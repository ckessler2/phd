# Reachability of neural network controlled _Alsomitra Macrocarpa_
 
This folder contains scripts for performing reachability analysis of the aforementioned _Alsomitra Macrocarpa_ system in CORA. [Alsomitra_Closed_Loop_Reachability.m](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Alsomitra_Closed_Loop_Reachability.m) is a mostly standard implementation, and the reachable region is calculated over 16s with the initial set being a range of y positions.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Reach_8_01.png" width="1250" class="center" />
</p>

In order for CORA to return an accurate and useful result within a reasonable time, some changes were made to the dynamic equations and reachability setup:

- Reachability - the initial set was too big for CORA to handle, and the nonlinear equations cause divergence long before it could reach 60s
    - Scaled down simulation to 16s from 60s, with an inital set of 0.1/0.07 to 0.3/0.07. This required retuning the PID controller and retraining the controller, but the concept is otherwise unchanged
    - Divided initial set into 8 smaller sets (the initial set is too large to run through CORA, and it explodes after a few seconds), calculate reachable region for each, and combine into final plot
- Equations - these needed simplification otherwise the symbolic hessian matrix was too big to compute in a reasonable time
    - Limited pitch angle to $-\pi/2 > \theta \leq 0$ (drone is always within this region anyway)
    - Simplified angle-of-attack definition to not include CoV/CoM discrepancy (has negligible effect given the system dimensions)
 
This script takes a long time to run (2h on my i5-12400f) and takes a lot of memory (10GB after plotting). It could be much faster, but that would require either: larger timesteps (which tends to make it explode), fewer initial sets (reachability tends to diverge with fewer sets), or simpler equations (would result in a simpler hessian, which is responsible for the bulk of the computation time - but the system cannot be simplified too much or it loses accuracy). I have been working on a finite-difference approximation method to calculate the hessian faster, but that will require a lot more work to function over large intervals.

For now, my plan is to create similar plots but from slightly larger initial sets, to visualise how the controller effectiveness deteriorates. This will make for a good comparison of other controllers, such as ones trained to be more robust.
