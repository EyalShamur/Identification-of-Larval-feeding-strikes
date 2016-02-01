clear all
close all

% input
input_folder = 'H:\Thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_Flip';
input_file = 'fish_head-0062.avi';
input_vid_hi_res = strcat(input_folder,'\\',input_file);
readerobj = VideoReader(input_vid_hi_res);
n_1 = readerobj.NumberOfFrames;

% output
output_folder = 'H:\Thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_Flip_corrected';
output_file = input_file;
output_vid_hi_res = strcat(output_folder,'\\',output_file);

    for fr_idx=1:n_1
        Img = read(readerobj, fr_idx);
        L_flipped = fliplr(Img(:,:,1));
        
        
        mov_flipped(fr_idx).cdata(:,:,1) = L_flipped;
        mov_flipped(fr_idx).cdata(:,:,2) = L_flipped;
        mov_flipped(fr_idx).cdata(:,:,3) = L_flipped;
        mov_flipped(fr_idx).colormap = [];
        
    end
    
 movie2avi(mov_flipped, output_vid_hi_res, 'compression', 'None'); 
        
  disp('done');      
        