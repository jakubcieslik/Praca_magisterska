% Dane z pierwszej symulacji
x = out_train.yout{1}.Values.Data;
y = out_train.yout{2}.Values.Data;
z = out_train.yout{3}.Values.Data;

inputSeq = [x, y, z];
outputSeq = inputSeq(2:end, :);
inputSeq = inputSeq(1:end-1, :);

XTrain = {inputSeq'};
YTrain = {outputSeq'};

% Sieć
layers = [
    sequenceInputLayer(3)
    lstmLayer(50, 'OutputMode', 'sequence')
    fullyConnectedLayer(3)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

net = trainNetwork(XTrain, YTrain, layers, options);

% Zapisz sieć do pliku
save('LSTM_2_50_50_0_100k.mat', 'net');