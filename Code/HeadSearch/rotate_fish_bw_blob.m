function [rot_roi, se_radius1, n_figure] = rotate_fish_bw_blob(roi, rotation_mat, params, rot_box_wr, rot_box_hr, box_hr, box_wr, n_figure, offset)

                    [active_y, active_x] = find(roi==1);
                    acive_y_norm = active_y-box_hr-offset(1);
                    acive_x_norm = active_x-box_wr-offset(2);
                    rot_xy = [acive_x_norm acive_y_norm]*(rotation_mat);
                    
                    rot_roi = zeros(params.g_box_h,params.g_box_w);
                    
                    for rot_idx=1:size(rot_xy,1);
                        x_val = round(rot_xy(rot_idx,1)+rot_box_wr);
                        y_val = round(rot_xy(rot_idx,2)+rot_box_hr);
                        if y_val>0 && x_val>0
                            if y_val<=size(rot_roi,1) && x_val<=size(rot_roi,2)
                                rot_roi(y_val,x_val)=1;
                            end
                        end
                    end
                        
                    se_radius1=1;
                    SE_dilate = strel('disk', se_radius1,8);
                    rot_roi = imdilate(rot_roi,SE_dilate);


                    if params.draw_level==1
                        figure(n_figure+1);
                        n_figure=n_figure+1;
                        imshow(rot_roi*255);
                    end
                        

end