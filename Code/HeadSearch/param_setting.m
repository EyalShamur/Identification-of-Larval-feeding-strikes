function [ params ] = param_setting()
%PARAM_SETTING Summary of this function goes here
    addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % princomp.m
    clear vars
    close all
    
    params.Database = 'B'; %'B'
    params.output_file = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\Videos-Graphics\\0-head.avi',params.Database);
    params.output_head_dir = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s',params.Database);
    
    
    if strcmp(params.Database,'B') 
        %params.input_filename = 'sparus_23dph_batch2_dex5_01-09-14_11-23-52.409.avi';
        %params.input_filename = 'sparus_22dph_batch3_dex0_01-10-14_11-15-05.562.avi';
        %params.input_filename = 'sparus_13dph_batch5_dex25_01-06-14_10-20-46.202.avi';
        params.input_filename = 'sparus_23dph_batch2_dex7_01-09-14_11-02-01.431.avi';
        
        params.input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-Compressed\compressed_05_',params.input_filename);
        params.HD_input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-ORIG\sparus feeding dextran\',params.input_filename);
    end
    if strcmp(params.Database,'A')
        params.input_filename = '2.avi';
        params.input_file = sprintf('H:\\thesis - eating fishes\\DATABASES\\Database-%s\\Videos-Compressed\\%s',params.Database,params.input_filename);
    end
    
    
    params.query_file ='H:\Thesis - eating fishes\Classification_temp_data\eating_detection_table.mat'; 
    params.save_fish_heads = 0;  % making a short head clip                  
    params.draw_level = 1;  % 0 = no draw,  
                     % 1 = draw all, (input,output, segmentation, all filters and edge detections 
                     % 2 = draw input output only  
                     % 3 = make video with graphics
                     % 5 = mark current segment we work on
    params.classify=0;
    


    if  strcmp(params.input_filename,'09-01-14_08-25-57.023_sparus_13dph_dex0_batch 10.avi')   ||...
        strcmp(params.input_filename,'08-21-14_11-45-44.001_sparus_13dph_dex0_batch 8.avi')   ||...
        strcmp(params.input_filename,'08-20-14_09-01-41.351_sparus_13dph_dex0_batch 7.avi')   ||...
        strcmp(params.input_filename,'08-10-14_09-16-23.994_sparus_13dph_dex0_batch2.avi')   ||...
        strcmp(params.input_filename,'sparus_13dph_batch2_dex0_12-30-13_09-32-05.982.avi')   ||...
        strcmp(params.input_filename,'sparus_13dph_batch6_dex0_01-15-14_09-25-08.395.avi')  ||...
        strcmp(params.input_filename,'sparus_13dph_batch3_dex0_01-01-14_12-58-13.042.avi')  ||...
        strcmp(params.input_filename,'sparus_13dph_batch5_dex25_01-06-14_10-20-46.202.avi') ||...
        strcmp(params.input_filename,'sparus_13dph_batch3_dex25_01-01-14_12-27-16.913.avi') ||...
        strcmp(params.input_filename,'sparus_13dph_batch3_dex5_01-01-14_12-04-37.648.avi')  ||...  
        strcmp(params.input_filename,'sparus_8dph_batch1_dex0_12-22-13_15-11-53.501.avi')
    
        params.margine = 1; 
        params.std_gap=0.4;  %0.4 for 8dph% smaller value = bigger segments
        params.min_head_radius = 4;  
        params.head_clip_len = 40; % must be even number eventualy it would be 41
        params.min_fish_length = 30;
        params.use_bw_image=true;
        params.use_bigest_segment = false;  % use the segment in the center of roi 
        params.ratio_thresh = 100;%180
        params.remove_marginal_noise_flag=0;
        params.body_margine=10;
        params.se_radius3=4;
        params.segmentation_2_sigma_factor=0;
        params.segment_size_thresh=3000;
        params.segmentation_1_low_thresh=350;%250
        params.use_second_bounded_circle=0;
        params.avg_sz=50;
        params.local_analyzation=0;
        params.use_otsu_segmentation=1;
        params.edge_magnitude = 120;
        params.edge_thresh = 140;
        params.latent_max_thresh = 40; %20
        params.use_HD = 1;
        params.half_box_h=120;  % for saving HD head videos
        params.half_box_w=120;  % for saving HD head videos
        
    elseif strcmp(params.input_filename,'sparus_22dph_batch1_dex0_01-05-14_11-25-39.779.avi')  ||...
       strcmp(params.input_filename,'sparus_22dph_batch2_dex0_01-08-14_10-08-58.908.avi')  ||...
       strcmp(params.input_filename,'sparus_22dph_batch3_dex0_01-10-14_11-15-05.562.avi')  ||...
       strcmp(params.input_filename,'sparus_23dph_batch2_dex2_01-09-14_11-43-03.933.avi')  ||...
       strcmp(params.input_filename,'sparus_23dph_batch4_dex0_01-13-14_14-50-34.611.avi')  ||...
       strcmp(params.input_filename,'sparus_23dph_batch2_dex5_01-09-14_11-23-52.409.avi')  ||...
       strcmp(params.input_filename,'sparus_23dph_batch2_dex7_01-09-14_11-02-01.431.avi')  
   
        params.margine = 15; 
        params.std_gap=0.6;%0.6;% 1.0;  % smaller value = bigger segments
        params.min_head_radius = 7;  
        params.head_clip_len = 40; % must be even number
        params.min_fish_length = 30;
        params.use_bw_image=true;  % second segmentation. (for the small window)
        params.use_bigest_segment = false;  % use the segment in the center of roi 
        params.ratio_thresh = 100;%180
        params.remove_marginal_noise_flag=0;%0;
        params.body_margine=10;
        params.se_radius3=7;
        params.segmentation_2_sigma_factor=1;
        params.segment_size_thresh=3000;
        params.segmentation_1_low_thresh=800;
        params.use_second_bounded_circle=0;
        params.avg_sz=150;
        params.local_analyzation=0;
        params.use_otsu_segmentation=1;
        params.edge_magnitude = 120;
        params.edge_thresh = 140;
        params.latent_max_thresh = 40;
        params.use_HD = 1;
        params.half_box_h=120;  % for saving HD head videos
        params.half_box_w=120;  % for saving HD head videos


 
    else %  Database_A
    	params.margine = 4; % for 1.avi, 2.avi, 3.avi, 4.avi
        params.std_gap=1;  % 1 = for 1.avi, 2.avi, 3.avi, 4.avi  
        params.min_head_radius = 10;  % normal head radius is 25
        params.head_clip_len = 20; % must be even number
        params.min_fish_length = 50;
        params.use_bw_image=true;% false
        params.use_bigest_segment = true;
        params.ratio_thresh = 100;
        params.remove_marginal_noise_flag=0;
        params.body_margine=40;
        params.se_radius3=0;
        params.segmentation_2_sigma_factor=1;
        params.segment_size_thresh=0;
        params.segmentation_1_low_thresh=800;
        params.use_second_bounded_circle=0;
        params.avg_sz=250;
        params.local_analyzation=0;
        params.use_otsu_segmentation=0;
        params.edge_magnitude = 100;
        params.edge_thresh = 140;
        params.latent_max_thresh = 40;
        params.use_HD = 0;
        params.half_box_h=60;  % for saving head videos
        params.half_box_w=60;  % for saving head videos
    
    end
        
        
    params.graphic_idx=0;
    params.fish_idx = 0;

    
    params.y_margine=params.margine;
    params.x_margine=params.margine; 

    params.g_box_h=61*2;     % for isolating fish from the serounding
    params.g_box_w=121*2;
    params.g_box_hr=61;
    params.g_box_wr=121;
    params.g_rot_box_hr = params.g_box_hr;
    params.g_rot_box_wr = params.g_box_wr;
                        

    params.isEating=0;% 0=non-eating.  1=eating. 2=spiting.  3=open mouth with no eating


end

