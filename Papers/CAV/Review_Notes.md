From Katya (Slack 11/3): 

Reviewer 1 mainly wishes it was written and structured better. Review 2 has the same criticism and is unhappy with overall formulation of the verification target (I agree, we never actually formally say what is the ideal property we want to hold), and how the two verification efforts come together. Note: Review 1 and 2 disagree as to how relevant training is. Reviewer 2 is probably more of an expert. Reviewer 1 rejected us mainly because the draft looked untidy. Reviewer 2 is surprised that Lipshitz robustness, rather than proper adversarial training, is used to train for our properties. It is not very standard to do such things: it is probably worth to have both property driven training and Lipshitz robustness training in the long run... Review 3 points out that the properties are so easy they do not really need Vehicle -- I agree, they actually do not make use of much of Vehicle's functionality that can declare unit conversions, functions, operations over arrays, etc. We need more interesting properties to show that Vehicle, and not standard Marabou, is really needed.

**Changes for SAIV submission:**
1. Remove error dimension - NNs now have 6 inputs. Vehicle specification will include line equation in x and y
2. Verify Lipschitz robustness properly
 * Onnx merging script works, vehicle specification is written
 * It currently seems that I cannot compare network outputs, have posted issue on GH - reply from Matt asking for clarification, I gave him my commands
 * Otherwise I can verify with respect to a dataset - as with MNIST example
 * Or try another verification language (PyRAT?)
3. Smaller networks with relu activation - makes verification much faster, might make CORA behave better
 * Still have issue that we cannot use the same networks for vehicle and CORA (normalised v unnormalised). I think I can solve this if I spend a day on it
4. Consider TaxiNet case study, verification of regression networks (?)


**General weaknesses with original submission according to Reviewers**
1. How do sub-problems relate to the overall problem?
2. Hard to follow because of a lack of sufficient details:
 * Table 1 (equations, too small) and figure 7 (reachability) are hard to understand, captions unhelpful.
 * Lack of elaboration on how tools cannot express specification (following a trajectory). In other words, how was it challenging to encode properties
 * More detail on Lipschitz training implementation - how is the worst-case adversarial example found in each training iteration?
 * Figure 8 (Lipschitz robustness vs training epsilon) - How is Lipschitz robustness measured?
 * Hard to understand if system/reachability is continuous or discrete
