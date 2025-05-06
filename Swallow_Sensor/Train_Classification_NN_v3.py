# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 11:58:17 2025

@author: Colin Kessler
adapted from https://www.geeksforgeeks.org/fashion-mnist-with-python-keras-and-deep-learning/
"""

from tensorflow.keras.models import Sequential
from sklearn.model_selection import KFold

# importing various types of hidden layers
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout

# Adam optimizer for better LR and less loss
 
import matplotlib.pyplot as plt
import os
import numpy as np
from PIL import Image
from sklearn.model_selection import train_test_split

import tensorflow as tf
import onnx
import tf2onnx
import keras

from adversarial_trainer import AdversarialTrainer 

# GPU setup

gpus = tf.config.experimental.list_physical_devices('GPU')



def load_data_old(data_dir, test_size=0.2):
    # Initialize lists to hold the images and labels
    images = []
    labels = []

    # Loop through each class directory
    for label, class_dir in enumerate(['Class0', 'Class1', 'Class2']):
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

def load_data(data_dir):
    # Initialize lists to hold the images and labels for both training and testing
    train_images = []
    train_labels = []
    test_images = []
    test_labels = []

    # Define the folder structure
    class_folders = [
        ('class0train', 'class0test'),
        ('class1train', 'class1test'),
        ('class2train', 'class2test'),
        ('class3train', 'class3test')
    ]
    
    # Function to load images from a specific folder
    def load_images_from_folder(folder, images_list, labels_list, label):
        folder_path = os.path.join(data_dir, folder)
        for image_file in os.listdir(folder_path):
            # Construct complete image path
            image_path = os.path.join(folder_path, image_file)
            # Load and process the image
            image = Image.open(image_path).convert('L').resize((28, 28))
            # Append image and label to respective lists
            images_list.append(np.array(image, dtype=np.uint8))
            labels_list.append(label)

    # Process each class folder pair
    for label, (train_folder, test_folder) in enumerate(class_folders):
        # Load training images and labels
        load_images_from_folder(train_folder, train_images, train_labels, label)
        # Load testing images and labels
        load_images_from_folder(test_folder, test_images, test_labels, label)

    # Convert lists to numpy arrays
    trainX = np.array(train_images, dtype=np.uint8).reshape(-1, 28, 28, 1)
    trainy = np.array(train_labels, dtype=np.uint8)
    testX = np.array(test_images, dtype=np.uint8).reshape(-1, 28, 28, 1)
    testy = np.array(test_labels, dtype=np.uint8)
    
    shuffle = np.random.permutation(len(trainX))
    trainX = trainX[shuffle]
    trainy = trainy[shuffle]

    return (trainX, trainy), (testX, testy)

def load_data_2(data_dir):
    # Initialize lists to hold the images and labels for both training and testing
    train_images = []
    train_labels = []
    test_images = []
    test_labels = []

    # Define the folder structure
    class_folders = [
        ('class0train', 'class0test'), # No swallow
        ('class1train', 'class1test'), # Blank swallow
        ('class2train', 'class2test'), # Water
        ('class3train', 'class3test')  # Food
    ]
    
    # Function to load images from a specific folder
    def load_images_from_folder(folder, images_list, labels_list, label):
        folder_path = os.path.join(data_dir, folder)
        for image_file in os.listdir(folder_path):
            # Construct complete image path
            image_path = os.path.join(folder_path, image_file)
            # Load and process the image
            image = Image.open(image_path).convert('L').resize((28, 28))
            # Append image and label to respective lists
            images_list.append(np.array(image, dtype=np.uint8))
            labels_list.append(label)

    # Process each class folder pair
    for index, (train_folder, test_folder) in enumerate(class_folders):
        if index == 0:
            # No Swallow (Class 1)
            new_label = 0  # Label for 'no swallow'
        else:
            # Swallow (Classes 2, 3, 4 grouped as Class 2)
            new_label = 1  # Label for 'swallow' (grouped classes)

        # Load training images and labels with the new label scheme
        load_images_from_folder(train_folder, train_images, train_labels, new_label)
        # Load testing images and labels with the new label scheme
        load_images_from_folder(test_folder, test_images, test_labels, new_label)

    # Convert lists to numpy arrays for neural network compatibility
    trainX = np.array(train_images).reshape(-1, 28, 28, 1)
    trainy = np.array(train_labels)
    testX = np.array(test_images).reshape(-1, 28, 28, 1)
    testy = np.array(test_labels)
    
    shuffle = np.random.permutation(len(trainX))
    trainX = trainX[shuffle]
    trainy = trainy[shuffle]

    return (trainX, trainy), (testX, testy)

def load_data_3(data_dir):
    # Initialize lists to hold the images and labels for both training and testing
    train_images = []
    train_labels = []
    test_images = []
    test_labels = []

    # Define the folder structure excluding class 0
    class_folders = [
        ('class1train', 'class1test'),  # Remapped to class 0
        ('class2train', 'class2test'),  # Remapped to class 1
        ('class3train', 'class3test')   # Remapped to class 2
    ]
    
    # Function to load images from a specific folder
    def load_images_from_folder(folder, images_list, labels_list, label):
        folder_path = os.path.join(data_dir, folder)
        for image_file in os.listdir(folder_path):
            # Construct complete image path
            image_path = os.path.join(folder_path, image_file)
            # Load and process the image
            image = Image.open(image_path).convert('L').resize((28, 28))
            # Append image and label to respective lists
            images_list.append(np.array(image, dtype=np.uint8))
            # Subtract 1 from the original label to remap 1, 2, 3 to 0, 1, 2
            labels_list.append(label - 1)

    # Process each class folder pair
    for index, (train_folder, test_folder) in enumerate(class_folders, start=1):
        # Load training images and labels with labels remapped from 1,2,3 to 0,1,2
        load_images_from_folder(train_folder, train_images, train_labels, index)
        # Load testing images and labels similarly
        load_images_from_folder(test_folder, test_images, test_labels, index)

    # Convert lists to numpy arrays
    trainX = np.array(train_images, dtype=np.uint8).reshape(-1, 28, 28, 1)
    trainy = np.array(train_labels, dtype=np.uint8)
    testX = np.array(test_images, dtype=np.uint8).reshape(-1, 28, 28, 1)
    testy = np.array(test_labels, dtype=np.uint8)
    
    shuffle = np.random.permutation(len(trainX))
    trainX = trainX[shuffle]
    trainy = trainy[shuffle]

    return (trainX, trainy), (testX, testy)

# # Use the modified load_data function
# data_dir = 'path_to_your_data_directory_here'
# (trainX, trainy), (testX, testy) = load_data(data_dir)

def model_arch():
    models = Sequential()
     
    # We are learning 64 
    # filters with a kernel size of 5x5
    models.add(Conv2D(64, (5, 5),
                      padding="same",
                      activation="relu", 
                      input_shape=(28, 28, 1)))
    
    
    models.add(MaxPooling2D(pool_size=(2, 2)))
    # Dropout(0.1),  # Dropout layer after max pooling
    models.add(Conv2D(64, (5, 5), padding="same",
                      activation="relu"))
    
    models.add(MaxPooling2D(pool_size=(2, 2)))
    # Dropout(0.1),  # Dropout layer after max pooling
    models.add(Conv2D(64, (5, 5), padding="same",
                      activation="relu"))
    
    
    models.add(MaxPooling2D(pool_size=(2, 2)))
    # Dropout(0.25),  # Dropout layer after max pooling
    models.add(Conv2D(16, (5, 5), padding="same",
                      activation="relu"))
    
    
     
    models.add(MaxPooling2D(pool_size=(2, 2)))
    
    # Dropout(0.25),  # Dropout layer after max pooling
     
    # Once the convolutional and pooling 
    # operations are done the layer
    # is flattened and fully connected layers
    # are added
    models.add(Flatten())
    models.add(Dense(8, activation="relu"))
     
    # Finally as there are total 10
    # classes to be added a FCC layer of
    # 10 is created with a softmax activation
    # function
    # models.add(Dense(4, activation="sigmoid"))
    
    models.add(Dense(2, activation="sigmoid"))
    return models


if __name__ == "__main__":
    # # Split the data into training and 2testing
    # (trainX, trainy), (testX, testy) = fashion_mnist.load_data()
    data_directory = 'A:/data'
    # data_directory = 'F:\matlab_stuff\phd\Swallow_Sensor\Dataset_2'
    (trainX, trainy), (testX, testy) = load_data_2(data_directory)
        
    epsilon = 0.0005
    epochs = 50
    batch_size = 100
    adversarial_train = False
    
    # 1k epochs, 1e-5 gets 69.55 accuracy
    
    # repeat_factor = 2
    
    # # Repeating the features and labels
    # trainX = np.repeat(trainX, repeat_factor, axis=0)
    # trainy = np.repeat(trainy, repeat_factor, axis=0)
    
     
    # # Print the dimensions of the dataset
    print('Train: X = ', trainX.shape)
    print('Test: X = ', testX.shape)
    
    # Values to find:
    values_to_find = [0, 1, 2, 3]
    titles = ['No Swallow', 'Blank Swallow', 'Water Swallow', 'Food Swallow']
    
    # # Dictionary to store results:
    # indexes = {}
    
    # for value in values_to_find:
    #     match = np.where(trainy == value)[0]
    #     indexes[value] = match[0] if match.size > 0 else None
    
    # for i in range(1, 5):
    #     # Create a 3x3 grid and place the
    #     # image in ith position of grid
    #     plt.subplot(1, 4, i)
    #     # Insert ith image with the color map 'grap'
    #     plt.imshow(trainX[indexes[i-1]], cmap=plt.get_cmap('gray'))
    #     plt.title(titles[i-1], fontdict={'fontname':'Times New Roman', 'fontsize':12})
    #     plt.tick_params(axis='both',          # Changes apply to both x and y axis
    #             which='both',         # both major and minor ticks are affected
    #             bottom=False,         # ticks along the bottom edge are off
    #             top=False,            # ticks along the top edge are off
    #             left=False,           # ticks along the left edge are off
    #             right=False,          # ticks along the right edge are off
    #             labelbottom=False,    # labels along the bottom edge are off
    #             labeltop=False,       # labels along the top edge are off
    #             labelleft=False,      # labels along the left edge are off
    #             labelright=False)     # labels along the right edge are off
     
    # # # Display the entire plot
    # plt.savefig('example_images.png',  dpi=1200, bbox_inches='tight')
    # plt.show()
    
    # trainX = np.expand_dims(trainX, -1)
    # testX = np.expand_dims(testX, -1)
     
    print(trainX.shape)
    
    model = model_arch()
     
    # 1e-4 for normal, 3e-4 for 2?
    model.compile(optimizer=keras.optimizers.Adam(learning_rate=1.5e-5),
                   # loss='sparse_categorical_crossentropy',
                   loss=keras.losses.SparseCategoricalCrossentropy(reduction="sum_over_batch_size"),
                  # loss='categorical_crossentropy',
                  # loss=tf.keras.losses.CategoricalCrossentropy(from_logits=True),
                  metrics=['sparse_categorical_accuracy'])
     
    model.summary()
    
    # Dataset is imbalanced, so NN will tend to ignore class 2 (has the least datapoints)
    # To solve this, I weight each classes inversely to the number of instances in trainy
    # class_weights = {0: 1.0, 1: 1.19, 2: 1.81, 3: 1.61}
    class_weights = {0: 2.0, 1: 1.0}
    # class_weights = {0: 1.0, 1: 1.52, 2: 1.36}


    history = model.fit(
            trainX.astype(np.float32), trainy.astype(np.float32),
            epochs=epochs,
            steps_per_epoch=25,
            validation_split=0.1,
            class_weight = class_weights
        )
    
    # # Accuracy vs Epoch plot
    plt.plot(history.history['sparse_categorical_accuracy'])
    plt.plot(history.history['val_sparse_categorical_accuracy'])
    plt.title('Model Accuracy')
    plt.ylabel('Accuracy')
    plt.xlabel('epoch')
    plt.legend(['train', 'val'], loc='upper left')
    plt.ylim(0,1)
    plt.show()
    
    
    
    # Loss vs Epoch plot
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('Model Loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'val'], loc='upper left')
    plt.yscale('log')
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
    
    model.output_names=['output']
    input_signature = [tf.TensorSpec([None, 28, 28, 1], tf.float32, name='input')]
    
    onnx_model, _ = tf2onnx.convert.from_keras(model, input_signature, opset=13)
    
    # onnx_model, _ = tf2onnx.convert.from_keras(model)
    
    
    onnx.save(onnx_model, 'NN_Classifier_dataset2_1.onnx')
    
    # model.save("Swallow_NN_Classifier.keras")
    
    
    
    # import inference_v3_2
    import inference_v3
    a = 1