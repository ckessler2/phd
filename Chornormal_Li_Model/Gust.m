t = 0:0.001:30;
f = tiledlayout("flow"); nexttile
gust1 = 0.5 * (cos((2*pi*t))+1).*heaviside(t-14.5).*heaviside(-t+15.5);


% gust2 = heaviside(t-9.5);
% gust1 = heaviside(-t+10.5);

plot(t,gust1, 'Color', [0.267004, 0.004874, 0.329415],'LineWidth', 2)
pbaspect([4 1 1])

% xlim([9 11])

ylabel("$a_{\textnormal{gust}}$ [-]");
xlabel("t [-]")

nexttile;

plot(t,cumtrapz(gust1) * 0.001, 'Color',[0.369214, 0.788888, 0.382914],'LineWidth', 2)
pbaspect([4 1 1])

ylabel("$u_{\textnormal{gust}}$ [-]");
xlabel("t [-]")

exportgraphics(f,'gust_equation.png','Resolution',600)