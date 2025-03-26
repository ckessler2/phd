# Check if counterexample violates p1 and/or p2
# It should violate property 1 but it doesn't
import onnxruntime as ort
import numpy as np

def verify_properties(counterexample):

    # counterexample = np.float32([ 5.0e-4, 0.534515, 0.396457, 0.0, 0.33818, 0.284731, 0.0, 0.0, 0.534515, 0.396457, 0.0, 0.33818, 0.284731, 0.0 ])
    
    ort_sess = ort.InferenceSession("base_model_merged.onnx")
    y = ort_sess.run(None, {'x': (np.expand_dims(counterexample, axis=0))})
    print("[ex, ex2] = " + str(y[0][0]))
    print("ex - ex2 = " + str(y[0][0][0] - y[0][0][1]))
    
    if y[0][0][0] <= y[0][0][1] + 0.01:
        print("Property 1 not violated")
    else:
        print("Property 1 violated")
    
    if y[0][0][1] <= 0.01:
        print("Property 2 not violated")
    else:
        print("Property 2 violated")