
function a0_prepare_data_per_split()
clear vars
    [globals,  DB_dir, vidext] = prerun_header();

    
    
    descriptor_type = 'MBH'; % 'MBH'  'MIP'  'STIP'  'GIST' 'VIF'
    model_type ='Models_Rot_and_Flip';
    %'Models_300_HI_RES_rot_flip_corrected';
    %'Models_Rot_and_Flip';% 
    %'Models_84_compressed_rot_flip';
    %'Models_84_HI_RES_Rot_Flip';
    %'Models_216_compressed_rot_flip';
    %'Models_216_HI_RES_Rot_Flip';
    %'Models_300_compressed_rot_flip';
    %'Models_300_HI_RES_rot_flip'; 
    %'Models_162_compressed_rot_flip';
    %'Models_HI_RES_Rot_and_Flip_frame' 'Models' 'Models_Rot' 'Models_Rot_and_Flip' 'Models_no_rotation'
    database = 'A';
    DB_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s',database);
    %run_id = 1000;
    run_id_fn = strcat(DB_dir,'\\run_id.mat');
    %save(run_id_fn,'run_id');
    folds_type = 'Database_A_no_avi2_6x40_folds';
    %'Database_B_no_562-2_6x48_folds';
    %'Database_B_no_409_25200to30200_6x48_folds';
    %'Database_B_no_562-1_6x48_folds';
    %'Database_B_no_202_6x48_folds';
    %'Database_A_no_avi2_6x40_folds';
    %'Database_A_6x50_folds';
    %'Database_B_6x50_folds';
    %'Database_C_6x14_folds';
    %'Database_D_6x36_folds';
    %'Database_A_6x50_folds';
    %'Database_B_6x27_folds';
    use_hist_pca = false;

    
    use_wheighted_SVM = 0;
    if use_wheighted_SVM
        svm_kernel_type = ' -s 0 -t 0 -w1 0.04  -c 1 '; 
    else
        svm_kernel_type =' -s 1 -t 2 ';
    end
    n_tries=1;% 10
    pca_subspase=100;
    switch descriptor_type
        case 'MBH'
        desc_folders = {...
            %'MBH_patch_size=64';...
            'MBH_patch_size=32';...
            %'MBH_patch_size=16';...
            %'MBH_orig';...
            %'MBH_patch_size=32_nxy=2_nt=5';...
            %'MBH_patch_size=64_nxy=1';...  % change desc_size to 1*1*3*8=24  in find_min_max_MBH_per_fold(..), get_rand_agents(...), 
            %'MBH_patch_size=64_nxy=1_nt=5';...% change desc_size to 1*1*3*8=24
            %'MBH_track_length=9';...% change desc_size to 1*1*3*8=24
        };
            case 'STIP'
        desc_folders = {...
            %'STIP_orig';...
            %'STIP_szf=10';...
            %'STIP_szf=10_margin=30';...
            %'STIP_szf=20';...
            %'STIP_szf=20_margin=30';...
            %'STIP_szf=20_thresh=0_margin=30';...
            %'STIP_thresh=0_kparam=0.005_szf=20';...
            %'STIP_thresh=0_szf=20';...
            'STIP_thresh=0_szf=10';...
        };
            case 'MIP'
        desc_folders = {...
            %'MIP_orig';...
            %'MIP_N24_M24_T_GL8';...
            %'MIP_N32_M32_T_GL8';...
            %'MIP_N12_M12_T_GL8';...
            %'MIP_frame_gap1';...
            %'MIP_frame_gap=1_N=32_T_GL=8';...
            %'MIP_frame_gap=1_N=48_T_GL=6';...
            %'MIP_frame_gap=1_N=64';...
            'MIP_N12_M12_gap1_T_GL8';...
            %'MIP_optimized N16';...
            %'MIP_optimized N32';...
            %'MIP_T_GL8';...
            %'MIP_T_GL10';...
            
        };
        case 'VIF'
        desc_folders = {...
            %'VIF_M=3_N=3';...
            %'VIF_M=N=1_S=3_T=1.5_rt';...
            %'VIFF_M=N=1_S=8_T=1.5_perCell';...
            %'VI_M=N=3_S=7_T=1.5_H=21_perCell';...
            %'VIF_M=N=3_S=3_T=1.5_perCell';...
            %'VIF_M=N=3_S=1_T=1.0_H=21';...
            %'VIF_M=N=3_S=17_T=1.0_H=21_per_cell';...
            'VIF_M=N=3_S=7_T=1.5_H=21';...
        };
    end
    
    switch descriptor_type
    case 'MBH'
        num_of_clusters = 512;  % 16: must be K^tree_height. in this case K=4 (or 2) tree_height=2 (or 4)
                                % 64: must be K^tree_height. in this case K=4 (or 2) tree_height=3 (or 6)
                                % 256: must be K^tree_height. in this case K=4 (or 2) tree_height=4 (or 8)
                                % 1024: must be K^tree_height. in this case K=4 (or 2) tree_height=5 (or 10)
        d_len=96;
    case 'VIF'
        num_of_clusters = 128; % 1024: must be K^tree_height. in this case K=4 (or 2) tree_height=3 (or 6)
        d_len=21*9;%21;%21*9; 
	case 'MIP'
        num_of_clusters = 512; % 1024: must be K^tree_height. in this case K=2 tree_height=9
        d_len=512; 
	case 'STIP'
        num_of_clusters = 128;%512; % 1024: must be K^tree_height. in this case K=2 tree_height=7
        d_len=162; 
    end
    
    
    use_hirarchical_integer_kmeans = 0;
    n_presentors = 50000;  % kmeans
    K=2; % num of branches for vertex ( num of sons)


    multiple_kmeans_type = 0;  % type of multiple_kmeans: 
                               % 0 = no mutiple_kmeans to be used
                               % 1 = L2 metric for clusters distance  
                               % 2 = ACC by self test of training set    
                               % 3 = ACC by nested n folds of the training set
   for i_desc_folders = 1:size(desc_folders,1)
       %if descriptor_type=='MBH'
       %if i_desc_folders==1 d_len=96; end
       %if i_desc_folders==2 d_len=160; end
       %if i_desc_folders==3 d_len=24; end
       %if i_desc_folders==4 d_len=40; end
       %if i_desc_folders==5 d_len=96; end
       %end
       
       
        run_id_fn = strcat(DB_dir,'\\run_id.mat');


        
        if use_wheighted_SVM
            run_id = 1123;
            load(run_id_fn,'run_id');
            run_id_SVM = run_id+1;
            run_id = run_id_SVM;%run_id+1; % tem increment of run_id. for saving run_id only. later run_id will be decremented
            save(run_id_fn,'run_id'); % save the new value in order to inform this id is used by run_id_output
            run_id = 1123;
            %run_id = run_id-1; % decrement run_id
        else
            load(run_id_fn,'run_id');
            run_id = run_id+1;
        	run_id_SVM = run_id;
            save(run_id_fn,'run_id');
            

        end
        
        
        for i_tries = 1: n_tries
            fprintf('\n');
            msg = sprintf('******** try no. %d run_id %d **********',i_tries,run_id);
            disp(msg);
            [globals,  DB_dir_, vidext] = prerun_header();
            direction_idx = 0; % dummy
            switch descriptor_type
                case 'STIP'
                    
                    descriptor_folder = char(desc_folders(i_desc_folders));
                    disp(descriptor_folder);
                    %[dummy, best_acc_score_mean(i_tries,1)] = 
                    if ~ use_wheighted_SVM
                        prepare_data_per_split( multiple_kmeans_type, K,d_len, n_presentors, run_id,use_hirarchical_integer_kmeans, i_tries,descriptor_type,descriptor_folder,model_type,database,folds_type,num_of_clusters);
                    end
                    [T,res(i_tries,:) last_fold_acc(i_tries,1)]= ...
                        evalc('a0_svm(run_id,descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries,svm_kernel_type,run_id_SVM);');
                case 'MBH'
                    descriptor_folder = char(desc_folders(i_desc_folders));
                    disp(descriptor_folder);
                    if ~ use_wheighted_SVM
                        prepare_data_per_split( multiple_kmeans_type, K,d_len, n_presentors, run_id,use_hirarchical_integer_kmeans, i_tries,descriptor_type,descriptor_folder,model_type,database,folds_type,num_of_clusters);
                    end
                    if use_hist_pca 
                        pca_for_histogram_per_split(pca_subspase,descriptor_type,descriptor_folder,model_type,database,folds_type);
                    end
                    [T,res(i_tries,:)] = ...
                        evalc('a0_svm(run_id,descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries,svm_kernel_type,run_id_SVM);');

                 case 'VIF'
                    
                    descriptor_folder = char(desc_folders(i_desc_folders));%'VIF_M=N=3_S=3_T=1.5_perCell';%'VIF_M=N=1_S=3_T=1.5_rt';%'VIF_M=3_N=3_S=5_I=1_D=1'; %'VIF_orig'; %'VIF'; %'VIF 1x1 blocks  frame_gap=1';
                    disp(descriptor_folder);
                    if ~ use_wheighted_SVM
                        prepare_data_per_split( multiple_kmeans_type, K,d_len, n_presentors, run_id,use_hirarchical_integer_kmeans, i_tries,descriptor_type,descriptor_folder,model_type,database,folds_type,num_of_clusters);
                    end
                    [T,res(i_tries,:)] = ...
                        evalc('a0_svm(run_id,descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries,svm_kernel_type,run_id_SVM);');
                    %res(i_tries,:) = a0_svm_10_splits_VIF_Database_B_per_fold...
                    %    (descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries);  
                    %disp(sprintf('%s\t\t\t%s\t\t%s\t\t\t%s\t%s','ACC','STD_err','AUC','false_pos','false_neg'));
                    %disp(sprintf('%f\t%f\t%f\t%f\t%f\t',res(1,1),res(1,2),res(1,3),res(1,4),res(1,5)));

                    %return; % VIF needs one loop only. all other loops are the same.

                case 'MIP'
                    
                    descriptor_folder = char(desc_folders(i_desc_folders));
                    disp(descriptor_folder);
