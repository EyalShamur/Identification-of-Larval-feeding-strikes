
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
Database_A_no_avi2=0;
Database_A_no_avi2_partial=0;
Database_A=0;
Database_B=0;
Database_C=0;
Database_D=0;
Database_B_no_202=0;
Database_B_no_409=0;
Database_B_no_562_partial=0;
Database_B_no_562_partial_2=0;
Database_B_no_409_25200to30200=1;

prune = 0; % make the number of non-eating clips twice the number of eating clips

if Database_A
    %permutation_vector = randperm(450);
    %benchmark_9_fold_cross_validation = reshape(permutation_vector,50,9);
    %benchmark_9_fold_tags = uint8(zeros(size(benchmark_9_fold_cross_validation)));
    %benchmark_9_fold_tags(find(benchmark_9_fold_cross_validation>300))=uint8(1);

    %save('Database_A_folds.mat','benchmark_9_fold_cross_validation','benchmark_9_fold_tags');
    
    
    permutation_vector_non_eating_150 = (randperm(300))';
    permutation_vector_non_eating_150 = permutation_vector_non_eating_150(1:150,:);
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

    save('Database_C_6x14_folds.mat','fold_clips','fold_tags');
end

if Database_D
    permutation_vector = (randperm(216));
    fold_clips = reshape(permutation_vector,36,6);
    fold_tags = uint8(zeros(size(fold_clips)));
    fold_tags(find(fold_clips<=108))=uint8(1);

    save('Database_D_6x36_folds.mat','fold_clips','fold_tags');

end


if Database_A_no_avi2_partial

    % skip clips extracted from 2.avi frames 1-20920
    % use eating event clips 301-450 but skip 328-350
    % use non-eating event clips 1-300 but skip clips 105-126
    permutation_vector_non_eating_104 = (randperm(104))';
    permutation_vector_non_eating_173 = (randperm(173))'+126;
    vector_277 = [permutation_vector_non_eating_104; permutation_vector_non_eating_173;];
    permutation_vector_non_eating_277 = vector_277(randperm(277));
    permutation_vector_non_eating_120 = permutation_vector_non_eating_277(1:120,:);
    
    permutation_vector_eating_27 = (randperm(27))';
    permutation_vector_eating_100 = (randperm(100))'+50;
    vector_127 = [permutation_vector_eating_27; permutation_vector_eating_100;];
    permutation_vector_eating_127 = vector_127(randperm(127));
    permutation_vector_eating_120 = permutation_vector_eating_127(1:120,:);
    
    permutation_vector_eating_120 = permutation_vector_eating_120+300;
    all_valid_vector = [permutation_vector_non_eating_120; permutation_vector_eating_120;];
    perm_idx = randperm(240);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,40,6);
    fold_tags = int32(ones(size(fold_clips))*(-1));
    fold_tags(find(fold_clips>300))=int32(1);

    save('Database_A_no_avi2_6x40_folds.mat','fold_clips','fold_tags');

end

if Database_A_no_avi2
    %{
    eating events

        idx     frame number
        ----       ------
         328        5890
         329        6410
         330        6690
         331        7250
         332        7480
         333        7620
         334        7850
         335        8200
         336        8480
         337        9890
         338       10170
         339       10340
         340       10510
         341       10740
         342       14680
         343       16540
         344       16860
         345       18510
         346       18890
         347       19670
         348       20560
         349       20920
         350        5890
         351       21400
         352       21580
         353       21890
         354       22340
         355       22630
         356       22900
         357       23090
         358       25710
         359       25850
         360       26160
         450       26150

non-eating events

        idx     frame number
        ----       ------
         105        6000
         106        6500
         107        7000
         108        7500
         109        8000
         110       60500
         111        9000
         112        9500
         113       10000
         114       58500
         115       11000
         116       11500
         117       15000
         118       16000
         119       16500
         120       17000
         121       17500
         122       18500
         123       19000
         124       19500
         125       20000
    
    %}
    
    clear all
    permutation_vector_non_eating_150 = (randperm(300))';
    new_idx=0;
    for idx=1:300
        if permutation_vector_non_eating_150(idx)< 105 || permutation_vector_non_eating_150(idx)> 147
            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_114 = permutation_vector_non_eating_(1:114,:);
    
    permutation_vector_eating_150 = (randperm(150)+300)';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 328 || permutation_vector_eating_150(idx)> 360) && permutation_vector_eating_150(idx)~=450
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_114 = permutation_vector_eating_(1:114,:);
    
    all_valid_vector = [permutation_vector_non_eating_114; permutation_vector_eating_114;];
    perm_idx = randperm(228);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,38,6);
    fold_tags = int32(ones(size(fold_clips))*(-1));
    fold_tags(find(fold_clips>300))=int32(1);

    save('Database_A_no_avi2_6x38_folds.mat','fold_clips','fold_tags');
    
end


if Database_B_no_202
    %{
    Eating events:
           3       21917
           4       53157
           5       81836
           6       41763
           7        8573

---------
Non-eating events:
         154       40013
         163       60019
         168       20006
         169       20006
         182       20006
         188       80026
    %}
    clear all
    permutation_vector_non_eating_150 = (randperm(150)+150)';
    new_idx=0;
    for idx=1:150
        if permutation_vector_non_eating_150(idx)~= 154 && ...
                permutation_vector_non_eating_150(idx)~= 163 && ...
                permutation_vector_non_eating_150(idx)~= 168 && ...
                permutation_vector_non_eating_150(idx)~= 169 && ...
                permutation_vector_non_eating_150(idx)~= 182 && ...
                permutation_vector_non_eating_150(idx)~= 188 

            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_144 = permutation_vector_non_eating_(1:144,:);
    
    permutation_vector_eating_150 = (randperm(150))';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 3 || permutation_vector_eating_150(idx)> 7) 
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_144 = permutation_vector_eating_(1:144,:);
    
    all_valid_vector = [permutation_vector_non_eating_144; permutation_vector_eating_144;];
    perm_idx = randperm(288);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,48,6);
    fold_tags = int32(ones(size(fold_clips)));
    fold_tags(find(fold_clips>150))=int32(-1);

    save('Database_B_no_202_6x48_folds.mat','fold_clips','fold_tags');
    
