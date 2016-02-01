function [STIP_eating_class, STIP_decision_value] = STIP_query(query_param,head_clip_name)
 
    STIP_desc_dir = 'H:\\Thesis - eating fishes\\Classification_temp_data\\STIP';
    code_path = 'H:\thesis - eating fishes\Code\Descriptors\STIP';
    if ~my_create_dir(STIP_desc_dir); return; end;
    [path, name,ext]=fileparts(head_clip_name);
    output_file = strcat(STIP_desc_dir,'/STIP_',name,'.txt');
    if query_param.database =='A'
        mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                       head_clip_name,... 
                       '" -thresh 0 -kparam 0.005 -szf 20 -vis "no"',' -o "',...
                       output_file,'"' );
    end
    if query_param.database =='B'
        if strcmp(query_param.STIP_params.desc_folders,'STIP_thresh=0_szf=20')
        mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                       head_clip_name,... 
                       '" -thresh 0 -szf 20 -vis "no"',' -o "',...
                       output_file,'"' );
        else
            if strcmp(query_param.STIP_params.desc_folders,'STIP_thresh=0_szf=10')
            mycommand = strcat('"',code_path,'/stipdet"  -f "',...
                       head_clip_name,... 
                       '" -thresh 0 -szf 10 -vis "no"',' -o "',...
                       output_file,'"' );
            else
                disp('Not supported STIP szf . in STIP_query(...) ');
            end
        end
            
    end

    %mycommand
    % Supress output by use evalc that sends output to output_buffer instead
    % of console
    output_buffer = evalc('system(mycommand);');
    desc_txt_file = output_file;
    
    
    % save hoghof as *.mat file
    hoghof = get_hoghof(desc_txt_file);
    f1 = sprintf('%.4d',1);
    stip_file = strcat(STIP_desc_dir,'\STIP_7-',f1,'.mat');
    save(stip_file,'hoghof');
    
    
    
    % STIP BoW 
    [ STIP_BoW, STIP_Bow_fn] = get_STIP_BoW(STIP_desc_dir,query_param);
    
    
    % SVM classifier
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab');
    
    [STIP_eating_class, STIP_decision_value] = query_svm(query_param, query_param.STIP_params, STIP_Bow_fn);
    
    

 
 end