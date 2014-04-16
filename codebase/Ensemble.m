function Ensemble (filelists, outfile)

assert(length(filelists) > 0);

Predictions = [];
for fi = 1:length(filelists),
    file = filelists{fi}
    M = csvread(file, 1, 0);
    if fi == 1,
        Predictions = M(:,2);
    else
        Predictions = [Predictions M(:,2)];
    end
end
size(Predictions)

voting_result = mode (Predictions, 2);
index = 1:size(voting_result, 1);
output = [index' voting_result];

csvwrite(outfile, ['ImageId,Label'])
csvwrite(outfile, output, 1, 0)

end
