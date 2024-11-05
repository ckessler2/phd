# Reachability of neural network controlled _Alsomitra Macrocarpa_
 
This folder contains scripts for performing reachaibility of the aforementioned _Alsomitra Macrocarpa_ system in CORA.


### Problem description

The control problem is based on a related NNCS reachability benchmark involving a quadcopter [3], with my eventual goal being to produce a similar reachability study. For this, we consider a drone starting at the origin, and control it in such a way that its trajectory ends up close to a desired trajectory (in this case, a straight line). For reachability we consider a range of starting positions along the y axis, which should all end up on the desired trajectory.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/NNCS_problem3.png" width="450" class="center" />
</p>

<hr style="height: 1px;">

### Step 1 - Run simulations to generate a training dataset (MATLAB)

[Alsomitra_Control_Simulation](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Alsomitra_Control_Simulation.m) runs a set of 5 control simulations based on previous work [4], with the dynamic equations defined in [another script](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/nondimfreelyfallingplate3.m). A manually tuned PID controller actuates the COM position based on an error signal - the y distance between the drone and the desired trajectory.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/PID_Result.png" width="250" class="center" />
</p>

