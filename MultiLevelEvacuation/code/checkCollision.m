function isCollide=checkCollision(margin_array,index,size)
    len=size(margin_array);
    margin=margin_array(index);
    isCollide=false;
    if(sum((margin<1)+(margin(:,1)>size(1))+(margin(:,2)>size(2)),'all')>0)
        isCollide=true;
    end
    for i=1:len(3)
        if(size(unique([margin;margin_array(:,:,i)],'row'),1)<size(margin,1)+size(margin_array(:,:,i),1))
            isCollide=true;
            break
        end
    end
end