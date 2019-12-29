# Predicting Wage with Machine Learning
Thesis for QMSS. A next level question, do we really need machine learning in social science studies.
## Topic
My topic is predicting salaries with machine learning models. <br/>
To be specific, I try to address the following three quesitons.
- How best canwe predict wages with all the methods we have given those legit variables? 
- Is it getting hard to predict wages ?  
- Is neural net way too powerful for social science research? Can we achieve a similar performance by using other methods that has meanings beside prediction.   

## Background
### Econ Background
- Mincer Equation
- Dual Labor Markets Theory (DLM)
### ML Background
- Cross validation
- A data-driven way of thinking. 

## Data
NLSY97(2005-2011&2013&2015)

## Environment/Usage
Models are defined in Python (sklearn and keras)

## Key Result
The result shows that the  Gradient Boost Algorithm does the best job among other models. The classic panel data regression is the second best, which is surprising. The decisison trees and random forests suffers overfitting a lot. Partial results are summerized below

| Models      | MSE(train)|MSE(test)| R<sup>2</sup>(train) |R<sup>2</sup>(test)|
| ------------- | ---------- | ----------- | ----------- |----------- |
|Regression|  0.34201 | 0.33855 | 0.21462 | 0.21594|
| Regression Tree | 0.18495 | 0.50965 | 0.575728 | -0.18031| 
|Random Forests|0.2063|0.41813|0.525625|0.03165|
|Gradient Boost|0.31873|0.33244|0.26806|0.2301|
|Neural Network|0.3996|0.39748|0.0823|0.07947|


## Implications
 This paper applies popular machine learning models to predict wages using data from the National Longitudinal Survey Youth 97 (NLSY 97). The paper firstly examines the classic Mincer equation in both the primary sector and the secondary sector defined by the dual labor market theory. Then, the paper explores the performance of random forests, gradient boosting machines, and neural networks in terms of mean squared error and R-squared. The result shows linear regression and gradient boosting machines are better than other models. The regression tree model suffers a lot from overfitting. The neural network tends to easily underfit the data. Furthermore, the paper tests the model over time and observe a consistent increase of mean squared error of all the models, indicating a decreasing of predictability of all models over time.

## References

[1] Jacob  Mincer.   Schooling,  experience,  and  earnings.  human  behavior  &  socialinstitutions no. 2.ERIC, 1974. <br>
[2] Harry Anthony Patrinos.  Estimating the return to schooling using the mincer equation.IZA World of Labor, 2016. <br>
[3] Hal  R  Varian. Big data:  New  tricks  for  econometrics.Journal of EconomicPerspectives, 28(2):3–28, 2014.