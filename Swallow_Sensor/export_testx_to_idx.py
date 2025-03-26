
import idx2numpy
import numpy as np

testX = np.load("testX.npy")
testy = np.load("testY.npy")

testX = np.float32(testX.squeeze()/255)

testX = testX[1]
testy = testy[1]

testX = np.expand_dims(testX, axis=0)
testy = np.expand_dims(testy, axis=0)


idx2numpy.convert_to_file('testX.idx', testX)
idx2numpy.convert_to_file('testY.idx', testy)
