function img=plotest(i,new_margin_array,size)       
img=zeros(200,250);
       for x=new_margin_array{i}'
           if 0<x(1) && x(1)<=size(1) && 0<x(2) && x(2)<=size(2) 
                img(x(1),x(2))=1;
           end
       end
       imshow(img)
       