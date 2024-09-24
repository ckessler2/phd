% close all; clc;

% NN or PID controller
nnc = true;

ObjectiveFunction = @Alsomitra_nondim;

its = 64;
epochs = 1;
obj_f = [];
% load('F:\matlab_stuff\Straight_Flight_4722ALLPLOTS\RL2\savedAgents\Agent3.mat')

nn = neuralNetwork.readONNXNetwork('alsomitra_controller.onnx');

parameters = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];


% figure

font=12;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 1.0);

% y_1 = mean(transpose(percents));
% plot(x_pc,y_1);
% xlabel('Optimisation iteration')
% ylabel('Average Paramater Range Size (\%)','Interpreter','latex')

% close all

set(0,'DefaultFigureWindowStyle','docked')

[data1,errors,ex_all] = simulate(0,parameters,ObjectiveFunction,nn,nnc);
% hold on
% [data2,errors2,ex_all2] = simulate(0.5/0.07,parameters,ObjectiveFunction,nn,nnc);
% [data3,errors3,ex_all3] = simulate(-0.5/0.07,parameters,ObjectiveFunction,nn,nnc);
% [data4,errors4,ex_all4,ds4] = simulate(1/0.07,parameters,ObjectiveFunction,nn,nnc);
% [data5,errors5,ex_all5] = simulate(-1/0.07,parameters,ObjectiveFunction,nn,nnc);
% % 
% data = [data1;data2;data3;data4;data5];
% 
% if nnc == false
%     writematrix(data,'C:\Users\Colin Kessler\AI_2\data_100.csv') 
% end

% 
% ylim([-2 0.5])
% xlim([0 300])
% 
% plot([0 3500],[-pi/2 -pi/2],'--black')
% 
% plot([0 3500],[0 0],'--black')

ylabel('${\alpha}$ (rad)')
xlabel('Simulation time (dimensionless)')
title('Simulation ${\alpha}$ vs Time')

hold on


function [data,errors,ex_all,ds] = simulate(y0,parameters, ObjectiveFunction,nn, nnc)

    v_xp0 = 1;
    v_yp0 = 0;
    omega0 = 0;
    theta0 = 0;
    x0 = 0;
    % y0 = 0;
    error = (y0 * 0.07) - (-1*0.07*x0 - 2);
    % error = 2;
    errors = (y0 * 0.07) - (- 2);
    errors2 = 0;
    error2 = 0;

    if nnc == true
        % NN CONTROLLER
        ex = nn.evaluate([v_xp0; v_yp0; omega0; theta0; x0; y0; error2]);
    else
        i  = sum(errors);
        d = errors(end) - error;
        % % PID CONTROLLER
        ex = 0.1870 + ((error) * 0.01);
        ex = ex -(0.0315*d) - (-0.0003 * i);
        if ex > 0.193
            ex = 0.193;
        elseif ex < 0.181
            ex = 0.181;
        end
    end
    
    
    
    num_sims = 1;
    x_scatter = [x0];
    y_scatter = [y0];
    
    omega_all = [omega0];
    theta_all = [theta0];
    vx_all =[v_xp0];
    vy_all =[v_yp0];
    x_all =[x0];
    y_all =[y0];
    ex_all = [ex];
    
    ds = [];
    
    
    for i = 1:num_sims

       
        error = (y0 * 0.07) - (-1*0.07*x0 - 2);

        if nnc == true
            % NN CONTROLLER
            ex = nn.evaluate([v_xp0; v_yp0; omega0; theta0; x0; y0;error2]);
        else
            % % PID CONTROLLER
            i  = sum(errors);
            d = errors(end) - error;
            
            
            ex = 0.1870 + ((error) * 0.1);
            ex = ex -(0.5*d) - (-0.0003 * i);
            if ex > 0.193
                ex = 0.193;
            elseif ex < 0.181
                ex = 0.181;
            end
            ds = [ds;d];
            %  SET ex to 0.181
            % ex = 0.181;
        end

        
        
        


        [v_xp, v_yp, omega, theta, x, y, error2] = ObjectiveFunction(0.161,v_xp0, v_yp0, omega0, theta0, x0, y0,num_sims);
        
        x_all = [x_all;x];
        y_all = [y_all;y];
    
        v_xp0 = v_xp(end);
        v_yp0 = v_yp(end);
        omega0 = omega(end);
        theta0 = theta(end);
        x0 = x(end);
        y0 = y(end);
        error2 = error2(end);
    
        x_scatter = [x_scatter;x0];
        y_scatter = [y_scatter;y0];
        % error = (y0 * 70) - (-0.5 * (x0 * 70) - 4000);
        

        % 
        % BANG-BANG controller
        % if error > 0
        %     ex = 0.106;
        % else
        %     ex = 0.161;
        % end

        ex_all = [ex_all;ex];
        theta_all =[theta_all;theta];
        omega_all =[omega_all;omega0];
        vx_all =[vx_all;v_xp0];
        vy_all =[vy_all;v_yp0];
        x_all =[x_all;x(end)];
        y_all =[y_all;y(end)];

       

        errors = [errors; error];
        errors2 = [errors2; error2];
   
    
    end
    
    % data = [vx_all,vy_all,omega_all,theta_all,x_scatter,y_scatter,errors2,ex_all];
    data = 1
    % newplot
    % tiledlayout(2,1);
    % nexttile
    % 
    % plot(x_all * 70 / 1000,y_all * 70 / 1000,'red')
    plot(x_all,y_all,'blue')
    % plot(1:length(atan2((v_yp - omega*ex*0.07),v_xp)),atan2((v_yp - omega*ex*0.07),v_xp),'blue')

    hold on
    
    x_c1 = -2:1:30;
    y_c1 = -1 * x_c1 - 2;
    
    
    
    % plot([x_c1] * 1000/70, [y_c1]* 1000/70, 'black')
    
    
    % scatter(x_scatter * 70 / 1000,y_scatter * 70 / 1000,4,'blue')
    % scatter(x_scatter,y_scatter,4,'blue')
    % 
    % xlim([-1 5])
    % ylim([-5 0])
    % xlim([-1 30])
    % ylim([-20 2])
    % xlim([0 150])
    % ylim([-150 50])
    
    % xlabel('x (m)')
    % ylabel('y (m)')
    % legend("Simulation","Desired Trajectory","Timestep")
    % daspect([1 1 1])

