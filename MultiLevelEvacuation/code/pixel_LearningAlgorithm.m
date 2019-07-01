%%the main function if you want to extract the objects by pixels. The pipeline of running evolutionary algorithm with N_it iterations and N_children
% different copies
function pixel_LearningAlgorithm(N_it,N_children)

% Initialize Parents
% 1 Set the initial conditions for everybody
directory=strcat('../data/it',num2str(N_it),'child',num2str(N_children),'/');
mkdir(directory)
filename = '../data/config2_build.png';
% filename_original_picture = filename;
% shapes = {'../data/shape.conf','../data/shape2.conf','../data/shape3.conf'};
% [geom,room_k] = read_objects(shapes,filename);
room=imread(filename);

%imshow(room)
room=room(1:2:end,1:2:end,:);
for k=1:N_children
    filename = strcat(directory,'Room',num2str(k),'.png');
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
for child = 1:N_children
        filename = strcat(directory,'Room',num2str(child),'.png');
        room=imread(filename);
        %imshow(room_picture)
        ObjectArrays{end+1}=extractShape(room);
end
config_file='../data/config2.conf';
for it=1:N_it
    
    %% For all children: Simulate
    % Find a way such that the simulation accesses the correct file
    % Find a way to access measured velocities of the agents and returns it to
    %  fitness vector (-> simulate ~line 43)
    fitness = zeros(1,N_children);
    %imshow(filename)
    for child = 1:N_children
        %filename = strcat('../data/Room',num2str(child),'.png');
        room=imread(strcat(directory,'Room',num2str(child),'.png'));
        %imshow(room_picture)
        %imwrite(room_picture,'../data/config1_1_build.png');

        fitness_child = simulate(config_file,strcat(directory,'Room',num2str(child),'.png'));
        fitness(child) = fitness_child;
    end
    
    fitness
    ObjectArrays=pixel_nextGeneration(fitness,N_children,ObjectArrays,directory);
end
[value,index]=max(fitness);
best_img=imread(strcat(directory,'Room',num2str(index),'.png'));
save(strcat(directory,'fitness_history_',num2str(N_it),'_',num2str(N_children),'.mat'),'fitness_history');
save(strcat(directory,'best_image_',num2str(N_it),'_',num2str(N_children),'.mat'),'best_img');
