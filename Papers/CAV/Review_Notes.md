From Katya (Slack 11/3): 

Reviewer 1 mainly wishes it was written and structured better.

Review 2 has the same criticism and is unhappy with overall formulation of the verification target (I agree, we never actually formally say what is the ideal property we want to hold), and how the two verification efforts come together. Note: Review 1 and 2 disagree as to how relevant training is. Reviewer 2 is probably more of an expert. Reviewer 1 rejected us mainly because the draft looked untidy. The surprise that Lipshitz robustness, rather than proper adversarial training, is used to train for our properties. It is not very standard to do such things: it is probably worth to have both property driven training and Lipshitz robustness training in the long run...

Review 3 points out that the properties are so easy they do not really need Vehicle -- I agree, they actually do not make use of much of Vehicle's functionality that can declare unit conversions, functions, operations over arrays, etc. We need more interesting properties to show that Vehicle, and not standard Marabou, is really needed.
