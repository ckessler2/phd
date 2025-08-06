% clear all; clc; close all;
ObjectiveFunction = @Alsomitra_nondim3;

% Nondimensionalised with l=7cm
p1 = [-0.3363	0.32178673	13.25541439];
p2 = [-0.4547	1.117865818	9.362957704];
p3 = [-0.3311	0.37305935	18.62325016];
p4 = [-0.4493	0.685756098	7.797849674];

new_coefficients = [5.182184521	0.807506507	0.105977518	4.936811621	1.499580107	0.238565281	2.852890077	0.368933365	1.730018894];
e_x = 0.161;

[f,slope,per,amp,x_,y_, Cl, Cd, alpha, theta, speed, v0, u0, vx, mins, maxs, max_x] = ObjectiveFunction([new_coefficients, e_x,0.07,3.6e-4],p1,p2,p3,p4);

% e_xs = 0.11:0.001:0.14;
% max_xs = [];
% for i = e_xs
%     disp("e_x = " + i)
%     [f,slope,per,amp,x_,y_, Cl, Cd, alpha, theta, speed, v0, u0, vx, mins, maxs, max_x] = ObjectiveFunction([new_coefficients, i],p1,p2,p3,p4);
%     max_xs = [max_xs, max_x];
% end

% close all;
% plot(e_xs, max_xs)

% figure
plot(x_,y_); hold on
% xlim(sort([x_(end), x_(end-1000)])); ylim(sort([y_(end-1000), y_(end)]));
% xlim(sort([x_(end-2000)+200, x_(end-2000)])); ylim(sort([y_(end-2000), y_(end-2000)-200]));
xlabel("$x $ [-]"); ylabel("$y $ [-]"); daspect([1 1 1])

