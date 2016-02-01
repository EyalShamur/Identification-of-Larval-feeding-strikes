


function [detection_results, query_param] = fish_classifier(head_clip_name, database )

%database='B';%'B'% 'A'


if strcmp(database,'A')
    query_param.database = 'A';

    query_param.folds_type = 'Database_A_no_avi2_6x40_folds'; % not used
    query_param.svm_kernel_type = ' -s 1 -t 2 '; % not used
    query_param.i_tries=1;  
    query_param.model_type = 'Models_Rot_and_Flip';
    
    query_param.MBH_params.run_id = 1123;%1123;
    query_param.MBH_params.run_id_for_svm = 1163;%1145;
    query_param.MIP_params.run_id = 1127;%1127;
    query_param.MIP_params.run_id_for_svm = 1146;%1146;
    query_param.VIF_params.run_id = 1122;%1135;
    query_param.VIF_params.run_id_for_svm = 1148;%1148;
    query_param.STIP_params.run_id = 1121;%1131;
    query_param.STIP_params.run_id_for_svm = 1147;%1147;

    
    query_param.MBH_params.desc_folders = 'MBH_patch_size=32';
    query_param.MBH_params.fold_idx = 2;
    
    query_param.MIP_params.desc_folders = 'MIP_orig';
    query_param.MIP_params.frame_gap = 2;
    query_param.MIP_params.movment_int = 1;
    query_param.MIP_params.N = 16;%Patches size N
    query_param.MIP_params.M = 16;%Patches size M
    query_param.MIP_params.T_GL = 12;%Movement threshold in Gray levels.
    query_param.MIP_params.fold_idx = 2;
    
    query_param.VIF_params.desc_folders = 'VIF_M=N=3_S=1_T=1.0_H=21';
    query_param.VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
	query_param.VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
	query_param.VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
    query_param.VIF_params.T = 1.0;%1.0;         % Threshold
    query_param.VIF_params.H = 21; %21;        hist_size
	query_param.VIF_params.S  = 1;% =n_time_sections.  added by Eyal
    query_param.VIF_params.per_cell = 0;
    query_param.VIF_params.fold_idx = 2;
    
    
    query_param.STIP_params.desc_folders = 'STIP_thresh=0_kparam=0.005_szf=20';
    query_param.STIP_params.fold_idx = 2;
    
    % STACKING params:  weighted=1159, Symetric=1149
    query_param.STACKING_params.STACKING_run_id = 1164;
    query_param.STACKING_params.stacking_fold_idx =2; % for stacking only
end

