% Colin Kessler 4.8.2024 - colinkessler00@gmail.com
clear all;clc

% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\training_data4.mat')
% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\Quad Testing\data_quad2.mat')

figure
tiledlayout("horizontal")
nexttile

nn = importNetworkFromONNX('base_model.onnx',InputDataFormats='BC');
plot_results(nn,"base")

nexttile
nn = importNetworkFromONNX('adversarial_model.onnx',InputDataFormats='BC');
plot_results(nn,"adversarial")

function plot_results(nn,name)
    load('Training_Data.mat')
    ex_true = data(:,8);
    ex_nn1 = [];
    ex_nn2 = [];
    err1 = [];
    err2 = [];
    
    load("Normalisation_Constants.mat")
    Cs = data2(1,:);
    Ss = data2(2,:);
    
    for i = 1:length(data)
        ex_nn2 = [ex_nn2; (nn.predict(data(i,1:7))* (0.012)) + 0.181];
        err2 = [err2;abs(ex_true(i) - ex_nn2)];
    end
    
    b = corrcoef(ex_nn2,ex_true);
    b = b(1,2);
    
    scatter(ex_true,ex_nn2,8,'filled');hold on;
    plot([-10,10],[-10,10]);
    colororder(["#721f81","black"])
    xlim([0.181 0.193])
    ylim([0.181 0.193])
    
    title(name + ' model NN accuracy,  R = ' + string(round(b,3)) + ',  RMSE = ' + string(round(mean(err2),6)))
    
    pbaspect([1 1 1])
    xlim([min(ex_true),max(ex_true)])
    ylim([min(ex_true),max(ex_true)])
    ylabel("NN output")
    xlabel("PID output")
end
