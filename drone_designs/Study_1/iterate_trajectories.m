% clear all; clc; close all;
ObjectiveFunction = @Alsomitra_nondim3;
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultTextInterpreter','latex');

% Nondimensionalised with l=7cm
p1 = [-0.3363	0.32178673	13.25541439];
p2 = [-0.4547	1.117865818	9.362957704];
p3 = [-0.3311	0.37305935	18.62325016];
p4 = [-0.4493	0.685756098	7.797849674];

new_coefficients = [5.182184521	0.807506507	0.105977518	4.936811621	1.499580107	0.238565281	2.852890077	0.368933365	1.730018894];
e_x = 0.1896;
l = 0.0700;
m = 3.6e-04;

e_x_list = 0.16:0.001:0.22;
l_list = 0.05:0.02:0.15;
m_list = 3e-4:0.6e-4:6e-4;

[X,Y] = meshgrid(l_list,m_list);

Z = [];
Z2 = [];
tic
f1 = figure; tiledlayout(1,length(m_list))
% for l_index = (1:length(l_list))
for l_index = 2
    l = l_list(l_index);
    for m_index = (1:length(m_list))
    % for m_index = 1:2
        m = m_list(m_index);
        vy_list = [];
        vx_list = [];
        vx_max_list = [];
        vx_min_list = [];
        for e_x = e_x_list(1:end)
            [f,slope,per,amp,x_,y_, Cl, Cd, alpha, theta, speed, v0, u0, vx, mins, maxs, max_x, t_v] = ObjectiveFunction([new_coefficients, e_x,l,m],p1,p2,p3,p4);
            GR = abs((x_(end) - x_(end-100000))/(y_(end)-y_(end-100000)));
            vy = -t_v;
            vy_list = [vy_list, vy];
            vx_list = [vx_list, vx];
            vx_max_list = [vx_max_list, maxs(2)];
            vx_min_list = [vx_min_list, mins(2)];
        end
        nexttile
        plot(e_x_list,vy_list,"r"); hold on
        fill([rot90(e_x_list); rot90(fliplr(e_x_list))], [rot90(vx_min_list); rot90(fliplr(vx_max_list))],'b','FaceAlpha',0.3);
        plot(e_x_list,vx_list,"b")
        % Find gliding/bounding boundary e_x value
        for i = length(vy_list)-1:-1:1
            if vy_list(i) > vy_list(i+1) && vy_list(i) < 3.5
                local_min_value = e_x_list(i+1);
                xline(local_min_value, ":k")
                scatter(local_min_value,vy_list(i))
                break; % Exit loop after finding the first local minimum
            end
        end

        % run final sim with optimal e_x
        [f,slope,per,amp,x_,y_, Cl, Cd, alpha, theta, speed, v0, u0, vx, mins, maxs, max_x, t_v] = ObjectiveFunction([new_coefficients, local_min_value,l,m],p1,p2,p3,p4);
        GR = abs((x_(end) - x_(end-100000))/(y_(end)-y_(end-100000)));
        vy = -t_v;
        Z(l_index, m_index) = vy;
        Z2(l_index, m_index) = local_min_value;
        
    end

end
legend("vy","vx$'$","interpreter","latex")
toc

f2 = figure;
tiledlayout(1,2); nexttile

plot(m_list, Z2);  xlabel("m [mg]"); ylabel("$e_x$ [-]")
nexttile
plot(m_list, Z);  xlabel("m [mg]"); ylabel("Terminal Velocity [ms$^{-1}$]")


% contourf(X(1:length(Z2),1:length(Z2))./(1e-3),Y(1:length(Z2),1:length(Z2))./(1e-6),Z2,min(min(Z2))-0.005:0.005:max(max(Z2))+0.05,"ShowText",true,"LabelFormat",'%.3f', ...
%     "FaceAlpha",0.9)
% a=colorbar; a.Label.String = 'CoM Displacement, $e_x$ [-]';
% colormap(viridis)
% xlabel("$\ell$ [mm]"); ylabel("m [mg]")
% pbaspect([1 1 1])
% 
% nexttile
% contourf(X(1:length(Z2),1:length(Z2))./(1e-3),Y(1:length(Z2),1:length(Z2))./(1e-6),Z,[0:0.1:1, 1.2:0.2:3],"ShowText",true,"LabelFormat","%0.1f", ...
%     "FaceAlpha",0.9)
% a=colorbar; a.Label.String = 'Terminal Velocity [ms$^{-1}$]';
% colormap(viridis)
% xlabel("$\ell$ [mm]"); ylabel("m [mg]")
% pbaspect([1 1 1])