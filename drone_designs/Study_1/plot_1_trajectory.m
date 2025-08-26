% clear all; clc; close all;
ObjectiveFunction = @Alsomitra_nondim3;

new_coefficients = [5.182184521	0.807506507	0.105977518	4.936811621	1.499580107	0.238565281	2.852890077	0.368933365	1.730018894];


m_list = [3.6e-5, 3.6e-4, 3.6e-3];

tv_list = zeros(1,3);

for i = m_list
    disp(i)
end

[f,slope,per,amp,x_1,y_1, Cl, Cd, alpha, theta, speed, v0, u0, vx, mins, maxs, max_x, t_v] = ObjectiveFunction([new_coefficients, 0.161,0.07,3.6e-4]);

% f = figure;
% tiledlayout(4,2); nexttile

colors = viridis(5);
plot(x_1 * 1/70,y_1 * 1/70,'color',colors(1,:)); 
xlabel("$x $ [m]"); ylabel("$y $ [m]"); daspect([1 1 1])
xlim([0 400] * 1/70); ylim([-200 5] * 1/70)
daspect([1 1 1]); title("0 Error")
