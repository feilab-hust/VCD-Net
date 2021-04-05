## The model quantization code is mostly from https://medium.com/@fanzongshaoxing/post-training-quantization-of-tensorflow-model-to-fp16-8d66b9dfa77f

import tensorflow as tf
from tensorflow.core.framework import types_pb2, graph_pb2, attr_value_pb2
from tensorflow.tools.graph_transforms import TransformGraph
from google.protobuf import text_format
import numpy as np

__all__ = ['save_graph_as_pb',
    'load_graph',
    'convert_graph_to_fp16',
    ]

def save_graph_as_pb(sess, output_node_names, output_graph_file, verbose=False):
    """Save the graph to a Protocal Buffer file
    Params:
        sess: tf.Session
        output_node_names: string, name(s) of the output node(s), comma seperated.
        output_graph_file: string, the path of the pb file to be written.
    """

    from tensorflow.python.framework import graph_util
    from tensorflow.python.platform import gfile

    if verbose:
        for op in sess.graph.get_operations():
            print(op.name)

    output_graph_def = graph_util.convert_variables_to_constants(
        sess=sess,
        input_graph_def=sess.graph_def,
        output_node_names=output_node_names.replace(" ", "").split(",") ) 

    with gfile.GFile(output_graph_file, "wb") as f:
        f.write(output_graph_def.SerializeToString())




def load_graph(model_path, import_name="", verbose=False):
    graph = tf.Graph()
    with graph.as_default():
        graph_def = tf.GraphDef()
        if model_path.endswith("pb"):
            with open(model_path, "rb") as f:
                graph_def.ParseFromString(f.read())
        else:
            with open(model_path, "r") as pf:
                text_format.Parse(pf.read(), graph_def)
        tf.import_graph_def(graph_def, name=import_name)
        sess = tf.Session(graph=graph)

        if verbose:
            for op in sess.graph.get_operations():
                print(op.name)
                
        print('load %s successfully' % model_path)
        return sess

def rewrite_batch_norm_node_v2(node, graph_def, target_type='fp16'):
    """
    Rewrite FusedBatchNorm with FusedBatchNormV2 for reserve_space_1 and reserve_space_2 in FusedBatchNorm require float32 for 
    gradient calculation (See here: https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/fused-batch-norm)
    """
    if target_type == 'fp16':
        dtype = types_pb2.DT_HALF
    elif target_type == 'fp64':
        dtype = types_pb2.DT_DOUBLE
    else:
        dtype = types_pb2.DT_FLOAT
    new_node = graph_def.node.add()
    new_node.op = "FusedBatchNormV2"
    new_node.name = node.name
    new_node.input.extend(node.input)
    new_node.attr["U"].CopyFrom(attr_value_pb2.AttrValue(type=types_pb2.DT_FLOAT))
    for attr in list(node.attr.keys()):
        if attr == "T":
            node.attr[attr].type = dtype
        new_node.attr[attr].CopyFrom(node.attr[attr])
    print("rewrite fused_batch_norm done!")

def convert_graph_to_fp16(model_path, save_path, name, as_text=False, target_type='fp16', input_name=None, output_names=None, keep_fp32_node_name=None):
    if target_type == 'fp16':
        dtype = types_pb2.DT_HALF
    elif target_type == 'fp64':
        dtype = types_pb2.DT_DOUBLE
    else:
        dtype = types_pb2.DT_FLOAT
    
    keep_fp32_node_name = [] if keep_fp32_node_name is None else keep_fp32_node_name

    source_sess = load_graph(model_path)
    source_graph_def = source_sess.graph.as_graph_def()
    target_graph_def = graph_pb2.GraphDef()
    target_graph_def.versions.CopyFrom(source_graph_def.versions)
    for node in source_graph_def.node:
        # fused batch norm node
        if node.op == "FusedBatchNorm":
            rewrite_batch_norm_node_v2(node, target_graph_def, target_type=target_type)
            continue
        # replicate node
        new_node = target_graph_def.node.add()
        new_node.op = node.op
        new_node.name = node.name
        new_node.input.extend(node.input)
        attrs = list(node.attr.keys())
        # keep batch norm params node
        if ("BatchNorm" in node.name) or ('batch_normalization' in node.name):
            for attr in attrs:
                new_node.attr[attr].CopyFrom(node.attr[attr])
            continue
        # replace dtype in node attr with target dtype
        for attr in attrs:
            # keep special node in fp32
            if node.name in keep_fp32_node_name:
                new_node.attr[attr].CopyFrom(node.attr[attr])
                continue
            if node.attr[attr].type == types_pb2.DT_FLOAT:
                # modify node dtype
                node.attr[attr].type = dtype
            if attr == "value":
                tensor = node.attr[attr].tensor
                if tensor.dtype == types_pb2.DT_FLOAT:
                    # if float_val exists
                    if tensor.float_val:
                        float_val = tf.make_ndarray(node.attr[attr].tensor)
                        new_node.attr[attr].tensor.CopyFrom(tf.make_tensor_proto(float_val, dtype=dtype))
                        continue
                    # if tensor content exists
                    if tensor.tensor_content:
                        tensor_shape = [x.size for x in tensor.tensor_shape.dim]
                        tensor_weights = tf.make_ndarray(tensor)
                        # reshape tensor
                        tensor_weights = np.reshape(tensor_weights, tensor_shape)
                        tensor_proto = tf.make_tensor_proto(tensor_weights, dtype=dtype)
                        new_node.attr[attr].tensor.CopyFrom(tensor_proto)
                        continue
            new_node.attr[attr].CopyFrom(node.attr[attr])
    # transform graph
    if output_names:
        if not input_name:
            input_name = []
        transforms = ["strip_unused_nodes"]
        target_graph_def = TransformGraph(target_graph_def, input_name, output_names, transforms)
    # write graph_def to model
    tf.io.write_graph(target_graph_def, logdir=save_path, name=name, as_text=as_text)
    print("Converting the model to half-precision done ...")
    print("Saved as %s" % save_path + name)


if __name__ == "__main__":
    model_path = 'pb/whole+half_brain_training_hr_shallow_region_8bit_step1um_2stage_dbpn+rdn_factor4_mse.pb'
    save_path = "pb"
    name = "test.pb"
    as_text = False
    target_type = 'fp16'

    input_name = "Placeholder"
    output_names = ["net_s2/out/Tanh"]
    # Const should be float32 in object detection api during nms (see here: https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/non-max-suppression-v4.html)
    keep_fp32_node_name = ["Postprocessor/BatchMultiClassNonMaxSuppression/MultiClassNonMaxSuppression/non_max_suppression/iou_threshold",
                        "Postprocessor/BatchMultiClassNonMaxSuppression/MultiClassNonMaxSuppression/non_max_suppression/score_threshold"]



    convert_graph_to_fp16(model_path, save_path, name, as_text=as_text, target_type=target_type, input_name=input_name, output_names=output_names)
    sess = load_graph(save_path+"/"+name)
