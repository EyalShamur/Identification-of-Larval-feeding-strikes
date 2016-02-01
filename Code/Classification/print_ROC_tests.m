
    close all
    clear all
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m
        %[X,Y,T,AUC] = perfcurve(testing_label_vector_all,probability_values_all(:,1),double(1));
    figure(88)
        set(0,'DefaultAxesColorOrder',[0 0 0],...
      'DefaultAxesLineStyleOrder','-|-.|--|:')

    database='A';
    model_type='Models_Rot_and_Flip';
    
    

            'MBH_patch_size=32\\RUN_ID_1029\\SVM\\test_num_4';...
        %'MIP_N12_M12_gap1_T_GL8\\run_id_1023\\SVM_PCA\\test_num_1';...
        'MIP_orig\\run_id_1003\\SVM_PCA\\test_num_1';...
        %'VIF_M=N=3_S=7_T=1.5_H=21_perCell\\RUN_ID_1019\\SVM\\test_num_1';...
        %'VIF_M=N=3_S=7_T=1.5_H=21\\RUN_ID_1020\\SVM\\test_num_1';...
        'VIF_M=N=3_S=1_T=1.0_H=21\\run_id_1068\\SVM\\test_num_2';...

    
    % STIP
    descriptor_folder='STIP_thresh=0_kparam=0.005_szf=20';
    run_id=1025;
    i_tries=3;
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM\\test_num_%d\\AUC_params.mat',database,model_type,descriptor_folder,run_id,i_tries);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    load ('decision_values_all.mat', 'dva' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    hold all
    set(p,'Color','blue','LineWidth',2)
    

    
    
    % MIP
    descriptor_folder='MIP_orig';
    run_id=1003;
    i_tries=1;
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM_PCA\\test_num_%d\\AUC_params.mat',database,model_type,descriptor_folder,run_id,i_tries);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    load ('decision_values_all.mat', 'dva' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    set(p,'Color','green','LineWidth',2)
    hold all

    
    % MBH
    % 0.980844	0.920000	0.015492	0.040000	0.120000 
    descriptor_folder='MBH_patch_size=32';
    run_id=1029;
    i_tries=4;
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM\\test_num_%d\\AUC_params.mat',database,model_type,descriptor_folder,run_id,i_tries);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    load ('decision_values_all.mat', 'dva' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    hold all
    set(p,'Color','red','LineWidth',2)
    %set(hleg1,'Location','SouthEast')
    
    
    
    % VIF
    descriptor_folder='VIF_M=N=3_S=1_T=1.0_H=21';
    run_id=1068;
    i_tries=2;
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\%s\\RUN_ID_%d\\SVM\\test_num_%d\\AUC_params.mat',database,model_type,descriptor_folder,run_id,i_tries);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    set(p,'Color','magenta','LineWidth',2)
    hold all
    
    
    %MBH+VIF
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING_BEST\\SVM\\test_num_1\\AUC_params.mat',database,model_type);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    set(p,'Color','cyan','LineWidth',2)
    hold all
    
    
    %STIP+MIP+MBH
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING_BEST\\SVM\\test_num_2\\AUC_params.mat',database,model_type);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    set(p,'Color','black','LineWidth',2)
    hold all
    
    
    %MIP+MBH+VIF
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING_BEST\\SVM\\test_num_3\\AUC_params.mat',database,model_type);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    orange = [0.95 0.6 0.0];
    set(p,'Color',orange,'LineWidth',2)
    hold all
    
    
    %STIP+MIP+MBH+VIF
    input_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\%s\\STACKING_BEST\\SVM\\test_num_4\\AUC_params.mat',database,model_type);
    load (input_dir, 'testing_label_vector_all', 'testing_decision_values_all' );
    [X,Y,T,AUC] = perfcurve(testing_label_vector_all,testing_decision_values_all(:,1),double(1));
    p=plot(X,Y);
    gray = [0.4 0.4 0.4];
    set(p,'Color',gray,'LineWidth',2)
    hold all
   
    
    hleg1 = legend('STIP','MIP','MBH','VIF','MBH+VIF','STIP+MIP+MBH','MIP+MBH+VIF','STIP+MIP+MBH+VIF');
    set(hleg1,'Location','SouthEast')
    
    
    
    % Change the line color to red and
    % set the line width to 2 points 
    %set(p,'Color','blue','LineWidth',4)
    %hleg1 = legend('cos_x','sin_x');
    %set(hleg1,'Location','SouthEast')
    %set(hleg1,'Interpreter','none')
    set(gca,'XTick',0:0.2:1)
    set(gca,'YTick',0:0.2:1)
    grid on
    %XMinorGrid off
    %set(grid,0:0.2:1)
    
    % Make the text of the legend italic and color it black
    black=[.0,.0,.0];
    set(hleg1,'FontAngle','normal','TextColor',black)
    set(hleg1,'FontName','Times','FontSize',12)
    
%see:  http://www.mathworks.com/help/matlab/ref/legend-properties.html

        %xlabel('False positive rate','FontName','Broadway'); 
        %ylabel('True positive rate','FontName','Broadway');
        xlabel('False positive rate','FontName','Times','FontSize',12); 
        ylabel('True positive rate','FontName','Times','FontSize',12);
        %ttl=sprintf('ROC for  MBH ',fold_idx);
        title('ROC Curve for Database-A','FontName','Times','FontSize',12);
        
%{        
'yellow' 'y' [1 1 0] 
'magenta' 'm' [1 0 1] 
'cyan' 'c' [0 1 1] 
'red' 'r' [1 0 0] 
'green' 'g' [0 1 0] 
'blue' 'b' [0 0 1] 
'white' 'w' [1 1 1] 
'black 'k' [0 0 0] 
%}
        
rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');

