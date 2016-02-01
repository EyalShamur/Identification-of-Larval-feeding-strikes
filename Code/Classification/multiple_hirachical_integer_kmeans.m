function [best_tree, best_A, res] = multiple_hirachical_integer_kmeans...
                        (multiple_kmeans_type, d_len, training_clips, n_presentors,num_of_clusters,K,kmean_param, ...
                     kmean_method, presentors_done,descriptor_type,output_dir_norm_training_set,output_dir_hist, ...
                     descriptor_folder,model_type,database,folds_type,output_dir_hist_training_set,fold_idx)

 
    min_err_sum=999999999999999;
                   
    best_ACC=0;
    
    nleaves = num_of_clusters;  
    % data has clmn wise representation. ie. each clmn represents a point
                
                    
    n_tries_ = 3;                
    for n_try=1:n_tries_
        % Fetch new presentors every 4 tries
        %if mod(n_try,8)==1
                presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_hist);
            %if(~presentors_done)
                presentors = get_rand_agents(d_len, n_presentors, descriptor_type, training_clips,output_dir_norm_training_set);

            %else 
            %    load (presentors_file,'presentors');  % classes_2
            %end
        %end
        % Integer Hirarchical K-means
        msg = ' vl_hikmeans...';
        fprintf(msg);
        start_time = tic;
        [tree,A] = vl_hikmeans(presentors,K,nleaves,kmean_param, kmean_method) ;
        duration = toc(start_time);
        fprintf(sprintf(' Time: %d  min, %d  sec\n',floor(duration/60), floor(mod(duration,60))));
        
        
        
        if multiple_kmeans_type == 1       
            err_sum=0;
            for pres_idx=1:size(presentors,2)
                %curr_center = tree.sub(A(1,pres_idx)).sub(A(2,pres_idx)).sub(A(3,pres_idx)).centers(:,(A(4,pres_idx)));
                sub_tree = tree.sub(A(1,pres_idx));
                for depth=2:tree.depth-1
                    sub_tree = sub_tree.sub(A(depth,pres_idx));
                end

                    curr_center = sub_tree.centers(:,(A(tree.depth,pres_idx)));
                    dist = single(curr_center)-single(presentors(:,pres_idx));
                    err = (dist')*dist;
                    err_sum=err_sum+err;


            end

            if err_sum < min_err_sum
                min_err_sum = err_sum;
                best_tree = tree;
                best_A = A;
                res = min_err_sum;
                save (presentors_file,'presentors');  % classes_2
            end
        end
                        

                        
                        
        if multiple_kmeans_type == 2 || multiple_kmeans_type==3                
            % Assign K-means centers
            msg = ' vl_hikmeanspush ( Assign Hirarchical K-means centers )...';
            fprintf(msg);
            start_time = tic;
            
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

     
                hist_volume = 500;
                hist = build_norm_histogram(classes,hist_volume,num_of_clusters);
                fn = sprintf('%.4d',clip_num);
                hist_file = sprintf('%s//hist_7-%s_for_kmean.mat',output_dir_hist_training_set,fn);
                save (hist_file,'hist')  % classes_2
                fclose('all');


            end


            
            if multiple_kmeans_type == 2 
                ACC = a0_svm_self_svm_for_best_ACC... 
                    (output_dir_hist_training_set, fold_idx, folds_type);
            end
            
            if multiple_kmeans_type == 3 % devide taraining set into n folds of train/test sets and cheeach seperately
                ACC = a0_svm_nested_fold_for_best_ACC...
                    (output_dir_hist_training_set, fold_idx, folds_type);
            end
            
            
            disp(sprintf(' Fold %d: Mean Accuracy of try num %d = %f',fold_idx,n_try,ACC));


            if ACC >= best_ACC
                best_ACC = ACC;
                best_tree = tree;
                best_A = A;
                res = best_ACC;
                save (presentors_file,'presentors');  % classes_2
            end

            duration = toc(start_time);
            fprintf(sprintf(' Time: %d  min, %d  sec\n',floor(duration/60), floor(mod(duration,60))));            
        end
        

        
        
        
        
    end
    msg=sprintf(' Best_ACC found till try num %d is : %d',n_tries_, best_ACC);        
    disp(msg);

                 
end
                    