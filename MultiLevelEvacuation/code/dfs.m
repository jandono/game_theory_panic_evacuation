%has been obsolete
function [pixels]=dfs(index,image,old_pixels)

% if isFirstCall
%     persistent image;
% end

%pixels=(index);
%image(index(1),index(2))=0;
pixels=[old_pixels;index];
for x=[index(1)-1,index(1)+1]
    if ~(0 < x && x <= size(image,1))
        continue;
    end

    for y=[index(2)-1,index(2)+1]
        if ~(0 < y && y <= size(image,2))
            continue;
        end
        if(image(x,y)==1)
            if(sum(ismember(pixels,[x,y],'rows')))
                continue
            end
            %fprintf('%i %i\n',x,y);
            pixels = dfs([x y],image,pixels);
        end
    end
end
size(pixels)
if(~size(unique(pixels,'rows'),1)==size(pixels,1))
    'error';
    size(unique(pixels,'rows'),1)
end
end