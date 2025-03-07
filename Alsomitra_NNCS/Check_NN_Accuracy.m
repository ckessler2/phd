% Colin Kessler 4.8.2024 - colinkessler00@gmail.com
clear all;clc

% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\training_data4.mat')
% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\CORA2\Scripts\Quad Testing\data_quad2.mat')
set(0,'DefaultFigureWindowStyle','docked')
set(0, 'defaultFigureRenderer', 'painters')
set(0,'DefaultFigureWindowStyle','docked')
font=12;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 0.5);

f1 = figure
tiledlayout('flow');
nexttile

datafile = 'adversarial_data_0.005.csv';

nn = importNetworkFromONNX('base_model_2.onnx',InputDataFormats='BC');
L0 = lipschitz_robustness(nn,datafile);
plot_results(nn,{"Naive model ($\epsilon=0$)"})

% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.0005_Norm.onnx',InputDataFormats='BC');
% L1 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"$\epsilon=0.0005$")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.001_Norm.onnx',InputDataFormats='BC');
% L2 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"$\epsilon=0.001$")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.002_Norm.onnx',InputDataFormats='BC');
% L3 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"$\epsilon=0.002$")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.005_Norm.onnx',InputDataFormats='BC');
% L4 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"$\epsilon=0.005$")
% 
% answer = [L0;L1;L2;L3;L4];
% exportgraphics(f1,'Regression_Performance.pdf','ContentType','vector')


% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.01_Norm.onnx',InputDataFormats='BC');
% L3 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"adversarial (0.01)")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.02_Norm.onnx',InputDataFormats='BC');
% L4 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"adversarial (0.02)")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.04_Norm.onnx',InputDataFormats='BC');
% L5 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"adversarial (0.04)")
% 
% nexttile
% nn = importNetworkFromONNX('adversarial_model_0.08_Norm.onnx',InputDataFormats='BC');
% L6 = lipschitz_robustness(nn,datafile);
% plot_results(nn,"adversarial (0.08)")
% answer = [L0;L1;L2;L3;L4;L5;L6];


function L = lipschitz_robustness(nn,datafile)

    load('Training_Data.mat') 
    % T1 = readtable('adversarial_data_0.005.csv');
    % T2 = readtable('adversarial_data_0.01.csv');
    % T3 = readtable('adversarial_data_0.02.csv');
    % T4 = readtable('adversarial_data_0.04.csv');
    % T1 = table2array(T1);
    % T2 = table2array(T2);
    % T3 = table2array(T3);
    % T4 = table2array(T4);
    % T = [T1;T2;T3;T4];
    T = readtable(datafile);
    T = table2array(T);
    L = [];
    
    for i = 1:length(data)
        eucs = [];
        for j = 1:length(T)
            euc = sqrt(sum((data(i,1:7) - T(j,1:7)) .^ 2));
            eucs = [eucs;euc];
        end
        [dist,index] = min(eucs);

        x = T(index,1:7); 
        y = data(i,1:7);
        fx = nn.predict(x);
        fy= nn.predict(y);

        L1 = abs(fx-fy)./abs(x-y);
        L = [L;max(L1)];
    end
    
    L = mean(L);
end


function plot_results(nn,name)
    load('Training_Data.mat')
    % load('Normalised_Data.mat')
    % data = normalized_matrix;
    ex_true = data(:,8);
    ex_nn1 = [];
    ex_nn2 = [];
    err1 = [];
    err2 = [];
    
    load("Normalisation_Constants.mat")
    % Cs = data2(1,:);
    % Ss = data2(2,:);
    
    for i = 1:length(data)
        % ex_nn2 = [ex_nn2; (nn.predict(data(i,1:7))* (0.012)) + 0.181];
        ex_nn2 = [ex_nn2; (nn.predict(data(i,1:7)))];
        err2 = [err2;abs(ex_true(i) - ex_nn2)];
    end
    
    b = corrcoef(ex_nn2,ex_true);
    b = b(1,2);
    
    scatter(ex_true,ex_nn2,4,'filled','MarkerFaceColor',[0.0504    0.0298    0.5280],'MarkerEdgeColor',[0.0504    0.0298    0.5280]);hold on;
    plot([-10,10],[-10,10]);
    colororder(["#721f81","black"])
    xlim([0.181 0.193])
    ylim([0.181 0.193])
    
    % % title(name + ' R = ' + string(round(b,6)) + ',  RMSE = ' + string(round(mean(err2),6)))
    title(name)
    
    pbaspect([1 1 1])
    xlim([min(ex_true),max(ex_true)])
    ylim([min(ex_true),max(ex_true)])
    ylabel("NN output")
    xlabel("True value")
end
