clear all
close all

%{
 
Input/Output options: 
   -f   : input video file 
   -ff  : first frame index 
   -lf  : last frame index 
   -o   : file name for saving detected features 
   -cam : the camera number (starts from 0)  
          (if you don't specify any number, it shows a dialog for choosing a camera) 
   -res : camera resolution for processing  
          the following resolutions are available  
	    0 : 80  x 60  
	    1 : 160 x 120 (default)  
	    2 : 320 x 240  
	    3 : 400 x 300  
	    4 : 640 x 480  
 
Detection options: 
   -nplev : number of levels in spatial frame pyramid (default=3) 
            factor 2 subsampling is used; for each pyramid level 
            points are detected at four combinations of spatial 
            and temporal scales obtained by Gaussian smoothing  
            with spatial variance sigma2={4.0,8.0} and  
            temporal variance tau2={2.0,4.0} 
   -plev0 : initial level of spatial frame pyramid (default=0) 
   -kparam: K parameter in Harris function (default=0.00050) 
   -thresh: threshold for ommiting weak points (default=1.000e-009) 
	    (to get all interest points set to zero) 
   -border: reject interest points within image boundary (default=5) 
 
Descriptor options: 
   -dscr  : type of descriptor [hoghof|hog|hof|hnf] (default=hoghof) 
   -szf   : factor used to compute descriptor patch size (default=5.0) 
            patch size along spatial/temporal dimensions is defined as 
            size_dim=szf*2*sqrt(Gauss variance_dim) 
 
Other options: 
   -h    : shows this message 
   -vis  : [yes|no] visulization stuffs (default=yes) 

%}

Database_A=0;
Database_B=1;
Database_C=0;
Database_D=0;

code_path = 'H:\thesis - eating fishes\Code\Descriptors\STIP';
    %helpcommand = strcat('"',code_path,'\stipdet"  "--help"' );
    %system(helpcommand);
    
addpath('H:\thesis - eating fishes\Code\HeadSearch');% for my_create_dir
if Database_A
    input_video_path='H:\thesis - eating fishes\DATABASES\Database-A\DB_Rot_and_Flip';
    output_path = 'H:\thesis - eating fishes\DATABASES\Database-A\Models_Rot_and_Flip\STIP_thresh=0_kparam=0.005_szf=20';
    output_dir_stip_video = 'H:\thesis - eating fishes\DATABASES\Database-A\DB_Rot_and_Flip/stip_videos';
end
if Database_B
    input_video_path='H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_Flip_corrected';
    output_path = 'H:\thesis - eating fishes\DATABASES\Database-B\Models_300_HI_RES_rot_flip_corrected\STIP_thresh=0_szf=20';
    output_dir_stip_video = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_Flip_corrected/stip_videos_orig';
end
if Database_C
    input_video_path='H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_Rot_Flip';
    output_path = 'H:\thesis - eating fishes\DATABASES\Database-C\Models_84_HI_RES_Rot_Flip\STIP_szf=20_brder=30';
    output_dir_stip_video = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_Rot_Flip/stip_videos_szf=10';
end
if Database_D
    input_video_path='H:\thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_Flip';
    output_path = 'H:\thesis - eating fishes\DATABASES\Database-D\Models_216_HI_RES_Rot_Flip\STIP_szf=20_thresh=0_margin=30';
    output_dir_stip_video = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_Flip/stip_videos';
end
if ~my_create_dir(output_path); return; end;
if ~my_create_dir(output_dir_stip_video); return; end;

%testcmd = ' "E:/thesis/trajectory subspace ver 44/stip-1.1-winlinux/bin/stipdet" -f "E:/thesis/trajectory subspace ver 44/stip-1.1-winlinux/data/walk-simple.avi" -o ./data/walk-simple-stip.txt';
%testcmd = ' "E:/thesis/trajectory subspace ver 44/stip-1.1-winlinux/bin/stipdet" -f "E:/thesis/ASLAN/DB/7-0001.avi" -o "E:/thesis/ASLAN/Run_40_train/stip/7-0001.txt"';

%system(testcmd);

%cmnd = ' "E:/thesis/trajectory subspace ver 44/stip-1.1-winlinux/bin/stipdet"  -f "E:/thesis/ASLAN/DB_2/7-0001.avi" -vis "no" -o "E:/thesis/ASLAN/Run_40_train/stip/STIP_7-0001.txt" ';
%system(cmnd);
if Database_A    n_vid = 450;    end
if Database_B    n_vid = 300;    end
if Database_C    n_vid = 84;    end
if Database_D    n_vid = 216;    end




for vid_i=1:n_vid
    vid_i
    video_name = sprintf('%s%.4d','fish_head-',vid_i);
    %video_name = strcat('7-0004');
    video_file = strcat(input_video_path,'/',video_name,'.avi');
    %video_file= 'E:/thesis/trajectory subspace ver 44/stip-1.1-winlinux/data/walk-simple.avi';
    %[ readerobj h w numFrames frate sep tmp_dir ext ] = my_mmreader( video_file,0 );
    filename = strcat(output_dir_stip_video,'/',video_name,'.avi');
    do_resize=0;
    if do_resize
        readerobj = VideoReader(video_file);
        numFrames = readerobj.NumberOfFrames;
        clear mov;

        % scale_factor = 240*320/(h*w); % can not do this as stip 
        %                                 exec demands size=240*320
        for i_fr = 1:numFrames
            frame_data = read(readerobj, i_fr);

            if Database_A    frame_data = imresize(frame_data, [120 160] );    end
            if Database_B    frame_data = imresize(frame_data, [240 320] );    end
            if Database_C    frame_data = imresize(frame_data, [240 320] );    end
            if Database_D    frame_data = imresize(frame_data, [240 320] );    end

            mov(i_fr).cdata = frame_data;
            mov(i_fr).colormap = [];
        end
        %implay(mov);
        % save movie


        

        movie2avi(mov, filename, 'compression', 'None');
 
    end
 
    %info = aviinfo(video_file);
    %video_file
    %{
    if  verLessThan('matlab', '7.14')
        %implay(full_file_name)
        readerobj = mmreader(video_file, 'tag', 'myreader1');
        h = get(readerobj, 'Height'); ;
        w = get(readerobj, 'Width'); 
        numFrames = get(readerobj, 'numberOfFrames');
        frate = get(readerobj, 'FrameRate');
        sep = 3; % num of seperations

    else

        readerobj = VideoReader(full_file_name);

        numFrames = readerobj.NumberOfFrames;
        h = readerobj.Height;
        w = readerobj.Width;
        frate = readerobj.FrameRate;
        sep = 3;

    end
    %}
    
    
    %helpcommand = strcat('"',code_path,'\stipdet"  "--help"' );
    %system(helpcommand);
    
    if exist(video_file ,'file');
        output_file = strcat(output_path,'/STIP_',video_name,'.txt');
        output_file_m = strcat(output_path,'/STIP_',video_name,'.mat');
        
        if Database_A
            mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                           filename,... 
                           '" -thresh 0 -kparam 0.005 -szf 20 -vis "no"',' -o "',...
                           output_file,'"' );
        end
        if Database_B
            mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                           filename,... 
                           '" -thresh 0 -szf 20 -vis "no"',' -o "',...
                           output_file,'"' );
        end
        if Database_C
            mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                           filename,... 
                           '" -border 30 -thresh 0 -szf 20 -vis "no"',' -o "',...
                           output_file,'"' );
        end
        if Database_D
            mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                           filename,... 
                           '" -border 30 -thresh 0 -szf 20 -vis "no"',' -o "',...
                           output_file,'"' );
        end
        %mycommand               
        system(mycommand);
