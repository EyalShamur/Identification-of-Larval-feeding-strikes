function [mouth_x, mouth_y, isHeadedRight, mouth_validity, n_figure] = locate_fish_mouth(rot_roi,head_location_x, h, w, params, fish_location,se_radius1,rot_box_wr, rotation_mat, n_figure)

    mouth_validity=1;       
    body_hist=sum(rot_roi);
    % smooth hist
    body_hist = imfilter(body_hist,[0.25 0.25 0.25 0.25]);
    if params.draw_level==1
        figure(n_figure+1);
        n_figure=n_figure+1;
        plot(body_hist);
    end
    %if mean_x>rot_box_wr 
        % HORIZONTAL FISH
        % fish headed to the right

        derived = body_hist(1:end-1)-body_hist(2:end);
        derived = fliplr(derived);
        dr_positive = find(derived>=0.75);
        if isempty(dr_positive)
            fprintf('No derivation found. Skipping fish\n');
            mouth_validity=0;
            mouth_x=-1; mouth_y=-1; isHeadedRight=-1;
            return;
        end
        derived_idx=dr_positive(1)-se_radius1-params.se_radius3;
        edge_right = params.g_box_w-derived_idx;% coord syatem origin is the lower left corner
        horisontal_mouth_location = [rot_box_wr-derived_idx 0];% coord syatem origin is the center of the box (roi)
        back_rotation_mat = inv(rotation_mat);
        shift_mouth_location =  horisontal_mouth_location*back_rotation_mat;
        mouth_y_right = fish_location(1)+shift_mouth_location(2);
        mouth_x_right = fish_location(2)+shift_mouth_location(1);
    %else
        % fish headed to the left

        derived = body_hist(2:end)-body_hist(1:end-1);
        dr_positive = find(derived>=0.75);
        if isempty(dr_positive)
            fprintf('No derivation found. Skipping fish\n');
            mouth_validity=0;
            mouth_x=-1; mouth_y=-1; isHeadedRight=-1;
            return;
        end
        derived_idx=dr_positive(1)+1+se_radius1+params.se_radius3;
        edge_left = derived_idx; % coord syatem origin is the lower left corner
        horisontal_mouth_location = [  derived_idx-rot_box_wr 0]; % coord syatem origin is the center of the box (roi)
        back_rotation_mat = inv(rotation_mat);
        shift_mouth_location =  horisontal_mouth_location*back_rotation_mat;
        mouth_y_left = fish_location(1)+shift_mouth_location(2);
        mouth_x_left = fish_location(2)+shift_mouth_location(1);
    %end


    left_dist = abs(edge_left-head_location_x);
    right_dist = abs(edge_right-head_location_x);

    if left_dist>params.min_fish_length || right_dist>params.min_fish_length
        fish_is_long_enough = 1; % all of the fish body is inside the frame
    else
        fish_is_long_enough = 0; %can not see all of the fish body. see only head or only tail
    end

    if abs(left_dist-right_dist) > 5
        head_location_certainty = 1; 
    else
        head_location_certainty = 0; % dont_know_where_the_head_is
    end

    if (fish_is_long_enough && head_location_certainty)  

        if (right_dist<left_dist  ) 
            % HORIZONTAL FISH
            % fish headed to the right
            if params.draw_level==1
                fprintf('fish headed right\n');
            end
            mouth_y = mouth_y_right;
            mouth_x = mouth_x_right;
            isHeadedRight=1;
        else
            % fish headed to the left
            if params.draw_level==1
                fprintf('fish headed left\n');
            end 
            mouth_y = mouth_y_left;
            mouth_x = mouth_x_left;
            isHeadedRight=0;
        end
    else
            % dont_know_where_the_head_is
            if params.draw_level==1
                fprintf('fish is on border. mouth located as body center\n');
            end 
            mouth_y = (mouth_y_left+mouth_y_right)/2;
            mouth_x = (mouth_x_left+mouth_x_right)/2;
            isHeadedRight=2;
    end





    margine_for_mouth_location = 2;
    %{
    if mouth_y<1+margine_for_mouth_location || mouth_x<1+margine_for_mouth_location || mouth_y>h-margine_for_mouth_location || mouth_x>w-margine_for_mouth_location
                fprintf('Fish head out of boundaries. Skipping fish\n');
                continue;
    end
    %}
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
               

end