# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 12:15:02 2025

@author: Colin Kessler
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc

import tensorflow as tf

# Load model - should be onnx but I couldn't get it to work
model = tf.keras.models.load_model('Swallow_NN_Classifier.keras')

testX = np.load("testX.npy")
testy = np.load("testY.npy")

trainX = np.load("trainX.npy")
trainy = np.load("trainY.npy")


probabilities = model.predict(testX)
# probabilities = model.predict(trainX)

# Extract probabilities for the positive class (class 1)
positive_class_probabilities = probabilities[:, 1]

# Calculate ROC curve and AUC 
fpr, tpr, thresholds = roc_curve(testy, positive_class_probabilities)
roc_auc = auc(fpr, tpr)

# Plot ROC curve
tfont = {'fontname':'Times New Roman'} 


plt.figure
plt.plot([0, 1], [0, 1], color='black', lw=2, label='Random classifier')
plt.plot(fpr, tpr, color='orange', lw=2, label='NN classifier \n(area = %0.2f)' % roc_auc)
plt.plot([0,1], [1,1], color='black', lw=2, linestyle=':', label='Perfect classifier')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC',**tfont)
plt.legend(loc="lower right")
ax = plt.gca()
ax.set_aspect('equal', adjustable='box')
plt.show()