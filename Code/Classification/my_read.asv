function [ frame_data ] = my_read( readerobj,i, tmp_dir, ext,convert_with_ffmpeg  )

    switch ext
        case '.avi' 
            if isunix()
                fn= sprintf('%s/output%06d.jpeg',tmp_dir,i);
                frame_data=imread(fn);
                %{
                mov = readerobj;
                frame_data =        mov(i).cdata;
                %}
            end
            
            if ispc()
                if ~convert_with_ffmpeg
                    frame_data = read(readerobj, i);
                else
                    fn= sprintf('%s/output%06d.jpeg',tmp_dir,i);
                    frame_data=imread(fn);
                end
            end
            

        case '.mpg'
            if isunix()
                fn= sprintf('%s/output%06d.jpeg',tmp_dir,i);
                frame_data=imread(fn);

            else
                if ispc()
                    frame_data = read(readerobj, i);            
 
                else % mac and others
                    error('current platform is not supported');
                end
            end
            
        case '.mp4'
            if isunix()
                fn= sprintf('%s/output%06d.jpeg',tmp_dir,i);
                frame_data=imread(fn);

            else
                if ispc()
                    if ~convert_with_ffmpeg
                        frame_data = read(readerobj, i);  
                    else
                        fn= sprintf('%s/output%06d.jpeg',tmp_dir,i);
                        frame_data=imread(fn);
                    end
 
                else % mac and others
                    error('current platform is not supported');
                end
            end
    end
                
                

end
