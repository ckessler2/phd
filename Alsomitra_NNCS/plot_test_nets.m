
for i = 10

    name = "adversarial_model_0.04_" + i + ".onnx";
    name = "adversarial_model_0.04.onnx";
    figure
    tiledlayout('flow');

    [completed, R,simRes1, dims] = Alsomitra_Closed_Loop_Reachability(name,0,1);
    [completed, R2,simRes2, dims] = Alsomitra_Closed_Loop_Reachability(name,0.2,1);

    nexttile
    hold on; box on;useCORAcolors('CORA:contDynamics');
    plot_cora_stuff
    plotOverTime(simRes1, 7, 'DisplayName', 'Simulations','color', [0.6928    0.1651    0.5645]);

    nexttile
    hold on; box on;useCORAcolors('CORA:contDynamics');
    plot_cora_stuff
    plotOverTime(simRes2, 7, 'DisplayName', 'Simulations','color', [0.9883    0.6523    0.2114]);
    title(name)

end

function plot_cora_stuff
    plot([0 20],[0 0],'--black');
    

    goalSet = interval( ...
        [-Inf;-Inf;-0.1;-Inf;-Inf;-Inf;-Inf], ...
        [ Inf; Inf; 0.1; Inf; Inf; Inf; Inf] ...
    );

    spec = specification(goalSet, 'safeSet', interval(0, 20));
    plotOverTime(spec, 3, 'DisplayName', 'Goal set');
    plot([0 20],[0 0],'--black');
end