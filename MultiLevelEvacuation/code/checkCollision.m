function isCollide=checkCollision(margin_array,index,size)
    margin=margin_array{index};
    isCollide=false;
    if(~isempty(find((margin<1)+(margin(:,1)>size(1))+(margin(:,2)>size(2)),1)))
        isCollide=true;
    end
    for i=1:length(margin_array)
        pause()
        %a=union(margin,margin_array{i},'rows')
        %size(a)
        if(length(unique([margin;margin_array{i}],'rows'))<length(margin)+length(margin_array{i}))
            isCollide=true;
            break
        end
    end
end