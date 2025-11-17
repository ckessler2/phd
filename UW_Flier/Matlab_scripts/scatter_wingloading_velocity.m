clf; clc; clear all; close all
plot_preamble()

X = [12.64, 3.62, 12.61, 27.24, 3.41, 2.93, 27.27] .* 0.01;
Y = [0.83, 0.3, 1.54, 1, 0.81, 1, 3];

marker_files = {...
    'markers/marker_girardi.png','markers/marker_kessler.png', ...
   'markers/marker_sun.png','markers/marker_johnson.png', ...
   'markers/marker_iyer.png','markers/marker_kim.png', ...
   'markers/marker_wiesemuller.png'
};

labels = { ...
    'Girardi (2024)','Proposed Design', ...
    'Sun (2025)','Johnson (2023)', ...
    'Iyer (2022)','Kim (2021)', ...
     'Wiesemuller (2022)'
};

label_side = { ...
    'right','right', ...
    'right','left', ...
    'right','right',...
    'above'
};

colors = {'r','b','k','k','k','k','r'};
scaling = [0.15, 0.15, 0.05, 0.08, 0.1, 0.09, 0.11];

dx = 1.5;          % horizontal offset
dy = -0.0;         % vertical offset (if you want text slightly below)

f = figure;
hold on; box on

for i = 1:length(X)

    % Load marker
    [mk,~,alph] = imread(marker_files{i});
    mk   = flipud(mk);
    alph = flipud(alph);

    % Color tinting
    c = colors{i};
    mk_color = mk;

    if strcmp(c,'k')
        mk_color(:,:,1) = 0;
        mk_color(:,:,2) = 0;
        mk_color(:,:,3) = 0;
    elseif strcmp(c,'r')
        mk_color(:,:,1) = 255;
        mk_color(:,:,2) = 0;
        mk_color(:,:,3) = 0;
    elseif strcmp(c,'b')
        mk_color(:,:,1) = 255;
        mk_color(:,:,2) = 255;
        mk_color(:,:,3) = 255;
    end

    % ---------------------------
    % KEEP ORIGINAL ASPECT RATIO
    % ---------------------------
    [h_img, w_img, ~] = size(mk_color);
    aspect = w_img / h_img;

    marker_height = scaling(i);       % your original scaling
    marker_width  = marker_height * aspect * 0.3 / 2.5;

    x1 = X(i) + [-1 1] * marker_width;
    y1 = Y(i) + [-1 1] * marker_height;

    im = imagesc(x1, y1, mk_color);
    im.AlphaData = alph;

    % ---------------------------
    % LABEL POSITIONING
    % ---------------------------
    dx = 0.015;
    dy = 0.012;    % slightly larger for above text

    side = label_side{i};

    if strcmp(side,'left')
        x_text = X(i) - (dx * 1.2);
        y_text = Y(i) - dy;
        hal = 'right';
        val = 'middle';

    elseif strcmp(side,'right')
        x_text = X(i) + dx;
        y_text = Y(i) - dy;
        hal = 'left';
        val = 'middle';

    elseif strcmp(side,'above')
        x_text = X(i);
        y_text = Y(i) + dy;
        hal = 'left';
        val = 'bottom';

    else
        error('label_side must be left, right, or above')
    end

    text(x_text, y_text, labels{i}, ...
         'HorizontalAlignment', hal, ...
         'VerticalAlignment',   val, ...
         'Interpreter','latex', ...
         'FontSize',10);

end

s = scatter(X(2),Y(2),140, "x");
s.LineWidth = 1.6;
s.MarkerEdgeColor = 'b';

set(gca,'YDir','normal')
xlim([0 0.3]); ylim([0 2])

xlabel("$W/S$ [kgm$^{-2}$]","Interpreter","latex")
ylabel("$v_y$ [ms$^{-1}$]","Interpreter","latex")
daspect([0.3 2.5 1])

% Set size of figure

figWidth = 12;  %width in cm, actually scaled by 2/2.5 so 9.6cm
figHeight = figWidth;
set(f, 'Units', 'centimeters', 'Position', [5, 5, figWidth, figHeight]);

% Paper units
set(f, 'PaperUnits', 'centimeters');
set(f, 'PaperPosition', [0 0 figWidth figHeight]);
set(f, 'PaperSize', [figWidth figHeight]);  % ensures no extra margins
set(findall(f, '-property', 'FontSize'), 'FontSize', 12);


exportgraphics(f,"loading_vs_terminal.png",Resolution=1200)
% set(f,'Renderer','opengl');  
% print(f,'loading_vs_terminal.eps','-depsc','-r1200');

function plot_preamble()
    set(0,'defaultFigureRenderer','painters')
    set(0,'DefaultFigureWindowStyle','docked')
    font = 12;
    set(groot,'defaultAxesTickLabelInterpreter','latex')
    set(groot,'defaultLegendInterpreter','latex')
    set(0,'defaultTextInterpreter','latex')
    set(0,'defaultAxesFontSize',font)
    set(0,'defaultLegendFontSize',font)
    set(0,'defaultAxesFontName','Times New Roman')
    set(0,'defaultLegendFontName','Times New Roman')
    set(0,'DefaultLineLineWidth',0.5);
end
