# Reachability of neural network controlled _Alsomitra Macrocarpa_
 
This folder contains scripts for performing reachaibility of the aforementioned _Alsomitra Macrocarpa_ system in CORA.

### Step 1 - Run simulations to generate a training dataset (MATLAB)

[Alsomitra_Closed_Loop_Reachability.m](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Alsomitra_Closed_Loop_Reachability.m) is a mostly standard CORA implementation, over 16s with the initial set being a range of y positions.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Reachability/Reach_8_01.png" width="1250" class="center" />
</p>

In order for CORA to execute within a readonable time and still return an accurate and useful result, some changes were made to the dynamic equations and reachability setup:
- Equations - these needed simplification otherwise the symbolic hessian matrix was too big to compute in a reasonable time.
    - Limited pitch angle to ![equation](https://latex.codecogs.com/svg.image?-\pi/2>\theta\leq&space;0)
- Reachability $`\sqrt{2}`$
