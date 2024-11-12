% clear all; close all; clc

set(0,'DefaultFigureWindowStyle','docked')
p_aero = [5.18218452125279	0.807506506794260	0.105977518471870	4.93681162104530	1.49958010664229	0.238565281050545	2.85289007725274	0.368933365279324	1.73001889433847];
C_L1 = p_aero(1);
C_L2 = p_aero(2);
C_D0 = p_aero(3);
C_D1 = p_aero(4);
C_D_pi_2 = p_aero(5);
C_0_CP = p_aero(6);
C_1_CP = p_aero(7);
C_2_CP = p_aero(8);
C_R = p_aero(9);

alpha = -pi/2:0.0057814:0;
alpha = alpha';
alpha0 = deg2rad(14);
delta = deg2rad(6);
Falpha2 = ((1 - tanh((-(alpha) - alpha0)/delta))/2);
Falpha3 = ((1 - tanh((alpha - alpha0)/delta))/2);

C_Dalpha2 = Falpha2.*(C_D0 + C_D1.*sin((-(alpha)).^2)) + (1 - Falpha2).*C_D_pi_2.*(sin(-(alpha)).^2);
figure
plot(alpha,C_Dalpha2)
hold on
C_Dalpha2_2 = Falpha2.*(C_D0 + 0.683.*C_D1.*sin(alpha).*sin(alpha)) + 0.66.*cos(2.143.*alpha + pi) + 0.66;
plot(alpha,C_Dalpha2_2);legend("CP true","CP approximated")

C_0_CP = 0.2574;
C_1_CP = 6.5168;
C_2_CP = 0.3347;

l_CP_alpha_l3 = Falpha3.*(C_0_CP - C_1_CP.*alpha.^2) + (1-Falpha3).*C_2_CP.*(1-alpha/(pi/2));
syms x
F_symbolic = ((1 - tanh((x - alpha0)/delta))/2);
CP_symbolic = F_symbolic*(C_0_CP - C_1_CP*x^2) + (1-F_symbolic)*C_2_CP*(1-x/(pi/2));


l2 = 0.2574.*cos(alpha) - 1./(5.*cosh(12.*alpha - 2.8));

% y = sin(x);

% plot(alpha,l_CP_alpha_l3)
% hold on
% x=alpha; plot(alpha,eval(subs(CP_symbolic)))

myfittype = fittype("0.2574*cos(b*x) - 1/(c*cosh(d*x - e)) + f",...
    dependent="y",independent="x",...
    coefficients=["b" "c" "d" "e" "f"]);

weights = [1000 ones(1, numel(alpha)-2), 1000];

f1 = fit(alpha,l_CP_alpha_l3,myfittype,'StartPoint', [1 5 12 2.8 0.015], 'Weights', weights,"MaxIter",20000);

fit_symbolic = 0.2574*cos(1.364*x) - 1/(4.817*cosh(11.5*x - 2.62 )) + 0.03425;
fit_symbolic_diff = -0.2574*sin(1.364*x)+ (11.5*tanh(11.5*x - 2.62))/(4.817*cosh(11.5*x - 2.62 ));

myfittype2 = fittype("-0.2574*sin(b*x)+ (11.5*tanh(d*x - e))/(c*cosh(d*x - e ))+ f",...
    dependent="y",independent="x",...
    coefficients=["b" "c" "d" "e" "f"]);

x = alpha;
CP_symbolic_diff = diff(CP_symbolic);

f2 = fit(alpha,eval(subs(CP_symbolic_diff)),"fourier6",'Weights', weights, "MaxIter",2000,Robust = 'on');

% hold on;
% plot(alpha,f(alpha))
% 
% legend("CP true","CP approximated")

figure
CP_symbolic_diff = diff(CP_symbolic);
x=alpha; plot(alpha,eval(subs(CP_symbolic_diff)))


vals = coeffvalues(f2);
syms a0 a1 a2 a3 a4 a5 a6 b1 b2 b3 b4 b5 b6 w x2

f2_symbolic = a1*cos(x2*w) + b1*sin(x2*w) + ...
               a2*cos(2*x2*w) + b2*sin(2*x2*w) + a3*cos(3*x2*w) + b3*sin(3*x2*w) + ...
               a4*cos(4*x2*w) + b4*sin(4*x2*w) + a5*cos(5*x2*w) + b5*sin(5*x2*w) + ...
               a6*cos(6*x2*w) + b6*sin(6*x2*w);
f2_symbolic_int = (a1*sin(w*x2))/w - (b2*cos(2*w*x2))/(2*w) - (b3*cos(3*w*x2))/(3*w) - (b4*cos(4*w*x2))/(4*w) - (b5*cos(5*w*x2))/(5*w) - (b6*cos(6*w*x2))/(6*w) - (b1*cos(w*x2))/w + (a2*sin(2*w*x2))/(2*w) + (a3*sin(3*w*x2))/(3*w) + (a4*sin(4*w*x2))/(4*w) + (a5*sin(5*w*x2))/(5*w) + (a6*sin(6*w*x2))/(6*w);


a1 =     -0.4085;
b1 =     -0.2411; 
a2 =      0.3164;
a3 =      0.1869;
b2 =     -0.6492;
b3 =     0.03671;
a4 =    -0.08876;
b4 =      0.0207;
a5 =    -0.0145;
b5 =    -0.02304;
a6 =     0.01116;
b6 =    0.00229;
w =       7.889;
x2 = x;

hold on
plot(alpha,eval(subs(f2_symbolic)))
legend("CP true","CP approximated")

figure
plot(alpha,eval(subs(CP_symbolic)))
hold on
plot(alpha,eval(subs(f2_symbolic_int))+0.1881)
legend("CP true","CP approximated")