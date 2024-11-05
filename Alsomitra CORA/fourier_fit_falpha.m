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

alpha = 0:0.0057814:pi/2;
alpha = alpha';
alpha0 = deg2rad(14);
delta = deg2rad(6);



% plot(alpha,Falpha3)
% hold on;
alpha2 = (-pi/2:0.0057814:0)';
Falpha2 = ((1 - tanh((-(alpha2) - alpha0)/delta))/2);

myfittype = fittype("a + a*((b * (x - c))/(sqrt(1+((b * (x - c))^2))))",...
    dependent="y",independent="x",...
    coefficients=["a" "b" "c"]);

f3 = fit(alpha2,Falpha2,myfittype,'StartPoint', [0.5 12 0.2],"MaxIter",20000);

figure
plot(alpha2,Falpha2)
hold on;

f2 = 1-(1./(1+exp(19.1.*alpha2 + 4.667)));
plot(alpha2,f3(alpha2))
legend("CP true","CP approximated")