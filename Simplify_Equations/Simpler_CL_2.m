% Constants
C_L1 = 5.2;
C_L2 = 0.95;
alpha0 = deg2rad(14);
delta = deg2rad(6);

syms alpha a b c d

% Define Falpha3
Falpha3 = @(alpha) (1 - tanh((alpha - alpha0) / delta)) / 2;

% Original C_Lalpha3 function
C_Lalpha3_original = @(alpha) Falpha3(alpha) .* C_L1 .* sin(alpha) + (1 - Falpha3(alpha)) .* C_L2 .* sin(2 * alpha);

% Simplified C_Lalpha3 function
C_Lalpha3_simplified = @(alpha, a, b) C_L2 .* sin(2 .* alpha) .* (1 + a.* exp(-b.*(sin(alpha)).^2));
C_L

1.9000*cos(2*alpha)*(a*exp(-b*sin(alpha)^2) + 1) - 1.9000*a*b*sin(2*alpha)*exp(-b*sin(alpha)^2)*cos(alpha)*sin(alpha)

% Sample data
alpha_data = linspace(0, pi/2, 100);  % Range of alpha
C_L_data = C_Lalpha3_original(alpha_data);

% Assuming alpha_data and C_L_data are defined as above
dC_L_data = gradient(C_L_data, alpha_data);

% Combined cost function
combined_cost = @(p, alpha) [C_Lalpha3_simplified(alpha, p(1), p(2)) - C_L_data];

opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIter', 100000, 'TolFun', 1e-16, 'MaxFunEvals', 500000, "StepTolerance", 0);
initial_guess = [3 60];  % Initial guesses for [a, b, c]
[params_fitted, resnorm] = lsqnonlin(@(p) combined_cost(p, alpha_data), initial_guess, [], [], opts);

figure;
subplot(2, 1, 1);  % Plot the function
plot(alpha_data, C_L_data, '-', alpha_data, C_Lalpha3_simplified(alpha_data, params_fitted(1), params_fitted(2)), '--');
title('Comparison of the Function Fit');
legend('Original', 'Fitted Simplified');

subplot(2, 1, 2);  % Plot the derivative
plot(alpha_data, dC_L_data, '-', alpha_data, CLalpha3_simp_deriv(alpha_data, params_fitted(1), params_fitted(2)), '--');
title('Comparison of the Derivative Fit');
legend('Original Derivative', 'Fitted Simplified Derivative');
xlim([0 pi/2])