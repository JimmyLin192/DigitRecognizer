# makes the KNN submission

library(FNN)

train <- read.csv("../data/train.csv", header=TRUE)
test <- read.csv("../data/test.csv", header=TRUE)

labels <- train[,1]
train <- train[,-1]

cat("KNN starts...")
results <- (0:9)[knn(train, test, labels, k = 10, algorithm="cover_tree")]
cat("KNN ends...")

cat("Write to external file starts...")
write(results, file="knn_benchmark.csv", ncolumns=1) 
cat("Write to external file ends...")
