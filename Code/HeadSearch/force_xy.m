function force_xy()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % princomp.m
    clear vars
    close all
    
    ffnum = 28540;
    isEating=1;
    fish_idx=99;
    forced_x = 22/2;
    forced_y = 530/2;
    isHeadedRight = 1;
    draw_level = 2;
    
    output_head_dir = 'H:\thesis - eating fishes\DATABASES\Database-B';
    input_filename = 'sparus_22dph_batch1_dex0_01-05-14_11-25-39.779';
    ext = '.avi';
    input_file = strcat('H:\thesis - eating fishes\DATABASES\Database-B\Videos-Compressed\compressed_05_',input_filename,ext);
    clear mov
    readerobj = VideoReader(input_file);
    %implay(input_file);
    half_box_h=60;  % for saving head videos
    half_box_w=60;  % for saving head videos
    
    margine = 20; 
    std_gap=0.5;% 1.0;  % smaller value = bigger segments
    head_clip_len = 40; % must be even number
    avg_sz=150;
    
    save_fish_heads=1;
        
    try
        fdataCurr = read(readerobj, ffnum);
        currFrame = (rgb2gray(fdataCurr));
        %imshow(currFrame);
        [h, w] = size(currFrame);
    catch
       fprintf('error read frame:    %d\n', ffnum); 

    end
       
    mouth_x=forced_x;
    mouth_y=forced_y;
                                      
    y_min = round(max(mouth_y - half_box_h,margine/2));
    y_max = round(min(mouth_y + half_box_h,h-margine/2));
    x_min = round(max(mouth_x - half_box_w,margine/2));
    x_max = round(min(mouth_x + half_box_w,w-margine/2));
                                                
    patch_win = currFrame(y_min:y_max,x_min:x_max);
    head_mask = uint8(head_search(patch_win,margine/2,draw_level,std_gap,avg_sz)./255);
    %radius3=3;
    %SE_d = strel('disk', radius3,8);
    %head_mask = imdilate(head_mask,SE_d);
    [L, num] = bwlabel(head_mask, 8);

    [seg_y,seg_x] = find(L==1);

    % Rows of X correspond to observations, columns to variables
    [COEFF,SCORE,latent]=princomp([seg_x seg_y ]);   % X size = 10x128    % zscore
    % latent is  a vector containing the eigenvalues of the covariance
    % matrix of X.
    % COEFF is a p-by-p matrix, each column containing coefficients
    % for one principal component. The columns are in order of decreasing component variance
    latent_max = max(latent');
    max_id=find(latent==latent_max,1,'first');
    min_id=find(latent~=latent_max,1,'last');
    rotation_mat = [COEFF(:,max_id ) COEFF(:,min_id) ];


    direction = COEFF(:,max_id);
                
    if (abs(direction(1)) > 0.0001) %&& n_fishes==2 %&& abs(direction(2)-0.1435)<0.001 % 21276
        slop = direction(2)/direction(1);
        if abs(slop) < 1
            % horizontal fish
            x = linspace(-50,49,100);  %# x values at a higher resolution
            y = mouth_y+(slop*x);
            x=mouth_x+x;
        else
            y = linspace(-50,49,100);  %# x values at a higher resolution
            x = mouth_x+(y/slop);
            y = mouth_y+y;
        end
    end
                        

                    
                    
    margine_for_mouth_location = 2;

    if mouth_y<1+margine_for_mouth_location
        mouth_y=1;

    end
    if mouth_x<1+margine_for_mouth_location
        mouth_x=1;
    end                    
     if mouth_y>h-margine_for_mouth_location
        mouth_y=h-1;
    end                   
    if mouth_x>w-margine_for_mouth_location
        mouth_x=w-1;
    end 
                    
                    
    if draw_level==1 || draw_level==3 || draw_level==2
        r=20;
        th = 0:pi/20:2*pi;
        xunit = uint32(r * cos(th) + mouth_x);
        yunit = uint32(r * sin(th) + mouth_y);

        for a_idx=1:41
            if (yunit(a_idx)-2 > 0) && (xunit(a_idx)-2>0)
                if ((yunit(a_idx)+2)<h) && ((xunit(a_idx)+2)<w)
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 1) = 0;
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 2) = 255;
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 3) = 0;
                end
            end
        end


        for v_idx = 1:size(x,2)  
            if round(y(v_idx))-1 > 0 && round(x(v_idx))-1 >0
                if round(y(v_idx))+1 < h && round(x(v_idx))+1 <w
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,1)=255;
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,2)=0;
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,3)=0;
                end
            end
        end
    end
                    
	if save_fish_heads 
        fish_idx = fish_idx+1;

        half_clip_len = head_clip_len/2; 
        for local_frame_idx=-1*half_clip_len:half_clip_len
            roi_y_beg = round(max(mouth_y - half_box_h,1));
            roi_y_end = round(min(mouth_y + half_box_h,h));
            roi_x_beg = round(max(mouth_x - half_box_w,1));
            roi_x_end = round(min(mouth_x + half_box_w,w));
            if ffnum+local_frame_idx <1 || ffnum+local_frame_idx>readerobj.NumberOfFrames
                continue;
            end
            fdata = read(readerobj, ffnum+local_frame_idx);
            %mov(local_frame_idx+11).cdata = imresize(fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:),0.5);
            mov(local_frame_idx+half_clip_len+1).cdata = fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:);
            mov(local_frame_idx+half_clip_len+1).colormap = [];
        end
        % save fish head as video
        head_file = sprintf('%s/fish_head-%d.avi',output_head_dir,fish_idx);
        movie2avi(mov, head_file, 'compression', 'None');
        attributes_file = sprintf('%s/fish_head-%d.mat',output_head_dir,fish_idx);
        frame_number = ffnum;
        save(attributes_file,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');

        %implay(mov);
        clear mov
        fprintf('save fish number %d\n',fish_idx);

	end
                    
	if  draw_level==1 || draw_level==2
        figure(101);

        imshow(fdataCurr);
    end
                    
                    
end

