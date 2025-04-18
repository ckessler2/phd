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
minimumInputValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]


maximumInputValues : UnnormalisedInputVector
maximumInputValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]


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
  x ! error >= (0.2 * 0.37161) + -0.0227797


@property
property1 : Bool
property1 = forall x . validInput x and droneFarAboveLine x =>
  norm_alsomitra x ! e_x >= (0.5 * 0.012) + 0.181


--------------------------------------------------------------------------------
-- Property 2

-- If the drone is below the line (error < -0.1), the network will always make it pitch up (e_x < 0.01)


droneFarBelowLine : UnnormalisedInputVector -> Bool
droneFarBelowLine x =
  x ! error <= (-0.1 * 0.37161) + -0.0227797



@property
property2 : Bool
property2 = forall x . validInput x and droneFarBelowLine x =>
  norm_alsomitra x ! e_x <= (0.01 * 0.012) + 0.181



  ---------------------------------------------------------------------------------------
-- Property 3

-- Output always within -0.1 : 1.1

@property
property3 : Bool
property3 = forall x . validInput x =>
	norm_alsomitra x ! e_x <= (1.01 * 0.012) + 0.181 and norm_alsomitra x ! e_x >= (-0.01 * 0.012) + 0.181

  ---------------------------------------------------------------------------------------

-- Property 4

-- If the drone is close to line and d_theta is small, output will be intermediate

droneCloseToLine : UnnormalisedInputVector -> Bool
droneCloseToLine x =
  x ! error <= (0.1 * 0.37161) + -0.0227797 and
  x ! error >= (-0.1 * 0.37161) + -0.0227797

droneStable : UnnormalisedInputVector -> Bool
droneStable x = 
  x ! d_theta >= (-0.1*0.900476) + -0.96848 and
  x ! d_theta <= (0.1*0.900476) + -0.96848

@property
property4 : Bool
property4 = forall x . validInput x and droneCloseToLine x and droneStable x=> 
  norm_alsomitra x ! e_x <= (0.6 * 0.012) + 0.181 and norm_alsomitra x ! e_x >= (0.4 * 0.012) + 0.181

  ---------------------------------------------------------------------------------------