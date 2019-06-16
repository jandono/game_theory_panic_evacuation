%% add the desired force from agents to the total force, which is stored in data.floor.agents.f

function data = addDesiredForce(data)
%ADDDESIREDFORCE add 'desired' force contribution (towards nearest exit or
%staircase)

for fi = 1:data.floor_count

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        m = data.floor(fi).agents(ai).m;
        v0 = data.floor(fi).agents(ai).v0;
        v = data.floor(fi).agents(ai).v;
        
        
        
        % get direction towards nearest exit
        ex = lerp2(data.floor(fi).img_dir_x, p(1), p(2));
        ey = lerp2(data.floor(fi).img_dir_y, p(1), p(2));
        e = [ex ey];
        
        % get direction towards nearest exit if cooperating
        ex_coop = lerp2(data.floor(fi).img_dir_x_coop, p(1), p(2));
        ey_coop = lerp2(data.floor(fi).img_dir_y_coop, p(1), p(2));
        e_coop = [ex_coop ey_coop];       
        
        % get forces
        Fi = m * (v0*e - v)/data.tau;
        Fi_coop = m * (v0*e_coop - v)/data.tau;
        
        % add force
        if(data.floor(fi).agents(ai).coop == 1)
            data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi_coop;
        else
            data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi;
        end 
    end
end

