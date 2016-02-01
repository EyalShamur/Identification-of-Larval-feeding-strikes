function [eating_class, decision_value] = MIP_query(query_param,head_clip_name)

    params.MIP_params.frame_gap = query_param.MIP_params.frame_gap;% 2;
    params.MIP_params.movment_int = query_param.MIP_params.movment_int;% 1;
    params.MIP_params.N = query_param.MIP_params.N;% 16;%Patches size N
    params.MIP_params.M = query_param.MIP_params.M;% 16;%Patches size M
    params.MIP_params.T_GL = query_param.MIP_params.T_GL;% 12;%Movement threshold in Gray levels.
    
    params.MIP_params.T = 9*(params.MIP_params.T_GL^2);%Movement threshold in ssd values.

    params.MIP_params.resize_image = 1;%enable image resizing during MIP calc
    params.MIP_params.resize_image_value = 0;%Resize image if resize enabled

    params.MIP_params.MIP_norm = 0;

    % Filter MIP histograms with too few pixels:
    params.MIP_params.limit_patch_min.en = true;%limit minimum number of pixels in each MIP histogram
    params.MIP_params.limit_patch_min.frac = 0.2;%min fraction of the patch size.
    % Align : Overcommong global motion.
    params.MIP_params.align.en = false;%en/dis MIP alignment.
    params.MIP_params.align.dbg_out = false;%Output Alined frames as movie.
    params.MIP_params.align.dbg_dir = ''; % dir for aligned frames
    params.MIP_params.align.precompute.en = true;%precompute wrapping and store.
    params.MIP_params.align.precompute.dir_name =  '';%add here a full file name of directory, empty=>in features dir
    params.MIP_params.align.precompute.overide = false;%Overide if exist
    params.MIP_params.align.model_type = 'affine';%'projective';%
    params.MIP_params.align.min_size = 30;%Pyramid min size
    params.MIP_params.align.iterations = 10;%Align itterations.
    params.MIP_params.align.dbg_align_flag = false;%Enable alignment debug plots.
    params.MIP_params.align.valid_margin = 5;%Valid pixels in frame margins.
    % Coding:
    params.MIP_params.MIP_code.code_shift = 0;%Current codded direction ,0-7 (this is alpha)
    params.MIP_params.MIP_code.batch_run_directions = [0:7];%Which direction should be codded in current run.
    % Debug:
    params.MIP_params.MIP_dbg_dumps = 0;  % 1
    params.MIP_params.MIP_dbg_dumps_imonly = 0;

    %  Locations:
    % -----------------
    params.features.location = '';
    params.features.dir_name = '';%'Extracted_features';
    params.features.overide = false;

    % Flow : general running params:
    % -------------------------------------------
    params.flow.parfor_en = false; % true for parallel run on windows

    % GUI Parameters:
    % ------------------------
    params.GUI.mov_suffix = {'.avi','.wmv'};
    params.GUI.add_path = fullfile('..'); % assumes running from MIPCode/Code/GUI...
    params.GUI.def_start_dir = fullfile('..','..','Data','InputDir');
    params.GUI.def_out_dir = fullfile('..','..','Data','OutputDir');



    %database_info = ''; % will be filled later
    %test_dir = '';  % will be filled later
    %add_path = '';  % will be filled later




    %model_output_dir = 'MIP_orig';
    

    
    

    addpath('H:\thesis - eating fishes\Code\Classification');  % for my_create_dir(...)
    addpath('H:\Thesis - eating fishes\Code\Descriptors\MIP\Code\Features');
    add_path  = 'H:\thesis - eating fishes\Code\Descriptors\MIP\Code\Features';
    %cur_mov_path = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_HI_RES_Rot_and_Flip_frame';
    %output_path = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-B\\Models_HI_RES_Rot_and_Flip_frame\\%s',model_dir);
    cur_mov_path = 'H:\\Thesis - eating fishes\\Classification_temp_data';
    output_path = 'H:\\Thesis - eating fishes\\Classification_temp_data\\MIP';
    rmdir(output_path,'s');
    if ~my_create_dir(output_path); return; end; 
    params_location = fullfile(output_path,'feature_params.mat');
    save(params_location,'params');
    
    [path, name,ext]=fileparts(head_clip_name);
    filename = strcat(name,ext);
    % fprintf(1,'%d, Excracting Features mov : %s\n',m,filename);
    outname = 'H:\\Thesis - eating fishes\\Classification_temp_data\\MIP\\fish_head-0001.mat';
    % Supress output by use evalc that sends output to output_buffer instead
    % of console
    
    output_buffer=evalc('save_MIP_features_directions_coding(cur_mov_path,filename,outname,params_location,add_path);');
    	



    % MIP BoW 
    MIP_desc_dir=output_path;
    [MIP_BoW, MIP_Bow_fn] = get_MIP_BoW(MIP_desc_dir,query_param);

    
    % SVM classifier
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab');
   
    
    [eating_class, decision_value] = query_svm(query_param, query_param.MIP_params  ,MIP_Bow_fn);
            


                    
                    
    %[eating_class, decision_value] = query_svm(query_param, MBH_Bow_fn);







end

