% Define the number of classes
numClasses = 4;  % As you mentioned classes 0-3

% Initialize an empty cell array to store folder names
folderNames = {};

% Loop through each class number
for i = 0:numClasses-1
    % For each class, create 'test' and 'train' folders
    folderNames{end+1} = ['class' num2str(i) 'test'];
    folderNames{end+1} = ['class' num2str(i) 'train'];
end

for k = 1:length(folderNames)
    mkdir(folderNames{k});  % Creates a folder with the name specified by folderNames{k}
end