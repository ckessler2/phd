lcm_diving = [15 16];
lcm_gliding = [17 18 20 21];
lcm_bounding = [22 24 26 27 28];
lcm_fluttering = [30 32];

centroid = 42.17983;

ex_mgc_diving = 0.5 - (( lcm_diving) ./ 70) ;
ex_mgc_gliding = 0.5 - (( lcm_gliding) ./ 70) ;
ex_mgc_bounding = 0.5 - ((lcm_bounding) ./ 70) ;
ex_mgc_fluttering = 0.5 - ((lcm_fluttering) ./ 70) ;

plot