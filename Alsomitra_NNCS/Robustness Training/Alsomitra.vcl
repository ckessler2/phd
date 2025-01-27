-- Adapted from: https://github.com/KatyaKom/DAIR-course/blob/main/Group-DAIR/Working_ADV_Training/alsomitra_5_mc.vcl
-- By Prab Singh, Ada Grecner, and Alexander Wickham

--------------------------------------------------------------------------------
-- Copied from: Full specification of the ACAS XU networks

--------------------------------------------------------------------------------
-- Inputs

type InputVector = Vector Rat 7

dv_x = 0
dv_y = 1
d_omega = 2
d_theta = 3
d_x = 4
d_y = 5
error = 6

--------------------------------------------------------------------------------
-- Outputs

type OutputVector = Vector Rat 1

e_x = 0

--------------------------------------------------------------------------------
-- The network

-- Next we use the `network` annotation to declare the name and the type of the
-- neural network we are verifying. The implementation is passed to the compiler
-- via a reference to the ONNX file at compile time.

@network
alsomitra : InputVector -> OutputVector

--------------------------------------------------------------------------------
-- Normalisation

-- minimum and maximum are taken from training data. None of the inputs are scaled

type UnnormalisedInputVector = Vector Rat 7

-- Next we define the minimum and maximum values that each input can take.
-- These correspond to the range of the inputs that the network is designed
-- to work over. These are taken from the training dataset
minimumInputValues : UnnormalisedInputVector
minimumInputValues = [0.967568147, -0.607397104, -0.356972794, -0.96847853, 0.482420778, -41.68140527, -0.022779722]
-- minimumInputValues = [0.8415, -0.6356, -0.3773, -1.0135, -1.5792, -43.9753, -0.0414]
--minimumInputValues = [0.3370, -0.7485, -0.4585, -1.1936, -9.8257, -53.1511, -0.1157]

maximumInputValues : UnnormalisedInputVector
maximumInputValues = [3.489893069, -0.043021391, 0.049180223, -0.068002516, 41.714717, 4.197233529, 0.348832422]
-- maximumInputValues = [3.6160, -0.0148, 0.0695, -0.0230, 43.7763, 6.4912, 0.3674]
-- maximumInputValues = [4.1205, 0.0981, 0.1507, 0.1571, 52.0228, 15.6669, 0.4417]


validInput : UnnormalisedInputVector -> Bool
validInput x = forall i . minimumInputValues ! i <= x ! i <= maximumInputValues ! i

normalise: UnnormalisedInputVector -> InputVector
normalise x = foreach i .  x ! i


-- Inputs are not normalised, as required for CORA
norm_alsomitra : UnnormalisedInputVector -> OutputVector
norm_alsomitra x = alsomitra (normalise x)



--------------------------------------------------------------------------------
-- Property 1

-- If the drone is far above the line (error > 0.2), the network will always make it pitch down (e_x > 0.5)


droneFarAboveLine : UnnormalisedInputVector -> Bool
droneFarAboveLine x =
  x ! error >= 0.2
  

@property
property1 : Bool
property1 = forall x . validInput x and droneFarAboveLine x =>
  norm_alsomitra x ! e_x >= 0.5


--------------------------------------------------------------------------------
-- Property 2

-- If the drone is below the line (error < -0.1), the network will always make it pitch up (e_x < 0.01)


droneFarBelowLine : UnnormalisedInputVector -> Bool
droneFarBelowLine x =
  x ! error <= -0.1



@property
property2 : Bool
property2 = forall x . validInput x and droneFarBelowLine x =>
  norm_alsomitra x ! e_x <= 0.01



  ---------------------------------------------------------------------------------------
-- Property 3

-- Output always within -0.1 : 1.1

@property
property3 : Bool
property3 = forall x . validInput x =>
	norm_alsomitra x ! e_x <= 1.01 and norm_alsomitra x ! e_x >= -0.01
	
  ---------------------------------------------------------------------------------------
  
-- Property 4

-- If the drone is close to line and d_theta is small, output will be intermediate

droneCloseToLine : UnnormalisedInputVector -> Bool
droneCloseToLine x =
  x ! error <= 0.1 and
  x ! error >= -0.1
  
droneStable : UnnormalisedInputVector -> Bool
droneStable x = 
  x ! d_theta >= -0.1 and
  x ! d_theta <= 0.1 

@property
property4 : Bool
property4 = forall x . validInput x and droneCloseToLine x and droneStable x=> 
  norm_alsomitra x ! e_x <= 0.6 and norm_alsomitra x ! e_x >= 0.4

  ---------------------------------------------------------------------------------------


