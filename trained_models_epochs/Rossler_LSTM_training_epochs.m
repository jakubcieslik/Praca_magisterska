%Getting parameters from another file
run('Rossler_LSTM_training_params_epochs.m');

%Writing data from Simulink ports to variables
x = out.yout{1}.Values.Data;
y = out.yout{2}.Values.Data;
z = out.yout{3}.Values.Data;

%Preparing data for network
inputSeq = [x, y, z];
outputSeq = x(2:end);
inputSeq = inputSeq(1:end-1, :);

XTrain = {inputSeq'};
YTrain = {outputSeq'};

%Training networks with varying one parameter
for i = 1:length(epochs)
    %Building LSTM network
    layers = [
        sequenceInputLayer(3)
        lstmLayer(LSTM_neurons, 'OutputMode', 'sequence')
        fullyConnectedLayer(1)
        regressionLayer];
    
    %Training options
    options = trainingOptions('adam', ...
        'MaxEpochs', epochs(i), ...
        'GradientThreshold', 1, ...
        'InitialLearnRate', 0.005, ...
        'Verbose', 0, ...
        'Plots', 'training-progress');
    
    %Training network
    net = trainNetwork(XTrain, YTrain, layers, options);
    
    %Writing network to file for later testing
    name_of_network = sprintf('LSTM_2_%d_70_0_100k', epochs(i));
    save([name_of_network '.mat'], 'net');
end