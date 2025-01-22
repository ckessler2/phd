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
-- to work over.
minimumInputValues : UnnormalisedInputVector
minimumInputValues = [0.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0]

maximumInputValues : UnnormalisedInputVector
maximumInputValues = [0.952704, 1.18577, 0.953317, 0.986364, 0.639149,1.0,1.0]

validInput : UnnormalisedInputVector -> Bool
validInput x = forall i . minimumInputValues ! i + 0.0  <= x ! i <= maximumInputValues ! i - 0.0

-- Then the mean values that will be used to scale the inputs.
minScalingValues : UnnormalisedInputVector
minScalingValues = [ 1.0        , -0.54068897, -0.3386752 , -1.18850405, -0.20712096, 1.0,1.0]

stdValues : UnnormalisedInputVector
stdValues = [0.47654473, 0.07599687, 0.06998913, 0.20082238, 0.8521974, 1.0, 1.0 ]

-- We can now define the normalisation function that takes an input vector and
-- returns the unnormalised version.
normalise : UnnormalisedInputVector -> InputVector
normalise x = foreach i .
  (x ! i - minScalingValues ! i) / (stdValues ! i * 6.0)

-- Using this we can define a new function that first normalises the input
-- vector and then applies the neural network.
norm_alsomitra : UnnormalisedInputVector -> OutputVector
norm_alsomitra x = alsomitra (x)


--------------------------------------------------------------------------------
-- Property 1

-- If the drone is far above the line (error > 1), the network will always make it pitch down (e_x > 0.5)


droneFarAboveLine : UnnormalisedInputVector -> Bool
droneFarAboveLine x =
      x ! error <= (-0+ 2) / (6*0.683353)



@property
property1 : Bool
property1 = forall x . validInput x and droneFarAboveLine x =>
  norm_alsomitra x ! e_x <= 0.0001


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

