function [t, courant, x, y, z, ux, uy, uz] = get_data(filename)

    data = readmatrix(filename); 
    t = data(:,1);
    [ d1, t1 ] = min( abs( t-(0) ) );
    [ d2, t2 ] = min( abs( t-(100) ) );
    t = t(t1:t2);

    courant = data(t1:t2,2);
    x = data(t1:t2,3);
    y = data(t1:t2,4);
    z = data(t1:t2,5);
    ux = data(t1:t2,6);
    uy = data(t1:t2,7);
    uz = data(t1:t2,8);
end
