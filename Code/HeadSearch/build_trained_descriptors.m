function [] = build_trained_descriptors()

%DRAW_EAT_EVENTS Summary of this function goes here
%   Detailed explanation goes here

clear all 

output_dir = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/train';

%db_file =   'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/Sparus_17dph_13-05-2013_1.avi';
input_file = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/comp_output_scale_fullsize11.avi';
tag_file =   'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/Great success.xls';
load tag_data

clear mov
ext = '.avi';
clip_dir = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample';

%[readerobj h w numFrames frate sep tmp_dir ext] = my_mmreader(input_file,0 );  % do not forget to delete tmp_dir
readerobj = VideoReader(input_file);

frate=readerobj.FrameRate;                   % frame rate
h = readerobj.Height;
w = readerobj.Width;
n = readerobj.NumberOfFrames;

%{
fdataCurr1=imread('D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\temp\output001000.jpeg');
fdataCurr2=imresize(fdataCurr1,0.5);
H = fspecial('gaussian', [3 3],0.5);
GaussBlur = imfilter(fdataCurr2,H,'replicate');
size(GaussBlur)
imshow(GaussBlur);
%}
t_copmression_factor = 5;
x_copmression_factor = 2;
y_copmression_factor = 2;
output_idx=0;
[ a b ] = size(tag_data);
y_wing = 30;  
x_wing = 30;
t_wing = 30;

    for draw_idx = 1:a
        
            fclose('all');

            x = uint32(floor(tag_data(draw_idx,2)/x_copmression_factor));
            y = uint32(floor(tag_data(draw_idx,3)/y_copmression_factor));
            t = uint32(floor(tag_data(draw_idx,1)/t_copmression_factor));
            
            min_x = max(x-x_wing,1);
            max_x = min(x+x_wing,w);
            min_y = max(y-y_wing,1);
            max_y = min(y+y_wing,h);
            min_t = max(t-t_wing,1);
            max_t = min(t+t_wing,n);
            
            try
                %fdataCurr= my_read(readerobj,abs_f_idx ,clip_dir , ext, 0 );
                clear fdataCurr
                for fnum=min_t:max_t
                    fdataCurr(fnum-min_t+1,:,:,:) = read(readerobj, fnum);
                end
            catch
               fprintf('error read frame: %d   %d\n',draw_idx, rel_f_num); 
               continue;
            end






            
            curr_shot = fdataCurr(1:max_t-min_t+1, min_y:max_y, min_x:max_x,:);
            

            clear fdataCurr
            for fidx=1:size(curr_shot,1)
                mov(fidx).cdata = squeeze(curr_shot(fidx,:,:,:));
                mov(fidx).colormap = [];
            end

            
                %implay(mov);

 % save movie
 n_str = sprintf('%.4d',draw_idx);
 output_file = strcat(output_dir,'/eat_event_',n_str,'.avi');
 movie2avi(mov, output_file, 'compression', 'None');
                        
           
    end
                         





end

