function DPNN(inTrainFile, inTestFile, outfile)

%inTrainFile = '../data/PCA_train.csv';
%inTestFile = '../data/PCA_test.csv';
%outfile = '../result/PCA_DPNN.csv';

inTrainData = csvread(inTrainFile);
inTestData = csvread(inTestFile);

train_x = double(inTrainData(:, 2:size(inTrainData,2))) / 255.0;
train_y = double(inTrainData(:, 1));
test_x = double(inTestData) / 255.0;

% normalize
[train_x, mu, sigma] = zscore(train_x);
test_x = normalize(test_x, mu, sigma);

%% ex2 neural net with L2 weight decay
rand('state',0);
nn = nnsetup([100 50 10]);

nn.weightPenaltyL2 = 1e-4;  %  L2 weight decay
nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.learningRate = 1;                %  Sigm require a lower learning rate
nn.output              = 'softmax';    %  use softmax output
opts.numepochs =  1;        %  Number of full sweeps through data
opts.batchsize = 100;       %  Take a mean gradient step over this many
opts.plot              = 1;            %  enable plotting

size(train_x)
size(train_y)
nn = nntrain(nn, train_x, train_y, opts);

labels = nnpredict(nn, test_x);

csvwrite(outfile, labels)

