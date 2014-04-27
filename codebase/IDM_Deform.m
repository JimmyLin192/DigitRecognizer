%% IDM DEFORMATION MODEL
%% AUTHOR: JIMMY LIN
%% INVOCATION:
%    IDM_Deform('../data/train.csv', '../data/test.csv', '../result/', 1, 1000)
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

% for parallelism
numWorkers = 14;
LoadEachWorker = nTrainDigits / numWorkers;

for testIdx = theStart:theEnd,
    min_dists = zeros(numWorkers, 1);
    min_imgs = zeros(numWorkers, 1);
    min_classes = zeros(numWorkers, 1);
    test_img = test_features(testIdx,:);

    for workerIdx = 1:numWorkers,
        min_dists(workerIdx) = inf;
        min_imgs(workerIdx) = inf;
        min_classes(workerIdx) = inf;
    end
    parfor workerIdx = 1:numWorkers,
        base = 1+(workerIdx-1)*LoadEachWorker;
        top = workerIdx*LoadEachWorker;
        workLoad = base:top;
        [md, mi, mc] = compute(base, LoadEachWorker, train_features(workLoad,:), ...
                  train_labels(workLoad), test_img);
        min_dists(workerIdx) = md;
        min_imgs(workerIdx) = mi;
        min_classes(workerIdx) = mc;
    end
    [~, index] = min(min_dists);
    min_class = min_classes(index);

    fprintf ('%d,%d\n', testIdx, min_class)
    %csvwrite(outFile, testIdx, testIdx, 0)
    %csvwrite(outFile, min_class, testIdx, 1)
end

end

function [md, mi, mc] = compute (base, Load, train_features, train_labels, test_img)
    min_dist = inf;
    min_img = inf;
    min_class = inf;
    for trainIdx = 1:Load,
        train_img = train_features(trainIdx,:);
        dist = IDM_distance(test_img, train_img);
        if dist < min_dist,
            min_dist = dist;
            min_img = trainIdx + base;
            min_class = train_labels(trainIdx);
        end
    end
    md = min_dist; 
    mi = min_img;
    mc = min_class;
end

%% NAME:
%    Computation for IDM distance
%
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
w = 1;
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
