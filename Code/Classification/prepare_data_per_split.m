function [res, best_acc_score] = prepare_data_per_split(multiple_kmeans_type, K,d_len, n_presentors, run_id,use_hirarchical_integer_kmeans, i_tries, descriptor_type,descriptor_folder,model_type,database,folds_type,num_of_clusters)

    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);


    output_dir_hist = sprintf('%s\\RUN_ID_%d\\HISTOGRAM\\test_num_%d', main_desc_dir,run_id,i_tries); 
    output_dir_kmeans = sprintf('%s\\RUN_ID_%d\\KMEANS_CLASSES\\test_num_%d',main_desc_dir,run_id,i_tries); 
    dir_desc = sprintf('%s\\DESCRIPTOR',main_desc_dir); 
    output_dir_norm = sprintf('%s\\RUN_ID_%d\\NORM',main_desc_dir,run_id); 
    output_dir_prs = sprintf('%s\\RUN_ID_%d\\KMEANS_PRESENTORS',main_desc_dir,run_id); 
    output_dir_kmeans_data = sprintf('%s\\RUN_ID_%d\\KMEANS_DATA',main_desc_dir,run_id);
    
 
    
    if ~my_create_dir(output_dir_hist); return; end; 
    if ~my_create_dir(output_dir_kmeans); return; end;
    if ~my_create_dir(dir_desc); return; end;
    if ~my_create_dir(output_dir_norm); return; end;
    if ~my_create_dir(output_dir_prs); return; end;
    if ~my_create_dir(output_dir_kmeans_data); return; end;
    

    if i_tries==1
        prepare_done = false;
        norm_done = false;
        kmeans_done = false;
    else
        prepare_done = true;
        norm_done = true;
        kmeans_done = false;
    end  
    %{
    modus=5;
    if mod(i_tries,modus)==1
        presentors_done = false;
    else
        presentors_done = true;
    end
    
    %}
    presentors_done = false;
    vl_ikmeans_done = false;
    

 
    clear fold_clips
    clear fold_tags
    fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
    load(fold_file); % get fold_clips,fold_tags  
 



    [n_clips_per_fold, n_folds ]=size(fold_tags);
best_acc_score = 0;
    for fold_idx = 1:n_folds
        msg = sprintf('Fold num %d',fold_idx);
        disp('--------------------');
        disp(msg);
        min_max_file = sprintf('%s\\min_max_fold_%.2d%s',output_dir_norm,fold_idx,'.mat');

        output_dir_norm_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',output_dir_norm,fold_idx);
        if ~my_create_dir(output_dir_norm_training_set); return; end;
        output_dir_norm_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',output_dir_norm,fold_idx);
        if ~my_create_dir(output_dir_norm_test_set); return; end;

        output_dir_kmeans_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',output_dir_kmeans,fold_idx);
        if ~my_create_dir(output_dir_kmeans_training_set); return; end;
        output_dir_kmeans_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',output_dir_kmeans,fold_idx);
        if ~my_create_dir(output_dir_kmeans_test_set); return; end;

        output_dir_hist_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',output_dir_hist,fold_idx);
        if ~my_create_dir(output_dir_hist_training_set); return; end;
        output_dir_hist_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',output_dir_hist,fold_idx);
        if ~my_create_dir(output_dir_hist_test_set); return; end;
        
        % output_dir_kmeans_presentors = sprintf('%s\\FOLD_%.2d_TRAINING_SET',output_dir_prs,fold_idx);
        %if ~my_create_dir(output_dir_kmeans_presentors); return; end;       

        output_dir_kmeans__ = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_dir_kmeans_data,i_tries,fold_idx);
        if ~my_create_dir(output_dir_kmeans__); return; end;
        
        
        %pr_id = uint32(floor((i_tries-1)/modus))+1;
        
        %output_dir_kmeans_presentors = sprintf('%s\\test_group_%d\\FOLD_%.2d_TRAINING_SET',output_dir_prs,pr_id,fold_idx);
        
        
        output_dir_kmeans_presentors = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_dir_prs,i_tries,fold_idx);
        if ~my_create_dir(output_dir_kmeans_presentors); return; end;
        
        

    
        
        
        
        % build training set vector and test set vector of clip names
        clear training_clips;
        training_clips = [];
        all_clips_per_fold = [];
        for train_idx=1:n_folds
            all_clips_per_fold = [all_clips_per_fold squeeze(fold_clips(:,train_idx))];
            if train_idx ~= fold_idx
                training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
            end
        end
        test_clips = squeeze(fold_clips(:,fold_idx));

