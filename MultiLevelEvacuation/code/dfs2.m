%depth first search to find the connected component of wall pixels
function dfs2(index,image_object)
    %index
    if(mod(index(1),100)==0 && mod(index(2),100)==0)
       %index
       length(image_object.pixels);
       %imshow(image_object.image)   
    end
    
    image_object.pixels=[image_object.pixels;index];
    length(image_object.pixels);
    image_object.image(index(1),index(2))=0;
    for x=index(1)-1:index(1)+1
        if ~(0 < x && x <= size(image_object.image,1))
            %size(image_object.image,1)
            continue;
        end

        for y=index(2)-1:index(2)+1
            if(x==index(1) && y==index(2))
                continue
            end
            if(x~=index(1) && y~=index(2))
                continue
            end
            if ~(0 < y && y <= size(image_object.image,2))
                continue;
            end
            if(image_object.image(x,y)==1)
                %fprintf('%i %i\n',x,y);
                dfs2([x y],image_object);
            end
        end
    end
end