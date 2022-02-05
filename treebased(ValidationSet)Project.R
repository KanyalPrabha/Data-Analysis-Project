#library (ISLR)
library (tree)
library(randomForest)
library(vip)
library(readxl)

setwd("/Users/prabhakanyal/Desktop/Data Analysis Project")
excelData=read_excel("projectTrain.xlsx")
excelDataTest=read_excel("projectTest.xlsx")
head(excelDataTest)

projectData = data.frame(excelData)#important to pass this through data.frame
actualTestData = data.frame(excelDataTest)#important to pass this through data.frame

actualTestResponse = actualTestData$Y1

head(projectData )
sum(is.na(projectData ))
projectData=na.omit(projectData)
colnames(projectData )
dim(projectData )

projectData$X5[projectData$X5 == "7"] <- "TRUE"
projectData$X5[projectData$X5 == "3.5"] <- "FALSE"

projectData$X5 <- as.factor(projectData$X5)
class(projectData$X5)



actualTestData$X5[actualTestData$X5 == "7"] <- "TRUE"
actualTestData$X5[actualTestData$X5 == "3.5"] <- "FALSE"

actualTestData$X5 <- as.factor(actualTestData$X5)
class(actualTestData$X5)


head(actualTestData)
head(projectData)
#Data Check
sapply(projectData, mode)
sapply (projectData, function(x) length(unique(x)))

##Using the tree() function to build tree
treeProjectData=tree(Y1~.,data = projectData)
summary(treeProjectData) #What are in the outputs?
plot(treeProjectData) #display tree structure
text(treeProjectData,pretty=0) #display node labels

###training MSE
treeProjectData=tree(Y1~.,data=projectData)
treePred=predict(treeProjectData,projectData)
mean((projectData$Y1-treePred)^2)

###test MSE
treeProjectData=tree(Y1~.,data=projectData)
tree.pred=predict(treeProjectData,actualTestData)
mean((actualTestResponse-tree.pred)^2)


##Tree Prunning

set.seed(1) # we do this so that each time we run the Cv command, the plot doesn't change
CVprojectData=cv.tree(treeProjectData) #again, for classification, check class notes
names(CVprojectData)
CVprojectData
plot(CVprojectData$size, CVprojectData$dev,type = "b")
CVmin <- which.min(CVprojectData$dev)
CVmin
points(CVprojectData$size[CVmin], CVprojectData$dev[CVmin], col = "red", cex = 2, pch = 20)

#To fit the pruned tree
pruneProjectData=prune.tree(treeProjectData, best = 7)
plot(pruneProjectData) #display tree structure of the Pruned tree
text(pruneProjectData,pretty=0) 


#Training Error for the Pruned Tree
treePredPrune=predict(pruneProjectData,projectData)
mean((projectData$Y1-treePredPrune)^2)


#Testing the Pruned Tree
treePredPrune=predict(pruneProjectData,actualTestData)
mean((actualTestResponse-treePredPrune)^2)



###Bagging
############Question (d): Bagging
set.seed(500)
bagProjectData=randomForest(Y1~.,data = projectData,
                              mtry=8, ntree=100, importance=TRUE)
bagProjectData

#Training MSE
yhatBag=predict(bagProjectData,newdata=projectData)
mean((yhatBag-projectData$Y1)^2)


##calculate test MSE
yhatBag=predict(bagProjectData,newdata=actualTestData)
mean((yhatBag - actualTestData)^2)




############Question (e): Random Forest
#random Forest
set.seed(500)
RFprojectData=randomForest(Y1~.,data = projectData,
                             mtry=4, ntree=100, importance=TRUE)

RFprojectData

#Training MSE
yhatRF=predict(RFprojectData,newdata=projectData)
mean((yhatRF-projectData$Y1)^2)

#Test MSE
yhatRF=predict(RFproject_Data,newdata=actualTestData)
mean((yhatRF-actualTestResponse)^2)

importance(rf.carseats)
vip(rf.carseats)#To find the relative importance of the variables




####################Boosting
##Use gbm() function in gbm package to fit boosted regression
##trees to the Boston data
#install.packages("gbm")
library(gbm)
set.seed(1)
boostProjectData = gbm(Y1 ~ .,data=projectData,
                         distribution="gaussian", shrinkage = 0.01, n.trees=5000, interaction.depth=4)

boostProjectData

summary(boostProjectData) ##relative influence plot
par(mfrow=c(1,2))
plot(boostProjectData,i="X1") ##partial dependence plot
plot(boostProjectData,i="X2")

#Training MSE
yhatBoost = predict(boostProjectData,newdata=projectData,
                     n.trees=5000)
mean((yhatBoost-projectData$Y1)^2)

#TEST MSE
yhatBoost = predict(boostProjectData,newdata=actualTestData,
                     n.trees=5000)
mean((yhatBoost-actualTestResponse)^2)
