# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 11:58:17 2025

@author: Colin Kessler
"""

from tensorflow.keras.models import Sequential

# importing various types of hidden layers
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten

# Adam optimizer for better LR and less loss
from tensorflow.keras.optimizers import Adam
import matplotlib.pyplot as plt
import numpy as np

import os
import numpy as np
from PIL import Image
from sklearn.model_selection import train_test_split

import tensorflow as tf
import onnx
import tf2onnx


def load_data(data_dir, test_size=0.2):
    # Initialize lists to hold the images and labels
    images = []
    labels = []

    # Loop through each class directory
    for label, class_dir in enumerate(['Other', 'Swallow']):
        # Get the path to the class directory
        class_path = os.path.join(data_dir, class_dir)
        
        # List all image files in the directory
        for image_file in os.listdir(class_path):
            # Load the image file
            image_path = os.path.join(class_path, image_file)
            image = Image.open(image_path)
            
            # Convert image to grayscale if needed and resize it
            image = image.convert('L')  # 'L' mode is for grayscale
            image = image.resize((28, 28))  # Ensuring size is 28x28
            
            # Convert image data to numpy array
            image_array = np.array(image, dtype=np.uint8)
            
            # Append the image and label to lists
            images.append(image_array)
            labels.append(label)

    # Convert lists to numpy arrays
    images_array = np.array(images, dtype=np.uint8)
    labels_array = np.array(labels, dtype=np.uint8)

    # Reshape images_array to the required format (n, 28, 28, 1)
    images_array = np.expand_dims(images_array, axis=-1)
    
    # Split the dataset into training and testing sets
    trainX, testX, trainy, testy = train_test_split(images_array, labels_array, test_size=test_size, random_state=42)
    
    return (trainX, trainy), (testX, testy)

# # Split the data into training and testing
# (trainX, trainy), (testX, testy) = fashion_mnist.load_data()
data_directory = 'F:\matlab_stuff\phd\Swallow_Sensor\Dataset_1'
(trainX, trainy), (testX, testy) = load_data(data_directory)

# repeat_factor = 2

# # Repeating the features and labels
# trainX = np.repeat(trainX, repeat_factor, axis=0)
# trainy = np.repeat(trainy, repeat_factor, axis=0)

 
# # Print the dimensions of the dataset
print('Train: X = ', trainX.shape)
print('Test: X = ', testX.shape)

for i in range(1, 10):
    # Create a 3x3 grid and place the
    # image in ith position of grid
    plt.subplot(3, 3, i)
    # Insert ith image with the color map 'grap'
    plt.imshow(trainX[i], cmap=plt.get_cmap('gray'))
 
# # Display the entire plot
plt.show()

# trainX = np.expand_dims(trainX, -1)
# testX = np.expand_dims(testX, -1)
 
print(trainX.shape)


def model_arch():
    models = Sequential()
     
    # We are learning 64 
    # filters with a kernel size of 5x5
    models.add(Conv2D(64, (5, 5),
                      padding="same",
                      activation="relu", 
                      input_shape=(28, 28, 1)))
     
    # Max pooling will reduce the
    # size with a kernel size of 2x2
    models.add(MaxPooling2D(pool_size=(2, 2)))
    models.add(Conv2D(128, (5, 5), padding="same",
                      activation="relu"))
     
    models.add(MaxPooling2D(pool_size=(2, 2)))
    models.add(Conv2D(256, (5, 5), padding="same", 
                      activation="relu"))
     
    models.add(MaxPooling2D(pool_size=(2, 2)))
     
    # Once the convolutional and pooling 
    # operations are done the layer
    # is flattened and fully connected layers
    # are added
    models.add(Flatten())
    models.add(Dense(256, activation="relu"))
     
    # Finally as there are total 10
    # classes to be added a FCC layer of
    # 10 is created with a softmax activation
    # function
    models.add(Dense(2, activation="softmax"))
    return models

model = model_arch()
 
model.compile(optimizer=Adam(learning_rate=1e-4),
              loss='sparse_categorical_crossentropy',
              metrics=['sparse_categorical_accuracy'])
 
model.summary()

history = model.fit(
    trainX.astype(np.float32), trainy.astype(np.float32),
    epochs=20,
    steps_per_epoch=100,
    validation_split=0.2
)



# Accuracy vs Epoch plot
plt.plot(history.history['sparse_categorical_accuracy'])
plt.plot(history.history['val_sparse_categorical_accuracy'])
plt.title('Model Accuracy')
plt.ylabel('Accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'val'], loc='upper left')
plt.show()



# Loss vs Epoch plot
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model Accuracy')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'val'], loc='upper left')
plt.show()

predictions = model.predict(testX)
predicted_classes = np.argmax(predictions, axis=1)
accuracy = np.mean(predicted_classes == testy)
print(f'Accuracy: {accuracy * 100:.2f}%')

np.save("testX.npy",testX)
np.save("testY.npy",testy)

np.save("trainX.npy",trainX)
np.save("trainY.npy",trainy)

# Export network as onnx
# input_signature = [tf.TensorSpec([28,28,1], tf.uint8, name='x')]
onnx_model, _ = tf2onnx.convert.from_keras(model)

onnx.save(onnx_model, 'Swallow_NN_Classifier.onnx')

model.save("Swallow_NN_Classifier.keras")
