% Colin Kessler 4.8.2024 - colinkessler00@gmail.com
clear;clc

% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\training_data4.mat')
% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\Quad Testing\data_quad2.mat')

load('Training_Data.mat')
% nn = neuralNetwork.readONNXNetwork('model2.onnx');
% nn = neuralNetwork.readONNXNetwork('C:\Users\Colin Kessler\AI_2\model.onnx');
nn = importONNXNetwork('alsomitra_controller2.onnx',InputDataFormats='BC');

ex_true = data(:,8);
ex_nn1 = [];
ex_nn2 = [];
err1 = [];
err2 = [];


for i = 1:length(data)
    % ex_nn1 = [ex_nn1; agent3.predictFcn(data(i,1:6))];
    % err1 = [err1;abs(agent3.predictFcn(data(i,1:6))-ex_true(i))];
    ex_nn2 = [ex_nn2; nn.predict(data(i,1:7))];
    err2 = [err2;abs(nn.predict(data(i,1:7))-ex_true(i))];
end
% a = corrcoef(ex_nn1,ex_true);
b = corrcoef(ex_nn2,ex_true);
% a = a(1,2);
b = b(1,2);

figure
scatter(ex_true,ex_nn2,8,'filled');hold on;
plot([-10,10],[-10,10]);
colororder(["#721f81","black"])

title('NN accuracy,  R = ' + string(round(b,3)) + ',  MAE = ' + string(round(mean(err2),6)))

pbaspect([1 1 1])
xlim([min(ex_true),max(ex_true)])
ylim([min(ex_true),max(ex_true)])
ylabel("NN output")
xlabel("PID output")
