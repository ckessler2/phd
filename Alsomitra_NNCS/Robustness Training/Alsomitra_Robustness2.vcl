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

@parameter
epsilon: Rat

@parameter
LipschitzConstant:Rat
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
validInput x = forall i . 0.0 <= x ! i <= 1.0

dimsAsPoints: UnnormalisedInputVector -> Bool
dimsAsPoints x = x ! d_x == x ! d_x2 and
	x ! d_y == x ! d_y2 and
	x ! error == x ! error2 and
	x ! d_theta == x ! d_theta2 and
	x ! d_omega == x ! d_omega2 and
	x ! dv_y == x ! dv_y2

x1_bigger : UnnormalisedInputVector -> Bool
x1_bigger x = x ! dv_x >= x ! dv_x2

y1_bigger : UnnormalisedInputVector -> Bool
y1_bigger x = alsomitra x ! e_x >= alsomitra x ! e_x2

L_inf_1: UnnormalisedInputVector -> Rat
L_inf_1 x = if x1_bigger x then x ! dv_x - x ! dv_x2 else x ! dv_x2 - x ! dv_x

L_inf_out: UnnormalisedInputVector -> Rat
L_inf_out x = if y1_bigger x then alsomitra x ! e_x  - alsomitra x  ! e_x2  else  alsomitra x ! e_x2  - alsomitra x  ! e_x

check_gradient:  UnnormalisedInputVector -> Bool
check_gradient x = L_inf_out x <= 100.0 * L_inf_1 x 

@property
property1 : Bool
property1 = forall x  .  validInput x and  dimsAsPoints x and 0.00001 <= L_inf_1 x<= epsilon =>
		check_gradient x


