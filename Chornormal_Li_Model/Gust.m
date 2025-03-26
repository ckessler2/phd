t = 0:0.001:30;
gust1 = (cos((2*pi*t)/1)+1).*heaviside(t-9.5).*heaviside(-t+10.5);
% gust2 = heaviside(t-9.5);
% gust1 = heaviside(-t+10.5);

plot(t,gust1)
daspect([1 1 1])

% xlim([9 11])

ylabel("Gust");
xlabel("Time [-]")