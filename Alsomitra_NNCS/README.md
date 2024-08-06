# Neural Network Control System (NNCS) for _Alsomitra Macrocarpa_
 
This folder contains scripts for training a NNCS for a small bio-inspired gliding drone, actuated by changing the position of the center of mass (COM), with behaviour cloning. The diaspore in question is _Alsomitra Macrocarpa_, modelled with a quasi-steady 2d aerodynamic model for falling plates with displaced COM [1]. The model has been optimised to fit experimental trajectories of real diaspores (as part of other ongoing work), and the long term goal is to design gliders to monitor the atmosphere as part of the Dandidrone project [2].

<img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/Render5_3by1.png" /> 

### Requirements

Python 3.9 for neural network training, and MATLAB r2024a for everything else. The libraries used are tensorflow 2.10.0, tf2onnx 1.16.1, scipy 1.11.4, onnx 1.15.0, pandas 2.1.1, and matplotlib.


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

Each of the 5 simulations runs for 60s, with a control frequency of 1Hz. For each control step, the script records all 6 system states, the y error, and the PID-controlled actuation (e_x). These results are saved to a [csv file](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Training_Data.csv) with 8 columns and 306 rows (and as a mat file). <br />
Note that the dynamics only involves 6 states, but I added the error signal to the dynamics equation such that the network would have the same signal (if not the derivative and integral) as the PID controller.

<hr style="height: 1px;">

### Step 2 - Train NN with supervised learning (Python)

[Train_Alsomitra_Controller](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Train_Alsomitra_Controller.py) is adapted from a regression example using Keras [5,6]. The network has an input layer (7 nodes) , 2x120 and 1x1 sigmoid layers, a lamda layer to normalise the output to the desired range, and a single output. The resulting network is saved as an ONNX.

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/NN_Training_Loss.png" width="450" class="center" />
</p>

<hr style="height: 1px;">

### Step 3 - Test NN accuracy and control performance (MATLAB)

Once trained, the network is imported back to MATLAB to test accuracy and control performance. [Check NN accuracy](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Check_NN_Accuracy.m) runs the training dataset through the network and plots the results to visualise its accuracy. Finally, [Alsomitra_Control_Simulation](https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Alsomitra_Control_Simulation.m) can be run with the network as a controller, by changing the nnc boolean to true (line 15).

<p align="center"> 
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/NN_Accuracy.png" width="325" class="center" />
 <img src="https://github.com/ckessler2/phd/blob/main/Alsomitra_NNCS/Figures/NNCS_Result.png" width="250" class="center" />
</p>

The resulting performance is quite good, but the trajectories do not follow the line as well as with a PID controller. This can be attributed to imperfect network accuracy and robustness, and this could likely be improved with better training methods.

<hr style="height: 1px;">

### References
[1] H. Li, T. Goodwill, J. Wang, L. Ristroph. [_Centre of mass location, flight modes, stability and dynamic modelling of gliders_](https://doi.org/10.1017/jfm.2022.89). JFM, 937, 2022.<br />
[2] I. M. Viola. [_Dandidrone: A Dandelion-Inspired Drone for Swarm Sensing_](https://voilab.eng.ed.ac.uk/dandidrone). eng.ed.ac.uk. 2021.<br />
[3] S. Bhattiprolu.  [_141 - Regression using Neural Networks and comparison to other models_](https://www.youtube.com/watch?v=2yhLEx2FKoY&t=2s). YouTube, 2020. <br />
[4] S. Bhattiprolu. [_141-regression_housing_example_](https://github.com/bnsreenu/python_for_microscopists/blob/master/141-regression_housing_example.py). GitHub, 2020. <br />
[5] D. Certini, C. Kessler. [_Alsomitra-straight-glide_](https://github.com/danielecertini90/Alsomitra-straight-glide) Github, 2024. <br />
[6] D. M. Lopez, M. Althoff, M. Forets, T. T. Johnson, T. Ladner, C. Schilling. [_ARCH-COMP23 Category Report: Artificial Intelligence and Neural Network Control Systems (AINNCS) for Continuous and Hybrid Systems Plants_](https://easychair.org/publications/open/Vfq4b). EPiC Series in Computing, pages 89–125, 2023. <br />
