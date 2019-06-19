function geom=read_objects(filenames,imagename)
    geom = geomObj;
    for filename=filenames
        config_path = fileparts(filename); % fileparts() returns [filepath, name, extension]
        if strcmp(config_path, '') == 1 % if path is empty (i.e. images are in the same folder)
            config_path = '.';   
        end
        filename
        fid = fopen(filename,'r');
        input = textscan(fid, '%s=%s');
        fclose(fid);
        keynames = input{1};
        values = input{2};
        v = str2double(values);
        idx = ~isnan(v);
        values(idx) = num2cell(v(idx));
        keynames
        values
        
        config = cell2struct(values, keynames);
        if(strcmp(config.shape,'triangle'))
            geom = geom.insertTriangle([config.s1x;config.s1y],[config.p0x;config.p0y]);
        end
        if(strcmp(config.shape,'rectangle'))
            geom=geom.insertRectangle([config.p0x;config.p0y],[config.sizex;config.sizey],config.phi);
        end
        if(strcmp(config.shape,'circle')) 
            geom=geom.insertCircle([config.p0x;config.p0y],config.R);
        end
        image=geom.drawShapes(imread(imagename));
        imshow(image)
    end
    
