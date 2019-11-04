# Thesis
This is thesis for QMSS. 
My topic is predicting salaries with machine learning models. <br/>
The data is collected from NLSY97 and cleaned in Stata. Models are defined in Python (sklearn and keras). In this paper, I try to address the following three quesitons.
- How best canwe predict wages with all the methods we have given those legit variables? 
- Is itgetting hard to predict wages ?  
- Is neural net way too powerful for social science research? Can we achieve a similar performance by using other methods that has meanings beside prediction.   

The current result shows that the  XGBoost Algorithm does the best job among other models. The classic panel data regression is the second best, which is surprising. The decisison trees and random forests suffers overfitting a lot, which means i need to pune the trees.

To be continued...