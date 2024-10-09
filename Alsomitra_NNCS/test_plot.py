from pandas import read_csv
import tensorflow as tf
from keras.models import Sequential
from keras.layers import Dense, Lambda
from keras.utils import plot_model

from tensorflow.keras.layers import Input, Concatenate
from tensorflow.keras.models import Model

from sklearn.model_selection import train_test_split
import onnx
import tf2onnx
import tensorflow.keras.backend as K
import numpy as np
import pydot_ng

# Define the input layer that accepts the whole dataset
input_layer = Input(shape=(7,), name='full_input')

# Use Lambda layers to split the input
# Primary input part (the first 5 columns)
primary_input = Lambda(lambda x: x[:, :5])(input_layer)

# Dummy input part (6th and 7th columns - though not used further in this configuration)
dummy_input = Lambda(lambda x: x[:, 5:])(input_layer)  # Not connected for training impact
# This variable is for architectural completeness in example and does not influence the network's training/output.

# Main network pathway for the primary input
x = Dense(10, activation='sigmoid')(primary_input)
x = Dense(10, activation='sigmoid')(x)
x = Dense(3, activation='sigmoid')(x)
main_output = Dense(1, activation='sigmoid')(x)

# Create the model
model = Model(inputs=input_layer, outputs=main_output)

dot_img_file = 'model_1.png'
plot_model(model, to_file=dot_img_file, show_shapes=True)