end




if Database_B_no_409
    %{
    Eating events:
          60        2080
          61        5751
          62       25330
          63       25250
          64       27206
          65       28971
          66       29371
          67       30156
          68       32317
          69       44119
          70       45089
          71       57622
          72       58472

---------
Non-eating events:
         267       20004
         278       30006
         280       40008
    %}
    clear all
    permutation_vector_non_eating_150 = (randperm(150)+150)';
    new_idx=0;
    for idx=1:150
        if permutation_vector_non_eating_150(idx)~= 267 && ...
                permutation_vector_non_eating_150(idx)~= 278 && ...
                permutation_vector_non_eating_150(idx)~= 280 

            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_135 = permutation_vector_non_eating_(1:135,:);
    
    permutation_vector_eating_150 = (randperm(150))';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 60 || permutation_vector_eating_150(idx)> 72) 
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_135 = permutation_vector_eating_(1:135,:);
    
    all_valid_vector = [permutation_vector_non_eating_135; permutation_vector_eating_135;];
    perm_idx = randperm(270);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,45,6);
    fold_tags = int32(ones(size(fold_clips)));
    fold_tags(find(fold_clips>150))=int32(-1);

    save('Database_B_no_409_6x45_folds.mat','fold_clips','fold_tags');
    
end


if Database_B_no_562_partial
    %{
    Eating events:
    
        clip_num   frame_number   mouth_x   mouth_y
          94       56011        1574          94   
          95       57972         794         524   
          96       58297         213         618   
          97       58217         282         493   
          98       60122         945          55   
    
    ---------
    Non-eating events:

         260       52965        1177         709
    
    %}
    clear all
    permutation_vector_non_eating_150 = (randperm(150)+150)';
    new_idx=0;
    for idx=1:150
        if permutation_vector_non_eating_150(idx)~= 260 

            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_144 = permutation_vector_non_eating_(1:144,:);
    
    permutation_vector_eating_150 = (randperm(150))';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 94 || permutation_vector_eating_150(idx)> 98) 
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_144 = permutation_vector_eating_(1:144,:);
    
    all_valid_vector = [permutation_vector_non_eating_144; permutation_vector_eating_144;];
    perm_idx = randperm(288);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,48,6);
    fold_tags = int32(ones(size(fold_clips)));
    fold_tags(find(fold_clips>150))=int32(-1);

    save('Database_B_no_562_partial_6x48_folds.mat','fold_clips','fold_tags');    
    
end


if Database_B_no_562_partial_2
    %{
    Eating events:
    
        clip_num   frame_number   mouth_x   mouth_y
    -     84        7246         791         634
    -     85        9682         624         561
    -     86       10707         532         145
    -     87       11482        1296         150   
    
    ---------
    Non-eating events:

    -    252        7701          43         633
    -    253        7701         371         860
    
    %}
    clear all
    permutation_vector_non_eating_150 = (randperm(150)+150)';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_non_eating_150(idx)~= 252) && (permutation_vector_non_eating_150(idx) ~= 253)

            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_144 = permutation_vector_non_eating_(1:144,:);
    
    permutation_vector_eating_150 = (randperm(150))';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 84 || permutation_vector_eating_150(idx)> 87) 
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_144 = permutation_vector_eating_(1:144,:);
    
    all_valid_vector = [permutation_vector_non_eating_144; permutation_vector_eating_144;];
    perm_idx = randperm(288);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,48,6);
    fold_tags = int32(ones(size(fold_clips)));
    fold_tags(find(fold_clips>150))=int32(-1);

    save('Database_B_no_562_partial_6x48_folds_2.mat','fold_clips','fold_tags');    
    
    
end


if Database_B_no_409_25200to30200
    
%{
    Eating events:
          63       25250
          64       27206
          65       28971
          66       29371
          67       30156
    ---------
    Non-eating events:
         278       30006
%}
     clear all
    permutation_vector_non_eating_150 = (randperm(150)+150)';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_non_eating_150(idx)~= 278) 

            new_idx=new_idx+1;
            permutation_vector_non_eating_(new_idx,1)=permutation_vector_non_eating_150(idx);
        end
    end        
    permutation_vector_non_eating_144 = permutation_vector_non_eating_(1:144,:);
    
    permutation_vector_eating_150 = (randperm(150))';
    new_idx=0;
    for idx=1:150
        if (permutation_vector_eating_150(idx)< 63 || permutation_vector_eating_150(idx)> 67) 
            new_idx=new_idx+1;
            permutation_vector_eating_(new_idx,1)=permutation_vector_eating_150(idx);
        end
    end
    permutation_vector_eating_144 = permutation_vector_eating_(1:144,:);
    
    all_valid_vector = [permutation_vector_non_eating_144; permutation_vector_eating_144;];
    perm_idx = randperm(288);
    permutation_vector = all_valid_vector(perm_idx);
    
    fold_clips = reshape(permutation_vector,48,6);
    fold_tags = int32(ones(size(fold_clips)));
    fold_tags(find(fold_clips>150))=int32(-1);

    save('Database_B_no_409_25200to30200_6x48_folds.mat','fold_clips','fold_tags');     
    
end


