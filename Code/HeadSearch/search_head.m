function  [head_found, mean_x, mean_y, n_figure] = serch_head(rot_roi, params, rot_box_hr, n_figure)


    head_found = false;
    mean_y = -99999999;
    mean_x = -99999999;
    for er_radius =round(rot_box_hr):-1:params.min_head_radius
       SE_erode = strel('disk', er_radius,4);
       circle = imerode(rot_roi,SE_erode);
       % remove founded circles that are not on the main
       % fish axis
       %circle(1:uint32(size(rot_roi,1)/2)-2,:)=0;
       %circle(uint32(size(rot_roi,1)/2)+2:end,:)=0;
       [circle_y circle_x] = find(circle==1);
       if ~isempty(circle_y)
            if params.use_second_bounded_circle                           
                er_radius=er_radius-4;                           
                SE_erode = strel('disk', er_radius,8);
                circle = imerode(rot_roi,SE_erode);
                % remove founded circles that are not on the main
                % fish axis
                circle(1:uint32(size(rot_roi,1)/2)-2,:)=0;
                circle(uint32(size(rot_roi,1)/2)+2:end,:)=0;
                [circle_y, circle_x] = find(circle==1);
            end                          

           mean_y = mean(circle_y);
           mean_x = mean(circle_x);
           head_found = true;
           if params.draw_level==1
                figure(n_figure+1);
                n_figure=n_figure+1;
                imshow(circle*255);
                %rotroi11=rot_roi*255;
                
                fish_head = zeros(size(rot_roi,1),size(rot_roi,2), 3);
                fish_head(:,:,1)=uint8(rot_roi*255);
                fish_head(:,:,2)=uint8(rot_roi*255);
                fish_head(:,:,3)=uint8(rot_roi*255);
                head_color = [0,200,150];
                fish_head = draw_circle_arround_mouth(fish_head, params, mean_x, mean_y,size(rot_roi,2),size(rot_roi,1), er_radius, uint8(head_color));
                figure(n_figure+1);
                n_figure=n_figure+1;
                imshow(fish_head);
                

            
            
           end
           break;
       end
    end




end
