function [params, mov_flipped] = rotate_fish_head_clip(params,mouth_x,mouth_y,readerobj,h,w,f_idx, isHeadedRight,rotation_mat)

    if params.classify 
        params.fish_idx = params.fish_idx+1;

        half_clip_len = params.head_clip_len/2; 
        for local_frame_idx=-1*half_clip_len:half_clip_len
            
            
            
            if f_idx+local_frame_idx <1 || f_idx+local_frame_idx>readerobj.NumberOfFrames
                continue;
            end
            mouth_y_enlarged = mouth_y+params.half_box_h*2;
            mouth_x_enlarged = mouth_x+params.half_box_w*2;
            y_start = int32(mouth_y_enlarged)-int32(params.half_box_h)*2;
            y_end = int32(mouth_y_enlarged)+int32(params.half_box_h)*2;
            x_start = int32(mouth_x_enlarged)-int32(params.half_box_w)*2;
            x_end = int32(mouth_x_enlarged)+int32(params.half_box_w)*2;

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
        

            
            
            
            
            
            
            
            
            %-------------------------------
            %{
            roi_y_beg = round(max(mouth_y - params.half_box_h,1));
            roi_y_end = round(min(mouth_y + params.half_box_h,h));
            roi_x_beg = round(max(mouth_x - params.half_box_w,1));
            roi_x_end = round(min(mouth_x + params.half_box_w,w));
            if f_idx+local_frame_idx <1 || f_idx+local_frame_idx>readerobj.NumberOfFrames
                continue;
            end
            fdata = read(readerobj, f_idx+local_frame_idx);
            %mov(local_frame_idx+11).cdata = imresize(fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:),0.5);
            mov(local_frame_idx+half_clip_len+1).cdata = fdata(roi_y_beg:roi_y_end,roi_x_beg:roi_x_end,:);
            mov(local_frame_idx+half_clip_len+1).colormap = [];
            %}
    end
        %{
        % save fish head as video
        head_file = sprintf('%s/fish_head-%d.avi',params.output_head_dir,params.fish_idx);
        movie2avi(mov, head_file, 'compression', 'None');
        attributes_file = sprintf('%s/fish_head-%d.mat',params.output_head_dir,params.fish_idx);
        frame_number = f_idx;
        input_filename = params.input_filename;
        isEating = params.isEating;
        save(attributes_file,'isEating','mouth_y','mouth_x','isHeadedRight','frame_number','rotation_mat','input_filename');

        %implay(mov);
        clear mov
        fprintf('save fish number %d\n',params.fish_idx);
    %}

    end
end
