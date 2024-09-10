

These scripts are based on a 2D aerodynamic model (Li 2022) fitted to experiments of flying seeds, with the aim of verifying neural network controllers for pitch control (by changing the position of the center of mass). 

Note - to get this code to work, I had to comment out the code that writes a symbolic Hessian script, since it has to be replaced with the FDA script. This is done by commenting out lines 178, 179, 188, 189 in derivatives.m (CORA-master\contDynamics\@contDynamics).

<hr style="height: 1px;">

### Files 

nondimfreelyfallingplate6.m defines the equations and parameters.

Alsomitra_model.m is my own script (not CORA) which implements a PID and neural network controller - my ultimate aim is to create reachability plots of these simulations with CORA.

Alsomitra_Open_Loop_Reachability.m is my attempt to implement my simulations (with no control) with CORA. This seems to work well, although I had to implement a FDA method to calculate Hessian matrices (hessianTensorInt ..). For the equations I am using (simplified slightly), the symbolic jacobian can be used.

Alsomitra_Closed_Loop_Reachability.m is my attempt to implement the neural network controller into the CORA script. It does run, but there are some issues:

The reachability plot (and the time taken to calculate) varies significantly with several parameters - notably the reachability timestep (0.25), Hessian delta (10), and total time (60s).

Additionally, the control simulations do not match up exactly between my script and my CORA implementation. 
