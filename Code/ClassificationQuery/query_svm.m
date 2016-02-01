
function [predicted_label, decision] = query_svm(query_param, desc_param, MBH_Bow_fn)

%close all
%clear all

%[globals, DB_dir, vidext] = prerun_header();



    
    
    if query_param.use_hist_pca
        output_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM_PCA\\test_num_%d'...
            ,query_param.database,query_param.model_type,desc_param.desc_folders,desc_param.run_id_for_svm,query_param.i_tries);
    else
        output_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM\\test_num_%d'...
            ,query_param.database,query_param.model_type,desc_param.desc_folders,desc_param.run_id_for_svm,query_param.i_tries);
    end
    model_dir =  sprintf('%s//FOLD_%.2d',output_dir,desc_param.fold_idx);
    model_file =  sprintf('%s//model.mat',model_dir);
    load(model_file,'model','shift', 'm');

   

    load (MBH_Bow_fn,'hist')  % hist
    nonnn = isnan(hist);
    idx_none=find(nonnn==1);
    if ~isempty(idx_none)
        hist=0;
    end




    hist =manipulate_hist(hist,query_param.descriptor_type);
    test_mat(1,:)=double(hist);
    testing_label_vector(1,1)=double(1); % random value as it is unknown
    
    %shift to 0
    scaled_mat_test(1,:) = test_mat(1,:)+shift;
    %scale to be in the interval(0...1)
    scaled_mat_test(1,:) = scaled_mat_test(1,:).*m;

            

    
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
    
    % Supress output by use evalc that sends output to output_buffer instead
    % of console 
    [output_buffer, predicted_label, accuracy, decision_values] = ...
        evalc('svmpredict(testing_label_vector, scaled_mat_test, model);'); 
    
    decision = decision_values(1,1);
    
  

     
end


   

function [hist] = manipulate_hist(input_hist,descriptor_type)
        hist = sqrt(input_hist);
        switch descriptor_type
            case 'VIF'
                hist = input_hist; 
            case 'MIP'
                hist = input_hist; 
        end


end



