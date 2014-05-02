function  estimate_labels( N, T, K,traindat, testdat)
%ESTIMATE Summary of this function goes here
%   Detailed explanation goes here
    trainLabels = traindat(:,1);
    A = traindat(:,2:785);
    B = testdat;
    
    B = B'; A = A';
    [~,trainK] = size(A);
    [~,testK] = size(B);

    sample_A = zeros(784, N);
    ridxarr = randperm(trainK);
    for j = 1 : N
        
        random_int  = ridxarr(j);
        sample_A(:,j) = A(:,random_int);
    end
    
    [~, V3] = FindEigendigits(sample_A);
    P = V3(:, 1:T);
    P = P';
    
    
    temp_ave = mean(A,2);
    A_mean = double(A - repmat(temp_ave, 1, trainK));
    
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

    
    est_labels = [(1:testK)' est_labels'];
    csvwrite('digit.csv',est_labels);
    
    
    
end

