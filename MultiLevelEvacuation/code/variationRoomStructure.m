function [new_img_build,new_pixel_array,new_margin_array]=variationRoomStructure(img_build,pixel_array,margin_array,range)
   %we only consider translational variation here
   %randomly sample an object in the scene
   %move it as a whole
   %check whether there are collisions using margin array
   len=length(pixel_array);
   new_img_build=img_build;
   translation=randi([-range,range],len,2);
   new_margin_array=margin_array;
   new_pixel_array=pixel_array;
   for i=1:length(margin_array)
       new_margin_array{i}=new_margin_array{i}+translation(i);
       if(checkCollision(new_margin_array,i,[size(img_build,1),size(img_build,2)]))
           new_margin_array{i}=new_margin_array{i}-translation(i);
       else
          pause()
           for j=1:len
            new_img_build(new_pixel_array{i}(j,1)+translation(i,1),new_pixel_array{i}(j,2)+translation(i,2),1:3)=new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3);
            new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3)=new_img_build(new_pixel_array{i}(j,1)-translation(i,1),new_pixel_array{i}(j,2)-translation(i,2),1:3);
            
           end
           
            new_pixel_array{i}=new_pixel_array{i}+translation(i);
          
       end
   end
end