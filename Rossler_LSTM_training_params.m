%Parameters for training LSTM network. Number of neurons in hidden layer
%can be changed by 'LSTM_neurons' variable. Number of epochs can be changed
%by 'epochs' variable.
LSTM_neurons = 60;
name_of_network = sprintf('LSTM_2_50_LSTM_%d_0_100k', LSTM_neurons);
epochs = 50;