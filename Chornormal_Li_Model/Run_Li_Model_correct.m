% clear all; clc; close all;
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

e_x = 0.0;
e_y = 0;

figure; f = tiledlayout("flow"); ax(1) = nexttile;

% f = figure; 
hold on; box on;
[tSol1,ySol1] = test_gust(0);
[tSol2,ySol2] = test_gust(1);
[tSol3,ySol3] = test_gust(2);
[tSol4,ySol4] = test_gust(3);
[tSol5,ySol5] = test_gust(4);
[tSol6,ySol6] = test_gust(5);

plot_x(tSol1, ySol1,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.267004, 0.004874, 0.329415])
plot_x(tSol2, ySol2,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.229739, 0.322361, 0.545706])
plot_x(tSol3, ySol3,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.127568, 0.566949, 0.550556])
plot_x(tSol4, ySol4,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.369214, 0.788888, 0.382914])
plot_x(tSol5, ySol5,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.678489, 0.863742, 0.189503])
plot_x(tSol6, ySol6,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.993248, 0.906157, 0.143936])
pbaspect([1 1 1])
nexttile; hold on;box on;
plot_z(tSol1, ySol1,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.267004, 0.004874, 0.329415])
plot_z(tSol2, ySol2,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.229739, 0.322361, 0.545706])
plot_z(tSol3, ySol3,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.127568, 0.566949, 0.550556])
plot_z(tSol4, ySol4,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.369214, 0.788888, 0.382914])
plot_z(tSol5, ySol5,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.678489, 0.863742, 0.189503])
plot_z(tSol6, ySol6,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.993248, 0.906157, 0.143936])
pbaspect([1 1 1])
nexttile; hold on;box on;
plot_ux(tSol1, ySol1,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.267004, 0.004874, 0.329415])
plot_ux(tSol2, ySol2,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.229739, 0.322361, 0.545706])
plot_ux(tSol3, ySol3,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.127568, 0.566949, 0.550556])
plot_ux(tSol4, ySol4,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.369214, 0.788888, 0.382914])
plot_ux(tSol5, ySol5,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.678489, 0.863742, 0.189503])
plot_ux(tSol6, ySol6,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.993248, 0.906157, 0.143936])
pbaspect([1 1 1])
nexttile; hold on;box on;
plot_uz(tSol1, ySol1,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.267004, 0.004874, 0.329415])
plot_uz(tSol2, ySol2,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.229739, 0.322361, 0.545706])
plot_uz(tSol3, ySol3,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.127568, 0.566949, 0.550556])
plot_uz(tSol4, ySol4,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.369214, 0.788888, 0.382914])
plot_uz(tSol5, ySol5,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)",[0.678489, 0.863742, 0.189503])
plot_uz(tSol6, ySol6,"chordwise only model ($e_x = "+string(e_x)+", e_y = 0$)", [0.993248, 0.906157, 0.143936])
pbaspect([1 1 1])

exportgraphics(f,'Li_grid.png','Resolution',300)


t = 0:0.1:30;
Y0 = [0; 0; 0; 0; 0.; 0.];

function [tSol2,ySol2] = test_gust(ratio)

    e_x = 0.0;
    e_y = .2;
    tSol_total = [];
    ySol_total = [];
    
    Y0 = [0; 0; 0; 0; 0.; 0.]; 
    toc
    
    t_start = 0;
    t_end = 30;
    dt = 0.1; % assuming this is the desired timestep
    
    t_current = t_start;
    y_current = transpose(Y0);
    tSol = t_start;
    ySol = transpose(Y0);
    gust = true;
    
    while t_current < t_end
        t_span = [t_current, min(t_current + dt, t_end)];
        [T, Y] = ode45(@(t,y) nondimfreelyfallingplate(y,e_x), t_span, y_current, odeset('MaxStep',dt, 'InitialStep', dt, 'Refine', 1));
        t_current = T(end);
        if gust
            % added_vel = -ratio * 0.5 * (cos((2*pi*t_current))+1).*heaviside(t_current-14.5).*heaviside(-t_current+15.5);
            added_vel = -ratio * ((1/(2*pi)*sin(2*pi*t_current)+t_current-14.5).*(heaviside(t_current-14.5)).*(heaviside(-t_current+15.5))+(heaviside(t_current-15.5)));
            % added_accel = -ratio * 0.5 * max( (cos((2*pi*t_current)/1)+1).*heaviside(t_current-14.5),2*heaviside(t_current-15));

            Y(end, 1) = Y(end, 1) + added_vel;
        end
        
        y_current = Y(end, :);
        % Append the results
        tSol = [tSol; T(end)];
        ySol = [ySol; Y(end, :)];
    
    % Modify your system here, for example:
    % Check if you need to introduce a gust or change parameters
    
    end
    
    
    tSol2 = [tSol];
    ySol2 = [ySol];
