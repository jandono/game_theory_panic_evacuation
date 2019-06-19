filename = '../data/Copy_of_config1_1_build.png';
filename_original_picture = filename;
shapes = {'../data/shape.conf','../data/shape2.conf','../data/shape3.conf'};
[geom,room_k] = read_objects(shapes,filename);

geom.circles
geom = geom.translateRand(0.1);
geom.circles