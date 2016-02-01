
function gfgff()
close all
clear all

[globals, DB_dir, vidext] = prerun_header();

A=1;  % Database-A
B=0;  % Database-B
C=0;  % Database-C
D=0;  % Database-D

self_test=0;
copy_clips = 0;


if A
    folds_type = 'Database_A_6x50_folds';
    db = 'A';
    if copy_clips 
        dir_in = 'H:\thesis - eating fishes\DATABASES\Database-A\DB';
    end
    model_type = 'Models_Rot_and_Flip'; 
    
   %{
   desc_folders = {...
        'MBH_patch_size=32\\RUN_ID_1029\\SVM\\test_num_1';...
        'MIP_N12_M12_gap1_T_GL8\\run_id_1023\\SVM_PCA\\test_num_1';...
        'VIF_M=3_N=3\\run_id_1005\\SVM\\test_num_1';...
        'STIP_thresh=0_kparam=0.005_szf=20\\RUN_ID_1025\\SVM\\test_num_1';...
    };
    
        desc_folders = {...
        'MBH_patch_size=32\\RUN_ID_1029\\SVM\\test_num_9';...or 4
        'MIP_orig\\run_id_1003\\SVM_PCA\\test_num_1';...
        'VIF_M=N=3_S=1_T=1.0_H=21\\run_id_1068\\SVM\\test_num_2';...
        'STIP_thresh=0_kparam=0.005_szf=20\\RUN_ID_1025\\SVM\\test_num_3';...or5
    };
    
    
    %}
    desc_folders = {...
        'MBH_patch_size=32\\RUN_ID_1029\\SVM\\test_num_4';...
        %'MIP_N12_M12_gap1_T_GL8\\run_id_1023\\SVM_PCA\\test_num_1';...
        'MIP_orig\\run_id_1003\\SVM_PCA\\test_num_1';...
        %'VIF_M=N=3_S=7_T=1.5_H=21_perCell\\RUN_ID_1019\\SVM\\test_num_1';...
        %'VIF_M=N=3_S=7_T=1.5_H=21\\RUN_ID_1020\\SVM\\test_num_1';...
        'VIF_M=N=3_S=1_T=1.0_H=21\\run_id_1068\\SVM\\test_num_2';...
        %'VIF_orig\\SVM\\test_num_1';...
        'STIP_thresh=0_kparam=0.005_szf=20\\RUN_ID_1025\\SVM\\test_num_3';...
    };

    
end

if B 
    folds_type = 'Database_B_6x50_folds';
    db = 'B';
    if copy_clips 
        dir_in = 'H:\thesis - eating fishes\DATABASES\Database-B\DB';
    end
    model_type = 'Models_300_HI_RES_rot_flip'; 
end
if C
    folds_type = 'Database_C_6x14_folds';
    db = 'C';
    model_type = 'Models_84_HI_RES_rot_flip';
    desc_folders = {...
        'MBH_orig\\RUN_ID_116';...
        'MIP_N24_M24_T_GL8\\RUN_ID_192';...
        'VIF_M=N=1_S=3_T=1.5_perCell\\RUN_ID_231';...
        'STIP_szf=20\\RUN_ID_201';...
    };
end
if D
    folds_type = 'Database_D_6x36_folds';
    db = 'D';
    model_type = 'Models_216_HI_RES_rot_flip';
    
    
    desc_folders = {...
        'MBH_patch_size=64\\RUN_ID_4016';...
        'MIP_optimized N32\\RUN_ID_4020';...
        'VIF_M=N=3_S=8_T=1.5_perCell\\RUN_ID_4001';...
        'STIP_szf=10_margin=30\\RUN_ID_4014';...
    };    
    
end

DB_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s',db);



n_tries=4;
for test_idx = 1:n_tries

%if B    
%    mbh_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\MBH_patch_size=64\\SVM\\test_num_%d',db,model_type,test_idx);
%    mip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\MIP_frame_gap=1_N=32_T_GL=8\\SVM_PCA\\test_num_%d',test_idx);
%    vif_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\VIF_M=N=1_S=3_T=1.5_rt\\SVM\\test_num_1',db,model_type);
%    stip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STIP_szf=10\\SVM\\test_num_%d',db,model_type,test_idx);
%end

%if C
    mbh_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',db,model_type,char(desc_folders(1)));
    mip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',db,model_type,char(desc_folders(2)));
    vif_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',db,model_type,char(desc_folders(3)));
    stip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',db,model_type,char(desc_folders(4)));
  