%%{    
                    if ~ use_wheighted_SVM
                            for direction_idx = 0:7%7

                            msg = sprintf('\n\nDirection %d',direction_idx);
                            disp(msg);
                            descriptor_folder_drection = sprintf('%s\\Direction_%.1d',descriptor_folder,direction_idx);

                            prepare_data_per_split( multiple_kmeans_type, K,d_len, n_presentors, run_id,use_hirarchical_integer_kmeans, i_tries,descriptor_type,descriptor_folder_drection,model_type,database,folds_type,num_of_clusters);

                            pca_for_histogram_per_split(pca_subspase, run_id,i_tries,descriptor_type,descriptor_folder_drection,model_type,database,folds_type);
                            end
                    

                        concatenate_all_directions(run_id,i_tries,descriptor_type,descriptor_folder,model_type,database,folds_type);
                    end
%%}    
                    use_hist_pca=1;
                    %res(i_tries,:) = a0_svm_10_splits_MIP_Database_B_per_fold...
                    %    (descriptor_type,descriptor_folder_root,model_type,database,use_hist_pca,folds_type,i_tries);
                    %res(i_tries,:) = a0_svm_MIP(descriptor_type,descriptor_folder_root,model_type,database,use_hist_pca,folds_type,i_tries,svm_kernel_type);
                    [T, res(i_tries,:)] = ...
                        evalc('a0_svm_MIP(run_id,descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries,svm_kernel_type,run_id_SVM);');

            end
            for res_id=1:i_tries
                disp(sprintf('%f\t%f\t%f\t%f\t%f\t',res(res_id,1),res(res_id,2),res(res_id,3),res(res_id,4),res(res_id,5)));
            end
            %a0_second_svm_10_splits_Database_B_per_fold.m

        end







        main_model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type);
        main_desc_dir = sprintf('%s\\%s',main_model_dir,descriptor_folder);
        all_res_fname = sprintf('%s\\res_all_tests.mat',main_desc_dir);  
        save(all_res_fname,'res');

        disp('\n\n');
        disp(descriptor_folder);
        disp('-------------------------------');
        for res_id=1:n_tries
            disp(sprintf('%f\t%f\t%f\t%f\t%f\t',res(res_id,1),res(res_id,2),res(res_id,3),res(res_id,4),res(res_id,5)));
        end
        acc_all = squeeze(res(:,2));
        auc_all = squeeze(res(:,1));
        false_negative_all = squeeze(res(:,4));
        false_positive_all = squeeze(res(:,5));


        mean_Standard_Error=mean(squeeze(res(:,3)));
        mean_ACC = mean(acc_all);
        mean_AUC = mean(auc_all);
        mean_fn = mean(false_negative_all);
        mean_fp = mean(false_positive_all);

        avg_res_fname = sprintf('%s\\res_avg_tests.mat',main_desc_dir);  
        save(avg_res_fname,'mean_AUC','mean_ACC','mean_Standard_Error','mean_fn','mean_fp');


         disp(sprintf('\navg :\n%f\t%f\t%f\t%f\t%f\t',mean_AUC,mean_ACC,mean_Standard_Error,1-mean_fp,1-mean_fn));


        %--------------------------------------%
        %           Write to log file          %
        %--------------------------------------%

        time = int2str(now());  % get serial time ( time as an integer number)
        my_time = fix(clock());
        year = int2str(my_time(1));
        month = int2str(my_time(2));
        day = int2str(my_time(3));
        hour = int2str(my_time(4));
        min = int2str(my_time(5));
        sec = int2str(my_time(6));
