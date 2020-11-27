import tensorflow as tf
import numpy as np

__all__ = ['l2_loss',
    'l1_loss',
    'edges_loss',
    
    ]


def l2_loss(image, reference):
  with tf.variable_scope('l2_loss'):
    return tf.reduce_mean(tf.squared_difference(image, reference))
    
def l1_loss(image, reference):
  with tf.variable_scope('l1_loss'):
    return tf.reduce_mean(tf.abs(image - reference))
    


def sobel_edges(input):
    '''
    find the edges of the input image, using the bulit-in tf function

    Params: 
        -input : tensor of shape [batch, height, width, channels]
    return:
        -tensor of the edges: [batch, height, width, channels]
    '''
    # transpose the image shape into [batch, h, w, d] to meet the requirement of tf.image.sobel_edges
    # img = tf.squeeze(tf.transpose(input, perm=[0,2,3,1,4]), axis=-1) 
    
    # the last dim holds the dx and dy results respectively
    edges_xy = tf.image.sobel_edges(input)
    #edges = tf.sqrt(tf.reduce_sum(tf.square(edges_xy), axis=-1))
    return edges_xy

def edges_loss(image, reference):
    '''
    params: 
        -image : tensor of shape [batch, depth, height, width, channels], the output of DVSR
        -reference : same shape as the image
    '''
    with tf.variable_scope('edges_loss'):
        edges_sr = sobel_edges(image)
        edges_hr = sobel_edges(reference)
        
        #return tf.reduce_mean(tf.abs(edges_sr - edges_hr))
        return l2_loss(edges_sr, edges_hr)