end

% Append last points if required
% tSol2 = [tSol; t_Current];
% ySol2 = [ySol; y_Current];

% tic
% [tSol, ySol] = ode45(@(t, y) nondimfreelyfallingplate_chordnormal(y,[e_x,e_y]), t, Y0); 
% toc
% plot_results(tSol, ySol,"chordwise \& chordnormal model ($e_x = "+string(e_x)+", e_y = "+string(e_y)+"$)")

% compare_results(tSol, ySol,tSol1, ySol1)

function plot_x(tSol, ySol, plot_title, color)
    t = tSol();
    v_xp = ySol(:,1);
    v_yp = ySol(:,2);
    omega = ySol(:,3);
    theta = ySol(:,4);
    x_ = ySol(:,5);
    y_ = ySol(:,6);
    
    [ d1, t1 ] = min( abs( t-(10) ) );
    [ d2, t2 ] = min( abs( t-(30) ) );
    t = t(t1:t2);
    
    plot(t,(x_(t1:t2)), 'Color', color,'LineWidth', 2)
    xlabel("t [-]"); ylabel("${\textnormal{x}}$ [-]"); 
    xlim([10 30])
    ylim([-6 1])
end

function plot_z(tSol, ySol, plot_title, color)
    t = tSol();
    v_xp = ySol(:,1);
    v_yp = ySol(:,2);
    omega = ySol(:,3);
    theta = ySol(:,4);
    x_ = ySol(:,5);
    y_ = ySol(:,6);
    
    [ d1, t1 ] = min( abs( t-(10) ) );
    [ d2, t2 ] = min( abs( t-(30) ) );
    t = t(t1:t2);
    
    plot(t,(y_(t1:t2) + (1.023 * t)), 'Color', color,'LineWidth', 2)
    xlabel("t [-]"); ylabel("${\textnormal{z}}$ [-]"); 
    xlim([10 30])
    ylim([0 6])
end

function plot_ux(tSol, ySol, plot_title, color)
    t = tSol();
    v_xp = ySol(:,1);
    v_yp = ySol(:,2);
    omega = ySol(:,3);
    theta = ySol(:,4);
    x_ = ySol(:,5);
    y_ = ySol(:,6);
    
    [ d1, t1 ] = min( abs( t-(10) ) );
    [ d2, t2 ] = min( abs( t-(30) ) );
    t = t(t1:t2);
    
    plot(t,[0;diff(x_(t1:t2))], 'Color', color,'LineWidth', 2)
    xlabel("t [-]"); ylabel("$u_{\textnormal{x}}$ [-]"); 
    xlim([10 30])
    ylim([-2.5 1])
end

function plot_uz(tSol, ySol, plot_title, color)
    t = tSol();
    v_xp = ySol(:,1);
    v_yp = ySol(:,2);
    omega = ySol(:,3);
    theta = ySol(:,4);
    x_ = ySol(:,5);
    y_ = ySol(:,6);
    
    [ d1, t1 ] = min( abs( t-(10) ) );
    [ d2, t2 ] = min( abs( t-(30) ) );
    t = t(t1:t2);
    
    plot(t,[0;diff(y_(t1:t2))]-1, 'Color', color,'LineWidth', 2)
    xlabel("t [-]"); ylabel("$u_{\textnormal{z}}$ [-]"); 
    xlim([10 30])
    ylim([-1 2])
end

