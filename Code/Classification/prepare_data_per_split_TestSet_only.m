function [res] = prepare_data_per_split_TestSet_only(i_tries, descriptor_type,descriptor_folder,model_type,database,folds_type)

    main_desc_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',database,model_type,descriptor_folder);


    output_dir_hist = sprintf('%s\\HISTOGRAM_1024',main_desc_dir); 
    output_dir_kmeans = sprintf('%s\\KMEANS_1024',main_desc_dir); 
    dir_desc = sprintf('%s\\DESCRIPTOR',main_desc_dir); 
    output_dir_norm = sprintf('%s\\NORM',main_desc_dir); 
    output_dir_prs = sprintf('%s\\KMEANS_PRESENTORS',main_desc_dir); 
    output_dir_ikmeans_res_dir = sprintf('%s\\KMEANS_DATA',main_desc_dir);
    if ~my_create_dir(output_dir_hist); return; end; 
    if ~my_create_dir(output_dir_kmeans); return; end;
    if ~my_create_dir(dir_desc); return; end;
    if ~my_create_dir(output_dir_norm); return; end;
    if ~my_create_dir(output_dir_prs); return; end;
    if ~my_create_dir(output_dir_ikmeans_res_dir); return; end;
    

    if i_tries==1
        prepare_done = false;
        norm_done = false;
        kmeans_done = false;
    else
        prepare_done = true;
        norm_done = true;
        kmeans_done = false;
    end  
    
    modus=5;
    if mod(i_tries,modus)==1
        presentors_done = false;
    else
        presentors_done = true;
    end
    

 
    clear fold_clips
    clear fold_tags
    fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
    load(fold_file); % get fold_clips,fold_tags  
 



    [n_clips_per_fold, n_folds ]=size(fold_tags);

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

        output_dir_kmeans_C_A = sprintf('%s\\test_num_%d\\FOLD_%.2d_TRAINING_SET',output_dir_ikmeans_res_dir,i_tries,fold_idx);
        if ~my_create_dir(output_dir_kmeans_C_A); return; end;
        
        
        pr_id = uint32(floor((i_tries-1)/modus))+1;
        
        output_dir_kmeans_presentors = sprintf('%s\\test_group_%d\\FOLD_%.2d_TRAINING_SET',output_dir_prs,pr_id,fold_idx);
        if ~my_create_dir(output_dir_kmeans_presentors); return; end;
        
        

    
        
        
        
        % build training set vector and test set vector of clip names
        clear training_clips;
        %training_clips = [];
        all_clips_per_fold = [];
        for train_idx=1:n_folds
            all_clips_per_fold = [all_clips_per_fold squeeze(fold_clips(:,train_idx))];
            %if train_idx ~= fold_idx
            %    training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
            %end
        end
        test_clips = squeeze(fold_clips(:,fold_idx));

        
        if ~prepare_done
            switch descriptor_type
                case 'MBH'
                    %[max_all, min_all] = find_min_max_MBH_per_fold(main_desc_dir,training_clips);
                    [dummy1, dummy2  ] = find_min_max_MBH_per_fold(main_desc_dir,test_clips);
                case 'VIF'
                    %[max_all, min_all] = find_min_max_VIF_per_fold(dir_desc,training_clips);
                    [dummy1, dummy2  ] = find_min_max_VIF_per_fold(dir_desc,test_clips);
                case 'MIP'
                    %disp(' Copy files..');
                    %cmd = sprintf('copy "%s\\*.mat" "%s" >nul',main_desc_dir,dir_desc);
                    %system(cmd);
                    %[max_all, min_all] = find_min_max_MIP_per_fold(dir_desc,training_clips);
                    [dummy1, dummy2  ] = find_min_max_MIP_per_fold(dir_desc,test_clips);
                case 'STIP'
                    %[max_all, min_all] = find_min_max_STIP(main_desc_dir,training_clips);
                    [dummy1, dummy2  ] = find_min_max_STIP(main_desc_dir,test_clips);
            end
            
            %save(min_max_file,'max_all','min_all');
        end


        
        if ~norm_done
            load(min_max_file,'max_all','min_all');
            % normalize to the UINT8 within interval [0 255]

    
            

            %for training set
            %kmeans_norm_data_per_fold(descriptor_type , ...
            %    dir_desc,output_dir_norm_training_set,max_all, min_all, training_clips);  % 3697
            %for test set
            kmeans_norm_data_per_fold(descriptor_type , ...
                dir_desc,output_dir_norm_test_set,max_all, min_all, test_clips);  % 3697
        end





        
        
        switch descriptor_type
            case 'MBH'
                num_of_clusters = 512;  % 64: must be 4^tree_height. in this case tree_height=3
                                        % 256: must be 4^tree_height. in this case tree_height=4
                                        % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'VIF'
                num_of_clusters = 64; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'MIP'
                num_of_clusters = 1024; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
            case 'STIP'
                num_of_clusters = 512; % 1024: must be 4^tree_height. in this case tree_height=5
                                        % 4096: must be 4^tree_height. in this case tree_height=6
        end

        n_presentors = 50000;  % 1000
        if(~kmeans_done ) %&& ~strcmp(descriptor_type,'VIF')
        %if(~hi_kmeans_done && ~strcmp(descriptor_type,'VIF'))
            tStart=tic;

            

            
            use_hirarchical_integer_kmeans = 0;
            use_integer_kmeans = 1;
            use_multiple_kmeans = 0;
            
            % Heirarchichal Integer K-means
            if use_hirarchical_integer_kmeans
                K=4; % num of branches for vertex ( num os sons)
                nleaves = num_of_clusters; 

                
                
                
                
                

                



                % classify test set data
                load (vl_hikmeans_file,'tree','A');
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
                

               

                    
                         
                    
              
               
               
               

                
                % classify test set data
                vl_ikmeans_file = sprintf('%s//vl_ikmeans_file.mat',output_dir_kmeans_C_A);
                load (vl_ikmeans_file,'C','A');
                clear clip_num
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
               

 
            end


        end


 
    end
end

