function concatenate_all_directions(run_id,i_tries, descriptor_type,descriptor_folder     ,model_type,database,folds_type)
         %concatenate_all_directions(run_id,i_tries, descriptor_type,descriptor_folder_root,model_type,database,folds_type);

clear fold_clips
    clear fold_tags
    fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
    load(fold_file); % get fold_clips,fold_tags 
    
    

    
    
    [n_clips_per_fold, n_folds ]=size(fold_tags);
    
    
    
	for fold_idx=1:n_folds   

        
        
        clear training_clips;
        training_clips = [];
        for train_idx=1:n_folds
            if train_idx ~= fold_idx
                training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
            end
        end
        test_clips = squeeze(fold_clips(:,fold_idx));
        
        n_training_clips = size(training_clips,1);
        n_test_clips = size(test_clips,1);
        
        for vc_idx=1: n_training_clips
            clip_num = training_clips(vc_idx);
            fn = sprintf('%.4d',clip_num);

            clear hist_all;
            hist_all=[];
            for direction_idx=0:7
                d_folder = sprintf('%s\\Direction_%.1d',descriptor_folder,direction_idx);
                main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,d_folder);
                input_dir_hist_pca = sprintf('%s\\run_id_%d\\PCA_HIST_SQRT\\test_num_%d',main_desc_dir,run_id,i_tries);
                input_dir_hist_pca_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',input_dir_hist_pca,fold_idx);              
                hist_pca_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_pca_training_set,fn); 
                load (hist_pca_file,'hist')  % classes_2 
                hist_all = [hist_all  hist];
            end
            
            output_main_desc_dir = sprintf...
                ('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);
            output_main_desc_dir_training_set = sprintf...
                ('%s\\run_id_%d\\PCA_HIST_SQRT_ALL\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_main_desc_dir,run_id,i_tries,fold_idx);
            if ~my_create_dir(output_main_desc_dir_training_set); return; end; 
            output_hist_pca_file = sprintf('%s/hist_7-%s.mat',output_main_desc_dir_training_set,fn);
            hist=hist_all; % rename only
            save (output_hist_pca_file,'hist')  % classes_2 

        end
        

        for vc_idx=1: n_test_clips
            clip_num = test_clips(vc_idx);
            fn = sprintf('%.4d',clip_num);
            clear hist_all;
            hist_all=[];
            for direction_idx=0:7
                d_folder = sprintf('%s\\Direction_%.1d',descriptor_folder,direction_idx);
                main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,d_folder);
                input_dir_hist_pca = sprintf('%s\\run_id_%d\\PCA_HIST_SQRT\\test_num_%d',main_desc_dir,run_id,i_tries);
                input_dir_hist_pca_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',input_dir_hist_pca,fold_idx);                
                hist_pca_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_pca_test_set,fn); 
                load (hist_pca_file,'hist')  % classes_2 
                hist_all = [hist_all  hist];
            end
        
            output_main_desc_dir = sprintf...
                ('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);
            output_main_desc_dir_test_set = sprintf...
                ('%s\\run_id_%d\\PCA_HIST_SQRT_ALL\\test_num_%d\\FOLD_%.2d_TEST_SET',output_main_desc_dir,run_id,i_tries,fold_idx);
            if ~my_create_dir(output_main_desc_dir_test_set); return; end; 
            output_hist_pca_file = sprintf('%s/hist_7-%s.mat',output_main_desc_dir_test_set,fn); 
            hist=hist_all; % rename only
            save (output_hist_pca_file,'hist')  % classes_2  
       end
	end


end