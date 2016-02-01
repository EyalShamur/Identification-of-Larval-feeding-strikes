function [eating_class, decision_value] = MBH_query(query_param,head_clip_name)

    code_path = 'H:\\Thesis - eating fishes\\Code\\ClassificationQuery\\DenseTrajectories_Query\\DenseTrajectories_Query\\Release';
    MBH_desc_dir = 'H:\\Thesis - eating fishes\\Classification_temp_data\\MBH';
    if ~my_create_dir(MBH_desc_dir); return; end;
    MBH_desc_dir_1 = sprintf('%s\\HOG',MBH_desc_dir);
    MBH_desc_dir_2 = sprintf('%s\\HOF',MBH_desc_dir);
    MBH_desc_dir_3 = sprintf('%s\\INFO',MBH_desc_dir);
    MBH_desc_dir_4 = sprintf('%s\\MBHx',MBH_desc_dir);
    MBH_desc_dir_5 = sprintf('%s\\MBHy',MBH_desc_dir);
    MBH_desc_dir_6 = sprintf('%s\\DENSE_TRAJ',MBH_desc_dir);
    if ~my_create_dir(MBH_desc_dir_1); return; end;
    if ~my_create_dir(MBH_desc_dir_2); return; end;
    if ~my_create_dir(MBH_desc_dir_3); return; end;
    if ~my_create_dir(MBH_desc_dir_4); return; end;
    if ~my_create_dir(MBH_desc_dir_5); return; end;
    if ~my_create_dir(MBH_desc_dir_6); return; end;

    if query_param.database =='A'
        mycommand = strcat('"',code_path,'\\DenseTrajectories_Query_patch32"  1 1 "',...
                       head_clip_name,... 
                       '" "',...
                       MBH_desc_dir,'"' );
    end
    if query_param.database =='B'  || query_param.database =='D'          
                           mycommand = strcat('"',code_path,'\\DenseTrajectories_Query_patch64"  1 1 "',...
                       head_clip_name,... 
                       '" "',...
                       MBH_desc_dir,'"' );
    end
    %no_print_command = strcat(mycommand,' &>/dev/null'); % added to avoid printing info to the screen
    system(mycommand);

    
    % MBH BoW 
    [ MBH_BoW, MBH_Bow_fn] = get_MBH_BoW(MBH_desc_dir,query_param);

    
    % SVM classifier
    rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab');
    
    [eating_class, decision_value] = query_svm(query_param, query_param.MBH_params, MBH_Bow_fn);
        
       

end
