function [validity,roi,fish_location,direction,x,y,rotation_mat] = local_analyze(edge_img,fish_location,n_figure,draw_level,segmentation_1_low_thresh,ratio_thresh,m_lowery,m_uppery,m_leftx,m_rightx,box_h,box_w)
  
  

    validity=0;
    roi=0;

    direction=0;
    x=0;
    y=0;
    rotation_mat=0;
  

    se_radius4=6;
    SE_dilate = strel('disk', se_radius4,4);
    %roi = imerode(roi,SE_erode);
    d_edge_img = imdilate(edge_img,SE_dilate);
    if draw_level==1
        figure(n_figure+1);% 8
        n_figure=n_figure+1;
        imshow(d_edge_img);
        %roi10=uint8(roi*255);
        
    end
        
        
        [L, num] = bwlabel(d_edge_img, 8);
        m_idx=0;
        max_seg_sz=0;
        for L_idx = 1:num
            
            [seg_y,seg_x] = find(L==L_idx);
            local_seg_sz = size(seg_y,1);
            
            if max_seg_sz<local_seg_sz
                if local_seg_sz < segmentation_1_low_thresh % too small segment
                    do_nothing=99;
                    %continue;
                end

                if local_seg_sz > 20000 % too large segment
                    do_nothing=99;
                    %continue;
                end
                
                max_seg_sz=local_seg_sz;
                m_idx = L_idx;
            end
        end     
        [seg_y,seg_x] = find(L==m_idx);



        % Rows of X correspond to observations, columns to variables
        [COEFF,SCORE,latent]=princomp([seg_x seg_y ]);   % X size = 10x128    % zscore
        % latent is  a vector containing the eigenvalues of the covariance
        % matrix of X.
        % COEFF is a p-by-p matrix, each column containing coefficients
        % for one principal component. The columns are in order of decreasing component variance
        if abs(latent(1))>abs(latent(2))
            if abs(latent(2))>0.00001
                ratio = abs(latent(1))/abs(latent(2));
            else
                ratio = 999999999999;
            end
        else
            if abs(latent(1))>0.00001
                ratio = abs(latent(2))/abs(latent(1));
            else
                 ratio = 999999999999;
            end
        end
        latent_max = max(latent');
        fish_local_location = [mean(seg_y) mean(seg_x)];



        if (ratio<ratio_thresh) && (latent_max>60)

                % direction
                max_id=find(latent==latent_max,1,'first');
                min_id=find(latent~=latent_max,1,'last');
                direction = COEFF(:,max_id);



            partial_roi=zeros(size(d_edge_img));
            partial_roi (find(L==m_idx))=1;



            roi=zeros(box_h,box_w);
            roi(m_lowery:m_uppery,m_leftx:m_rightx)=partial_roi;  


            fish_location=fish_local_location+fish_location+round([m_lowery-size(partial_roi,1)/2 m_leftx-size(partial_roi,2)/2]);
            rotation_mat = [COEFF(:,max_id ) COEFF(:,min_id) ];
            if (abs(direction(1)) > 0.0001) %&& n_fishes==2 %&& abs(direction(2)-0.1435)<0.001 % 21276
                save_validity = 1;
                slop = direction(2)/direction(1);
            else
                slop = 999999;
            end
            if abs(slop) < 1
                    % horizontal fish
                    rotation_mat = [COEFF(:,max_id) COEFF(:,min_id) ];
                    x = linspace(-50,49,100);  %# x values at a higher resolution
                    y = fish_location(1)+(slop*x);
                    x=fish_location(2)+x;
                else
                    % vertical fish
                    y = linspace(-50,49,100);  %# x values at a higher resolution
                    x = fish_location(2)+(y/slop);
                    y = fish_location(1)+y;      
            end 
        
            validity = 1;
            
        end
        
        
end  % function