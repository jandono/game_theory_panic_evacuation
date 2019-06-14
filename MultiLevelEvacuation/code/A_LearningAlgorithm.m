%% The main function. The pipeline of running evolutionary algorithm with N_it iterations and N_children
% different copies

N_it = 2;
N_children = 3;

% Initialize Parents
for k=1:N_children
    filename = '../data/Copy_of_config1_1_build.png';
    room_k = imread(filename);
    filename = strcat('../data/Room',num2str(k),'.png');
    imwrite(room_k,filename);
end


for it=1:N_it
    
    
    %% For all children: Simulate
    % Find a way such that the simulation accesses the correct file
    % Find a way to access measured velocities of the agents and returns it to
    %  fitness vector (-> simulate ~line 43)
    
    fitness = zeros(1,N_children);
    for child = 1:N_children
        filename = strcat('../data/Room',num2str(k),'.png');
        room_picture = imread(filename);
        imwrite(room_picture,'../data/config1_1_build.png');
        fitness_child = simulate;
        fitness(child) = fitness_child;
    end
    
    fitness
    A_nextGeneration(fitness,N_children)
end;
