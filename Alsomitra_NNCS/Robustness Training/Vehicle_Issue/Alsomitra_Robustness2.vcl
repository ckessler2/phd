--------------------------------------------------------------------------------
-- Copied from: Full specification of the ACAS XU networks

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

--Outputs
type OutputVector = Vector Rat 2

e_x = 0
e_x2 = 1

--Network
@network
alsomitra : InputVector -> OutputVector

--Set dimensions 2-7 as points
dimsAsPoints: InputVector -> Bool
dimsAsPoints x = x ! dv_y == x ! dv_y2 and 
	x ! d_x == x ! d_x2 and
	x ! d_y == x ! d_y2 and
	x ! error == x ! error2 and
	x ! d_theta == x ! d_theta2 and
	x ! d_omega == x ! d_omega2 

--Valid input - difference in dimension 1 less than epsilon and 2-7 as points
validInput : InputVector -> Bool
validInput x = forall i . 0.0 <= x ! i <= 1.0 and  
	(x ! dv_x - x ! dv_x2) <=  0.0005 and  
	(x ! dv_x2 - x ! dv_x) <=  0.0005 and 
	dimsAsPoints x
	
-- Property 1 
-- for valid inputs, dim 1 bounded by epsilon, and dims 2-7 as points, the difference in the outputs should be less than 0.01
@property
property1 : Bool
property1 = forall x  .  validInput x =>
	alsomitra x ! e_x - alsomitra x ! e_x2 <= 0.01

-- Property 2 
-- for valid inputs, dim 1 bounded by epsilon, and dims 2-7 as points, the second output should be less than 0.01
@property
property2 : Bool
property2 = forall x  .  validInput x =>
	alsomitra x ! e_x2 <= 0.01
