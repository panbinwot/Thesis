#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2019-02-25 09:12:27
# @Author  : Bin Pan (bp2551@columbia.edu)
# @Version : $1.0$

import numpy as np
import pandas as pd
import math
import matplotlib.pyplot as plt
import math
from numpy.random import permutation
from numpy import array_split, concatenate

from sklearn.cross_validation import train_test_split
from sklearn.neighbors import KNeighborsClassifier as knnn

class solution:
	def __init__(self, X, y):
		self.features_matrix = X
		self.target = y

class model(solution):
	'''
	Step 0: Cross Validation
	Return: y_test, y_pred
	'''
	def cv(self,folds = 10):
		x = self.features_matrix
		y = self.target
		res = []

		assert len(y) > folds # Actually, no need to do that

		perms = array_split(permutation(len(y)), folds)
		
		for  i in range(folds):
			print("working on fold number:", i)
			train_idxs = list(range(folds))
			train_idxs.pop(i) 
			train = []
			for idx in train_idxs:
				train.append(perms[idx])
			train = concatenate(train)
				
			test_idx = perms[i] 
			self.X_train, self.X_test, self.y_train, self.y_test = x.iloc[train],x.iloc[test_idx], y.iloc[train],y.iloc[test_idx]
			w = self.train(self.X_train,self.y_train)
			print(w)
			y_pred = self.predict(self.X_test,w)
			res.append([y_pred, self.y_test])
		return res

	def acq(self,y_pred,y_test):
		a = np.array(y_pred)
		b = np.array(y_test)
		r = 0
		for i in range(0,len(a)):
			if a[i] == b[i]:
				r += 1
		return r/len(a)

	def validate(self,folds = 10):
		a,b = [],[]
		for y_p, y_t in self.cv(folds):
			b.append( self.acq(y_p, y_t) )
			# print(self.acq(y_p, y_t))
		print("Cross Validation Complete. Output the average score:", np.mean(b))
		return np.mean(b)

class Bayes(model):
	'''
	Implement the naive bayesian estimator 
	and evaluate the model by confusion matrix, accuracy
	'''
	def train(self,x,y):
		x = np.array(x)
		y = np.array(y)
		p_hat = sum(y)/len(y)

		df = pd.DataFrame( np.c_[y,x] )
		x0 = np.array(df.where(df[0]==0).dropna() )[:,1:]
		P,D = x0.shape
		x1 = np.array(df.where(df[0]==1).dropna() )[:,1:]
		Q,D = x1.shape 
		l0d = (np.sum(x0)+D)/(D*P+D)
		l1d = (np.sum(x1)+D)/(D*Q+D)

		return p_hat[0], l0d, l1d

	def predict(self,x,w):
		p,v1,v2 = w[0],w[1],w[2]
		y_pred = []
		x = np.array(x)
		for i in range(len(x)):
			l = np.prod(np.random.poisson(v1,[x[i,:]]))*(1-p)
			r = np.prod(np.random.poisson(v2,[x[i,:]]))*p
			if l > r:
				y_pred.append(0)
			else:
				y_pred.append(1)
		return y_pred

	def stem_plot(self):
		pass

class KNN(model):
	'''
	Implement k-NN algorithm (k = 1 ... 20).
	Evaluate it by Plot of accuracy
	'''
	def __init__(self, X, y, k ):
		self.features_matrix = X
		self.target = y
		self.k = k

	def train(self,x,y):
		return 0
		# No training for KNN 
			
	def predict(self,x,w):
		y_pred = []
		for i in range(len(self.X_test)):
			pt = np.array(self.X_test.iloc[i,:])
			y_pred.append(self.knn(x,pt))
		return y_pred

	def knn(self,x,pt):
		row = 0  # Track the row number
		dst = {}

		for j in range(len(x)):
			s = np.array(self.X_train.iloc[j,:])
			# dst[str(row)] = np.linalg.norm(pt-s,ord=1)
			dst[str(row)] = self.dist(pt,s)
			row += 1

		lst = sorted(dst.items(),key = lambda item:item[1],reverse=False)[0:self.k]
		# Vote
		y_po,y_ne = 0, 0 
		while lst:
			if np.array(self.y_train)[int(lst.pop()[0])] == 1: 
				y_po += 1
			else:
				y_ne += 1
		if y_po > y_ne:
			return 1
		else:
			return 0

	def dist(self,a,b):
		if len(a) != len(b):
			print("Error")
		d = 0
		for i in range(len(a)):
			d = d + abs(a[i]-b[i])
		return d

