%{
dir_in1 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_compressed';
dir_in2 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_compressed_rot';
dir_in3 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_compressed_rot_flip';
dir_in4 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_no_rotation_frame';
dir_in5 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_Rot_and_Flip_frame';
dir_in6 = 'H:\thesis - eating fishes\DATABASES\Database-C\DB_84_HI_RES_Rot_frame';
%}
dir_in1 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_compressed';
dir_in2 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_compressed_rot';
dir_in3 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_compressed_rot_flip';
dir_in4 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_no_rotation_frame';
dir_in5 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_and_Flip_frame';
dir_in6 = 'H:\thesis - eating fishes\DATABASES\Database-D\DB_216_HI_RES_Rot_frame';

dir_out1 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_compressed';
dir_out2 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_compressed_rot';
dir_out3 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_compressed_rot_flip';
dir_out4 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_no_rotation_frame';
dir_out5 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_and_Flip_frame';
dir_out6 = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_frame';
if ~my_create_dir(dir_out1); return; end;
if ~my_create_dir(dir_out2); return; end;
if ~my_create_dir(dir_out3); return; end;
if ~my_create_dir(dir_out4); return; end;
if ~my_create_dir(dir_out5); return; end;
if ~my_create_dir(dir_out6); return; end;

output_idx = 198;


for input_idx=115:116
    
    output_idx = output_idx+1;
    fname_in = sprintf('\\fish_head-%.4d.*',input_idx);
    file_path_in1 = strcat(dir_in1,fname_in);
    file_path_in2 = strcat(dir_in2,fname_in);
    file_path_in3 = strcat(dir_in3,fname_in);
    file_path_in4 = strcat(dir_in4,fname_in);
    file_path_in5 = strcat(dir_in5,fname_in);
    file_path_in6 = strcat(dir_in6,fname_in);
    
    fname_out = sprintf('\\fish_head-%.4d.*',output_idx);
    file_path_out1 = strcat(dir_out1,fname_out);
    file_path_out2 = strcat(dir_out2,fname_out);
    file_path_out3 = strcat(dir_out3,fname_out);
    file_path_out4 = strcat(dir_out4,fname_out);
    file_path_out5 = strcat(dir_out5,fname_out);
    file_path_out6 = strcat(dir_out6,fname_out);
    

    
    %copy_command = sprintf('copy "%s" "%s"',file_path_in1 ,file_path_out1);
    %system(copy_command);
    %copy_command = sprintf('copy "%s" "%s"',file_path_in2 ,file_path_out2);
    %system(copy_command);
    %copy_command = sprintf('copy "%s" "%s"',file_path_in3 ,file_path_out3);
    %system(copy_command);
    copy_command = sprintf('copy "%s" "%s"',file_path_in4 ,file_path_out4);
    system(copy_command);
    copy_command = sprintf('copy "%s" "%s"',file_path_in5 ,file_path_out5);
    system(copy_command);
    copy_command = sprintf('copy "%s" "%s"',file_path_in6 ,file_path_out6);
    system(copy_command);

    
    %fname_in = sprintf('\\fish_head-%d.mat',input_idx);
    %file_path_in = strcat(dir_in,fname_in);
    %del_command = sprintf('del "%s"',file_path_in );
    %system(del_command);
    
    %fname_in = sprintf('\\fish_head-%d.avi',input_idx);
    %file_path_in = strcat(dir_in,fname_in);
    %del_command = sprintf('del "%s"',file_path_in );
    %system(del_command);
    
end


%{
for idx=5:17

    fname_in = sprintf('\\fish_head-%d.mat',idx);
    fname_out = sprintf('\\fish_head-%d.mat',idx);
    
    %fname_in = sprintf('\\fish_head-%.4d.mat',idx);
    %fname_out = sprintf('\\fish_head-%.4d.mat',idx);
    
    attributes_file_in = strcat(dir_out,fname_in);
    attributes_file_out = strcat(dir_out,fname_out);

    load(attributes_file_in,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
    if isEating == 0
        fprintf('isEating= 0\n');
    else
        continue; 
    end
    
    isEating=1;
    close('all');
    fprintf(sprintf('frame_number = %d, isEating = %d\n',frame_number,isEating)); 
    save(attributes_file_out,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
    
end
%}

endprog=999;