%prepare_done=1;
        if ~prepare_done
            switch descriptor_type
                case 'MBH'
                    [max_all, min_all] = find_min_max_MBH_per_fold(d_len,main_desc_dir,training_clips);
                    [dummy1, dummy2  ] = find_min_max_MBH_per_fold(d_len,main_desc_dir,test_clips);
                case 'VIF'
                    [max_all, min_all] = find_min_max_VIF_per_fold(dir_desc,training_clips);
                    [dummy1, dummy2  ] = find_min_max_VIF_per_fold(dir_desc,test_clips);
                case 'MIP'
                    disp(' Copy files..');
                    cmd = sprintf('copy "%s\\*.mat" "%s" >nul',main_desc_dir,dir_desc);
                    system(cmd);
                    [max_all, min_all] = find_min_max_MIP_per_fold(dir_desc,training_clips);
                    [dummy1, dummy2  ] = find_min_max_MIP_per_fold(dir_desc,test_clips);
                case 'STIP'
                    [max_all, min_all] = find_min_max_STIP(main_desc_dir,training_clips);
                    [dummy1, dummy2  ] = find_min_max_STIP(main_desc_dir,test_clips);
            end
            
            save(min_max_file,'max_all','min_all');
        end


%norm_done=1;
        if ~norm_done
            load(min_max_file,'max_all','min_all');
            % normalize to the UINT8 within interval [0 255]

    
            

            %for training set
            kmeans_norm_data_per_fold(descriptor_type , ...
                dir_desc,output_dir_norm_training_set,max_all, min_all, training_clips);  % 3697
            %for test set
            kmeans_norm_data_per_fold(descriptor_type , ...
                dir_desc,output_dir_norm_test_set,max_all, min_all, test_clips);  % 3697
        end

%{
        if strcmp(descriptor_type,'VIF')       
            for vc_idx=1: size(training_clips,1)
                clip_num = training_clips(vc_idx);
                fn = sprintf('%.4d',clip_num);
                file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
                load(file_name,'desc_norm');
                if isempty(desc_norm)
                    desc_norm = uint8(zeros(size(C,1),1));
                    msg = sprintf('Clip num %d has empty descriptor',clip_num);
                    disp(msg);
                end
                %hist_volume = 500;
                %hist = build_norm_histogram(desc_norm,hist_volume,size(desc_norm,1));
                hist = desc_norm;
                fn = sprintf('%.4d',clip_num);
                hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_training_set,fn);
                save (hist_file,'hist')  % classes_2
                fclose('all');
            end
            for vc_idx=1: size(test_clips,1)
                clip_num = test_clips(vc_idx);
                fn = sprintf('%.4d',clip_num);
                file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_test_set,fn); 
                load(file_name,'desc_norm');
                if isempty(desc_norm)
                    desc_norm = uint8(zeros(size(C,1),1));
                    msg = sprintf('Clip num %d has empty descriptor',clip_num);
                    disp(msg);
                end
                fn = sprintf('%.4d',clip_num);    
                %hist_volume = 500;
                %hist = build_norm_histogram(desc_norm,hist_volume,size(desc_norm,1));
                hist = desc_norm;
                fn = sprintf('%.4d',clip_num);
                hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_test_set,fn);
                save (hist_file,'hist')  % classes_2
                fclose('all');
            end
            continue;
        end

