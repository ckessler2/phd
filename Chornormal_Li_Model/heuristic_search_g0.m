clear all; close all; clc;
ObjectiveFunction = @Alsomitra_nondim3;

% Maximum and minimum bounds for 9 coefficients
max_coefficients = [6.3,1,0.2,13,2,0.3,7.7,0.43,pi];
min_coefficients = [3.9,0.712,0.075,3.76,1.42,0.22,2.62,0.15,1.1]/1.5;

% Maximum and minimum values for e_x
ex = 0;

% Amplitude and Period
p1 = [1.0849e-04 7.8361];

t1=tic;
[new_coefficients1, e_x1, x_pc1,y_11] = h_search(max_coefficients, min_coefficients, ex, p1);
toc(t1)

function [new_coefficients, e_x, x_pc,y_1] =  h_search(max_coefficients, min_coefficients, ex, p1)

    % Optimisation part 1 - finds values for 9 aerodynamic coefficients
    % Each iteration (random_coefficients) runs 400* simulations with
    % random coefficient values between bounds
    
    % After every iteration, the bounds are tightened (tighten_coefficient_bounds)
    % based on the best 14* results from the dataset, for each seed
    
    % After 120* iterations (46k simulations), bounds are said to 
    % have converged on a single value for each coefficient
    % This is shown on the plot; average paramater range size decreases to 0.3%
    
    % This part has 3 parameters (marked with *) affecting performance & results. 
    % I chose values by trial and error, so they may not be optimal

    its = 40; % 400
    opt_its = 12; % 120
    cutoff = 4; % 14
    % ex_its = 1200; % (max_ex-min_ex)/0.0001

    percents = [100 100 100 100 100 100 100 100 100];
    warning('off','all'); tic
    
    fprintf("Optimisation iteration:  \n1-1","Interpreter","Latex");

    figure; hold on
    [data1] = random_coefficients([],1,its, min_coefficients, max_coefficients,p1);
    
    maxs = [max(data1(:,17))];
    mins = [min(data1(:,17))];
    [max_,min_,percents,maxs,mins] = tighten_coefficient_bounds(data1,cutoff,min_coefficients,max_coefficients,percents,maxs,mins);
    
    for n=1:opt_its-1
    % for n=1
        % tic
        if n > 10
            fprintf("\b")
        elseif n > 100
            fprintf("\b")
        end
        fprintf("\b\b\b" + string(n+1)+"-1");
        
        if mod(n,20)==0
            % fprintf("\b")
            if numel(num2str(n)) == 2
                % fprintf("\b")
            end
            
            
        end
        % figure; hold on
        [data1] = random_coefficients([],n,its, min_, max_,p1);
        [max_,min_,percents,maxs,mins] = tighten_coefficient_bounds(data1,cutoff,min_coefficients,max_coefficients,percents,maxs,mins);
        % toc
        % fprintf(", " + (n+1)); 
        % % toc
    end
    toc 
    
    % Optimisation part 2 - find values for e_x, with 9 coefficients fixed
    % Exact values for 9 coefficients are taken by averaging best results in 
    % most recent dataset (average_coefficients)
    
    % With 9 coefficients fixed, 3k simulations are run with changing values
    % of e_x between 0 and 0.3 (iterate_e_x)
    
    % Final values for coefficients are stored in new_coefficients
    % Final values for e_x per seed are stored in r_x
    
    new_coefficients = average_coefficients(data1);

    tic
    e_x = 0;
    toc
    
    % Optimisation part 1 plot: paramater range size against optimisation iteration
    
    f = figure;
    x_pc = 1:opt_its+1;
    font=12;
    set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
    set(groot, 'defaultLegendInterpreter', 'latex');
    set(0,'defaultTextInterpreter','latex');
    set(0, 'defaultAxesFontSize', font)
    set(0, 'defaultLegendFontSize', font)
    set(0, 'defaultAxesFontName', 'Times New Roman');
    set(0, 'defaultLegendFontName', 'Times New Roman');
    set(0, 'DefaultLineLineWidth', 1.0);
    
    y_1 = mean(transpose(percents));
    plot(x_pc,y_1);
    xlabel('Optimisation iteration')
    ylabel('Average Paramater Range Size (\%)','Interpreter','latex')

end


function [data] = random_coefficients(data,epoch,its, min_, max_,p1)
    ObjectiveFunction = @Alsomitra_nondim3;
    n=1;
    while n < its+1
        % tic
        for i = 1:9
            rng('shuffle');
            data(n,i) = min_(i) + ((max_(i) - min_(i)) * rand(1));
        end
        try 
            %tic
            [f,slope,per,amp,x_,y_] = ObjectiveFunction(data(n,:),p1);
            if ~isnan(f(1))
                
                % disp("hi")
                data(n,11:14) = f;
                data(n,15:17) = [slope,amp,per];
                %disp("Iteration " + epoch + ", n = "+ n + ", x_end = " + x_(end))
                n = n + 1;
                plot(x_(500:end)-x_(500),y_(500:end)-y_(500))
                xlim([-20 120]); ylim([-120 0])
                %toc
                if n > 10
                    fprintf("\b")
                elseif n > 100
                    fprintf("\b")
                end
                fprintf("\b" + string(n));
                
            end
        catch
            disp("error");
        end
        % toc
    end
    data = sortrows(data,11);
end

function [max_,min_,percents,maxs,mins] = tighten_coefficient_bounds(data,cutoff,min_coefficients,max_coefficients,percents,maxs,mins)
    min_ = [1 1 1 1 1 1 1 1 1] * 999;
    max_ = [0 0 0 0 0 0 0 0 0];
    % cutoff = 14;
    for i=11:14
        data = sortrows(data,i);

        for n=1:9
            if max(data(1:cutoff,n)) > max_(n)
                max_(n) = max(data(1:cutoff,n));
            end
            if min(data(1:cutoff,n)) < min_(n)
                min_(n) = min(data(1:cutoff,n));
            end
        end
    end

    data = sortrows(data,17);
    z=0;
    while z==0
        for i = fliplr(1:cutoff)
            if data(i,17) < 50
                maxs = [maxs;max(data(i,17))];
                z=1;
                break
            end
        end
    end

    % maxs = [maxs;max(data(:,17))];
    try
        mins = [mins;min(data(:,17))];
    catch
        a = 1;
    end

    min_ = [min_,0];
    max_ = [max_,0.5];
    percents2 = [];
    for i=1:9
        percents2(i) = 100 * (abs(max_(i) - min_(i)))/(abs(max_coefficients(i) - min_coefficients(i)));
    end
    percents = [percents;percents2];
end

function [new_coefficients] = average_coefficients(data)
    new_coefficients = zeros(1,9);
    for i = 1:4
        data = sortrows(data,10+i);
        for j=1:9
            new_coefficients(j) = new_coefficients(j) + data(1,j);
        end
    end
    new_coefficients = new_coefficients/4;
end
