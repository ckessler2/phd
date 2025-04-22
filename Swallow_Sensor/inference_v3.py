import onnxruntime as ort
import numpy as np
from Train_Classification_NN_v3 import load_data
from sklearn.metrics import confusion_matrix
import seaborn as sns  # For a nicer graphical representation
import matplotlib.pyplot as plt

data_directory = 'C:/Users/ck2049/Desktop/Data_Files'
(trainX, trainy), (testX, testy) = load_data(data_directory)

ort_sess = ort.InferenceSession("NN_Classifier_dataset2.onnx")
nny_train = []
n = len(trainy)

# Training dataset
for i in range(n):
    x1 = np.expand_dims((np.float32(trainX[i])), axis=0)
    y = ort_sess.run(None, {'input': x1})
    nny_train.append(np.argmax(y))


cm = confusion_matrix(trainy[0:n],nny_train)
plt.figure(figsize=(10, 7))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', cbar=False)  # 'd' means decimal format
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix (Training Data)')
plt.show()

nny_test = []
n = len(testy)

# Test dataset
for i in range(n):
    x1 = np.expand_dims((np.float32(testX[i])), axis=0)
    y = ort_sess.run(None, {'input': x1})
    nny_test.append(np.argmax(y))


cm2 = confusion_matrix(testy[0:n],nny_test)
plt.figure(figsize=(10, 7))
sns.heatmap(cm2, annot=True, fmt='d', cmap='Blues', cbar=False)  # 'd' means decimal format
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix (Test Data)')
plt.show()

acc_test = 100 * round((cm2[0,0]+cm2[1,1]+cm2[2,2] + cm2[3,3])/sum(sum(cm2)),2)

acc_train = 100 * round((cm[0,0]+cm[1,1]+cm[2,2] + cm2[3,3])/sum(sum(cm)),2)

print("acc test = " + str(round(acc_test,2)))
print("acc train = " + str(round(acc_train,2)))