function [completed, R,simRes, dims] = Alsomitra_Closed_Loop_Reachability_2


% Parameters --------------------------------------------------------------
tic
params.tFinal = 2;

params.R0 = polyZonotope(interval( ...
    [1; 0; 0; 0; 0; -4/0.07; 0;],...
    [1; 0; 0; 0; 0; -0/0.07; 0;]));

% Reachability Settings ---------------------------------------------------

options.timeStep = 0.01;
options.alg = 'lin';
options.tensorOrder = 2;
options.taylorTerms = 1;
options.zonotopeOrder = 80;

% Parameters for NN evaluation --------------------------------------------

evParams = struct();
evParams.poly_method = 'regression';

% System Dynamics ---------------------------------------------------------
    
alsomitra = nonlinearSys(@nondimfreelyfallingplate6);
tic

nn = neuralNetwork.readONNXNetwork('Alsomitra_Controller4.onnx');
nn.evaluate(params.R0, evParams);
nn.refine(2, "layer", "both", params.R0.c, true);


sys = neurNetContrSys(alsomitra, nn, 1);

% Specification -----------------------------------------------------------

goalSet = interval( ...
    [-Inf;-Inf;-Inf;-Inf;-Inf;-Inf;-Inf], ...
    [ Inf; Inf; Inf; Inf; Inf; Inf; Inf] ...
);
spec = specification(goalSet, 'safeSet', interval(params.tFinal));

% Verification ------------------------------------------------------------

t = tic;
[res, R, simRes] = verify(sys, spec, params, options, evParams, true);
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

% plot reachable sets
useCORAcolors("CORA:contDynamics")
plot(R,projDim,'DisplayName','Reachable set','Unify',true,'UnifyTotalSets',5);

% plot initial set
plot(R(1).R0,projDim, 'DisplayName','Initial set');

% plot simulation results      
plot(simRes,projDim,'DisplayName','Simulations');

% label plot
xlabel(['x_{',num2str(projDim(1)),'}']);
ylabel(['x_{',num2str(projDim(2)),'}']);
legend()
grid on
daspect([1 1 1])

% labels and legend
xlabel('x (m)'); ylabel('y (m)');
title("Reachability of NN-controlled Alsomitra")
