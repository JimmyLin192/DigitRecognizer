function PCA_libSVM(trainFile, testFile, outLabels)

[train_labels, train_instances] = libsvmread(trainFile);
[test_labels, test_instances] = libsvmread(testFile);

% TODO: add training option for multiclass classfication
model = svmtrain(train_labels, train_instances);
[predicted_labels] = svmpredict(test_labels, test_instances, model);
libsvmwrite(outLabels, predicted_labels);
end