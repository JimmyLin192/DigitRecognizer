function C_SVM(trainFile, testFile, outLabels)

[train_labels, train_instances] = libsvmread(trainFile);
[test_labels, test_instances] = libsvmread(testFile);

% TODO: add training option for multiclass classfication
model = svmtrain(train_labels, train_instances, '-s 0')
[predicted_labels] = svmpredict(test_labels, test_instances, model);
index = 1:size(test_labels,1);
output = [index' predicted_labels];
csvwrite(outLabels, ['ImageId' 'Label']);
csvwrite(outLabels, output, 1, 0);
end
