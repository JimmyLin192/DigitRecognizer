# makes the random forest submission

library(randomForest)

train <- read.csv("../data/PCA_train.csv", header=FALSE)
test <- read.csv("../data/PCA_test.csv", header=FALSE)

labels <- as.factor(train[,1])
train <- train[,-1]

rf <- randomForest(train, labels, xtest=test, ntree=1000)
predictions <- levels(labels)[rf$test$predicted]

write(predictions, file="../result/PCA_RF.csv", ncolumns=1) 
