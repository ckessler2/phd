clc; clear all; close all;
set(0,'DefaultFigureWindowStyle','docked')

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

names7 = get_csv_files("SwallowData2\NoisyBlankSwallowing\CricoidCartilage");
names8 = get_csv_files("SwallowData2\NoisyBlankSwallowing\HyoidBone");

names9 = get_csv_files("SwallowData2\Coughing\CricoidCartilage");
names10 = get_csv_files("SwallowData2\Coughing\HyoidBone");

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
% 
% [Im7,Im8]  = Extract_Images(string(names(4)),4.7,10.1);
% [Im9,Im10]  = Extract_Images(string(names(5)),5,10.2);
% [Im11,Im12]  = Extract_Images(string(names(6)),4.8,10.2);
% [Im13,Im14]  = Extract_Images(string(names(7)),5.3,10);
% [Im15,Im16]  = Extract_Images(string(names(8)),4.6,10);
% [Im17,Im18]  = Extract_Images(string(names(9)),4.9,12);

% Noisy blank swallow - cridoid
% names = names7;
% [Im1,Im2] = Extract_Images(string(names(1)),5.2,10.6);
% [Im3,Im4] = Extract_Images(string(names(2)),4.9,10);
% [Im5,Im6] = Extract_Images(string(names(3)),5.5,10.1);

% Noisy blank swallow - hyoid
% names = names10;
% [Im1,Im2] = Extract_Images(string(names(1)),4.8,10);
% [Im3,Im4] = Extract_Images(string(names(2)),4.4,10.2);
% [Im5,Im6] = Extract_Images(string(names(3)),5.4,11);

% % (OTHER) Blank swallow - cricoid
% names = [names1;names2;names3];
% % [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(1)),4,6);
% % [Im7,Im8]  = Extract_Images(string(names(1)),7,8);
% % [Im9,Im10]  = Extract_Images(string(names(1)),9,11.3);
% % [Im11,Im12]  = Extract_Images(string(names(1)),12.3,13.3);
% 
% % [Im1,Im2]  = Extract_Images(string(names(2)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(2)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(2)),4,6);
% % [Im7,Im8]  = Extract_Images(string(names(2)),7,8);
% % [Im9,Im10]  = Extract_Images(string(names(2)),9,11.7);
% % [Im11,Im12]  = Extract_Images(string(names(2)),12.7,13.7);
% 
% % [Im1,Im2]  = Extract_Images(string(names(3)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(3)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(3)),5.7,6.7);
% % [Im7,Im8]  = Extract_Images(string(names(3)),7.7,8.7);
% % [Im9,Im10]  = Extract_Images(string(names(3)),11,12);
% % [Im11,Im12]  = Extract_Images(string(names(3)),13,14);
% 
% % [Im1,Im2]  = Extract_Images(string(names(4)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(4)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(4)),5.7,6.7);
% % [Im7,Im8]  = Extract_Images(string(names(4)),7.7,8.7);
% % [Im9,Im10]  = Extract_Images(string(names(4)),11,12);
% % [Im11,Im12]  = Extract_Images(string(names(4)),13,14);

% % (OTHER) Blank swallow - hyoid
% names = [names4;names5;names6];
% % [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(1)),5.9,6.9);
% % [Im7,Im8]  = Extract_Images(string(names(1)),7.9,8.8);
% % [Im9,Im10]  = Extract_Images(string(names(1)),11.2,12.2);
% % [Im11,Im12]  = Extract_Images(string(names(1)),13.1,14);
% 
% % [Im1,Im2]  = Extract_Images(string(names(2)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(2)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(2)),3.8,6);
% % [Im7,Im8]  = Extract_Images(string(names(2)),7,8);
% % [Im9,Im10]  = Extract_Images(string(names(2)),8.8,11);
% % [Im11,Im12]  = Extract_Images(string(names(2)),12,13);
% 
% % [Im1,Im2]  = Extract_Images(string(names(3)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(3)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(3)),5.7,6.7);
% % [Im7,Im8]  = Extract_Images(string(names(3)),7.7,8.7);
% % [Im9,Im10]  = Extract_Images(string(names(3)),11,12);
% % [Im11,Im12]  = Extract_Images(string(names(3)),13,14);
% 
% % [Im1,Im2]  = Extract_Images(string(names(4)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(4)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(4)),5.7,6.7);
% % [Im7,Im8]  = Extract_Images(string(names(4)),7.7,8.7);
% % [Im9,Im10]  = Extract_Images(string(names(4)),11,12);
% % [Im11,Im12]  = Extract_Images(string(names(4)),13,14);

