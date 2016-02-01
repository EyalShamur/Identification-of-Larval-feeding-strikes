function [roi, seg_validity n_figure ] = roi_dominant_segment(roi, params, num_,L_, n_figure, near_center_flag, fish_est_location )
    seg_validity = 1;
    if params.use_bigest_segment
        m_size_=0;
        for L_idx_ = 1:num_
            [seg_y_,seg_x_] = find(L_==L_idx_);
            c_size_ = size(seg_y_,1);
            if m_size_<c_size_
                m_size_=c_size_;
                m_idx_ = L_idx_;
            end
        end
    else % use the segment nearest the center of roi
        if near_center_flag
            reference_y = size(roi,1)/2;
            reference_x = size(roi,2)/2;
        else
            reference_y = fish_est_location(1);
            reference_x = fish_est_location(2);
        end
        global_min = size(roi,1)+size(roi,2); % biggest num that can be
        for L_idx_ = 1:num_
            [seg_y_,seg_x_] = find(L_==L_idx_);
            c_size_ = size(seg_y_,1);
            if c_size_<100  % check size of segment as well
                %continue;
            end
            if c_size_> params.segment_size_thresh  % check size of segment as well
                %continue;
            end
            y_dist = seg_y_- double(reference_y);
            x_dist = seg_x_- double(reference_x);
            L1dist = abs(y_dist)+abs(x_dist);
            local_min = min(L1dist);
            if local_min<global_min
                global_min=local_min;
                m_idx_ = L_idx_;
            end
        end 

        if global_min>40
            seg_validity=0;
        end
    end
                    
    roi(:,:)=0;
    roi (find(L_==m_idx_))=1;
    if params.draw_level==1
        figure(n_figure+1);% 6
        n_figure=n_figure+1;
        imshow(roi*255);
    end

    %SE_erode = strel('disk', 5,8);
    %SE_erode = strel('rectangle', [5  5]);

    if params.se_radius3~=0
        SE_dilate = strel('disk', params.se_radius3,8);
        %roi = imerode(roi,SE_erode);
        roi = imdilate(roi,SE_dilate);
        if params.draw_level==1
            figure(n_figure+1);% 7
            n_figure=n_figure+1;
            imshow(roi*255);
            %roi10=uint8(roi*255);
        end   
    end         
           

end
