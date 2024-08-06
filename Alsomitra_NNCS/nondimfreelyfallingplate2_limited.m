function dydt = nondimfreelyfallingplate2_limited(x,u)
    
    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector x
    v_xp = x(1);
    v_yp = x(2);
    omega = x(3);
    theta = x(4);
    x_ = x(5);
    y_ = x(6);

    l = 0.0700;
    m = 3.1750e-04;
    rho_f = 1.225;
    a = 0.0338;
    b = 5.0000e-04;
    s = 0.1745;

    rho_s = m/(pi*a*b);
    %h = m/(rho_s*l);

    C_L1 = 5.18218452125279;
    C_L2 = 0.807506506794260;
    C_D0 = 0.105977518471870;
    C_D1 = 4.93681162104530;
    C_D_pi_2 = 1.49958010664229;
    C_0_CP = 0.238565281050545;
    C_1_CP = 2.85289007725274;
    C_2_CP = 0.368933365279324;
    C_R = 1.73001889433847;
    e_x= u(1);

    l_CM = e_x * l;
  
    m_prime = 4 * m / (pi * rho_f * l * l * s);
    gamma = rho_f/(rho_s-rho_f);


    % alpha = atan((v_yp - omega*l_CM)/v_xp);
    % alpha = ((v_yp - omega*l_CM)/v_xp)/(sqrt(1+0.6*((v_yp - omega*l_CM)/v_xp)));

    alpha = 0.988*sin((v_yp - omega*l_CM)/v_xp);
    % disp(alpha)

    alpha0 = deg2rad(14);
    delta = deg2rad(6);

    % Falpha2 = ((1 - tanh(((-alpha) - alpha0)/delta))/2);

    tanh_term = ((-alpha) - alpha0)/delta;
    tanh_exp = (exp(tanh_term)-exp(-tanh_term))/(exp(tanh_term)+exp(-tanh_term));

    Falpha2 = ((1 - tanh_exp)/2);
    
    C_Lalpha2 = Falpha2*C_L1.*sin((-alpha)) + (1-Falpha2)*C_L2.*sin(2*(-alpha));
    
    C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin(((-alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin((-alpha)).^2);

    l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*(-alpha).^2) + (1-Falpha2).*C_2_CP.*(1-(-alpha)/(pi/2));

    C_Lalpha = - C_Lalpha2;
    C_Dalpha = C_Dalpha2;
    epsilon_alpha = l_CP_alpha_l2;

    L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega.*e_x).^2);
    L_Tx = L_Txy.*(v_yp - omega*e_x);
    L_Ty = L_Txy.*(-v_xp);
  
    L_Rxy = (-2/pi)*C_R*omega;
    L_Rx = L_Rxy*(v_yp - omega*e_x);
    L_Ry = L_Rxy*(-v_xp);


    D_xy = (-2/pi)*C_Dalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x).^2);
    D_x = D_xy*v_xp;
    D_y = D_xy.*(v_yp - omega*e_x);
    
    e_xplus = (2.*e_x + 1).^4 + (2.*e_x - 1).^4;
    e_xminus = (2.*e_x + 1).^4 - (2.*e_x - 1).^4;

    
    plus_minus = e_xplus + e_xminus;
    
    
    % Define dv_xpdt, dv_ypdt, domegadt, dthetadt, dx_dt and dy_dt from the ODEs
    % ripartire da qui copiando le (5.1 - 5.2 - 5.3)

    %Inertia = (1/12)*m_prime*(beta^2+1)+m_prime*e_x^2+1/32+e_x^2;

    Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x.^2;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*(omega)*plus_minus + ((L_Ty + D_y).*(epsilon_alpha - e_x)) - gamma.*e_x*cos(theta))/Inertia;
    
    disp(omega)

    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x.*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt.*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);
    
    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt];
end