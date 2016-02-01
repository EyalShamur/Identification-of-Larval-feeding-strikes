function [best_C,best_A,res] = multiple_integer_kmeans_for_best_ACC_per_fold...
                    (training_clips_per_fold, n_presentors,num_of_clusters,kmean_param, ...
                     kmean_method, presentors_done,descriptor_type,output_dir_norm_training_set,output_dir_hist, ...
                     descriptor_folder,model_type,database,folds_type,output_dir_hist_training_set,fold_idx)


    best_ACC=0;
    




        
        
    for n_try=1:1
        
        % Fetch new presentors every 4 tries
        %if mod(n_try,4)==1
        
            presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_hist);
            if(~presentors_done)
                presentors_per_fold = get_rand_agents_per_fold( fold_idx , n_presentors, descriptor_type, training_clips_per_fold,output_dir_norm_training_set);
                save (presentors_file,'presentors_per_fold');  % classes_2
            else 
                load (presentors_file,'presentors_per_fold');  % classes_2
            end
        %end
        
        
        for sub_fold_idx_for_test = 1:size(training_clips_per_fold,2)
            if sub_fold_idx_for_test == fold_idx
                sum_dist_sqr(sub_fold_idx_for_test) = 0;
                ACC(sub_fold_idx_for_test,1) = 0;
                total_n_desc(sub_fold_idx_for_test) = 0;
                continue;
            end
            training_clips = [];
            presentors = [];
            for train_fold_idx=1:size(training_clips_per_fold,2)
                if train_fold_idx == fold_idx
                    continue;
                end
                if train_fold_idx == sub_fold_idx_for_test
                    continue;
                end
                    training_clips = [training_clips; training_clips_per_fold(:,train_fold_idx)];
                    presentors = [presentors  squeeze(presentors_per_fold(:,train_fold_idx,:))];
                
            end
            test_clips = training_clips_per_fold(:,sub_fold_idx_for_test);
            training_and_test_clips = [training_clips;  test_clips];
            

        

            % Integer K-means
            msg = ' vl_ikmeans...';
            fprintf(msg);
            start_time = tic;

            [C(sub_fold_idx_for_test,:,:),A(sub_fold_idx_for_test,:)] = vl_ikmeans(presentors,num_of_clusters,kmean_param, kmean_method) ;
            duration = toc(start_time);
            fprintf(sprintf(' Time: %d  min, %d  sec\n',floor(duration/60), floor(mod(duration,60))));


            err_sum=0;
            n_presentors = size(presentors,2);
            err_idx=0;


            % Assign K-means centers
            msg = ' vl_ikmeanspush ( Assign K-means centers )...';
            fprintf(msg);
            start_time = tic;
            sum_dist_sqr(sub_fold_idx_for_test)=0;
            total_n_desc(sub_fold_idx_for_test)=1; % init with 1 and not with 0 to avoid devide by zero later on.
            for vc_idx=1: size(training_and_test_clips,1)
                clip_num = training_and_test_clips(vc_idx);




                %[msg, errmsg] = sprintf('\n classify clip num %d \n',clip_num);
                %disp ( msg) ;


                fn = sprintf('%.4d',clip_num);
                file_name = sprintf('%s//kmeans_data_norm_7-%s.mat',output_dir_norm_training_set,fn); 
                load(file_name,'desc_norm');
                if strcmp(descriptor_type,'MIP')
                    desc_norm=uint8(desc_norm');
                end

                classes = vl_ikmeanspush(desc_norm,squeeze(C(sub_fold_idx_for_test,:,:))) ;

                hist_volume = 500;
                hist = build_norm_histogram(classes',hist_volume,num_of_clusters);
                fn = sprintf('%.4d',clip_num);
                hist_file = sprintf('%s//hist_7-%s_for_kmean.mat',output_dir_hist_training_set,fn);
                save (hist_file,'hist')  % classes_2
                fclose('all');
                
                curr_C = squeeze(C(sub_fold_idx_for_test,:,:));
                dist = curr_C(:,classes) - int32(desc_norm);
                for el_idx=1:size(desc_norm,2)
                    dist_sqr = single(dist(:,el_idx)')*single(dist(:,el_idx));
                    sum_dist_sqr(sub_fold_idx_for_test) = sum_dist_sqr(sub_fold_idx_for_test)+dist_sqr;
                end
                total_n_desc(sub_fold_idx_for_test) = total_n_desc(sub_fold_idx_for_test)+size(desc_norm,2);

            end
            duration = toc(start_time);
            fprintf(sprintf(' Time: %d  min, %d  sec\n',floor(duration/60), floor(mod(duration,60))));

            %fold_idx=2;
            ACC(sub_fold_idx_for_test,1) = a0_svm_10_splits_MBH_Database_B_for_best_ACC_per_fold...
                (output_dir_hist_training_set, fold_idx, sub_fold_idx_for_test, descriptor_type,descriptor_folder,model_type,database,0,folds_type);
            disp(sprintf(' Fold %d: Accuracy of try num %d = %f',fold_idx,n_try,ACC(sub_fold_idx_for_test,1)));



        end
            mean_ACC = single(sum(ACC))/single((size(training_clips_per_fold,2)-1));
            all_n_desc = sum(total_n_desc);
            mean_dist = single(sum(sum_dist_sqr))/single(all_n_desc);
            if mean_ACC > best_ACC
                best_mean_ACC = mean_ACC;
                best_idx = find(ACC==max(ACC));
                best_ACC = ACC(best_idx(1));
                best_Cs = C;
                best_As = A;
                best_dist = mean_dist;
                %save (presentors_file,'presentors_per_fold');
            end
            msg=sprintf(' Best mean_ACC found till try num %d is : %d',n_try, best_mean_ACC);        
            disp(msg);

    end

    best_C = squeeze(best_Cs(best_idx(1),:,:));
    best_A = squeeze(best_As(best_idx(1),:));
    res = [single(best_ACC) single(best_mean_ACC) single(best_dist)];
            
end