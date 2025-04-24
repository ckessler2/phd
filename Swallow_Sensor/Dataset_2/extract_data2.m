% clc; clear all

% Load mat files
load("A:\Big_Downloads\male.mat");

% Progress bar
f = waitbar(0, 'Starting');

% CLASS 0 test
tic
% for i = 1:length(class0test)
for i = 1:411
    waitbar(i/411, f, sprintf('Processing Class 0: %d %%', floor(i/411*100)));
    voltage1 = squeeze(class0test(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class0test\class0test_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 0 train
tic
for i = 1:3703
    waitbar(i/3703, f, sprintf('Processing Class 0: %d %%', floor(i/3703*100)));
    voltage1 = squeeze(class0train(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class0train\class0train_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 1 test
tic
for i = 1:345
    waitbar(i/345, f, sprintf('Processing Class 1: %d %%', floor(i/345*100)));
    voltage1 = squeeze(class1test(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class1test\class1test_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 1 train
tic
for i = 1:3107
    waitbar(i/3107, f, sprintf('Processing Class 1: %d %%', floor(i/3107*100)));
    voltage1 = squeeze(class1train(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class1train\class1train_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 2 test
tic
for i = 1:227
    waitbar(i/227, f, sprintf('Processing Class 2: %d %%', floor(i/227*100)));
    voltage1 = squeeze(class2test(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class2test\class2test_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 2 train
tic
for i = 1:2043
    waitbar(i/2043, f, sprintf('Processing Class 2: %d %%', floor(i/2043*100)));
    voltage1 = squeeze(class2train(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class2train\class2train_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 3 test
tic
for i = 1:255
    waitbar(i/255, f, sprintf('Processing Class 2: %d %%', floor(i/255*100)));
    voltage1 = squeeze(class3test(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class3test\class3test_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% CLASS 3 train
tic
for i = 1:2291
    waitbar(i/2291, f, sprintf('Processing Class 2: %d %%', floor(i/2291*100)));
    voltage1 = squeeze(class3train(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "class3train\class3train_"+string(i)+".png";
    imwrite(im1,filename)
end
toc

% % CLASS 3a test
% tic
% for i = 1:84
%     waitbar(i/84, f, sprintf('Processing Class 2: %d %%', floor(i/84*100)));
%     voltage1 = squeeze(class3atest(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "class3atest\class3atest_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc
% 
% % CLASS 3a train
% tic
% for i = 1:751
%     waitbar(i/751, f, sprintf('Processing Class 2: %d %%', floor(i/751*100)));
%     voltage1 = squeeze(class3atrain(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "class3atrain\class3atrain_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc
% 
% % CLASS 3b test
% tic
% for i = 1:38
%     waitbar(i/38, f, sprintf('Processing Class 2: %d %%', floor(i/38*100)));
%     voltage1 = squeeze(class3btest(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "class3btest\class3btest_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc
% 
% % CLASS 3b train
% tic
% for i = 1:339
%     waitbar(i/339, f, sprintf('Processing Class 2: %d %%', floor(i/339*100)));
%     voltage1 = squeeze(class3btrain(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "class3btrain\class3btrain_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc





function Im1 = Extract_Image(voltage)

    voltage = rmmissing(voltage);

    time = 0:1.5/length(voltage):1.5;

    time_intervals = zeros(numel(time),1);
    for i = 1:numel(time)-1
        time_intervals(i) = time(i+1) - time(i);
    end
    average_sampling_rate = mean(time_intervals);

    
    total_duration = max(time) - min(time);
    new_sampling_rate = 1/round(average_sampling_rate,5);
    total_points = ceil(new_sampling_rate * total_duration);
    
    % new_time = linspace(min(time), max(time), (max(time) - min(time)) * new_sampling_rate);
    % new_voltage = interp1(time, voltage, new_time, 'linear'); 

    new_time = time;
    new_voltage = voltage;
    
    window_size = 256; % Segment size for FFT
    % window_size =82;
    overlap = round(0.8 * window_size); % Number of overlapped samples
    % overlap = 0;
    % nfft = 55; % Number of DFT points
    nfft = 110;

    % if filename == 'Rest\HyoidBone\8PS\serial_data_20250228_112554.csv'
    %     a = 1;
    % end
    
    [s,f,t] = spectrogram(new_voltage, window_size, overlap); 
    I = (normalize(abs(s)', 'range', [0 1]));
    I = imrotate(I,90);
    

    % net = denoisingNetwork("DnCNN");
    % I = denoiseImage(I,net);

    [val1,idx1]=min(abs(time));
    Im1 = I(:,idx1:idx1+27);
    
    Im1 = reduce_size(Im1);
end


function I = reduce_size(I)
     for i = 1:28
        for j = 1:28
            I2(i,j) = mean([I(2*i-1,j),I(2*i,j)]);
            % I = 1
        end
     end
     I = I2;
end