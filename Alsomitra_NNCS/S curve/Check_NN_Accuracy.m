% Colin Kessler 4.8.2024 - colinkessler00@gmail.com
clear all;clc

% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\training_data4.mat')
% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\Quad Testing\data_quad2.mat')

load('Training_Data.mat')
% nn = neuralNetwork.readONNXNetwork('model2.onnx');
% nn = neuralNetwork.readONNXNetwork('C:\Users\Colin Kessler\AI_2\model.onnx');
nn = importNetworkFromONNX('Alsomitra_Controller5.onnx',InputDataFormats='BC');

data = data3;
ex_true = data(:,8);
ex_nn1 = [];
ex_nn2 = [];
err1 = [];
err2 = [];

% scaling_params = [0.70371706, 0.11989679, 0.10076656, 0.29718315, 0.78915489];
% shifting_params = [ 2.83689013, -0.11779447, -0.03251239, -0.67161129,  0.06904406];

for i = 1:length(data)
    % ex_nn1 = [ex_nn1; agent3.predictFcn(data(i,1:6))];
    % err1 = [err1;abs(agent3.predictFcn(data(i,1:6))-ex_true(i))];
    ex_nn2 = [ex_nn2; (nn.predict(data(i,1:7))* (0.012)) + 0.181];

    err2 = [err2;abs(ex_true(i) - ex_nn2)];
end

% ex_nn2 = (ex_nn2 * (0.012)) + 0.181;

% a = corrcoef(ex_nn1,ex_true);
b = corrcoef(ex_nn2,ex_true);
% a = a(1,2);
b = b(1,2);

figure
scatter(ex_true,ex_nn2,8,'filled');hold on;
plot([-10,10],[-10,10]);
colororder(["#721f81","black"])
xlim([0.181 0.193])
ylim([0.181 0.193])

title('NN accuracy,  R = ' + string(round(b,3)) + ',  RMSE = ' + string(round(mean(err2),6)))

pbaspect([1 1 1])
xlim([min(ex_true),max(ex_true)])
ylim([min(ex_true),max(ex_true)])
ylabel("NN output")
xlabel("PID output")
