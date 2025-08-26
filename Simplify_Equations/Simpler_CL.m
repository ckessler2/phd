% Constants
C_L1 = 5.2;
C_L2 = 0.95;
alpha0 = deg2rad(14);
delta = deg2rad(6);

syms alpha a b c d e

% Define Falpha3
Falpha3 = @(alpha) (1 - tanh((alpha - alpha0) / delta)) / 2;

% Original C_Lalpha3 function
C_Lalpha3_original = @(alpha) Falpha3(alpha) .* C_L1 .* sin(alpha) + (1 - Falpha3(alpha)) .* C_L2 .* sin(2 * alpha);

% Simplified C_Lalpha3 function
C_Lalpha3_simplified = @(alpha, a, b, c, d) C_L2 .* sin(2 .* alpha) + a .* exp(-b .* alpha .^ d) .* sin(c .* alpha);
CLalpha3_simp_deriv = @(alpha, a, b, c) 2 .* 0.95 .* cos(2 .* alpha) - a .* b .* exp(-b .* alpha) .* sin(c .* alpha) + a .* exp(-b .* alpha) .* c .* cos(c .* alpha);
CLalpha3_simp_deriv = @(alpha, a, b, c, d) (19.*cos(2.*alpha))/10 + a.*c.*exp(-alpha.^d.*b).*cos(alpha.*c) - a.*alpha.^(d - 1).*b.*d.*exp(-alpha.^d.*b).*sin(alpha.*c);

C_Lalpha3_simplified = @(alpha, a, b, c, d)  d .* sin(2 .* alpha) .* (a + b.* exp((-c.*(sin(2.* alpha - pi/2)))));
CLalpha3_simp_deriv = @(alpha, a, b, c, d)  2 .* d .*cos(2.*alpha).*(a + b.*exp(-c.*sin(2.*alpha - 1.5708))) - 1.9000.*b.*c.*sin(2.*alpha).*exp(-c.*sin(2.*alpha - 1.5708)).*cos(2.*alpha - 1.5708);

% Sample data
alpha_data = linspace(0, pi/2, 100);  % Range of alpha
C_L_data = C_Lalpha3_original(alpha_data);

% Assuming alpha_data and C_L_data are defined as above
dC_L_data = gradient(C_L_data, alpha_data);

% Combined cost function
combined_cost = @(p, alpha) [C_Lalpha3_simplified(alpha, p(1), p(2), p(3), p(4)) - C_L_data, ...
                             (CLalpha3_simp_deriv(alpha, p(1), p(2), p(3), p(4)) - dC_L_data)];

opts = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxIter', 1000, 'TolFun', 1e-16, 'MaxFunEvals', 500000, "StepTolerance", 0);
opts.FinDiffRelStep = 0.1;  % Default is sqrt(eps). Increasing might promote broader searches.

% initial_guess = [10943, 53.026, 0.000309489, 3];  % Initial guesses for [a, b, c]
initial_guess = [1 6 8.16 0.5];
[params_fitted, resnorm] = lsqnonlin(@(p) combined_cost(p, alpha_data), initial_guess, [], [], opts);

figure;
subplot(2, 1, 1);  % Plot the function
plot(alpha_data, C_L_data, '-', alpha_data, C_Lalpha3_simplified(alpha_data, params_fitted(1), params_fitted(2), params_fitted(3), params_fitted(4)), '--');
title('Comparison of the Function Fit');
legend('Original', 'Fitted Simplified');

subplot(2, 1, 2);  % Plot the derivative
plot(alpha_data, dC_L_data, '-', alpha_data, CLalpha3_simp_deriv(alpha_data, params_fitted(1), params_fitted(2), params_fitted(3), params_fitted(4)), '--');
title('Comparison of the Derivative Fit');
legend('Original Derivative', 'Fitted Simplified Derivative');
xlim([0 pi/2])