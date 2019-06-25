%% Sample the next generation of room structures, variate them using random noise,
% and new room structures to images


function nextGeneration(fitness,N_children,filename_original_picture)


%% Resample Children room numbers
children_numbers = A_sample_children_numbers(fitness,N_children);

%% Add rooms to new children_rooms
% Do this by writing the tensors to files
% Tensor dimension 400x500x3
originalPicture = imread(filename_original_picture);

for child=1:N_children
    % Load the chosen room
    k = children_numbers(child);
    obj_filename = strcat('../data/Geom',num2str(k),'.mat'); % Parent Path
    obj_filename_fut = strcat('../data/Geom',num2str(child),'_future.mat');
    pic_filename = strcat('../data/Room',num2str(child),'.png');
    %room_k = imread(filename);
    load(obj_filename); % This is called geom
    
    % Randomize the geometry parameters
    geom = geom.translateRand(0.5); %translation distance is in meters
    save(obj_filename_fut,'geom');
    % Draw geometry on it 
    childRoom = geom.drawShapes(originalPicture);
    % and store the new room (future!)
    imwrite(childRoom,pic_filename);
end

% Override Parents
for child=1:N_children
    filename = strcat('../data/Geom',num2str(child),'_future.mat');
    target = strcat('../data/Geom',num2str(child),'.mat');
    movefile(filename,target)
end