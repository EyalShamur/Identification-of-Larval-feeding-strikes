
function [res] = a0_svm_10_splits_VIF_Database_B_per_fold(descriptor_type,descriptor_folder,model_type,database,use_hist_pca,folds_type,i_tries)

    %close all
    %clear all

    [globals, DB_dir, vidext] = prerun_header();


    %histogram_pca=0;
    %histogram_1024=1;
    scale = 1;


    self_test=0;
    copy_clips = 0;
    clear fold_clips
    clear fold_tags
    fold_file = sprintf('H:\\thesis - eating fishes\\Code\\Classification\\%s.mat',folds_type);
    load(fold_file); % get fold_clips,fold_tags 
    fold_tags=int32(fold_tags);
    fold_tags(find(fold_tags==0))=-1;  
    
    if strcmp(database, 'A')
        if copy_clips 
            dir_in = 'H:\thesis - eating fishes\DATABASES\Database-A\DB';
        end
    end

    if strcmp(database, 'B')
        if copy_clips 
            dir_in = 'H:\thesis - eating fishes\DATABASES\Database-B\DB';
        end
    end


    [n_clips_per_fold, n_folds ]=size(fold_tags);
    clear train_mat
    clear training_label_vector

    testing_label_vector_all=[];
    %probability_values_all=[];
    decision_values_all=[];



for fold_idx=1:n_folds
 
    % build training set vector and test set vector of clip names
    clear training_clips;
    training_clips = [];
    training_tags = [];
    for train_idx=1:n_folds
        if train_idx ~= fold_idx
            training_clips = [training_clips;squeeze(fold_clips(:,train_idx))];
            training_tags = [training_tags;squeeze(fold_tags(:,train_idx))];
        end
    end
    test_clips = squeeze(fold_clips(:,fold_idx));
    test_tags = squeeze(fold_tags(:,fold_idx));
    
    
    
    
    if use_hist_pca
        vif_histogram_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\PCA_HIST_SQRT\\test_num_%d',database,model_type,descriptor_folder,i_tries);
        output_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\SVM_PCA\\test_num_%d',database,model_type,descriptor_folder,i_tries);
    else
        %vif_histogram_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\NORM',database,model_type,descriptor_folder);
        vif_histogram_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\HISTOGRAM_1024\\test_num_%d',database,model_type,descriptor_folder,i_tries);

        output_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\SVM\\test_num_%d',database,model_type,descriptor_folder,i_tries);
    end
    if ~my_create_dir(output_dir); return; end;
    vif_histogram_dir_for_training_set = sprintf('%s\\FOLD_%.2d_TRAINING_SET',vif_histogram_dir,fold_idx);
    vif_histogram_dir_for_test_set = sprintf('%s\\FOLD_%.2d_TEST_SET',vif_histogram_dir,fold_idx);

    
            
   


    local_i=0;
    start_time = tic;
    n_clips_for_training = size(training_clips,1);
    for i=1:n_clips_for_training % training clips




        f1 = sprintf('%.4d',training_clips(i));


        %msg = sprintf('***************  VIF: TRAINING : featur vector of fold %d indx %d clip %s  ***************\n',...
        %                                  fold_idx,i,f1); 
        %fprintf(msg); 
        local_i=local_i+1;


        
        
         hist_file = sprintf('%s/hist_7-%s.mat',vif_histogram_dir_for_training_set,f1);
        load (hist_file,'hist')  % hist

        
        %hist_file = sprintf('%s/kmeans_data_norm_7-%s.mat',vif_histogram_dir_for_training_set,f1);
        %load (hist_file,'desc_norm')  % hist

        %nonnn = isnan(desc_norm);
        nonnn = isnan(hist);
        idx_none=find(nonnn==1);
        if ~isempty(idx_none)
            %desc_norm=0;
            hist=0;
        end
        
        hist=manipulate_hist(hist);






        %train_mat(local_i,:)=double(desc_norm);
        train_mat(local_i,:)=double(hist);
        training_label_vector(local_i,1)=double(training_tags(i));


        fclose('all');    
    end
        
     
     if scale
        [scaled_mat_train,shift, m] = my_scale(train_mat);

        % scale test
        %scaled_mat_test = zeros(size(test_mat));
        %for scale_idx=1:size(test_mat,2)
        %    scaled_mat_test(:,scale_idx)=(test_mat(:,scale_idx)+shift(scale_idx))*m(scale_idx);
        %end
     else
         scaled_mat_train = train_mat;

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



    


    fprintf(sprintf('\n\nSplit %d\n',fold_idx));
    fprintf('-------------\n');
    fprintf('\n\nrunning svmtrain...\n');
rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
    model = svmtrain(training_label_vector, scaled_mat_train, ' -s 1 -t 0' );
    %model = svmtrain(training_label_vector, scaled_mat_train, '-t 2 -q -b 1' );
    %model = svmtrain(scaled_mat_train,training_label_vector, 'kernel_function','rbf' );
    
    
    
    
    
    n_clips_for_test = size(test_clips,1);
    local_i=0;
    for i=1:n_clips_for_test % training clips




        f1 = sprintf('%.4d',test_clips(i));

        %msg = sprintf('***************  VIF: TEST : featur vector of fold %d indx %d clip %s  ***************\n',...
        %                                  fold_idx,i,f1);   
        %fprintf(msg); 
        local_i=local_i+1;


        
        
        

        hist_file = sprintf('%s/hist_7-%s.mat',vif_histogram_dir_for_test_set,f1);
        load (hist_file,'hist')  % hist
        %hist_file = sprintf('%s/kmeans_data_norm_7-%s.mat',vif_histogram_dir_for_test_set,f1);
        %load (hist_file,'desc_norm')  % hist

        %nonnn = isnan(desc_norm);
        nonnn = isnan(hist);
        idx_none=find(nonnn==1);
        if ~isempty(idx_none)
            %desc_norm=0;
            hist=0;
        end
        
        hist=manipulate_hist(hist);






        %test_mat(local_i,:)=double(desc_norm);
        test_mat(local_i,:)=double(hist);
        testing_label_vector(local_i,1)=double(test_tags(i));
        
        fclose('all');
    end
    
    if scale
        % scale test
        %scaled_mat_test = zeros(size(test_mat));
        %for scale_idx=1:size(test_mat,2)
        %    scaled_mat_test(:,scale_idx)=(test_mat(:,scale_idx)+shift(scale_idx))*m(scale_idx);
        %end
        %scaled_mat_test = (test_mat+shift).*m;
        
        for i=1:size(test_mat,1)
            %shift to 0
            scaled_mat_test(i,:) = test_mat(i,:)+shift;

            %scale to be in the interval(0...1)
            scaled_mat_test(i,:) = scaled_mat_test(i,:).*m;
        end
            
                    
     else

         scaled_mat_test = test_mat;

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
    
    [training_predicted_label, training_accuracy, training_decision_values] = ...
        svmpredict(training_label_vector, scaled_mat_train, model);  
    
     
        %[predicted_label, accuracy, prob_values] = ...
        %svmpredict(testing_label_vector, scaled_mat_test, model, '-b 1');
    
    accuracy_ = accuracy(1,1);
    accuracy_
    accuracy_all(fold_idx)=accuracy_/100.0;
    [tpr, tnr, info] = vl_roc(testing_label_vector, decision_values(:,1),'plot','truenegatives') ;
    check_it=0;
    if check_it
        d = decision_values(:,1);
        [d_sort idx] = sort(d,'descend');
        lbl_sort = testing_label_vector(idx);
        check_mat = [lbl_sort d_sort];
        correctness_score = testing_label_vector.*decision_values(:,1);
        correctness=zeros(size(correctness_score));
        correctness(find(correctness_score>0))=1;
        check_mat = [check_mat correctness];
    
    end
    AUC = info.auc;
