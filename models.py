'''
Author: Bin Pan
Date: 09/21/2018
Comment: this is the helper function for the thesis project. The module includes several models and defines errors. I wrote it in the functional way to make it easier.
'''
import numpy as np 
import pandas as pd 
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn import metrics
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor

from keras.models import Sequential
from keras.layers.normalization import BatchNormalization
from keras.layers.convolutional import Conv2D
from keras.layers.convolutional import MaxPooling2D
from keras.layers.core import Activation
from keras.layers.core import Dropout
from keras.layers.core import Dense
from keras.layers import Flatten
from keras.layers import Input
from keras.models import Model
from keras.optimizers import adam


def mincer(X_train, y_train,  X_test, y_test):
    regressor = LinearRegression()
    reg = regressor.fit(X_train,y_train)
    y_pred = reg.predict(X_test)
    # return reg.score(X_test, y_test)
    return np.mean(np.square(y_pred-y_test))


def trees(X_train, y_train, X_test, y_test, model="rf", n_estimators=5, max_depth=5):
    if  model == "gb":
        regressor = GradientBoostingRegressor(max_depth=15)
    else:
        regressor = RandomForestRegressor(n_estimators=5, max_depth=1, random_state=1)
    reg = regressor.fit(X_train, y_train)
    # y_pred = reg.predict(X_test)
    r2 = reg.score(X_test, y_test)
    return np.mean(np.square(y_pred-y_test))


def nn(X_train, y_train, X_test, y_test):
    dim =  X_train.shape[1]
    model = Sequential()
    model.add(Dense(8, input_dim=dim, activation="relu"))
    model.add(Dense(4, activation="relu"))
    model.add(Dense(4, activation="relu"))
    model.add(Dense(4, activation="relu"))
    model.add(Dense(1, activation="linear"))
    
    opt = adam(lr=1e-3, decay=1e-3 / 200)
    model.compile(loss="mean_absolute_percentage_error", optimizer=opt)
    model.fit(X_train, y_train, validation_data=(  X_test, y_test), epochs=5, batch_size=8)
    
    y_pred = model.predict(X_test)

    diff = y_pred.flatten() - y_test
    percentDiff = (diff / y_test) * 100
    absPercentDiff = np.abs(percentDiff)
    mean = np.mean(absPercentDiff)
    std = np.std(absPercentDiff)

    r2 = np.mean(np.square(diff))
    print("The r_squrare of this MLP is: {:.2f}%".format(r2))
    return r2


def  r_square(y_pred, y_test):
    # assert (y_pred.shape == y_test.shape), "Inputs dimension errors."
    y_pred, y_test = np.array(y_pred), np.array(y_test)
    res = ((y_pred - y_test)^2).sum() / len(y_test)
    return res


# data_path = './data/mincer.xlsx'
# #dat.describe(include="all")
# dat = pd.read_excel(data_path)
# dat = dat.fillna(0)
# train, test = train_test_split(dat, test_size=0.25, random_state=12)
# y_train, X_train, y_test, X_test = train['lnwage'], train.iloc[:,
#                                                                4:], test['lnwage'], test.iloc[:, 4:]

# res = nn(X_train, y_train, X_test, y_test)
# print("Testing............")
# print(res)
