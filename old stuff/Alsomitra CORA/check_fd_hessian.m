x2 = interval( ...
        [1; 0; 0; 0; 0; 0.1/0.07; 0; 0.181],...
        [2; 0; 0; 0; 0; 0.3/0.07; 0; 0.181]);
h_a = hessianTensorInt_nondimfreelyfallingplate6Controlled(x2,0.181);

max_errs = [];
mean_errs = [];
deltas = [];

for i = 0
    delta = 10^(-6 - i/10);
    [max_err,mean_err] = compare_hessians(delta, x2, h_a);
    max_errs = [max_errs;max_err];
    mean_errs = [mean_errs;mean_err];
    deltas = [deltas;delta];
end

set(0, 'defaultFigureRenderer', 'painters')
set(0,'DefaultFigureWindowStyle','docked')
font=12;
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesFontSize', font)
set(0, 'defaultLegendFontSize', font)
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultLegendFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 1.0);

plot(deltas,max_errs,'Color',[0.2656    0.0039    0.3281]); hold on
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log')
set(gca, 'XDir','reverse'); grid on
xlabel('Delta');ylabel('Absolute Error');

plot(deltas,mean_errs,'Color',[0.1289    0.5664    0.5469])
legend('Maximum Absolute Error', 'Mean Absolute (nonzero) Error')
xlim([min(deltas),max(deltas)])
% ylim([1e-9, 1e-2])

function [max_err,mean_err] = compare_hessians(delta, x2, h_a)
    
    h_fd = hessianTensorInt_nondimfreelyfallingplate6Controlled_FD(x2,0.181,delta);
    
    fd_array = [];
    a_array = [];
    errors = [];
    
    for c = 1:8
        for b = 1:9
            for a = 1:9
                int_fd = h_fd{1,c}(b,a);
                int_a = h_a{1,c}(b,a);
                fd_array = [fd_array;max(int_fd);min(int_fd)];
                a_array = [a_array;max(int_a);min(int_a)];
                errors = [errors;abs(max(int_fd)-max(int_a));abs(min(int_fd)-min(int_a))];
                
            end
        end
    end
    
    
    fprintf("max absolute error = " + num2str(max(errors)) + "\n")
    fprintf("mean absolute nonzero error = " + num2str(mean(errors)) + "\n")

    max_err = max(errors);
    mean_err = mean(errors(find(errors)));
end