%{    
addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m
    [X,Y,T,AUC] = perfcurve(testing_label_vector,decision_values(:,1),double(1));
    %[X,Y,T,AUC] = perfcurve(testing_label_vector,prob_values(:,1),double(1));
rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
%}
plot_auc = 0;
if plot_auc
    figure(fold_idx)
    plot(tpr,tnr);
    xlabel('False positive rate'); ylabel('True positive rate');
    ttl=sprintf('ROC for classification split %d by SVM',fold_idx);
    title(ttl);
end

    fprintf('AUC=%.8f',AUC);
%{
    prediction_all(:,fold_idx)=predicted_label;
    auc_all(fold_idx)=AUC;
    prob_all(:,fold_idx) = prob_values(:,1);
    output_accuracy =  sprintf('%s/split_%d_accuracy.mat',output_dir,fold_idx);
    output_probability = sprintf('%s/split_%d_probability.mat',output_dir,fold_idx);
    output_prediction = sprintf('%s/split_%d_prediction.mat',output_dir,fold_idx);
    output_auc = sprintf('%s/split_%d_auc.mat',output_dir,fold_idx);
%notvalid
    save(output_accuracy, 'accuracy');
    save(output_probability,'prob_values');
    save(output_prediction,'predicted_label');
    save(output_auc,'AUC');
    
    testing_label_vector_all=[ testing_label_vector_all; testing_label_vector;];
    probability_values_all=[ probability_values_all; prob_values(:,1);];
    %}
    prediction_all(:,fold_idx)=predicted_label;
    auc_all(fold_idx)=AUC;
    decision_all(:,fold_idx) = decision_values;
    %prob_all(:,fold_idx) = prob_values(:,1);
    output_accuracy =  sprintf('%s/split_%d_accuracy.mat',output_dir,fold_idx);
    
    output_decision = sprintf('%s/split_%d_decision.mat',output_dir,fold_idx);
    output_decision_training = sprintf('%s/split_%d_training_decision.mat',output_dir,fold_idx);
    
    %output_probability = sprintf('%s/split_%d_probability.mat',output_dir,fold_idx);
    output_prediction = sprintf('%s/split_%d_prediction.mat',output_dir,fold_idx);
    output_prediction_training = sprintf('%s/split_%d_training_prediction.mat',output_dir,fold_idx);
    output_training_labels = sprintf('%s/split_%d_training_labels.mat',output_dir,fold_idx);
    output_test_labels = sprintf('%s/split_%d_test_labels.mat',output_dir,fold_idx);
    
    output_auc = sprintf('%s/split_%d_auc.mat',output_dir,fold_idx);
    
%notvalid
    save(output_accuracy, 'accuracy');
    save(output_decision,'decision_values');
    save(output_decision_training,'training_decision_values');
    %save(output_probability,'prob_values');
    save(output_prediction,'predicted_label');
    save(output_prediction_training,'training_predicted_label');
    save(output_training_labels,'training_label_vector');
    
    save(output_test_labels,'testing_label_vector');
    
    
    save(output_auc,'AUC');
    
    testing_label_vector_all=[ testing_label_vector_all; testing_label_vector;];
    decision_values_all=[ decision_values_all; decision_values(:,1);];
    %probability_values_all=[ probability_values_all; prob_values(:,1);];
    
    
     
end




    
    
    
    

     













    %-------------------------------------------------------------------









    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








    

auc_all

% prediction
output_prediction_all =  sprintf('%s/all_prediction.mat',output_dir);
save(output_prediction_all,'prediction_all');

% decision
output_decision =  sprintf('%s/decision.mat',output_dir);
save(output_decision,'decision_all');

% probability
%output_probability =  sprintf('%s/probability.mat',output_dir);
%save(output_probability,'prob_all');

