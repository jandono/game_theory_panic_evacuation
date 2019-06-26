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
   %old_img_build=zeros(size(new_img_build),'uint8');
   % old_img_build(:)=new_img_build(:);
   for i=1:length(margin_array)
       new_margin_array{i}=new_margin_array{i}+translation(i,:);
       if(checkCollision(new_margin_array,i,[size(img_build,1),size(img_build,2)]))
           new_margin_array{i}=new_margin_array{i}-translation(i,:);
       else
           new_margin_array{i}=new_margin_array{i}-2*translation(i,:);
           if(checkCollision(new_margin_array,i,[size(img_build,1),size(img_build,2)]))
               new_margin_array{i}=new_margin_array{i}+translation(i,:);
           else
              
              new_margin_array{i}=new_margin_array{i}+2*translation(i,:); 
              img1=plotest(i,new_pixel_array,[200,250]);
             % imshow(img1)
              %pause()
              lenj=size(new_pixel_array{i},1);
%               temp=zeros(lenj,3);
%               for j=1:lenj
%                   temp(j,:)=new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3);
%               end
%               temp2=zeros(lenj,3);
%               for j=1:lenj
%                   temp2(j,:)=new_img_build(new_pixel_array{i}(j,1)-translation(i,1),new_pixel_array{i}(j,2)-translation(i,2),1:3);
%               end
%                 for j=1:lenj
%                      if(~isempty(find(new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3)~=0,1)))
%                          "error"
%                      end
%                 end
              for j=1:lenj
                %if(new_pixel_array{i}(j,1)+translation(i,1)>0)
                
                new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3)=255;
     
              end
              for j=1:lenj
                  new_img_build(new_pixel_array{i}(j,1)+translation(i,1),new_pixel_array{i}(j,2)+translation(i,2),1:3)=0; 
              end
                new_pixel_array{i}=new_pixel_array{i}+translation(i,:);
%                 for j=1:lenj
%                      if(~isempty(find(new_img_build(new_pixel_array{i}(j,1),new_pixel_array{i}(j,2),1:3)~=0,1)))
%                          "error"
%                      end
%                 end
                
                %imshow(new_img_build)
                
           end
       end
   end
   %imshow(abs(new_img_build-old_img_build));
   
end