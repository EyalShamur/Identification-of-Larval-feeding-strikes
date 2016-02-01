function pca_for_histogram_per_split(nGoods, run_id,i_tries,descriptor_type,descriptor_folder,model_type,database,folds_type)

 

    

    %nGoods = 50;%100;  %50

        
        
    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);


    input_dir_hist = sprintf('%s\\run_id_%d\\HISTOGRAM\\test_num_%d',main_desc_dir,run_id,i_tries);
    output_dir_hist_pca = sprintf('%s\\run_id_%d\\PCA_HIST_SQRT\\test_num_%d',main_desc_dir,run_id,i_tries);
    
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
        training_clips = [];
        for train_idx=1:n_folds
            if train_idx ~= fold_idx
                training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
            end
        end
        test_clips = squeeze(fold_clips(:,fold_idx));
        
        n_training_clips = size(training_clips,1);
        clear all_sqrt_hists
        all_sqrt_hists=[];
        for vc_idx=1: n_training_clips
            clip_num = training_clips(vc_idx);
            fn = sprintf('%.4d',clip_num);

            hist_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_training_set,fn);
         
            load (hist_file,'hist')  % classes_2
            all_sqrt_hists = [all_sqrt_hists sqrt(hist)' ];
            %all_sqrt_hists = [all_sqrt_hists (hist)' ];
        end
addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m

                           % Rows of X correspond to observations, columns to variables
                    [COEFF,SCORE,latent]=princomp(single(all_sqrt_hists'));   % X size = 10x128    % zscore
                    % latent is  a vector containing the eigenvalues of the covariance
                    % matrix of X.
                    % COEFF is a p-by-p matrix, each column containing coefficients
                    % for one principal component. The columns are in order of decreasing component variance
                    princomp_file = sprintf('%s/princomp_coeff.mat',output_dir_hist_pca_training_set); 
                    save (princomp_file,'COEFF','SCORE','latent');
                
                    
                    
          for vc_idx=1: n_training_clips
                clip_num = training_clips(vc_idx);
                fn = sprintf('%.4d',clip_num);

                hist_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_training_set,fn);
                
                load (hist_file,'hist'); 

                hist_sqrt_pca=COEFF(1:nGoods,:)*(single(sqrt(hist)'));
                %hist_sqrt_pca=COEFF(1:nGoods,:)*(single((hist)'));
                clear hist;
                hist = hist_sqrt_pca';  % rename only
                hist_pca_file = sprintf('%s/hist_7-%s.mat',output_dir_hist_pca_training_set,fn); 
                save (hist_pca_file,'hist');  

          end  
          
          n_test_clips = size(test_clips,1);
          princomp_file = sprintf('%s/princomp_coeff.mat',output_dir_hist_pca_training_set); 
          load (princomp_file,'COEFF','SCORE','latent');
          for vc_idx=1: n_test_clips
                clip_num = test_clips(vc_idx);
                fn = sprintf('%.4d',clip_num);

                hist_file = sprintf('%s/hist_7-%s.mat',input_dir_hist_test_set,fn);
                
                load (hist_file,'hist'); 
                
                
                hist_sqrt_pca=COEFF(1:nGoods,:)*(single(sqrt(hist)'));
                %hist_sqrt_pca=COEFF(1:nGoods,:)*(single((hist)'));
                nonnn = isnan(hist_sqrt_pca);
                idx_none=find(nonnn==1);
                if ~isempty(idx_none)
                    hist_sqrt_pca = zeros(nGoods,1);
                end
                clear hist;
                hist = hist_sqrt_pca';  % rename only
                hist_pca_file = sprintf('%s/hist_7-%s.mat',output_dir_hist_pca_test_set,fn); 
                save (hist_pca_file,'hist')  % classes_2

          end
    end


end