% Accuracy, Standard error
accuracy_avg = mean(accuracy_all);
(accuracy_all)
accuracy_avg
Standard_Error=std(accuracy_all)/sqrt(length(accuracy_all));
Standard_Error
output_accuracy =  sprintf('%s/accuracy.mat',output_dir);
save(output_accuracy,'accuracy_all','accuracy_avg','Standard_Error');
% AUC

[tpr, tnr, info] = vl_roc(testing_label_vector_all, decision_values_all(:,1),'plot','falsepositives') ;
%disp(info.auc) ;

%{
addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m
    %[X,Y,T,AUC] = perfcurve(testing_label_vector_all,probability_values_all(:,1),double(1));
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,decision_values_all(:,1),double(1));
rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
%}

AUC=info.auc;


AUC
output_AUC =  sprintf('%s/AUC.mat',output_dir);
save(output_AUC,'AUC');
plot_auc = 0;
if plot_auc
    figure(fold_idx)
    plot(tpr,tnr);
    xlabel('False positive rate'); ylabel('True positive rate');
    ttl=sprintf('ROC for  VIF ',fold_idx);
    title(ttl);
end



% Confusion Matrix
false_negative = 0;
true_negative = 0;
false_positive = 0;
true_positive = 0;
positive_all = 0;
negative_all = 0;


for fold_idx=1: n_folds
    for clip_idx = 1: n_clips_per_fold
        if fold_tags(clip_idx,fold_idx)==1
            positive_all = positive_all+1;
            if prediction_all(clip_idx,fold_idx)==1
                true_positive = true_positive+1;
            else
                false_positive = false_positive+1;
                
                if copy_clips
                    idx=fold_clips(clip_idx,fold_idx);
                    fname_in = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_in = strcat(dir_in,fname_in);

                    fname_out = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_out = strcat(output_dir,'\\false_positive - eat detected as noneat',fname_out);


                    copy_command = sprintf('copy "%s" "%s"',file_path_in ,file_path_out);
                    system(copy_command);
                end
            end
        end
        
        
        if fold_tags(clip_idx,fold_idx)==-1
            negative_all = negative_all+1;
            if prediction_all(clip_idx,fold_idx)==-1
                true_negative = true_negative+1;
                if copy_clips
                    idx=fold_clips(clip_idx,fold_idx);
                    fname_in = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_in = strcat(dir_in,fname_in);

                    fname_out = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_out = strcat(output_dir,'\\true_negative - noneat detected as noneat',fname_out);


                    copy_command = sprintf('copy "%s" "%s"',file_path_in ,file_path_out);
                    system(copy_command);
                end
                
                
            else
                false_negative = false_negative+1;
                
                if copy_clips
                
                    idx=fold_clips(clip_idx,fold_idx);
                    fname_in = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_in = strcat(dir_in,fname_in);

                    fname_out = sprintf('\\fish_head-%.4d.*',idx);
                    file_path_out = strcat(output_dir,'\\false_negative - noneat detected as eat',fname_out);


                    copy_command = sprintf('copy "%s" "%s"',file_path_in ,file_path_out);
                    system(copy_command);
                end
    
            end
        end
    end
end
true_positive_ratio = true_positive/positive_all;
true_negative_ratio = true_negative/negative_all;
false_negative_ratio = false_negative/negative_all;
false_positive_ratio = false_positive/positive_all;
false_negative_ratio
false_positive_ratio
output_confusion_matrix_all =  sprintf('%s/confusion_matrix.mat',output_dir);
save(output_confusion_matrix_all,'positive_all','negative_all',...
       'true_positive','true_negative','false_negative',...
       'false_positive','true_positive_ratio','true_negative_ratio'...
       ,'false_negative_ratio','false_positive_ratio');
   
   
fprintf('%f\t%f\t%f\t%f\t%f\n\n',accuracy_avg,Standard_Error,AUC,false_negative_ratio,false_positive_ratio);
res = [ accuracy_avg Standard_Error AUC false_negative_ratio false_positive_ratio];


end


function [hist] = manipulate_hist(input_hist)
    hist = input_hist;
    %hist = sqrt(input_hist);

end
