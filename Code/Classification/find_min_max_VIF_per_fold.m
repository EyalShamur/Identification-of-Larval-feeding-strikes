function [max_all, min_all] = find_min_max_VIF_per_fold(vif_dir,clips)


max_all=-999999;%0;
min_all=99999;%-1;
n_clips = size(clips,1);

    for i_clip=1:n_clips

        f1 = sprintf('%.4d',i_clip);
        %msg = sprintf('***************  Max-Min VIF:  video  %s  ***************\n',...
        %                                  f1);
        %fprintf(msg);
        vif_file = strcat(vif_dir,'\VIF_7-',f1 ,'.mat');
        load(vif_file,'VIF_descriptor');
        
        if ~isempty(VIF_descriptor)
            local_max = max(max(VIF_descriptor)');
            local_min = min(min(VIF_descriptor)');
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