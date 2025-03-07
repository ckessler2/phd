clear; clc; close all

nn = importNetworkFromONNX('base_model.onnx',InputDataFormats='BC');

T = readtable("Y_test.csv");
T = table2array(T);

nn_output = [];
load('Training_Data.mat')

for n=1:36
    nn_output = [nn_output;(nn.predict((data(T(n,1)+1,1:7)) .* [1 1 1 1 0 0 1]))];
end

figure; hold on

scatter(T(:,2),T(:,3),"rx")
scatter(T(:,2),nn_output,"b.")

xlim([0.181 0.193])
ylim([0.181 0.193])

plot([0 1],[0 1],"--k")
daspect([1 1 1])

ylabel("NN output")
xlabel("True value")

legend("Python model","Matlab model","Ground truth")