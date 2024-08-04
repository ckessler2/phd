# Neural Network Control System (NNCS) for _Alsomitra Macrocarpa_
 
This folder contains scripts for training an NNCS for a small seed-inspired gliding drone, actuated by changing the position of the center of mass (COM). The seed (diaspore) in question is _Alsomitra Macrocarpa_, modelled with [Li 2022](https://doi.org/10.1017/jfm.2022.89) - a quasi-steady 2d aerodynamic model for falling plates with displaced COM.The model has been optimised to fit experimental trajectories of real diaspores (as part of other ongoing work), and the long term goal is to design flying-seed inspired gliders to monitor the atmosphere as part of the [Dandidrone](https://voilab.eng.ed.ac.uk/dandidrone) project.

<img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/Render5_3by1.png" /> 

### Requirements

Neural network training was written in Python 3.9, and all other scripts (running simulations, generating datasets) are in MATLAB r2024a.

### Problem description

The control problem is based on a related NNCS reachability benchmark involving a quadcopter [4], with my evential goal being to produce a similar reachability analysis for this system. For this I consider a drone starting at the origin, and control it in such a way that its trajectory ends up close to a desired trajectory (in this case a straight line). For reachability, I consider a range of starting positions along the y axis which should all end up on the desired trajectory.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/NNCS_problem3.png" width="400" class="center" />
</p>

### Step 1 - Run simulations to generate training dataset (MATLAB)

[Alsomitra_Control_Simulation](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Alsomitra_Control_Simulation.m) runs a set of 5 control simulations based on previous work [3], with the dynamic equations defined in [nondimfreelyfallingplate3](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/nondimfreelyfallingplate3.m). A manually tuned PID controller actuates the COM position based on an error signal - the y distance between the drone and the desired trajectory.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/PID_Result.png" width="200" class="center" />
</p>

Each of the 5 simulations runs for 60s, with a control frequency of 1Hz. For each control step, the script records all 6 system states, the y error, and the PID-controlled actuation (e_x). These results are saved to a [csv file](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Training_Data.csv) with 8 columns and 306 rows.

### Step 2 - Train NNCS (Python)

based on a regression example using Keras [1,2]

### Step 3 - Test NN and NNCS accuracy (MATLAB)

asd



## Contributors
Colin Kessler 

## References
[1] S, Bhattiprolu.  [_141 - Regression using Neural Networks and comparison to other models_](https://www.youtube.com/watch?v=2yhLEx2FKoY&t=2s). YouTube, 2020. <br />
[2] S, Bhattiprolu. [_141-regression_housing_example_](https://github.com/bnsreenu/python_for_microscopists/blob/master/141-regression_housing_example.py). GitHub, 2020. <br />
[3] D. Certini, C. Kessler. [_Alsomitra-straight-glide_](https://github.com/danielecertini90/Alsomitra-straight-glide) Github, 2024. <br />
[4] D. M. Lopez, M. Althoff, M. Forets, T. T. Johnson, T. Ladner, C. Schilling. [_ARCH-COMP23 Category Report: Artificial Intelligence and Neural Network Control Systems (AINNCS) for Continuous and Hybrid Systems Plants_](https://easychair.org/publications/open/Vfq4b). EPiC Series in Computing, pages 89–125, 2023. <br />
