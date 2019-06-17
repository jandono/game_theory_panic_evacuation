%depth first search to find the connected component of wall pixels
function [pixels,image]=dfs(index,image)
    pixels=(index);
    image(index)=0;
    for x=[index(1)-1,index(1)+1]
        for y=[index(2)-1,index(2)+1]
            if(image(x,y)==1)
                pixels=[pixels;dfs([x y],image)];
            end
        end
    end
end