import tensorflow as tf
from tensorlayer.layers import Layer

class LReluLayer(Layer):
    
    def __init__(self, layer=None, alpha=0.2, name='leaky_relu'):
        Layer.__init__(self, name=name)
        self.inputs = layer.outputs
        
        with tf.variable_scope(name):
            self.outputs = tf.nn.leaky_relu(self.inputs, alpha=alpha)
        self.all_layers = list(layer.all_layers)
        self.all_params = list(layer.all_params)
        self.all_drop = dict(layer.all_drop)
        self.all_layers.extend( [self.outputs] )

class ReluLayer(Layer):
    
    def __init__(self, layer=None, name='relu'):
        Layer.__init__(self, name=name)
        self.inputs = layer.outputs
        
        with tf.variable_scope(name):
            self.outputs = tf.nn.relu(self.inputs)
        self.all_layers = list(layer.all_layers)
        self.all_params = list(layer.all_params)
        self.all_drop = dict(layer.all_drop)
        self.all_layers.extend( [self.outputs] )