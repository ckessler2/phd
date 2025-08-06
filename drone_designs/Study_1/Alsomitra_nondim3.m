function [f,slope,per2,amp2,x_,y_, Cl, Cd, alpha, theta_end, speed, v0, u0, vx_end, mins, maxs, max_x, t_v] = Alsomitra_nondim3(opt,p1,p2,p3,p4)
    
    % display(opt)
    % opt= [4.9794    0.7787    0.1671    5.8387    1.8170    0.2574    6.5168    0.3347    2.9944];
    
    %% define the initial conditions 
    
    % non dimensional period of oscillation T
    T = 2;
    f = 999;
    % number of periods
    n = 24; % Cathal's % n = 1; % mine
    
    % amp = 999;
    % per = 999;
    % slope = 999;
    % 
    % time interval over which to solve the ODEs
    
    % t = 0:0.05:128; % For checking jump to type 1
    t = 0:0.05:6400; % For checking steady states
    % t = 0:0.05:128000; % For checking steady states

    % 640
    
    % initial conditions for v_xp, v_yp, omega, theta, x, y
    % eps in Matlab gives a value close to 0
    Y0 = [0; 0; 0; -pi/3; 0.; 0.]; % Cathal's % Y0 = [0.1; 0.1; 0.1; 0.1; 0.1; 0.1]; % mine

    % Jump to state 2
    % Y0 = [1.1569023891485377; -0.7224070740896313;  0; 0.03300836234265729; 0.; 0.];

    % Jump to state 3
    Y0 = [1.3951749150824846; -0.4904804377758627;  0; -0.005871429288530726; 0.; 0.];
    
    % Using SI units, instead of the units in LiJFM2022, is not a problem since
    % the code is non dimensional 
    l = 5*10^-2;    % % % p(1) = 5.1*10^-2; % p(1) = 5.1 LiJFM2022 
    h = l*0.002;      % % % p(2) = p(1)*0.002;
    rho_s = 1.4*10^3; % % % p(3) = 1.4*10^3; % p(3) = 1.4 LiJFM2022 
    rho_f = 1.225;    % % % p(4) = 1.225; % p(4) = 1.225*10^-3; LiJFM2022 
    l_CE = l*0;     % % % p(5) = p(1)*0.0;
    % e_x = 0.08;       % % % p(6) = 0.00;
    g = 9.80665;      % % % p(7) = 9.80665; % p(7) = 980.665; 
    
  
    % global p 
    % p = [l h rho_s rho_f l_CE e_x g]';
    
    [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate2(t, y, opt(1:12)), t, Y0);
    
    % extract the single variables from the vector with the solutions
    % x component of velocity in the reference system of the body
    v_xp = ySol(:,1);
    vx_end = mean(v_xp(end-10000:end));
    % y component of velocity in the reference system of the body
    v_yp = ySol(:,2);
    
    % omega, first derivative of theta
    omega = ySol(:,3);
    % theta angle defined in Fig.2
    theta = ySol(:,4);
    theta_ = ySol(:,4);
    theta_end = (theta(end));
    % x, horizontal coordinate in reference system linked to the lab
    x_ = ySol(:,5);
    % y, horizontal coordinate in reference system linked to the lab
    y_ = ySol(:,6);
    % terminal velocity approximation
    t_v = y_(end) / tSol(end);
    % d_v_xp = v_xp(end);
    % d_v_yp = v_yp(end);
    % d_omega = omega(end);
    % d_theta = theta(end);
    % d_x = x_(end);
    % d_y = y_(end);

    % Mins/maxs 1=speed, 2=v_xp, 3 = alpha, 4 = CL/CD
    mins(1) = min(sqrt(abs(v_xp(end-10000:end).*v_xp(end-10000:end)) + abs(v_yp(end-10000:end).*v_yp(end-10000:end))));
    maxs(1) = max(sqrt(abs(v_xp(end-10000:end).*v_xp(end-10000:end)) + abs(v_yp(end-10000:end).*v_yp(end-10000:end))));

    mins(2) = min(v_xp(end-10000:end));
    maxs(2) = max(v_xp(end-10000:end));
    % Get initial values
    % [Cl1, Cd1, alpha1, speed1] = calc_Cl_Cd(v_xp(1), v_yp(1), omega(1), theta(1), l, opt(1:10))

    % Get final values
    [Cl, Cd, alpha, speed, v0, u0] = calc_Cl_Cd(v_xp(end), v_yp(end), omega(end), theta(end), l, opt(1:10));
    alpha = (alpha);

    % Get all values
    [Cl_all, Cd_all, alpha_all, speed_all, v0_all, u0_all] = calc_Cl_Cd(v_xp(end-10000:end), v_yp(end-10000:end), omega(end-10000:end), theta(end-10000:end), l, opt(1:10));
    speed = mean(speed_all);
    Cl_all = abs(Cl_all);
    Cl = mean(Cl_all); Cd = mean(Cd_all); alpha = mean(alpha_all);

    mins(3) = min(alpha_all); maxs(3) = max(alpha_all); 
    mins(4) = min(Cl_all./Cd_all); maxs(4) = max(Cl_all./Cd_all); 

    % Cl = 0;
    % Cd = 0;
    if tSol(end) == 128
        tl = tiledlayout(4,2); title(tl, "Type 3 Initialisation ($e_x = 0.193$)",'interpreter','latex'); nexttile;
        plot(tSol,-theta, "k"); ylabel("$\theta$"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], [0.40917087194192125 0.40917087194192125], 'r--');
        plot([0 tSol(end)], [-0.03300836234265729, -0.03300836234265729], 'g--');
        plot([0 tSol(end)], [-0.005871429288530726 -0.005871429288530726], 'b--'); legend("Trajectory", "Type 1", "Type 2", "Type 3"); nexttile
    
        plot(tSol,-alpha_all, "k"); ylabel("$\alpha$"); hold on; xlim([0 tSol(end)])
         plot([0 tSol(end)], [0.04559869216922122 0.04559869216922122], 'r--');
        plot([0 tSol(end)], [0.5581908868990874 0.5581908868990874], 'g--');
        plot([0 tSol(end)], [0.3380592695304332 0.3380592695304332], 'b--'); nexttile;
    
        plot(tSol,-Cl_all, "k"); ylabel("$C_L$"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], [0.2326453746118501 0.2326453746118501], 'r--');
        plot([0 tSol(end)], [0.7305851262234647 0.7305851262234647], 'g--'); 
        plot([0 tSol(end)], [0.6789508721701888 0.6789508721701888], 'b--'); nexttile;
    
        plot(tSol,Cd_all, "k"); ylabel("$C_D$"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], [0.11375223496814238 0.11375223496814238], 'r--');
        plot([0 tSol(end)], [00.42334768377527887 0.42334768377527887], 'g--'); 
        plot([0 tSol(end)], [0.2342185171818062 0.2342185171818062], 'b--'); nexttile;
    
        plot(tSol, u0_all, "k"); ylabel("$u_0$"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], -[2.460292948194082 2.460292948194082], 'r--');
        plot([0 tSol(end)], -[1.1569023891485377 1.1569023891485377], 'g--'); 
        plot([0 tSol(end)], -[1.3951749150824846 1.3951749150824846], 'b--'); nexttile;
    
        plot(tSol, v0_all, "k"); ylabel("$v_0$"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], [0.11226395951065525 0.11226395951065525], 'r--');
        plot([0 tSol(end)], [0.7224070740896313 0.7224070740896313], 'g--'); 
        plot([0 tSol(end)], [0.4904804377758627 0.4904804377758627], 'b--'); nexttile;
    
        plot(tSol,speed_all, "k"); ylabel("Total Speed"); hold on; xlim([0 tSol(end)])
        plot([0 tSol(end)], [2.46285293664452 2.46285293664452], 'r--');
        plot([0 tSol(end)], [1.3639263611765617 1.363926361176], 'g--'); 
        plot([0 tSol(end)], [1.478879340418352 1.478879340418352], 'b--'); nexttile;
    
        plot(tSol,omega, "k");xlabel("Time"); ylabel("$\omega$"); xlim([0 tSol(end)])
    end
    
    % Uncomment for optimisation
    % for n = 500:length(x_)-1
    %     if x_(n+1) < x_(n)
    %         f = [999 999 999 999];
    %         slope = 999; amp2 = 999; per2 = 999;
    %         return;
    %     end
    % end
    
    
    % transform v_xp and v_yp (velocity components in the coordinate system following the 
    % rotation of the card) in v_x and v_y (velocity components in the fixed coordinate system).
    v_x = v_xp.*cos(theta) - v_yp.*sin(theta);
    v_y = v_xp.*sin(theta) + v_yp.*cos(theta);
    
    v = sqrt((v_x.*v_x)+(v_y.*v_y));
    v2 = v;
    t2 = t;
    
    while v2(1) > v2(2)
        v2 = v2(2:end);
        t2 = t2(2:end);
    end
    t2 = t2 - t2(1);
    
    if x_(end)<0
        x_=-x_;
        v_xp=-v_xp;
        omega=-omega;
        theta=-theta;
        alpha_all = -alpha_all;
        alpha = mean(alpha_all);
        mins(3) = min(alpha_all); maxs(3) = max(alpha_all); 
    end
    
        % figure(6), hold on
        % plot(x_,y_)
        % plot(x_(500:end),y_(500:end))
    
    if 0
        
        font=12;
        set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
        set(groot, 'defaultLegendInterpreter', 'latex');
        set(0,'defaultTextInterpreter','latex');
        set(0, 'defaultAxesFontSize', font)
        set(0, 'defaultLegendFontSize', font)
        set(0, 'defaultAxesFontName', 'Times New Roman');
        set(0, 'defaultLegendFontName', 'Times New Roman');
        set(0, 'DefaultLineLineWidth', 1.0);
        paperUnits = 'centimeters';
        paperPosition = [0 0 15 7.5];
    
        figure(1)
        plot(tSol,v_xp), hold on
        title('Horizontal velocity in the body reference system')
        xlabel('Time $t$ (s)','FontSize',font)
        ylabel('Horizontal velocity $u$ (m s$^{-1}$)','FontSize',font)
        
        figure(2)
        plot(tSol,v_yp), hold on
        title('Vertical velocity in the body reference system')
        xlabel('Time $t$ (s)','FontSize',font)
        ylabel('Vertical velocity $v$ (m s$^{-1}$)','FontSize',font)
        
        figure(3)
        plot(tSol,rad2deg(omega)), hold on
        title('Angular velocity')
        xlabel('Time $t$ (s)','FontSize',font)
        ylabel('Angular velocity $\omega$ (deg. s$^{-1}$)','FontSize',font)
        
        figure(4)
        plot(tSol,rad2deg(theta)), hold on
        title('Angular position')
        xlabel('Time $t$ (s)','FontSize',font)
        ylabel('Angular position $\theta$ (deg.)','FontSize',font)
        
        figure(5)
        plot(rad2deg(theta),rad2deg(omega)), hold on
        title('Fig. 3 Andersen 2005')
        xlabel('Angular position $\theta$ (deg.)','FontSize',font)
        ylabel('Angular velocity $\omega$ (deg. s$^{-1}$)','FontSize',font)
        axis equal
    
        load Alsomitra21Data02.mat
        figure(6)
        plot(x_,y_,'DisplayName','Optimal'), hold on
        plot(x-0.2,y,'--','DisplayName','Exp')
        title('Fig')
        xlabel('$x$')
        ylabel('$y$')
        % axis([-10 10 -20 0])
        axis equal
        legend('Location','best')
        grid on
    
        figure(7)
        plot(x_,atand(v_yp./v_xp)), hold on
        xlabel('$x$ (m)','FontSize',font)
        ylabel('Angle of attack $\alpha$ (deg)','FontSize',font)
        xlim([0.4 0.8])
        grid on
    
    end
    % load Alsomitra21Data02.mat
    % figure(1) % figure(6) in Alsomitra.m
    % plot(x_,y_,'DisplayName','Optimal'), hold on
    % plot(x-0.2,y,'--','DisplayName','Exp')
    % title('Fig')
    % xlabel('$x$')
    % ylabel('$y$')
    % % axis([-10 10 -20 0])
    % axis equal 
    % legend('Location','best')
    % grid on
    
    alphaEXP=30.5413; %manually measured
    amp_exp_z=0.2076;
    ssfrac = 0.9;
    s = round((1-ssfrac)*length(x_));
    % ODE data
    z=y_(s:end);
    x=x_(s:end);
    % plot(x_(200:end)-x_(200),y_(200:end)-y_(200))
    % xlim([-20 120]); ylim([-120 0])
    try
        slope = polyfit(x_(500:end),y_(500:end),1);
    catch ME
        slope = 999;
    end
    s2 = slope(2);
    slope = slope(1);
    if abs(x_(end)) < 25
        slope = 999;
    end
    % slope=(z(end)-z(1000))/(x(end)-x(1000));
    z_0=z(1)+slope*(x-x(1));
    alphaNUM=-atand(slope);
    zprime=(z_0-z)*cosd(alphaNUM);
    zprime_det=detrend(zprime,1);
    amp_num_z=(max(zprime_det)-min(zprime_det));
    t_reg = linspace(tSol(1), tSol(end), length(tSol)).'; % we want a column vector for fit()
    x_reg = interp1(tSol, x_, t_reg);
    y_reg = interp1(tSol, y_, t_reg);
    per_exp_y=0.028;%0.55-0.27; measured manually
    
    mask = t_reg > ssfrac * t_reg(end); % define what is steady-state
    poly_x = polyfit(t_reg(mask), x_reg(mask), 1);
    x_det = x_reg - polyval(poly_x, t_reg);
    % ffit_x = fit(y_reg(mask), x_det(mask), 'sin1'); % best-fitting one-harmonic sine
    % per_num_y = 2*pi / ffit_x.b1;
    
    
    x_slop = linspace(0, 40, 5);
    % plot(x_slop,(slope * x_slop + s2))
    x2 = x_;
    y2 = y_;
    
    x2 = x_(9600:end) - x_(9600);
    y2 = y_(9600:end) - y_(9600);
    t2 = t(9600:end) - t(9600);
    
    
    % y2 = y2 - slope * x2;
    % plot(x2,y2,"red")
    % hold on
    fit1 = polyfit(x2,y2,1);
    theta = -atan(fit1(1));
    
    for i=1:length(x2)
        [theta2,rho] = cart2pol(x2(i),y2(i));
        [x2(i),y2(i)] = pol2cart(theta2+theta,rho);
    end
    % plot(x2,y2)
    peaks_y = [];
    peaks_t = [];
    peaks_x = 0;
    valleys_y = [];
    valleys_t = [];
    valleys_x = [];
    count = 1;
    
    for i=2:(length(y2)-1)
        if y2(i) > y2(i+1) & y2(i) > y2(i-1)
            peaks_y = [peaks_y,y2(i)];
            peaks_t = [peaks_t,t(i)];
            peaks_x = [peaks_x,x2(i)];
            count = count + 1;
        elseif y2(i) < y2(i+1) & y2(i) < y2(i-1)
            valleys_y = [valleys_y,y2(i)];
            valleys_x = [valleys_x,x2(i)];
        end
    end
    % 
    peaks_x = peaks_x(2:end);

    % cluster close points to simplify amp/per calculations
    combined_peaks_valleys_x = [peaks_x, valleys_x];
    combined_peaks_valleys_y = [peaks_y, valleys_y];
    x_tol = 9;
    y_tol = (max(peaks_y) - min(valleys_y))/1.7;
    % Place all points into a matrix
    points = [combined_peaks_valleys_x' combined_peaks_valleys_y'];
    
    % Sort points by x to make clustering easier
    points = sortrows(points, 1);
    
    % Initialize cluster storage
    % clusters = {};
    % current_cluster = points(1, :);
    
    % for i = 2:length(points)
    %     % Calculate the distance from the current point to the current cluster's last point
    %     dist_x = abs(points(i, 1) - points(i-1, 1));
    %     dist_y = abs(points(i, 2) - points(i-1, 2));
    % 
    %     % Check if current point is close enough to be considered in the current cluster
    %     if dist_x <= x_tol && dist_y <= y_tol
    %         current_cluster = [current_cluster; points(i, :)];
    %     else
    %         % Save the current cluster and start a new one
    %         clusters{end+1} = current_cluster;
    %         current_cluster = points(i, :);
    %     end
    % end
    
    % Save the last remaining cluster
    % clusters{end+1} = current_cluster;
    
    % Compute average of each cluster
    % averaged_points = zeros(length(clusters), 2);
    % for i = 1:length(clusters)
    %     averaged_points(i, :) = mean(clusters{i}, 1);
    % end

    % scatter(peaks_x,peaks_y,"filled","red"); hold on
    % scatter(valleys_x,valleys_y,"filled","red")#
    % scatter(averaged_points(:,1),averaged_points(:,2),"blue"); hold on
    % plot(x2,y2)
    
    amps = [];
    periods = [];
    f = [];
    p0 = [p1;p2;p3;p4];
    
    % for i=1:min(length(peaks_y),length(valleys_y))
    %     amps = [amps,abs(peaks_y(i) - valleys_y(i))];
    % end
    % 
    % for i=1:min(length(peaks_y),length(valleys_y))-1
    %     periods = [periods,abs(peaks_x(i) - peaks_x(i+1))];
    % end

    % for i = 1:length(averaged_points(:,2))-1
    %     amps = [amps,abs(averaged_points(i,2) - averaged_points(i+1,2))];
    %     periods =  [periods, abs(averaged_points(i,1) - averaged_points(i+1,1))];
    % end

    amp = abs(mean(amps))/2;
    per = abs(mean(periods));
    % x3 = x2;
    % y3 = y2;

    % fit1 = @(b,x3)  b(1).*(sin(2*pi*x3.*b(2) + 2*pi*b(3))) + b(4);     % Function to fit
    % fcn = @(b) sum((fit1(b,x3) - y3).^2);                              % Least-Squares cost function
    % options = optimset('MaxIter',2000000,'MaxFunEvals',2000000,'TolX', 0, 'TolFun', 0);
    % s = fminsearchbnd(fcn, [amp;  1/(per);  -1;  0], [amp/1.5 1/25 -1 0], [amp*5 1/4 -1 0],options);
    % amp2 = abs(s(1));
    amp2 = amp;
    per2 = per;

    % plot(x,fit1([amp,1/per,-1,0],transpose(x)),'--black')
    % x5 = x2;
    % y5 = fit1(s,transpose(x2));
    
    % ft = fittype('a + b*sin(x/d + c)','indep','x');
    % 
    % mdl = fit(x3(:),y3(:),ft,'startpoint',[0; amp;  5;  -1]);
    % plot(x,(mdl(2)*sin(x/mdl(3) + mdl(4))),'--black')
    % 
    
    % per2 = abs(1/s(2));

    % fprintf("amp2, per2: " + amp2 + " " + per2 + "\n")
    % max_x = plot_fft(v_xp(end-10000:end), tSol(end-10000:end));
    max_x = 1;

    for i=1:4

        slope_exp = abs(p0(i,1));
        amp_exp = abs(p0(i,2));
        per_exp = abs(p0(i,3));
        slope = abs(slope);
        
        % if amp2 < 0.6
        %     amp2 = amp_exp;
        %     per = per_exp;
        % end
        
        %% OBJECTIVE FUNCTION
        f1 =  ( abs((slope-slope_exp )   / slope_exp ))  + ...
             ( abs((amp2-amp_exp) / amp_exp))  + ...
             ( abs((per2-per_exp) / per_exp)); 
        
            c=clock; %[year month day hour minute seconds]
            cc=c(6)+60*c(5);
            % figure(8)
            % plot(cc,f,'x','MarkerSize',12)
            % set(gca, 'YScale', 'log')
            % hold on
        f = [f;f1];
    end
