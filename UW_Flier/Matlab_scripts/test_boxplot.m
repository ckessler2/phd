% daboxplot_demo a few examples of daboxplot functionality 
%
% Povilas Karvelis
% 15/04/2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all
rng('default')
% data in a cell array 
data1{1} = randn([60,4]); % Humans
data1{2} = randn([60,4]); % Dogs
data1{3} = randn([60,4]); % God
data1{4} = randn([60,4]); % Potato
% data in a numreic array (+ grouping indices)
data2 = [randn([30,4]); randn([30,4]);...
         randn([30,4]); randn([30,4])];
group_inx = [ones(1,30), 2.*ones(1,30), 3.*ones(1,30), 4.*ones(1,30)];
% skewed data in a numeric array (+ group indices)
data3 = [pearsrnd(0,1,-1,5,25,1); pearsrnd(0,1,-2,7,25,1); ...
    pearsrnd(0,1,1,8,25,1)];
group_inx2 = [ones(1,25), 2.*ones(1,25), 3.*ones(1,25)];
% data with group differences in a cell array
data4{1} = randn([60,3]) + (0:0.5:1);          % Humans
data4{2} = randn([60,3]) + (2:2:6);            % Dogs
group_names = {'Humans', 'Dogs' , 'God', 'Potato'};
condition_names = {'Water', 'Land', 'Moon', 'Hyperspace'};
% an alternative color scheme for some plots
c =  [0.45, 0.80, 0.69;...
      0.98, 0.40, 0.35;...
      0.55, 0.60, 0.79;...
      0.90, 0.70, 0.30];  
   
h = daboxplot(data4{1}(:,1),'xtlabels', "asd",'whiskers',1,...
    'scatter',1,'scattersize',25,'scatteralpha',0.6,'outliers',0);
set(gca,'FontSize',12)
% TIP: to make the plots vertical use camroll(-90)