class KNNN(KNN):
	def predict(self,x,y):
		mlgb = knnn(n_neighbors=self.k)
		mlgb.fit(self.X_train,self.y_train)
		return mlgb.predict(self.X_test)

class Logit_steepest_ascent(model):
	'''
	Estimate logit regression by steepest ascent algorithm.
	Evaluate it by confusion matrix
	'''
	def __init__(self, X, y, h = 0.01/4600, n = 1000):
		self.features_matrix = X
		self.target = y
		self.h = h
		self.n = n

	def train(self,x,y):
		# Reform data
		x.loc[:,len(x.columns)] = 1 
		x = np.array(x)
		y = np.array(y.replace(0,-1))

		# The following code are just tmp solution
		self.X_test.loc[:,55] = 1

		# Initialize w vector
		w = np.zeros((x.shape[1],))
		for i in range(0,self.n):
			w = w + self.h*self.gradient(x,y,w)
		return w

	def llhood(self,x,y,w):
		i,s = 0,0
		for i in range(0,x.shape[0]):
			# s = s+ np.log(self.sigma(x[i,:],y[i],w))
			m = y[i]*np.dot(x[i,:],w)
			s = s+ m +np.log(1 + math.exp(m) )			
			i += 1
		return s		

	def gradient(self,x,y,w):
		i,gradient = 0,0
		for i in range(0,x.shape[0]):
			gradient = gradient+ y[i]*np.dot((1-self.sigma(x[i,:],y[i],w)),x[i,:])
			i += 1
		return gradient

	def hessian(self,x,y,w):
		i,hess = 0,0
		for i in range(0,x.shape[0]):
			hess += np.dot(np.mat(x[i,:]).transpose(),np.mat(x[i,:]))*(1-self.sigma(x[i,:],y[i],w)/math.exp(y[i]*np.dot(x[i,:],w)))
		return hess

	# Recall ( 1- sigma_i(y_i wt) ) is the probability assigned to the wrong value.
	def sigma(self,x_i,y_i,w):

		tmp = math.exp(y_i*np.dot(x_i,w))
		sig_i = tmp/(1+tmp)
		return sig_i

	def predict(self,x,w, c = 0.5):
		# c is the threshold......
		y_tmp = [math.exp(x)/(1+math.exp(x)) for x in np.dot(np.array(x),w)]
		return [1 if y>c else 0 for y in y_tmp]

class Logit_newton(Logit_steepest_ascent):
	'''
	Estimate logit regression by Newton's Method. 
	h is critical value, n is max iter time.
	solve the FOC of new llhood, we have iter: w_t+1 = w_t + inv(H)*G
	np.linalg.inv(x)
	'''
	def __init__(self, X, y, d = 0.01, t = 100):
		self.features_matrix = X
		self.features_matrix.loc[:,55] = 1		
		self.target = y
		self.d = d
		self.t = t	

	def train(self,x,y):
		# Reform data
		x.loc[:,len(x.columns)] = 1 
		x = np.array(x)
		y = np.array(y.replace(0,-1))

		# The following code are just tmp solution


		# Initialize w vector
		w = np.zeros((x.shape[1],1))
		l = self.llhood(x,y,w)
		i = 0
		dl = np.Infinity
		# delta = np.Infinity
		while abs(dl)>self.d and i < self.t:
			grad = self.gradient(x,y,w)
			hess = self.hessian(x,y,w)
			tm = np.mat(grad).transpose()
			delta = np.dot(np.mat(np.linalg.inv(hess)), tm)
			w += np.mat(delta)
			l2 = self.llhood(x, y, w) 
			dl = l - l2
			l = l2
			i += 1
			print("iteration :",i)
			print(dl)
		return w

path = 'C:/Users/pb061/OneDrive/Semester2/COMSW4721/HW/hw2/'
X = pd.read_csv(path+'X.csv',header=None) 
y = pd.read_csv(path+'y.csv',header=None)


# test3 = Logit_newton(X,y)
# print(test3.validate(2))

test = Bayes(X,y)
print(test.validate(2))
