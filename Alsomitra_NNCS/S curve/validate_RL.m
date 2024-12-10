rng(0,"twister");

simOpts = rlSimulationOptions( ...
    MaxSteps=ceil(Tf/Ts), ...
    StopOnError="on");
experiences = sim(env,agent,simOpts);


sum(experiences.Reward)

x =  experiences.Observation.obs1.Data(5,:,:);
y =  experiences.Observation.obs1.Data(6,:,:);

figure
plot(squeeze(x),squeeze(y))