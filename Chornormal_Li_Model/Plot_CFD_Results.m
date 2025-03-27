clc; clear all; close all;

[t0, courant0, x0, y0, z0, ux0, uy0, uz0] = get_data('GR_0.dat');
[t1, courant1, x1, y1, z1, ux1, uy1, uz1] = get_data('GR_1.dat');
[t2, courant2, x2, y2, z2, ux2, uy2, uz2] = get_data('GR_2.dat');
[t3, courant3, x3, y3, z3, ux3, uy3, uz3] = get_data('GR_3.dat');
[t4, courant4, x4, y4, z4, ux4, uy4, uz4] = get_data('GR_4.dat');
[t5, courant5, x5, y5, z5, ux5, uy5, uz5] = get_data('GR_5.dat');

figure; f = tiledlayout("flow"); ax(1) = nexttile;

% plot_for_all_gusts(t0, t1, t2, t3, t4, t5, courant0, courant1, courant2, courant3, courant4, courant5, "courant [-]"); nexttile;
plot_for_all_gusts(t0, t1, t2, t3, t4, t5, x0, x1, x2, x3, x4, x5, "x [-]"); nexttile;
% plot_for_all_gusts(t0, t1, t2, t3, t4, t5, y0, y1, y2, y3, y4, y5, "y [-]"); nexttile;
plot_for_all_gusts(t0, t1, t2, t3, t4, t5, z0, z1, z2, z3, z4, z5, "z [-]"); nexttile;
plot_for_all_gusts(t0, t1, t2, t3, t4, t5, ux0, ux1, ux2, ux3, ux4, ux5, "ux [-]"); nexttile;
% plot_for_all_gusts(t0, t1, t2, t3, t4, t5, uy0, uy1, uy2, uy3, uy4, uy5, "uy [-]"); nexttile;
plot_for_all_gusts(t0, t1, t2, t3, t4, t5, uz0, uz1, uz2, uz3, uz4, uz5, "uz [-]");

leg = legend(ax(1), "GR-0", "GR-1", "GR-2", "GR-3", "GR-4", "GR-5",'Orientation','Horizontal');
leg.Layout.Tile = 'north';

exportgraphics(f,'CFD_Gust.png','Resolution',300)

function plot_for_all_gusts(t0, t1, t2, t3, t4, t5, y0, y1, y2, y3, y4, y5, var)

    plot(t0, y0, 'Color', [0.267004, 0.004874, 0.329415],'LineWidth', 2)
    hold on
    plot(t1, y1, 'Color', [0.229739, 0.322361, 0.545706],'LineWidth', 2)  
    plot(t2, y2, 'Color', [0.127568, 0.566949, 0.550556],'LineWidth', 2)  
    plot(t3, y3, 'Color', [0.369214, 0.788888, 0.382914],'LineWidth', 2)  
    plot(t4, y4, 'Color', [0.678489, 0.863742, 0.189503],'LineWidth', 2) 
    plot(t5, y5, 'Color', [0.993248, 0.906157, 0.143936],'LineWidth', 2)  
    xlabel("t [-]")
    ylabel(var)
    pbaspect([1 1 1])

end

function [t, courant, x, y, z, ux, uy, uz] = get_data(filename)

    data = readmatrix(filename); 
    t = data(:,1);
    [ d1, t1 ] = min( abs( t-(10) ) );
    [ d2, t2 ] = min( abs( t-(30) ) );
    t = t(t1:t2);

    courant = data(t1:t2,2);
    x = data(t1:t2,3);
    y = data(t1:t2,4);
    z = data(t1:t2,5);
    ux = data(t1:t2,6);
    uy = data(t1:t2,7);
    uz = data(t1:t2,8);
end
