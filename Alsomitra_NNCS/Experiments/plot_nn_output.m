x = -1.2:0.01:0.1;
y = [];
y2 = [];

nn = importNetworkFromONNX('Alsomitra_Controller6.onnx',InputDataFormats='BC');

for i=1:length(x)
    y = [y,nn.predict([x(i)])* (0.012) + 0.181];
    y2_ = 0.1*x(i) + 0.181;
    if y2_ > 0.193
        y2_ = 0.193;
    elseif y2_ < 0.181
        y2_ = 0.181;
    end
    y2 = [y2,y2_];
end

figure
plot(x,y); hold on
plot(x,y2)

xlim([-1.2 0.1])

figure
plot(y2,y)