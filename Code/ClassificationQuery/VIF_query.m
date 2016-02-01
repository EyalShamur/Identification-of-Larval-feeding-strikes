function [VIF_eating_class, VIF_decision_value] = VIF_query(query_param,head_clip_name)

    VIF_desc_dir = 'H:\\Thesis - eating fishes\\Classification_temp_data\\VIF';
    if ~my_create_dir(VIF_desc_dir); return; end;
    [path, name,ext]=fileparts(head_clip_name);
    
    addpath('H:\thesis - eating fishes\Code\Descriptors\OpticalFlow\mex'); % opticalflow
    addpath('H:\Thesis - eating fishes\Code\Descriptors\VIF');
    

    
    VIF_descriptor = VIF_create_feature_vec(query_param.VIF_params, path,strcat(name,ext));
    
    % save descriptor
    f1 = sprintf('%.4d',1);
    vif_file = strcat(VIF_desc_dir,'\VIF_7-',f1 ,'.mat');
    save(vif_file,'VIF_descriptor');
    
    % VIF BoW 
    [ VIF_BoW, VIF_Bow_fn] = get_VIF_BoW(VIF_desc_dir,query_param);
    
    % SVM classifier
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab');
    
    [VIF_eating_class, VIF_decision_value] = query_svm(query_param, query_param.VIF_params , VIF_Bow_fn);
    
    
    
    
end