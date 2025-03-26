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
norm_alsomitra x = alsomitra x


-----------

@parameter
epsilon: Rat

@parameter
LipschitzConstant:Rat

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
LInfinityDistance1 : UnnormalisedInputVector -> Rat
LInfinityDistance1 x = max (x ! dv_x - x ! dv_x2)(x ! dv_x2 - x ! dv_x)

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

-- Limited definition - per dimension
LInfinityDistance12 : UnnormalisedInputVector -> Rat
LInfinityDistance12 x = max (LInfinityDistance1 x) (LInfinityDistance2 x)

-- Limited definition - per dimension
LInfinityDistance34 : UnnormalisedInputVector -> Rat
LInfinityDistance34 x = max (LInfinityDistance3 x) (LInfinityDistance4 x)

-- Limited definition - per dimension
LInfinityDistance : UnnormalisedInputVector -> Rat
LInfinityDistance x = (LInfinityDistance12 x)

--LInfinityDistance : UnnormalisedInputVector -> Rat

-- Check if input point distance is within epsilon cube (L infinity)
boundedByEpsilonLInfinity: UnnormalisedInputVector -> Bool
boundedByEpsilonLInfinity x  =  0.00001 <= LInfinityDistance1  x <=  0.00005
	
-- Set dims 567 to points
dimsAsPoints: UnnormalisedInputVector -> Bool
dimsAsPoints x = x ! d_x == x ! d_x2 and
	x ! d_y == x ! d_y2 and
	x ! error == x ! error2 and
	x ! d_theta == x ! d_theta2 and
	x ! d_omega == x ! d_omega2 and
	x ! dv_y == x ! dv_y2
	


L1: UnnormalisedInputVector -> Rat
L1 x = norm_alsomitra x ! e_x - norm_alsomitra x ! e_x2

L2: UnnormalisedInputVector -> Rat
L2 x =  norm_alsomitra x ! e_x2 - norm_alsomitra x ! e_x

L3: UnnormalisedInputVector -> Rat
L3 x = max (L1 x) (L2 x)


-- Calculate gradient according to Lipschitz definition, defined linearly
checkGradient: UnnormalisedInputVector -> Bool
--checkGradient x  = L3 x  <= LipschitzConstant* LInfinityDistance1 x 
checkGradient x  = norm_alsomitra x ! e_x - norm_alsomitra x ! e_x2  <= LInfinityDistance1 x * LipschitzConstant and
	norm_alsomitra x ! e_x2 - norm_alsomitra x ! e_x  <= LInfinityDistance1 x * LipschitzConstant

--------------------------------------------------------------------------------
-- Property 1

-- for any x (pair of inputs) where the distance between them is less than eps, the gradient between them will be less than L

@property
property1 : Bool
property1 = forall x  .  validInput x and  dimsAsPoints x and boundedByEpsilonLInfinity x=>
		checkGradient x


