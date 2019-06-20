function ObjectArray=extractShape(img_build)
    img_wall = (img_build(:, :, 1) ==   0 ...
        & img_build(:, :, 2) ==   0 ...
        & img_build(:, :, 3) ==   0);
    ObjectArray.pixel_array={};
    ObjectArray.margin_array={};
    while(true)
        margin=[];
        pixel=[0,0];
        if(isempty(find(img_wall,1)))
            break
        end
        pixel(1)=find(img_wall,1);
        [pixel(1),pixel(2)]=ind2sub(size(img_wall),pixel(1));
        img_object=img_obj(img_wall,[]);
%         img_object.image=img_wall;
%         img_object.pixels=[];
        dfs2(pixel,img_object);
        %'dfs ended'
        img_wall=img_object.image;
        pixels=img_object.pixels;

        %pixels
       % imshow(img_wall)
        %img_object=img_object.pixels;
        %img_wall(pixels)=0;
        for pixel2=pixels'      
            pixel=pixel2';
            sub_img=img_build(max(pixel(1)-1,1):min(pixel(1)+1,size(img_wall,1)),max(pixel(2)-1,1):min(pixel(2)+1,size(img_wall,2)),1:3);
            %size(sub_img)
            % if it is a neighbor to a non-black pixel
            if(~isempty(find(sub_img~=0,1)))
                margin=[margin;pixel];
            end
        end
        %size(margin)
        %size(pixels)
        ObjectArray.pixel_array{end+1}=pixels;
        ObjectArray.margin_array{end+1}=margin;
    end
end