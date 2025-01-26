load("base_model.onnx_reach_0.mat")
R0 = R;
% load("base_model.onnx_reach_01.mat")
% R1 = R;
load("base_model.onnx_reach_0.2.mat")
R2 = R;


dims = [5 6];
f1 = figure ;

hold on; box on;
projDim = dims;
h1 = [];

% 
for i = 1:length(R2)
    h1 =  plot(R2(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.267, 0.004, 0.329]);
end

for i = 1:length(R1)
    h2 =  plot(R1(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.129, 0.565, 0.549]);
end

for i = 1:length(R0)
    h3 =  plot(R0(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0.992, 0.906, 0.145]);
end


x_c1 = -2:1:30;
y_c1 = -1 * x_c1;
h4 = plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black');

% lgd = legend([h1 h2 h3 h4], {"Reachable set 1",'Reachable set 2', 'Reachable set 3', 'Desired Trajectory'});
xlabel('$x$ (m)'); ylabel('$y$ (m)');
title("Base model $x$ vs $y$")

axis square;
xlim([0 40])
ylim([-40 5])