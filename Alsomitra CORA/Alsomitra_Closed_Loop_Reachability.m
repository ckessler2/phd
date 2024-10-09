function [completed, R,simRes, dims] = Alsomitra_Closed_Loop_Reachability


% Parameters --------------------------------------------------------------
tic
params.tFinal = 15;

w = 2/0.07;
k = zeros(7,7);
k(6,6) = 2/0.07;
% params.R0 = zonotope([zeros(7,1),k]);
params.points = 25;

params.R0 = polyZonotope(interval( ...
    [1; 0; 0; 0; 0; -4/0.07; 0;],...
    [1; 0; 0; 0; 0; 0/0.07; 0;]));

% params.R0 = zonotope([zeros(6,1),0.05*diag(ones(6,1))]);
% params.U = zonotope(0.193);
% params.u = 0.181;

params.x0 = [1;0;0;0;0;0;2];
% Reachability Settings ---------------------------------------------------

options.points = 250;
options.type = 'standard';
options.timeStep = 0.2;  
options.taylorTerms = 20;
options.zonotopeOrder = 50;
options.alg = 'lin';
options.tensorOrder = 2;
options.errorOrder = 10;


options.intermediateOrder = 50;
options.polyZono.maxPolyZonoRatio = 1;
options.polyZono.maxDepGenOrder = 2;

% options.lagrangeRem.simplify = 'simplify';
% options.lagrangeRem.method = 'taylorModel';
evParams = struct();
evParams.poly_method = 'regression';

% System Dynamics ---------------------------------------------------------
    
alsomitra = nonlinearSys(@nondimfreelyfallingplate6,7,1);
tic

nn = neuralNetwork.readONNXNetwork('Alsomitra_Controller4.onnx');
params.U = nn.evaluate(params.R0, evParams);
% nn.refine(2, "layer", "both", params.R0.c, true);


sys = neurNetContrSys(alsomitra, nn, 1);

% [t,x] = simulate(alsomitra,params);
simRes = simulateRandom(sys,params);
% Reachability Analysis ---------------------------------------------------
toc
% plot(x(:,5),x(:,6))
plot(simRes,[5,6])
daspect([1 1 1])
tic
R = reach(sys, params, options, evParams);
tComp = toc;
disp(['computation time of reachable set: ',num2str(tComp)]);


% Simulation --------------------------------------------------------------

% simOpt.points = 10;
% simRes = simulateRandom(alsomitra, params, simOpt);


% Visualization -----------------------------------------------------------

dims = {[1 2],[3 4],[5 6]};
figure;

for k = 1:length(dims)

    subplot(1,3,k); 
    hold on; box on;
    projDim = dims{k};

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
end
hold on; box on;
k=3;
projDim = dims{k};

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
grid off
% daspect([1 1 1])

toc

% example completed
completed = true;

% ------------------------------ END OF CODE ------------------------------
