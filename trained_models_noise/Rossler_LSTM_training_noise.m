%This program is designed to train 6 networks based on data stored in 6
%datasets called: out_0, out_0_001, out_0_002, out_0_005, out_0_01, out_0_1. Data sets are made by
%Rossler_model program and each set coresponds to different values of
%noise amplitude. Level of noise is also written in name of a set. On example
%out_0_001 has a noise level = 0.001, out_0_01 has value a = 0.01 etc.
%This program will work properly only if you have this 6 sets of data with
%exact names as given above stored in matlab workspace memory. If u dont
%have this files you have to make this by running Rossler_model programm
%and saving output with proper names.

%Getting parameters from another file
run('Rossler_LSTM_training_params_noise.m');

%Subsequent values of noise level (multiplied by 1000 to avoid dots in name of file)
NoiseLevel = [0, 1, 2, 5, 10, 100];


for i = 1:length(NoiseLevel)
    out = eval(sprintf('out_%d', a_values(i)));
    
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
    name_of_network = sprintf('LSTM_30_70_90_%d_100k', NoiseLevel(i));
    save([name_of_network '.mat'], 'net');
end