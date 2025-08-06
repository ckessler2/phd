l_list = 0.07:0.07:0.7;
m_list = 3.6000e-04:0.4000e-04:7.2e-4;

[X,Y] = meshgrid(l_list,m_list);
Z = (X) + (Y)./(1e-3);
surf(X,Y,Z)
% xlim([min(l_list) max(l_list)])
% ylim([min(m_list) max(m_list)])
view(0,90); colorbar