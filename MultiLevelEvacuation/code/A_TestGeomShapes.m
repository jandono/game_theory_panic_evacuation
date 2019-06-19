geom = geomObj;
s1 = [5;5]; p0 = [10;10];
geom = geom.insertTriangle(s1,p0);
p0 = [25; 25]; sizes = [10; 10]; phi = 120;
geom = geom.insertRectangle(p0,sizes,phi);
geom = geom.insertRectangle(p0,sizes,phi+40);
p0 = [0; 25]; R = 20;
geom = geom.insertCircle(p0,R);
image = imread('../data/config2_build.png');
image = geom.drawShapes(image);
imshow(image)