%end
%if D    
%    mbh_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\MBH_patch_size=64\\SVM\\test_num_%d',db,model_type,test_idx);
%    mip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\MIP_frame_gap=1_N=48_T_GL=6\\SVM_PCA\\test_num_%d',db,model_type,test_idx);
%    vif_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\VIF_M=N=3_S=8_T=1.5_perCell\\SVM\\test_num_1',db,model_type);
%    stip_input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STIP_szf=10_margin=30\\SVM\\test_num_%d',db,model_type,test_idx);
%end
output_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\Models_Rot_and_Flip\\STACKING\\SVM\\test_num_%d',db,test_idx);
if ~my_create_dir(output_dir); return; end;

svm_kernel_type = ' -s 1 -t 0';

clear fold_clips
clear fold_tags
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



for fold_idx=1:n_folds
 
    % build training set vector and test set vector of clip names
    clear training_clips;
    training_desc = [];
    training_tags = [];
    %for train_idx=1:n_folds
    %    if train_idx ~= fold_idx

            % MBH
            clear decision_values
            input_decision = sprintf('%s/split_%d_training_decision.mat',mbh_input_dir,fold_idx);
            load(input_decision,'training_decision_values');
            mbh_decision_values = training_decision_values;
            %clear predicted_label
            %output_prediction = sprintf('%s/split_%d_training_prediction.mat',mbh_input_dir,fold_idx);
            %load(output_prediction,'training_predicted_label');
            %mbh_predicted_label = training_predicted_label;
            
            
            % MIP
            clear decision_values 
            input_decision = sprintf('%s/split_%d_training_decision.mat',mip_input_dir,fold_idx);
            load(input_decision,'training_decision_values');
            mip_decision_values = training_decision_values;
            %clear predicted_label
            %output_prediction = sprintf('%s/split_%d_training_prediction.mat',mip_input_dir,fold_idx);
            %load(output_prediction,'training_predicted_label');
            %mip_predicted_label = training_predicted_label;

            
            
            % VIF
            clear decision_values
            input_decision = sprintf('%s/split_%d_training_decision.mat',vif_input_dir,fold_idx);
            load(input_decision,'training_decision_values');
            vif_decision_values = training_decision_values;
            %clear predicted_label
            %output_prediction = sprintf('%s/split_%d_training_prediction.mat',vif_input_dir,fold_idx);
            %load(output_prediction,'training_predicted_label');
            %vif_predicted_label = training_predicted_label; 
            
            
            % STIP
            clear decision_values
            input_decision = sprintf('%s/split_%d_training_decision.mat',stip_input_dir,fold_idx);
            load(input_decision,'training_decision_values');
            stip_decision_values = training_decision_values;
            %clear predicted_label
            %output_prediction = sprintf('%s/split_%d_training_prediction.mat',stip_input_dir,fold_idx);
            %load(output_prediction,'training_predicted_label');
            %stip_predicted_label = training_predicted_label;
            
            
            %{
            mip_mbh = [mip_decision_values mbh_decision_values];
            %mip_mbh_prediction = [mip_predicted_label mbh_predicted_label];
            mip_mbh_vif = [mip_decision_values mbh_decision_values vif_decision_values];
            %mip_mbh_vif_stip = [mip_decision_values mbh_decision_values vif_decision_values stip_decision_values];
            mip_mbh_stip = [mip_decision_values mbh_decision_values stip_decision_values];
            %mip_mbh_with_predicted_labels = ...
            %    [mip_decision_values mip_predicted_label ...
             %    mbh_decision_values mbh_predicted_label ...
             %    %vif_decision_values vif_predicted_label
             %    ];
            mbh_stip = [mbh_decision_values stip_decision_values];
            mip_stip = [mip_decision_values  stip_decision_values];
            mbh_vif = [mbh_decision_values vif_decision_values];
            mip_vif = [mip_decision_values  vif_decision_values];
            mbh_mip_vif = [mbh_decision_values mip_decision_values  vif_decision_values];
            mbh_mip_stip_vif = [mbh_decision_values mip_decision_values stip_decision_values vif_decision_values];
             bagging_mip_mbh = mip_decision_values+mbh_decision_values;
           bagging_mip_mbh_vif_stip = mip_decision_values+mbh_decision_values+stip_decision_values+vif_decision_values;
           
           %}
            training_desc = get_desc(test_idx, mbh_decision_values, mip_decision_values, stip_decision_values, vif_decision_values);%mip_mbh;%bagging_mip_mbh; %[training_desc;mip_mbh];
            %training_desc = [training_desc;mip_mbh_vif_stip];
            
            input_training_labels = sprintf('%s/split_%d_training_labels.mat',mbh_input_dir,fold_idx);
            load(input_training_labels,'training_label_vector');
            
            training_tags = training_label_vector;
            
    %    end
    %end
    
    % MBH
    clear decision_values
    input_decision = sprintf('%s/split_%d_decision.mat',mbh_input_dir,fold_idx);
    load(input_decision,'decision_values');
    mbh_decision_values = decision_values;
    clear predicted_label
    output_prediction = sprintf('%s/split_%d_prediction.mat',mbh_input_dir,fold_idx);
    load(output_prediction,'predicted_label');
    mbh_predicted_label = predicted_label;
    
    % MIP
    clear decision_values
    input_decision = sprintf('%s/split_%d_decision.mat',mip_input_dir,fold_idx);
    load(input_decision,'decision_values');
    mip_decision_values = decision_values;
    clear predicted_label
    output_prediction = sprintf('%s/split_%d_prediction.mat',mip_input_dir,fold_idx);
    load(output_prediction,'predicted_label');
    mip_predicted_label = predicted_label; 
    
    
    
    % VIF
    clear decision_values
    input_decision = sprintf('%s/split_%d_decision.mat',vif_input_dir,fold_idx);
    load(input_decision,'decision_values');
    vif_decision_values = decision_values;
    clear predicted_label
    output_prediction = sprintf('%s/split_%d_prediction.mat',vif_input_dir,fold_idx);
    %load(output_prediction,'predicted_label');
    %vif_predicted_label = predicted_label; 
 
    
    
    
    % STIP
    clear decision_values
    input_decision = sprintf('%s/split_%d_decision.mat',stip_input_dir,fold_idx);
    load(input_decision,'decision_values');
    stip_decision_values = decision_values;
    %clear predicted_label
    %output_prediction = sprintf('%s/split_%d_training_prediction.mat',stip_input_dir,fold_idx);
    %load(output_prediction,'training_predicted_label');
    %stip_predicted_label = training_predicted_label;
            
            
            

    
    %{        
            
    mip_mbh = [mip_decision_values mbh_decision_values];
    %mip_mbh_prediction = [mip_predicted_label mbh_predicted_label];
    mip_mbh_vif = [mip_decision_values mbh_decision_values vif_decision_values];
    %mip_mbh_vif_stip = [mip_decision_values mbh_decision_values vif_decision_values stip_decision_values];
    mip_mbh_stip = [mip_decision_values mbh_decision_values stip_decision_values];
    mbh_stip = [mbh_decision_values stip_decision_values];
    mip_stip = [mip_decision_values  stip_decision_values];
    mbh_vif = [mbh_decision_values vif_decision_values];
    mip_vif = [mip_decision_values  vif_decision_values];
    mbh_mip_stip_vif = [mbh_decision_values mip_decision_values stip_decision_values vif_decision_values];

    mbh_mip_vif = [mbh_decision_values mip_decision_values  vif_decision_values];
            %mip_mbh_with_predicted_labels = ...
    %    [mip_decision_values mip_predicted_label ...
    %     mbh_decision_values mbh_predicted_label ...
     %    %vif_decision_values vif_predicted_label
     %    ];         
    bagging_mip_mbh = mip_decision_values+mbh_decision_values;
    
    bagging_mip_mbh_vif_stip = mip_decision_values+mbh_decision_values+stip_decision_values+vif_decision_values;
 
    %}
    [test_desc, descriptors ]= get_desc(test_idx, mbh_decision_values, mip_decision_values, stip_decision_values, vif_decision_values);%mip_mbh;%bagging_mip_mbh; %[training_desc;mip_mbh];

    %test_desc = mip_mbh;  %mip_mbh;
    %test_desc = mip_mbh_vif_stip;
    
    %test_tags = squeeze(fold_tags(:,fold_idx));
    input_test_labels = sprintf('%s/split_%d_test_labels.mat',mbh_input_dir,fold_idx);
    load(input_test_labels,'testing_label_vector');
    test_tags = testing_label_vector;
    
    
    
    



    local_i=0;
    start_time = tic;
    %n_clips_for_training = size(training_clips,1);
    




        train_mat=double(training_desc);
        training_label_vector=double(training_tags);


        

     
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

    model = svmtrain(training_label_vector, train_mat, svm_kernel_type );
    %model = svmtrain(training_label_vector, scaled_mat_train, '-t 2 -q -b 1' );
    %model = svmtrain(scaled_mat_train,training_label_vector, 'kernel_function','rbf' );
    
    
    
    
    
    %n_clips_for_test = size(test_clips,1);





        test_mat=double(test_desc);
        testing_label_vector=double(test_tags);
        
   
    
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
        svmpredict(testing_label_vector, test_mat, model);    
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
    %output_probability = sprintf('%s/split_%d_probability.mat',output_dir,fold_idx);
    output_prediction = sprintf('%s/split_%d_prediction.mat',output_dir,fold_idx);
    output_auc = sprintf('%s/split_%d_auc.mat',output_dir,fold_idx);
