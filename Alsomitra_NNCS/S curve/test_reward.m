x_c1 = -4:0.01:4.5;
y_c1 = -x_c1;
y_c2 = -4.6:-0.01:-6.5;
x_c2 = sqrt(2-((y_c2+5.5).^2))+3.5;
x_c3 = 4.4:-0.01:3.5;
y_c3 = x_c3 - 11;
y_c4 = -7.6:-0.01:-9.5;
x_c4 = -sqrt(2-((y_c4+8.5).^2))+4.5;
x_c5 = 3.6:0.01:6;
y_c5 = -x_c5 - 6;
x_c1 = [x_c1,x_c2,x_c3,x_c4,x_c5]/5  * 1000/70;
y_c1 = [y_c1,y_c2,y_c3,y_c4,y_c5]/5  * 1000/70;


figure


a = 128;
b = 64;
x = linspace(0,25,b);
y = linspace(-35,5,a);
[X,Y] = meshgrid(x,y);
Z = sin(X)+cos(Y);

for yn = 1:a
    [val,idx] = min( abs(Y(yn,1)-y_c1 ) );
    nearest_y = y_c1(idx);
    true_x = x_c1(idx);
    for xn = 1:b
        Z(yn,xn) = abs(1/((X(1,xn)- true_x)));
        if Z(yn,xn) > 1
            Z(yn,xn) = 1;
        end

    end
end


[C,h] = contourf(X,Y,Z);
hold on

plot([x_c1], [y_c1], '--black')
xlim([0 25])
ylim([-35 5])
legend("Reward","Desired Trajectory")
daspect([1 1 1])
set(h,'LineColor','none')

% % Add colorbar
% colorbar;
% 
% % Typically, you can customize the colorbar as well
% c = colorbar;
% c.Label.String = 'Value scale'; % Adding label to the colorbar
% % caxis([3, 3]); % Setting the limits of the color scale if needed



rng(0,"twister");

simOpts = rlSimulationOptions( ...
    MaxSteps=ceil(Tf/Ts), ...
    StopOnError="on");
experiences = sim(env,agent,simOpts);


sum(experiences.Reward)

x =  experiences.Observation.obs1.Data(5,:,:);
y =  experiences.Observation.obs1.Data(6,:,:);


plot(squeeze(x),squeeze(y),'r')