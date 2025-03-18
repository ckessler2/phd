clc; clear all; close all;

font=9;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 0.7);

names1 = get_csv_files("SwallowData2\BlankSwallow\CricoidCartilage\8PS");
names2 = get_csv_files("SwallowData2\BlankSwallow\CricoidCartilage\64PS");
names3 = get_csv_files("SwallowData2\BlankSwallow\CricoidCartilage\128PS");

names4 = get_csv_files("SwallowData2\BlankSwallow\HyoidBone\8PS");
names5 = get_csv_files("SwallowData2\BlankSwallow\HyoidBone\64PS");
names6 = get_csv_files("SwallowData2\BlankSwallow\HyoidBone\128PS");

names = [names1;names2;names3;names4;names5;names6];
figure; f1 = tiledlayout(6,3);
for n =1:length(names)
    nexttile;
    Plot_Piezo_Data_2(string(names(n)))
end

names7 = get_csv_files("SwallowData2\Coughing\CricoidCartilage");
names8 = get_csv_files("SwallowData2\Coughing\HyoidBone");
names = [names7;names8];
figure; f2 = tiledlayout(2,3);
for n =1:length(names)
    nexttile;
    Plot_Piezo_Data_2(string(names(n)))
end

names9 = get_csv_files("SwallowData2\NoisyBlankSwallowing\CricoidCartilage");
names10 = get_csv_files("SwallowData2\NoisyBlankSwallowing\HyoidBone");
names = [names9;names10];
figure; f3 = tiledlayout(2,3);
for n =1:length(names)
    nexttile;
    Plot_Piezo_Data_2(string(names(n)))
end

names11 = get_csv_files("SwallowData2\Rest\CricoidCartilage\8PS");
names12 = get_csv_files("SwallowData2\Rest\CricoidCartilage\64PS");
names13 = get_csv_files("SwallowData2\Rest\CricoidCartilage\128PS");

names14 = get_csv_files("SwallowData2\Rest\HyoidBone\8PS");
names15 = get_csv_files("SwallowData2\Rest\HyoidBone\64PS");
names16 = get_csv_files("SwallowData2\Rest\HyoidBone\128PS");

names = [names11;names12;names13;names14;names15;names16];
figure; f4 = tiledlayout(6,3);
for n =1:length(names)
    nexttile;
    % disp(names(n))
    Plot_Piezo_Data_2(string(names(n)))
    % disp("success")
end

names17 = get_csv_files("SwallowData2\WaterSwallow\CricoidCartilage\8PS");
names18 = get_csv_files("SwallowData2\WaterSwallow\CricoidCartilage\64PS");
names19 = get_csv_files("SwallowData2\WaterSwallow\CricoidCartilage\128PS");

names20 = get_csv_files("SwallowData2\WaterSwallow\HyoidBone\8PS");
names21 = get_csv_files("SwallowData2\WaterSwallow\HyoidBone\64PS");
names22 = get_csv_files("SwallowData2\WaterSwallow\HyoidBone\128PS");

names = [names17;names18;names19;names20;names21;names22];
figure; f5 = tiledlayout(6,3);
for n =1:length(names)
    nexttile;
    % disp(names(n))
    Plot_Piezo_Data_2(string(names(n)))
    % disp("success")
end



% exportgraphics(f1,'blankSwallow.png','Resolution',600)



function allFileNames = get_csv_files(root)
    % location = "\SwallowData2\BlankSwallow\HyoidBone\8PS";
    filePattern = fullfile(root, "*.csv");
    ds = fileDatastore(filePattern, 'ReadFcn', @readmatrix);
    allFileNames = ds.Files;
end