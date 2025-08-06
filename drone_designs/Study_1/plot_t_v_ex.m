% Plot preamble.
set(0, 'defaultFigureRenderer', 'painters')
set(0,'DefaultFigureWindowStyle','docked')
font=12;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 0.5);

hold on
h3 = fill([rot90(e_x_list); rot90(fliplr(e_x_list))], [rot90(vx_min_list); rot90(fliplr(vx_max_list))],[0.8 0.8 1], 'EdgeColor', 'none');
h2 = plot(e_x_list,vx_list,"b");
h1 = plot(e_x_list,vy_list,"r");

xline(local_min_value, ":k")
legend([h1 h2 h3], "$v_y$","$v_{x'}$ (mean)","$v_{x'}$ (range)","interpreter","latex")

xlabel("$e_x$ [-]"); ylabel("Velocity [ms$^{-1}$]")


