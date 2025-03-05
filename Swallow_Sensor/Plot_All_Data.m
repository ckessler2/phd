font=9;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 0.7);

figure; f1 = tiledlayout(4,3); nexttile

Plot_Piezo_Data("leftAA1.csv"); nexttile
Plot_Piezo_Data("leftAA2.csv"); nexttile
Plot_Piezo_Data("leftAA3.csv"); nexttile
Plot_Piezo_Data("leftAA_maxGain1.csv"); nexttile
Plot_Piezo_Data("leftAA_maxGain2.csv"); nexttile
Plot_Piezo_Data("leftAA_maxGain3.csv"); nexttile
Plot_Piezo_Data("OnAdamsApple1.csv"); nexttile
Plot_Piezo_Data("OnAdamsApple2.csv"); nexttile
Plot_Piezo_Data("OnAdamsApple3.csv"); nexttile
Plot_Piezo_Data("OnAA_maxGain1.csv"); nexttile
Plot_Piezo_Data("OnAA_maxGain2.csv"); nexttile
Plot_Piezo_Data("OnAA_maxGain3.csv")

% exportgraphics(f1,'blankSwallow.png','Resolution',600)

figure; f2 = tiledlayout(1,3); nexttile

Plot_Piezo_Data("serial_data_20250224_170122.csv"); nexttile
Plot_Piezo_Data("serial_data_20250224_170155.csv"); nexttile
Plot_Piezo_Data("serial_data_20250224_170219.csv");

% exportgraphics(f2,'Coughing.png','Resolution',600)

figure; f3 = tiledlayout(1,2); nexttile

Plot_Piezo_Data("serial_data_20250224_171304.csv"); nexttile
Plot_Piezo_Data("serial_data_20250224_171415.csv")

% exportgraphics(f3,'extraPlots.png','Resolution',600)

figure; f4 = tiledlayout(1,3); nexttile

Plot_Piezo_Data("serial_data_20250224_170325.csv"); nexttile
Plot_Piezo_Data("serial_data_20250224_170403.csv"); nexttile
Plot_Piezo_Data("serial_data_20250224_170444.csv");

% exportgraphics(f4,'Talking.png','Resolution',600)

figure; f5 = tiledlayout(2,3); nexttile

Plot_Piezo_Data("ws1.csv"); nexttile
Plot_Piezo_Data("ws2.csv"); nexttile
Plot_Piezo_Data("ws3.csv"); nexttile
Plot_Piezo_Data("waterSwallow1.csv"); nexttile
Plot_Piezo_Data("waterSwallow2.csv"); nexttile
Plot_Piezo_Data("waterSwallow3.csv");

% exportgraphics(f5,'waterSwallow.png','Resolution',600)