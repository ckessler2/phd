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

% names = [names1;names2;names3;names4;names5;names6];

figure;  f1 = tiledlayout(3,6); 

% Blank swallow - cricoid
% names = [names1;names2;names3];
% [Im1,Im2]  = Extract_Images(string(names(1)),5,10.3);
% [Im3,Im4]  = Extract_Images(string(names(2)),5,10.7);
% [Im5,Im6]  = Extract_Images(string(names(3)),4.7,9.9);
% [Im7,Im8]  = Extract_Images(string(names(4)),4.8,10.3);
% [Im9,Im10]  = Extract_Images(string(names(5)),4.6,10.1);
% [Im11,Im12]  = Extract_Images(string(names(6)),4.9,10);
% [Im13,Im14]  = Extract_Images(string(names(7)),4.9,10.1);
% [Im15,Im16]  = Extract_Images(string(names(8)),3.9,10.2);
% [Im17,Im18]  = Extract_Images(string(names(9)),4.8,10.2);

% Blank swallow - hyioid
% names = [names4;names5;names6];
% [Im1,Im2]  = Extract_Images(string(names(1)),4.9,10.2);
% [Im3,Im4]  = Extract_Images(string(names(2)),4.8,9.8);
% [Im5,Im6]  = Extract_Images(string(names(3)),4.5,10);
% [Im7,Im8]  = Extract_Images(string(names(4)),4.7,10.1);
% [Im9,Im10]  = Extract_Images(string(names(5)),5,10.2);
% [Im11,Im12]  = Extract_Images(string(names(6)),4.8,10.2);
% [Im13,Im14]  = Extract_Images(string(names(7)),5.3,10);
% [Im15,Im16]  = Extract_Images(string(names(8)),4.6,10);
% [Im17,Im18]  = Extract_Images(string(names(9)),4.9,12);


Images = [[Im1], [Im2], [Im3], [Im4], [Im5], [Im6]];
Images = [Images, [Im7], [Im8], [Im9], [Im10], [Im11], [Im12]];
Images = [Images, [Im13], [Im14], [Im15], [Im16], [Im17], [Im18]];

for i = 1:18
    nexttile; 
    imshow(Images(:,28*i - 27:28*i));
    filename = "Dataset_1/Swallow/Cricoid_"+string(i)+".png";
    imwrite(Images(:,28*i - 27:28*i),filename)
end