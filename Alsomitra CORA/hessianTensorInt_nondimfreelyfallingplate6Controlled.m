function H=hessianTensorInt_nondimfreelyfallingplate6Controlled(x,u)


    % x = x(1:6);
    f = @nondimfreelyfallingplate6;
    n = 7;
    delta =10; 

    for k = 1:n+1
        H{k} = interval(sparse(n+2, n+2));
    end
    
    for i = 1:n
        % H{i} = interval(sparse(n+1, n+1));
        % fprintf("i = " + string(i))
        for j = 1:n
            % Create perturbed copies of x for second derivative computation
            x_ij_pp = x; % x plus-plus
            x_ij_mm = x; % x minus-minus
            x_ij_pm = x; % x plus-minus
            x_ij_mp = x; % x minus-plus

            % Perturb the copies appropriately
            x_ij_pp(i) = x_ij_pp(i) + delta;
            x_ij_pp(j) = x_ij_pp(j) + delta;
            x_ij_mm(i) = x_ij_mm(i) - delta;
            x_ij_mm(j) = x_ij_mm(j) - delta;
            x_ij_pm(i) = x_ij_pm(i) + delta;
            x_ij_pm(j) = x_ij_pm(j) - delta;
            x_ij_mp(i) = x_ij_mp(i) - delta;
            x_ij_mp(j) = x_ij_mp(j) + delta;

            % Evaluate function at perturbed points
            f_pp = f(x_ij_pp, u);
            f_mm = f(x_ij_mm, u);
            f_pm = f(x_ij_pm, u);
            f_mp = f(x_ij_mp, u);

            % Calculate max and min terms for intervals to correctly form the Hessian element intervals
            term_max = (max(f_pp) - max(f_pm) - max(f_mp) + max(f_mm)) / (4 * delta^2);
            term_min = (min(f_pp) - min(f_pm) - min(f_mp) + min(f_mm)) / (4 * delta^2);

            % Save the interval in the good format
            for k = 1:n  % Assuming f returns a vector of size n
                if abs(term_min(k)) > delta && abs(term_max(k)) > delta
                    H{k}(i, j) = interval(min(term_min(k), term_max(k)), max(term_min(k), term_max(k)));
                    H{k}(i, j) = interval(min(term_min(k), term_max(k)), max(term_min(k), term_max(k)));
                end
            end

        end
    end
end