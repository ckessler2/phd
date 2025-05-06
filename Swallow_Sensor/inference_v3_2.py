import onnxruntime as ort
import numpy as np
from Train_Classification_NN_v3 import load_data
from sklearn.metrics import confusion_matrix
import seaborn as sns  # For a nicer graphical representation
import matplotlib.pyplot as plt

data_directory = 'A:/data'
# data_directory = 'F:\matlab_stuff\phd\Swallow_Sensor\Dataset_2'
(trainX, trainy), (testX, testy) = load_data(data_directory)

ort_sess = ort.InferenceSession("NN_Classifier_dataset2_0.onnx")
nny_train = []
n = len(trainy)

# # Training dataset
# nny_train = []
# n = len(trainy)
# for i in range(n):
#     x1 = np.expand_dims((np.float32(trainX[i])), axis=0)
#     y = ort_sess.run(None, {'input': x1})
#     nny_train.append(np.argmax(y))
    
# # trainy = np.where(trainy > 0, 1, trainy)

# cm = confusion_matrix(trainy[0:n], nny_train)
# plt.figure(figsize=(10, 7))
# sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', cbar=False)  # 'd' means decimal format
# plt.xlabel('Predicted labels')
# plt.ylabel('True labels')
# plt.title('Confusion Matrix (Training Data)')
# plt.show()

nny_test = []
n = len(testy)

# Test dataset
for i in range(n):
    x1 = np.expand_dims((np.float32(testX[i])), axis=0)
    y = ort_sess.run(None, {'input': x1})
    nny_test.append(np.argmax(y))

# testy = np.where(testy > 0, 1, testy)

cm2 = confusion_matrix(testy[0:n], nny_test)
plt.figure(figsize=(10, 7))
sns.heatmap(cm2, annot=True, fmt='d', cmap='Blues', cbar=False)  # 'd' means decimal format
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix (Test Data)')
plt.show()

acc_test = 100 * (np.sum(np.diag(cm2)) / np.sum(cm2))

# acc_train = 100 * (np.sum(np.diag(cm)) / np.sum(cm))

print("acc test = " + str(round(acc_test, 2)))
# print("acc train = " + str(round(acc_train, 2)))

print("total correct = " + str(np.sum(np.diag(cm2))))