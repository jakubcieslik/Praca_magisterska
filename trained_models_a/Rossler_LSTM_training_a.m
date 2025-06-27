%This program is designed to train 5 networks based on data stored in 5
%datasets called: out_20, out_25, out_30, out_35, out_38. Data sets are made by
%Rossler_model program and each set coresponds to different values of
%parameter a. Value of a is also written in name of a set. On example
%out_20 has a value = 0.2, out_25 has value a = 0.25 etc.
%This program will work properly only if you have this 5 sets of data with
%names as given above stored in matlab workspace memory.

%Getting parameters from another file
run('Rossler_LSTM_training_params_a.m');

%Subsequent values of a (multiplied by 100 to avoid dots in name of file)
a_values = [20, 25, 30, 35, 38];

for i = 1:length(a_values)
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
    name_of_network = sprintf('LSTM_%d_70_90_0_100k', a_values(i));
    save([name_of_network '.mat'], 'net');
end