figure
dims = size(Z);
Z(Z == 0) = NaN;
contourf(X(1:dims(2),1:dims(1))./(1e-3),Y(1:dims(2),1:dims(1))./(1e-6),(Z(1:dims(1),1:dims(2))).',[0.1, 0.5:0.1:1.6],"ShowText",true,"LabelFormat","%0.1f", ...
    "FaceAlpha",0.8)


% contour3(X(1:dims(2),1:dims(1))./(1e-3),Y(1:dims(2),1:dims(1))./(1e-6),(Z(1:dims(1),1:dims(2))).',50)
colormap(viridis); pbaspect([1 1 1]); colorbar
ylim([200 700])