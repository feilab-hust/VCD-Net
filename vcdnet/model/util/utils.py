import tensorflow as tf
import numpy as np
import tensorlayer as tl
# from tensorlayer.layers import InputLayer, Conv2d, Conv3dLayer, UpSampling2dLayer, SubpixelConv2d, ElementwiseLayer, BatchNormLayer, ConcatLayer
from tensorlayer.layers import *
from .custom import *
from tensorlayer.layers import Layer




#w_init = tf.random_normal_initializer(stddev=0.02)
w_init = tf.glorot_uniform_initializer
b_init = None #tf.constant_initializer(value=0.0)
g_init = tf.random_normal_initializer(1., 0.02)


def conv2d(layer, n_filter, filter_size=3, stride=1, act=tf.identity, W_init=w_init, b_init=b_init, name = 'conv2d'):
    return tl.layers.Conv2d(layer, n_filter=int(n_filter), filter_size=(filter_size, filter_size), strides=(stride, stride), act=act, padding='SAME', W_init=W_init, b_init=b_init, name=name)
        
def conv3d(layer, 
    act=tf.identity, 
    filter_shape=(2,2,2,3,32),  #Shape of the filters: (filter_depth, filter_height, filter_width, in_channels, out_channels)
    strides=(1, 1, 1, 1, 1), W_init=w_init, b_init=b_init, name='conv3d'): 
    
    return tl.layers.Conv3dLayer(layer, act=act, shape=filter_shape, strides=strides, padding='SAME', W_init=W_init, b_init=b_init, W_init_args=None, b_init_args=None, name=name)

def max_pool2d(layer, filter_size=2, stride=2, name='pooling3d'):
    return MaxPool2d(layer, filter_size=(filter_size, filter_size), strides=(stride, stride), name=name)


def deconv2d(layer, out_channels, filter_size=3, stride=2, out_size=None, act=tf.identity, padding='SAME', W_init=w_init, b_init=b_init, name='deconv2d'):
    """
    up-sampling the layer in height and width by factor 2
    Parames:
        shape - shape of filter : [height, width, out_channels, in_channels]
        out_size : height and width of the outputs 
    """
    batch, h, w, in_channels = layer.outputs.get_shape().as_list()   
    filter_shape = (filter_size, filter_size, int(out_channels), int(in_channels))
    if out_size is None:
        output_shape = (batch, int(h * stride), int(w * stride), int(out_channels))
    else :
        output_shape = (batch, out_size[0], out_size[1], int(out_channels))
    strides = (1, stride, stride, 1)
    return tl.layers.DeConv2dLayer(layer, act=act, shape=filter_shape, output_shape=output_shape, strides=strides, padding=padding, W_init=W_init, b_init=b_init, W_init_args=None, b_init_args=None, name=name)

def atrous2d(layer, out_channels, filter_size, rate, act=tf.identity, padding='VALID', name='atrous2d'):
    return tl.layers.AtrousConv2dLayer(
                 prev_layer=layer,
                 n_filter=out_channels,
                 filter_size=(filter_size, filter_size),
                 rate=rate,
                 act=act,
                 padding=padding,
                 W_init=tf.truncated_normal_initializer(stddev=0.02),
                 b_init=tf.constant_initializer(value=0.0),
                 W_init_args=None,
                 b_init_args=None,
                 name=name)

def merge(layers, name='merge'):
    '''
    merge two Layers by element-wise addition
    Params : 
        -layers : list of Layer instances to be merged : [layer1, layer2, ...]
    '''
    return tl.layers.ElementwiseLayer(layers, combine_fn=tf.add, name=name)

def concat(layers, name):
    return ConcatLayer(layers, concat_dim=-1, name=name)    

def batch_norm(layer, act=tf.identity, is_train=True, gamma_init=g_init, name='bn'): 
    return tl.layers.BatchNormLayer(layer, act=act, is_train=is_train, gamma_init=gamma_init, name=name)
    
class PadDepth(Layer):
    
    def __init__(self, layer=None, name='padding',desired_channels=0):
        Layer.__init__(self, name=name)
        self.inputs = layer.outputs
        self.desired_channels=desired_channels
        
        with tf.variable_scope(name):
            self.outputs = self.pad_depth(self.inputs,self.desired_channels)
        self.all_layers = list(layer.all_layers)
        self.all_params = list(layer.all_params)
        self.all_drop = dict(layer.all_drop)
        self.all_layers.extend( [self.outputs] )
        
    def pad_depth(self, x , desired_channels):
        y = tf.zeros_like(x)
        print(y.shape)
        new_channels = desired_channels - x.shape.as_list()[-1]
        y = y[...,:new_channels]
        
        #y=tf.to_int32(y, name='ToInt32')
        #x=tf.to_int32(x, name='ToInt32')
        print(x.shape,y.shape)
        return tf.concat([x,y],axis=-1)                              


 
def upconv(layer, out_channels, out_size, filter_size=3, name='upconv'):
    with tf.variable_scope(name):
        n = tl.layers.UpSampling2dLayer(layer, size=out_size, is_scale=False, method=1, name = 'upsampling')
        '''
        - Index 0 is ResizeMethod.BILINEAR, Bilinear interpolation.
        - Index 1 is ResizeMethod.NEAREST_NEIGHBOR, Nearest neighbor interpolation.
        - Index 2 is ResizeMethod.BICUBIC, Bicubic interpolation.
        - Index 3 ResizeMethod.AREA, Area interpolation.
        '''
        n = conv2d(n, n_filter=out_channels, filter_size=filter_size, name='conv')
        return n