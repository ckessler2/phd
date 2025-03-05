function Plot_Piezo_Data_2(filename)

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
    
    window_size = 512; % Segment size for FFT
    overlap = round(0.8 * window_size); % Number of overlapped samples
    nfft = 512; % Number of DFT points

    % if filename == 'Rest\HyoidBone\8PS\serial_data_20250228_112554.csv'
    %     a = 1;
    % end
    
    spectrogram(new_voltage, window_size, overlap, nfft, new_sampling_rate, 'yaxis');
    c = colorbar('XTick', -200:5:30);
    clim([-60 -20])
    % c.Limits = [-10 40];
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colormap(gca,hot);
    set(gca,'ColorScale','log')
    xlim([0 15])
    filename  = erase(filename ,"_");

    title(filename);
    daspect([1 300 10])
    a = 1;
end