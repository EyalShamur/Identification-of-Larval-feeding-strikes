







%implay ('DB sample/compreesed-6.avi');
%implay('DB sample/eating_events_all.avi');

fname = 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\ORIG\2.avi';



obj = VideoReader(fname);
video_info = get(obj);
nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;                
curr_frame = read(obj, 500);

imshow(curr_frame);

 implay ('D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\ORIG\2.avi');
               
                
 %fname = 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\Sparus_17dph_13-05-2013_1.avi';
%info = aviinfo(fname);
%                frate=info.FramesPerSecond;                   % frame rate
%                h = info.Height;
%                w = info.Width;
%mov = aviread(fname);
%numFrames = length(mov); 
%readerobj = mov;

%{                
                
                INPUT_FILE= 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes/DB sample/Sparus_17dph_13-05-2013_1.avi';
OUT_FILE = 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes/DB sample/output_libx264crf20.avi';


ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libx264 -crf 20 "', OUT_FILE,'"');
system(ffmpeg_command);

ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec msmpeg4v2 -qscale 0.5 "', OUT_FILE,'"');
%                ffmpeg_command = strcat(ffmpeg_command,' &>/dev/null'); % added to avoid printing info to the screen
system(ffmpeg_command);

%h264
 
 %}