function shapes = getShapePaths(ExperimentNumber)

% Experiment with one cirlcle in a room
if ExperimentNumber == 0
    shapes = {'../data/InitialRooms/GESS_all_shapes_circle.conf'};
end


% Experiment with one square in a room
if ExperimentNumber == 1
    shapes = {'../data/InitialRooms/square_little_below.conf'};
end

% Experiment with one single triangle in a room
if ExperimentNumber == 2
    shapes = {'../data/InitialRooms/triangle_before_door.conf'};        
end

% Experiment with 3 objects in a room (triangle, square, circle)
if ExperimentNumber == 3
    shapes = {'../data/InitialRooms/GESS_all_shapes_table.conf',...
        '../data/InitialRooms/GESS_all_shapes_circle.conf',...
        '../data/InitialRooms/GESS_all_shapes_triangle.conf'};
end

% Experiment with two objects in a room (Square,Circle)
if ExperimentNumber == 4
    shapes = {'../data/InitialRooms/square_little_below.conf',...
        '../data/InitialRooms/GESS_all_shapes_circle.conf'};
end    

% Experiment with two objects in a room (Triangle,circle) 
if ExperimentNumber == 5
    shapes = {'../data/InitialRooms/GESS_all_shapes_triangle.conf',...
    '../data/InitialRooms/GESS_all_shapes_circle.conf'};
end

% Experiment with two objects in a room (Triangle,square) 
if ExperimentNumber == 6
    shapes = {'../data/InitialRooms/GESS_all_shapes_triangle.conf',...
    '../data/InitialRooms/GESS_all_shapes_table.conf'};
end
