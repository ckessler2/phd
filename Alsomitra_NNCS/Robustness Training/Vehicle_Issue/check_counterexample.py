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
onnx_model3 = onnx.load('base_model_merged.onnx')
k_model3 = onnx_to_keras(onnx_model3,['x'], name_policy='short')

# Property 1 counterexample from marabou
counterexample = [ 5.0e-4, 0.534515, 0.396457, 0.0, 0.33818, 0.284731, 0.0, 0.0, 0.534515, 0.396457, 0.0, 0.33818, 0.284731, 0.0 ]

# Property 2 counterexample from marabou
# counterexample = [ 0.0, 0.653285, 0.672391, 7.0226e-2, 0.0, 0.0, 0.0, 0.0, 0.653285, 0.672391, 7.0226e-2, 0.0, 0.0, 0.0 ]

x = np.float32(np.array(counterexample))

y = k_model3.predict(np.expand_dims(counterexample, axis=0))


print("[ex, ex2] = " + str(y[0]))

print("ex - ex2 = " + str(y[0][0] - y[0][1]))

if y[0][0] <= y[0][1] + 0.01:
    print("Property 1 not violated")
else:
    print("Property 1 violated")

if y[0][1] <= 0.01:
    print("Property 2 not violated")
else:
    print("Property 2 violated")