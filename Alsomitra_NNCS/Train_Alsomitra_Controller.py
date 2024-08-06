# Colin Kessler 4.8.2024 - colinkessler00@gmail.com
# Adapted from https://github.com/bnsreenu/python_for_microscopists/blob/master/141-regression_housing_example.py

from pandas import read_csv
import tensorflow as tf
from keras.models import Sequential
from keras.layers import Dense, Lambda
from sklearn.model_selection import train_test_split
import onnx
import tf2onnx
import tensorflow.keras.backend as K
import numpy as np

# load data and arrange into dataframe
df = read_csv("Training_Data_Scaled.csv", delim_whitespace=False, header=None)
df.columns = ['dv_xpdt', 'dv_ypdt', 'domegadt', 'dthetadt', 'dx_dt', 'dy_dt', 'error', 'e_x']

# Split by inputs and output (e_x), and into train/test datasets
X = df.drop('e_x', axis = 1)
y = df['e_x']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.1, random_state = 20)

# Define network layers
model = Sequential()
model.add(Dense(120, input_dim=7, activation='sigmoid'))
model.add(Dense(120, activation='sigmoid'))
model.add(Dense(1, activation='sigmoid'))
# model.add(Lambda(lambda x: (x * (0.193 - 0.181)) + 0.181))
model.output_names=['output'] 

# Define loss function (rmse)
def rmse(y_true, y_pred):
        return (K.sqrt(K.mean(K.square(y_pred - y_true)))) 

# Train network
opt = tf.keras.optimizers.Adamax(
    learning_rate=0.001)
model.compile(loss=rmse, optimizer=opt, metrics=['mse'])
model.summary()
history = model.fit(X_train, y_train, validation_split=0.1, epochs=1000, batch_size=25)

# Plot rmse against training epochs
from matplotlib import pyplot as plt
plt.rcParams['figure.dpi'] = 900
plt.rc('font', family='sans-serif') 
plt.rcParams["font.family"] = "Times New Roman"
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs = range(1, len(loss) + 1)
plt.plot(epochs, loss, "#721f81")
plt.title('Training Loss (RMSE)')
plt.xlabel('Epoch') 
plt.ylabel('RMSE')
plt.yscale('log')
plt.show()

# Compare to test data
predictions = model.predict(X_test[:5])
print("Predicted values are: ", predictions)
print("Real values are: ", y_test[:5])

# Export network as onnx
onnx_model, _ = tf2onnx.convert.from_keras(model)
onnx.save(onnx_model, 'Alsomitra_Controller.onnx')