function compare_results(tSol, ySol,tSol2, ySol2)
    t = tSol(1:51);
    v_xp = ySol(1:51,1);
    v_yp = ySol(1:51,2);
    omega = ySol(1:51,3);
    theta = ySol(1:51,4);
    x_ = ySol(1:51,5);
    y_ = ySol(1:51,6);

    v_xp2 = ySol2(1:51,1);
    v_yp2 = ySol2(1:51,2);
    omega2 = ySol2(1:51,3);
    theta2 = ySol2(1:51,4);
    x_2 = ySol2(1:51,5);
    y_2 = ySol2(1:51,6);

    f = figure;
    tiledlayout(6,1);nexttile
    
    plot(t,abs(v_xp-v_xp2));ylim([0 1e-5]);xlim([0 5]);nexttile
    plot(t,abs(v_yp-v_yp2));ylim([0 1e-5]);xlim([0 5]);nexttile
    plot(t,abs(omega-omega2));ylim([0 1e-5]);xlim([0 5]);nexttile
    plot(t,abs(theta-theta2));ylim([0 1e-5]);xlim([0 5]);nexttile
    plot(t,abs(x_-x_2));ylim([0 1e-5]);xlim([0 5]);nexttile
    plot(t,abs(y_-y_2));ylim([0 1e-5]);xlim([0 5])


end


function dydt = nondimfreelyfallingplate(y,u)
    
    % global p %p_aero 
    p_aero = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];


    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    v_xp = y(1);
    v_yp = y(2);
    omega = y(3);
    theta = y(4);
    x_ = y(5);
    y_ = y(6);

    p = [0.070000000000000;3.247200000000000e-04;1.225000000000000;0.033750000000000;5.000000000000000e-04;0.174500000000000];
    l = 0.1;
    m = p(2);
    rho_f = p(3);
    a = p(4);
    b = p(5);
    s = p(6);

    rho_s = m/(pi*a*b);

    C_L1 = p_aero(1);
    C_L2 = p_aero(2);
    C_D0 = p_aero(3);
    C_D1 = p_aero(4);
    C_D_pi_2 = p_aero(5);
    C_0_CP = p_aero(6);
    C_1_CP = p_aero(7);
    C_2_CP = p_aero(8);
    C_R = p_aero(9);
    e_x= u(1);
    
    l_CM = e_x * l;
    
    m_prime = 4 * m / (pi * rho_f * l * l * s);
    gamma = rho_f/(rho_s-rho_f);

    alpha = atan2((v_yp - omega*l_CM),v_xp); 
    % alpha = atan((v_yp)/v_xp); 
    
    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

    Falpha1 = ((1 - tanh((pi - abs(alpha) - alpha0)/delta))/2);
    Falpha2 = ((1 - tanh((abs(alpha) - alpha0)/delta))/2);
    Falpha3 = ((1 - tanh((alpha - alpha0)/delta))/2);
    Falpha4 = ((1 - tanh((pi - alpha - alpha0)/delta))/2);

    C_Lalpha1 = Falpha1*C_L1.*sin(pi - abs(alpha)) + (1-Falpha1)*C_L2.*sin(2*(pi - abs(alpha)));
    C_Lalpha2 = Falpha2*C_L1.*sin(abs(alpha)) + (1-Falpha2)*C_L2.*sin(2*abs(alpha));
    C_Lalpha3 = Falpha3*C_L1.*sin(alpha) + (1-Falpha3)*C_L2.*sin(2*alpha);
    C_Lalpha4 = Falpha4*C_L1.*sin(pi - alpha) + (1-Falpha4)*C_L2.*sin(2*(pi - alpha));
    C_Lalpha = C_Lalpha1.*(alpha>=-pi & alpha<=-pi/2) - C_Lalpha2.*(alpha>-pi/2 & alpha<=0) + C_Lalpha3.*(alpha>0 & alpha<=pi/2) - C_Lalpha4.*(alpha>pi/2 & alpha<=pi);

    C_Dalpha1 = Falpha1.*(C_D0 + C_D1.*sin((pi - abs(alpha)).^2)) + (1 - Falpha1).*C_D_pi_2.*(sin(pi - abs(alpha)).^2);
    C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((abs(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(abs(alpha)).^2);
    C_Dalpha3 = Falpha3.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha3).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha4 = Falpha4.*(C_D0 + C_D1.*sin((pi - alpha).^2)) + (1 - Falpha4).*C_D_pi_2.*(sin(pi - alpha).^2);
    C_Dalpha = C_Dalpha1.*(alpha>=-pi & alpha<-pi/2) + C_Dalpha2.*(alpha>=-pi/2 & alpha<0) + C_Dalpha3.*(alpha>=0 & alpha<pi/2) + C_Dalpha4.*(alpha>=pi/2 & alpha<=pi);

    l_CP_alpha_l1 = Falpha1.*(C_0_CP - C_1_CP.*(pi - abs(alpha)).^2) + (1-Falpha1).*C_2_CP.*(1-(pi - abs(alpha))/(pi/2));
    l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*abs(alpha).^2) + (1-Falpha2).*C_2_CP.*(1-abs(alpha)/(pi/2));
    l_CP_alpha_l3 = Falpha3.*(C_0_CP - C_1_CP.*alpha.^2) + (1-Falpha3).*C_2_CP.*(1-alpha/(pi/2));
    l_CP_alpha_l4 = Falpha4.*(C_0_CP - C_1_CP.*(pi - alpha).^2) + (1-Falpha4).*C_2_CP.*(1-(pi - alpha)/(pi/2));
   
    epsilon_alpha = -l_CP_alpha_l1.*(alpha>=-pi & alpha<=-pi/2) + l_CP_alpha_l2.*(alpha>=-pi/2 & alpha<=0) + l_CP_alpha_l3.*(alpha>=0 & alpha<=pi/2) - l_CP_alpha_l4.*(alpha>=pi/2 & alpha<=pi);

    L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    L_Tx = L_Txy.*(v_yp - omega*e_x);
    L_Ty = L_Txy.*(-v_xp);
  
    L_Rxy = (-2/pi)*C_R*omega;
    L_Rx = L_Rxy*(v_yp - omega*e_x);
    L_Ry = L_Rxy*(-v_xp);

    D_xy = (-2/pi)*C_Dalpha*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    D_x = D_xy*v_xp;
    D_y = D_xy*(v_yp - omega*e_x);
    
    e_xplus = (2*e_x + 1).^4 + (2*e_x - 1).^4;
    e_xminus = (2*e_x + 1).^4 - (2*e_x - 1).^4;

    if 2*e_x <= 1 

        plus_minus = e_xplus + e_xminus;
    else

        plus_minus = e_xplus - e_xminus;
    end
    
    % Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2;
    Inertia = 0.0421;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*abs(omega)*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    
    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);

    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt];
