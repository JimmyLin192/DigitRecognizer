function Ensemble (filelists, outfile)

assert(length(filelists) > 0);

Predictions = [];
for fi = 1:length(filelists),
    file = filelists[fi]
    M = csvread(file, 1, 0)
    if fi == 1,
        Predictions = M;
    else:
        Predictions = [Predictions M];
    end
end

voting_result = mode (Predictions, 2);

csvwrite(outfile, ['ImageId' 'Label'])
csvwrite(outfile, voting_result, 1, 0)

end
