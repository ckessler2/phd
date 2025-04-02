CAV 2025 Paper #189 Reviews and Comments
===========================================================================
Paper #189 Neural Network Verification for Gliding Drone Control: A Case
Study


Review #189A
===========================================================================

Overall merit
-------------
2. Weak reject

Reviewer expertise
------------------
3. Knowledgeable

Paper summary
-------------
The paper reports on an effort to verify a neural network controller for a gliding drone (this is a case study paper). This task for this type of drone is different from the existing NN controller benchmarks, because safety is defined as adhering to a certain safe trajectory, instead of reachability of safe/unsafe sets, and because the dynamics are more complex than for current benchmark systems. 
<mark>Agree</mark>
The case study uses two existing tools, Marabou and CORA, to verify different properties of the controller, because no single tool exists that could verify all of them. While one would want to verify properties for an infinite horizon, this is not possible with today’s tools, but the paper shows that more restricted properties can be proven for some versions of controllers. These different versions of the controller are obtained by different NN training.
<mark>We should explain clearer what the different training modes are - unnormalised vs normalised, and normal vs adversarial. This could be explained with a table, or CORA normalised.</mark>

Comments for authors
--------------------
Verifying the correctness of neural network controllers for real-world applications such as the discussed drones is highly relevant. The focus of the paper and thus the intended contribution is unclear to me, however. For CAV, the verification part is probably the most relevant and interesting one, but a lot of the technical details provided are not about this but e.g. about the NN training. The presentation of the paper makes it hard for me to follow and judge. Below I point out the most important parts that were confusing to me.
<mark>Contributions! But SAIV readers will probably be okay with ML component.</mark>

I found the paper structure to be confusing. For example, it mixes and jumps between NN training and verification. Perhaps it would help to state the role of NN training up-front, and thus separate the two parts. 
<mark>Consider putting training before verification. Say that it is known that normal training is not robust - don't need to define robustness before training.</mark>

I also found the use of figures rather confusing. Most figures are referenced in the text without essentially any explanation at all, some figures (e.g. Fig 1 & 2) are not explained enough to be of much use (at least to me) even with the caption. It would make the text easier to read if the important explanations from the captions were moved to the main text. The ordering and placing of figures is also rather confusing (e.g. Fig 6 comes before Fig 5). 
Table 2: U is explained, but what does Yes/No mean?
<mark>Fig 2 caption: Explain better for people who aren't engineers(approximation _of Alsomitra_).</mark>

The paper provides many low-level details that are not accessible to people who are non-expertsn, but that don’t seem to be actually necessary for the high-level picture.  Table 1, for example, could be moved to the appendix and the most important aspects summarized in the body of the paper (e.g. What makes this system more complex than previous ones? Number of variables, constraints etc.).
Section 3 suddenly talks about a PID controller, without introducing it or explaining its role. It is also not (explicitly) part of Fig 5.
<mark>Make more use of equations table, mention that they are implemented in CORA. Mention in contributions - coding complex dynamics in CORA</mark>
<mark>Dedicate section/subsection explaining difficulty in formalising in CORA (impossibility in vehicle/marabou). Include snippet of code?</mark>

I was also confused about the verification properties stated in section 4. What is e_x? In section 3 it was introduced as the value that the PID controller actuates. How is the drone affected by e_x? It seems that e.g. a value of e_x = 0.7 would make the drone pitch down (property 1) and also not pitch down (property 2). Can you please check/explain this?
Property 3 seems to imply that 1 <= 0?
<mark>Could have section (3?) "formalisation of alsomitra in NNVs", discuss formalising either way is difficult, challenges, variables, nonlinearity, snippets. Vehicle is also difficult, no equations but infinite horizon, made certain choices, etc.</mark>

Review #189B
===========================================================================

Overall merit
-------------
2. Weak reject

Reviewer expertise
------------------
3. Knowledgeable

Paper summary
-------------
This paper presents a case study involving the verification of a cyber-physical system with a neural network (NN) controller. Verification of such systems is an increasingly important problem that is under active investigation as evidenced by the existence of its own verification competition (ARCH-COMP). However, this paper argues that the problems currently considered in the competition are not challenging enough. Towards this end, the paper presents gliding drones with neural controllers as a challenging problem to consider. The dynamics of this system are complex and non-linear, it requires consideration of infinite-time horizons, and unlike typical safety specifications that require reaching a desired goal state while avoiding unsafe states, for this system, the specification is relative---it asks for the drone to track a desired trajectory. All of these, the paper argues, makes the verification problem specially challenging. <mark>Agree</mark>  The paper also presents some initial attempts at verifying this system. In particular, for ease of verification, the paper proposes two simpler sub-problems (although these do not combine to give a proof of the original problem).--We need to think about this, maybe they combine well-- The first sub-problem poses verification queries about the neural network controller in isolation without considering the system dynamics and can be solved using NN verification tools such as Marabou. The second sub-problem considers the system dynamics but only focuses on finite-time horizon properties that can be addressed using tools such as CORA. Finally, the paper also proposes to train the NN using adversarial
training in order to improve the overall safety of the system. <mark>Agree</mark>
<mark>Formalisation section- explain ideal formalisation of original problem and how CORA/Vehicle deviate. Ideal is different from state of the art, do sub problems combine to cover the original or not?</mark>
<mark>Seems that overall method came across well, even if writeup was not perfect</mark>

Comments for authors
--------------------
### Strengths
1. The gliding drone case study presents an interesting verification challenge.

2. The attempt to break down the verification task into queries that can be handled by Marabou vs queries handled by CORA suggests a potentially useful strategy.

