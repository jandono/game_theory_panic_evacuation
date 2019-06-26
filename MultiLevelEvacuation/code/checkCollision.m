%return true if there is collision between
%the object and boundary
%the objects and objects(for the boundary walls, we also extract it as objects. So this means that the objects cannot traverse across walls)
function isCollide=checkCollision(margin_array,index,size)
    margin=margin_array{index};
    isCollide=false;
    if(~isempty(find((margin<1)+(margin(:,1)>size(1))+(margin(:,2)>size(2)),1)))
       img=zeros(size(1),size(2));
       for x=margin'
           if 0<x(1) && x(1)<=size(1) && 0<x(2) && x(2)<=size(2) 
                img(x(1),x(2))=1;
           end
       end
       imshow(img)
       isCollide=true;
       return
    end
    for i=1:length(margin_array)
        %pause()
        %a=union(margin,margin_array{i},'rows')
        %size(a)
        if(i==index)
            continue
        end
        if(length(unique([margin;margin_array{i}],'rows'))<length(margin)+length(margin_array{i}))
           img=zeros(size(1),size(2));
           for x=margin'
            img(x(1),x(2))=1;
           end
           for x=margin_array{i}'
               img(x(1),x(2))=1;
           end
            imshow(img)            
            isCollide=true;
            break
            
        end
    end
    %pause()
end