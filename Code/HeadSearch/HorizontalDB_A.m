

readerobj = VideoReader('H:\thesis - eating fishes\DATABASES\Database-A\DB_Rot_and_Flip\fish_head-0001.avi');
%info = mmfileinfo('H:\thesis - eating fishes\DATABASES\Database-A\DB_no_rotation\fish_head-0001.avi')
%cmd prompt: ffmpeg -i "H:\thesis - eating fishes\DATABASES\Database-A\DB_no_rotation\fish_head-0001.avi";

clear all;

input_vid_dir = 'H:\thesis - eating fishes\DATABASES\Database-A\Videos-Compressed\';
input_clip_dir = 'H:\thesis - eating fishes\DATABASES\Database-A\DB';
output_Hor_dir = 'H:\thesis - eating fishes\DATABASES\Database-A\DB_Rot';
output_Flip_dir = 'H:\thesis - eating fishes\DATABASES\Database-A\DB_Rot_and_Flip';
output_no_rot_dir = 'H:\thesis - eating fishes\DATABASES\Database-A\DB_no_rotation';
head_clip_len = 20; % must be even number



half_clip_len = head_clip_len/2;


    half_box_h=60;  % for saving head videos
    half_box_w=60;  % for saving head videos
    
    
    
for clip_idx=1:450
    clear mov;
    clear mov_flipped;
clip_idx
    head_info_file = sprintf('%s/fish_head-%.4d.mat',input_clip_dir,clip_idx);
    load (head_info_file);
    if clip_idx>300
        isEating=1;
    else
        isEating=0;
    end
    %'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename'
    
    %if strcmp(input_filename,'sparus_23dph_batch2_dex2_01-09-14_11-43-03.933')
    %    input_filename = 'compressed_05_sparus_23dph_batch2_dex2_01-09-14_11-43-03.933.avi';
    %end
    
    %if strcmp(input_filename,'sparus_23dph_batch2_dex5_01-09-14_11-23-52.409')
    %    input_filename = 'compressed_05_sparus_23dph_batch2_dex5_01-09-14_11-23-52.409.avi';
    %end
    %if strcmp(input_filename,'sparus_23dph_batch2_dex7_01-09-14_11-02-01.431')
    %    input_filename = 'compressed_05_sparus_23dph_batch2_dex7_01-09-14_11-02-01.431.avi';
    %end
    input_vid = strcat(input_vid_dir,input_filename);
    %input_filename = input_vid;
    readerobj = VideoReader(input_vid);
    f_idx = frame_number;
    
    
