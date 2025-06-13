function [f,slope,per2,amp2,x_,y_] = Alsomitra_nondim3(opt,p1)
    
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
    
    t = 0:0.05:80;
    
    % initial conditions for v_xp, v_yp, omega, theta, x, y
    % eps in Matlab gives a value close to 0
    Y0 = [0; 0; 0; pi/3; 0.; 0.]; % Cathal's % Y0 = [0.1; 0.1; 0.1; 0.1; 0.1; 0.1]; % mine
    
    % Using SI units, instead of the units in LiJFM2022, is not a problem since
    % the code is non dimensional 
    l = 5*10^-2;    % % % p(1) = 5.1*10^-2; % p(1) = 5.1 LiJFM2022 
    h = l*0.002;      % % % p(2) = p(1)*0.002;
    rho_s = 1.4*10^3; % % % p(3) = 1.4*10^3; % p(3) = 1.4 LiJFM2022 
    rho_f = 1.225;    % % % p(4) = 1.225; % p(4) = 1.225*10^-3; LiJFM2022 
    l_CE = l*0;     % % % p(5) = p(1)*0.0;
    e_x = 0.08;       % % % p(6) = 0.00;
    g = 9.80665;      % % % p(7) = 9.80665; % p(7) = 980.665; 
    
  
    global p 
    p = [l h rho_s rho_f l_CE e_x g]';
    
    [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate2(t, y, opt(1:9)), t, Y0);
    
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
    ffit_x = fit(y_reg(mask), x_det(mask), 'sin1'); % best-fitting one-harmonic sine
    per_num_y = 2*pi / ffit_x.b1;
    
    
    x_slop = linspace(0, 40, 5);
    % plot(x_slop,(slope * x_slop + s2))
    x2 = x_;
    y2 = y_;
    
    x2 = x_(300:end) - x_(300);
    y2 = y_(300:end) - y_(300);
    t2 = t(300:end) - t(300);
    
    
    % y2 = y2 - slope * x2;
    % plot(x2,y2)
    % hold on
    fit1 = polyfit(x2,y2,1);
    theta = -atan(fit1(1));
    
    for i=1:length(x2)
        [theta2,rho] = cart2pol(x2(i),y2(i));
        [x2(i),y2(i)] = pol2cart(theta2+pi/2,rho);
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
        if y2(i) > y2(i+1) & y2(i) > y2(i-1) & x2(i) > (peaks_x(count) + 5)
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

    % scatter(peaks_x,peaks_y,"filled","red")
    % scatter(valleys_x,valleys_y,"filled","red")
    
    amps = [];
    periods = [];
    f = [];
    % p0 = [p1;p2;p3;p4];
    
    for i=1:min(length(peaks_y),length(valleys_y))
        amps = [amps,abs(peaks_y(i) - valleys_y(i))];
    end

    for i=1:min(length(peaks_y),length(valleys_y))-1
        periods = [periods,abs(peaks_x(i) - peaks_x(i+1))];
    end
    amp = abs(mean(amps))/2;
    per = abs(mean(periods));
    x3 = x2;
    y3 = y2;

    fit1 = @(b,x3)  b(1).*(sin(2*pi*x3.*b(2) + 2*pi*b(3))) + b(4);     % Function to fit
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
    
    for i=1

        amp_exp = abs(p1(i,1));
        per_exp = abs(p1(i,2));
        
        % if amp2 < 0.6
        %     amp2 = amp_exp;
        %     per = per_exp;
        % end
        
        %% OBJECTIVE FUNCTION
        f1 = ( abs((amp2-amp_exp) / amp_exp))  + ...
             ( abs((per2-per_exp) / per_exp)); 
        
            c=clock; %[year month day hour minute seconds]
            cc=c(6)+60*c(5);
            % figure(8)
            % plot(cc,f,'x','MarkerSize',12)
            % set(gca, 'YScale', 'log')
            % hold on
        disp(f1)
        f = [f;f1];
    end
end