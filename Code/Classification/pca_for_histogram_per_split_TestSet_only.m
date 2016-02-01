function pca_for_histogram_per_split_TestSet_only(descriptor_type,descriptor_folder,model_type,database,folds_type)

 

    

    

        
        
    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);


    input_dir_hist = sprintf('%s\\HISTOGRAM_1024',main_desc_dir);
    output_dir_hist_pca = sprintf('%s\\PCA_HIST_SQRT',main_desc_dir);
    
    clear fold_clips
    clear fold_tags
        fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
    load(fold_file); % get fold_clips,fold_tags 



    disp('pca...');
    
    [n_clips_per_fold, n_folds ]=size(fold_tags);

    for fold_idx=1:n_folds
        % input
        input_dir_hist_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',input_dir_hist,fold_idx);
        input_dir_hist_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',input_dir_hist,fold_idx);
            
        % output
        output_dir_hist_pca_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',output_dir_hist_pca,fold_idx);
        if ~my_create_dir(output_dir_hist_pca_training_set); return; end;
        output_dir_hist_pca_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',output_dir_hist_pca,fold_idx);
        if ~my_create_dir(output_dir_hist_pca_test_set); return; end; 


        clear training_clips;
   

        test_clips = squeeze(fold_clips(:,fold_idx));
        
   
        clear all_sqrt_hists
        all_sqrt_hists=[];
        nGoods=50;
        

                    
 
          
          n_test_clips = size(test_clips,1);
          princomp_file = sprintf('%s/princomp_coeff.mat',output_dir_hist_pca_training_set); 
          load (princomp_file,'COEFF','SCORE','latent');
          for vc_idx=1: n_test_clips
                clip_num = test_clips(vc_idx);
                fn = sprintf('%.4d',clip_num);

                hist_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_test_set,fn);
                
                load (hist_file,'hist'); 

                hist_sqrt_pca=COEFF(1:nGoods,:)*(single(hist'));
                clear hist;
                hist = hist_sqrt_pca';  % rename only
                hist_pca_file = sprintf('%s/hist_7-%s.mat',output_dir_hist_pca_test_set,fn); 
                save (hist_pca_file,'hist')  % classes_2

          end
    end


end

