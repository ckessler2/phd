# Alsomitra Drone Neural Network Contoller
 
This folder contains scripts for training an NNCS for small seed-inspired glider, actuated by changing the position of the center of mass (COM). The seed (diaspore) in question is _Alsomitra Macrocarpa_, modelled with [Li 2022](https://doi.org/10.1017/jfm.2022.89) - a quasi-steady 2d aerodynamic model for falling plates with displaced COM. The model parameters have been optimised to fit experimental trajectories of real diaspores, and the long term goal is to design flying-seed inspired gliders to monitor the atmosphere as part of the [Dandidrone](https://voilab.eng.ed.ac.uk/dandidrone) project.

<img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_Controller/Render5_3by1.png">

### Requirements

The NN training script was written with Python 3.9 based on a regression example using Keras [1,2]. All other scripts (running simulations, generating datasets) were written in MATLAB r2024a based on previous work [3].

### Problem description

The control problem is based on a related NNCS reachability benchmark involving a quadcopter [4], with my evential goal being to produce a similar reachability analysis for this system.

### Step 1 - Run simulations to generate training dataset (MATLAB)

asd

### Step 2 - Train NNCS (Python)

asd

### Step 3 - Test NN and NNCS accuracy (MATLAB)

asd



## Contributors
Colin Kessler 

## References
[1] S, Bhattiprolu.  [_141 - Regression using Neural Networks and comparison to other models_](https://www.youtube.com/watch?v=2yhLEx2FKoY&t=2s). YouTube, 2020. <br />
[2] S, Bhattiprolu. [_141-regression_housing_example_](https://github.com/bnsreenu/python_for_microscopists/blob/master/141-regression_housing_example.py). GitHub, 2020. <br />
[3] D. Certini, C. Kessler. [_Alsomitra-straight-glide_](https://github.com/danielecertini90/Alsomitra-straight-glide) Github, 2024. <br />
[4] D. M. Lopez, M. Althoff, M. Forets, T. T. Johnson, T. Ladner, C. Schilling. [_ARCH-COMP23 Category Report: Artificial Intelligence and Neural Network Control Systems (AINNCS) for Continuous and Hybrid Systems Plants_](https://easychair.org/publications/open/Vfq4b). EPiC Series in Computing, pages 89–125, 2023. <br />
