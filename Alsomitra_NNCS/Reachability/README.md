# Reachability of neural network controlled _Alsomitra Macrocarpa_
 
This folder contains scripts for performing reachaibility of the aforementioned _Alsomitra Macrocarpa_ system in CORA.

### Step 1 - Run simulations to generate a training dataset (MATLAB)

[Alsomitra_Closed_Loop_Reachability.m](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Alsomitra_Closed_Loop_Reachability.m) is a mostly standard CORA implementation, over 16s with the initial set being a range of y positions.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Reach_8_01.png" width="1250" class="center" />
</p>

In order for CORA to execute within a readonable time and still return an accurate and useful result, some changes were made to the dynamic equations and reachability setup:
- Equations - these needed simplification otherwise the symbolic hessian matrix was too big to compute in a reasonable time.
    - Limited pitch angle to $-\pi/2 > \theta \leq 0$ (drone is always within this region anyway)
    - Simplified angle-of-attack definition to not include CoV/CoM discrepancy (has negligible effect)
- Reachability - the initial set is too large to run through CORA, and it explodes after a few seconds
    - Divided initial set into 8 sets, calculate reachable state for each, and combine into final plot

My plan is to create similar plots but from a slightly larger initial set, and see how the controller effectiveness deteriorates. This will make for a good comparison of other controllers, such as ones trained to be more robust.
