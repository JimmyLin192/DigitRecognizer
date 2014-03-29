# makes the KNN submission

library(FNN)

train <- read.csv("../data/PCAed_train.csv", header=FALSE)
test <- read.csv("../data/PCAed_test.csv", header=FALSE)

labels <- train[,1]
train <- train[,-1]

cat(nrow(train), nrow(test), "\n")
cat(ncol(train), ncol(test), "\n")

cat("KNN starts...")
results <- (0:9)[knn(train, test, labels, k = 10, algorithm="cover_tree")]
cat("KNN ends...")

cat("Write to external file starts...")
write(results, file="PCA_KNN.csv", ncolumns=1) 
cat("Write to external file ends...")
