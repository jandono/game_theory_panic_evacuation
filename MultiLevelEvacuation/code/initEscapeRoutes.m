function data = initEscapeRoutes(data)
%INITESCAPEROUTES Summary of this function goes here
%   Detailed explanation goes here

for i=1:data.floor_count

    boundary_data = zeros(size(data.floor(i).img_wall));
    boundary_data(data.floor(i).img_wall) =  1;
    %if (i == 1)
        boundary_data(data.floor(i).img_exit) = -1;
    %else
        boundary_data(data.floor(i).img_stairs_down) = -1;
    %end
    
    boundary_data_coop = boundary_data;
    boundary_data_coop(data.floor(i).img_imaginary) = 1;

    exit_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
    [data.floor(i).img_dir_x, data.floor(i).img_dir_y] = ...
        getNormalizedGradient(boundary_data, -exit_dist);
    
    exit_dist_coop = fastSweeping(boundary_data_coop) * data.meter_per_pixel;
    [data.floor(i).img_dir_x_coop, data.floor(i).img_dir_y_coop] = ...
        getNormalizedGradient(boundary_data_coop, -exit_dist_coop);
end