% % (OTHER) Noisy blank swallow - cridoid
% names = names7;
% % [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(1)),4.2,6.9);
% % [Im7,Im8]  = Extract_Images(string(names(1)),7.9,8.7);
% % [Im9,Im10]  = Extract_Images(string(names(1)),9.6,11.6);
% % [Im11,Im12]  = Extract_Images(string(names(1)),12.6,13.6);
% 
% % [Im1,Im2]  = Extract_Images(string(names(2)),0,1);
% % [Im3,Im4]  = Extract_Images(string(names(2)),2,3);
% % [Im5,Im6]  = Extract_Images(string(names(2)),3.9,5.9);
% % [Im7,Im8]  = Extract_Images(string(names(2)),6.9,7.8);
% % [Im9,Im10]  = Extract_Images(string(names(2)),8.9,11);
% % [Im11,Im12]  = Extract_Images(string(names(2)),12,13);
% 
% % [Im1,Im2]  = Extract_Images(string(names(3)),0,0.8);
% % [Im3,Im4]  = Extract_Images(string(names(3)),1.4,2.6);
% % [Im5,Im6]  = Extract_Images(string(names(3)),3.5,5.5);
% % [Im7,Im8]  = Extract_Images(string(names(3)),6.9,7.8);
% % [Im9,Im10]  = Extract_Images(string(names(3)),8.9,11);
% % [Im11,Im12]  = Extract_Images(string(names(3)),12,13);

% % (OTHER) Noisy blank swallow - hyoid
% names = names8;
% [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(1)),3.8,5.9);
% [Im7,Im8]  = Extract_Images(string(names(1)),6.9,7.7);
% [Im9,Im10]  = Extract_Images(string(names(1)),8.6,11);
% [Im11,Im12]  = Extract_Images(string(names(1)),12,13);
% 
% [Im1,Im2]  = Extract_Images(string(names(2)),0,0.8);
% [Im3,Im4]  = Extract_Images(string(names(2)),1.6,2.5);
% [Im5,Im6]  = Extract_Images(string(names(2)),3.4,5.4);
% [Im7,Im8]  = Extract_Images(string(names(2)),6.4,7.8);
% [Im9,Im10]  = Extract_Images(string(names(2)),8.9,11.2);
% [Im11,Im12]  = Extract_Images(string(names(2)),12.2,13.2);
% 
% [Im1,Im2]  = Extract_Images(string(names(3)),0,0.8);
% [Im3,Im4]  = Extract_Images(string(names(3)),1.4,2.6);
% [Im5,Im6]  = Extract_Images(string(names(3)),3.5,4.4);
% [Im7,Im8]  = Extract_Images(string(names(3)),6.9,7.8);
% [Im9,Im10]  = Extract_Images(string(names(3)),8.9,10);
% [Im11,Im12]  = Extract_Images(string(names(3)),12,13);

% (OTHER) Coughing - cricoid
% names = names9;
% [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(1)),4,5);
% [Im7,Im8]  = Extract_Images(string(names(1)),6,7);
% [Im9,Im10]  = Extract_Images(string(names(1)),8,9);
% [Im11,Im12]  = Extract_Images(string(names(1)),10.2,11.2);
% 
% [Im1,Im2]  = Extract_Images(string(names(2)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(2)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(2)),4.5,5.5);
% [Im7,Im8]  = Extract_Images(string(names(2)),6.5,7.5);
% [Im9,Im10]  = Extract_Images(string(names(2)),8.5,9.8);
% [Im11,Im12]  = Extract_Images(string(names(2)),10.8,11.8);
% 
% [Im1,Im2]  = Extract_Images(string(names(3)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(3)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(3)),4.6,5.5);
% [Im7,Im8]  = Extract_Images(string(names(3)),6.6,7.6);
% [Im9,Im10]  = Extract_Images(string(names(3)),8.6,9.6);
% [Im11,Im12]  = Extract_Images(string(names(3)),10.3,11.3);

% (OTHER) Coughing - hyoid
names = names10;
% [Im1,Im2]  = Extract_Images(string(names(1)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(1)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(1)),4,4.8);
% [Im7,Im8]  = Extract_Images(string(names(1)),6,7);
% [Im9,Im10]  = Extract_Images(string(names(1)),8,9);
% [Im11,Im12]  = Extract_Images(string(names(1)),10,11);
% 
% [Im1,Im2]  = Extract_Images(string(names(2)),0,1);
% [Im3,Im4]  = Extract_Images(string(names(2)),2,3);
% [Im5,Im6]  = Extract_Images(string(names(2)),4,5);
% [Im7,Im8]  = Extract_Images(string(names(2)),6,7);
% [Im9,Im10]  = Extract_Images(string(names(2)),8,9);
% [Im11,Im12]  = Extract_Images(string(names(2)),10,11);

[Im1,Im2]  = Extract_Images(string(names(3)),0,1);
[Im3,Im4]  = Extract_Images(string(names(3)),2,3);
[Im5,Im6]  = Extract_Images(string(names(3)),4.7,5.7);
[Im7,Im8]  = Extract_Images(string(names(3)),6.7,7.7);
[Im9,Im10]  = Extract_Images(string(names(3)),8.7,9.8);
[Im11,Im12]  = Extract_Images(string(names(3)),10.8,11.8);


Images = [[Im1], [Im2], [Im3], [Im4], [Im5], [Im6]];
Images = [Images, [Im7], [Im8], [Im9], [Im10], [Im11], [Im12]];
% Images = [Images, [Im13], [Im14], [Im15], [Im16], [Im17], [Im18]];

for i = 1:length(Images)/ 28
    nexttile; 
    imshow(Images(:,28*i - 27:28*i));
    % filename = "Dataset_1/Swallow/Noisy_Hyoid_"+string(i)+".png";
    filename = "Dataset_1/Other/Coughing_Hyoid_3_"+string(i)+".png";
    imwrite(Images(:,28*i - 27:28*i),filename)
end