%}
        
        %{
        switch descriptor_type
            case 'MBH'
                num_of_clusters = 512;  % 64: must be 4^tree_height. in this case tree_height=3
                                        % 256: must be 4^tree_height. in this case tree_height=4
                                        % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'VIF'
                num_of_clusters = 24; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'MIP'
                num_of_clusters = 512; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'STIP'
                num_of_clusters = 128;%512; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
        end
%}
        %n_presentors = 50000;  % 1000
        if(~kmeans_done ) %&& ~strcmp(descriptor_type,'VIF')
        %if(~hi_kmeans_done && ~strcmp(descriptor_type,'VIF'))
            tStart=tic;

            

            
            %use_hirarchical_integer_kmeans = 0;
            use_integer_kmeans = 1-use_hirarchical_integer_kmeans;
            
            
            % Heirarchichal Integer K-means
            if use_hirarchical_integer_kmeans
                %K=2; % num of branches for vertex ( num os sons)
                nleaves = num_of_clusters; 

                if multiple_kmeans_type ~= 0
                    [tree, A, res] = multiple_hirachical_integer_kmeans...
                       (multiple_kmeans_type, d_len, training_clips, n_presentors, num_of_clusters,K,...
                       'method', 'elkan',presentors_done,descriptor_type,...
                       output_dir_norm_training_set,output_dir_kmeans_presentors, ...
                       descriptor_folder,model_type,database,folds_type,output_dir_hist_training_set,fold_idx);
                   if fold_idx == n_folds
                    best_acc_score=res;
                   end
                else
                    if(~presentors_done)
                        presentors = get_rand_agents(d_len, n_presentors, descriptor_type, training_clips,output_dir_norm_training_set);
                        presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_kmeans_presentors);
                        save (presentors_file,'presentors')  
                    end 
                    presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_kmeans_presentors);
                    load (presentors_file,'presentors')  % presentors  
                    % data has clmn wise representation. ie. each clmn represents a point
                    msg = sprintf(' Running vl_hikmeans...');
                    disp(msg);
                    
                    vl_hikmeans_done = 0;
                    vl_hikmeans_file = sprintf('%s//vl_hikmeans_file.mat',output_dir_kmeans__);
                    if ~vl_hikmeans_done
                        [tree,A] = vl_hikmeans(presentors,K,nleaves,'method', 'elkan') ;
                        save (vl_hikmeans_file,'tree','A'); 
                    else
                        load (vl_hikmeans_file,'tree','A'); 
                    end
                    
                    
  
                end
                
                
                
                

                % classify training data
                clear clip_num
                [msg, errmsg] = sprintf(' Classify training data...');
                disp ( msg) ;
                for vc_idx=1: size(training_clips,1)
                    clip_num = training_clips(vc_idx);




                    %[msg, errmsg] = sprintf('\n classify clip num %d \n',clip_num);
                    %disp ( msg) ;


                    fn = sprintf('%.4d',clip_num);
                    file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
                    load(file_name,'desc_norm');
                    if strcmp(descriptor_type,'MIP')
                        desc_norm=uint8(desc_norm');
                    end



                    AT       = vl_hikmeanspush(tree,desc_norm) ;





                    % assign cluster tag for each point ( cluster id)
                    m = size(AT,1); % tree height
                    n = size(AT,2); % num of newdata points
                    tags = zeros(n,1);
                    for t=1:n
                       tag = 0;
                       for i=1:m
                          tag = tag+(AT(i,t)-1)*power(K,m-i);
                       end
                       tag=tag+1;
                      if tag > num_of_clusters
                          it_is_a_bug = 1;
                      end
                      tags(t,1)=tag;
                    end


                   classes=tags;




                    fn = sprintf('%.4d',clip_num);    
                    classes_file = sprintf('%s//kmeans_classes_7-%s.mat',output_dir_kmeans_training_set,fn);
                    save (classes_file,'classes')  % classes_1


                    hist_volume = 500;
                    hist = build_norm_histogram(classes,hist_volume,num_of_clusters);
                    fn = sprintf('%.4d',clip_num);
                    hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_training_set,fn);
                    save (hist_file,'hist')  % classes_2
                    fclose('all');

                end



                % classify test set data
                clear clip_num
                [msg, errmsg] = sprintf(' Classify test data...');
                disp ( msg) ;
                for vc_idx=1: size(test_clips,1)
                    clip_num = test_clips(vc_idx);
                    %[msg, errmsg] = sprintf('\n classify clip num %d \n',clip_num);
                    %disp ( msg) ;
                    fn = sprintf('%.4d',clip_num);
                    file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_test_set,fn); 
                    load(file_name,'desc_norm');
                    if strcmp(descriptor_type,'MIP')
                        desc_norm=uint8(desc_norm');
                    end

                    AT       = vl_hikmeanspush(tree,desc_norm) ;


                    % assign cluster tag for each point ( cluster id)
                    m = size(AT,1); % tree height
                    n = size(AT,2); % num of newdata points
                    tags = zeros(n,1);
                    for t=1:n
                       tag = 0;
                       for i=1:m
                          tag = tag+(AT(i,t)-1)*power(K,m-i);
                       end
                       tag=tag+1;
                      if tag > num_of_clusters
                          it_is_a_bug = 1;
                      end
                      tags(t,1)=tag;
                    end


                   classes=tags;




                    fn = sprintf('%.4d',clip_num);    
                    classes_file = sprintf('%s//kmeans_classes_7-%s.mat',output_dir_kmeans_test_set,fn);
                    save (classes_file,'classes')  % classes_1
                    


                    hist_volume = 500;
                    hist = build_norm_histogram(classes,hist_volume,num_of_clusters);
                    fn = sprintf('%.4d',clip_num);
                    hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_test_set,fn);
                    save (hist_file,'hist')  % classes_2
                    fclose('all');



                end 
                t_elapsed = toc(tStart);
                [msg, errmsg] = sprintf(' hi_kmean time = %d seconds',uint32(t_elapsed));
                disp ( msg) ;
                
            elseif  use_integer_kmeans  % not hirarchical
                

               tStart_integer_kmeans=tic;
               if  multiple_kmeans_type > 1 
                    msg = sprintf(' Running multiple vl_ikmeans...');
                    disp(msg);
                    %[C,A,res] = multiple_integer_kmeans_for_best_ACC...
                    %  (training_clips, n_presentors, num_of_clusters,...
                    [C,A,res] = multiple_integer_kmeans_for_best_ACC_per_fold...
                        (all_clips_per_fold, n_presentors, num_of_clusters,...
                       'method', 'elkan',presentors_done,descriptor_type,...
                       output_dir_norm_training_set,output_dir_kmeans_presentors, ...
                       descriptor_folder,model_type,database,folds_type,output_dir_hist_training_set,fold_idx);
                   
                        msg=sprintf('best_ACC = %d',res);        
                        disp(msg);
               else
                   if multiple_kmeans_type == 1
                        [C,A,res] = multiple_integer_kmeans(d_len, training_clips, n_presentors,num_of_clusters,'method', 'elkan', presentors_done,descriptor_type,output_dir_norm_training_set,output_dir_hist);
                   else %  multiple_kmeans_type == 0
%presentors_done=1;
                    if(~presentors_done)
                        presentors = get_rand_agents(d_len, n_presentors, descriptor_type, training_clips,output_dir_norm_training_set);
                        presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_kmeans_presentors);
                        save (presentors_file,'presentors')  % classes_2
                    end 
                    presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_kmeans_presentors);
                    load (presentors_file,'presentors')  % presentors
                    msg = sprintf(' Running vl_ikmeans...');
                    disp(msg);
                    
