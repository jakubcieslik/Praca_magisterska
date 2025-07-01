%
%Getting parameters from another file
run('Rossler_LSTM_training_params_selectedsamples.m');

%Writing data from Simulink ports to variables
x = out.yout{1}.Values.Data;
y = out.yout{2}.Values.Data;
z = out.yout{3}.Values.Data;

SelectedSamples = [1, 2, 5, 10, 20];


for i = 1:length(SelectedSamples)
    %Choosing 1 out of SelectedSamples(i) samples to simulate insufficient
    %sampling speed by real ADC
    x = x(1:SelectedSamples(i):end);
    y = y(1:SelectedSamples(i):end);
    z = z(1:SelectedSamples(i):end);
    
    %Preparing data for network
    inputSeq = [x, y, z];
    outputSeq = x(2:end);
    inputSeq = inputSeq(1:end-1, :);
    
    XTrain = {inputSeq'};
    YTrain = {outputSeq'};
    
    %Training networks with varying one parameter

    %Building LSTM network
    layers = [
        sequenceInputLayer(3)
        lstmLayer(LSTM_neurons, 'OutputMode', 'sequence')
        fullyConnectedLayer(1)
        regressionLayer];
    
    %Training options
    options = trainingOptions('adam', ...
        'MaxEpochs', epochs, ...
        'GradientThreshold', 1, ...
        'InitialLearnRate', 0.005, ...
        'Verbose', 0, ...
        'Plots', 'training-progress');
    
    %Training network
    net = trainNetwork(XTrain, YTrain, layers, options);
    
    %Writing network to file for later testing
    name_of_network = sprintf('LSTM_30_70_90_2_%d', 100000/SelectedSamples(i));
    save([name_of_network '.mat'], 'net');
end