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

maximumInputValues : UnnormalisedInputVector
maximumInputValues = [3.489893069, -0.043021391, 0.049180223, -0.068002516, 41.714717, 4.197233529, 0.348832422]

validInput : UnnormalisedInputVector -> Bool
validInput x = forall i . minimumInputValues ! i <= x ! i <= maximumInputValues ! i


-- Inputs are not normalised, as required for CORA
norm_alsomitra x = alsomitra (x)


--------------------------------------------------------------------------------
-- Property 1

-- If the drone is far above the line (error > 1), the network will always make it pitch down (e_x > 0.5)


droneFarAboveLine : UnnormalisedInputVector -> Bool
droneFarAboveLine x =
  x ! error >= (0.5 + 0.20712096) / (6*0.8521974)



@property
property1 : Bool
property1 = forall x . validInput x and droneFarAboveLine x =>
  norm_alsomitra x ! e_x >= 0.99


--------------------------------------------------------------------------------
-- Property 2

-- If the drone is below the line (error < -0.1), the network will always make it pitch up (e_x < 0.5)


droneFarBelowLine : UnnormalisedInputVector -> Bool
droneFarBelowLine x =
  x ! error <= (-0.1 + 0.20712096) / (6*0.8521974)



@property
property2 : Bool
property2 = forall x . validInput x and droneFarBelowLine x =>
  norm_alsomitra x ! e_x <= 0.5


--------------------------------------------------------------------------------------
-- Property 3

-- If the drone is traveling above a certain velocity and is pitched up, the COM should not be forwards

--drone is above a minumum speed
droneAboveMinimumSpeed : UnnormalisedInputVector -> Bool
droneAboveMinimumSpeed x = 
  x ! dv_x >= 0.1  or x ! dv_y >= 0.1

droneMovingFast : UnnormalisedInputVector -> Bool
droneMovingFast x =
  x ! dv_x >= 0.6 or x ! dv_y >= 0.6

@property
property3 : Bool
property3 = forall x . validInput x and droneMovingFast x =>
  norm_alsomitra x ! e_x <= 0.5


---------------------------------------------------------------------------------------
-- Property 4

-- If the drone is going too fast, it will pitch up to slow down

dronePastMaxSpeed : UnnormalisedInputVector -> Bool
dronePastMaxSpeed x =
  x ! dv_x >= 0.8

@property
property4 : Bool
property4 = forall x . validInput x and dronePastMaxSpeed x => 
  norm_alsomitra x ! e_x <= 0.5

  ---------------------------------------------------------------------------------------
-- Property 5 - NOT WORKING AS INTENDED

-- If the drone is close to the line, no extreme control measures will be taken (e_x stays within +- 0.1)

droneCloseToLine : UnnormalisedInputVector -> Bool
droneCloseToLine x = 
  not droneFarAboveLine x and not droneFarBelowLine x

-- @property
--property5 : Bool
--property5 = forall x . validInput x and droneCloseToLine x =>
--  norm_alsomitra x ! e_x <= (0.5 + 0.1) and norm_alsomitra x ! e_x >= (0.5 - 0.1)