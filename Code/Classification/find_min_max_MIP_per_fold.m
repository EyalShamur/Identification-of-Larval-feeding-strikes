function [max_all, min_all] = find_min_max_MIP_per_fold(mip_dir,clips)


max_all=-999999;%0;
min_all=99999;%-1;
n_clips = size(clips,1);
msg = sprintf(' Max-Min MIP...\n');
fprintf(msg);
    for i_clip=1:n_clips

        f1 = sprintf('%.4d',i_clip);
        %msg = sprintf('***************  Max-Min MIP:  video  %s  ***************\n',...
        %                                  f1);
        %fprintf(msg);
        xy_dir = strcat(mip_dir,'\MIP_',f1);
        mip_file = strcat(xy_dir ,'.mat');
        %---------------------------
        
        load(mip_file,'F');
        
        if (~isempty(F)) && (~isempty(F))
            ddd = (max(F));
            local_max = max(max(F)');
            local_min = min(min(F)');
            if issparse(local_min)
                l_min=0;
            else
                l_min=local_min;
            end
            if max_all<local_max
                max_all=local_max;
            end
            if min_all>l_min
                min_all=l_min;
            end
        end


        
        fclose('all');
        
    end
    
    fclose('all');
    %minmax_file = strcat(mip_dir ,'\MIP_min_max.mat');
    %save(minmax_file, 'min_all', 'max_all');
       

end