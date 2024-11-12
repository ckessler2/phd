function dydt = nondimfreelyfallingplate6_int(y,u)
    
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
    % e_x = (e_x * (0.012)) + 0.181;
    e_x = plus(times(e_x,0.012),0.181);

    % l_CM = e_x * l;
    l_CM = mtimes(e_x,l);

    
    % m_prime = 4 * m / (pi * rho_f * l * l * s);
    m_prime = mtimes(4,(mrdivide(m,(pi * rho_f * l * l * s))));



    gamma = rho_f/(rho_s-rho_f);

    % alpha = atan((v_yp - omega*l_CM)/v_xp); 
    alpha = atan(mrdivide((minus(v_yp,mtimes(omega,l_CM))),v_xp));
    
    % critical angle of attack at stall
    alpha0 = deg2rad(14);
    % delta is the smoothness of the transition from laminar to turbulent
    delta = deg2rad(6);

    % f activation function, it specifies laminar and stall regimes

    % Falpha2 = ((1 - tanh((-(alpha) - alpha0)/delta))/2);
    Falpha2 = mrdivide(minus(1,tanh(mrdivide(minus(-alpha,alpha0),delta))),2);
    
    
    % C_Lalpha2 = Falpha2*C_L1.*sin(-(alpha)) + (1-Falpha2)*C_L2.*sin(2*-(alpha));
    % C_Lalpha = - C_Lalpha2;
    C_Lalpha = uminus(plus(mtimes(Falpha2,mtimes(C_L1,sin(minus(0,alpha)))),mtimes(C_L2,mtimes((minus(1,Falpha2)),(sin(mtimes(-2,alpha)))))));

    % C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((-(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(-(alpha)).^2);
    % C_Dalpha = C_Dalpha2;
    C_Dalpha = plus(mtimes(Falpha2,(plus(C_D0,mtimes(C_D1,sin(power(-alpha,2)))))),mtimes(C_D_pi_2,mtimes(minus(1,Falpha2),sin(power(-alpha,2)))));

    % l_CP_alpha_l2 = Falpha2.*(C_0_CP - C_1_CP.*(alpha).^2) + (1-Falpha2).*C_2_CP.*(1+(alpha)/(pi/2));
    l_CP_alpha_l2 = plus(mtimes(Falpha2,minus(C_0_CP,mtimes(C_1_CP,power(alpha,2)))),mtimes(minus(1,Falpha2),mtimes(C_2_CP,plus(1,mrdivide(alpha,(pi/2))))));
   
    epsilon_alpha = l_CP_alpha_l2;

    %% CHECK the following equations are all checked with syms Matlab, in the
    % online course https://matlabacademy.mathworks.com/R2020a/portal.html?course=symbolic#chapter=8&lesson=1&section=1
    % you can type the symbolic equation and get a graphical representation
    % as in Latex.
    
    % L_Txy = (2/pi)*C_Lalpha.*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    % L_Tx = L_Txy.*(v_yp - omega*e_x);
    % L_Ty = L_Txy.*(-v_xp);
    L_Txy = mtimes((2/pi),mtimes(C_Lalpha,sqrt(plus(power(v_xp,2),power(minus(v_yp,mtimes(omega,e_x)),2)))));
    L_Tx = mtimes(L_Txy,minus(v_yp,mtimes(omega,e_x)));
    L_Ty = mtimes(L_Txy,uminus(v_xp));
    
  
    % L_Rxy = (-2/pi)*C_R*omega;
    % L_Rx = L_Rxy*(v_yp - omega*e_x);
    % L_Ry = L_Rxy*(-v_xp);
    L_Rxy = mtimes((-2/pi),mtimes(C_R,omega));
    L_Rx = mtimes(L_Rxy,minus(v_yp,mtimes(omega,e_x)));
    L_Ry = mtimes(L_Rxy,uminus(v_xp));


    % D_xy = (-2/pi)*C_Dalpha*sqrt(v_xp^2 + (v_yp - omega*e_x)^2);
    % D_x = D_xy*v_xp;
    % D_y = D_xy*(v_yp - omega*e_x);
    D_xy = mtimes((-2/pi),mtimes(C_Dalpha,sqrt(plus(power(v_xp,2),power(minus(v_yp,mtimes(omega,e_x)),2)))));
    D_x = mtimes(D_xy,v_xp);
    D_y = mtimes(D_xy,minus(v_yp,mtimes(omega,e_x)));
    
    % plus sign applies for 2*l_CM/l < 1, when the CoM lies within the plate
    % e_xplus = (2*e_x + 1)^4 + (2*e_x - 1)^4;
    % e_xminus = (2*e_x + 1)^4 - (2*e_x - 1)^4;
    % plus_minus = e_xplus + e_xminus;
    plus_minus = plus(plus(power(plus(mtimes(2,e_x),1),4),power(minus(mtimes(2,e_x),1),4)),minus(power(plus(mtimes(2,e_x),1),4),power(minus(mtimes(2,e_x),1),4)));

    % Inertia = (m * (a^2 + b^2)/(rho_f * l^4))+1/32+e_x^2;
    Inertia = plus(plus(mtimes(m,mrdivide(plus(power(a,2),power(b,2)),mtimes(rho_f,power(l,4)))),1/32),power(e_x,2));
    
    % domegadt = ((-C_D_pi_2/(32*pi))*omega*(sqrt(omega^2 + 0.00001))*plus_minus + ((L_Ty + D_y)*(epsilon_alpha - e_x)) - gamma*e_x*cos(theta))/Inertia;
    o1 = mtimes(mtimes(mtimes(mrdivide(uminus(C_D_pi_2),mtimes(32,pi)),(sqrt(plus(power(omega,2),0.00001)))),omega),plus_minus);
    o2 = mtimes(plus(L_Ty,D_y),minus(epsilon_alpha,e_x));
    o3 = mtimes(gamma,mtimes(e_x,cos(theta)));
    domegadt = mrdivide(minus(plus(o1,o2),o3),Inertia);
    
    
    % dv_xpdt = (1/m_prime)*((m_prime + 1)*omega*v_yp - e_x*omega^2 + (L_Tx + L_Rx) + D_x - sin(theta)); 
    dv_xpdt = mtimes(mrdivide(1,m_prime),plus(minus(mtimes(mtimes(plus(m_prime,1),omega),v_yp),mtimes(e_x,power(omega,2))),minus(plus(plus(L_Tx,L_Rx),D_x),sin(theta))));

    % dv_ypdt = (1/(m_prime+1))*(-m_prime*omega*v_xp +domegadt*e_x + (L_Ty + L_Ry) + D_y - cos(theta));
    dv_ypdt = mtimes(mrdivide(1,plus(m_prime,1)),minus(plus(plus(plus(mtimes(mtimes(uminus(m_prime),omega),v_xp),mtimes(domegadt,e_x)),plus(L_Ty,L_Ry)),D_y),cos(theta)));

    dthetadt = omega; 

    % dx_dt = v_xp.*cos(theta) - v_yp.*sin(theta);
    dx_dt = minus(mtimes(v_xp,cos(theta)),mtimes(v_yp,sin(theta)));
    
    % dy_dt = v_xp.*sin(theta) + v_yp.*cos(theta);
    dy_dt = plus(mtimes(v_xp,sin(theta)),mtimes(v_yp,cos(theta)));

    % error = (dy_dt * 0.07) - (-1*0.07*dx_dt);

    % error = ((y_+dy_dt) * 0.07) - (-1*0.07*(x_+dx_dt)) - error_;
    error = minus(minus(mtimes(y_+dy_dt,0.07),mtimes(-1,mtimes(0.07,plus(x_,dx_dt)))),error_);
    
     % Create output column vector dydt
    dydt = [dv_xpdt; dv_ypdt; domegadt; dthetadt; dx_dt; dy_dt; error];
    
end