end


function [Cl, Cd, alpha, speed, v0, u0] = calc_Cl_Cd(v_xp, v_yp, omega, theta, l, p_aero)


    C_L1 = p_aero(1);
    C_L2 = p_aero(2);
    C_D0 = p_aero(3);
    C_D1 = p_aero(4);
    C_D_pi_2 = p_aero(5);
    C_0_CP = p_aero(6);
    C_1_CP = p_aero(7);
    C_2_CP = p_aero(8);
    C_R = p_aero(9);
    e_x= p_aero(10);
    
    l_CM = e_x * l;

    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

    alpha = atan2((v_yp - omega*l_CM),v_xp); 
    
    % f activation function, it specifies laminar and stall regimes
    Falpha1 = ((1 - tanh((pi - abs(alpha) - alpha0)/delta))/2);
    Falpha2 = ((1 - tanh((abs(alpha) - alpha0)/delta))/2);
    Falpha3 = ((1 - tanh((alpha - alpha0)/delta))/2);
    Falpha4 = ((1 - tanh((pi - alpha - alpha0)/delta))/2);
    % Falpha = Falpha1.*(alpha>=-pi & alpha<=-pi/2) + Falpha2.*(alpha>=-pi/2 & alpha<=0) + Falpha3.*(alpha>=0 & alpha<=pi/2) + Falpha4.*(alpha>=pi/2 & alpha<=pi);

    % C_Lalpha = Falpha*C_L1.*sin(alpha) + (1-Falpha)*C_L2.*sin(2*alpha);
    C_Lalpha1 = Falpha1*C_L1.*sin(pi - abs(alpha)) + (1-Falpha1)*C_L2.*sin(2*(pi - abs(alpha)));
    C_Lalpha2 = Falpha2*C_L1.*sin(abs(alpha)) + (1-Falpha2)*C_L2.*sin(2*abs(alpha));
    C_Lalpha3 = Falpha3*C_L1.*sin(alpha) + (1-Falpha3)*C_L2.*sin(2*alpha);
    C_Lalpha4 = Falpha4*C_L1.*sin(pi - alpha) + (1-Falpha4)*C_L2.*sin(2*(pi - alpha));
    Cl = C_Lalpha1.*(alpha>=-pi & alpha<=-pi/2) - C_Lalpha2.*(alpha>-pi/2 & alpha<=0) + C_Lalpha3.*(alpha>0 & alpha<=pi/2) - C_Lalpha4.*(alpha>pi/2 & alpha<=pi);

    % C_Dalpha = Falpha.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha1 = Falpha1.*(C_D0 + C_D1.*sin((pi - abs(alpha)).^2)) + (1 - Falpha1).*C_D_pi_2.*(sin(pi - abs(alpha)).^2);
    C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((abs(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(abs(alpha)).^2);
    C_Dalpha3 = Falpha3.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha3).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha4 = Falpha4.*(C_D0 + C_D1.*sin((pi - alpha).^2)) + (1 - Falpha4).*C_D_pi_2.*(sin(pi - alpha).^2);
    Cd = C_Dalpha1.*(alpha>=-pi & alpha<-pi/2) + C_Dalpha2.*(alpha>=-pi/2 & alpha<0) + C_Dalpha3.*(alpha>=0 & alpha<pi/2) + C_Dalpha4.*(alpha>=pi/2 & alpha<=pi);
    
    % speed = (abs(v_xp) + abs(v_yp));
    speed = sqrt(abs(v_xp.*v_xp) + abs(v_yp.*v_yp));
    v0 = -v_yp; u0 = -v_xp;
end


function max_x = plot_fft(omega, time)
    Fs = 100;            % Sampling frequency    
    L = length(time);      % Length of signal
    Y = fft(omega);

    tiledlayout(2,1); nexttile
    plot(time, omega)
    title("$v_x$ vs time")
    xlabel("t [s]"); ylabel("$v_x$"); nexttile

   
    plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
    title("fft Spectrum")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    xlim([0 5])

    Y = Y(10:end);
    [max_y, index_of_max_y] = max(abs(fftshift(Y)));
    x = Fs/L*(-L/2:L/2-1);
    max_x = abs(x(index_of_max_y+5));
    disp("max nonzero frequency = " + max_x)

        
end