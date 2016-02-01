function [C,A,res] = multiple_integer_kmeans(d_len,training_clips, n_presentors,num_of_clusters,kmean_param, kmean_method, presentors_done,descriptor_type,output_dir_norm_training_set,output_dir_hist)

    min_err_sum=999999999999999;
    min_err_std = 99999999999999999;
    presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_hist);
    
    
    for n_try=1:10
        %if mod(n_try,5)==1
        %    presentors_file = sprintf('%s//kmean_presentors.mat',output_dir_hist);
        %    if(~presentors_done)
                 presentors = get_rand_agents(d_len, n_presentors, descriptor_type, training_clips,output_dir_norm_training_set);
        %        save (presentors_file,'presentors');  % classes_2
        %    else 
        %        load (presentors_file,'presentors');  % classes_2
        %    end

        %end
        
        
        [C,A] = vl_ikmeans(presentors,num_of_clusters,kmean_param, kmean_method) ;
        err_sum=0;
        n_presentors = size(presentors,2);
        err_idx=0;
        
        
        
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
            
            classes = vl_ikmeanspush(desc_norm,C) ;

            for desc_idx=1:size(desc_norm,2)
                %curr_center = tree.sub(A(1,pres_idx)).sub(A(2,pres_idx)).sub(A(3,pres_idx)).centers(:,(A(4,pres_idx)));

                curr_center = C(:,classes(desc_idx));
                dist = single(curr_center)-single(desc_norm(:,desc_idx));
                err = (dist')*dist;
                %err_sum=err_sum+err;
                err_idx=err_idx+1;
                err_vector(err_idx)=err;

            end
        end
        %std_symetric = [err_vector -err_vector];
        %err_std = std(std_symetric);  % make it symetric arround the zero.
                                                   % we wand to calc std
                                                   % arround the zero point
        %if err_std < min_err_std
        %    min_err_std = err_std;
        %    best_C = C;
        %    best_A = A;      
        %end
%msg=sprintf('err_std = %d',err_std);        
%disp(msg);
        err_sum = sum(err_vector');
        if err_sum < min_err_sum
            min_err_sum = err_sum;
            best_C = C;
            best_A = A; 
            best_presentors = presentors;
        end
msg=sprintf('err_sum = %d',err_sum);        
disp(msg);


    end
    msg=sprintf('min_err_sum = %d',min_err_sum);        
    disp(msg);
    presentors = best_presentors;
    C=best_C;
    A=best_A;
    res = min_err_sum;
    save (presentors_file,'presentors');
            
end