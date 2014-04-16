function PCA_C_SVM (trainFile, testFile, outLabels)

[train_labels, train_instances] = libsvmread(trainFile);

[test_labels, test_instances] = libsvmread(testFile);

model = svmtrain (train_labels, train_instances);

[predicted_labels] = svmpredict(test_labels, test_instances, '-s 0');

index = 1:size(test_instances,1);
index = index';

output = [index predicted_labels];

libsvmwrite(outLabels, ['ImageId' 'Label']);
libsvmwrite(outLabels, output, 1, 0);

end