%notvalid
    save(output_accuracy, 'accuracy');
    save(output_decision,'decision_values');
    %save(output_probability,'prob_values');
    save(output_prediction,'predicted_label');
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
%addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m
    %[X,Y,T,AUC] = perfcurve(testing_label_vector_all,probability_values_all(:,1),double(1));
%if A
%    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,decision_values_all(:,1),double(0));
%end
%if B
%    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,decision_values_all(:,1),double(1));
%end

output_decision_values_all =  sprintf('%s/AUC_params.mat',output_dir);
testing_decision_values_all = decision_values_all;
save(output_decision_values_all,'testing_label_vector_all', 'testing_decision_values_all');

[tpr, tnr, info] = vl_roc(testing_label_vector_all, decision_values_all(:,1),'plot','truenegatives') ;

rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
AUC=info.auc;
AUC
output_AUC =  sprintf('%s/AUC.mat',output_dir);
save(output_AUC,'AUC');
plot_auc = 0;
if plot_auc
    figure(fold_idx)
    plot(tpr,tnr);
    xlabel('False positive rate'); ylabel('True positive rate');
    ttl=sprintf('ROC for  MIP ',fold_idx);
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
   
   
fprintf('%f\t%f\t%f\t%f\t%f\t',AUC,accuracy_avg,Standard_Error,false_negative_ratio,false_positive_ratio);
res(test_idx,:) = [AUC accuracy_avg Standard_Error 1-false_positive_ratio 1-false_negative_ratio];


