function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%


% get the path from the config file -> to read the images
config_path = fileparts(config_file); % fileparts() returns [filepath, name, extension]
if strcmp(config_path, '') == 1 % if path is empty (i.e. images are in the same folder)
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames); % convert to structure array

% At this point run the evolutionary algorithm

% read the images
for i=1:config.floor_count
    
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    
    % At this point read from the tensor that was returned from alg
    img_build = imread(file_name); % imread returns m*n*3 array representing the image
    
    % decode images
    % black = wall
    config.floor(i).img_wall = (img_build(:, :, 1) ==   0 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) ==   0);
    
    % violet = start area
    config.floor(i).img_spawn = (img_build(:, :, 1) == 255 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) == 255);
    
    % green = exit
    config.floor(i).img_exit = (img_build(:, :, 1) ==   0 ...
        & img_build(:, :, 2) == 255 ...
        & img_build(:, :, 3) ==   0);
    
    % red = stairs going up
    config.floor(i).img_stairs_up = (img_build(:, :, 1) == 255 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) ==   0);
    
    % blue = stairs going down
    config.floor(i).img_stairs_down = (img_build(:, :, 1) ==   0 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) == 255);
    
    %init the plot image here, because this won't change
    config.floor(i).img_plot = 5*config.floor(i).img_wall ...
        + 4*config.floor(i).img_stairs_up ...
        + 3*config.floor(i).img_stairs_down ...
        + 2*config.floor(i).img_exit ...
        + 1*config.floor(i).img_spawn;
    config.color_map = [1 1 1; 0.9 0.9 0.9; 0 1 0; 0.4 0.4 1; 1 0.4 0.4; 0 0 0];
end

