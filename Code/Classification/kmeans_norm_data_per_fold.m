function  kmeans_norm_data_per_fold(desc_type,input_dir,output_dir,max_val, min_val, training_clips)


    idx=0;
    
    if (max_val-min_val)==0
        fprintf('ERROR: (max_val-min_val) = 0 in file kmeans_norm_data_per_fold.m');
        return;
    end
    n_clips = size(training_clips,1);
    msg = sprintf('  Norm %s  ...\n',desc_type);
    fprintf(msg);
    
    for i_clip=1:n_clips
        fn = sprintf('%.4d',training_clips(i_clip));
        %msg = sprintf('***************  Norm %s:  video  %s  ***************\n',...
        %              desc_type,fn);
        %fprintf(msg);
        
        
        file_name = sprintf('%s/%s_7-%s.mat',input_dir,desc_type,fn);
        
         if (strcmp(desc_type,'MIP'))
             clear file_name;
            file_name = sprintf('%s/%s_%s.mat',input_dir,desc_type,fn);
         end
        
        file_exists = exist(file_name ,'file');
        if ~file_exists
                        
            fprintf('Clip file not exists\n');
            desc_norm = zeros(162,1);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
            continue;
        end
        idx=idx+1;
        %valid_clips(idx) = i_clip;
        if (strcmp(desc_type,'STIP'))
            %STIP
            load (file_name,'hoghof');  %'subspace_all_frames' first file
            hoghof = hoghof-min_val;
            desc_norm = uint8((hoghof/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        end
        if (strcmp(desc_type,'GIST'))
            %GIST
            load (file_name,'media_gist');  %'subspace_all_frames' first file
            media_gist = media_gist-min_val;
            desc_norm = uint8((media_gist/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        end
        if (strcmp(desc_type,'TRAJ_SBSP'))
            % TRAJ_SBSP
            load (file_name,'traj_sbsp');  %'subspace_all_frames' first file
            traj_sbsp = traj_sbsp-min_val;
            desc_norm = uint8((traj_sbsp/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        end
        if (strcmp(desc_type,'MBH'))
            %MBH
            load (file_name,'mbh');  %'subspace_all_frames' first file
            mbh = mbh-min_val;
            desc_norm = uint8((mbh/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        end
        if (strcmp(desc_type,'MIP'))
            %MIP
            load (file_name,'F');  %'subspace_all_frames' first file
            F = F-min_val;
            desc_norm = uint8((F/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        end
        if (strcmp(desc_type,'VIF'))
            load(file_name,'VIF_descriptor');
            VIF_descriptor = VIF_descriptor-min_val;
            desc_norm = uint8((VIF_descriptor/(max_val-min_val))*255);
            %fn = sprintf('%.4d',i_clip);
            prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir,fn); 
            save(prepare_kmeans_file_name,'desc_norm');
        
        
        fclose('all');  
   end



        %kmeans_vc_file_name = sprintf('%s/kmeans_valid_clips.mat',output_dir); 
        %save(kmeans_vc_file_name,'valid_clips');

end

