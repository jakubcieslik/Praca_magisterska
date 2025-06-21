% Załaduj wytrenowaną sieć
load('rossler_lstm_net.mat');

% --- Wczytaj dane uczące z pliku ---
load('rossler_training_data.mat');  % dodaje zmienną train_data

% Dane testowe z drugiej symulacji
x = out_test.yout{1}.Values.Data;
y = out_test.yout{2}.Values.Data;
z = out_test.yout{3}.Values.Data;
t = out_test.yout{1}.Values.Time;

inputSeq = [x, y, z];
outputSeq = inputSeq(2:end, :);
inputSeq = inputSeq(1:end-1, :);

XTest = {inputSeq'};
YTest = {outputSeq'};

% Predykcja
YPred = predict(net, XTest{1}, 'MiniBatchSize', 1);

% RMSE – błąd średniokwadratowy
rmse = sqrt(mean((YPred - YTest{1}).^2, 'all'));

% Wykres
figure
titles = {'x(t)', 'y(t)', 'z(t)'};
test_t = t(2:end);         % t+1 testowy
train_t = train_data.t;    % t z treningu

for i = 1:3
    subplot(3,1,i)
    
    % Dane rzeczywiste z testu (niewidziane przez sieć)
    plot(test_t, YTest{1}(i,:), 'b', 'DisplayName', 'Rzeczywiste (test)')
    hold on
    
    % Dane przewidziane przez sieć
    plot(test_t, YPred(i,:), 'r--', 'DisplayName', 'Przewidziane przez sieć')

    % Dane uczące (na których trenowano)
    switch i
        case 1, plot(train_t, train_data.x, 'k:', 'DisplayName', 'Dane uczące');
        case 2, plot(train_t, train_data.y, 'k:', 'DisplayName', 'Dane uczące');
        case 3, plot(train_t, train_data.z, 'k:', 'DisplayName', 'Dane uczące');
    end
    
    ylabel(titles{i})
    legend
end
xlabel('Czas')
sgtitle(['Test sieci LSTM – RMSE = ' num2str(rmse)])
