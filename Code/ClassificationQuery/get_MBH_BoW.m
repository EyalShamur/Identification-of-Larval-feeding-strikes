function [hist, MBH_Bow_fn] = get_MBH_BoW(MBH_desc_dir, query_param)
% Output
    output_dir_norm = sprintf('%s\\NORM',MBH_desc_dir);
    output_dir_classes = sprintf('%s\\KMEANS',MBH_desc_dir);
    output_dir_Bow = sprintf('%s\\BoW',MBH_desc_dir);
    if ~my_create_dir(output_dir_norm); return; end; 
    if ~my_create_dir(output_dir_classes); return; end; 
    if ~my_create_dir(output_dir_Bow); return; end; 
    
%Input
    database=query_param.database;% = 'A';
    desc_folders=query_param.MBH_params.desc_folders;% = 'MBH_patch_size=32';
    model_type=query_param.model_type;% = 'Models_Rot_and_Flip';
    run_id=query_param.MBH_params.run_id;%=1029;
    i_tries=query_param.i_tries;%=4;
    fold_idx=query_param.MBH_params.fold_idx;% = 1;
    
    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,desc_folders);
    input_dir_norm = sprintf('%s\\RUN_ID_%d\\NORM',main_desc_dir,run_id);
    min_max_file = sprintf('%s\\min_max_fold_%.2d%s',input_dir_norm,fold_idx,'.mat');

% Load and Concat MBHx MBHy into *.mat file    
    [mbh, mbh_file] = concat_MBHxy_desc(MBH_desc_dir,1);

% Norm
    load(min_max_file,'max_all','min_all');
    load (mbh_file,'mbh');  
    mbh = mbh-min_all;
    desc_norm = uint8((mbh/(max_all-min_all))*255);
 
    fn_norm = sprintf('%s//norm_desc.mat',output_dir_norm);
    save(fn_norm,'desc_norm');
    
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


    num_of_clusters = 512;
    hist_volume = 500;
    hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
    MBH_Bow_fn = sprintf('%s//BoW.mat',output_dir_Bow);
    save (MBH_Bow_fn,'hist')  % classes_2
    fclose('all');
    
    




end