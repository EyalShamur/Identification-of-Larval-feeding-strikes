
addpath('H:\thesis - eating fishes\Code\Classification'); % for my_create_dir(...)
addpath('H:\thesis - eating fishes\Code\Descriptors\OpticalFlow\mex'); % opticalflow
%output_dir = 'H:\thesis - eating fishes\DATABASES\Database-B\Models_HI_RES_Rot_and_Flip_frame\VIF_orig\DESCRIPTOR';
%output_dir = 'H:\thesis - eating fishes\DATABASES\Database-C\Models_84_HI_RES_rot_flip\VIF_M=N=1_S=3_T=1.5_perCell\DESCRIPTOR';
output_dir = 'H:\thesis - eating fishes\DATABASES\Database-B\Models_300_HI_RES_rot_flip_corrected\VIF_M=N=3_S=17_T=1.0_H=21_per_cell\DESCRIPTOR';
if ~my_create_dir(output_dir); return; end;


%clip_dir = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_Rot_Flip';
clip_dir = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_Flip_corrected';

	VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
	VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
	VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
    VIF_params.T = 1.0;%1.0;         % Threshold
    VIF_params.H = 21; %21;        hist_size
	VIF_params.S  = 17;% =n_time_sections.  added by Eyal
    VIF_params.per_cell = 1;
    
    
for clip_dx = 1:300; %450 %162
    file_name = sprintf('/fish_head-%.4d.avi',clip_dx);
    disp(file_name);
    VIF_descriptor = VIF_create_feature_vec(VIF_params, clip_dir,file_name);
    
    % save descriptor
    f1 = sprintf('%.4d',clip_dx);
    vif_file = strcat(output_dir,'\VIF_7-',f1 ,'.mat');
    save(vif_file,'VIF_descriptor');
end
