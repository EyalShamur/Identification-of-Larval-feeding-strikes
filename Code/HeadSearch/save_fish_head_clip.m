function [params] = save_fish_head_clip(params,mouth_x,mouth_y,readerobj,h,w,f_idx, isHeadedRight,rotation_mat)

    if params.save_fish_heads 
        params.fish_idx = params.fish_idx+1;

        half_clip_len = params.head_clip_len/2; 
        for local_frame_idx=-1*half_clip_len:half_clip_len
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
        end
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

    end
end
