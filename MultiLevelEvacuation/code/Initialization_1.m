function [image,geom] = Initialization_1(image)

geom = geomObj;

% Triangles
s1 = [5;5]; p0 = [10;10];
geom = geom.insertTriangle(s1,p0);

% Rectangles
p0 = [25; 25]; sizes = [10; 10]; phi = 120;
geom = geom.insertRectangle(p0,sizes,phi);
geom = geom.insertRectangle(p0,sizes,phi+40);


% Circles
p0 = [0; 25]; R = 20;
geom = geom.insertCircle(p0,R);

% 
image = geom.drawShapes(image);