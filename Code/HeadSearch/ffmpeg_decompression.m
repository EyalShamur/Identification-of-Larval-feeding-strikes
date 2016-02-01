function  draw_eat_events(  )
%DRAW_EAT_EVENTS Summary of this function goes here
%   Detailed explanation goes here

clear all 

output_file = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/decomp.avi';
input_file = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/Sparus_17dph_13-05-2013_1.avi';
ext = '.avi';
temp_dir = 'D:/Eyal/OpenU/Computer Science - MSc/thesis - eating fishes/DB sample/temp';



readerobj = VideoReader(input_file);
fn=26;
frame_data = read(readerobj, fn);
imshow(frame_data);


%[readerobj h w numFrames frate sep tmp_dir ext] = my_mmreader(input_file,1 );  % do not forget to delete tmp_dir

ffmpeg_command = strcat('ffmpeg -i "',input_file,'" -f image2 "', temp_dir,'/output%06d.png"');
                    system(ffmpeg_command);
                    numFrames=1;
                    outputfilename= sprintf('%s/output%06d.png',temp_dir,numFrames);
                    while exist(outputfilename,'file') 
                        numFrames=numFrames+1;
                        outputfilename= sprintf('%s/output%06d.png',temp_dir,numFrames);
                    end
                    numFrames=numFrames-1;


output_idx=0;


        while 1
            fclose('all');
            output_idx = output_idx+1;
            try
                    fn= sprintf('%s/output%06d.png',temp_dir,output_idx);
                    fdataCurr=imread(fn);
                    %fdataCurr= my_read(readerobj,output_idx ,temp_dir , ext, 1 );
            catch
               fprintf('error read frame: %d   \n',output_idx); 
               break;
            end
            
         
            mov(output_idx).cdata = fdataCurr;
            mov(output_idx).colormap = [];
            

                        
        end   

                         


 % save movie
 movie2avi(mov, output_file, 'compression', 'None');
 
 implay(mov);
end