end

disp(sprintf('\n\n\n-------------------------------'));
    for res_id=1:n_tries
        disp(sprintf('%f\t%f\t%f\t%f\t%f\t',res(res_id,1),res(res_id,2),res(res_id,3),res(res_id,4),res(res_id,5)));
    end
    acc_all = squeeze(res(:,2));
    auc_all = squeeze(res(:,1));
    true_negative_all = squeeze(res(:,5));
    true_positive_all = squeeze(res(:,4));
    stderr_all = squeeze(res(:,3));
    
    avg.mean_Standard_Error=mean(stderr_all);
    avg.mean_ACC = mean(acc_all);
    avg.mean_AUC = mean(auc_all);
    avg.mean_tn = mean(true_negative_all);
    avg.mean_tp = mean(true_positive_all);
    
    ddd =0;
    

    disp(sprintf('\navg :\n%f\t%f\t%f\t%f\t%f\t',avg.mean_AUC,avg.mean_ACC,avg.mean_Standard_Error,avg.mean_tp,avg.mean_tn));
    
    save_results(DB_dir, db, model_type,folds_type,svm_kernel_type,n_tries,desc_folders,res,avg,descriptors);
    
end

function [desc, descriptors] = get_desc(test_idx, mbh_decision_values, mip_decision_values, stip_decision_values, vif_decision_values)


         
            
    stacking___mip_mbh = [mip_decision_values mbh_decision_values];
    %mip_mbh_prediction = [mip_predicted_label mbh_predicted_label];
    stacking___mip_mbh_vif = [mip_decision_values mbh_decision_values vif_decision_values];
    stacking___mip_mbh_stip = [mip_decision_values mbh_decision_values stip_decision_values];
    stacking___mbh_stip = [mbh_decision_values stip_decision_values];
    stacking___mip_stip = [mip_decision_values  stip_decision_values];
    stacking___mbh_vif = [mbh_decision_values vif_decision_values];
    stacking___mip_vif = [mip_decision_values  vif_decision_values];
    stacking___mbh_mip_stip_vif = [mbh_decision_values mip_decision_values stip_decision_values vif_decision_values];
    stacking___mbh_mip_vif = [mbh_decision_values mip_decision_values  vif_decision_values];
        
    bagging___mip_mbh = mip_decision_values+mbh_decision_values;
    bagging___mip_mbh_vif_stip = mip_decision_values+mbh_decision_values+stip_decision_values+vif_decision_values;
    bagging___mip_mbh_stip = mip_decision_values+mbh_decision_values+stip_decision_values;
    bagging___mip_stip = mip_decision_values+stip_decision_values;
    bagging___mbh_stip = mbh_decision_values+stip_decision_values;

    %desc = bagging___mip_mbh_vif_stip;
    %desc = bagging___mip_mbh_stip;
    %desc = bagging___mip_mbh;
    %desc = bagging___mip_stip;
    %desc = bagging___mbh_stip;
    
    %desc = stacking___mbh_stip;
    %desc = stacking___mip_mbh;
    %desc = stacking___mip_stip;
    desc = stacking___mip_mbh_stip;
    %desc = stacking___mip_mbh_vif;
    %desc = stacking___mbh_mip_stip_vif;
    

    
    
    
    switch test_idx
        case 1
            desc = stacking___mbh_vif;            
            
        case 2
            desc = stacking___mip_mbh_stip;
                  
        case 3
            desc = stacking___mip_mbh_vif;
                   
        case 4
            desc = stacking___mbh_mip_stip_vif;
                   
    end
    
                           
    descriptors = {...
        'MBH+VIF         ';...
        'STIP+MIP+MBH    ';...
        'MIP+MBH+VIF     ';...
        'STIP+MIP+MBH+VIF';...
    };
            

