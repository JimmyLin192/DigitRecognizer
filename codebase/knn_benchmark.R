# makes the KNN submission

library(FNN)

train <- read.csv("../data/PCA_train_64.csv", header=TRUE)
test <- read.csv("../data/PCA_test_64.csv", header=TRUE)

labels <- train[,1]
train <- train[,-1]

cat("KNN starts...")
results <- (0:9)[knn(train, test, labels, k = 10, algorithm="cover_tree")]
cat("KNN ends...")

cat("Write to external file starts...")
write(results, file="PCA_64_KNN_10.csv", ncolumns=1) 
cat("Write to external file ends...")
