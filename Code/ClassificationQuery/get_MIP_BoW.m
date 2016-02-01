function [ hist, output_hist_pca_file] = get_MIP_BoW(MIP_desc_dir,query_param)


    clear hist_all;
    hist_all=[];
    output_dir_pca_hist = sprintf('%s\\PCA_HIST_SQRT_ALL',MIP_desc_dir);
    if ~my_create_dir(output_dir_pca_hist); return; end
    
    for direction_idx = 0:7%7
        descriptor_folder_drection = sprintf('%s\\Direction_%.1d',MIP_desc_dir,direction_idx);
     % Output
        output_dir_norm = sprintf('%s\\NORM',descriptor_folder_drection);
        output_dir_classes = sprintf('%s\\KMEANS',descriptor_folder_drection);
        output_dir_Bow = sprintf('%s\\BoW',descriptor_folder_drection);
        if ~my_create_dir(output_dir_norm); return; end; 
        if ~my_create_dir(output_dir_classes); return; end; 
        if ~my_create_dir(output_dir_Bow); return; end; 
    %Input
        database=query_param.database;% = 'A';
        desc_folders=query_param.MIP_params.desc_folders;% = 'MBH_patch_size=32';
        model_type=query_param.model_type;% = 'Models_Rot_and_Flip';
        run_id=query_param.MIP_params.run_id;%=1029;
        i_tries=query_param.i_tries;%=4;
        fold_idx=query_param.MIP_params.fold_idx;% = 1;

        main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\Direction_%.1d',database,model_type,desc_folders,uint32(direction_idx));
        input_dir_norm = sprintf('%s\\RUN_ID_%d\\NORM',main_desc_dir,query_param.MIP_params.run_id);
        min_max_file = sprintf('%s\\min_max_fold_%.2d%s',input_dir_norm,fold_idx,'.mat');


        load(min_max_file,'max_all','min_all');
        file_name = sprintf('%s\\Direction_%.1d\\fish_head-0001.mat',MIP_desc_dir,uint32(direction_idx));
        load (file_name,'F');  %'subspace_all_frames' first file
        F = F-min_all;
        desc_norm = uint8((F/(max_all-min_all))*255);
        fn = sprintf('%.4d',1);
        prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir_norm,fn); 
        save(prepare_kmeans_file_name,'desc_norm');
    % K-Means   

        %if isempty(desc_norm)
        %    desc_norm = uint8(zeros(size(C,1),1));
        %    msg = sprintf('Clip num %d has empty descriptor',clip_num);
        %    disp(msg);
        %end

        %main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,desc_folders); 
        output_dir_kmeans_data = sprintf('%s\\RUN_ID_%d\\KMEANS_DATA',main_desc_dir,run_id);
        output_dir_kmeans__ = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_dir_kmeans_data,i_tries,fold_idx);
        vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans__);
        load (vl_ikmeans_file,'C','A');
        run('C:\Program Files\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')
        %run('C:\Program Files (x86)\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')  % add vlfeat lib          
        classes = vl_ikmeanspush(desc_norm',C);

        fn_classes = sprintf('%s//classes.mat',output_dir_classes);
        save (fn_classes,'classes')  % classes_1

    % Raw BoW
        num_of_clusters = 512;
        hist_volume = 500;
        hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
        MIP_Bow_fn = sprintf('%s//BoW.mat',output_dir_Bow);
        save (MIP_Bow_fn,'hist')  % classes_2
        
    
    
    
    
    % PCA 
    %  H:\Thesis - eating fishes\DATABASES\Database-A\Models_Rot_and_Flip\MIP_orig\direction_0
    %\RUN_ID_1119\PCA_HIST_SQRT\test_num_1\FOLD_01_TRAINING_SET
        input_dir_pca = sprintf('%s\\RUN_ID_%d\\PCA_HIST_SQRT',main_desc_dir,run_id);
        input_dir_hist_pca_training_set = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',input_dir_pca,i_tries,fold_idx);
        princomp_file = sprintf('%s/princomp_coeff.mat',input_dir_hist_pca_training_set); 
        load (princomp_file,'COEFF','SCORE','latent');
        nGoods = query_param.pca_subspase;
        hist_sqrt_pca=COEFF(1:nGoods,:)*(single(sqrt(hist)'));
        clear hist;
        hist = hist_sqrt_pca';  % rename only
        %hist_pca_file = sprintf('%s/hist_7-%s.mat',output_dir_hist_pca_training_set,fn); 
        %save (hist_pca_file,'hist');
                
               
                
    

    % Concatenate
        hist_all = [hist_all  hist];
        
         
    end
            
 
    output_hist_pca_file = sprintf('%s/hist_7-%s.mat',output_dir_pca_hist,fn);
    hist=hist_all; % rename only
    save (output_hist_pca_file,'hist')  % classes_2 
    fclose('all'); 

 


end