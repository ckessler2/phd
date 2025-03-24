#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 20 14:45:00 2025

@author: ck2049
"""

import onnx
from onnx2keras import onnx_to_keras
import numpy as np
import tensorflow as tf

# Load ONNX model
onnx_model1 = onnx.load('base_model_norm.onnx')
onnx_model2 = onnx.load('adversarial_model_0.001.onnx')
k_model1 = onnx_to_keras(onnx_model1,['x'], name_policy='short')
k_model2 = onnx_to_keras(onnx_model2,['x'], name_policy='short')

onnx_model3 = onnx.load('base_model_merged.onnx')
k_model3 = onnx_to_keras(onnx_model3,['x'], name_policy='short')

counterexample =[ 1.0e-5, 0.691386, 0.692117, 7.409e-2, 0.0, 0.0, 0.0, 0.0, 0.691386, 0.692117, 7.409e-2, 0.0, 0.0, 0.0 ]


# y5 = k_model3.predict(np.expand_dims(counterexample_vehicle, axis=0))

# generate_adversarial_example(k_model3, counterexample_vehicle, y5, 0.00005)


x = np.float32(np.array(counterexample))

x1 = x[0:7]
x2 = x[7:14]

# eps = max((abs(x1-x2))[0],(abs(x1-x2))[1],(abs(x1-x2))[2],(abs(x1-x2))[3])

eps = abs(x1-x2)[0]

print("Epsilon (dim 1) = " + str(eps))

y1 = k_model1.predict(np.expand_dims(x1, axis=0))
y2 = k_model1.predict(np.expand_dims(x2, axis=0))


L1 = abs(y2-y1)[0][0]/(eps)
print("L (base model) = " + str(L1))

y3 = k_model2.predict(np.expand_dims(x1, axis=0))
y4 = k_model2.predict(np.expand_dims(x2, axis=0))

L2 = abs(y3-y4)[0][0]/(eps)
print("L (adversarial model) = " + str(L2))

# Convert the numpy array to a TensorFlow tensor with appropriate dtype
x = np.float32(counterexample)

x_tensor = tf.Variable(x, dtype=tf.float32)

# Define epsilon as a variable this time
epsilon = 0.00005  # Adjust this value freely to test different intensities.
iterations = 100
learning_rate = 0.00001

def optimise_L(model, epsilon, iterations, learning_rate, x_tensor):
    optimizer = tf.optimizers.SGD(learning_rate)
    
    for i in range(iterations):
        with tf.GradientTape() as tape:
            tape.watch(x_tensor)
            x1, x2 = x_tensor[:7], x_tensor[7:14]
            
            # Enforcing x2 to be at most epsilon away from x1 during the iteration
            x2_adjusted = x1 + tf.clip_by_value(x2 - x1, -epsilon, epsilon)
            x_tensor.assign(tf.concat([x1, x2_adjusted], axis=0))
    
            y1 = model(x1[tf.newaxis, ...])
            y2 = model(x2_adjusted[tf.newaxis, ...])
    
            loss = -tf.abs(y1 - y2)  # Negate to maximize
    
        gradients = tape.gradient(loss, x_tensor)
        optimizer.apply_gradients([(gradients, x_tensor)])
    
    # Extract and verify
    x1_adv, x2_adv = x_tensor.numpy()[:7], x_tensor.numpy()[7:14]
    eps2 = np.max(np.abs(x1_adv - x2_adv))
    return x1_adv, x2_adv, eps2

x1_adv, x2_adv, eps2 = optimise_L(k_model1, epsilon, iterations, learning_rate, x_tensor)

y5 = k_model1.predict(np.expand_dims(x1_adv, axis=0))
y6 = k_model1.predict(np.expand_dims(x2_adv, axis=0))
L3 = abs(y5-y6)/eps2
print("SGD optimised L (base model) = " + str(L3[0][0]))

x3_adv, x4_adv, eps3 = optimise_L(k_model2, epsilon, iterations, learning_rate, x_tensor)

eps3 =  x3_adv[0] - x4_adv[0]
y7 = k_model2.predict(np.expand_dims(x3_adv, axis=0))
y8 = k_model2.predict(np.expand_dims(x4_adv, axis=0))
L4 = abs(y7-y8)/eps3
print("SGD optimised L (adversarial model) = " + str(L4[0][0]))

threshold = 100
simple_L = L3

if simple_L > threshold:
    print("Counterexample is valid (" + str(simple_L[0][0]) + " >= " + str(threshold) + ")")
else:
    print("Counterexample invalid (" + str(simple_L[0][0]) + " < " + str(threshold) + ")")


