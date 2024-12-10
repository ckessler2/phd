clc;clear

previousRngState = rng(0,"twister");
open_system("alsomitra_RL3");

% Observation info
obsInfo = rlNumericSpec([3 1],...
    LowerLimit=[-inf -inf -inf ]',...
    UpperLimit=[inf inf inf]');

% Action info
actInfo = rlNumericSpec([1 1], ...
    LowerLimit=[0.106]',...
    UpperLimit=[0.193]');

actInfo.Name = "e_x";

env = rlSimulinkEnv("alsomitra_RL3","alsomitra_RL3/RL Agent",...
    obsInfo,actInfo);

Ts = 1.0;
Tf = 16;

% Observation path
obsPath = featureInputLayer(obsInfo.Dimension(1), ...
    Name="obsInLyr");

% Action path
actPath = featureInputLayer(actInfo.Dimension(1), ...
    Name="actInLyr");

% Common path
commonPath = [
    concatenationLayer(1,2,Name="concat")
    fullyConnectedLayer(25)
    reluLayer()
    fullyConnectedLayer(25)
    reluLayer()
    fullyConnectedLayer(1,Name="QValue")
    ];

% Create the network object and add the layers
criticNet = dlnetwork();
criticNet = addLayers(criticNet,obsPath);
criticNet = addLayers(criticNet,actPath);
criticNet = addLayers(criticNet,commonPath);

% Connect the layers
criticNet = connectLayers(criticNet, ...
    "obsInLyr","concat/in1");
criticNet = connectLayers(criticNet, ...
    "actInLyr","concat/in2");

rng(0,"twister");
criticNet = initialize(criticNet);

critic = rlQValueFunction(criticNet, ...
    obsInfo,actInfo, ...
    ObservationInputNames="obsInLyr", ...
    ActionInputNames="actInLyr");

getValue(critic, ...
    {rand(obsInfo.Dimension)}, ...
    {rand(actInfo.Dimension)})

actorNet = [
    featureInputLayer(obsInfo.Dimension(1))
    fullyConnectedLayer(25)
    reluLayer()
    fullyConnectedLayer(25)
    reluLayer()
    fullyConnectedLayer(actInfo.Dimension(1))
    ];

rng(0,"twister");
actorNet = dlnetwork(actorNet);

actor = rlContinuousDeterministicActor(actorNet,obsInfo,actInfo);
agent = rlDDPGAgent(actor,critic);


% RL settings
agent.AgentOptions.SampleTime = Ts;
agent.AgentOptions.DiscountFactor = 1.0;
agent.AgentOptions.MiniBatchSize = 400;
agent.AgentOptions.ExperienceBufferLength = 1e9;

actorOpts = rlOptimizerOptions( ...
    LearnRate=1e-6, ...
    GradientThreshold=1, ...
    L2RegularizationFactor=1e-4);
criticOpts = rlOptimizerOptions( ...
    LearnRate=1e-5, ...
    GradientThreshold=1, ...
    L2RegularizationFactor=1e-4);
agent.AgentOptions.ActorOptimizerOptions = actorOpts;
agent.AgentOptions.CriticOptimizerOptions = criticOpts;

agent.AgentOptions.NoiseOptions.StandardDeviation = 0.6;
agent.AgentOptions.NoiseOptions.StandardDeviationDecayRate = 1e-7;


% training options
trainOpts = rlTrainingOptions(...
    MaxEpisodes=1200, ...
    MaxStepsPerEpisode=ceil(Tf/Ts), ...
    Plots="training-progress", ...
    Verbose=false, ...
    StopTrainingCriteria="EvaluationStatistic", ...
    StopTrainingValue=2000);

% agent evaluator
evl = rlEvaluator(EvaluationFrequency=10,NumEpisodes=5);

doTraining = true;

if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts,Evaluator=evl);
end