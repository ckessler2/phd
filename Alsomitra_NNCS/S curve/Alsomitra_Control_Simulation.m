% Colin Kessler 4.8.2024 - colinkessler00@gmail.com
clear; clc;

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
set(0, 'DefaultLineLineWidth', 1.0);

% NN or PID controller
nnc =  true;

ObjectiveFunction = @Alsomitra_nondim;

its = 64;
epochs = 1;
obj_f = [];

nn = importNetworkFromONNX('Alsomitra_Controller5.onnx',InputDataFormats='BC');

parameters = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];

p1 = [-0.3363	0.32178673	13.25541439];
p2 = [-0.4547	1.117865818	9.362957704];
p3 = [-0.3311	0.37305935	18.62325016];
p4 = [-0.4493	0.685756098	7.797849674];

figure

data = [];

% Plot simulations over a range of starting y values

for n = 0.1
    disp(n)
    hold on
    [data1,errors1,ex_all1] = simulate(n/0.07,parameters,ObjectiveFunction,nn,nnc);
    data = [data;data1];
end


% if nnc == false
%     %  Remove data points randomly with a gaussian distribution, such that
%     %  datapoints are not mostly close to error = 0
% 
%     writematrix(data,'Training_Data.csv') 
%     save('Training_Data','data3')
% end


function [data,errors,ex_all,ds] = simulate(y0,parameters, ObjectiveFunction,nn, nnc)

    % Target trajectory
    x_c1 = 0:0.1:4.5;
    y_c1 = -x_c1;
    y_c2 = -4.6:-0.1:-6.5;
    x_c2 = sqrt(2-((y_c2+5.5).^2))+3.5;
    x_c3 = 4.4:-0.1:3.5;
    y_c3 = x_c3 - 11;
    y_c4 = -7.6:-0.1:-9.5;
    x_c4 = -sqrt(2-((y_c4+8.5).^2))+4.5;
    x_c5 = 3.6:0.1:6;
    y_c5 = -x_c5 - 6;
    x_c1 = [x_c1,x_c2,x_c3,x_c4,x_c5]/5;
    y_c1 = [y_c1,y_c2,y_c3,y_c4,y_c5]/5;


    v_xp0 = 1;
    v_yp0 = 0;
    omega0 = 0;
    theta0 = 0;
    x0 = 0;
    alpha0 = 0;
    % y0 = 0;
    % error = (y0 * 0.07) - (-1*0.07*x0 - 2);
    % errors = (y0 * 0.07) - (- 2);
    % errors2 = (y0 * 0.07) - (-1*0.07*x0 - 2);
    % error2 = (y0 * 0.07) - (- 2);
    error = 0;
    errors = 0;
    errors2 = 0;
    error2 = 0;

    e1 = 0;
    e2 = 0;
    e1s = 0;
    e2s = 0;
    thetat = 0;

    ex =  controller(e1, e2, error, errors, nnc, v_xp0, v_yp0, omega0, theta0, x0, y0, error2, thetat);
    
    num_sims = 48;
    x_scatter = x0;
    y_scatter = y0;
    
    omega_all = omega0;
    theta_all = theta0;
    vx_all = v_xp0;
    vy_all = v_yp0;
    x_all = x0 ;
    y_all =y0;
    ex_all = ex;
    alpha_all = alpha0;
    
    ds = [];
    
    
    for i = 1:num_sims

       
        error = error2;

        ex =  controller(e1, e2, error, errors, nnc, v_xp0, v_yp0, omega0, theta0, x0, y0, error2, thetat);

       
        [v_xp, v_yp, omega, theta, x, y, error2, alpha] = ObjectiveFunction([parameters,ex],v_xp0, v_yp0, omega0, theta0, x0, y0,num_sims,error2, alpha0);
        
        x_all = [x_all;x];
        y_all = [y_all;y];
    
        v_xp0 = v_xp(end);
        v_yp0 = v_yp(end);
        omega0 = omega(end);
        theta0 = theta(end);
        x0 = x(end);
        y0 = y(end);
        error2 = error2(end);
        alpha0 = alpha(end);
        x_scatter = [x_scatter;x0];
        y_scatter = [y_scatter;y0];
        
        [xt,yt,thetat] = calc_errors(x0,y0,theta0);
        e1x = x0 - xt;
        e1y = y0 - yt;
        e1 = sqrt((e1x^2)+(e1y^2)) * - (abs(e1y)/e1y) ;
        e1s = [e1s,e1];
        % theta_err = theta-theta2;
        e2s = [e2s, thetat];

        ex_all = [ex_all;ex];
        theta_all =[theta_all;theta0];
        omega_all =[omega_all;omega0];
        vx_all =[vx_all;v_xp0];
        vy_all =[vy_all;v_yp0];
        x_all =[x_all;x(end)];
        y_all =[y_all;y(end)];
        alpha_all = [alpha_all;alpha0];

       

        errors = [errors; error];
        errors2 = [errors2; error2];

   
    
    end
    
    % plot(1:25, e2s)
    hold on
    plot(1:num_sims+1, theta_all)
    plot(1:num_sims+1, e2s)

    data = [vx_all,vy_all,omega_all,theta_all,x_scatter, y_scatter, errors2,ex_all, alpha_all];
    
    figure
    plot(x_all,y_all,'red')
    hold on
    plot([x_c1] * 1000/70, [y_c1]* 1000/70, '--black')
    xlim([0 25])
    ylim([-35 5])

    legend("Simulation","Desired Trajectory")
    daspect([1 1 1])

