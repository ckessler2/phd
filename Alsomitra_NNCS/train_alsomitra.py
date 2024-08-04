# Adapted from https://github.com/bnsreenu/python_for_microscopists/blob/master/141-regression_housing_example.py

from pandas import read_csv
# import keras
import tensorflow as tf
from keras.models import Sequential
from keras.layers import Dense, Lambda
# from keras.initializers import HeNormal
# initializer = HeNormal()
# from keras.regularizers import l2
# from keras.wrappers.scikit_learn import KerasRegressor
# from sklearn.model_selection import cross_val_score
# from sklearn.model_selection import KFold
# from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
import onnx
# from onnxconverter_common import convert_float_to_float16
import tf2onnx
import tensorflow.keras.backend as K

# load data and arrange into Pandas dataframe
df = read_csv("data_100.csv", delim_whitespace=False, header=None)


feature_names = ['a','b','c','d','e','f','g','h']


df.columns = feature_names
print(df.head())

df = df.rename(columns={'h': 'e_x'})
print(df.describe())

def rmse(y_true, y_pred):
        return (100*K.sqrt(K.mean(K.square(y_pred - y_true)))) 

#Split into features and target (Price)
X = df.drop('e_x', axis = 1)
y = df['e_x']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 20)


#Scale data, otherwise model will fail.
#Standardize features by removing the mean and scaling to unit variance
from sklearn.preprocessing import StandardScaler
scaler=StandardScaler()
scaler.fit(X_train)

X_train_scaled = X_train
X_test_scaled = X_test


# define the model
#Experiment with deeper and wider networks
model = Sequential()
model.add(Dense(120, input_dim=7, activation='sigmoid'))
# model.add(Dropout(0.5))
model.add(Dense(120, activation='sigmoid'))
#Output layer
model.add(Dense(1, activation='sigmoid'))
model.add(Lambda(lambda x: x * (0.193 - 0.181) + 0.181))
model.output_names=['output'] 

opt = tf.keras.optimizers.Adamax(
    learning_rate=0.001)


model.compile(loss=rmse, optimizer=opt, metrics=['mse'])
model.summary()

history = model.fit(X_train_scaled, y_train, validation_split=0.1, epochs=1000, batch_size=20)

from matplotlib import pyplot as plt
#plot the training and validation accuracy and loss at each epoch
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs = range(1, len(loss) + 1)
plt.plot(epochs, loss, 'm', label='Training loss')
# plt.plot(epochs, val_loss, 'r', label='Validation loss')
plt.title('Training and validation loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.yscale('log')
plt.legend()
plt.show()


acc = history.history['mse']
val_acc = history.history['val_mse']
plt.plot(epochs, acc, 'm', label='Training MSE')
plt.plot(epochs, val_acc, 'r', label='Validation MSE')
plt.title('Training and validation MSE')
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.yscale('log')
plt.legend()
plt.show()

############################################
#Predict on test data
predictions = model.predict(X_test_scaled[:5])
print("Predicted values are: ", predictions)
print("Real values are: ", y_test[:5])
##############################################

onnx_model, _ = tf2onnx.convert.from_keras(model)
onnx.save(onnx_model, 'alsomitra_controller.onnx')