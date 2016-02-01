function [  ] = build_DATABASE_C_D(  )

    clear vars
    close all
    
 

    dir_in = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_compressed_rot_flip';
    %dir_in_hi_res = 'H:\thesis - eating fishes\DATABASES\Database-B\DB_300_HI_RES_Rot_and_Flip_frame';

    eat_sml_dir_out = 'H:\thesis - eating fishes\DATABASES\Database-C\eating';%DB_300_compressed_rot_flip';
    eat_big_dir_out = 'H:\thesis - eating fishes\DATABASES\Database-D\eating';%DB_300_compressed_rot_flip';
    no_eat_sml_dir_out = 'H:\thesis - eating fishes\DATABASES\Database-C\non_eating';%DB_300_compressed_rot_flip';
    no_eat_big_dir_out = 'H:\thesis - eating fishes\DATABASES\Database-D\non_eating';%DB_300_compressed_rot_flip';
    if ~my_create_dir(eat_sml_dir_out); return; end;
    if ~my_create_dir(eat_big_dir_out); return; end;
    if ~my_create_dir(no_eat_sml_dir_out); return; end;
    if ~my_create_dir(no_eat_big_dir_out); return; end;

    eat_sml_idx=0;
    no_eat_sml_idx=42;
    eat_big_idx=0;
    no_eat_big_idx=108;
    
    for clip_idx=1:300
        %output_idx = output_idx+1;
        fname_in = sprintf('\\fish_head-%.4d.*',clip_idx);
        file_path_in = strcat(dir_in,fname_in);
        %file_path_in_hi_res = strcat(dir_in_hi_res,fname_in);

        attribute_name = sprintf('\\fish_head-%.4d.mat',clip_idx);
        attribute_file = strcat(dir_in,attribute_name);
        load(attribute_file); % get input_filename
    
        input_filename = strrep(input_filename, 'compressed_05_', '');
        input_filename = strrep(input_filename, '.avi', '');

        %strcmp(input_filename,'08-20-14_08-34-59.291_sparus_13dph_dex0_batch 7')   ||...
        %strcmp(input_filename,'08-20-14_08-34-59.291_sparus_13dph_dex0_batch 7')   ||...
    if  strcmp(input_filename,'09-01-14_08-25-57.023_sparus_13dph_dex0_batch 10')   ||...
        strcmp(input_filename,'08-21-14_11-45-44.001_sparus_13dph_dex0_batch 8')   ||...
        strcmp(input_filename,'08-20-14_09-01-41.351_sparus_13dph_dex0_batch 7')   ||...
        strcmp(input_filename,'08-10-14_09-16-23.994_sparus_13dph_dex0_batch2')   ||...
        strcmp(input_filename,'sparus_13dph_batch2_dex0_12-30-13_09-32-05.982')   ||...
        strcmp(input_filename,'sparus_13dph_batch6_dex0_01-15-14_09-25-08.395')  ||...
        strcmp(input_filename,'sparus_13dph_batch3_dex0_01-01-14_12-58-13.042')  ||...
        strcmp(input_filename,'sparus_13dph_batch5_dex25_01-06-14_10-20-46.202') ||...
        strcmp(input_filename,'sparus_13dph_batch3_dex25_01-01-14_12-27-16.913') ||...
        strcmp(input_filename,'sparus_13dph_batch3_dex5_01-01-14_12-04-37.648')  ||...  
        strcmp(input_filename,'sparus_8dph_batch1_dex0_12-22-13_15-11-53.501')
    
       if isEating
            eat_sml_idx=eat_sml_idx+1;
            fname_out = sprintf('\\fish_head-%.4d.*',eat_sml_idx);
            file_path_out = strcat(eat_sml_dir_out,fname_out);
       else
           no_eat_sml_idx=no_eat_sml_idx+1;
            fname_out = sprintf('\\fish_head-%.4d.*',no_eat_sml_idx);
            file_path_out = strcat(no_eat_sml_dir_out,fname_out);
       end
       copy_command = sprintf('copy "%s" "%s"',file_path_in ,file_path_out);
       system(copy_command);
    else
    if strcmp(input_filename,'sparus_22dph_batch1_dex0_01-05-14_11-25-39.779')  ||...
       strcmp(input_filename,'sparus_22dph_batch2_dex0_01-08-14_10-08-58.908')  ||...
       strcmp(input_filename,'sparus_22dph_batch3_dex0_01-10-14_11-15-05.562')  ||...
       strcmp(input_filename,'sparus_23dph_batch2_dex2_01-09-14_11-43-03.933')  ||...
       strcmp(input_filename,'sparus_23dph_batch4_dex0_01-13-14_14-50-34.611')  ||...
       strcmp(input_filename,'sparus_23dph_batch2_dex5_01-09-14_11-23-52.409')  ||...
       strcmp(input_filename,'sparus_23dph_batch2_dex7_01-09-14_11-02-01.431') 
       if isEating
            eat_big_idx=eat_big_idx+1;
            fname_out = sprintf('\\fish_head-%.4d.*',eat_big_idx);
            file_path_out = strcat(eat_big_dir_out,fname_out);
       else
           no_eat_big_idx=no_eat_big_idx+1;
            fname_out = sprintf('\\fish_head-%.4d.*',no_eat_big_idx);
            file_path_out = strcat(no_eat_big_dir_out,fname_out);
       end
       copy_command = sprintf('copy "%s" "%s"',file_path_in ,file_path_out);
       system(copy_command);
        
    else
        error=1;
    end
    
        
    end



end

