function err = crossval(N, T, K,traindat, ~)
% 
%   Input: 
%       N: number of sample size we take 
%       T: number of Eigenvalue and Eigenvector we take 
%       K: number of Nearest neighbor
%   Output:
%       err: error
%
%   Usage: err = MyExperiment(N, T, K)
%


if nargin < 1
    N = 100;
end
if nargin < 2
    T = 100;
end
if nargin < 3
    K = 10;
end

err = [];

trainLabels_org = traindat(:,1);

A = traindat(:,2:785);

% implement cross validation. Ten fold 
for i = 1: 10
    B = A((i-1)*4200+1: i*4200, :);
    testLabels = trainLabels_org((i-1)*4200+1: i*4200,1); 
    
    A1 = A;  A1((i-1)*4200+1: i*4200,:) = [];

    trainLabels = trainLabels_org;
    trainLabels((i-1)*4200+1: i*4200,:) = []; 
    
    B = B'; A1 = A1';

[~,trainK] = size(A1);
[~,testK] = size(B);



sample_A = zeros(784, N);
ridxarr = randperm(trainK);
for j = 1 : N
   
    random_int  = ridxarr(j);
    sample_A(:,j) = A1(:,random_int);  
end    

[~, V3] = FindEigendigits(sample_A);
P = V3(:, 1:T);
P = P';


temp_ave = mean(A1,2);
A_mean = double(A1 - repmat(temp_ave, 1, trainK));

trainmatrix = P * A_mean;

temp_ave = mean(B,2);
B_mean = double(B - repmat(temp_ave, 1, testK));

testmatrix = P * B_mean;

[~,Index] = pdist2(trainmatrix',testmatrix','euclidean','Smallest',K);


est_labels = ones(1, testK)*(-1);
for k = 1 : testK
    label = trainLabels(Index(:, k));
    est_labels(k) = mode(double(label));
end


err = [err length(find(est_labels' ~= testLabels)) / length(testLabels)];

% plot the graph, set as comment to prvent slowing the program
%=====================plot the reconstruction images===========
% subplot (2,3,1), imshow(reshape(B(:,3),28,28));
% subplot (2,3,4), imshow(reshape((pinv(P)*testmatrix(:,3)),28,28));
% subplot (2,3,2), imshow(reshape(B(:,2),28,28));
% subplot (2,3,5), imshow(reshape((pinv(P)*testmatrix(:,2)),28,28));
% subplot (2,3,3), imshow(reshape(B(:,1),28,28));
% subplot (2,3,6), imshow(reshape((pinv(P)*testmatrix(:,1)),28,28));

% subplot (2,3,1), imshow(reshape(B(:,6810),28,28));
% subplot (2,3,4), imshow(reshape((pinv(P)*testmatrix(:,6810)),28,28));
% subplot (2,3,2), imshow(reshape(B(:,6811),28,28));
% subplot (2,3,5), imshow(reshape((pinv(P)*testmatrix(:,6811)),28,28));
% subplot (2,3,3), imshow(reshape(B(:,6816),28,28));
% subplot (2,3,6), imshow(reshape((pinv(P)*testmatrix(:,6816)),28,28));

%%=============== plot eigenvector figures ==========
%[height, width] = size(I);
%neig = 64;
%MTEigenV = zeros(height, width, 1, neig);
%for i = 1 : neig
%   MTEigenV(:, :, 1, i) = reshape(MyRescale(P(i, :), 0, 1), height, width);
%end
%colormap('jet');
%montage(MTEigenV);


end

err = mean(err);

end






