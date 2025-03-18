% load("base_model.onnx_reach_0.mat")
% R0 = R;
% % load("base_model.onnx_reach_01.mat")
% % R1 = R;
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

hold on; box on;
projDim = dims;
h1 = [];


for i = 1:length(R2)
    h1 =  plot(R2(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.6928    0.1651    0.5645]);
end

for i = 1:length(R1)
    h2 =  plot(R1(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.9883    0.6523    0.2114]);
end


% h1 = plot(simRes2,projDim,'DisplayName','Simulations','color', [0.6928    0.1651    0.5645]);
% h2 = plot(simRes1,projDim,'DisplayName','Simulations','color', [0.9883    0.6523    0.2114]);
 

x_c1 = -2:1:30;
y_c1 = -1 * x_c1;
h4 = plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black');

% lgd = legend([h1 h3 h4], {"Reachable set 1",'Reachable set 3', 'Desired Trajectory'});

xlabel('$x$ [m]'); ylabel('$y$ [m]');
title("$x$ vs $y$")
axis square; grid on
xlim([0 40])
ylim([-40 5])


nexttile
hold on; box on;useCORAcolors('CORA:contDynamics');

for i = 1:length(R2)
    h5 = plotOverTime(R2(i), 7, 'DisplayName', 'Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.6928    0.1651    0.5645]);
end

for i = 1:length(R1)
    h6 = plotOverTime(R1(i), 7, 'DisplayName', 'Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.9883    0.6523    0.2114]);
end
% plotOverTime(simRes2, 7, 'DisplayName', 'Simulations','color', [0.6928    0.1651    0.5645]);
% plotOverTime(simRes1, 7, 'DisplayName', 'Simulations','color', [0.9883    0.6523    0.2114]);
plot([0 20],[0 0],'--black');

plot([0 20],[0.05 0.05],':black');
h7 = plot([0 20],[-0.05 -0.05],':black');

lgd = legend([h1 h2 h4 h7], {"$y_0 \in [1.429, 4.286]$",'$y_0 \in [-1.429, 7.143]$', 'Desired Trajectory', 'Desired Trajectory \pm 0.05'});
lgd.Layout.Tile = 3;

xlabel('$t$ [s]');
ylabel('$y$ error [m]');
title("$y_{\textnormal{error}}$ vs time")
axis square; grid on
xlim([0 20])

exportgraphics(f1,'reachability_2.png','Resolution',600)