if strcmp(database,'B') 

    query_param.database = 'B';
    query_param.folds_type = 'Database_B_no_202_6x48_folds';
                            % 'Database_B_no_562-2_6x48_folds';
                            %'Database_B_no_202_6x48_folds'; 
                            %'Database_B_no_562-1_6x48_folds';
                          
    query_param.i_tries=1;  
    query_param.model_type = 'Models_300_HI_RES_rot_flip_corrected';
   
    
    if strcmp(query_param.folds_type,'Database_B_no_562-1_6x48_folds'); 
        % MBH params:
        query_param.MBH_params.run_id = uint32(2126);%symetric=2126;
        query_param.MBH_params.run_id_for_svm = uint32(2301);  % weighted=2301
        query_param.MBH_params.desc_folders = 'MBH_patch_size=64';
        query_param.MBH_params.fold_idx = uint32(5);
        if query_param.MBH_params.run_id == query_param.MBH_params.run_id_for_svm
            query_param.MBH_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MBH_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.12  -c 1 ';
        end



        % MIP params:
        query_param.MIP_params.run_id = 2246;%symetric=2246;
        query_param.MIP_params.run_id_for_svm = 2298;% weighted=2247
        query_param.MIP_params.desc_folders = 'MIP_N12_M12_gap1_T_GL8';
        query_param.MIP_params.frame_gap = 1;
        query_param.MIP_params.movment_int = 1;
        query_param.MIP_params.N = 12;%Patches size N
        query_param.MIP_params.M = 12;%Patches size M
        query_param.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        query_param.MIP_params.fold_idx = uint32(5);
        if query_param.MIP_params.run_id == query_param.MIP_params.run_id_for_svm
            query_param.MIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.07  -c 1 ';
        end



        % VIF params:
        query_param.VIF_params.run_id = 2263;%symetric=2263;
        query_param.VIF_params.run_id_for_svm = 2300;% symetric=2263;% weighted=2264;
        query_param.VIF_params.desc_folders = 'VIF_M=N=3_S=7_T=1.5_H=21';
                                              %'VIF_M=N=3_S=17_T=1.0_H=21_per_cell';
        query_param.VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
        query_param.VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
        query_param.VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
        query_param.VIF_params.T = 1.5;%1.0;         % Threshold
        query_param.VIF_params.H = 21; %21;        hist_size
        query_param.VIF_params.S  = 17;% =n_time_sections.  added by Eyal
        query_param.VIF_params.per_cell = 0;
        query_param.VIF_params.fold_idx = uint32(5);
        if query_param.VIF_params.run_id == query_param.VIF_params.run_id_for_svm
            query_param.VIF_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.VIF_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STIP params:
        query_param.STIP_params.run_id = 2257;% symetric= 2259;
        query_param.STIP_params.run_id_for_svm = 2299;% symetric= 2259;% weighted=2260;
        query_param.STIP_params.desc_folders = 'STIP_thresh=0_szf=10';
        query_param.STIP_params.fold_idx = uint32(5);
        if query_param.STIP_params.run_id == query_param.STIP_params.run_id_for_svm
            query_param.STIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.STIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STACKING params:
        % all_weighted=2266, partialy_weighted=2265, all_symetric=2271
        query_param.STACKING_params.STACKING_run_id = 2302;
        query_param.STACKING_params.stacking_fold_idx =uint32(5); % for stacking only
    end
    
    
    
    if strcmp(query_param.folds_type,'Database_B_no_562-2_6x48_folds');
        
        % MBH params:
        query_param.MBH_params.run_id = uint32(2207);%2219;%2126;%2112;
        query_param.MBH_params.run_id_for_svm = uint32(2282);  % symetric=2207 ;% weighted=2282;
        query_param.MBH_params.desc_folders = 'MBH_patch_size=64';
        query_param.MBH_params.fold_idx = uint32(1);
        if query_param.MBH_params.run_id == query_param.MBH_params.run_id_for_svm
            query_param.MBH_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MBH_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.12  -c 1 ';
        end



        % MIP params:
        query_param.MIP_params.run_id = 2248;%2111;
        query_param.MIP_params.run_id_for_svm = 2286;% symetric=2248 ;% weighted=2286;
        query_param.MIP_params.desc_folders = 'MIP_N12_M12_gap1_T_GL8';
        query_param.MIP_params.frame_gap = 1;
        query_param.MIP_params.movment_int = 1;
        query_param.MIP_params.N = 12;%Patches size N
        query_param.MIP_params.M = 12;%Patches size M
        query_param.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        query_param.MIP_params.fold_idx = uint32(6);
        if query_param.MIP_params.run_id == query_param.MIP_params.run_id_for_svm
            query_param.MIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.07  -c 1 ';
        end



        % VIF params:
        query_param.VIF_params.run_id = 2253;
        query_param.VIF_params.run_id_for_svm = 2290;% symetric=2253 ;% weighted=2290;
        query_param.VIF_params.desc_folders = 'VIF_M=N=3_S=7_T=1.5_H=21';
                                              %'VIF_M=N=3_S=17_T=1.0_H=21_per_cell';
        query_param.VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
        query_param.VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
        query_param.VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
        query_param.VIF_params.T = 1.5;%1.0;         % Threshold
        query_param.VIF_params.H = 21; %21;        hist_size
        query_param.VIF_params.S  = 7;% =n_time_sections.  added by Eyal
        query_param.VIF_params.per_cell = 0;
        query_param.VIF_params.fold_idx = uint32(1);
        if query_param.VIF_params.run_id == query_param.VIF_params.run_id_for_svm
            query_param.VIF_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.VIF_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STIP params:
        query_param.STIP_params.run_id = 2250;
        query_param.STIP_params.run_id_for_svm = 2287;% symetric=2250 ;% weighted=2287;
        query_param.STIP_params.desc_folders = 'STIP_thresh=0_szf=10';
        query_param.STIP_params.fold_idx = uint32(3);
        if query_param.STIP_params.run_id == query_param.STIP_params.run_id_for_svm
            query_param.STIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.STIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STACKING params:
        % all_weighted=2296, partialy_weighted=2268, all_symetric=2272
        query_param.STACKING_params.STACKING_run_id = 2296;
        query_param.STACKING_params.stacking_fold_idx =1; % for stacking only
        
    end
    if strcmp(query_param.folds_type,'Database_B_no_202_6x48_folds');
        
        % MBH params:
        query_param.MBH_params.run_id = uint32(2219);%2219;%2126;%2112;
        query_param.MBH_params.run_id_for_svm = uint32(2220);  % for weighted SVM
        query_param.MBH_params.desc_folders = 'MBH_patch_size=64';
        query_param.MBH_params.fold_idx = uint32(4);
        if query_param.MBH_params.run_id == query_param.MBH_params.run_id_for_svm
            query_param.MBH_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MBH_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.12  -c 1 ';
        end



        % MIP params:
        query_param.MIP_params.run_id = 2222;%2111;
        query_param.MIP_params.run_id_for_svm = 2292;%2111;
        query_param.MIP_params.desc_folders = 'MIP_N12_M12_gap1_T_GL8';
        query_param.MIP_params.frame_gap = 1;
        query_param.MIP_params.movment_int = 1;
        query_param.MIP_params.N = 12;%Patches size N
        query_param.MIP_params.M = 12;%Patches size M
        query_param.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
        query_param.MIP_params.fold_idx = uint32(4);
        if query_param.MIP_params.run_id == query_param.MIP_params.run_id_for_svm
            query_param.MIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.MIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.07  -c 1 ';
        end



        % VIF params:
        query_param.VIF_params.run_id = 2231;
        query_param.VIF_params.run_id_for_svm = 2293;
        query_param.VIF_params.desc_folders = 'VIF_M=N=3_S=7_T=1.5_H=21';
                                              %'VIF_M=N=3_S=17_T=1.0_H=21_per_cell';
        query_param.VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
        query_param.VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
        query_param.VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
        query_param.VIF_params.T = 1.5;%1.0;         % Threshold
        query_param.VIF_params.H = 21; %21;        hist_size
        query_param.VIF_params.S  = 17;% =n_time_sections.  added by Eyal
        query_param.VIF_params.per_cell = 0;
        query_param.VIF_params.fold_idx = uint32(3);
        if query_param.VIF_params.run_id == query_param.VIF_params.run_id_for_svm
            query_param.VIF_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.VIF_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STIP params:
        query_param.STIP_params.run_id = 2235;
        query_param.STIP_params.run_id_for_svm = 2294;
        query_param.STIP_params.desc_folders = 'STIP_thresh=0_szf=10';
        query_param.STIP_params.fold_idx = uint32(3);
        if query_param.STIP_params.run_id == query_param.STIP_params.run_id_for_svm
            query_param.STIP_params.svm_kernel_type = ' -s 1 -t 2 ';
        else
            query_param.STIP_params.svm_kernel_type = ' -s 0 -t 0 -w1 0.3  -c 1 ';
        end

        % STACKING params:  weighted=2295, Symetric=2273
        query_param.STACKING_params.STACKING_run_id = 2295;
        query_param.STACKING_params.stacking_fold_idx =4; % for stacking only
        
    end    
