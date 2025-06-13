% Define the range and resolution for x and y
x = linspace(0, 42, 42);
y = linspace(-42, 5, 47);

% Create meshgrid for the domain
[X, Y] = meshgrid(x, y);

% Define your function, f, in terms of X and Y
f = 0.19 + (0.05 * (X + Y));
f = max(min(f, 0.193), 0.181);

% Plot the function as a gradient
figure; tiledlayout("flow"); nexttile
imagesc(x, y, f);
colorbar; % Adds a color bar to indicate the scale
axis xy; % Corrects the axis orientation
xlabel('x');
ylabel('y');
nexttile;

nn = importNetworkFromONNX('Reachability\adversarial_model_005_denorm.onnx',InputDataFormats='BC');

vars = [3.198062764	-0.068648196	0.001018501	-0.745166944];
f2 = zeros(size(X));
% Loop through each (X,Y) pair
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        % Concatenate fixed inputs with current (X, Y) values
        input = [vars, X(i, j), Y(i, j)];

        % Compute the neural network output
        f2(i, j) = nn.predict(input);
    end
end

imagesc(x, y, f2);
colorbar; % Adds a color bar to indicate the scale
axis xy; % Corrects the axis orientation
xlabel('x');
ylabel('y');