%% The main function. The pipeline of running evolutionary algorithm with N_it iterations and N_children
% different copies

N_it = 2;
N_children = 12;

% Initialize Parents
% 1 Set the initial conditions for everybody
filename = '../data/Copy_of_config1_1_build.png';
filename_original_picture = filename;
shapes = {'../data/shape.conf','../data/shape2.conf','../data/shape3.conf'};
[geom,room_k] = read_objects(shapes,filename);
for k=1:N_children
    filename = strcat('../data/Room',num2str(k),'.png');
    imwrite(room_k,filename);
    obj_filename = strcat('../data/Geom',num2str(k),'.mat');
    save(obj_filename,'geom')
end

%{
It works! Loads with the same variable name
clear;
imshow('../data/Room2.png');
load obj_filename;
geom.triangles
%}

for it=1:N_it
    
    %% For all children: Simulate
    % Find a way such that the simulation accesses the correct file
    % Find a way to access measured velocities of the agents and returns it to
    %  fitness vector (-> simulate ~line 43)
    fitness = zeros(1,N_children);
    parfor child = 1:N_children
        filename = strcat('../data/Room',num2str(k),'.png');
        room_picture = imread(filename);
        imwrite(room_picture,'../data/config1_1_build.png');
        fitness_child = simulate;
        fitness(child) = fitness_child;
    end
    
    fitness
    A_nextGeneration(fitness,N_children,filename_original_picture)
end;