classdef geomObj
    
    properties
        triangles;
        circles
        rectangles;
        meter_per_pixel = 0.1;
    end
    
    methods
        
        function obj = geomObj(obj)
            obj.triangles = [];
            obj.circles = [];
            obj.rectangles = [];
        end
        
        % s1 is one corner; p0 opposite middle point
        function obj = insertTriangle(obj,s1,p0)
            obj.triangles = [obj.triangles, [s1; p0]];
        end
        
        function obj = insertRectangle(obj,p0,sizes,phi)
            obj.rectangles = [obj.rectangles, [p0; sizes; phi]];
        end
        
        function obj = insertCircle(obj,p0,R)
            obj.circles = [obj.circles, [p0; R]];
        end
        
        function image = drawShapes(obj,image)
            for rect=1:size(obj.rectangles,2)
                image = obj.drawRectangle(rect,image);
            end
            for tri=1:size(obj.triangles,2)
                image = obj.drawTriangle(tri,image);
            end
            for circ=1:size(obj.circles,2)
                image = obj.drawCircle(circ,image);
            end
        end
        
        function image = drawCircle(obj,circNumber,image)
            % Search
            p0R = obj.circles(:,circNumber);
            p0 = p0R(1:2)
            R = p0R(3)
            
            % Geometrical Descr
            inCircle = @(p) norm(p-p0) < R;
            
            % Draw
            lb_i = floor((p0(2)-R)/obj.meter_per_pixel);
            ub_i = ceil((p0(2)+R)/obj.meter_per_pixel);
            lb_j = floor((p0(1)-R)/obj.meter_per_pixel);
            ub_j = ceil((p0(1)+R)/obj.meter_per_pixel);
            
            lb_i = max(1,lb_i);
            ub_i = min(size(image,1),ub_i);
            lb_j = max(1,lb_j);
            ub_j = min(size(image,2),ub_j);
            
            for i=lb_i:ub_i
                for j=lb_j:ub_j
                    p = obj.meter_per_pixel*[j;i];
                    if inCircle(p)
                        image(i,j,:) = 0;
                    end
                end
            end
        end
        
        
        
        function image = drawRectangle(obj,rectNumber,image)
            % Search
            p0sizesphi = obj.rectangles(:,rectNumber);
            p0 = p0sizesphi(1:2);
            sizes = p0sizesphi(3:4);
            phideg = p0sizesphi(5);
            
            % Geometrical Descr
            phi = pi/180*phideg;
            Q = [cos(phi) sin(phi); -sin(phi) cos(phi)];
            inRectangle = @(p) prod(abs(Q*(p-p0)) < [sizes(1)/2; sizes(2)/2]) == 1;
            
            % Draw
            % Worst case: The corner points straight up.
            % Thus can bound the domain by center +- 0.5*sqrt(a^2+b^2)
            lb_i = (p0(2)-norm(sizes/2))/obj.meter_per_pixel;
            ub_i = (p0(2)+norm(sizes/2))/obj.meter_per_pixel;
            lb_j = (p0(1)-norm(sizes/2))/obj.meter_per_pixel;
            ub_j = (p0(1)+norm(sizes/2))/obj.meter_per_pixel;
            
            lb_i = max(1,floor(lb_i));
            ub_i = min(size(image,1),ceil(ub_i));
            lb_j = max(1,floor(lb_j));
            ub_j = min(size(image,2),ceil(ub_j));
            
            for i=lb_i:ub_i
                for j=lb_j:ub_j
                    p = obj.meter_per_pixel*[j;i];
                    if inRectangle(p)
                        image(i,j,:) = 0;
                    end
                end
            end
            
        end
        
        function image = drawTriangle(obj,triangleNumber,image)
            % Search
            s1p0 = obj.triangles(:,triangleNumber);
            s1 = s1p0(1:2);
            p0 = s1p0(3:4);
            
            % Define the geometrical inequalities
            phideg = 120;
            phi = pi/180*phideg;
            Q = [cos(phi) sin(phi); -sin(phi) cos(phi)];
            v1 = p0-s1; b1 = v1'*p0;
            v2 = Q*v1; b2 = v2'*s1;
            v3 = Q*v2; b3 = v3'*s1;
            V = [v1'; v2'; v3'];
            b = [b1 b2 b3]';
            
            inTriangle = @(p) prod(V*p < b);
            
            % Draw it for the matrix
            % The bounds can be found the exact same way as in circle
            % (spin the triangle) and the radius is
            center = s1+2/3*(p0-s1);
            R = 2/3*norm(p0-s1);
            
            lb_i = floor((center(2)-R)/obj.meter_per_pixel);
            ub_i = ceil((center(2)+R)/obj.meter_per_pixel);
            lb_j = floor((center(1)-R)/obj.meter_per_pixel);
            ub_j = ceil((center(1)+R)/obj.meter_per_pixel);
            
            lb_i = max(1,lb_i);
            ub_i = min(size(image,1),ub_i);
            lb_j = max(1,lb_j);
            ub_j = min(size(image,2),ub_j);
            
            for i=lb_i:ub_i
                for j=lb_j:ub_j
                    p = obj.meter_per_pixel*[j;i];
                    if inTriangle(p)
                        image(i,j,:) = 0;
                    end
                end
            end
        end
    end
end