% function [completed, R,simRes, dims] = Alsomitra_Closed_Loop_Reachability_2

set(0,'DefaultFigureWindowStyle','docked')
% Parameters --------------------------------------------------------------
tic
params.tFinal = 16;

params.R0 = polyZonotope(interval( ...
    [1; 0; 0; 0; 0; 0.1/0.07; 0;],...
    [1; 0; 0; 0; 0; 0.3/0.07; 0;]));

% Reachability Settings ---------------------------------------------------

options.timeStep = 0.02;
options.alg = 'lin';
options.tensorOrder = 2;
options.taylorTerms = 5;
params.points = 25;

options.zonotopeOrder = 100;
options.intermediateOrder = 10;
options.errorOrder = 10;
polyZono.maxDepGenOrder = 50;
polyZono.maxPolyZonoRatio = 0.01;
polyZono.restructureTechnique = 'reducePca';
options.polyZono = polyZono;

% Parameters for NN evaluation --------------------------------------------

evParams = struct();
evParams.poly_method = 'regression';

options.nn = evParams;

% System Dynamics ---------------------------------------------------------
    
alsomitra = nonlinearSys(@nondimfreelyfallingplate6);
tic

nn = neuralNetwork.readONNXNetwork('Alsomitra_Controller5.onnx');
nn.evaluate(params.R0, evParams);
nn.refine(2, "layer", "both", params.R0.c, true);


sys = neurNetContrSys(alsomitra, nn, 0.5);

% Specification -----------------------------------------------------------

goalSet = interval( ...
    [-Inf;-Inf;-Inf;-Inf;-Inf;-Inf;-Inf], ...
    [ Inf; Inf; Inf; Inf; Inf; Inf; Inf] ...
);
spec = specification(goalSet, 'safeSet', interval(params.tFinal));

% Verification ------------------------------------------------------------
simRes1 = simulateRandom(sys,params);
% Reachability Analysis ---------------------------------------------------
toc
% plot(x(:,5),x(:,6))
plot(simRes1,[5,6])
daspect([1 1 1])

t = tic;
R = [];

for i = 1:10
    start_ = 0.1 + (i-1)/50;
    end_ = 0.1 + i/50;
    params.R0 = polyZonotope(interval( ...
        [1; 0; 0; 0; 0; start_/0.07; 0;],...
        [1; 0; 0; 0; 0; end_/0.07; 0;]));
    [res, X, simRes] = verify(sys, spec, params, options, evParams, true);
    R = [R; X];
end
% [res, R, simRes] = verify(sys, spec, params, options, evParams, true);



tTotal = toc(t);
disp(['Result: ' res])

% Visualization -----------------------------------------------------------
disp("Plotting..")

figure; hold on; box on;

% plot specification (over entire time horizon)
spec = specification(goalSet, 'safeSet', interval(0, params.tFinal));
% plotOverTime(spec, 3, 'DisplayName', 'Goal set');

dims = [5 6];
hold on; box on;
projDim = dims;
h1 = [];

% plot reachable sets
% useCORAcolors("CORA:contDynamics")
for i = 1:length(R)
    h1 =  plot(R(i),projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5,'FaceColor', [0 0.4470 0.7410]);
end

% plot initial set
h2 = plot(R(1).R0,projDim, 'DisplayName','Initial set','FaceColor', [1 1 1]);

% plot simulation results      
h3 = plot(simRes1,projDim,'DisplayName','Simulations','color','k');

% label plot
xlabel(['x_{',num2str(projDim(1)),'}']);
ylabel(['x_{',num2str(projDim(2)),'}']);
legend([h1 h2 h3], {"Reachable set",'Initial set', 'Simulations'})
grid on
daspect([1 1 1])

% labels and legend
xlabel('x (m)'); ylabel('y (m)');
title("Reachability of NN-controlled Alsomitra")

x_c1 = -2:1:30;
y_c1 = -1 * x_c1;

plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black')

% scatter(x_scatter * 70 / 1000,y_scatter * 70 / 1000,4,'blue')
% scatter(x_scatter,y_scatter,2,'filled','s')
% 
xlim([0 25])
ylim([-25 5])