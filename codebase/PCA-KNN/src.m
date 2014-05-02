% main function to drive the program
% 
%   Input: N: an array of number of sample size
%          T: an array of number of princeple of eigenvalue to choose
%          K: number of Nearest neighbor
%   Output: array of error based on different parameter configuration
%
clear; clc; close all;
traindat = csvread('train.csv',1,0);
testdat = csvread('test.csv',1,0);
savefile = 'traindat.mat';
save(savefile, 'traindat');
savefile = 'testdat.mat';
save(savefile, 'testdat');

load 'traindat.mat';
load 'testdat.mat';
K = 5;

%==============================================================
arrerr2 = [];   %  explore the effact of number of sample size
% iter = floor(log2(60000)); 

for N = 200: 10: 1000
    for T =20: 2: 50
        for K = 4: 10
            err = crossval(N, T, K, traindat, testdat);
            arrerr2 = [arrerr2 err]
            savefile = 'arrerr2.mat';
            save(savefile, 'arrerr2');
        end
    end
end

N = 630; T=50; K = 5;
estimate_labels(N, T, K,traindat, testdat);
