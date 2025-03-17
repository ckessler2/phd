-- Adapted from: https://github.com/KatyaKom/DAIR-course/blob/main/Group-DAIR/Working_ADV_Training/alsomitra_5_mc.vcl
-- By Prab Singh, Ada Grecner, and Alexander Wickham

--------------------------------------------------------------------------------
-- Copied from: Full specification of the ACAS XU networks

--------------------------------------------------------------------------------
-- Inputs

type InputVector = Vector Rat 14

dv_x = 0
dv_y = 1
d_omega = 2
d_theta = 3
d_x = 4
d_y = 5
error = 6
dv_x2 = 7
dv_y2 = 8
d_omega2 = 9
d_theta2 = 10
d_x2 = 11
d_y2 = 12
error2 = 13

--------------------------------------------------------------------------------
-- Outputs

type OutputVector = Vector Rat 2

e_x = 0
e_x2 = 1

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

type UnnormalisedInputVector = Vector Rat 14

-- Next we define the minimum and maximum values that each input can take.
-- These correspond to the range of the inputs that the network is designed
-- to work over. These are taken from the training dataset
minimumInputValues : UnnormalisedInputVector
minimumInputValues = [0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00]



maximumInputValues : UnnormalisedInputVector
maximumInputValues = [1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00]



validInput : UnnormalisedInputVector -> Bool
validInput x = forall i . minimumInputValues ! i <= x ! i <= maximumInputValues ! i

normalise: UnnormalisedInputVector -> InputVector
normalise x = foreach i .  x ! i


-- Inputs are not normalised, as required for CORA
norm_alsomitra : UnnormalisedInputVector -> OutputVector
norm_alsomitra x = alsomitra (normalise x)


-----------

@parameter
epsilon: Rat

@parameter
LipschitzConstant: Rat

-- NONLINEAR SPECIFICATION 
-- Calculate square of euclidean distance in input space- to be compared to epsilon and used for Lipschitz
--euclideanDistance : UnnormalisedInputVector -> Rat
--euclideanDistance x  =  ((x ! dv_x - x ! dv_x2) * (x ! dv_x - x ! dv_x2)) + 
--	((x ! dv_y - x ! dv_y2) * (x ! dv_y - x ! dv_y2)) + 
--	((x ! d_omega - x ! d_omega2) * (x ! d_omega - x ! d_omega2)) + 
--	((x ! d_theta - x ! d_theta2) * (x ! d_theta - x ! d_theta2)) + 
--	((x ! d_x - x ! d_x2) * (x ! d_x - x ! d_x2)) + 
--	((x ! d_y - x ! d_y2) * (x ! d_y - x ! d_y2)) + 
--	((x ! error - x ! error2) * (x ! error - x ! error2))
	
-- Check if input point distance squared is less than epsilon squared
--boundedByEpsilonEuclidean: UnnormalisedInputVector -> Bool
--boundedByEpsilonEuclidean x  = euclideanDistance  x <= epsilon * epsilon
	
-- LINEAR SPECIFICATION
-- Without calculating euclideans,  check that points are within epsilon hypperectangle (l-infinity, linear)

-- Full definition
--LInfinityDistance x = max (x ! dv_x - x ! dv_x2) (max (x ! dv_x2 - x ! dv_x)(max (x ! dv_y - x ! dv_y2) (max (x ! dv_y2 - x ! dv_y)(max (x ! d_omega - x ! d_omega2) (max (x ! d_omega2 - x ! d_omega)(max (x ! d_theta - x ! d_theta2) (max (x ! d_theta2 - x ! d_theta)(max (x ! d_x - x ! d_x2) (max (x ! d_x2 - x ! d_x)(max (x ! d_y - x ! d_y2) (max (x ! d_y2 - x ! d_y)(max (x ! error - x ! error2) (x ! error2 - x ! error)))))))))))))


-- Limited definition - per dimension
LInfinityDistance : UnnormalisedInputVector -> Rat
LInfinityDistance x = max (x ! dv_x - x ! dv_x2)(x ! dv_x2 - x ! dv_x)

