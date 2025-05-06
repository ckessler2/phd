% Define the data with appropriate class order
data = [359, 23, 21,  8;
        14, 308,  3, 20;
        12,   5, 155, 55;
        20,  12, 41, 182];

data2 = [254	66	49	42
    95	170	21	59
    67	30	67	63
    46	38	53	118];

% Define the names of the classes in the order of the rows/columns of data
classNames = {'No Swallow', 'Blank Swallow', 'Water Swallow', 'Food Swallow'};

% fig = figure;
% set(gcf, 'Position', 1.1*[fig.Position(1), fig.Position(2), fig.Position(3)/1.5, fig.Position(4)/1.5]);
% 
% % Create the confusion matrix chart using these class names
% cm = confusionchart(data2, classNames);
% sortClasses(cm,["No Swallow", "Blank Swallow", "Water Swallow", "Food Swallow"])
% 
% % Set the title and cmis labels
% % cm.Title = 'Confusion Matrix for Random Forest on Male Dataset';
% cm.Title = 'Confusion Matrix for Neural Network on Male Dataset';
% cm.XLabel = 'Predicted Class';
% cm.YLabel = 'True Class';
% cm.FontName = 'Times New Roman';  % Set up the font face

data2 =  csvread("NN2_1_loss.csv");
acc1 = data2(1,:);
acc2 = data2(2,:);
loss1 = data2(3,:);
loss2 = data2(4,:);


data3 =  csvread("NN2_2_loss.csv");
acc3 = data3(1,:);
acc4 = data3(2,:);
loss3 = data3(3,:);
loss4 = data3(4,:);

t = tiledlayout(2,2); nexttile

plot(1:150,acc1,"LineWidth",1); hold on
plot(1:150,acc2,"LineWidth",1); 

% xlabel("Training Epoch")
ylabel("Accuracy")
box on; pbaspect([3 1 1]);ylim([0 1])

legend("Train", "Validation")

nexttile

plot(1:150,acc3,"LineWidth",1); hold on
plot(1:150,acc4,"LineWidth",1); 

% xlabel("Training Epoch")
% ylabel("Accuracy")
box on; pbaspect([3 1 1]); ylim([0 1])
nexttile

plot(1:150,loss1,"LineWidth",1); hold on
plot(1:150,loss2,"LineWidth",1); 

xlabel("Training Epoch")
ylabel("Loss")
box on; pbaspect([3 1 1])
yscale("log")
yticks([0.5 1])


nexttile

plot(1:150,loss3,"LineWidth",1); hold on
plot(1:150,loss4,"LineWidth",1); 

xlabel("Training Epoch")
% ylabel("Loss")
box on; pbaspect([3 1 1])
yscale("log")
yticks([1 2])