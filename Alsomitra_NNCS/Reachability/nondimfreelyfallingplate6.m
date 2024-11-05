function dydt = nondimfreelyfallingplate6(y,u)
    
    % global p %p_aero 
    p_aero = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];


    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    v_xp = y(1);
    v_yp = y(2);
    omega = y(3);
    theta = y(4);
    x_ = y(5);
    y_ = y(6);
    error_ = y(7);

    p = [0.070000000000000;3.175000000000000e-04;1.225000000000000;0.033750000000000;5.000000000000000e-04;0.174500000000000];
    l = p(1);
    m = p(2);
    rho_f = p(3);
    a = p(4);
    b = p(5);
    s = p(6);

    rho_s = m/(pi*a*b);
    %h = m/(rho_s*l);

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
    e_x = (e_x * (0.012)) + 0.181;

    % l_CM = l_CE*(rho_s - rho_f)/rho_s; 
    l_CM = e_x * l;
    % % U = 2*sqrt(((rho_s/rho_f)-1)*(h*g/pi));
    
    m_prime = 4 * m / (pi * rho_f * l * l * s);
    % m_prime = 4*rho_s*l*0.001/(pi*rho_f*l);
    % m_prime = 33.0329;
    % m_prime = 5.7642;
    % m_prime = 2.9103;
    % m_prime = 0.5853;

    % Cathal's plot on Slack 14/06/23
    % beta = h/l;
    % gamma = rho_f/(rho_s-rho_f);
    % alpha depends on time t

    % From Cathal 27/03/24
    % beta = 0.001;
    % beta = b/l;
    %gamma = 0.0029;
    gamma = rho_f/(rho_s-rho_f);

    % alpha = atan((v_yp - omega*l_CM)/v_xp); 
    alpha = atan((v_yp)/v_xp); 
    
    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

    % f activation function, it specifies laminar and stall regimes
    Falpha2 = ((1 - tanh((-(alpha) - alpha0)/delta))/2);

    % Falpha2 = 1-(1./(1+exp(19.1.*alpha + 4.667)));
    % Falpha2 = 0.5328 - 0.3463 .* atan((-18.45 .* alpha) - 4.434);
    % Falpha2 = 0.5246 + 0.5246*((10.88 * (alpha + 0.2416))/(sqrt(1+((10.88 * (alpha + 0.2416))^2))));
    % Falpha2 = sin(alpha);

    C_Lalpha2 = Falpha2*C_L1.*sin(-(alpha)) + (1-Falpha2)*C_L2.*sin(2*-(alpha));
    C_Lalpha = - C_Lalpha2;

    % C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((-(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(-(alpha)).^2);
    % C_Dalpha = C_Dalpha2;

    C_Dalpha = Falpha2.*(C_D0 + 0.683.*C_D1.*sin(alpha).*sin(alpha)) + 0.66.*cos(2.143.*alpha + pi) + 0.66;

    % a1 =     -0.4085;
    % b1 =     -0.2411; 
    % a2 =      0.3164;
    % a3 =      0.1869;
    % b2 =     -0.6492;
    % b3 =     0.03671;
    % a4 =    -0.08876;
    % b4 =      0.0207;
    % a5 =    -0.0145;
    % b5 =    -0.02304;
    % a6 =     0.01116;
    % b6 =    0.00229;
    % w =       7.889;
    % x2 = alpha;
    % l_CP_alpha_l2 =  (a1*sin(w*x2))/w - (b2*cos(2*w*x2))/(2*w) - (b3*cos(3*w*x2))/(3*w) - (b4*cos(4*w*x2))/(4*w) - (b5*cos(5*w*x2))/(5*w) - (b6*cos(6*w*x2))/(6*w) - (b1*cos(w*x2))/w + (a2*sin(2*w*x2))/(2*w) + (a3*sin(3*w*x2))/(3*w) + (a4*sin(4*w*x2))/(4*w) + (a5*sin(5*w*x2))/(5*w) + (a6*sin(6*w*x2))/(6*w);
    
    l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*(alpha).^2) + (1-Falpha2).*C_2_CP.*(1+(alpha)/(pi/2));
   
    epsilon_alpha = l_CP_alpha_l2;

    %% CHECK the following equations are all checked with syms Matlab, in the
    % online course https://matlabacademy.mathworks.com/R2020a/portal.html?course=symbolic#chapter=8&lesson=1&section=1
    % you can type the symbolic equation and get a graphical representation
    % as in Latex.
    
    L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    L_Tx = L_Txy.*(v_yp - omega*e_x);
    L_Ty = L_Txy.*(-v_xp);
    % L_T = L_Tx + L_Ty;
  
    L_Rxy = (-2/pi)*C_R*omega;
    L_Rx = L_Rxy*(v_yp - omega*e_x);
    L_Ry = L_Rxy*(-v_xp);
    % L_R = L_Rx + L_Ry;

    % L = L_T + L_R;

    D_xy = (-2/pi)*C_Dalpha*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    D_x = D_xy*v_xp;
    D_y = D_xy*(v_yp - omega*e_x);
    % D = D_x + D_y;
    
    % plus sign applies for 2*l_CM/l < 1, when the CoM lies within the plate
    e_xplus = (2*e_x + 1)^4 + (2*e_x - 1)^4;
    e_xminus = (2*e_x + 1)^4 - (2*e_x - 1)^4;

    plus_minus = e_xplus + e_xminus;
    
    % Define dv_xpdt, dv_ypdt, domegadt, dthetadt, dx_dt and dy_dt from the ODEs
    % ripartire da qui copiando le (5.1 - 5.2 - 5.3)

    %Inertia = (1/12)*m_prime*(beta^2+1)+m_prime*e_x^2+1/32+e_x^2;

    Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*(sqrt(omega^2 + 0.00001))*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    
    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);

    % error = (dy_dt * 0.07) - (-1*0.07*dx_dt);

    error = ((y_+dy_dt) * 0.07) - (-1*0.07*(x_+dx_dt)) - error_;
    
     % Create output column vector dydt
    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt; error];
    
end