%vl_ikmeans_done = 1;
                    vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans__);
                    if ~vl_ikmeans_done
                        [C,A] = vl_ikmeans(presentors,num_of_clusters,'method', 'elkan') ;
                        save (vl_ikmeans_file,'C','A'); 
                    else
                        load (vl_ikmeans_file,'C','A'); 
                    end
                       end
               end
               
               
               % classify training data
                clear clip_num
                %vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans__);
                [msg, errmsg] = sprintf('Classify training data... ');
                disp ( msg) ;
                for vc_idx=1: size(training_clips,1)
                    clip_num = training_clips(vc_idx);




                    %[msg, errmsg] = sprintf('\n classify clip num %d \n',clip_num);
                    %disp ( msg) ;


                    fn = sprintf('%.4d',clip_num);
                    file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
                    load(file_name,'desc_norm');
                    if strcmp(descriptor_type,'MIP')
                        desc_norm=uint8(desc_norm');
                    end
                    
                    if isempty(desc_norm)
                        desc_norm = uint8(zeros(size(C,1),1));
                        msg = sprintf('Clip num %d has empty descriptor',clip_num);
                        disp(msg);
                    end

                    classes = vl_ikmeanspush(desc_norm,C) ;
                    
                    fn = sprintf('%.4d',clip_num);    
                    classes_file = sprintf('%s//kmeans_classes_7-%s.mat',output_dir_kmeans_training_set,fn);
                    save (classes_file,'classes')  % classes_1


                    hist_volume = 500;
                    hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
                    fn = sprintf('%.4d',clip_num);
                    hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_training_set,fn);
                    save (hist_file,'hist')  % classes_2
                    fclose('all');
                end
                
                                % classify test set data
                clear clip_num
                %vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans__);
                [msg, errmsg] = sprintf('Classify test data...');
                disp ( msg) ;
                for vc_idx=1: size(test_clips,1)
                    clip_num = test_clips(vc_idx);
                    %[msg, errmsg] = sprintf('\n classify clip num %d \n',clip_num);
                    %disp ( msg) ;
                    fn = sprintf('%.4d',clip_num);
                    file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_test_set,fn); 
                    load(file_name,'desc_norm');
                    if strcmp(descriptor_type,'MIP')
                        desc_norm=uint8(desc_norm');
                    end
                    
                    if isempty(desc_norm)
                        desc_norm = uint8(zeros(size(C,1),1));
                        msg = sprintf('Clip num %d has empty descriptor',clip_num);
                        disp(msg);
                    end
                    
                    classes = vl_ikmeanspush(desc_norm,C) ;
                    
                    fn = sprintf('%.4d',clip_num);    
                    classes_file = sprintf('%s//kmeans_classes_7-%s.mat',output_dir_kmeans_test_set,fn);
                    save (classes_file,'classes')  % classes_1
                    


                    hist_volume = 500;
                    hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
                    fn = sprintf('%.4d',clip_num);
                    hist_file = sprintf('%s//hist_7-%s.mat',output_dir_hist_test_set,fn);
                    save (hist_file,'hist')  % classes_2
                    fclose('all');
                end
               

                t_elapsed = toc(tStart_integer_kmeans);
                [msg, errmsg] = sprintf('integer_kmeans time = %d seconds',uint32(t_elapsed));
                disp ( msg) ;
            end


        end


        %{
        hist_volume = 500;
        s_clip = 1;
        e_clip = 2300;
        kmean_nsbsp_file = sprintf('%s/kmeans_nsbsp_part_1.mat',output_dir); 
        load (kmean_nsbsp_file); %nSubSpaces_so_far
        classes_1_file = sprintf('%s/kmeans_classes_1.mat',output_dir);
        load (classes_1_file)  % classes_1
        num_of_clusters = max(classes_1);
        build_norm_histogram(nSubSpaces_so_far,classes_1,hist_volume,num_of_clusters ,output_dir_hist);

        s_clip = 2301;
        e_clip = 3400;
        kmean_nsbsp_file = sprintf('%s/kmeans_nsbsp_part_2.mat',output_dir); 
        load (kmean_nsbsp_file); %nSubSpaces_so_far
        classes_2_file = sprintf('%s/kmeans_classes_2.mat',output_dir);
        load (classes_2_file)  % classes_2
        num_of_clusters = max(classes_2);
        build_norm_histogram(nSubSpaces_so_far,classes_2,hist_volume,num_of_clusters ,output_dir_hist);
        %}
    end
   
end

