params.MIP_params.frame_gap = 2;% frames interval between Current frame and Prev frame
params.MIP_params.movment_int = 1;% frames interval for start and end proccesing
params.MIP_params.resize_image = 1;%enable image resizing during MIP calc
params.MIP_params.resize_image_value = 0;%Resize image if resize enabled
params.MIP_params.N = 16;%Patches size N
params.MIP_params.M = 16;%Patches size M
params.MIP_params.MIP_norm = 0;
params.MIP_params.T_GL = 12;%Movement threshold in Gray levels.
params.MIP_params.T = 9*(params.MIP_params.T_GL^2);%Movement threshold in ssd values.
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

%%  Locations:
% -----------------
params.features.location = '';
params.features.dir_name = '';%'Extracted_features';
params.features.overide = false;

%% Flow : general running params:
% -------------------------------------------
params.flow.parfor_en = false; % true for parallel run on windows

%% GUI Parameters:
% ------------------------
params.GUI.mov_suffix = {'.avi','.wmv'};
params.GUI.add_path = fullfile('..'); % assumes running from MIPCode/Code/GUI...
params.GUI.def_start_dir = fullfile('..','..','Data','InputDir');
params.GUI.def_out_dir = fullfile('..','..','Data','OutputDir');



database_info = ''; % will be filled later
test_dir = '';  % will be filled later
add_path = '';  % will be filled later
for i=2:2
i
    switch i

        case 0
            model_output_dir = 'MIP_orig';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 16;%Patches size N
            params.MIP_params.M = 16;%Patches size M
            params.MIP_params.T_GL = 12;%Movement threshold in Gray levels.
        case 1
            model_output_dir = 'MIP_frame_gap1';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 16;%Patches size N
            params.MIP_params.M = 16;%Patches size M
            params.MIP_params.T_GL = 12;%Movement threshold in Gray levels.
        case 2
            model_output_dir = 'MIP_N12_M12_gap1_T_GL8';
             fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 12;%Patches size N
            params.MIP_params.M = 12;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        case 3 
            model_output_dir = 'MIP_N32_M32_T_GL8';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 32;%Patches size N
            params.MIP_params.M = 32;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        case 4 
            model_output_dir = 'MIP_N12_M12_T_GL8';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 12;%Patches size N
            params.MIP_params.M = 12;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.

        case 5 
            model_output_dir = 'MIP_T_GL10';
             fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 16;%Patches size N
            params.MIP_params.M = 16;%Patches size M
            params.MIP_params.T_GL = 10;%Movement threshold in Gray levels.
        case 6 
            model_output_dir = 'MIP_T_GL8';
             fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 16;%Patches size N
            params.MIP_params.M = 16;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        case 7 
            model_output_dir = 'MIP_N24_M24_T_GL8';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 2;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 24;%Patches size N
            params.MIP_params.M = 24;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        case 8 
            model_output_dir = 'MIP_optimized N16';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 16;%Patches size N
            params.MIP_params.M = 16;%Patches size M
            params.MIP_params.T_GL = 10;%Movement threshold in Gray levels.
        case 9 
            model_output_dir = 'MIP_optimized N32';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 32;%Patches size N
            params.MIP_params.M = 32;%Patches size M
            params.MIP_params.T_GL = 10;%Movement threshold in Gray levels.     
        case 10
            model_output_dir = 'MIP_frame_gap=1_N=64';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 64;%Patches size N
            params.MIP_params.M = 64;%Patches size M
            params.MIP_params.T_GL = 12;%Movement threshold in Gray levels. 
        case 11
            model_output_dir = 'MIP_frame_gap=1_N=48_T_GL=6';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 48;%Patches size N
            params.MIP_params.M = 48;%Patches size M
            params.MIP_params.T_GL = 6;%Movement threshold in Gray levels.
        case 12
            model_output_dir = 'MIP_frame_gap=1_N=32_T_GL=8';
            fprintf('%s\n',model_output_dir);
            fprintf('=============================================\n');
            params.MIP_params.frame_gap = 1;
            params.MIP_params.movment_int = 1;
            params.MIP_params.N = 32;%Patches size N
            params.MIP_params.M = 32;%Patches size M
            params.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
    end
    params.MIP_params.T = 9*(params.MIP_params.T_GL^2);%Movement threshold in ssd values.
    
    
    features_dir = run_MIP_coding_on_files(test_dir,params,database_info,add_path,model_output_dir);
end


blabla=999;







