#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2019-01-22 15:05:18
# @Author  : Bin Pan (bp2551@columbia.edu)

import numpy as np
import pandas as pd
import math
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import  cross_val_predict
from sklearn.cross_validation import train_test_split
from sklearn import metrics
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
import xlsxwriter

class PredictRate:
	"""docstring for PredictRate"""
	pd.options.mode.chained_assignment = None
	def __init__(self, dat):
		self.dataFrame = dat
		self.features_name = self.genvar(self.dataFrame)
		self.target_name = 'lnwage'
		self.features_matrix = np.array(self.dataFrame[self.features_name])
		self.target = np.ravel(np.array(self.dataFrame[['lnwage']]))
		self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(self.features_matrix, self.target, random_state=1)
		self.res = 0 # Keep track of all the models.

	# @staticmethod
	def genvar(self,df):
		varlst = []
		for col in df.columns.values.tolist():
			if col=='lnwage':continue
			if str(df[col].dtype)=='object':
				tabs = self.tab(df,col)
				varlst = varlst + tabs                
			else: 
				varlst.append(col)
		return varlst

	def tab(self,df, var):
		var_matrix=[]
		catlst=self.group(df,var)
		count = 1
		for v in catlst:
			subname = str(var)+'_'+str(count)
			df[subname] = 0
			var_matrix.append(subname)
			df.loc[df[var]==v,subname]=1
			count += 1
		return var_matrix
    
	def group(self,df,var):
		catlst=[]
		for i in df[var]:
			if not i in catlst:
				catlst.append(i)
		return catlst

class Models(PredictRate):
	
	def idk(self):
		pass

	# Output the result in excel.
	def output_excel(self):
		wb = xlsxwriter.Workbook('./res.xlsx')
		ws = wb.add_worksheet()
		ws.write(1,1,'Models')
		ws.write(1,2,'Score')
		ws.write(1,3,'MSE')

		return 'File saved at the current directory'

	def predict(self):
		regressor = self.train(self.X_train,self.y_train)
		pred = regressor.predict(self.X_test)		
		return pred

	def aqr_abs(self):
		abs_err = abs(self.predict() - self.y_test)
		aqr_abs = round(100-np.mean(100 * (abs_err/self.y_test)), 2)
		return aqr_abs

	def iscore(self):
		regressor = self.train(self.X_test,self.y_test)
		return round(regressor.score(self.X_test,self.y_test),2)

	def aqr_mse(self):
		mse = np.square(self.predict() - self.y_test )
		aqr_mse = round(100-np.mean(100 * (mse/self.y_test)), 2)
		return aqr_mse

	def rsquare(self):
		y_bar = np.mean(self.y_test)
		variance_exp = sum(np.square(self.predict() - y_bar))
		variance_tol = sum(np.square(self.y_test - y_bar))
		r2 = round(100*variance_exp/variance_tol,2)
		return r2

class RfReg(Models):
	def train(self,x,y):
		self.res += 1
		regressor = RandomForestRegressor(n_estimators=1000, 
							max_depth=15,
							random_state=42)
		reg = regressor.fit(x,y)
		return reg

class Mincer(Models):
	def train(self,x,y):
		self.res += 1
		regressor = LinearRegression()
		reg = regressor.fit(x,y)
		return reg

class Gboost(Models):
	def train(self,x,y):
		self.res += 1
		regressor = GradientBoostingRegressor(max_depth=15)
		reg = regressor.fit(x,y)
		return reg

a = [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2013,2015]
path = 'C:/Users/pb061/OneDrive/GraduateThesis/'
data =pd.read_excel(path+'data/temp/mincer.xlsx') 

b = [2005, 2006, 2007]
for y in a:
	df = data.copy() 
	dat = df.loc[df['year']==y]
	print('-'*5,'Following Test Year = ',y,' ','-'*5)

	lr = Mincer(dat)
	print('Linear Mincer: ','Score: ',lr.iscore(),
		# ' R-square: ',lr.rsquare(),'%',
		'Accuracy(MSE)',lr.aqr_mse(),' %')

	clf = RfReg(dat)
	print('Random Forest: ','Score: ',clf.iscore(),
		# ' R-square: ',clf.rsquare(),'%',
		'Accuracy(MSE): ',clf.aqr_mse(),' %')

	gb = Gboost(dat)
	print('Gradient Boosting: ','Score: ',gb.iscore(),
		# ' R-square: ',gb.rsquare(),'%',
		' Accuracy(MSE)',gb.aqr_mse(),' %')

# clf = Mincer(data.loc[data['year']==2005])
# print(clf.output_excel())











