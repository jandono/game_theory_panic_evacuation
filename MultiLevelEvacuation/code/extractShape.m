function ObjectArray=extractShape(img_build)
    img_wall = (img_build(:, :, 1) ==   0 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) ==   0);
    
    while(true)
        margin=[];
        pixel=[0,0];
        pixel(1)=find(img_wall,1);
        if(isempty(pixel))
            break
        end
        [pixel(1),pixel(2)]=ind2sub(size(img_wall),pixel(1));
        [pixels]=dfs(pixel,img_wall,[]);
        'dfs ended'
        img_wall(pixels)=0;
        for pixel=pixels
            sub_img=img_build(pixel(1)-1:pixel(1)+1:2,pixel(1)-1:pixel(1)+1:2,1:3);
            if(sum(sub_img~=255)~=0)
                margin=[margin;pixel];
            end
        end
        ObjectArray.pixel_array=cat(3,ObjectArray.pixel_array,pixels);
        ObjectArray.margin_array=cat(3,ObjectArray.margin_array,pixels);
    end
end