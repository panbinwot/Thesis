# Predicting Salary with Machine Learning Models
This is thesis for QMSS. A next level question, do we really need machine learning in social science studies.
## Topic
My topic is predicting salaries with machine learning models. <br/>
To be specific, I try to address the following three quesitons.
- How best canwe predict wages with all the methods we have given those legit variables? 
- Is it getting hard to predict wages ?  
- Is neural net way too powerful for social science research? Can we achieve a similar performance by using other methods that has meanings beside prediction.   

## Data
NLSY97(2005-2011&2013&2015)

## Environment/Usage
Models are defined in Python (sklearn and keras)

## Current Result
The current result shows that the  Gradient Boost Algorithm does the best job among other models. The classic panel data regression is the second best, which is surprising. The decisison trees and random forests suffers overfitting a lot. Partial results are summerized below

| Models      | MSE(train)|MSE(test)| R<sup>2</sup>(train) |R<sup>2</sup>(test)|
| ------------- | ---------- | ----------- | ----------- |----------- |
|Regression|  0.34201 | 0.33855 | 0.21462 | 0.21594|
| Regression Tree | 0.18495 | 0.50965 | 0.575728 | -0.18031| 
|Random Forests|0.2063|0.41813|0.525625|0.03165|
|Gradient Boost|0.31873|0.33244|0.26806|0.2301|
|Neural Network|0.3996|0.39748|0.0823|0.07947|


## Implications
I explored the performance of several popular machine learning models on survey data (limited size and noisy). The results show that only model beating linear regression is Gradient Boost. Maybe we need a second before embracing all the fancy machine learning algorithms. 

## References

[1] Jacob  Mincer.   Schooling,  experience,  and  earnings.  human  behavior  &  socialinstitutions no. 2.ERIC, 1974. <br>
[2] Harry Anthony Patrinos.  Estimating the return to schooling using the mincer equation.IZA World of Labor, 2016. <br>
[3] Hal  R  Varian. Big data:  New  tricks  for  econometrics.Journal of EconomicPerspectives, 28(2):3–28, 2014.