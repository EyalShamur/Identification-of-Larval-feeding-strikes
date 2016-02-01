
%{
load('Database_B_folds_pruned.mat','benchmark_7_fold_cross_validation','benchmark_7_fold_tags');
start_count = 83-1;
for i=1:126
i
   clip_num =  benchmark_7_fold_cross_validation(i);
   if clip_num<64
       continue;
   end
   start_count = start_count+1;
   src_dir = 'H:\\thesis - eating fishes\\DATABASES\\Database-B\\DB old';
   src = sprintf('%s\\fish_head-%.4d.avi',src_dir,clip_num);
   dest_dir = 'H:\\thesis - eating fishes\\DATABASES\\Database-B\\DB_compressed';
   dst = sprintf('%s\\fish_head-%.4d.avi',dest_dir,start_count);
   cmd = sprintf('copy "%s" "%s"',src,dst);
   system(cmd);
   src = sprintf('%s\\fish_head-%.4d.mat',src_dir,clip_num);
   dst = sprintf('%s\\fish_head-%.4d.mat',dest_dir,start_count);
   cmd = sprintf('copy "%s" "%s"',src,dst);
   system(cmd);
end 


%}

%----------------

Database_A=0;
Database_B=0;
Database_C=0;
Database_D=1;

prune = 0; % make the number of non-eating clips twice the number of eating clips

if Database_A
    %permutation_vector = randperm(450);
    %benchmark_9_fold_cross_validation = reshape(permutation_vector,50,9);
    %benchmark_9_fold_tags = uint8(zeros(size(benchmark_9_fold_cross_validation)));
    %benchmark_9_fold_tags(find(benchmark_9_fold_cross_validation>300))=uint8(1);

    %save('Database_A_folds.mat','benchmark_9_fold_cross_validation','benchmark_9_fold_tags');
    
    
    permutation_vector_non_eating_300 = (randperm(300))';
    permutation_vector_non_eating_150 = permutation_vector_non_eating_300(1:150,:);
    permutation_vector_eating_150 = (randperm(150)+300)';
    all_valid_vector = [permutation_vector_non_eating_150; permutation_vector_eating_150;];
    perm_idx = randperm(300);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,50,6);
    fold_tags = uint8(zeros(size(fold_clips)));
    fold_tags(find(fold_clips>300))=uint8(1);

    save('Database_A_6x50_folds.mat','fold_clips','fold_tags');

end

if Database_B
    if prune
        permutation_vector = randperm(63*2);
        permutation_vector_1 = randperm(280-63)+63;
        permutation_vector_2 = permutation_vector_1(1:126);
        
        new_per=0;
        for per_idx=1:63*2
            if permutation_vector(per_idx)<=63
                continue;
            else
                new_per=new_per+1;
                permutation_vector(per_idx) = permutation_vector_2(new_per);
            end
        end
        
        benchmark_7_fold_cross_validation = reshape(permutation_vector,42,3);
        benchmark_7_fold_tags = uint8(zeros(size(benchmark_7_fold_cross_validation)));
        benchmark_7_fold_tags(find(benchmark_7_fold_cross_validation<=63))=uint8(1);
        save('Database_B_folds_pruned.mat','benchmark_7_fold_cross_validation','benchmark_7_fold_tags');
        
    else
        
        permutation_vector = randperm(162);
        benchmark_6x27_fold_cross_validation = reshape(permutation_vector,27,6);
        benchmark_6x27_fold_tags = uint8(zeros(size(benchmark_6x27_fold_cross_validation)));
        benchmark_6x27_fold_tags(find(benchmark_6x27_fold_cross_validation<=81))=uint8(1);

        save('Database_B_6x27_folds.mat','benchmark_6x27_fold_cross_validation','benchmark_6x27_fold_tags');

    
    end

end

if Database_C
    permutation_vector = (randperm(84));
    fold_clips = reshape(permutation_vector,14,6);
    fold_tags = uint8(zeros(size(fold_clips)));
    fold_tags(find(fold_clips<=42))=uint8(1);

    save('Database_D_6x36_folds.mat','fold_clips','fold_tags');
end

if Database_D
    permutation_vector = (randperm(216));
    fold_clips = reshape(permutation_vector,36,6);
    fold_tags = uint8(zeros(size(fold_clips)));
    fold_tags(find(fold_clips<=108))=uint8(1);

    save('Database_D_6x36_folds.mat','fold_clips','fold_tags');

end