end

function dydt = nondimfreelyfallingplate_chordnormal(y,u)
    
    % global p %p_aero 
    p_aero = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];


    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    v_xp = y(1);
    v_yp = y(2);
    omega = y(3);
    theta = y(4);
    x_ = y(5);
    y_ = y(6);

    p = [0.070000000000000;3.175000000000000e-04;1.225000000000000;0.033750000000000;5.000000000000000e-04;0.174500000000000];
    l = p(1);
    m = p(2);
    rho_f = p(3);
    a = p(4);
    b = p(5);
    s = p(6);

    rho_s = m/(pi*a*b);

    C_L1 = p_aero(1);
    C_L2 = p_aero(2);
    C_D0 = p_aero(3);
    C_D1 = p_aero(4);
    C_D_pi_2 = p_aero(5);
    C_0_CP = p_aero(6);
    C_1_CP = p_aero(7);
    C_2_CP = p_aero(8);
    C_R = p_aero(9);
    e_x= u(1);
    e_y = u(2);

    l_CM = e_x * l;
    h_CM = e_y * l;
    
    m_prime = 4 * m / (pi * rho_f * l * l * s);
    gamma = rho_f/(rho_s-rho_f);


    alpha = atan2((v_yp - omega*l_CM),v_xp-omega*h_CM); 
    % alpha = atan2((v_yp - omega*l_CM),v_xp); 
    % alpha = atan((v_yp)/v_xp); 
    
    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

    Falpha1 = ((1 - tanh((pi - abs(alpha) - alpha0)/delta))/2);
    Falpha2 = ((1 - tanh((abs(alpha) - alpha0)/delta))/2);
    Falpha3 = ((1 - tanh((alpha - alpha0)/delta))/2);
    Falpha4 = ((1 - tanh((pi - alpha - alpha0)/delta))/2);

    C_Lalpha1 = Falpha1*C_L1.*sin(pi - abs(alpha)) + (1-Falpha1)*C_L2.*sin(2*(pi - abs(alpha)));
    C_Lalpha2 = Falpha2*C_L1.*sin(abs(alpha)) + (1-Falpha2)*C_L2.*sin(2*abs(alpha));
    C_Lalpha3 = Falpha3*C_L1.*sin(alpha) + (1-Falpha3)*C_L2.*sin(2*alpha);
    C_Lalpha4 = Falpha4*C_L1.*sin(pi - alpha) + (1-Falpha4)*C_L2.*sin(2*(pi - alpha));
    C_Lalpha = C_Lalpha1.*(alpha>=-pi & alpha<=-pi/2) - C_Lalpha2.*(alpha>-pi/2 & alpha<=0) + C_Lalpha3.*(alpha>0 & alpha<=pi/2) - C_Lalpha4.*(alpha>pi/2 & alpha<=pi);

    C_Dalpha1 = Falpha1.*(C_D0 + C_D1.*sin((pi - abs(alpha)).^2)) + (1 - Falpha1).*C_D_pi_2.*(sin(pi - abs(alpha)).^2);
    C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((abs(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(abs(alpha)).^2);
    C_Dalpha3 = Falpha3.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha3).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha4 = Falpha4.*(C_D0 + C_D1.*sin((pi - alpha).^2)) + (1 - Falpha4).*C_D_pi_2.*(sin(pi - alpha).^2);
    C_Dalpha = C_Dalpha1.*(alpha>=-pi & alpha<-pi/2) + C_Dalpha2.*(alpha>=-pi/2 & alpha<0) + C_Dalpha3.*(alpha>=0 & alpha<pi/2) + C_Dalpha4.*(alpha>=pi/2 & alpha<=pi);

    l_CP_alpha_l1 = Falpha1.*(C_0_CP - C_1_CP.*(pi - abs(alpha)).^2) + (1-Falpha1).*C_2_CP.*(1-(pi - abs(alpha))/(pi/2));
    l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*abs(alpha).^2) + (1-Falpha2).*C_2_CP.*(1-abs(alpha)/(pi/2));
    l_CP_alpha_l3 = Falpha3.*(C_0_CP - C_1_CP.*alpha.^2) + (1-Falpha3).*C_2_CP.*(1-alpha/(pi/2));
    l_CP_alpha_l4 = Falpha4.*(C_0_CP - C_1_CP.*(pi - alpha).^2) + (1-Falpha4).*C_2_CP.*(1-(pi - alpha)/(pi/2));
   
    epsilon_alpha = -l_CP_alpha_l1.*(alpha>=-pi & alpha<=-pi/2) + l_CP_alpha_l2.*(alpha>=-pi/2 & alpha<=0) + l_CP_alpha_l3.*(alpha>=0 & alpha<=pi/2) - l_CP_alpha_l4.*(alpha>=pi/2 & alpha<=pi);

    % L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    % L_Tx = L_Txy.*(v_yp - omega*e_x);
    % L_Ty = L_Txy.*(-v_xp);
    L_Txy = (2/pi)*C_Lalpha.*sqrt((v_xp - omega*e_y)^2 + (v_yp - omega*e_x)^2);
    L_Tx = L_Txy.*(v_yp - omega*e_x);
    L_Ty = L_Txy.*(-(v_xp-omega*e_y));

    % L_Rxy = (-2/pi)*C_R*omega;
    % L_Rx = L_Rxy*(v_yp - omega*e_x);
    % L_Ry = L_Rxy*(-v_xp);
    L_Rxy = (-2/pi)*C_R*omega;
    L_Rx = L_Rxy*(v_yp - omega*e_x);
    L_Ry = L_Rxy*(-(v_xp-omega*e_y));

    % D_xy = (-2/pi)*C_Dalpha*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    % D_x = D_xy*v_xp;
    % D_y = D_xy*(v_yp - omega*e_x)
    D_xy = (-2/pi)*C_Dalpha*sqrt((v_xp - omega*e_y)^2 + (v_yp - omega*e_x)^2);
    D_x = D_xy*(v_xp-omega*e_y);
    D_y = D_xy*(v_yp - omega*e_x);
    
    e_xplus = (2*e_x + 1).^4 + (2*e_x - 1).^4;
    e_xminus = (2*e_x + 1).^4 - (2*e_x - 1).^4;

    if 2*e_x <= 1 

        plus_minus = e_xplus + e_xminus;
    else

        plus_minus = e_xplus - e_xminus;
    end
    
    Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2 + e_y^2;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*abs(omega)*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    
    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);

    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt];
end