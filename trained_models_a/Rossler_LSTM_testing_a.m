%Choosing all network files
ext = '.mat';
modelFiles = dir(['*' ext]);

%Get testing data
x = out.yout{1}.Values.Data;
y = out.yout{2}.Values.Data;
z = out.yout{3}.Values.Data;
t = out.yout{1}.Values.Time;

inputSeq = [x, y, z];
targetX = x(2:end);
inputSeq = inputSeq(1:end-1, :);    % adjust length
XTest = {inputSeq'};
YTest = {targetX'};

%Results
stats = struct();
YPreds = {};

for k = 1:length(modelFiles)
    modelPath = modelFiles(k).name;
    load(modelPath, 'net');

    YPred = predict(net, XTest{1}, 'MiniBatchSize', 1);
    YPreds{k} = YPred;

    err = YPred - YTest{1};
    stats(k).name = modelFiles(k).name;
    stats(k).RMSE = sqrt(mean(err.^2));
    stats(k).MAE = mean(abs(err));
    stats(k).MaxError = max(abs(err));
end

%Sorting table stats by RMSE
[~, sortIdx] = sort([stats.RMSE]);
stats = stats(sortIdx);
YPreds = YPreds(sortIdx);

%X variable chart
figure(1)
test_t = t(2:end);
plot(test_t, YTest{1}, 'k', 'DisplayName', 'Real data')
hold on
colors = lines(length(YPreds));
for k = 1:length(YPreds)
    plot(test_t, YPreds{k}, '--', 'Color', colors(k,:), ...
        'DisplayName', sprintf('%d: %s network', k, stats(k).name));
end
title('Porównanie wyników predykcji zmiennej X')
xlabel('Time')
ylabel('x(t+1)')
legend('Interpreter', 'none')
grid on

%Comparison table
figTable = uifigure('Name', 'Tabela wyników', 'Position', [100 100 900 300]);
f = uitable(figTable);
f.Data = [string({stats.name})', ...
          [stats.RMSE]', ...
          [stats.MAE]', ...
          [stats.MaxError]'];
f.ColumnName = {'Model', 'RMSE', 'MAE', 'Max Error'};
f.ColumnWidth = {250, 'auto', 'auto', 'auto'};
f.Position = [20 20 800 200];
f.RowName = [];
