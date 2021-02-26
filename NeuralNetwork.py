from keras.models import Sequential
from keras.layers import Dense
from numpy import array
from numpy.random import uniform
from numpy import hstack
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import pandas as pd
import numpy as np

#Read Data Points
Y = pd.read_csv('Targets.csv')
X = pd.read_csv('Inputs.csv')
X = X.astype('float32')
Y = Y.astype('float32')
X = X.to_numpy()
Y = Y.to_numpy()
Y[:,0:2] = Y[:, 0:2] * 180/3.14

#Split Data Points
xtrain, xtest, ytrain, ytest=train_test_split(X, Y, test_size=0.01)

#Model Parameters
model = Sequential()
model.add(Dense(100, input_dim=in_dim, activation="relu"))
model.add(Dense(200, activation = "relu"))
model.add(Dense(400, activation = "relu"))
model.add(Dense(out_dim))
model.compile(loss="mean_absolute_error", optimizer="adam", metrics=['accuracy'])

#Train Model
history = model.fit(X, Y, validation_split=0.02, epochs=200, batch_size=128)

#Dev-Set
ypred = model.predict(xtest)

#Find MSE Errors
print("rotational error MSE:%.4f" % np.sqrt(mean_squared_error(ytest[:,0], ypred[:,0])**2+mean_squared_error(ytest[:,1], ypred[:,1])**2+mean_squared_error(ytest[:,2], ypred[:,2])**2))
print("translational error MSE:%.4f" % np.sqrt(mean_squared_error(ytest[:,3], ypred[:,3])**2+mean_squared_error(ytest[:,4], ypred[:,4])**2+mean_squared_error(ytest[:,5], ypred[:,5])**2))

#Plot a few points to visually check model accuracy
length = 2000
x_ax = range(len(xtest[0:length,0]))
plt.scatter(x_ax, ytest[0:length,5],  s=1, label="y1-test")
plt.plot(x_ax, ypred[0:length,5], label="y1-pred")
#plt.scatter(x_ax, ytest[:,1],  s=6, label="y2-test")
#plt.plot(x_ax, ypred[:,1], label="y2-pred")
plt.legend()
plt.show()


#Plot Model Accuracy, training, and loss curves
print(history.history.keys())
# summarize history for accuracy
plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('model accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()
# summarize history for loss
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()
