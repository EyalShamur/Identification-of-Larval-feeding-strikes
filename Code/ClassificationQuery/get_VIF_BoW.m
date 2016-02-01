function [ hist, VIF_Bow_fn] = get_VIF_BoW(VIF_desc_dir,query_param)


% Output
    output_dir_norm = sprintf('%s\\NORM',VIF_desc_dir);
    output_dir_classes = sprintf('%s\\KMEANS',VIF_desc_dir);
    output_dir_Bow = sprintf('%s\\BoW',VIF_desc_dir);
    if ~my_create_dir(output_dir_norm); return; end; 
    if ~my_create_dir(output_dir_classes); return; end; 
    if ~my_create_dir(output_dir_Bow); return; end; 
    
%Input
    database=query_param.database;% = 'A';
    desc_folders=query_param.VIF_params.desc_folders;% = 'MBH_patch_size=32';
    model_type=query_param.model_type;% = 'Models_Rot_and_Flip';
    run_id=query_param.VIF_params.run_id;
    i_tries=query_param.i_tries;
    fold_idx=query_param.VIF_params.fold_idx;
    
    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,desc_folders);
    input_dir_norm = sprintf('%s\\RUN_ID_%d\\NORM',main_desc_dir,run_id);
    min_max_file = sprintf('%s\\min_max_fold_%.2d%s',input_dir_norm,fold_idx,'.mat');
    
    
% Norm
    load(min_max_file,'max_all','min_all');
    fn = sprintf('%.4d',1);
    vif_file = strcat(VIF_desc_dir,'\VIF_7-',fn ,'.mat');
    load(vif_file,'VIF_descriptor');
    
    VIF_descriptor = VIF_descriptor-min_all;
    desc_norm = uint8((VIF_descriptor/(max_all-min_all))*255);
 
    prepare_kmeans_file_name = sprintf('%s/kmeans_data_norm_7-%s.mat',output_dir_norm,fn); 
    save(prepare_kmeans_file_name,'desc_norm');
    
    % K-Means   

    %if isempty(desc_norm)
    %    desc_norm = uint8(zeros(size(C,1),1));
    %    msg = sprintf('Clip num %d has empty descriptor',clip_num);
    %    disp(msg);
    %end
    
    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,desc_folders); 
    output_dir_kmeans_data = sprintf('%s\\RUN_ID_%d\\KMEANS_DATA',main_desc_dir,run_id);
    output_dir_kmeans__ = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_dir_kmeans_data,i_tries,fold_idx);
    vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans__);
    load (vl_ikmeans_file,'C','A');
    run('C:\Program Files\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')
    %run('C:\Program Files (x86)\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')  % add vlfeat lib          
    classes = vl_ikmeanspush(desc_norm,C);

    fn_classes = sprintf('%s//classes.mat',output_dir_classes);
    save (fn_classes,'classes')  % classes_1


    num_of_clusters = 128;
    hist_volume = 500;
    hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
    VIF_Bow_fn = sprintf('%s//BoW.mat',output_dir_Bow);
    save (VIF_Bow_fn,'hist')  % classes_2
    fclose('all');
    
end