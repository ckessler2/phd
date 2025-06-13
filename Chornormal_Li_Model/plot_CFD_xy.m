clear all; clc; close all

[t0, courant0, x0, y0, z0, ux0, uy0, uz0] = get_data('GR_0.dat');

plot(x0, z0-t0)

x_ = x0(4000:end);
y_ = z0(4000:end) - t0(4000:end);

x2 = x_(300:end) - x_(300);
y2 = y_(300:end) - y_(300);

for i=1:length(x2)
    [theta2,rho] = cart2pol(x2(i),y2(i));
    [x2(i),y2(i)] = pol2cart(theta2+pi/2,rho);
end

plot(x2, y2); hold on

peaks_y = [];
peaks_t = [];
peaks_x = 0;
valleys_y = [];
valleys_t = [];
valleys_x = [];
count = 1;

for i=2:(length(y2)-1)
    if y2(i) > y2(i+1) & y2(i) > y2(i-1) & x2(i) > (peaks_x(count) + 5)
        peaks_y = [peaks_y,y2(i)];
        peaks_t = [peaks_t,t0(i)];
        peaks_x = [peaks_x,x2(i)];
        count = count + 1;
    elseif y2(i) < y2(i+1) & y2(i) < y2(i-1)
        valleys_y = [valleys_y,y2(i)];
        valleys_x = [valleys_x,x2(i)];
    end
end

peaks_x = peaks_x(2:end);

% scatter(peaks_x,peaks_y,"filled","red")
% scatter(valleys_x,valleys_y,"filled","red")

amps = [];
periods = [];
f = [];

for i=1:min(length(peaks_y),length(valleys_y))
    amps = [amps,abs(peaks_y(i) - valleys_y(i))];
end

for i=1:min(length(peaks_y),length(valleys_y))-1
    periods = [periods,abs(peaks_x(i) - peaks_x(i+1))];
end
amp = abs(mean(amps))/2;
per = abs(mean(periods));