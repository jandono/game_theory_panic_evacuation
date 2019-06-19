classdef img_obj < handle
  properties
    image
    pixels
  end
  methods
    function h = img_obj(img,pix)
      h.image = img  ;
      h.pixels=pix;
    end
  end
end