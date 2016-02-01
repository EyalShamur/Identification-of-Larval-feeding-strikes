function [roi, seg_validity, n_figure ] = local_segmentation(curr_window,edge_img, params, n_figure,prev_window,next_window,fish_est_location)



                % locate water surface (this will be later used to remove
                % water surface edges)
                surface_y=0;
                for h_idx=1:size(curr_window,1)
                    curr_mean = mean(curr_window(h_idx,:)');
                    curr_var = var(single(curr_window(h_idx,:)'));
                    if curr_mean<30 && curr_var<50
                        surface_y=h_idx;
                    else
                        break;
                    end   
                end
                
                botom_y=size(curr_window,1);
                for h_idx=size(curr_window,1):-1:1
                    curr_mean = mean(curr_window(h_idx,:)');
                    curr_var = var(single(curr_window(h_idx,:)'));
                    if curr_mean<30 && curr_var<50
                        botom_y=h_idx;
                    else
                        break;
                    end
                end
                
                                
                
                water_surface = uint8(ones(size(curr_window)));
                if surface_y>0
                    water_surface(1:surface_y+10,:)=uint8(0);
                end
                if botom_y<size(curr_window,1)
                    water_surface(botom_y-10:size(curr_window,1),:)=uint8(0);
                end
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);
                    imshow(water_surface*255);
                end
                
                
                
                % Get moving objects (this will be later used to remove stationary objects
                diff_image_n = imabsdiff(curr_window,next_window);
                diff_image_p = imabsdiff(curr_window,prev_window);
                diff_image = bitor(diff_image_n,diff_image_p);
                sigma=1;
                h_gauss=fspecial('gaussian',[3 3],sigma);
                diff_image = imfilter(diff_image,h_gauss);
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);
                    imshow(diff_image);
                end
                diff_image_bw=zeros(size(diff_image));
                %diff_image_bw(find(diff_image>10))=1;
                diff_image_bw(find(diff_image>8))=1;
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);
                    imshow(diff_image_bw*255);
                end
                dilate_radius = 2;
                SE_dilate = strel('disk', dilate_radius,8);
                %roi = imerode(roi,SE_erode);
                diff_image_bw = imdilate(diff_image_bw,SE_dilate);
                if params.draw_level==1
                    figure(n_figure+1);% 7
                    n_figure=n_figure+1;
                    imshow(diff_image_bw*255);
                end   
 


               % Get edged objects (this will be later used to remove plane objects
               if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(curr_window);
                end
               if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(edge_img);
               end
               sigma=4;
                h_gauss=fspecial('gaussian',[5 5],sigma);
                thick_edges_img = imfilter(edge_img,h_gauss);
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(thick_edges_img);
                end
                darken_img = curr_window-2*thick_edges_img;
                darken_img(find(darken_img<0))=0;
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(darken_img);
                end 
                n_classes = 10;
                [IDX,sep]=otsu(darken_img,n_classes);
                seg_ing = uint8(zeros(size(darken_img)));
                for i_classes=1:n_classes
                    i_c=find(IDX==i_classes);
                    seg_ing(i_c) = uint8(i_classes*floor(255/n_classes));

                end
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(seg_ing);
                end

                head_mask_local = uint8(head_search(seg_ing,0,0,0.1,80)./255);

                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(head_mask_local*255);
                end

                
                
                
                
                
                
                
                % Remove stationary objects and plane objects
                temp = bitand(uint8(water_surface), uint8(diff_image_bw));
                if params.draw_level==1
                    n_figure=n_figure+1;
                    figure(n_figure);% 2
                    imshow(uint8(temp)*255);
                end
                head_mask_local = bitand(uint8(head_mask_local), uint8(temp));
                
                
                

                % Region of interest segmentation to identify domunant segment        
                [L_, num_] = bwlabel(head_mask_local, 8);
                if num_==0
                    seg_validity=0;
                    return;
                end
                % Get dominant segment in the roi, clear all other segments
                params2=params;
                params2.se_radius3=3;
                [roi, seg_validity, n_figure ]= roi_dominant_segment(head_mask_local, params2, num_,L_, n_figure, 0, fish_est_location );    

end