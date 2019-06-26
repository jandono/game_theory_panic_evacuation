%% Sample the next generation of room structures, variate the room structure by using random direction translation of objects
%represented by black pixels
% and new room structures to images


function NewObjectArrays=pixel_nextGeneration(fitness,N_children,ObjectArrays,directory)


    %% Resample Children room numbers
    children_numbers = A_sample_children_numbers(fitness,N_children);
    
    %% Add rooms to new children_rooms
    % Do this by writing the tensors to files
    % Tensor dimension 400x500x3
    %originalPicture = imread(filename_original_picture);
    NewObjectArrays={};
    for child=1:N_children
        % Load the chosen room
        k = children_numbers(child);
       % obj_filename = strcat('../data/Geom',num2str(k),'.mat'); % Parent Path
        %obj_filename_fut = strcat('../data/Geom',num2str(child),'_future.mat');
        pic_filename = strcat(directory,'Room',num2str(k),'.png');
        future_pic_filename=strcat(directory,'Room_future',num2str(child),'.png');
        room_k = imread(pic_filename);
        %load(obj_filename); % This is called geom
        
        % Randomize the geometry parameters
        %geom = geom.translateRand(0.1); %translation distance is in meters
        %save(obj_filename_fut,'geom');
        % Draw geometry on it 
        %childRoom = geom.drawShapes(originalPicture);
        % and store the new room (future!)
        %childRoom=geom.drawShapes()
        [room_k,NewObjectArrays{child}.pixel_array,NewObjectArrays{child}.margin_array]=variationRoomStructure(room_k,ObjectArrays{k}.pixel_array,ObjectArrays{k}.margin_array,20);
        imwrite(room_k,future_pic_filename);
    end

    for child=1:N_children
        filename = strcat(directory,'Room_future',num2str(child),'.png');
        target = strcat(directory,'Room',num2str(child),'.png');
        movefile(filename,target);
    end
end
    % Override Parents
    
        
        