LInfinityDistance2 : UnnormalisedInputVector -> Rat
LInfinityDistance2 x = max (x ! dv_y - x ! dv_y2) (x ! dv_y2 - x ! dv_y)

LInfinityDistance3 : UnnormalisedInputVector -> Rat
LInfinityDistance3 x = max (x ! d_omega - x ! d_omega2) (x ! d_omega2 - x ! d_omega)

LInfinityDistance4 : UnnormalisedInputVector -> Rat
LInfinityDistance4 x = max (x ! d_theta - x ! d_theta2) (x ! d_theta2 - x ! d_theta)

LInfinityDistance5 : UnnormalisedInputVector -> Rat
LInfinityDistance5 x = max (x ! d_x - x ! d_x2) (x ! d_x2 - x ! d_x)

LInfinityDistance6 : UnnormalisedInputVector -> Rat
LInfinityDistance6 x = max (x ! d_y - x ! d_y2) (x ! d_y2 - x ! d_y)

LInfinityDistance7 : UnnormalisedInputVector -> Rat
LInfinityDistance7 x = max (x ! error - x ! error2) (x ! error2 - x ! error)

--LInfinityDistance : UnnormalisedInputVector -> Rat

-- Check if input point distance is within epsilon cube (L infinity)
boundedByEpsilonLInfinity: UnnormalisedInputVector -> Bool
boundedByEpsilonLInfinity x  = LInfinityDistance  x <= epsilon 
--	LInfinityDistance2  x <= epsilon and
--	LInfinityDistance3  x <= epsilon and
--	LInfinityDistance4  x <= epsilon and
--	LInfinityDistance5  x <= epsilon and
--	LInfinityDistance6  x <= epsilon and
--	LInfinityDistance7  x <= epsilon
	
-- Check that output points are within epsilon cube
LInfinityDistanceOutput : UnnormalisedInputVector -> Rat
LInfinityDistanceOutput x = max(norm_alsomitra x ! e_x - norm_alsomitra x ! e_x2) (norm_alsomitra x ! e_x2 - norm_alsomitra x ! e_x)

-- Calculate gradient according to Lipschitz definition, defined linearly
checkGradient: UnnormalisedInputVector -> Bool
checkGradient x  = (LInfinityDistanceOutput x)  <= LipschitzConstant * (LInfinityDistance  x)
--	(LInfinityDistanceOutput x)  <= LipschitzConstant * (LInfinityDistance2  x) and
--	(LInfinityDistanceOutput x) <= LipschitzConstant * (LInfinityDistance3 x) and
--	(LInfinityDistanceOutput x) <= LipschitzConstant * (LInfinityDistance4 x) and
--	(LInfinityDistanceOutput x) <= LipschitzConstant * (LInfinityDistance5 x) and
--	(LInfinityDistanceOutput x) <= LipschitzConstant * (LInfinityDistance6 x) and
--	(LInfinityDistanceOutput x) <= LipschitzConstant * (LInfinityDistance7 x)
--------------------------------------------------------------------------------
-- Property 1

-- for any x (pair of inputs) where the distance between them is less than eps, the gradient between them will be less than L

@property
property1 : Bool
property1 = forall x  .  validInput x  and boundedByEpsilonLInfinity x=>
		checkGradient x
		

--------------------------------------------------------------------------------
-- Property 2

-- If the drone is below the line (error < -0.1), the network will always make it pitch up (e_x < 0.001)


droneFarBelowLine : UnnormalisedInputVector -> Bool
droneFarBelowLine x =
  x ! error <= -0.1



@property
property2 : Bool
property2 = forall x . validInput x and droneFarBelowLine x =>
  norm_alsomitra x ! e_x <= 0.001



  ---------------------------------------------------------------------------------------
-- Property 3

-- Output always within -0.1 : 1.001 (normalised)

@property
property3 : Bool
property3 = forall x . validInput x =>
	norm_alsomitra x ! e_x <= (1.001-0.181) / 0.0012 and norm_alsomitra x ! e_x >= (-0.001-0.181) / 0.0012
	
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


