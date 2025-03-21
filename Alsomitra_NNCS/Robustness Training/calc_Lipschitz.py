#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 20 14:45:00 2025

@author: ck2049
"""

import onnx
from onnx2keras import onnx_to_keras
import numpy as np

# Load ONNX model
onnx_model1 = onnx.load('base_model_norm.onnx')
onnx_model2 = onnx.load('adversarial_model_0.001.onnx')
k_model1 = onnx_to_keras(onnx_model1,['x'], name_policy='short')
k_model2 = onnx_to_keras(onnx_model2,['x'], name_policy='short')

onnx_model3 = onnx.load('base_model_merged.onnx')
k_model3 = onnx_to_keras(onnx_model3,['x'], name_policy='short')

counterexample = [ 1.0e-5, 0.954176, 0.0, 1.0, 0.54999, 1.0, 0.0, 0.0, 0.954176, 0.0, 1.0, 0.54999, 1.0, 0.0 ]

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


y5 = k_model3.predict(np.expand_dims(counterexample, axis=0))
L2 = abs(y5.flat[0]-y5.flat[1])/(eps)
print("L (base model merged) = " + str(L2))