function [roi, box_hr, box_wr, rot_box_hr,rot_box_wr, x, y,y_min,y_max,x_min,x_max,m_lowery,m_uppery,m_leftx,m_rightx, n_figure ]= get_roi(params,head_mask,fish_location, slop, h, w, n_figure)

    if abs(slop) < 1
        % horizontal fish
        box_h=params.g_box_h;
        box_w=params.g_box_w;
        box_hr=params.g_box_hr;
        box_wr=params.g_box_wr;
        rot_box_hr = params.g_rot_box_hr;
        rot_box_wr = params.g_rot_box_wr;
        x = linspace(-50,49,100);  %# x values at a higher resolution
        y = fish_location(1)+(slop*x);
        x=fish_location(2)+x;
    else
        % vertical fish

        box_w=params.g_box_h;
        box_h=params.g_box_w;
        box_wr=params.g_box_hr;
        box_hr=params.g_box_wr;
        rot_box_wr = params.g_rot_box_wr;
        rot_box_hr = params.g_rot_box_hr;
        y = linspace(-50,49,100);  %# x values at a higher resolution
        x = fish_location(2)+(y/slop);
        y = fish_location(1)+y;      

    end
    clear roi
    round_x =round(fish_location(2)); 
    round_y =round(fish_location(1));
    y_min = max(1,round_y-box_hr);
    y_max = min(h,round_y+box_hr);
    x_min = max(1,round_x-box_wr);
    x_max = min(w,round_x+box_wr);

    if x_min==1
        m_leftx = 1+(1-(round_x-box_wr))+params.x_margine;
        x_min = x_min+params.x_margine;
    else
        m_leftx=1;
    end
    if y_min ==1; 
        m_lowery = 1+(1-(round_y-box_hr))+params.y_margine;
        y_min = 1+params.y_margine;
    else
        m_lowery=1; 
    end
    if x_max==w
        m_rightx = box_wr*2+1-(round_x+box_wr-w)-params.x_margine;
        x_max = x_max-params.x_margine;
    else
        m_rightx = box_wr*2+1;
    end
    if y_max == h
        m_uppery = box_hr*2+1-(round_y+box_hr-h)-params.y_margine;
        y_max=h-params.y_margine;
    else
        m_uppery=box_hr*2+1;
    end



    if params.use_bw_image
        partial_roi  = head_mask(y_min:y_max,x_min:x_max);
        roi=uint8(zeros(box_h,box_w));
        roi(m_lowery:m_uppery,m_leftx:m_rightx)=partial_roi; 
    else

        if params.draw_level==1
            partial_roi  = head_mask(y_min:y_max,x_min:x_max);
            roi=uint8(zeros(box_h,box_w));
            roi(m_lowery:m_uppery,m_leftx:m_rightx)=partial_roi;
            figure(n_figure+1);% 2

            n_figure=n_figure+1;
            imshow(uint8(roi)*255);

            clear partial_roi;
            clear roi;
        end


        partial_roi  = currFrame(y_min:y_max,x_min:x_max);
        mean_gray = mean(mean(partial_roi)');
        roi=ones(box_h,box_w)*mean_gray;
        roi(m_lowery:m_uppery,m_leftx:m_rightx)=partial_roi;  

        %roi = currFrame(y_min:y_max,x_min:x_max);
        if params.draw_level==1
            figure(n_figure+1); %3
            n_figure=n_figure+1;
            imshow(uint8(roi));
            %roi8=uint8(roi);
        end


        active_roi = reshape(roi,size(roi,1)*size(roi,2),1);
        std_ = std(single(active_roi));
        mean_ = mean(single(active_roi));
        body_idx = find(roi<mean_- params.segmentation_2_sigma_factor*std_); %find(roi<mean_-0.5*std_);
        roi(:,:)=0;
        roi(body_idx)=1;

        radius2=4;
        SE_erode = strel('disk', radius2,8);
        roi = imerode(roi,SE_erode);
        roi = imdilate(roi,SE_erode);

        if params.draw_level==1
            figure(n_figure+1); % 4
            n_figure=n_figure+1;
            imshow(uint8(roi)*255);
            %roi8=uint8(roi);
        end

    end





    radius2=2;                      
    if radius2~=0
        radius2=2;
        SE_erode = strel('disk', radius2,8);
        roi = imerode(roi,SE_erode);
        %roi = imdilate(roi,SE_erode);

    end



    if params.draw_level==1
        figure(n_figure+1); % 5
        n_figure=n_figure+1;
        imshow(roi*255);
        %roi9=uint8(roi*255);
    end
                    
                    

end