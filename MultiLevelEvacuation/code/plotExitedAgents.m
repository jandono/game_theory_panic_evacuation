function plotExitedAgents(data)
%plot time vs exited agents
persistent X;
persistent Y;

if isempty(X)
    X = [0, data.time];
    disp("check here")
else    
    X = [X, data.time];

end

if isempty(Y)
    Y = [0, data.agents_exited];
else
    Y = [Y, data.agents_exited];
end
%hold on;
%plot(data.time, data.agents_exited, 'o');
plot(X, Y, 'r-')
%hold off;
