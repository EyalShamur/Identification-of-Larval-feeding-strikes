%{

folder = 'H:\\Thesis - eating fishes\\DATABASES\\Database-A\\DB_Rot_and_Flip';
t_idx=0;
no_t_idx=0;
eat_table_idx=[];
no_eat_table_idx=[];
for idx=1:450
    file_name = sprintf('\\fish_head-%.4d.mat',idx);
    fn = strcat(folder,file_name);
    load(fn,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
    
        if strcmp(input_filename , '2.avi')
            if isEating==0
                t_idx=t_idx+1;
                eat_table_idx(t_idx,:)=[idx,frame_number] ;
            else
                no_t_idx=no_t_idx+1;
                no_eat_table_idx(no_t_idx,:)=[idx,frame_number] ;           
            end

    end

end
disp(eat_table_idx);
disp(---------);
disp(no_eat_table_idx);
%}
%----------------------------------------

folder = 'H:\\Thesis - eating fishes\\DATABASES\\Database-B\\DB_300_HI_RES_Rot_Flip_corrected';
t_idx=0;
no_t_idx=0;
eat_table_idx=[];
no_eat_table_idx=[];
for idx=1:300
    file_name = sprintf('\\fish_head-%.4d.mat',idx);
    fn = strcat(folder,file_name);
    load(fn,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
    [pathstr,name,ext] = fileparts(input_filename);
        if strcmp(name , 'sparus_22dph_batch3_dex0_01-10-14_11-15-05.562')
       % if strcmp(name , 'sparus_13dph_batch5_dex25_01-06-14_10-20-46.202')
            if isEating==1
                t_idx=t_idx+1;
                eat_table_idx(t_idx,:)=[idx,frame_number,mouth_x,mouth_y] ;
            else
                no_t_idx=no_t_idx+1;
                no_eat_table_idx(no_t_idx,:)=[idx,frame_number,mouth_x,mouth_y] ;           
            end

    end

end
disp('Eating events:');
disp('    clip_num        frame_number   mouth_x   mouth_y');
disp(eat_table_idx);
disp('');
disp('---------');
disp('');
disp('Non-eating events:');
disp(no_eat_table_idx);