clear all; close all; clc

% Plotting preamble
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

data1 = [90.0400   91.9100   94.4300  101.3400  102.7100 122.3700];

f = figure;
% h = boxplot(data1(1:5),"Colors","k");
hold on
s = scatter(ones(1,5), data1(1:5),'filled');
s2 = scatter(1, data1(6));

xlabel('All Fliers','Interpreter','latex')
ylabel('Mass [mg]')
% title('Masses of 6 3.6 $\mu$m Polyester Flier Prototypes')
pbaspect([1 4 4])
set(gca,'xticklabels',[])
ylim([85 125])

s.MarkerFaceColor = [245, 66, 66]./255;
s2.MarkerEdgeColor = [0,0,0];

% saveas(f,"flier_masses.svg")