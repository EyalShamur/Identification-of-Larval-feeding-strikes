
function [res] = a0_svm_nested_fold_for_best_ACC(hist_dir, fold_idx,folds_type)
%close all
%clear all

[globals, DB_dir, vidext] = prerun_header();
rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');


clear fold_clips
clear fold_tags
clear accuracy_

acc_idx = 0;

fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
load(fold_file); % get fold_clips,fold_tags 
fold_tags=int32(fold_tags);
fold_tags(find(fold_tags==0))=-1; 

[n_clips_per_fold, n_folds ]=size(fold_tags);
clear train_mat
clear training_label_vector

testing_label_vector_all=[];
%probability_values_all=[];
decision_values_all=[];


msg = sprintf(' MBH: SVM...'); 
disp(msg);

 

 
    
    for test_idx = 1:n_folds
        if test_idx == fold_idx
            continue;
        end

        
         % build training set vector and test set vector of clip names
        clear training_clips;
        training_clips = [];
        training_tags = [];
    
        for train_idx=1:n_folds
            if (train_idx ~= fold_idx) && (train_idx ~= test_idx) 
                training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
                training_tags = [training_tags;squeeze(fold_tags(:,train_idx))];
            end
        end


        test_clips = squeeze(fold_clips(:,test_idx));
        test_tags =  squeeze(fold_tags (:,test_idx));







        local_i=0;
       
        n_clips_for_training = size(training_clips,1);


        for i=1:n_clips_for_training % training clips




            f1 = sprintf('%.4d',training_clips(i));


            %msg = sprintf('***************  MBH: TRAINING : featur vector of fold %d indx %d clip %s  ***************\n',...
            %                                  fold_idx,i,f1); 
            %fprintf(msg); 
            local_i=local_i+1;






            hist_file = sprintf('%s/hist_7-%s_for_kmean.mat',hist_dir,f1);
            load (hist_file,'hist')  % hist
            nonnn = isnan(hist);
            idx_none=find(nonnn==1);
            if ~isempty(idx_none)
                hist=0;
            end


            hist = sqrt(hist);







            train_mat(local_i,:)=double(hist);
            training_label_vector(local_i,1)=double(training_tags(i));


            fclose('all');    
        end


         % scale
         [scaled_mat_train,shift, m,  num_of_bad_bins] = my_scale(train_mat);
         
         if num_of_bad_bins > 0.1*size(train_mat,2)
             disp(sprintf('Too many zeros bins %d/%d',num_of_bad_bins,size(train_mat,2)));
             %res=0;
             %return;
         end



             %{

        -s 3 -p 0.1 -t 0

        options:
        -s svm_type : set type of SVM (default 0)
            0 -- C-SVC		(multi-class classification)
            1 -- nu-SVC		(multi-class classification)
            2 -- one-class SVM	
            3 -- epsilon-SVR	(regression)
            4 -- nu-SVR		(regression)
        -t kernel_type : set type of kernel function (default 2)
            0 -- linear: u'*v
            1 -- polynomial: (gamma*u'*v + coef0)^degree
            2 -- radial basis function: exp(-gamma*|u-v|^2)
            3 -- sigmoid: tanh(gamma*u'*v + coef0)
            4 -- precomputed kernel (kernel values in training_set_file)
        -d degree : set degree in kernel function (default 3)
        -g gamma : set gamma in kernel function (default 1/num_features)
        -r coef0 : set coef0 in kernel function (default 0)
        -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
        -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
        -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
        -m cachesize : set cache memory size in MB (default 100)
        -e epsilon : set tolerance of termination criterion (default 0.001)
        -h shrinking : whether to use the shrinking heuristics, 0 or 1 (default 1)
        -b probability_estimates : whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
        -wi weight : set the parameter C of class i to weight*C, for C-SVC (default 1)
        -v n: n-fold cross validation mode
        -q : quiet mode (no outputs)


        The k in the -g option means the number of attributes in the input data.

        option -v randomly splits the data into n parts and calculates cross
        validation accuracy/mean squared error on them.


        %}






        %fprintf(sprintf('\n\nSplit %d\n',fold_idx));
        %fprintf('-------------\n');
        %fprintf('\n\nrunning svmtrain...\n');

        model = svmtrain(training_label_vector, scaled_mat_train, ' -s 1 -t 2 -q' );
        %model = svmtrain(training_label_vector, scaled_mat_train, '-t 2 -q -b 1' );
        %model = svmtrain(scaled_mat_train,training_label_vector, 'kernel_function','rbf' );









        n_clips_for_test = size(test_clips,1);
        local_i=0;
        for i=1:n_clips_for_test % training clips




            f1 = sprintf('%.4d',test_clips(i));

            %msg = sprintf('***************  MBH: TEST : featur vector of fold %d indx %d clip %s  ***************\n',...
            %                                  fold_idx,i,f1);   
            %fprintf(msg); 
            local_i=local_i+1;






            hist_file = sprintf('%s/hist_7-%s_for_kmean.mat',hist_dir,f1);
            load (hist_file,'hist')  % hist
            nonnn = isnan(hist);
            idx_none=find(nonnn==1);
            if ~isempty(idx_none)
                hist=0;
            end


            hist = sqrt(hist);







            test_mat(local_i,:)=double(hist);
            testing_label_vector(local_i,1)=double(test_tags(i));

            fclose('all');
        end


        % scale    
        for i=1:size(test_mat,1)
            %shift to 0
            scaled_mat_test(i,:) = test_mat(i,:)+shift;

            %scale to be in the interval(0...1)
            scaled_mat_test(i,:) = scaled_mat_test(i,:).*m;
        end




        %{
    The function 'svmpredict' has three outputs. 

    The first one,
    predictd_label, is a vector of predicted labels. 

    The second output,
    accuracy, is a vector including accuracy (for classification), mean
    squared error, and squared correlation coefficient (for regression).

    The third is a matrix containing decision values or probability
    estimates (if '-b 1' is specified). If k is the number of classes
    in training data, for decision values, each row includes results of 
    predicting k(k-1)/2 binary-class SVMs. For classification, k = 1 is a
    special case. Decision value +1 is returned for each testing instance,
    instead of an empty vector. For probabilities, each row contains k values
    indicating the probability that the testing instance is in each class.
    Note that the order of classes here is the same as 'Label' field
    in the model structure.  
    %}



        [predicted_label, accuracy, decision_values] = ...
            svmpredict(testing_label_vector, scaled_mat_test, model);












            %[predicted_label, accuracy, prob_values] = ...
            %svmpredict(testing_label_vector, scaled_mat_test, model, '-b 1');
            
        acc_idx = acc_idx+1;
        accuracy_(acc_idx) = accuracy(1,1);

        end
        
        res = mean(accuracy_);
        
        
    
    end