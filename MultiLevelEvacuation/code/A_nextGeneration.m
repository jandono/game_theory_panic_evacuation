%% Sample the next generation of room structures, variate them using random noise,
% and new room structures to images


function nextGeneration(fitness,N_children)


%% Resample Children room numbers
children_numbers = A_sample_children_numbers(fitness,N_children);

%% Add rooms to new children_rooms
% Do this by writing the tensors to files
% Tensor dimension 400x500x3
for child=1:N_children
    % Load the chosen room
    k = children_numbers(child);
    filename = strcat('../data/Room',num2str(k),'.png');
    room_k = imread(filename);
    
    % Randomize child and save to same filename + future
    %{
    room_k = room_k + uint8(randi(2,size(room_k))-1);
    filename = strcat('../data/Room',num2str(child),'_future.png'); % CANNOT DO THIS
    imwrite(room_k,filename);
    %}
    
    % Apply Ding's Code to randomize the images
    
end

% Override Parents
for child=1:N_children
    filename = strcat('../data/Room',num2str(child),'_future.png');
    target = strcat('../data/Room',num2str(child),'.png');
    movefile(filename,target)
end