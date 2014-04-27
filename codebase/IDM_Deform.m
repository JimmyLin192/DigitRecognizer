%% IDM DEFORMATION MODEL
%% AUTHOR: JIMMY LIN
%% USAGE:
%    rawTrainFile - input csv file for training data
%    rawTestFile - input csv file for testing data
%    theStart - the test data instance our prediction starts from
%    theEnd - the test data instance our prediction ends to

function IDM_Deform (rawTrainFile, rawTestFile, outDir, theStart, theEnd)
fprintf('Start reading trainData..\n')
trainData = csvread(rawTrainFile);
train_labels = trainData(:,1);
train_features = trainData(:,2:size(trainData,2));
fprintf('End reading trainData..\n')

fprintf('Start reading testData..\n')
test_features = csvread(rawTestFile);
fprintf('End reading testData..\n')

nTrainDigits = size(trainData, 1);
nTestDigits = size(test_features, 1);
nFeatures = size(train_features, 2);
nClasses = length(unique(train_labels));

filename = strcat(['IDM_' num2str(theStart) '_' num2str(theEnd) '.csv']);
outFile = strcat([outDir filename]);
fprintf('Output Filename: %s\n', outFile)

for testIdx = theStart:theEnd,
    test_img = test_features(testIdx,:);
    min_dist = inf;
    min_img = inf;
    min_class = inf;
    for trainIdx = 1:nTrainDigits,
        train_img = train_features(trainIdx,:);
        dist = IDM_distance(test_img, train_img);
        if dist < min_dist,
            min_dist = dist;
            min_img = trainIdx;
            min_class = train_labels(trainIdx);
        end
    end
    fprintf ('Test Index: %d, Classified as %d\n', testIdx, min_class)
    csvwrite(outFile, testIdx, testIdx, 0)
    csvwrite(outFile, min_class, testIdx, 0)
end
end

%%% Computation for IDM distance
%%
%% See: 
%    Deformation Model for Image Recognition (Algorithm 3)
%
%% INPUT INSTRUCTION
%    A: test image
%    B: reference image
function s = IDM_distance(A, B)
WIDTH = 28;
HEIGHT = 28;
s = 0;
w = 3;
for i = 1:WIDTH,
    for j = 1:HEIGHT,
        min_edist = inf;
        for x = max([1 i-w]):min([WIDTH i+w]),
            for y = max([1 j-w]):min([HEIGHT j+w]),
                dist = norm(A((j-1)*WIDTH+i) - B((y-1)*WIDTH+x));
                if dist < min_edist;
                    min_edist = dist;
                end
            end
        end
        s = s + min_edist;
    end
end
end
