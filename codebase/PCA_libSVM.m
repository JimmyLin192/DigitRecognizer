function PCA_libSVM(trainFile, testFile, outLabels)

[train_labels, train_instances] = libsvmread(trainFile);

[test_labels, test_instances] = libsvmread(testFile);

model = svmtrain(train_labels, train_instances);
[predicted_labels, accuracy] = svmpredict(test_instances, test_labels);
libsvmwrite(outLabels, predicted_labels);
end