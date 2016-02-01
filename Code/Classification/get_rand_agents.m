function [presentors] = get_rand_agents(d_len, n_presentors, descriptor_type, training_clips,output_dir_norm_training_set )
    desc_size = d_len;
    switch descriptor_type
    case 'MBH'
        desc_size = d_len*2;%160*2;%96*2;
    end 

start_time = tic;

%presentors = zeros(desc_size,n_presentors);
    
    if strcmp(descriptor_type,'VIF') || strcmp(descriptor_type,'STIP')
        pr_idx=0;
        for clip_idx =1: size(training_clips,1)
            clip_num=training_clips(clip_idx,1);
            fn = sprintf('%.4d',clip_num);
            file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
            load(file_name,'desc_norm');
            fclose('all');

            for desc_idx=1:size(desc_norm,2)
                pr_idx=pr_idx+1;
                presentors(:,pr_idx)=desc_norm(:,desc_idx); 
            end
            clear desc_norm
        end
        
    else

    presentors = uint8(zeros(desc_size,n_presentors));


    %kmeans_vc_file_name = sprintf('%s/kmeans_valid_clips.mat',output_dir_norm_training_set); 
    %load(kmeans_vc_file_name,'valid_clips');

    msg = sprintf(' Build %d presentors...',n_presentors);
    fprintf(msg);
    
    
    n_agents_per_clip=floor(n_presentors/size(training_clips,1));
    pr_idx=0;
    for clip_idx = 1: size(training_clips,1)
        %pr_idx

        clip_num=training_clips(clip_idx,1);
        fn = sprintf('%.4d',clip_num);
        file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
        load(file_name,'desc_norm');
        if isempty(desc_norm)
            sssss=0;
            desc_norm = zeros(desc_size);
            pr_idx=pr_idx+1;
            presentors(:,pr_idx)=desc_norm(:,1);
            fclose('all');
            continue;
        end
        if strcmp(descriptor_type,'MIP')
            desc_norm=uint8(desc_norm');
        end
        
        for agent_per_clip_idx = 1:n_agents_per_clip
            r_sbsp=int32(rand(1,1)*size(desc_norm,2));
            if r_sbsp == 0 
                r_sbsp=int32(1); 
            end    
            pr_idx=pr_idx+1;
            presentors(:,pr_idx)=desc_norm(:,r_sbsp);   

        end
        fclose('all');
        clear desc_norm
    end
        
      
    for pr_idx_add = pr_idx+1: n_presentors
        %pr_idx
        r_clip=int32(rand(1,1)*size(training_clips,1));
        if r_clip == 0 
            r_clip=int32(1); 
        end
        clip_num=training_clips(r_clip,1);
        fn = sprintf('%.4d',clip_num);
        file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
        load(file_name,'desc_norm');
        if isempty(desc_norm)
            sssss=0;
            desc_norm = zeros(desc_size);
        end
        if strcmp(descriptor_type,'MIP')
            desc_norm=uint8(desc_norm');
        end
        r_sbsp=int32(rand(1,1)*size(desc_norm,2));
        if r_sbsp == 0 
            r_sbsp=int32(1); 
        end    
        fclose('all');
        presentors(:,pr_idx_add)=desc_norm(:,r_sbsp);           
        clear desc_norm
    end

    end
    
    duration = toc(start_time);
    fprintf(sprintf(' Time: %d  min, %d  sec\n',floor(duration/60), floor(mod(duration,60))));              
end
