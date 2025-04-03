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

endTime = 10;
timeStep = 0.001;
tspan = linspace(0,endTime,endTime/timeStep);

x0 = [0.0150000000000000; 1; 0; 0.0150000000000000; 0; 0; 20325; -0.0639; -0.2005; 0; 0; 0; 0];

% Solve ODE
[t, x] = ode45(@(t, x) system_eqns(x), tspan, x0);

% get result
x1 = x(:,1);
x2 = x(:,2);
x4 = x(:,4);
PVacI = x(:,7);
fExt1 = x(:,8); fExt2 = x(:,9);

states = get_states(t, x1, x4, 0.015, 0.015, 0.2);

% Plots
figure
fig = tiledlayout("flow"); nexttile;

plot(t,x2*1000,'linewidth',2)
title("X2 vs Time"); nexttile;

plot(t,x1*1000,'linewidth',2); hold on
plot(t,x4*1000,'linewidth',2)
xlabel('Time [s]'); ylabel('Displacement [mm]')
legend('first','second'); title("Displacement vs Time")

nexttile;
plot(t, states)
ylim([1 4]); title("State vs Time")

nexttile;
plot(t,PVacI*1e-3)
yline(20325*1e-3)
yline(101325*1e-3)
xlabel('Time [s]'); ylabel('Intermediate pressure [kPa]')
title("Intermediate pressure vs Time")

nexttile;
plot(t,fExt1); hold on 
plot(t,fExt1)
legend('first','second'); title("Fext vs Time")

function dxdt = system_eqns(x)

    % Unpack variables and constants
    x1 = x(1); x2 = x(2); x3 = x(3); x4 = x(4); x5 = x(5); x6 = x(6);
    PVacI = x(7); 
    fExt1 = x(8);
    fExt2 = x(9);
    alpha1 = x(10); alpha2 = x(11); alpha3 = x(12); alpha4 = x(13);

    % Constants
    PATM = 101325; % Atmospheric pressure [Pa]
    PVAC = PATM-0.81e+05; % Vacuum pressure [Pa]
    RHO = 1.293; % Density of air [kg/m^3]
    MDOTVAC = RHO*6e-05/0.675; % Mass flow rate of vacuum [kg/s]

    mass = [3.3e-03 3.3e-03];
    length = [0.015 0.015]; % Length [m]
    diam = [0.02 0.02]; % Diameter [m]
    holeDiam = [0.002 0.0035 0.001]; 
    stage = 0.2;

    k = [1 1.2]./length; % Stiffness [N/m] % 0.365 for actual
    zeta = [0.7 0.7]; % Damping ratio [-]
    wn = sqrt(k./mass); % natural frequency [rad/s]
    
    % Control logic to determine state and update forces and pressures
    % Check conditions and update force/pressure appropriately
    if x4 > length(2) * stage && x1 > length(1) * stage % Both extended
        dPVacI  = PVAC + (8 * MDOTVAC^2) / (RHO * (pi * holeDiam(1)^2)^2) - 0.5 * RHO * ((diam(2) / holeDiam(2))^2 * x5^2);
        dfExt1 = -(pi*holeDiam(1)^2)/4*PVAC - (pi*holeDiam(2)^2)/4*PVacI;
        dfExt2 = -(pi*holeDiam(2)^2)/4*PVacI + (pi*holeDiam(3)^2)/4*PATM;
    elseif x4 < length(2) * stage && x1 > length(1) * stage % 2nd collapsed and 1st still extending
        dPVacI = PVAC + (8*MDOTVAC^2)/(RHO*(pi*holeDiam(1)^2)^2) - 0.5*RHO*((diam(2)/holeDiam(2))^2*x5)^2;
        dfExt1 = -(pi*holeDiam(1)^2)/4*PVAC - (pi*holeDiam(2)^2)/4*PVacI;
        dfExt2 = -(pi*holeDiam(2)^2)/4*PVacI;
    elseif x4 < length(2) * stage && x1 < length(1) * stage % Both collapsed
        dPVacI = 0;
        dfExt1 = -(pi*holeDiam(1)^2)/4*PVacI;
        dfExt2 = -(pi*holeDiam(2)^2)/4*PVacI + 1.2000; % Adjust this constant based on actual parameters
    elseif x4 > length(2) * stage && x1 < length(1) * stage % 2nd fully extended and 1st still collapsed
        dPVacI = PATM + 0.5*RHO*((diam(2)/holeDiam(2))^2*x5)^2;
        dfExt1 = (pi*holeDiam(1)^2)/4*PVacI;
        dfExt2 = -(pi*holeDiam(2)^2)/4*PVacI + (pi*holeDiam(3)^2)/4*PATM;
    end

    % Updating equation for alpha1
    dalpha1 = alpha2; 
    dalpha2 = -2 * zeta(1) * wn(1) * alpha2 - wn(1)^2 * alpha1 + fExt1;  
    dalpha3 = alpha4;
    dalpha4 = -2 * zeta(2) * wn(2) * alpha4 - wn(2)^2 * alpha3 + fExt2;  

    % Compute derivatives
    dxdt = zeros(7,1);
    dxdt(1) = x2;
    dxdt(2) = -2*zeta(1)*wn(1)*x2 - wn(1)^2*x1 + fExt1;
    dxdt(3) = (dxdt(2) - x3);
    dxdt(4) = x5;
    dxdt(5) = -2*zeta(2)*wn(2)*x5 - wn(2)^2*x4 + fExt2;
    dxdt(6) = (dxdt(5) - x6);
    dxdt(7) = dPVacI;
    dxdt(8) = dfExt1;
    dxdt(9) = dfExt2;
    dxdt(10) = dalpha1;
    dxdt(11) = dalpha2;
    dxdt(12) = dalpha3;
    dxdt(13) = dalpha4;
end

function states = get_states(t, x1, x4, length1, length2, stage)
    states = zeros(1,length(t));
    for iterCount = 2:length(t)+1 % initial conditions are iterCount = 1

        if x4(iterCount-1) > length2*stage && x1(iterCount-1) > length1*stage % both extended: vac & atm
            states(iterCount-1) = 1;
    
        elseif x4(iterCount-1) < length2*stage && x1(iterCount-1) > length1*stage % 2nd collapsed and 1st still collapsing: vac 
            states(iterCount-1) = 2;
    
        elseif x4(iterCount-1) < length2*stage && x1(iterCount-1) < length1*stage % both collapsed: intermediate pressure
            states(iterCount-1) = 3;
    
        elseif x4(iterCount-1) > length2*stage && x1(iterCount-1) < length1*stage % 2nd fully extended and 1st still collapsed
            states(iterCount-1) = 4;
        end
    end
end