end

function [v_xp, v_yp, omega, theta, x_, y_, error] = Alsomitra_nondim(ex,v_xp0, v_yp0, omega0, theta0, x0, y0,num_sims)
    
    % display(opt)
    
    %% define the initial conditions 
    
    % non dimensional period of oscillation T
    T = 2;
    f = 999;
    % number of periods
    n = 60 / num_sims; % Cathal's % n = 1; % mine
    
    % time interval over which to solve the ODEs
    t = 0:T/10^1:n;
    % fprintf("t end = " + t(end))
    
    % initial conditions for v_xp, v_yp, omega, theta, x, y
    % eps in Matlab gives a value close to 0
    % Y0 = [0; 0; 0; 0; 0.; 0.]; % Cathal's % Y0 = [0.1; 0.1; 0.1; 0.1; 0.1; 0.1]; % mine
    Y0 = [v_xp0, v_yp0, omega0, theta0, x0, y0, 0];

    % Using SI units, instead of the units in LiJFM2022, is not a problem since
    % the code is non dimensional 
    %l = 5.725*10^-2;    % % % p(1) = 5.1*10^-2; % p(1) = 5.1 LiJFM2022 
    %s = 174.5*10^-3;   % Average wingspan
    %m = 0.3175;     % Average mass

    masses = ([0.36,0.37,0.37,0.17])*10^-3;
    lengths = ([54,58,58,59])*10^-3;
    spans = ([162,188,178,170])*10^-3;
    l = mean(lengths);
    l = 7*10^-2;
    s = mean(spans);
    m = mean(masses);

    as= ([64,71,67,68])/2 *10.^-3;
    a = mean(as);
    b = 1/2 *10^-3;

    % h = l*0.002;      % % % p(2) = p(1)*0.002;
    rho_s = 1.4*10^3; % % % p(3) = 1.4*10^3; % p(3) = 1.4 LiJFM2022 
    rho_f = 1.225;    % % % p(4) = 1.225; % p(4) = 1.225*10^-3; LiJFM2022 
    % l_CE = l*0;     % % % p(5) = p(1)*0.0;
    % e_x = 0.08;       % % % p(6) = 0.00;
    % g = 9.80665;      % % % p(7) = 9.80665; % p(7) = 980.665; 
    
  
    % global p 
    p = [l m rho_f a b s]';
    
    % [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate3(p, y, opt(1:10)), t, Y0);

    [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate6(y,ex), t, Y0);
    
    % extract the single variables from the vector with the solutions
    % x component of velocity in the reference system of the body
    v_xp = ySol(:,1);
    
    % y component of velocity in the reference system of the body
    v_yp = ySol(:,2);
    
    % omega, first derivative of theta
    omega = ySol(:,3);
    
    % theta angle defined in Fig.2
    theta = ySol(:,4);
    
    % x, horizontal coordinate in reference system linked to the lab
    x_ = ySol(:,5);

    % y, horizontal coordinate in reference system linked to the lab
    y_ = ySol(:,6);

    error = ySol(:,7);

end