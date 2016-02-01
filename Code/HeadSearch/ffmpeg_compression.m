
% To have a constant quality (but a variable bitrate), use the option ’-qscale n’ when ’n’ is between 1 (excellent quality) and 31 (worst quality). 



%implay ('D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes/DB sample/output_libx264crf20.avi');
%%INPUT_FILE= 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\ORIG\Sparus_17dph_13-05-2013_1.avi';
%CROPED_INPUT_FILE= 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes/DB sample/croped_input.avi';
%%OUT_FILE = 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes\DB sample\ORIG/0.avi';
%readerobj = VideoReader(INPUT_FILE);
%readerobj
%1 -->  ffmpeg -t 5  -i Sparus_17dph_13-05-2013_1.avi -vcodec libxvid -crf 5 -vf scale=1024:512 -qscale 1 -qmin 1 -intra -an -r 30 hh.avi
%2 -->  ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 50 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%3 --> ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 10 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%4 --> ffmpeg_command = strcat('ffmpeg -t 10 -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 5 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%5 --> ffmpeg_command = strcat('ffmpeg -t 10 -i "',INPUT_FILE,'" -vcodec libxvid -crf 5 -vf scale=iw/2:ih/2 -qscale 5 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%6 --> ffmpeg_command = strcat('ffmpeg -t 10 -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 3 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%7 --> ffmpeg_command = strcat('ffmpeg -t 10 -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
% win ---> ffmpeg_command = strcat('ffmpeg -t 10 -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 30  "', OUT_FILE,'"');
%8 --> ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an  "', OUT_FILE,'"');
%9 --> ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 29.9 "', OUT_FILE,'"');
%10--> ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 29.924 "', OUT_FILE,'"');
%11--> ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 59.848 "', OUT_FILE,'"');
    input_filename = 'sparus_22dph_batch1_dex0_01-05-14_11-25-39.779.avi';
    INPUT_FILE = strcat('H:/thesis - eating fishes/DATABASES/Database-B/Videos-ORIG/sparus feeding dextran/',input_filename);
    output_filename = strcat('compressed_05_',input_filename);
    
%output_filename = 'dummy1.avi';  

    
    OUT_FILE = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-Compressed/',output_filename);
    
%drdrd = VideoReader(OUT_FILE);
%nframes = drdrd.NumberOfFrames;
%frate = drdrd.FrameRate;

%use -t 1  to compress one second only.
ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an "', OUT_FILE,'"');
system(ffmpeg_command);


%------------------------------------------------------------
%ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libxvid -vf scale=iw/2:ih/2 -qscale 2 -qmin 1 -intra -an -r 59.848 "', OUT_FILE,'"');
%system(ffmpeg_command);
%------------------------------------------------------------




%ffmpeg_command = strcat('ffmpeg -t 1 -i "',INPUT_FILE,'" -acodec copy "', CROPED_INPUT_FILE,'"');
%system(ffmpeg_command);

%ffmpeg -i hd-movie.mkv -c:v libx264 -s:v 854x480 -c:a copy out.mp4
%%ffmpeg_command = strcat('ffmpeg -t 1 -i "',INPUT_FILE,'" -c:v libx264 -s:v 1024x512 -c:a copy  "', OUT_FILE,'"');
%system(ffmpeg_command);


% -vcodec libx264 -vf
%ffmpeg_command = strcat('ffmpeg -t 1  -i "',INPUT_FILE,'" -vcodec libxvid -crf 5 -vf scale=iw/2:ih/2 "', OUT_FILE,'"');
%system(ffmpeg_command);

% -vcodec libx264 -vf
%ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -t 1 -vcodec libxvid -crf 1 -vf scale=iw/2:ih/2 "', OUT_FILE,'"');
%system(ffmpeg_command);

%ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec libx264 -crf 5 "', OUT_FILE,'"');
%system(ffmpeg_command);


%ffmpeg_command = strcat('ffmpeg -i "',INPUT_FILE,'" -vcodec msmpeg4v2 -qscale 0.5 "', OUT_FILE,'"');
%                ffmpeg_command = strcat(ffmpeg_command,' &>/dev/null'); % added to avoid printing info to the screen
%system(ffmpeg_command);

%h264






%implay ('DB sample/compreesed-6.avi');
%implay('DB sample/eating_events_all.avi');
%{
fname = 'DB sample/compreesed-6.avi';
%}
%{
INPUT_FILE= 'D:\Eyal\OpenU\Computer Science - MSc\thesis - eating fishes/DB sample/Sparus_17dph_13-05-2013_1.avi';

info = aviinfo(INPUT_FILE);
                frate=info.FramesPerSecond;                   % frame rate
                h = info.Height;
                w = info.Width;
                mov = aviread(fname);
                numFrames = length(mov); 
                readerobj = mov;

%}