end 

%{
if strcmp(database,'D')
    query_param.database = 'D';
    %query_param.fold_idx = 1;
    query_param.folds_type = 'Database_D_6x36_folds'; % not used
    query_param.svm_kernel_type = ' -s 1 -t 2 '; % not used
    query_param.i_tries=1;  
    query_param.model_type = 'Models_216_HI_RES_Rot_Flip_corrected';
    
    query_param.MBH_params.MBH_run_id = 4006;%2112;
    query_param.MBH_params.MBH_fold_idx = 5;

    query_param.MIP_params.MIP_run_id = 4001;%2111;
    query_param.VIF_params.VIF_run_id = 1111;
    query_param.STIP_params.STIP_run_id = 1111;
    query_param.STACKING_params.STACKING_run_id = 2132;
    
    query_param.MBH_params.MBH_desc_folders = 'MBH_patch_size=64';
    
    query_param.MIP_params.MIP_desc_folders = 'MIP_N12_M12_gap1_T_GL8';
    query_param.MIP_params.frame_gap = 1;
    query_param.MIP_params.movment_int = 1;
    query_param.MIP_params.N = 12;%Patches size N
    query_param.MIP_params.M = 12;%Patches size M
    query_param.MIP_params.T_GL = 8;%Movement threshold in Gray levels.
    query_param.MIP_params.MIP_fold_idx = 5;
    
    query_param.VIF_params.VIF_desc_folders = 'VIF_M=N=3_S=17_T=1.0_H=21_per_cell';
    query_param.VIF_params.movment_int = 1;      % frames intervat between Current frame and Prev frame
	query_param.VIF_params.N = 3;  %4;              % number of  vertical blocks in frame
	query_param.VIF_params.M = 3;  %4;              % number of  horisontal blocks in frame
    query_param.VIF_params.T = 1.0;%1.0;         % Threshold
    query_param.VIF_params.H = 21; %21;        hist_size
	query_param.VIF_params.S  = 17;% =n_time_sections.  added by Eyal
    query_param.VIF_params.per_cell = 1;
    query_param.VIF_params.VIF_fold_idx = 5;
    
    query_param.STIP_params.STIP_desc_folders = 'STIP_thresh=0_szf=20';
    query_param.STIP_params.STIP_fold_idx = 5;
    
    query_param.STACKING_params.stacking_fold_idx =1; % for stacking only
    
end 
   %}
     
    % MBH
    disp('MBH');  
    query_param.descriptor_type = 'MBH';
    query_param.use_hist_pca = false;
    [MBH_eating_class, MBH_decision_value] = MBH_query(query_param,head_clip_name);    
    
    
    
    
    
    % MIP
    disp('MIP');
    query_param.i_tries=1;
    query_param.descriptor_type = 'MIP';
    query_param.use_hist_pca = true;
    query_param.pca_subspase=100;
    [MIP_eating_class, MIP_decision_value] = MIP_query(query_param,head_clip_name);

    
    % VIF
    disp('VIF');
    query_param.i_tries=1;
    query_param.descriptor_type = 'VIF';
    query_param.use_hist_pca = false;
    [VIF_eating_class, VIF_decision_value] = VIF_query(query_param,head_clip_name);
    
    

    % STIP
    disp('STIP');
    query_param.i_tries=1;
    query_param.descriptor_type = 'STIP';
    query_param.use_hist_pca = false;
    [STIP_eating_class, STIP_decision_value] = STIP_query(query_param,head_clip_name);
    
    
    % Stacking
    disp('Stacking');
    %predicted_label(1,1)=1;
 
