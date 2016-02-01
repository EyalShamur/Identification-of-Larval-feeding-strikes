function [ readerobj h w numFrames frate sep tmp_dir ext ] = my_mmreader( full_file_name,convert_with_ffmpeg )


    [path, name, ext] = fileparts(full_file_name);
    tmp_dir ='';
    switch ext
        case '.avi' 
            if isunix()
                tmp_dir = strcat(path,'/temp');  
                    remove_command = strcat('rm -r ''',tmp_dir,'''');
                    system(remove_command);
                mkdir_command = strcat('mkdir ''',tmp_dir,'''');
                system(mkdir_command);
                ffmpeg_command = strcat('ffmpeg -i ''',full_file_name,''' -f image2 ''', tmp_dir,'/output%06d.jpeg''');
                ffmpeg_command = strcat(ffmpeg_command,' &>/dev/null'); % added to avoid printing info to the screen
                system(ffmpeg_command);
                numFrames=1;
                outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                [h w sep] = size(imread(outputfilename));
                while exist(outputfilename,'file') 
                    numFrames=numFrames+1;
                    outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                end
                numFrames=numFrames-1;
                frate = 25;
                readerobj = 0;  % dummy
                
                %{
                
              
                info = aviinfo(full_file_name);
                frate=info.FramesPerSecond;                   % frame rate
                h = info.Height;
                w = info.Width;
                mov = aviread(full_file_name);
                numFrames = length(mov); 
                readerobj = mov;
                sep=3; % hard coded for the moment
                  %}
                
            end
            
            if ispc()
                if ~convert_with_ffmpeg
                    
                    if  verLessThan('matlab', '7.14')
                        %implay(full_file_name)
                        readerobj = mmreader(full_file_name, 'tag', 'myreader1');
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
                    

               
                

                else
                    tmp_dir = strcat(path,'/temp');
 
                    rmdir(tmp_dir,'s');

                    mkdir_command = sprintf('mkdir "%s" ',tmp_dir);
                    system(mkdir_command);
                    ffmpeg_command = strcat('ffmpeg -i "',full_file_name,'" -f image2 "', tmp_dir,'/output%06d.jpeg"');
                    system(ffmpeg_command);
                    numFrames=1;
                    outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                    [h w sep] = size(imread(outputfilename));
                    while exist(outputfilename,'file') 
                        numFrames=numFrames+1;
                        outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                    end
                    numFrames=numFrames-1;
                    frate = 25;
                    readerobj = 0;  % dummy
                end
            end
            
        case '.mpg'
            numFrames=0;
            tmp_dir ='';
            if isunix(); % linux 
                %ffmpeg_command = strcat('ffmpeg -i ''',full_file_name,''' -vframes 1 ''', path,'/outputone.jpeg''');
                tmp_dir = strcat(path,'/temp');
 
                    remove_command = strcat('rm -r ''',tmp_dir,'''');
                    system(remove_command);

                mkdir_command = strcat('mkdir ''',tmp_dir,'''');
                system(mkdir_command);
                ffmpeg_command = strcat('ffmpeg -i ''',full_file_name,''' -f image2 ''', tmp_dir,'/output%06d.jpeg''');
                system(ffmpeg_command);
                numFrames=1;
                outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                [h w sep] = size(imread(outputfilename));
                while exist(outputfilename,'file') 
                    numFrames=numFrames+1;
                    outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                end
                numFrames=numFrames-1;
                frate = 25;
                readerobj = 0;  % dummy
            else 
                if ispc() % windows
                    readerobj = mmreader(full_file_name, 'tag', 'myreader1');
                    numFrames = get(readerobj, 'numberOfFrames');
                    frate = get(readerobj, 'FrameRate');
                    h = get(readerobj, 'Height'); ;
                    w = get(readerobj, 'Width');
                    sep=3; % hard coded for the moment
                else % mac and others
                    error('current platform is not supported');
                end
            end
        case '.mp4'
            numFrames=0;
            tmp_dir ='';
            if isunix(); % linux 
                %ffmpeg_command = strcat('ffmpeg -i ''',full_file_name,''' -vframes 1 ''', path,'/outputone.jpeg''');
                tmp_dir = strcat(path,'/temp');
                 
                remove_command = strcat('rm -r ''',tmp_dir,'''');
                system(remove_command);
 
                mkdir_command = strcat('mkdir ''',tmp_dir,'''');   % &>/dev/null
                system(mkdir_command);
                ffmpeg_command = strcat('ffmpeg  -i ''',full_file_name,''' -f image2 ''', tmp_dir,'/output%06d.jpeg''');
                ffmpeg_command = strcat(ffmpeg_command,' &>/dev/null');
                system(ffmpeg_command);
                numFrames=1;
                outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                [h w sep] = size(imread(outputfilename));
                while exist(outputfilename,'file') 
                    numFrames=numFrames+1;
                    outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                end
                numFrames=numFrames-1;
                frate = 25;
                readerobj = 0;  % dummy
            else 
                if ispc() % windows
                    if ~convert_with_ffmpeg
                        readerobj = mmreader(full_file_name, 'tag', 'myreader1');
                        numFrames = get(readerobj, 'numberOfFrames');
                        frate = get(readerobj, 'FrameRate');
                        h = get(readerobj, 'Height'); 
                        w = get(readerobj, 'Width');
                        sep=3; % hard coded for the moment
                    
                    else
                        tmp_dir = strcat(path,'/temp');
 
                        rmdir(tmp_dir,'s');

                        mkdir_command = sprintf('mkdir "%s" ',tmp_dir);
                        system(mkdir_command);
                        ffmpeg_command = strcat('ffmpeg -i "',full_file_name,'" -f image2 "', tmp_dir,'/output%06d.jpeg"');
                        system(ffmpeg_command);
                        numFrames=1;
                        outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                        [h w sep] = size(imread(outputfilename));
                        while exist(outputfilename,'file') 
                            numFrames=numFrames+1;
                            outputfilename= sprintf('%s/output%06d.jpeg',tmp_dir,numFrames);
                        end
                        numFrames=numFrames-1;
                        frate = 25;
                        readerobj = 0;  % dummy
                    end
                
                
                else % mac and others
                    error('current platform is not supported');
                end
            end

    end
    
  




end