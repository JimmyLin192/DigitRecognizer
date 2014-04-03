% Neural Network for multi-class classification problem
% Author: Jimmy Lin
% Note that the input hiddenNodes does not include intercept node
% sample input: [300 200 100 50]
% README:  A{1}(4) input of hidden node at layer 1 indexed by 4
%    A - input of each layer node
%    Z - activated value of each node
%    WEIGHTS - 
function NN(hiddenNodes, iterations, trainInFile, testInFile, testOutFile)
% TODO:
%  0. fine-tune batch-size, 100 average error as one update
%  1. fine-tune learning rate, 
%  2. fine-tune activation function, tan, exp, ...
% 
alpha = 0.8;
nHiddenLayers = length(hiddenNodes);
assert(nHiddenLayers > 0)

trainData = csvread(trainInFile);
labels = trainData(:,1);
features = trainData(:,2:size(trainData,2));
nDigits = size(trainData, 1);
nFeatures = size(features, 2);
nClasses = length(unique(labels));

testData = csvread(testInFile);

nLayers = nHiddenLayers+1; % exclude the input layer
% initiailize the weights
WEIGHTS = cell(1, nLayers);
% the weight between input layer and first hidden layer
WEIGHTS{1} = rand(hiddenNodes(1), nFeatures+1);
% weights between hidden layer
for layerIdx = 2:nHiddenLayers,
    WEIGHTS{layerIdx} = rand(hiddenNodes(layerIdx), hiddenNodes(layerIdx-1)+1)
end
% weigths between last hidden layer and output layer
WEIGHTS{nLayers} = randn(nClasses, hiddenNodes(nHiddenLayers)+1);

% training period
fprintf('Start training NN!\n')
for iter = 1:iterations,
    fprintf('Iteration %d Starts\n', iter)
    errors = [];
    for i = 1:nDigits,
        label = labels(i);
        feat = features(i,:)';
        target = zeros(nClasses,1);
        target(label+1) = 1;
        % forward stage
        [A, Z] = forward(feat, hiddenNodes, WEIGHTS);
        
        % backward stage
        [E, e] = backward(target, hiddenNodes, A, Z, WEIGHTS);
        errors = [errors e];

        % update the weight
        WEIGHTS{1} = WEIGHTS{1} - alpha * E{1} * [1; feat]';
        for layerIdx = 2:nLayers,
            WEIGHTS{layerIdx} = WEIGHTS{layerIdx} - alpha* E{layerIdx} * [1; Z{layerIdx-1}]';
        end
    end
    fprintf('Iteration %d Ends with mean error %f\n', iter, mean(errors))
end
fprintf('Training NN Completes!\n')

% testing period
fprintf('Apply trained NN on testing set!\n')
predictions = [];
for i = 1:size(testData,1),
    feat = testData(i,:)';
    [~, Z] = forward(feat, hiddenNodes, WEIGHTS);
    [~, plabel] = max(Z{nLayers});
    predictions = [predictions; i plabel-1]; % compensate the label offset
end
fprintf('Testing set completes!\n')

predictions
% output to external file
csvwrite(testOutFile, predictions)
end

function [A,Z] = forward(feature, hiddenNodes, WEIGHTS)
        nLayers = length(WEIGHTS);
        nHiddenLayers = length(hiddenNodes);
        % initialize value matrix
        A = cell(1, nLayers);
        Z = cell(1, nLayers);
        A{1} = WEIGHTS{1} * [1; feature];
        Z{1} = tan(A{1});
        % hidden layer
        for layerIdx = 2:nHiddenLayers,
            A{layerIdx} = WEIGHTS{layerIdx} * [1; Z{layerIdx-1}];
            Z{layerIdx} = tan(A{layerIdx});
        end
        % output layer
        A{nLayers} = WEIGHTS{nLayers} * [1; Z{nHiddenLayers}];
        Z{nLayers} = SoftMax(A{nLayers});
end

function [E,error] = backward(target, hiddenNodes, A, Z, WEIGHTS)
        error = 0.0;
        nLayers = length(WEIGHTS);
        nHiddenLayers = length(hiddenNodes);
        E = cell(1, nLayers);
        % output layer
        E{nLayers} = Z{nLayers} - target;
        for layerIdx = nHiddenLayers:-1:1,
            E{layerIdx} = zeros(hiddenNodes(layerIdx),1);
            for j = 1:hiddenNodes(layerIdx),
                E{layerIdx}(j) = sec(A{layerIdx}(j))^2 * (WEIGHTS{layerIdx+1}(:,j)' * E{layerIdx+1});
            end
        end
        error = error + sum(abs(E{nLayers}));
end

function y = SoftMax(x)
    expv = exp(x-max(x));
    sumExp = sum(expv);
    y = expv / sumExp;
end