%%{

    %'MBH+VIF'
    %'MBH+MIP'
    %'STIP+MIP+MBH'
    %'MIP+MBH+VIF'
    %'STIP+MIP+MBH+VIF'
    stack_option = 'MBH+MIP';
    desc = stack_descriptors(stack_option, MBH_decision_value, MIP_decision_value, STIP_decision_value, VIF_decision_value);
    model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING\\RUN_ID_%d\\SVM\\%s',query_param.database,query_param.model_type,query_param.STACKING_params.STACKING_run_id,stack_option);
    model_dir = sprintf('%s\\fold_%d',model_dir,query_param.STACKING_params.stacking_fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model');
    test_mat(1,:)=double(desc);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    [T, predicted_label, accuracy, decision_values] = evalc('svmpredict(testing_label_vector, test_mat, model);'); 
    MBH_MIP_eating_class = predicted_label(1,1);
    clear test_mat
    
    stack_option = 'MBH+VIF';
    desc = stack_descriptors(stack_option, MBH_decision_value, MIP_decision_value, STIP_decision_value, VIF_decision_value);
    model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING\\RUN_ID_%d\\SVM\\%s',query_param.database,query_param.model_type,query_param.STACKING_params.STACKING_run_id,stack_option);
    model_dir = sprintf('%s\\fold_%d',model_dir,query_param.STACKING_params.stacking_fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model');
    test_mat(1,:)=double(desc);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    [T, predicted_label, accuracy, decision_values] = evalc('svmpredict(testing_label_vector, test_mat, model);'); 
    MBH_VIF_eating_class = predicted_label(1,1);
    clear test_mat
    
    stack_option = 'STIP+MIP+MBH';
    desc = stack_descriptors(stack_option, MBH_decision_value, MIP_decision_value, STIP_decision_value, VIF_decision_value);
    model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING\\RUN_ID_%d\\SVM\\%s',query_param.database,query_param.model_type,query_param.STACKING_params.STACKING_run_id,stack_option);
    model_dir = sprintf('%s\\fold_%d',model_dir,query_param.STACKING_params.stacking_fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model');
    test_mat(1,:)=double(desc);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    [T, predicted_label, accuracy, decision_values] = evalc('svmpredict(testing_label_vector, test_mat, model);'); 
    STIP_MIP_MBH_eating_class = predicted_label(1,1);
    clear test_mat
    
    stack_option = 'MIP+MBH+VIF';
    desc = stack_descriptors(stack_option, MBH_decision_value, MIP_decision_value, STIP_decision_value, VIF_decision_value);
    model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING\\RUN_ID_%d\\SVM\\%s',query_param.database,query_param.model_type,query_param.STACKING_params.STACKING_run_id,stack_option);
    model_dir = sprintf('%s\\fold_%d',model_dir,query_param.STACKING_params.stacking_fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model');
    test_mat(1,:)=double(desc);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    [T, predicted_label, accuracy, decision_values] = evalc('svmpredict(testing_label_vector, test_mat, model);');
    MIP_MBH_VIF_eating_class = predicted_label(1,1);
    clear test_mat
    
    stack_option = 'STIP+MIP+MBH+VIF';
    desc = stack_descriptors(stack_option, MBH_decision_value, MIP_decision_value, STIP_decision_value, VIF_decision_value);
    model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING\\RUN_ID_%d\\SVM\\%s',query_param.database,query_param.model_type,query_param.STACKING_params.STACKING_run_id,stack_option);
    model_dir = sprintf('%s\\fold_%d',model_dir,query_param.STACKING_params.stacking_fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model');
    test_mat(1,:)=double(desc);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    [T, predicted_label, accuracy, decision_values] = evalc('svmpredict(testing_label_vector, test_mat, model);'); 
    STIP_MIP_MBH_VIF_eating_class = predicted_label(1,1);
    clear test_mat
    
    
    
    
    %%}
    detection_results.MBH_eating_class=MBH_eating_class;
    
    %%{
    
    detection_results.MIP_eating_class=MIP_eating_class;
    detection_results.STIP_eating_class=STIP_eating_class;
    detection_results.VIF_eating_class=VIF_eating_class;
    
    
    
    detection_results.MBH_MIP_eating_class=MBH_MIP_eating_class;
    detection_results.MBH_VIF_eating_class=MBH_VIF_eating_class;
    detection_results.STIP_MIP_MBH_eating_class=STIP_MIP_MBH_eating_class;
    detection_results.MIP_MBH_VIF_eating_class=MIP_MBH_VIF_eating_class;
    detection_results.STIP_MIP_MBH_VIF_eating_class=STIP_MIP_MBH_VIF_eating_class;
    
    %%}
    %{
    %detection_results.MBH_eating_class=-1;
    detection_results.STIP_eating_class=-1;
    detection_results.MIP_eating_class=-1;
    detection_results.VIF_eating_class=-1;
    detection_results.MBH_MIP_eating_class=-1;
    detection_results.MBH_VIF_eating_class=-1;
    detection_results.STIP_MIP_MBH_eating_class=-1;
    detection_results.MIP_MBH_VIF_eating_class=-1;
    detection_results.STIP_MIP_MBH_VIF_eating_class=-1;
%}

end