end



function save_results(DB_dir, db, model_type,folds_type,svm_kernel_type,n_tries,desc_folders,res,avg,descriptors)
        run_id_fn = strcat(DB_dir,'\\run_id.mat');
        load(run_id_fn,'run_id');
        run_id = run_id+1;
        save(run_id_fn,'run_id');

        time = int2str(now());  % get serial time ( time as an integer number)
        my_time = fix(clock());
        year = int2str(my_time(1));
        month = int2str(my_time(2));
        day = int2str(my_time(3));
        hour = int2str(my_time(4));
        min = int2str(my_time(5));
        sec = int2str(my_time(6));
        main_model_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s',db,model_type);

        log_file = strcat(main_model_dir,...
                                    '\10_tries_','STACKING','_',...
                                    year, '_', month ,'_', ...
                                    day,'_',  hour,'_',  ...
                                    min,'_',  sec,...
                                    '.txt');
        my_disp(sprintf('\n\n\nRunning version num  %s',version), log_file);
        my_disp(sprintf('--------------------------------------------\r\n'), log_file);

        my_disp(sprintf('Date:  %s/%s/%s',day,month,year), log_file);
        my_disp(sprintf('Time:  %s:%s:%s',hour,min,sec), log_file);
        my_disp(sprintf('\r\n',hour,min,sec), log_file);
        my_disp(sprintf('Run id:  %d',run_id), log_file);
        my_disp(strcat('Model type : ',model_type), log_file);    
        my_disp(strcat('Database : ',db), log_file);
        my_disp(strcat('Folds type : ',folds_type), log_file);

        my_disp(strcat('SVM kernel type : ',svm_kernel_type), log_file);
        my_disp(sprintf('Num of repeated tests : %d',n_tries), log_file);
        for i_desc_folders=1:size(desc_folders,1)
            my_disp(strcat('Desc_folders(params): ',char(desc_folders(i_desc_folders))), log_file);
        end

        my_disp(strcat('\r\n'), log_file);


        my_disp('                AUC     Acc     Std_Err truepos trueneg', log_file);
        my_disp('                ----    ----    ----    ----    ----', log_file);
        for res_id=1:n_tries
            my_disp(sprintf('%s%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t',char(descriptors(res_id)),res(res_id,1),res(res_id,2),res(res_id,3),res(res_id,4),res(res_id,5)), log_file);
        end
        my_disp(sprintf('\r\navg :\r\n%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t',avg.mean_AUC,avg.mean_ACC,avg.mean_Standard_Error,avg.mean_tn,avg.mean_tp), log_file);


end
