function [max_all, min_all] = find_min_max_STIP(stip_dir,clips)


max_all=-99999999;%0;
min_all=99999999;%-1;

%if ~my_create_dir(output_dir_norm_test_set); return; end;

n_clips = size(clips,1);
msg = ' Max-Min STIP ...\n';
fprintf(msg);
    for i_clip=1:n_clips
            hog = [];
            hof = [];
            hoghof=[];
        f1 = sprintf('%.4d',clips(i_clip));
        %msg = sprintf('***************  Max-Min STIP:  video  %s  ***************\n',...
        %                                  f1);
        %fprintf(msg);
        xy_dir = strcat(stip_dir,'\STIP_fish_head-',f1);
        %out_dir = strcat(stip_dir,'\STIP_7-',f1);
        %stip_file = strcat(out_dir ,'.mat');
        
        stip_file = strcat(stip_dir,'\DESCRIPTOR\STIP_7-',f1,'.mat');
        
        %---------------------------
        
        stip_txt_file = strcat(xy_dir ,'.txt');
        fid = fopen(stip_txt_file);
        tline1 = fgetl(fid);
        tline2 = fgetl(fid);
        tline3 = fgetl(fid);
        i=0;
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
        
        if (~isempty(hog)) && (~isempty(hof))
            local_max = max(max(hoghof)');
            local_min = min(min(hoghof)');
            if max_all<local_max
                max_all=local_max;
            end
            if min_all>local_min
                min_all=local_min;
            end
        else
            hog(1:72,1) = 0;
            hof(1:90,1) = 0;
            hoghof(1:162,1)=0;
 
        end
        save(stip_file,'hog','hof','hoghof');
            
        clear hog
        clear hof
        clear hoghof

        %-----------------------------

        %{  
        file_exists = exist(stip_file ,'file');
        if file_exists
            load (stip_file,'hoghof');
            local_max = max(max(hoghof)');
            local_min = min(min(hoghof)');
            if max_all<local_max
                max_all=local_max;
            end
            if min_all<local_min
                min_all=local_min;
            end            
        else
            
            fprintf('STIP file not exists\n');
        end
        %}
        fclose('all');
        
    end
    
    fclose('all');
    minmax_file = strcat(stip_dir ,'\STIP_min_max.mat');
    save(minmax_file, 'min_all', 'max_all');
       

end