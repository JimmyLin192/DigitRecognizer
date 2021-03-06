# makes the KNN submission

library(FNN)

train <- read.csv("../data/PCAed_train.csv", header=FALSE)
test <- read.csv("../data/PCAed_test.csv", header=FALSE)

labels <- train[,1]
train <- train[,-1]

cat("KNN starts...")
results <- (0:9)[knn(train, test, labels, k = 10, algorithm="cover_tree")]
cat("KNN ends...")

cat("Write to external file starts...")
cbind(as.matrix(seq(nrow(results))), as.matrix(results))
write.csv(results, file="PCA_KNN.csv", row.names=FALSE, col.names=FALSE) 
cat("Write to external file ends...")
