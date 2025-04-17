% clc; clear all
% 
% % Load mat files
% load("C:\Users\ck2049\Downloads\v1\v1\class0.mat");
% load("C:\Users\ck2049\Downloads\v1\v1\class1.mat");
% load("C:\Users\ck2049\Downloads\v1\v1\class2.mat");

% Progress bar
f = waitbar(0, 'Starting');

% CLASS 0
% tic
% for i = 1:length(class0)
%     waitbar(i/6256, f, sprintf('Processing Class 0: %d %%', floor(i/6256*100)));
%     voltage1 = squeeze(class0(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "Class0\Class0_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc

% CLASS 1
% tic
% for i = 1:1986
%     waitbar((3197+i)/6256, f, sprintf('Processing Class 1: %d %%', floor((3197+i)/6256*100)));
%     voltage1 = squeeze(class1(i,1,:));
%     im1 = Extract_Image(voltage1);
%     filename = "Class1\Class1_"+string(i)+".png";
%     imwrite(im1,filename)
% end
% toc

% CLASS 2
tic
for i = 1:1073
    waitbar((5183+i)/6256, f, sprintf('Processing Class 2: %d %%', floor((5183+i)/6256*100)));
    voltage1 = squeeze(class2(i,1,:));
    im1 = Extract_Image(voltage1);
    filename = "Class2\Class2_"+string(i)+".png";
    imwrite(im1,filename)
end
toc
close(f)

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
    

    net = denoisingNetwork("DnCNN");
    I = denoiseImage(I,net);

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