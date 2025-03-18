# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 12:15:02 2025

@author: Colin Kessler
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc

import tensorflow as tf

# Load your ONNX model
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
plt.figure()
plt.plot(fpr, tpr, color='darkorange', lw=2, label='ROC curve (area = %0.2f)' % roc_auc)
plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC (Validation Data)')
plt.legend(loc="lower right")
plt.show()