3. The observation that simply training the DNN controller in an adversarial fashion can help improve overall system safety is worth exploring further.

### Weaknesses
1. While gliding drones are an interesting challenge problem, the verification attempts presented in the paper still seem to be in very early stages. As such, although the paper presents some interesting initial ideas, it does not feel like a completed case study at this stage.
<mark>Maybe clarify contributions. Argue that improvements will make cohesive result - where exactly should the problem be completed, or continued in future?</mark>
<mark>Need to talk more about it, inc with Alessandro. Is problem complete or not? Can it even be solved? To what extent?</mark>
<mark>Ideal property is infinite horizon, we think two tools are good approximators - cite other papers and how they use approximations</mark>
<mark>Conceptually, is infinite horizon verification possible or reasonable?</mark>

2. The decomposition of the overall verification problem in to the two sub-problems feels a little ad-hoc. How do these two sub-problems relate to the overall problem?
<mark>See above</mark>

3. In various places, the paper can be hard to follow because of a lack of sufficient details. I elaborate on this in the next section.


### Detailed Comments and Questions
Following is a list of detailed comments and questions:

1. Fig 1 and 2: These figures are hard to follow and the captions are not very helpful.
<mark>Same as review 1. Maybe there is a better way of conceptualising</mark>

2. Table 1: Its extremely hard to make sense of what's going on this table. While I understand that not all details can be provided, I would at least hope for some high-level explaination to guide the reader.
<mark>Same as review 1. We should strengthen use of equations + snippets as contribution instead of in appendix</mark>
</mark>Table 1 is original contribution, cross-reference draft</mark>

3. The paper frequently says that available verification tools do not allow expressing the kind of specification (follow a desired trajectory) required for this system. However, this point is not carefully elaborated. In fact, the desired specification is never expressed formally, which makes it hard to judge the validity of this claim.
<mark>See above</mark>

4.  Section 4: How are the NN specifications in this section obtained?
<mark>See above</mark>

5. Figure 7: It is difficult to interpret Figure 7. Neither the caption nor the text in the paper are very helpful. What do reachable set 1 and set 3 correspond to? What do you precisely mean when you say that CORA does not support NN normalisation? It would help to elaborate a bit on the role of normalisation.
<mark>Reachable sets need to be explained in formalisation section. </mark>
<mark>Explain how normalisation is not available in CORA</mark>

6. Pg 8: "During adverarial training with a given $\epsilon$" --> Dangling sentence
<mark>Fix</mark>

7. Section 5: (i) I would have liked to see more details of how adversarial training is used for the regression setting. For instance, how is the worst-case adversarial example found in each training iteration? (ii) Fig 8: How is Lipschitz robustness measured?
<mark>Explain adversarial training for regression better - how much needed modification</mark>
<mark>Explain how LR is handled - measured etc.</mark>

8. Pg 9: "The reachability timesteps need to be small (0.01s) to avoid set explosions" --> Not sure what this means. Is the system modeled as a discrete-time or a continuous-time system? Earlier, Section 5, mentions that the model timestep is 0.01s. Again, what does this mean precisely? It would generally help to elaborate how CORA is used for verification in this case. Also, the paragraph titled "Encountered Technical Limitations and Lessons Learnt" could benefit from some more explanations in the text.
<mark>Explain discretization of reachability in formalisation section - time has to be discretised etc.</mark>
<mark>Expand limitations section</mark>

Review #189C
===========================================================================

Overall merit
-------------
3. Weak accept

Reviewer expertise
------------------
3. Knowledgeable

Paper summary
-------------
This is a case study paper on the formal verification of a new kind of drones, inspired by biological seeds (dandelion or "Alsomitra"). The drones are built using neural network control. The formal verification is performed with Marabou (for the neural network) and CORA (for system-level verification). <mark>Agree</mark>

Comments for authors
--------------------
Pros:

The paper describes a new kind of drones, that are rather interesting.
The verification performed is pretty standard but it highlights the merits and limitations of existing verification tools.
<mark>See if we can emphasize difficulty in formalisation as contribution</mark>

Cons:

The paper is generally clearly written although it has some odd formatting issues that should be fixed before publication. For instance the information in Table 1 is too tiny to read and all the captions are tiny and use an unusual font.
<mark>Change table to be more readable, fix formatting</mark>

Questions:

The authors mentioned using Vehicle but it is unclear how it was used for the case study. I could not understand the challenge in encoding the four properties on page 6. Is it the case that the preconditions of the properties could not be encoded in terms of NN inputs? Did you need to link with the NN embeddings? Please explain.
<mark>Verification definitions in marabou work for any other verifier</mark>
<mark>Justify use of vehicle - makes complex property definition easier. Normalisation should be done in vehicle, and explained</mark>
<mark>Vehicle allows definition of relational properties, talk about line and output. Ideal property would be exactly relational - NN will follow close to line, irrespective of coordinates.</mark>

Small comment:

The authors mention that existing verification efforts focus on classifiers while they have a regression model to analyze. The authors should look up and cite literature on the TaxiNet case study, which uses a regression model to guide airplanes on taxiways.
<mark>Read through, find links/similarities/differences and cite if useful. Statement of where we deviate</mark>



Response by Author [Colin Kessler <ck2049@hw.ac.uk>] (38 words)
---------------------------------------------------------------------------
Apologies for the delay - it is clear that this paper is not refined enough for this publication, and will be withdrawn. We thank our reviewers for the insightful feedback, and will continue improving our work for suture submissions.
