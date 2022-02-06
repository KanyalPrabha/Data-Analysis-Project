# Data-Analysis-Project
OBJECTIVE:

The objective of this project was to come up with a statistical learning method for a regression problem that would provide a high prediction accuracy when applied to previously unseen test data.  

The approach to the problem was to analyze and compare different methods and to assess the performance of each method based on some approximation of the test mean square error – a measure of the accuracy in predicting the test data. For the analysis, we were guided by the knowledge of the structure of our data which includes the relationships between explanatory and the response variable as well as the relationship between pairs of the explanatory variables. We then selected three best models comprising: 

1.	Model1: Multiple linear regression model with an interaction term and transformation of the output variable 
2.	Model 2: best subsets selection method 
3.	Model 3: Lasso regression method. 

We found the best subset selection method to be the overall best model because it had the lowest approximation of the test mean square error. We also calculated the true test mean square error given the actual test data. 

Model Improvement:
Furthermore, in the model improvement phase of the project, we revised our decision of our best model. We then sought ways to achieve a better prediction accuracy by analyzing other models not previously considered. Eventually, we concluded that regression trees improved by boosting in fact provided the best prediction accuracy. 
