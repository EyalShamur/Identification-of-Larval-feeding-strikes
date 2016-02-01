















input_file = 'H:\\thesis - eating fishes\\DATABASES\\Database-B\\DB_300_HI_RES_Rot_Flip\\fish_head-0001.avi';
%input_file = 'H:\\thesis - eating fishes\\DATABASES\\Database-B\\Videos-ORIG\\sparus feeding dextran\\
%input_file = 'H:\\thesis - eating fishes\\DATABASES\\Database-A\\Videos-Compressed\\1.avi';

readerobj = VideoReader(input_file);
    nFrames = readerobj.NumberOfFrames;
    fprintf('Total num of frames %d  \n', nFrames);
    fclose('all');
idx=0;
    start_frame=1;
    end_frame = nFrames;
    for f_i = start_frame:6:end_frame  
        f_i
        idx=idx+1;
        fname = sprintf('H:\\thesis - eating fishes\\DATABASES\\noneating_fnum_%d.jpg',idx);


            
        try
            fdataCurr = read(readerobj, f_i);
        catch
           fprintf('error read frame:    %d\n', f_i); 
           continue;
        end
        
        imwrite(fdataCurr,fname,'jpg');
        
    end
    
    
    stophere=999;
    
    