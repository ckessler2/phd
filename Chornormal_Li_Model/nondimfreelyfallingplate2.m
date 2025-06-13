function dydt = nondimfreelyfallingplate2(t, y, p_aero)
    
    % global p %p_aero 

    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    v_xp = y(1);
    v_yp = y(2);
    omega = y(3);
    theta = y(4);
    % x_ = y(5);
    % y_ = y(6);

    l = 0.0700;
    m = 3.1750e-04;
    rho_f = 1.225;
    a = 0.0338;
    b = 5.0000e-04;
    s = 0.1745;

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
    e_x= 0.0;

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

    alpha = atan2((v_yp - omega*l_CM),v_xp); 
    
    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

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
    C_Lalpha = C_Lalpha1.*(alpha>=-pi & alpha<=-pi/2) - C_Lalpha2.*(alpha>-pi/2 & alpha<=0) + C_Lalpha3.*(alpha>0 & alpha<=pi/2) - C_Lalpha4.*(alpha>pi/2 & alpha<=pi);

    % C_Dalpha = Falpha.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha1 = Falpha1.*(C_D0 + C_D1.*sin((pi - abs(alpha)).^2)) + (1 - Falpha1).*C_D_pi_2.*(sin(pi - abs(alpha)).^2);
    C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((abs(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(abs(alpha)).^2);
    C_Dalpha3 = Falpha3.*(C_D0 + C_D1.*sin((alpha).^2)) + (1 - Falpha3).*C_D_pi_2.*(sin(alpha).^2);
    C_Dalpha4 = Falpha4.*(C_D0 + C_D1.*sin((pi - alpha).^2)) + (1 - Falpha4).*C_D_pi_2.*(sin(pi - alpha).^2);
    C_Dalpha = C_Dalpha1.*(alpha>=-pi & alpha<-pi/2) + C_Dalpha2.*(alpha>=-pi/2 & alpha<0) + C_Dalpha3.*(alpha>=0 & alpha<pi/2) + C_Dalpha4.*(alpha>=pi/2 & alpha<=pi);

    % l_CP_alpha_l = Falpha.*(C_0_CP - C_1_CP.*alpha.^2) + (1-Falpha).*C_2_CP.*(1-alpha/(pi/2));
    l_CP_alpha_l1 = Falpha1.*(C_0_CP - C_1_CP.*(pi - abs(alpha)).^2) + (1-Falpha1).*C_2_CP.*(1-(pi - abs(alpha))/(pi/2));
    l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*abs(alpha).^2) + (1-Falpha2).*C_2_CP.*(1-abs(alpha)/(pi/2));
    l_CP_alpha_l3 = Falpha3.*(C_0_CP - C_1_CP.*alpha.^2) + (1-Falpha3).*C_2_CP.*(1-alpha/(pi/2));
    l_CP_alpha_l4 = Falpha4.*(C_0_CP - C_1_CP.*(pi - alpha).^2) + (1-Falpha4).*C_2_CP.*(1-(pi - alpha)/(pi/2));
   
    epsilon_alpha = -l_CP_alpha_l1.*(alpha>=-pi & alpha<=-pi/2) + l_CP_alpha_l2.*(alpha>=-pi/2 & alpha<=0) + l_CP_alpha_l3.*(alpha>=0 & alpha<=pi/2) - l_CP_alpha_l4.*(alpha>=pi/2 & alpha<=pi);

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
    e_xplus = (2*e_x + 1).^4 + (2*e_x - 1).^4;
    e_xminus = (2*e_x + 1).^4 - (2*e_x - 1).^4;

    if 2*e_x <= 1 

        plus_minus = e_xplus + e_xminus;
    else

        plus_minus = e_xplus - e_xminus;
    end
    
    % Define dv_xpdt, dv_ypdt, domegadt, dthetadt, dx_dt and dy_dt from the ODEs
    % ripartire da qui copiando le (5.1 - 5.2 - 5.3)

    %Inertia = (1/12)*m_prime*(beta^2+1)+m_prime*e_x^2+1/32+e_x^2;

    Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*abs(omega)*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    
    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);
    
     % Create output column vector dydt
    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt];
end