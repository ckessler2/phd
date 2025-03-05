function [Im1,Im2] = Extract_Images(filename,t1,t2)

    data = readtable(filename);

    filename = erase(filename, "C:\Users\ck2049\Desktop\Swallow Data\SwallowData2\");
    
    % tiledlayout(2,1)
    % nexttile
    % plot(data.Time,data.Voltage)
    % xlabel('Time (s)');
    % ylabel('Voltage (V?)');
    % xlim([0 26])
    % nexttile
    voltage = data.RawData;
    voltage = rmmissing(voltage);

    time = 0:15/length(voltage):15;



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
    
    window_size = 328; % Segment size for FFT
    % window_size =82;
    overlap = round(0.8 * window_size); % Number of overlapped samples
    % overlap = 0;
    % nfft = 55; % Number of DFT points
    nfft = 110;

    % if filename == 'Rest\HyoidBone\8PS\serial_data_20250228_112554.csv'
    %     a = 1;
    % end
    
    [s,f,t] = spectrogram(new_voltage, window_size, overlap, nfft, new_sampling_rate, 'yaxis'); 
    I = (normalize(abs(s)', 'range', [0 1]));
    I = imrotate(I,90);
    

    net = denoisingNetwork("DnCNN");
    I = denoiseImage(I,net);
    % I = ( -cos( pi * mat2gray( I ) ) + 1 ) / 2;


    [val1,idx1]=min(abs(t-t1));
    [val3,idx2]=min(abs(t-t2));
    Im1 = I(:,idx1:idx1+27);
    Im2 = I(:,idx2:idx2+27);
    % Im1 = I(:,idx1:idx1+111);
    % Im2 = I(:,idx2:idx2+111);

    
    Im1 = reduce_size(Im1);
    Im2 = reduce_size(Im2);

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