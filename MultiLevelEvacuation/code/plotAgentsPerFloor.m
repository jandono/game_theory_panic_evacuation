function plotAgentsPerFloor(data, floor_idx)

persistent X;
persistent Y;

if nargin == 1
    X = [data.time];
    Y = [length(data.floor(floor_idx).agents)];
else
    X = [X, data.time];
    Y = [Y, length(data.floor(floor_idx).agents)];
end

%plot time vs agents on floor

h = subplot(data.floor(floor_idx).agents_on_floor_plot);

set(h, 'position',[0.05+(data.floor_count - floor_idx)/(data.figure_floors_subplots_w+0.2), ...
    0.05, 1/(data.figure_floors_subplots_w*1.2), 0.3-0.05 ]);

if floor_idx~=data.floor_count
    set(h,'ytick',[]) %hide y-axis label
end

axis([0 data.duration 0 data.total_agent_count]);

hold on;
%plot(data.time, length(data.floor(floor_idx).agents), 'b-');
plot(X,Y, 'b-');
hold off;

title(sprintf('agents on floor %i', floor_idx));

