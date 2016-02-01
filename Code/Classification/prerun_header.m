function [globals, DB_dir, vidext] = prerun_header()
    clear vars







 

    version = 'Fishes 11';
    
    my_vista_pc = 1;
    my_win7_pc = 0;
 

        if my_vista_pc
            run('C:\Program Files\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')  % add vlfeat lib


            addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab   ');
            %addpath('H:\thesis - eating fishes\Code\trajectory subspace ver 47\fast-matlab-src-2.1');
            %addpath('OpticalFlow\mex');

addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % pca , perfcurve.m
            %output_dir_train = 'H:\thesis - eating fishes\DATABASES\Database-B\Models\TRAJ_SBSP_20_2080_12';
            
            %DB_dir = 'H:\thesis - eating fishes\DATABASES\Database-B\DB';
            vidext = '.avi';
            
            DB_dir = '';
            globals = 0;
        end
        
        if my_win7_pc
            
                run('C:\Program Files (x86)\MATLAB\R2010a Student\toolbox\vlfeat-0.9.14\toolbox\vl_setup')  % add vlfeat lib
                addpath('H:\thesis - eating fishes\Code\Classification\SVM\libsvm-3.17\matlab   ');
                addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % pca , perfcurve.m
                vidext = '.avi';
            
                DB_dir = '';
                globals = 0;
                %{
                %addpath('   D:\Eyal\OpenU\Computer Science - MSc\thesis\trajectory subspace\FAST 2.1   ');
                addpath('   C:\thesis - general\FLANN\flann-1.6.11-src\src\matlab   ');
                addpath('   C:\thesis - general\SVM\libsvm-3.17\matlab   ');
                addpath('C:\thesis - general\FAST  corner detection\matlab code\fast-matlab-src-2.1');
                addpath('OpticalFlow\mex');
                addpath('   C:\thesis - general\SVM\libsvm-3.17\matlab');
                addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % perfcurve.m
                addpath('   C:\installations\ffmpeg');
%rmpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats');
                load 'D:\thesis - action recognition\benchmarks\ASLAN\DB pairs\test_pairs';
                load 'D:\thesis - action recognition\benchmarks\ASLAN\DB pairs\train_pairs';

                output_dir_train = 'D:\thesis - action recognition\ASLAN-runs\Run_46';
                %output_dir_test= 'D:\thesis - action recognition\benchmarks\ASLAN\Run_45';
                 output_dir_hist = 'not in use';
                DB_dir = 'D:\thesis - action recognition\benchmarks\ASLAN\DB';
                vidext = '.avi';
            %}
        end
    



    
end
