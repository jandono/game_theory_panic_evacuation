# Code Folder 

this folder contains the matlab & c code

to run the simulation, first compile the c code using the matlab function
'compileC.m' (install a c compiler first, eg gcc on UNIX).

run the simulation with: simulate() with the optional config file as argument
(eg '../data/config1.conf').

video generation (on unix):
set the save\_frames in the config to 1, then after simulation, use the script
eps2avi.sh in this folder to generate a video in the folder ../videos (run
./eps2avi.sh to see how to use it).


## some conventions

- image coordinates:
 img(y,x), where y is vertcal index, x is horizontal index
 img(1,1) is the upper leftmost point

- data format:
 all internal data is stored in pixels not in meters


## Cluster running:
- clone from the cluster branch
- load matlab module: module load new matlab/9.1
- use matlab function compileC.m to compile C files(the file is modified to suit the cluster environment)
- specify the parameters in the script: parameters in for loop mean the experiment number, while we take N_it and N_children to be 16 and 12 by default 
- the output for experiment number i is in the directory ../data/ExperimentNumber$i. Best image is stored in best_img_(N_it)_(N_children).mat while the fitness value over iterations is stored in fitness_history.mat.
