setwd("/Users/prabhakanyal/Desktop/Data Analysis Project")
library(readxl)
library(leaps)  
train = read_excel("projectTrain.xlsx")

projectTrainData = data.frame(train)#important to pass this through data.frame

head(projectTrainData)
sum(is.na(projectTrainData))
projectTrainData =na.omit(projectTrainData)
colnames(projectTrainData)
dim(projectTrainData)

#checking correlations
pairs(projectTrainData[,-c(9)], main ="scatter plot of the independent variables in pairs", col = "blue")
pairs(projectTrainData, main ="scatter plot of the predictor and response variable in pairs", col = "blue")
cor(projectTrainData, use = "complete.obs")

##Best subset selection Model: returns up to 8 variables
modelRegfit = regsubsets(Y1~.,data=projectTrainData,nvmax=8)#reports as many variables as desired up to the total number of variables which is gonna be the maximum anyways
modelRegfitSummary = summary(modelRegfit)
modelRegfitSummary
names(modelRegfitSummary)



##find the best model according to each criteria
modelRegfitSummary$rss
par(mfrow=c(2,2))#used to plot multiple graphs in a single plot
#Figure 1
plot(modelRegfitSummary$rss,xlab="Number of predictors",ylab="RSS",type="l")
#Figure 2
modelRegfitSummary$rsq
modelRegfitSummary$adjr2
plot(modelRegfitSummary$adjr2,xlab="Number of predictors",ylab="Adjusted
RSq",type="l")
which.max(modelRegfitSummary$adjr2)
points(6,modelRegfitSummary$adjr2[6], col="red",cex=2,pch=20)
#Figure 3
modelRegfitSummary$cp
plot(modelRegfitSummary$cp,xlab="Number of predictors",ylab="Cp",type='l')
which.min(modelRegfitSummary$cp)
points(6,modelRegfitSummary$cp[6],col="red",cex=2,pch=20)
#Figure 4
modelRegfitSummary$bic
plot(modelRegfitSummary$bic,xlab="Number of predictors",ylab="BIC",type='l')
which.min(modelRegfitSummary$bic)
points(5,modelRegfitSummary$bic[5],col="red",cex=2,pch=20)


#Approximating the test error using the validation set approach and looking for the optimal model
set.seed(500)
train_Project_Data=sample(1:nrow(Project_Data), nrow(Project_Data)/2)
Train_Data=Project_Data[train_Project_Data,] #put training data set in a data frame, wonder why R requires this
dim(Train_Data)
Test_Data=Project_Data[-train_Project_Data,] #test data set
Test_response=Project_Data$Y1[-train_Project_Data] #response variable on the test data


M2_lm.train_1 <- lm(Y1 ~ X5, data = Train_Data)
M2_pred.test_1 <- predict(M2_lm.train_1, Test_Data) #create predictions on test set
mean((M2_pred.test_1 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_2 <- lm(Y1 ~ X5+X7, data = Train_Data)
M2_pred.test_2 <- predict(M2_lm.train_2, Test_Data) #create predictions on test set
mean((M2_pred.test_2 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_3 <- lm(Y1 ~ X3+X5+X7, data = Train_Data)
M2_pred.test_3 <- predict(M2_lm.train_3, Test_Data) #create predictions on test set
mean((M2_pred.test_3 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_4 <- lm(Y1 ~ X1+X4+X5+X7, data = Train_Data)
M2_pred.test_4 <- predict(M2_lm.train_4, Test_Data) #create predictions on test set
mean((M2_pred.test_4 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_5 <- lm(Y1 ~ X1+X4+X5+X7+X8, data = Train_Data)
M2_pred.test_5 <- predict(M2_lm.train_5, Test_Data) #create predictions on test set
mean((M2_pred.test_5 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_6 <- lm(Y1 ~ X1+X2+X3+X5+X7+X8, data = Train_Data)
M2_pred.test_6 <- predict(M2_lm.train_6, Test_Data) #create predictions on test set
mean((M2_pred.test_6 - Test_response)^2) #Mean Sq Error Linear Model

M2_lm.train_7 <- lm(Y1 ~ X1+X2+X3+X5+X6+X7+X8, data = Train_Data)
M2_pred.test_7 <- predict(M2_lm.train_7, Test_Data) #create predictions on test set
mean((M2_pred.test_7 - Test_response)^2) #Mean Sq Error Linear Model

#To get the coefficient of the Best model we regress using full data set
coef_6 <- lm(Y1 ~ X1+X2+X3+X5+X7+X8, data = Project_Data)
summary(coef_6)



#Future work: GIVEN TEST DATA

#Training Error(8.781438)
M2_lm.TEST_6 <- lm(Y1 ~ X1+X2+X3+X5+X7+X8, data = Project_Data)
M2_pred.test_6 <- predict(M2_lm.TEST_6, Project_Data) #create predictions given 
mean((M2_pred.test_6 - Project_Data$Y1)^2) #Training Error 
#Given actual test data, make sure to save the test data as "Test_Data"
#and run the last three lines of code

#Test Error
#Define TEST DATA
#M2_lm.TEST_6 <- lm(Y1 ~ X1+X2+X3+X5+X7+X8, data = Project_Data)
#M2_pred.test_6 <- predict(M2_lm.TEST_6, Test_Data) #create predictions given 
#mean((M2_pred.test_6 - Test_response)^2) #Test Error 
#Given actual test data, make sure to save the test data as "Test_Data"
#and run the last three lines of code
