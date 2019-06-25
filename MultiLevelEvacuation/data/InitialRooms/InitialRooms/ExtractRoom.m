room = imread('GESS_triangle.png');
room(150:180,280:330,:) = 255;
basic_room = room;
imwrite(basic_room,'Basic_Room.png');

%{
filename = '../data/Copy_of_config1_1_build.png';
filename_original_picture = filename;
shapes = {'../data/shape.conf','../data/shape2.conf','../data/shape3.conf'};
[geom,room_k] = read_objects(shapes,filename);
%}

% First Room
Room_Basic_path = 'Basic_Room.png';
shapes = {'GESS_all_shapes_triangle.conf','GESS_all_shapes_table.conf'};
[geom,BasicRoom] = read_objects(shapes,Room_Basic_path);

Room_Init = geom.drawShapes(BasicRoom);
imshow(Room_Init)

%imshow('GESS_triangle.png');
