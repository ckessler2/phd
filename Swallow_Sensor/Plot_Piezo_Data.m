function Plot_Piezo_Data(filename)

    data = readtable(filename);
    
    % tiledlayout(2,1)
    % nexttile
    % plot(data.Time,data.Voltage)
    % xlabel('Time (s)');
    % ylabel('Voltage (V?)');
    % xlim([0 26])
    % nexttile
    
    time = data.Time;
    voltage = data.Voltage;
    time_intervals = zeros(numel(time),1);
    for i = 1:numel(time)-1
        time_intervals(i) = time(i+1) - time(i);
    end
    average_sampling_rate = mean(time_intervals);
    
    total_duration = max(time) - min(time);
    new_sampling_rate = 1/round(average_sampling_rate,5);
    total_points = ceil(new_sampling_rate * total_duration);
    
    new_time = linspace(min(time), max(time), (max(time) - min(time)) * new_sampling_rate);
    new_voltage = interp1(time, voltage, new_time, 'linear'); 
    
    window_size = 32; % Segment size for FFT
    overlap = round(0.8 * window_size); % Number of overlapped samples
    nfft = 512; % Number of DFT points
    
    spectrogram(new_voltage, window_size, overlap, nfft, new_sampling_rate, 'yaxis');
    c = colorbar('XTick', -150:5:30);
    clim([-10 40])
    c.Limits = [-10 40];
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colormap(gca,hot);
    % set(gca,'ColorScale','log')
    xlim([0 26])
    filename  = erase(filename ,"_");

    title("\textbf{" + filename + "}",'Interpreter', 'latex');
    
end