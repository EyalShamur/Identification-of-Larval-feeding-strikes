function  aa_head_search(  )
%DRAW_EAT_EVENTS Summary of this function goes here
%   Detailed explanation goes here

    clear vars
    close all

    input_filename = 'sparus_13dph_batch3_dex5_01-01-14_12-04-37.648';%'sparus_22dph_batch3_dex0_01-10-14_11-15-05.562';
    ext = '.avi';
    hi_res=true;
    if hi_res
        input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-ORIG\sparus feeding dextran\',input_filename,ext);
    else
        input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-Compressed\compressed_05_',input_filename,ext);       
    end
    %input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-ORIG\sparus feeding dextran\',input_filename,ext);
    
 output_dir = 'H:\thesis - eating fishes\DATABASES\Database-B\Unknown_events\';
    clear mov

    %implay(input_file);
    
    %input_file = 'H:\thesis - eating fishes\DATABASES\Database-A\Videos-Compressed\4.avi';
    %input_filename = '4.avi';

    readerobj = VideoReader(input_file);
    nFrames = readerobj.NumberOfFrames;
    fprintf('Total num of frames %d  \n', nFrames);
    fclose('all');
    f_idx=0;
    mid_frame = 31200;%6930;
    start_frame=mid_frame-50;
    end_frame = mid_frame+50;
    %start_frame=mid_frame-1;
    %end_frame = mid_frame+1;
    
    
    mark=0;
    if mark
        mark_x = 280;%/2
        mark_y = 490;%/2
    end
    
    
    
    for f_i = start_frame:1:end_frame  
        f_i
        f_idx=f_idx+1;


            
        try
            fdataCurr = read(readerobj, f_i);
        catch
           fprintf('error read frame:    %d\n', f_i); 
           continue;
        end
        
        if mark
            for m_x = mark_x-10:mark_x+10
                fdataCurr(mark_y:mark_y+1,m_x,1) = 255;
                fdataCurr(mark_y:mark_y+1,m_x,2) = 255;
                fdataCurr(mark_y:mark_y+1,m_x,3) = 0;
            end
            for m_y = mark_y-10:mark_y+10
                fdataCurr(m_y,mark_x:mark_x+1,1) = 255;
                fdataCurr(m_y,mark_x:mark_x+1,2) = 255;
                fdataCurr(m_y,mark_x:mark_x+1,3) = 0;
            end
        
        end
        
        
drawrect = false;
if drawrect
    xloc = 380;
    yloc = 250;
    for thic = -5:5 
        fdataCurr(xloc-100:xloc+100,yloc+100+thic,1) = 255;
        fdataCurr(xloc-100:xloc+100,yloc+100+thic,2) = 0;
        fdataCurr(xloc-100:xloc+100,yloc+100+thic,3) = 0;
        fdataCurr(xloc-100:xloc+100,yloc-100+thic,1) = 255;
        fdataCurr(xloc-100:xloc+100,yloc-100+thic,2) = 0;
        fdataCurr(xloc-100:xloc+100,yloc-100+thic,3) = 0;
        fdataCurr(xloc+100+thic,yloc-100:yloc+100,1) = 255;
        fdataCurr(xloc+100+thic,yloc-100:yloc+100,2) = 0;
        fdataCurr(xloc+100+thic,yloc-100:yloc+100,3) = 0;
        fdataCurr(xloc-100+thic,yloc-100:yloc+100,1) = 255;
        fdataCurr(xloc-100+thic,yloc-100:yloc+100,2) = 0;
        fdataCurr(xloc-100+thic,yloc-100:yloc+100,3) = 0;
    end
    %imshow(fdataCurr);

end


        
        mov(f_idx).cdata=fdataCurr;%(100:275,825:1000,:);%(250:400,350:700,:);%(450:800,1100:1450,:);%(250:600,500:850,:);
        mov(f_idx).colormap=[];
        
        
        
    end
    
    implay(mov);
    out_file = sprintf('%s/%s_from_%d_to_%d%s',output_dir,input_filename,start_frame,end_frame,ext);
    movie2avi(mov, out_file, 'compression', 'None');

    
    endprog=1;
    
    
end
        
        
        
        
        
        
        
        
        
        