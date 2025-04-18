clc; clear all; close all
load("C:/Users/ck2049/Desktop/Data_files/adversarial_model_005_denormonnx_reach_0.mat")
R1 = R;
load("C:\Users\ck2049\Desktop/Data_files/base_model_denormonnx_reach_0.mat")
R2 = R;
% load("base_model.onnx_reach_0.2.mat")
% R2 = R;

% Plot preamble.
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

dims = [5 6];
f1 = figure ;
tiledlayout(1,3); nexttile

xlabel('$x$ [m]'); ylabel('$y$ [m]');
% title("$x$ vs $y$")
axis square; grid off
xlim([0 40])
ylim([-40 5])


hold on; box on;
projDim = dims;
h1 = [];

h4 = plot(polyshape([0 0 50 50], [-2 2 -48 -52]),'FaceColor', [0.800, 1.000, 0.800],'EdgeColor', [0.800, 1.000, 0.800],'FaceAlpha',.7,'EdgeAlpha',1);


% f = waitbar(0, 'Starting');
% R1_ = [];
% R2_ = [];
% tic
% for i = 1:10
%     R2_ = add(R2_,R2(i));
%     waitbar(i/length(R2), f, sprintf('Set 1 progress: %d %%', floor(i/length(R2)*100)));
% end
% toc

tic
h1 =  plot(R2,projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.6928    0.1651    0.5645],'EdgeColor', [0.6928    0.1651    0.5645],'FaceAlpha',.4,'EdgeAlpha',.4);
toc
% tic
% for i = 1:10
%     R1_ = add(R1_,R2(i));
%     waitbar(i/length(R2), f, sprintf('Set 2 progress: %d %%', floor(i/length(R2)*100)));
% end
% toc

tic
h2 =  plot(R1,projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.9883    0.6523    0.2114],'EdgeColor', [0.9883    0.6523    0.2114],'FaceAlpha',.4,'EdgeAlpha',.4);
toc

% for i = 1:length(R2)
%     h1 =  plot(R2(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.6928    0.1651    0.5645],'FaceAlpha',.4,'EdgeAlpha',.4);
%     waitbar(i/length(R2), f, sprintf('Progress: %d %%', floor(i/length(R2)*100)));
% end

% for i = 1:length(R1)
%     h2 =  plot(R1(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.9883    0.6523    0.2114],'FaceAlpha',.4,'EdgeAlpha',.4);
%     waitbar(i/length(R1), f, sprintf('Progress: %d %%', floor(i/length(R1)*100)));
% end


% h1 = plot(simRes2,projDim,'DisplayName','Simulations','color', [0.6928    0.1651    0.5645]);
% h2 = plot(simRes1,projDim,'DisplayName','Simulations','color', [0.9883    0.6523    0.2114]);


x_c1 = -2:1:30;
y_c1 = -1 * x_c1;
h3 = plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black');

% lgd = legend([h1 h3 h4], {"Reachable set 1",'Reachable set 3', 'Desired Trajectory'});

nexttile
hold on; box on;useCORAcolors('CORA:contDynamics');

xlabel('$x$ [m]'); ylabel('$y$ [m]');
% title("$x$ vs $y$")
axis square; grid off
xlim([30 40])
ylim([-40 -30])


h4 = plot(polyshape([0 0 50 50], [-2 2 -48 -52]),'FaceColor', [0.800, 1.000, 0.800],'EdgeColor', [0.800, 1.000, 0.800],'FaceAlpha',.7,'EdgeAlpha',.7);


% for i = 100:length(R2)
%     h1 =  plot(R2(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.6928    0.1651    0.5645],'FaceAlpha',.4,'EdgeAlpha',.4);
%     waitbar(i/length(R2), f, sprintf('Progress: %d %%', floor(i/length(R2)*100)));
% end
% 
% for i = 50:length(R1)
%     h2 =  plot(R1(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.9883    0.6523    0.2114],'FaceAlpha',.4,'EdgeAlpha',.4);
%     waitbar(i/length(R1), f, sprintf('Progress: %d %%', floor(i/length(R1)*100)));
% end
tic
plot(R2,projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.6928    0.1651    0.5645],'EdgeColor', [0.6928    0.1651    0.5645],'FaceAlpha',.4,'EdgeAlpha',.4);
toc

tic
plot(R1,projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',1,'FaceColor', [0.9883    0.6523    0.2114],'EdgeColor', [0.9883    0.6523    0.2114],'FaceAlpha',.4,'EdgeAlpha',.4);
toc

 

x_c1 = -2:1:30;
y_c1 = -1 * x_c1;
h3 = plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black');

% lgd = legend([h1 h3 h4], {"Reachable set 1",'Reachable set 3', 'Desired Trajectory'});

% for i = 1:length(R2)
%     h5 = plotOverTime(R2(i), 7, 'DisplayName', 'Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.6928    0.1651    0.5645]);
% end
% 
% for i = 1:length(R1)
%     h6 = plotOverTime(R1(i), 7, 'DisplayName', 'Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.9883    0.6523    0.2114]);
% end
% % plotOverTime(simRes2, 7, 'DisplayName', 'Simulations','color', [0.6928    0.1651    0.5645]);
% % plotOverTime(simRes1, 7, 'DisplayName', 'Simulations','color', [0.9883    0.6523    0.2114]);
% plot([0 20],[0 0],'--black');
% 
% plot([0 20],[0.05 0.05],':black');
% h7 = plot([0 20],[-0.05 -0.05],':black');
% 
lgd = legend([h1 h2 h3 h4], {"Naive NN","Adversarial NN","Target Trajectory","Target Region"});
lgd.Layout.Tile = 3;


exportgraphics(f1,'reachability_2.png','Resolution',600)