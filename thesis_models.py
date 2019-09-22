'''
Author: Bin Pan
Date: 09/21/2018
Comment: this is the helper function for the thesis project. The module includes several models and defines errors. I wrote it in the functional way to make it easier.
'''
import numpy as np 

def  r_square(y_pred, y_test):
    y_pred, y_test = np.array(y_pred), np.array(y_test)
    res = ((y_pred - y_test)^2).sum() / len(y_test)
    print(res)
    return res