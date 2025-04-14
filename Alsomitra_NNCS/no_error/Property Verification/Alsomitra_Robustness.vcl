--------------------------------------------------------------------------------
-- Copied from: Full specification of the ACAS XU networks
-- Colin Kessler 14/4/25

-- Inputs
type InputVector =  Vector Rat 12

dv_x = 0
dv_y = 1
d_omega = 2
d_theta = 3
d_x = 4
d_y = 5
dv_x2 = 6
dv_y2 = 7
d_omega2 = 8
d_theta2 = 9
d_x2 = 10
d_y2 = 11


--Outputs
type OutputVector = Vector Rat 2

e_x = 0
e_x2 = 1

validInput : InputVector -> Bool
validInput x = forall i . 0.0 <= x ! i <= 1.0

--Network
@network
alsomitra : InputVector -> OutputVector

@parameter
epsilon: Rat

@parameter
Lipschitz: Rat

@parameter(infer=True)
n : Nat

@dataset
trainingInputs : Vector InputVector n

@dataset
trainingOutputs : Vector OutputVector n

boundedByEpsilon : InputVector -> Bool
boundedByEpsilon x = -epsilon <= x ! dv_x - x ! dv_x2 <= epsilon and
	-epsilon <= x ! dv_y - x ! dv_y2 <= epsilon and
	-epsilon <= x ! d_omega - x ! d_omega2 <= epsilon and
	-epsilon <= x ! d_theta - x ! d_theta2 <= epsilon and
	-epsilon <= x ! d_x - x ! d_x2 <= epsilon and
	-epsilon <= x ! d_y - x ! d_y2 <= epsilon

validPerturbation : InputVector -> Bool
validPerturbation x = x ! dv_x == 0.0 and
	x ! dv_y == 0.0 and
	x ! d_omega == 0.0 and
	x ! d_theta == 0.0 and
	x ! d_x == 0.0 and
	x ! d_y == 0.0

-- Robustness definition
robustAround : InputVector -> OutputVector -> Bool
robustAround input output = forall pertubation .
  	let perturbedInput = input - pertubation in validPerturbation pertubation and 
	validInput 	perturbedInput and  boundedByEpsilon perturbedInput=>
	output ! e_x - alsomitra perturbedInput ! e_x2 <= Lipschitz / epsilon

-- Property 1 
@property
property1 : Vector Bool n
property1 = foreach i . robustAround (trainingInputs ! i) (trainingOutputs ! i)