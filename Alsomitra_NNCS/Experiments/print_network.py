

import onnx
from onnx import numpy_helper
onnx_model   = onnx.load("Alsomitra_Controller6.onnx")
INTIALIZERS  = onnx_model.graph.initializer
onnx_weights = {}
for initializer in INTIALIZERS:
    W = numpy_helper.to_array(initializer)
    onnx_weights[initializer.name] = W
    print(W)
    
