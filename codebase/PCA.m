function PCA (trainInFile, testInFile, outTrainfile, outTestFile)

% read in the image file data with header
M = csvread(trainInFile,1,0);
testPixels = csvread(testInFile,1,0);

nDigits = size(M,1);
nCols = size(M,2);
nFeatures = nCols-1;

% groundtruth label and raw pixels of each digits
labels = M(:,1);
M = M(:,2:nCols); 

% since SVD on raw input matrix is too expensive,
% we subsample it and run svd to apply PCA
% TODO: run svd on original matrix? 
sampleSize = 5000;
sampleIdx = mod(randi(nDigits, [1 sampleSize]), nDigits);
subM = M(sampleIdx, :);
[U, Sigma, V] = svd(subM); 

% However, we observe that the derived singluar values are almost continuous.
% That is, there is no significant break point we can make use of.
% TODO: find a more reasonable way to determine the number of principal
% component
singularValues = [];
for i = 1:min(size(Sigma)),
    singularValues = [singularValues Sigma(i,i)];
end

% TODO: one way is to cross validate on the number of pc
% extract the right singular matrix
nPrincipalComponents = 100;
subV = V(:, 1:nPrincipalComponents);
% derive the PCA truncated matrix
PCAedM = M * subV;
PCAedTestM = testPixels * subV;

PCAedMwithLabels = [labels PCAedM];
csvwrite(outTrainfile, PCAedMwithLabels)
csvwrite(outTestFile, PCAedTestM)
