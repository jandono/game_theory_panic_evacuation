%%the main function if you want to extract the objects by pixels. The pipeline of running evolutionary algorithm with N_it iterations and N_children
% different copies

N_it = 20;
N_children = 8;

% Initialize Parents
% 1 Set the initial conditions for everybody
filename = '../data/config2_build.png';
% filename_original_picture = filename;
% shapes = {'../data/shape.conf','../data/shape2.conf','../data/shape3.conf'};
% [geom,room_k] = read_objects(shapes,filename);
room=imread(filename);
for k=1:N_children
    filename = strcat('../data/Room',num2str(k),'.png');
    imwrite(room,filename);
%     obj_filename = strcat('../data/Geom',num2str(k),'.mat');
%     save(obj_filename,'geom')
end

%{
It works! Loads with the same variable name
clear;
imshow('../data/Room2.png');
load obj_filename;
geom.triangles
%}
ObjectArrays={};
config_file='../data/config1.conf';
for it=1:N_it
    
    %% For all children: Simulate
    % Find a way such that the simulation accesses the correct file
    % Find a way to access measured velocities of the agents and returns it to
    %  fitness vector (-> simulate ~line 43)
    fitness = zeros(1,N_children);
    for child = 1:N_children
        filename = strcat('../data/Room',num2str(child),'.png');
        room_picture = imread(filename);
        room_picture=room_picture(100:300,1:400,1:3)
        imshow(room_picture)
        
        if(it==1)
            ObjectArrays{end+1}=extractShape(room_picture);
        end
        %imwrite(room_picture,'../data/config1_1_build.png');

        fitness_child = simulate(config_file,strcat('../data/Room',num2str(child),'.png'));
        fitness(child) = fitness_child;
    end
    
    fitness
    ObjectArrays=pixel_nextGeneration(fitness,N_children,ObjectArrays);
end