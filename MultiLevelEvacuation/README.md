# MATLAB FS12 – Research Plan

> * Group Name: Baby-Chiefs
> * Group participants names: Hans Hardmeier, Andrin Jenal , Beat Kueng, Felix Thaler
> * Project Title: Modelling Situations of Evacuation in a Multi-level Building

## General Introduction

Simulating the evacuation scenario of a single-level building is well known but not general enough. Though we want to introduce a more sophisticated simulation within a multi-level building. 
E.g.: What would happen, if a multi-level building has to be evacuated? Which escape routes would be mostly used?
Since tower buildings are getting more common in large cities, engineers have to care more about the behaviour in situations of emergency, namely evacuation. 
To investigate in some of these aspects we will create a relatively general framework for behavioral simulation in evacuation scenarios.

## The Model

General Model:
We are planning to base our work on the social force model. The  behaviour of the agents will be heavily influenced by different model parameters like obstacles, stairs and other agents. In addition psychological pressure in such evacuation scenarios are going to be investigated.
Research:
As a core investigation we are going to simulate an everyday situation in a crowded (public) environment ending in an evacuation scenario.

## Fundamental Questions

Research object: General (public) multi-level building
How does an implementation of a social force model look like?
How can this be implemented efficiently for a multilevel building?
How does the simulation behave for a real building like the ETH CAB building?
How realistic is the behaviour of the agents?

## Expected Results

We expect the stairs and the main building exit to be the bottlenecks. The amount of people in lower levels is increasing with time until a certain point, when most of the people have exited the building.
Also we think that if the velocity of the people is higher (people are more in panic), jams at the exit will be increased and people will mainly try to take the main exit instead of emergency exits.

## References 

Bibliographic References:

Helbling, Dirk - Molnar, Peter (1995): Social Force Model for Pedestrians Dynamics

Helbling, Dirk, Johansson, Anders (2007): Dynamics of crowd disasters: An empirical Study

Helbling, Dirk, Johansson, Anders (2006): Analytical Approach to Continuous and Intermittent Bottleneck Flows

Schadschneider, Andreas et al. (2002): CA Approach to Collective Phenomena in Pedestrian Dynamics

Helbling, Dirk et al. (2000): Simulating dynamical features of escape panic

Helbling, Dirk et al. (2005): Self-Organized Pedestrian Crowd Dynamics: Experiments, Simulations, and Design Solutions

Our idea of the simulation might go in a similar direction as the one of the "Airplane Evacuation 2011 FS" and the Project "Evacuation Bottleneck:
Simulation and analysis of an evacuation of a high-school building with MATLAB" from HS 2011.
But we won't base our work on these reports and we won't focus on a single evacuation object as they do, but we want to create a general framework which can easily be adapted to different scenarios. We will hopefully be able to implement more efficient algorithms to additionally support larger scale evacuations.  

## Research Methods

We will use the agent-based social force model to simulate the behaviour of invdividual persons. Shortest evacuation paths may probably be precalculated using a grid discretization and efficient fast sweeping methods.
The parameters of the model will be based on empirical data from accordant literature.

## Other

Model Properties: Mentioned in the papers
