function dydt = nondimfreelyfallingplate2_limited(p, y, p_aero)
    
    % % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    % v_xp = y(1);
    % v_yp = y(2);
    % omega = y(3);
    % theta = y(4);
    % x_ = y(5);
    % y_ = y(6);
    % 
    % l = p(1);
    % m = p(2);
    % rho_f = p(3);
    % a = p(4);
    % b = p(5);
    % s = p(6);
    % 
    % rho_s = m/(pi*a*b);
    % %h = m/(rho_s*l);
    % 
    % C_L1 = p_aero(1);
    % C_L2 = p_aero(2);
    % C_D0 = p_aero(3);
    % C_D1 = p_aero(4);
    % C_D_pi_2 = p_aero(5);
    % C_0_CP = p_aero(6);
    % C_1_CP = p_aero(7);
    % C_2_CP = p_aero(8);
    % C_R = p_aero(9);
    % e_x= p_aero(10);
    % 
    % l_CM = e_x * l;
    % 
    % m_prime = 4 * m / (pi * rho_f * l * l * s);
    % gamma = rho_f/(rho_s-rho_f);
    % 
    % 
    % % alpha = atan((v_yp - omega*l_CM)/v_xp);
    % % alpha = ((v_yp - omega*l_CM)/v_xp)/(sqrt(1+0.6*((v_yp - omega*l_CM)/v_xp)));
    % 

    % 
    % L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega.*e_x).^2);
    % L_Tx = L_Txy.*(v_yp - omega*e_x);
    % L_Ty = L_Txy.*(-v_xp);
    % 
    % L_Rxy = (-2/pi)*C_R*omega;
    % L_Rx = L_Rxy*(v_yp - omega*e_x);
    % L_Ry = L_Rxy*(-v_xp);
    % 
    % 
    % D_xy = (-2/pi)*C_Dalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x).^2);
    % D_x = D_xy*v_xp;
    % D_y = D_xy.*(v_yp - omega*e_x);
    % 
    % e_xplus = (2.*e_x + 1).^4 + (2.*e_x - 1).^4;
    % e_xminus = (2.*e_x + 1).^4 - (2.*e_x - 1).^4;
    % 
    % 
    % plus_minus = e_xplus + e_xminus;
    % 
    % 
    % % Define dv_xpdt, dv_ypdt, domegadt, dthetadt, dx_dt and dy_dt from the ODEs
    % % ripartire da qui copiando le (5.1 - 5.2 - 5.3)
    % 
    % %Inertia = (1/12)*m_prime*(beta^2+1)+m_prime*e_x^2+1/32+e_x^2;
    % 
    % Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x.^2;
    % 
    % domegadt = ((-C_D_pi_2/(32*pi))*omega*(omega)*plus_minus + ((L_Ty + D_y).*(epsilon_alpha - e_x)) - gamma.*e_x*cos(theta))/Inertia;
    % 
    % % disp(omega)
    % 
    % dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x.*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 
    % 
    % dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt.*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    % 
    % dthetadt = omega; 
    % 
    % dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    % 
    % dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);
    % 
    % error = (dy_dt * 0.07) - (-1*0.07*dx_dt);
    % 
    %  % Create output column vector dydt
    % dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt; error];

        % global p %p_aero 

    % Extract v_xp, v_yp, omega, theta x_ and y_ from input vector y
    v_xp = y(1);
    v_yp = y(2);
    omega = y(3);
    theta = y(4);
    x_ = y(5);
    y_ = y(6);

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
    e_x= p_aero(10);

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

    alpha = (((v_yp - omega*l_CM)./(v_xp))) ;

    % alpha0 = deg2rad(14);
    % delta = deg2rad(6);

    % Falpha2 = 1/(1+exp(2*((sqrt(alpha^2)-alpha0)/delta)));

    % C_Lalpha2 = Falpha2*C_L1.*sin((-alpha)) + (1-Falpha2)*C_L2.*sin(2*(-alpha));

    % C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin(((-alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin((-alpha)).^2);

    % l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*(-alpha).^2) + (1-Falpha2).*C_2_CP.*(1-(-alpha)/(pi/2));

    % C_Lalpha = - C_Lalpha2;
    % C_Dalpha = C_Dalpha2;
    % epsilon_alpha = l_CP_alpha_l2;
    
    
    C_Lalpha =  0.91*sin(2.115*alpha) + 0.1612*sin(8.752*alpha) + 0.09194*sin(11.71*alpha) + 0.1887*sin(5.73*alpha) + 0.02936 *sin(14.58*alpha);
    C_Dalpha = -125.8783 + 9.6401*cos(alpha*1.8789) - 230.5762*sin(alpha*1.8789) + 173.0141*cos(2*alpha*1.8789) + 15.2340*sin(2*alpha*1.8789) -13.4114*cos(3*alpha*1.8789) + 105.6618*sin(3*alpha*1.8789) - 51.1826*cos(4*alpha*1.8789) - 8.1529*sin(4*alpha*1.8789) + 3.3431*cos(5*alpha*1.8789) - 18.7275*sin(5*alpha*1.8789) + 4.6614*cos(6*alpha*1.8789) + 0.8163*sin(6*alpha*1.8789) - 0.0841*cos(7*alpha*1.8789) + 0.5972 *sin(7*alpha*1.8789);
    epsilon_alpha =  0.1465   + 0.0052414*cos(alpha*3.3371384839) + -0.104177*sin(alpha*3.3371384839) + 0.0197930*cos(2*alpha*3.3371384839) + -0.0165049*sin(2*alpha*3.3371384839) + 0.026364*cos(3*alpha*3.3371384839) + 0.00433539*sin(3*alpha*3.3371384839) + 0.02168*cos(4*alpha*3.3371384839) + 0.00502389*sin(4*alpha*3.3371384839) + 0.012060267*cos(5*alpha*3.3371384839) + 0.00185939*sin(5*alpha*3.3371384839) +   0.004075*cos(6*alpha*3.3371384839);
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

    plus_minus = e_xplus + e_xminus;
    
    % Define dv_xpdt, dv_ypdt, domegadt, dthetadt, dx_dt and dy_dt from the ODEs
    % ripartire da qui copiando le (5.1 - 5.2 - 5.3)

    %Inertia = (1/12)*m_prime*(beta^2+1)+m_prime*e_x^2+1/32+e_x^2;

    Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2;
    
    domegadt = ((-C_D_pi_2/(32*pi))*omega*sqrt(omega^2)*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    
    dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 

    dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    
    dthetadt = omega; 

    dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    
    dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);

    error = (dy_dt * 0.07) - (-1*0.07*dx_dt);

    % alpha = sin(((dv_ypdt - omega*l_CM)./(dv_xpdt ))) ;
    
     % Create output column vector dydt
    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt; error];
end