%{
        fid = fopen(output_file);
        tline1 = fgetl(fid);
        tline2 = fgetl(fid);
        tline3 = fgetl(fid);
        
        i=0;
        clear hog
        clear hof
        clear hoghof
        hog = [];
        hof = [];
        hoghof = [];
        while ~feof(fid)
            i=i+1;
            % # point-type x y t sigma2 tau2 detector-confidence dscr-hog(72) dscr-hof(90)
            params = fscanf(fid, '%f', [7 1]);  
            t_hog = fscanf(fid, '%f', [72 1]);
            if size(t_hog,1) ~=72
                break;
            end
            hog(1:72,i) = t_hog;
            t_hof = fscanf(fid, '%f', [90 1]);
            if size(t_hof,1) ~=90
                break;
            end
            hof(1:90,i) = t_hof;
            hoghof(1:162,i)=[hog(1:72,i);hof(1:90,i);];
        end
        save(output_file_m,'hog','hof','hoghof');
        fclose('all');
%}
    end
end
%system('"D:\Eyal\OpenU\Computer Science - MSc\thesis\STIP\Laptev''s code\stip 1.1\\bin\stipdet"  "-f" "D:\Eyal\OpenU\Computer Science - MSc\thesis\STIP\Laptev''s code\stip 1.1\data\walk-complex.avi');
% -o ./data/walk-simple-stip.txt;

eee=999;

