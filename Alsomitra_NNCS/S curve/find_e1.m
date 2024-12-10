
[xt,yt] = find_nearest(5.96,-4.1866,-0.922696217035257)


function [xt,yt] = find_nearest(x,y,theta)

    % Target trajectory
    x_c1 = 0:0.1:4.5;
    y_c1 = -x_c1;
    y_c2 = -4.6:-0.1:-6.5;
    x_c2 = sqrt(2-((y_c2+5.5).^2))+3.5;
    x_c3 = 4.4:-0.1:3.5;
    y_c3 = x_c3 - 11;
    y_c4 = -7.6:-0.1:-9.5;
    x_c4 = -sqrt(2-((y_c4+8.5).^2))+4.5;
    x_c5 = 3.6:0.1:6;
    y_c5 = -x_c5 - 6;
    x_c1 = [x_c1,x_c2,x_c3,x_c4,x_c5]/5 * 1000/70;
    y_c1 = [y_c1,y_c2,y_c3,y_c4,y_c5]/5 * 1000/70;

    distances1 = ((x_c1-x).^2);
    distances2 = ((y_c1-y).^2);

    [val,idx] = min(distances1+distances2);
    
    % nearest_y = y_c1(idx);
    % nearest_x = x_c1(idx);

    theta2 = atan((y_c1(idx+1)-y_c1(idx-1))/(x_c1(idx+1)-x_c1(idx-1)));
    intercept2 = y_c1(idx) - (tan(theta2) * x_c1(idx));

    intercept = y - (tan(theta-pi/2)*x);

    
    % if theta2 > theta
    %     next_nearest_y = y_c1(idx-1);
    %     next_nearest_x = x_c1(idx-1);
    % else
    %     next_nearest_y = y_c1(idx+1);
    %     next_nearest_x = x_c1(idx+1);
    % end
    



    xt = (intercept2-intercept)/ (tan(theta-pi/2)- tan(theta2));
    yt = tan(theta-pi/2)*xt + intercept;

end