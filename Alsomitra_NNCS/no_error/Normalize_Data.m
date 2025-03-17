clc; clear

% load("Normalisation_Constants.mat")
% Cs = data2(:,1);
% Ss = data2(:,2);

% NOT NORMALIZED
load('Training_Data.mat')

Cs = [];
Ss = [];
data_true = data;

% NORMALIZATION (gets Cs and Ss)
for i = 1:7
    [N,C,S] = normalize(data(:,i),"range") ;
    data(:,i) = N;
    Cs = [Cs,C];
    Ss = [Ss,S];
end

data_norm = data;

writematrix(data_norm,'Training_Data_Normalised.csv') 
save('Training_Data_Normalised','data_norm')

data_true_2 = data_norm;

% CHECK METHOD

%  DENORMALIZATION (requires Cs and Ss)
for n = 1:length(data_norm)
    data_true_2(n,:) = (data_norm(n,:) .* Ss)+ Cs;
end

% NORMALIZATION (gets Cs and Ss), manually
data_norm_2 = data_true;
for n = 1:length(data_norm)
    % for n = 1:length(data_norm)
    %     data_norm_2(n,i) = (data_true(n,i) - Cs(i)) / Ss(i);
    % end
    data_norm_2(n,:) = (data_true(n,:) - Cs) ./ Ss;

end