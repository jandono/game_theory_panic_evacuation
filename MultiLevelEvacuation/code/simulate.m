%% taking filename as input and output the average efficiency metric(the fitness function for the room structure)
% The filename corresponds to a config file recording the parameters and
% image of room structure.
%line 49-59(added code): calculate the metric of efficiency using
%individual position and velocity


function avg_effic = simulate(config_file,filename)
% run this to start the simulation

% if no config_file provided -> use the default one
if nargin==0 
    config_file='../data/config1.conf';
    filename='../data/config1_1_build.png';
end
if nargin==1
    config_file='../data/config1.conf';
end

fprintf('Load config file...\n');
filename
config = loadConfig(config_file,filename);

data = initialize(config);


data.time = 0;
frame = 0;
fprintf('Start simulation...\n');

avg_effic = 0;
timesteps = 0;

while (data.time < data.duration)
    tstart=tic;
    data = addDesiredForce(data);
    data = addWallForce(data);
    data = addAgentRepulsiveForce(data);
    data = applyForcesAndMove(data);
    
    % do the plotting
    set(0,'CurrentFigure',data.figure_floors);
    for floor=1:data.floor_count
        plotAgentsPerFloor(data, floor);
        plotFloor(data, floor);
    end
%     if data.save_frames==1
%         print('-depsc2',sprintf('frames/%s_%04i.eps', ...
%             data.frame_basename,frame), data.figure_floors);
%     end
    
    set(0,'CurrentFigure',data.figure_exit);
    plotExitedAgents(data);
    
    
    %% WE CHANGED THIS
    % print mean/median velocity of agents on each floor
     
    

if (data.time + data.dt > data.durati n)
        data.dt = data.duration - data.time;
        data.time = data.duration;
    else
        data.time = data.time + data.dt;
    end
    
    if data.agents_exited == data.total_agent_count
        fprintf('All agents are now saved (or are they?). Time: %.2f sec\n', data.time);
        fprintf('Total Agents: %i\n', data.total_agent_count);
        
        print('-depsc2',sprintf('frames/exited_agents_%s.eps', ...
            data.frame_basename), data.figure_floors);
        break;
    end
    
     for fi = 1:data.floor_count
         % calculate the efficiency metric at this specific timestep
         effic = arrayfun(@(agent) agent.v*...
         [lerp2(data.floor(fi).img_dir_x, agent.p(1), agent.p(2)) lerp2(data.floor(fi).img_dir_y, agent.p(1), agent.p(2))]'/agent.v0...
	 , data.fl or(fi).agents);
           % we need to average the efficiency over time finally.
         avg_effic = avg_effic + mean(effic); 
    
     end
     timesteps = timesteps + 1;
    telapsed = toc(tstart);
    pause(max(data.dt - telapsed, 0.01));
    %fprintf('Frame %i done (took %.3fs; %.3fs out of %.3gs simulated).\n', frame, telapsed, data.time, data.duration);
    frame = frame + 1;
    
    %data
end

avg_effic = avg_effic/timesteps;

fprintf('Simulation done.\n');