end

function [v_xp, v_yp, omega, theta, x_, y_, error, alpha] = Alsomitra_nondim(opt,v_xp0, v_yp0, omega0, theta0, x0, y0,num_sims,error, alpha)
    
    % display(opt)
    
    %% define the initial conditions 
    
    
    % non dimensional period of oscillation T
    T = 2;
    f = 999;
    % number of periods
    n = 16 / num_sims; % Cathal's % n = 1; % mine
    
    % time interval over which to solve the ODEs
    t = 0:0.01:n;
    % fprintf("t end = " + t(end))
    
    % initial conditions for v_xp, v_yp, omega, theta, x, y
    % eps in Matlab gives a value close to 0
    % Y0 = [0; 0; 0; 0; 0.; 0.]; % Cathal's % Y0 = [0.1; 0.1; 0.1; 0.1; 0.1; 0.1]; % mine
    Y0 = [v_xp0, v_yp0, omega0, theta0, x0, y0, error, alpha];

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
    
    [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate3(y,opt(10)), t, Y0);
    
    % extract the single variables from the vector with the solutions
    % x component of velocity in the reference system of the body
    v_xp = ySol(:,1);
    
    % y component of velocity in the reference system of the body
    v_yp = ySol(:,2);
    
    % omega, first derivative of theta
    omega = ySol(:,3);
    
    % theta angle defined in Fig.2
    theta = ySol(:,4);
    
    % % x, horizontal coordinate in reference system linked to the lab
    x_ = ySol(:,5);

    % y, horizontal coordinate in reference system linked to the lab
    y_ = ySol(:,6);

    error = ySol(:,7);

    alpha = ySol(:,8);

end


function [xt,yt,thetat] = calc_errors(x,y,theta)

    % Target trajectory
    x_c1 = -0.5:0.1:4.5;
    y_c1 = -x_c1;
    y_c2 = -4.6:-0.1:-6.5;
    x_c2 = sqrt(2-((y_c2+5.5).^2))+3.5;
    x_c3 = 4.4:-0.1:3.5;
    y_c3 = x_c3 - 11;
    y_c4 = -7.6:-0.1:-9.5;
    x_c4 = -sqrt(2-((y_c4+8.5).^2))+4.5;
    x_c5 = 3.6:0.1:10;
    y_c5 = -x_c5 - 6;
    x_c1 = [x_c1,x_c2,x_c3,x_c4,x_c5]/5 * 1000/70;
    y_c1 = [y_c1,y_c2,y_c3,y_c4,y_c5]/5 * 1000/70;

    distances1 = ((x_c1-x).^2);
    distances2 = ((y_c1-y).^2);
    [val,idx] = min(distances1+distances2);

    theta2 = atan2((y_c1(idx+1)-y_c1(idx-1)),(x_c1(idx+1)-x_c1(idx-1)));
    intercept2 = y_c1(idx) - (tan(theta2) * x_c1(idx));
    intercept = y - (tan(theta-pi/2)*x);

    xt = (intercept2-intercept)/ (tan(theta-pi/2)- tan(theta2));
    yt = tan(theta-pi/2)*xt + intercept;

    thetat = theta2;
end

function ex =  controller(e1, e2, error, errors, nnc, v_xp0, v_yp0, omega0, theta0, x0, y0, error2, thetat)
    
    if nnc == true
        % NN CONTROLLER
        ex = nn.predict([v_xp0 v_yp0 omega0 theta0 x0 y0 error2]);
        ex = (ex * (0.012)) + 0.181;
    else
        % % PID CONTROLLER
        integral  = sum(errors);
        derivative = errors(end) - error;
        
        
        % ex = 0.1870 + (error * 0.008)+ (derivative * 0.02) + (integral * 0.0001);

        % if error < 1
        %     error = error * 0.25;
        % end

        ex = 0.1870 + (error * 0.05)+ (derivative * -0.45)+ (integral * 0.0000);
        if ex > 0.193
            ex = 0.193;
        elseif ex < 0.181
            ex = 0.181;
        end
    end

     ex = 0.1870 + ((theta0-thetat) * 0.5);
     if thetat > theta0
         ex = 0.1870 + ((theta0-thetat) * 0.05);
     end

     if ex < 0.106
        ex = 0.106;
     end

end