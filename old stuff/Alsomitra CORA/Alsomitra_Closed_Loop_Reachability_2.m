% function [completed, R,simRes, dims] = Alsomitra_Closed_Loop_Reachability_2

set(0,'DefaultFigureWindowStyle','docked')
% Parameters --------------------------------------------------------------
tic
params.tFinal = 4;
w = 0.1;

start_ = 0.1;
end_ = 0.3;

params.R0 = polyZonotope(interval( ...
        [1; 0; 0; 0; 0-w; start_/0.07-w; 0;],...
        [1; 0; 0; 0; 0+w; end_/0.07+w; 0;]));

% Reachability Settings ---------------------------------------------------

options.timeStep = 0.01;
options.alg = 'lin';
options.tensorOrder = 2;
options.taylorTerms = 50;
params.points = 25;

options.zonotopeOrder = 100;
options.intermediateOrder = 10;
options.errorOrder = 20;
polyZono.maxDepGenOrder = 50;
polyZono.maxPolyZonoRatio = 0.01;
polyZono.restructureTechnique = 'reducePca';
options.polyZono = polyZono;

% Parameters for NN evaluation --------------------------------------------

evParams = struct();
% evParams.poly_method = 'regression';

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
plot(simRes1,[5,6])
daspect([1 1 1])

t = tic;
R = [];

segments = 24;
for i = 1:1
    n = segments/0.2;
    start_ = 0.1 + (i-1)/n;
    end_ = 0.1 + i/n;
    params.R0 = polyZonotope(interval( ...
            [1; 0; 0; 0; 0-w; start_/0.07-w; 0;],...
            [1; 0; 0; 0; 0+w; end_/0.07+w; 0;]));
    [res, X, simRes] = verify(sys, spec, params, options, evParams, true);

    % figure; hold on
    % goalSet3 = interval([-999;-999;-999;-999;0;0;-sqrt(2)*0.3 * 0.07;],[999;999;999;999;0;0;sqrt(2)*0.3 * 0.07;]);
    % spec = specification(goalSet3, 'safeSet',interval(0, params.tFinal));
    % plotOverTime(spec, 7, 'DisplayName', 'Goal set');
    % plotOverTime(X, 7, 'DisplayName', 'Reachable set','FaceColor', [0 0.4470 0.7410]);

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


plot_alsomitra_reachability