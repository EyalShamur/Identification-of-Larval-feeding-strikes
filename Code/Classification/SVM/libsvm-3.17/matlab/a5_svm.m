


%{

        -training_label_vector:
            An m by 1 vector of training labels (type must be double).
        -training_instance_matrix:
            An m by n matrix of m training instances with n features.
            It can be dense or sparse (type must be double).
        -libsvm_options:
            A string of training options in the same format as that of LIBSVM.

%}


addpath('   D:\Eyal\OpenU\Computer Science - MSc\thesis\SVM\libsvm-3.17\matlab   ');


    make;
    
m= 100;  % num of train instances
n=20; % num of features
    training_label_vector = double(zeros(m,1)) ;
    training_label_vector(floor(m/2):m)=double(1);
    training_instance_matrix = rand(m,n);
    training_instance_matrix(floor(m/2):m,:) =  training_instance_matrix(floor(m/2):m,:).*0.5;
    

k=60;  % num of test instances
    testing_label_vector = double(zeros(k,1)) ;
    testing_instance_matrix = rand(k,n);
    
model = svmtrain(training_label_vector, training_instance_matrix );

[predicted_label, accuracy, decision_values] = ...
    svmpredict(testing_label_vector, testing_instance_matrix, model);