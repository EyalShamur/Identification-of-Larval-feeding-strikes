function [max_all, min_all] = find_min_max_MBH_per_fold(d_len, mbh_dir,clips)

desc_len = d_len;  % 96
max_all=-999999;%0;
min_all=99999;%-1;
n_clips = size(clips,1);
msg = ' Max-Min MBH ...\n';
fprintf(msg);
    for i_clip=1:n_clips
            %info = [];
            %dense_traj = [];
            %hog=[];
            %hof=[];
            mbhx=[];
            mbhy=[];
            mbh=[];
        f1 = sprintf('%.4d',clips(i_clip));
        %msg = sprintf('***************  Max-Min MBH:  video  %s  ***************\n',...
        %                                  f1);
        %fprintf(msg);
        x_dir = strcat(mbh_dir,'\MBHx\MBHx_7-',f1);
        y_dir = strcat(mbh_dir,'\MBHy\MBHy_7-',f1);
        x_dir_output = strcat(mbh_dir,'\MBHx\MBHx_DESCRIPTOR\MBHx_7-',f1);
        y_dir_output = strcat(mbh_dir,'\MBHy\MBHy_DESCRIPTOR\MBHy_7-',f1);
        mbhx_file = strcat(x_dir_output ,'.mat');
        mbhy_file = strcat(y_dir_output ,'.mat');
        mbh_file = strcat(mbh_dir,'\DESCRIPTOR\MBH_7-',f1,'.mat');
        %---------------------------
        
        mbhx_txt_file = strcat(x_dir ,'.txt');
        mbhy_txt_file = strcat(y_dir ,'.txt');
        fidx = fopen(mbhx_txt_file);
        fidy = fopen(mbhy_txt_file);

        i=0;
        while ~feof(fidx) && ~feof(fidy)
            i=i+1;
            
            % # point-type x y t sigma2 tau2 detector-confidence dscr-hog(72) dscr-hof(90)
            m_x = fscanf(fidx, '%f', [desc_len 1]);  
            if size(m_x,1) ~=desc_len
                break;
            end
            m_y = fscanf(fidy, '%f', [desc_len 1]);
            if size(m_y,1) ~=desc_len
                break;
            end
            mbhx(1:desc_len,i) = m_x;
            mbhy(1:desc_len,i) = m_y;
        end
        
        if (~isempty(mbhx)) && (~isempty(mbhy))
            mbh=[mbhx; mbhy;];
        end
        if ~isempty(mbh)
            local_max = max(max(mbh)');
            local_min = min(min(mbh)');
            if max_all<local_max
                max_all=local_max;
            end
            if min_all>local_min
                min_all=local_min;
            end
        else
            mbh(1:2*desc_len,1) = 0;

        end
        save(mbhx_file,'mbhx');
        save(mbhy_file,'mbhy');
        save(mbh_file,'mbh');
        clear mbhx
        clear mbhy
        clear mbh

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
    %minmax_file = strcat(mbh_dir ,'\MBH_min_max.mat');
    %save(minmax_file, 'min_all', 'max_all');
       

end