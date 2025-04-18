clear
% close all
clc

% constants
PATM = 101325; % Atmospheric pressure [Pa]
PVAC = PATM-0.81e+05; % Vacuum pressure [Pa]
RHO = 1.293; % Density of air [kg/m^3]
MDOTVAC = RHO*6e-05/0.675; % Mass flow rate of vacuum [kg/s]
% TOL = 1e-2;

% variable
mass = [3.3e-03 3.3e-03]; % Mass of zigzag [kg]
length = [0.015 0.015]; % Length [m]
diam = [0.02 0.02]; % Diameter [m]
holeDiam = [0.002 0.0035 0.001]; % Pipe diameter, dVac dVacI dATM [m]

stage = 0.2; % 20% of zigzag 2 & 20% of zigzag 1 

k = [1 1.2]./length; % Stiffness [N/m] % 0.365 for actual
zeta = [0.7 0.7]; % Damping ratio [-]
wn = sqrt(k./mass); % natural frequency [rad/s]
c = zeta.*2.*mass.*wn;

endTime = 2;
timeStep = 0.001;
nT = endTime/timeStep;
tspan = linspace(0,endTime,nT);

statStat = zeros(1,nT);
PVacI = zeros(1,nT);
alpha = zeros(4,nT);
fExt = zeros(2,nT);
x = zeros(6,nT);
x(:,1) = [length(1); 0;  0; length(2); 0; 0];
currT = 0;
for iterCount = 2:nT % initial conditions are iterCount = 1
    % pulling down: -'ive, pushing up: +'ive
    if x(4,iterCount-1) > length(2)*stage && x(1,iterCount-1) > length(1)*stage % both extended: vac & atm
        statStat(iterCount-1) = 1;
        PVacI(iterCount) = PVAC + (8*MDOTVAC^2)/(RHO*(pi*holeDiam(1)^2)^2) - 0.5*RHO*((diam(2)/holeDiam(2))^2*x(5,iterCount-1))^2;

        fExt(1,iterCount) = -(pi*holeDiam(1)^2)/4*PVAC - (pi*holeDiam(2)^2)/4*PVacI(iterCount);
        fExt(2,iterCount) = -(pi*holeDiam(2)^2)/4*PVacI(iterCount) + (pi*holeDiam(3)^2)/4*PATM;

    elseif x(4,iterCount-1) < length(2)*stage && x(1,iterCount-1) > length(1)*stage % 2nd collapsed and 1st still collapsing: vac 
        statStat(iterCount-1) = 2;
        PVacI(iterCount) = PVAC + (8*MDOTVAC^2)/(RHO*(pi*holeDiam(1)^2)^2) - 0.5*RHO*((diam(2)/holeDiam(2))^2*x(5,iterCount-1))^2;

        fExt(1,iterCount) = -(pi*holeDiam(1)^2)/4*PVAC - (pi*holeDiam(2)^2)/4*PVacI(iterCount);
        fExt(2,iterCount) = -(pi*holeDiam(2)^2)/4*PVacI(iterCount);

    elseif x(4,iterCount-1) < length(2)*stage && x(1,iterCount-1) < length(1)*stage % both collapsed: intermediate pressure
        statStat(iterCount-1) = 3;
        PVacI(iterCount) = PVacI(iterCount-1);

        fExt(1,iterCount) = -(pi*holeDiam(1)^2)/4*PVacI(iterCount);
        fExt(2,iterCount) = -(pi*holeDiam(2)^2)/4*PVacI(iterCount) + k(2)*length(2);

    elseif x(4,iterCount-1) > length(2)*stage && x(1,iterCount-1) < length(1)*stage % 2nd fully extended and 1st still collapsed
        statStat(iterCount-1) = 4;
        PVacI(iterCount) = PATM + 0.5*RHO*((diam(2)/holeDiam(2))^2*x(5,iterCount-1))^2;

        fExt(1,iterCount) = (pi*holeDiam(1)^2)/4*PVacI(iterCount);
        fExt(2,iterCount) = -(pi*holeDiam(2)^2)/4*PVacI(iterCount) + (pi*holeDiam(3)^2)/4*PATM;    
    end

    alpha(1,iterCount) = alpha(1,iterCount-1) + timeStep*alpha(2,iterCount-1); 
    alpha(2,iterCount) = alpha(2,iterCount-1) + timeStep*(-2*zeta(1)*wn(1)*alpha(2,iterCount-1) - wn(1)^2*alpha(1,iterCount-1) + fExt(1,iterCount)); 
    alpha(3,iterCount) = alpha(3,iterCount-1) + timeStep*alpha(4,iterCount-1); 
    alpha(4,iterCount) = alpha(4,iterCount-1) + timeStep*(-2*zeta(2)*wn(2)*alpha(4,iterCount-1) - wn(2)^2*alpha(3,iterCount-1) + fExt(2,iterCount)); 

    x(1,iterCount) = x(1,iterCount-1) + alpha(1,iterCount);
    x(2,iterCount) = alpha(2,iterCount);
    x(3,iterCount) = (alpha(2,iterCount) - alpha(2,iterCount-1))/timeStep;
    x(4,iterCount) = x(4,iterCount-1) + alpha(3,iterCount);
    x(5,iterCount) = alpha(4,iterCount);
    x(6,iterCount) = (alpha(4,iterCount) - alpha(4,iterCount-1))/timeStep;

    currT = currT + timeStep;
    iterCount = iterCount+1;
end

% Plots
figure
tiledlayout("flow"); nexttile;

plot(tspan,x(2,:)*1000,'linewidth',2)
title("x2 vs Time")

nexttile;
plot(tspan,x(1,:)*1000,'linewidth',2)
hold on 
plot(tspan,x(4,:)*1000,'linewidth',2)
ylim([0 1.1*length(1)*1000])
xlabel('Time [s]')
ylabel('Displacement [mm]')
legend('first','second')
title("Displacement vs Time")

nexttile;
plot(tspan,statStat)
ylim([1 4]); title("State vs Time")

nexttile;
plot(tspan,PVacI*1e-3)
yline(PVAC*1e-3)
yline(PATM*1e-3)
xlabel('Time [s]')
ylabel('Intermediate pressure [kPa]')
title("Intermediate pressure vs Time")

nexttile;
plot(tspan,fExt(1,:))
hold on 
plot(tspan,fExt(2,:))
legend('first','second')
title("Fext vs Time")