%{
    [active_y active_x] = find(roi==1);
    acive_y_norm = active_y-box_hr;
    acive_x_norm = active_x-box_wr;
    rot_xy = [acive_x_norm acive_y_norm]*(rotation_mat);

    rot_roi = zeros(g_box_h,g_box_w);

    for rot_idx=1:size(rot_xy,1);
        x_val = round(rot_xy(rot_idx,1)+rot_box_wr);
        y_val = round(rot_xy(rot_idx,2)+rot_box_hr);
        if y_val>0 && x_val>0
            if y_val<=size(rot_roi,1) && x_val<=size(rot_roi,2)
                rot_roi(y_val,x_val)=1;
            end
        end
    end
%}

    direction = rotation_mat(:,1); %main eigen vector is always the first one
    angle_radian = atan2(direction(2),direction(1));
    angle_degree = (angle_radian*180)/pi;
                    
                    
     draw_img = 0;               
    for local_frame_idx=-1*half_clip_len:half_clip_len
        if f_idx+local_frame_idx <1 || f_idx+local_frame_idx>readerobj.NumberOfFrames
            continue;
        end
        mouth_y_enlarged = mouth_y+half_box_h*2;
        mouth_x_enlarged = mouth_x+half_box_w*2;
        y_start = int32(mouth_y_enlarged)-int32(half_box_h)*2;
        y_end = int32(mouth_y_enlarged)+int32(half_box_h)*2;
        x_start = int32(mouth_x_enlarged)-int32(half_box_w)*2;
        x_end = int32(mouth_x_enlarged)+int32(half_box_w)*2;
        
        %if y_start<1 y_start=1; end
        %if y_end>readerobj.Height y_end=readerobj.Height; end
        %if x_start<1 x_start=1; end
        %if x_end>readerobj.Width x_end=readerobj.Width; end
        
        
        I = read(readerobj, f_idx+local_frame_idx);
        I_enlarged = uint8(zeros(size(I,1)+int32(half_box_h)*4,size(I,2)+int32(half_box_w)*4,size(I,3)));
        I_enlarged(int32(half_box_h)*2+1:size(I,1)+int32(half_box_h)*2,int32(half_box_w)*2+1:size(I,2)+int32(half_box_w)*2,:)= I;
        K = I_enlarged(y_start:y_end,x_start:x_end,:);
        K = rgb2gray(K);
        J = imrotate(K,angle_degree,'bilinear','crop');
        
        y_start = half_box_h;
        y_end = half_box_h*3;
        x_start = half_box_w;
        x_end = half_box_w*3;
        
        %if y_start>size(J,1) y_start=size(J,1); end
        %if y_end>size(J,1) y_end=size(J,1); end
        %if x_start>size(J,2) x_start=size(J,2); end
        %if x_end>size(J,2) x_end=size(J,2); end
        
        
        
        L = K(y_start:y_end,x_start:x_end);
        L_rotated = J(y_start:y_end,x_start:x_end);
        if isHeadedRight
            L_flipped = L_rotated;
        else
            L_flipped = fliplr(L_rotated);
        end
        
        
        
        if draw_img
            figure(1);
            imshow(I);
            figure(2);
            imshow(I_enlarged);
            figure(3);
            imshow(K);
            figure(4);
            imshow(J);
            figure(5);
            imshow(L);
        end
        
        
        
        mov(local_frame_idx+half_clip_len+1).cdata(:,:,1) = L;
        mov(local_frame_idx+half_clip_len+1).cdata(:,:,2) = L;
        mov(local_frame_idx+half_clip_len+1).cdata(:,:,3) = L;
        mov(local_frame_idx+half_clip_len+1).colormap = [];
        
        mov_rotated(local_frame_idx+half_clip_len+1).cdata(:,:,1) = L_rotated;
        mov_rotated(local_frame_idx+half_clip_len+1).cdata(:,:,2) = L_rotated;
        mov_rotated(local_frame_idx+half_clip_len+1).cdata(:,:,3) = L_rotated;
        mov_rotated(local_frame_idx+half_clip_len+1).colormap = [];
        
        mov_flipped(local_frame_idx+half_clip_len+1).cdata(:,:,1) = L_flipped;
        mov_flipped(local_frame_idx+half_clip_len+1).cdata(:,:,2) = L_flipped;
        mov_flipped(local_frame_idx+half_clip_len+1).cdata(:,:,3) = L_flipped;
        mov_flipped(local_frame_idx+half_clip_len+1).colormap = [];
    end
    

%{     
    for local_frame_idx=-1*half_clip_len:half_clip_len
        roi_y_beg = round(max(mouth_y - half_box_h,1));
        roi_y_end = round(min(mouth_y + half_box_h,h));
        roi_x_beg = round(max(mouth_x - half_box_w,1));
        roi_x_end = round(min(mouth_x + half_box_w,w));

        fdata = read(readerobj, f_idx+local_frame_idx);
        %mov(local_frame_idx+11).cdata = imresize(fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:),0.5);
        mov(local_frame_idx+half_clip_len+1).cdata = fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:);
        mov(local_frame_idx+half_clip_len+1).colormap = [];
    end
%}    
    
    
    
   % save fish head as video
    head_file = sprintf('%s/fish_head-%.4d.avi',output_no_rot_dir,clip_idx);
    movie2avi(mov, head_file, 'compression', 'None');
    %implay(head_file);
    attributes_file = sprintf('%s/fish_head-%.4d.mat',output_no_rot_dir,clip_idx);
    frame_number = f_idx;
    save(attributes_file,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');

    head_file = sprintf('%s/fish_head-%.4d.avi',output_Hor_dir,clip_idx);
    movie2avi(mov_rotated, head_file, 'compression', 'None');
    %implay(head_file);
    attributes_file = sprintf('%s/fish_head-%.4d.mat',output_Hor_dir,clip_idx);
    frame_number = f_idx;
    save(attributes_file,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
    
    head_file = sprintf('%s/fish_head-%.4d.avi',output_Flip_dir,clip_idx);
    movie2avi(mov_flipped, head_file, 'compression', 'None');
    %implay(head_file);
    attributes_file = sprintf('%s/fish_head-%.4d.mat',output_Flip_dir,clip_idx);
    frame_number = f_idx;
    save(attributes_file,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');
   

    %readerobj = VideoReader(head_file);
    %ccc = read(readerobj, 1);
    %figure(5);
    %imshow(ccc);
end


enprog=9999;



    
    
    