run_id_str = int2str(int32(run_id_SVM));
        log_file = strcat(main_model_dir,...
                                    '\10_tries_',descriptor_folder,'__run_id=',run_id_str,'_', ...
                                    year, '_', month ,'_', ...
                                    day,'_',  hour,'_',  ...
                                    min,'_',  sec,...
                                    '.txt');
        my_disp(sprintf('\n\n\nRunning version num  %s',version), log_file);
        my_disp(sprintf('--------------------------------------------\r\n'), log_file);

        my_disp(sprintf('Date:  %s/%s/%s',day,month,year), log_file);
        my_disp(sprintf('Time:  %s:%s:%s',hour,min,sec), log_file);
        my_disp(sprintf('\r\n',hour,min,sec), log_file);
        my_disp(sprintf('Run id:  %d',run_id), log_file);
        my_disp(sprintf('Run id for SVM:  %d',run_id_SVM), log_file);
        my_disp(strcat('Descriptor type : ',descriptor_type), log_file);
        my_disp(strcat('Model type : ',model_type), log_file);    
        my_disp(strcat('Database : ',database), log_file);
        my_disp(strcat('Folds type : ',folds_type), log_file);
        my_disp(sprintf('Use hist pca flag: %d',use_hist_pca), log_file);
        if use_hist_pca
            my_disp(sprintf('PCA_subspase: %d',pca_subspase), log_file); 
        end
        my_disp(strcat('SVM kernel type : ',svm_kernel_type), log_file);
        my_disp(sprintf('Num of repeated tests : %d',n_tries), log_file);
        my_disp(strcat('Desc_folders(params): ',char(desc_folders(i_desc_folders))), log_file);
        my_disp(sprintf('Num_of_clusters : %d',num_of_clusters), log_file);
        if use_hirarchical_integer_kmeans 
            my_disp('Kmeans_type : hirarchical_integer_kmeans', log_file);
        else
            my_disp('Kmeans_type : integer_kmeans', log_file);
        end
        my_disp(sprintf('Original descriptor length : %d',d_len), log_file);
        my_disp(sprintf('Num of randomly selected agents fo kmeans : %d',n_presentors), log_file);
        my_disp(sprintf('Num of branches for hirarchical kmeans : %d',K), log_file);% num of branches for vertex ( num os sons)

       switch multiple_kmeans_type
           case 0
               my_disp('multiple_kmeans_type : 0 = no mutiple_kmeans to be used', log_file);
           case 1
               my_disp('multiple_kmeans_type : 1 = L2 metric for clusters distance', log_file);
           case 2
               my_disp('multiple_kmeans_type : 2 = ACC by self test of training set', log_file);
           case 3
               my_disp('multiple_kmeans_type : 3 = ACC by nested n folds of the training set', log_file);
       end
    

        my_disp(strcat('\r\n'), log_file);


        my_disp('AUC          Acc         Std_Err      trueneg     truepos ', log_file);
        my_disp('----         ----        ----         ----        ----', log_file);
        for res_id=1:n_tries
            my_disp(sprintf('%f\t%f\t%f\t%f\t%f\t',res(res_id,1),res(res_id,2),res(res_id,3),1-res(res_id,4),1-res(res_id,5)), log_file);
        end
        my_disp(sprintf('\r\navg :\r\n%f\t%f\t%f\t%f\t%f\t',mean_AUC,mean_ACC,mean_Standard_Error,1-mean_fn, 1-mean_fp), log_file);

%best_acc_score_mean
%last_fold_acc
    end

end








