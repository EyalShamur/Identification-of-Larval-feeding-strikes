function  aa_head_search()
clear params
close all
tStart=tic;

                
    params = param_setting();
    
    readerobj = VideoReader(params.input_file);
    if params.use_HD
        HD_readerobj = VideoReader(params.HD_input_file);
    end
    nFrames = readerobj.NumberOfFrames;
    fprintf('Total num of frames %d  \n', nFrames);
    
    % reset counters
    eat_event_num = 0;
    eating_events_table = [];     
    no_eat_event_num=0;
                
                
    start_frame=29310;%32310;%10;
    end_frame=29310;%11500;%32310;%26160;

    if params.classify  % init 
        query_log_file_eating = 'H:\Thesis - eating fishes\Classification_temp_data\B_eating_detection_table.txt';
        fid=fopen(query_log_file_eating,'w'); % discard current content
        fclose(fid);
        query_log_file_non_eating = 'H:\Thesis - eating fishes\Classification_temp_data\B_non_eating_detection_table.txt';
        fid=fopen(query_log_file_non_eating,'w'); % discard current content
        fclose(fid);
        addpath('H:\Thesis - eating fishes\Code\ClassificationQuery');
        records_params = init_records();
    end
    
	for f_idx = start_frame:10:end_frame    
        fclose('all');
        fprintf('head search frame num %d  \n', f_idx);
        
        % Read frame
        try
            fdataCurr = read(readerobj, f_idx);
        catch
           fprintf('error read frame:    %d\n', f_idx); 
           continue;
        end
        
        % Convert frame to gray image
        currFrame = (rgb2gray(fdataCurr));
        if params.draw_level==1 || params.draw_level==2
            figure(1); %1
            imshow(currFrame);
        end
        [h, w] = size(currFrame); 
        
        % Remove margines. Usually done with frames that has black stripes
        % on margines cuased by inaccurate camera positioning.
        if params.remove_marginal_noise_flag
            currFrame=remove_marginal_noise(currFrame,params.draw_level,3,3);
            currFrame=remove_marginal_noise(currFrame,params.draw_level,3,w-3);
            %currFrame=remove_marginal_noise(currFrame,params.draw_level,h-3,w-3);
        end
        
        % Segmentation       
        if params.use_otsu_segmentation
            n_classes = 20;
            [IDX,sep]=otsu(currFrame,n_classes);
            seg_ing = uint8(zeros(size(currFrame)));
            for i_classes=1:n_classes
                i_c=find(IDX==i_classes);
                seg_ing(i_c) = uint8(i_classes*floor(255/n_classes));

            end
            if params.draw_level==1
                figure(2);% 2
                imshow(seg_ing);
            end
        else
            seg_ing=currFrame;
        end
        
        
 
        % Convert segmentation into binary segmentation, remove margines
        head_mask = uint8(head_search(seg_ing,params.margine,params.draw_level,params.std_gap,params.avg_sz)./255);


        
        
        
        % Number all segments
        [L, num] = bwlabel(head_mask, 8);
        
        n_fishes=1;  % count found fishes 
        
        % For each segment do the next:
        for L_idx = 1:num
            if L_idx ~=17 %17 %26
                %continue;
            end
            
            %{
            % Skip segments for debugging
            if L_idx ~= 7 
                continue;
            else
                params.draw_level = 1; % draw all
            end
            %}
            
            n_figure=2; % Figures counter and naming
            
            % Get current segment
            [seg_y,seg_x] = find(L==L_idx);
            
            % Remove segments below threshold
            if size(seg_y,1) < params.segmentation_1_low_thresh % too small segment
                continue;
            end
            
            % Remove segments above threshold
            if size(seg_y,1) > 10000 % too large segment
                continue;
            end
            
            
            % mark current segment we work on
            if params.draw_level==5
                %{
                fish_location = [mean(seg_y) mean(seg_x)];
                s_ = uint32(fish_location-3);
                e_ = uint32(fish_location+3);

                figure(1000);% 2
                drawimg=head_mask;
                drawimg(s_(:,1):e_(:,1),s_(:,2):e_(:,2))=0;
                s_ = uint32(fish_location-1);
                e_ = uint32(fish_location+1);
                drawimg(s_(:,1):e_(:,1),s_(:,2):e_(:,2))=255;
                fdataCurr = draw_fish_number(fdataCurr, fish_location(1), fish_location(2),w,h,params,L_idx);
                imshow(uint8(drawimg)*255);
                %}
                
                drawimg = uint8(zeros(size(head_mask,1),size(head_mask,2),3));
                drawimg(:,:,1)=uint8(head_mask*255);
                drawimg(:,:,2)=uint8(head_mask*255);
                drawimg(:,:,3)=uint8(head_mask*255);
                
                for drawimg_idx=1:size(seg_y,1)
                    drawimg(seg_y(drawimg_idx),seg_x(drawimg_idx),2:3)=0; 
                end
                imshow(uint8(drawimg));
                
                clear partial_roi;
                clear roi;
            end

            
            
            % Remove fish if it is too close to image margines            
            fish_location = [mean(seg_y) mean(seg_x)];          
            if (fish_location(1)<=params.body_margine) && ...
               (fish_location(2)<=params.body_margine) && ...
               (fish_location(1)>= h-params.body_margine) && ...
               (fish_location(2)>= w-params.body_margine)
           
                continue;
            end
            
            
            addpath('C:\Program Files\MATLAB\R2013a\toolbox\stats\stats'); % pca , perfcurve.m
            % PCA : getting main axis (direction), rotation matrix, eigen values ratio.
            [COEFF,SCORE,latent]=princomp([seg_x seg_y ]);   % X size = 10x128
            % Rows of X correspond to observations, columns to variables
            % latent is  a vector containing the eigenvalues of the covariance
            % matrix of X.
            % COEFF is a p-by-p matrix, each column containing coefficients
            % for one principal component. The columns are in order of decreasing component variance
            if abs(latent(1))>abs(latent(2))
                if abs(latent(2))>0.00001
                    eigen_ratio = abs(latent(1))/abs(latent(2));
                else
                    eigen_ratio = 999999999999;
                end
            else
                if abs(latent(1))>0.00001
                    eigen_ratio = abs(latent(2))/abs(latent(1));
                else
                     eigen_ratio = 999999999999;
                end
            end
            latent_max = max(latent');
            
            % Set fish main exis direction
            max_id=find(latent==latent_max,1,'first');
            min_id=find(latent~=latent_max,1,'last');
            direction = COEFF(:,max_id);
            rotation_mat = [COEFF(:,max_id ) COEFF(:,min_id) ];

            
            

            % Remove segments with too elongated shape
            candidate_validity = 1;
            if (eigen_ratio>=params.ratio_thresh) || (latent_max<=params.latent_max_thresh)
                continue;
            end
            
            
            
            % Count num fishes found
            n_fishes = n_fishes+1;




            if (abs(direction(1)) > 0.0000001)
                slop = direction(2)/direction(1);
            else
                slop = 99999999999; % big num.
            end
            

    
                    
            % Get region of interest - ROI - arround fish blob for further
            % and closer analyzation
            [roi, box_hr, box_wr, rot_box_hr,rot_box_wr, x, y, y_min, y_max, x_min, x_max, m_lowery, m_uppery, m_leftx, m_rightx, n_figure]=...
               get_roi(params,head_mask, fish_location, slop, h, w, n_figure);

            % Region of interest segmentation         
            [L_, num_] = bwlabel(roi, 8);
            if num_==0
                continue;
            end
            

            % Get dominant segment in the roi, clear all other segments
            [roi, seg_validity, n_figure ]= roi_dominant_segment(roi, params, num_,L_, n_figure, 1,0 );         
            if seg_validity==0
               continue;
            end
           
           
            % Count Sobel edges on domunant segment
            curr_window  = currFrame(y_min:y_max,x_min:x_max);
            curr_borders = [m_lowery  m_uppery m_leftx  m_rightx];
            [n_edges, n_figure, edge_img ] = ...
                get_sobel_edges(roi, params, curr_window, curr_borders, n_figure);
           

            % Remove segments that has no fish texture (with too few edges)
            if length(n_edges)<params.edge_thresh
                continue;  % in order to avoid noise
            end

            %{                          
            if params.local_analyzation

                [validity,roi,fish_location,direction,x,y,rotation_mat] = ...
                    local_analyze(clean_edge_img_bw,fish_location,n_figure,params.draw_level,...
                    params.segmentation_1_low_thresh,params.ratio_thresh,...
                    m_lowery,m_uppery,m_leftx,m_rightx,box_h,box_w);

                if ~validity
                    continue;
                end

            end  

            %}
            
           %-----------------------------------
           % Local segmentation + subtruction of stationary objects.
           if params.use_HD
               fr_step=50;%10;
               if f_idx-fr_step > 0 && f_idx-fr_step < nFrames
                    try
                        fdataPrev = read(readerobj, f_idx-fr_step);
                        fdataNext = read(readerobj, f_idx+fr_step);
                    catch
                       fprintf('error read frame:    %d\n', f_idx-fr_step); 
                       continue;
                    end
               
                    % Convert frame to gray image
                    prevFrame = (rgb2gray(fdataPrev));
                    nextFrame = (rgb2gray(fdataNext));

                    prev_window = prevFrame(y_min:y_max,x_min:x_max);
                    next_window = nextFrame(y_min:y_max,x_min:x_max);
                    
                    fish_location_in_roi = fish_location-[y_min x_min];

                    [roi, seg_validity, n_figure ] = local_segmentation(curr_window,edge_img, params, n_figure,prev_window,next_window,fish_location_in_roi);

                    if seg_validity==0
                       continue;
                    end
               end
           else
               fish_location_in_roi = fish_location-[y_min x_min];
           end

            %-----------------------------------
            
            
            
            % Rotate BW fish blob image 
            fish_offset = fish_location_in_roi-[box_hr box_wr]; % the dist vector of fish loc from center of roi
            [rot_roi, se_radius1, n_figure] = rotate_fish_bw_blob(roi, rotation_mat, params, rot_box_wr, rot_box_hr, box_hr, box_wr, n_figure, fish_offset);

            
            % Remove blob if it is too small
            rot_non_zero = find(rot_roi>0); 
            if length(rot_non_zero)<params.segmentation_1_low_thresh
                continue;
            end
            
            
            
        
            % Locate fish head using max bounded circle
            [head_found, head_location_x, head_location_y, n_figure] = search_head(rot_roi, params, rot_box_hr, n_figure);
            % Remove blob if fish head could not be found
            if ~head_found 
                continue;
            end
                        
                    
            % Locate fish mouth 
            [mouth_x, mouth_y, isHeadedRight, mouth_validity, n_figure] = locate_fish_mouth(rot_roi,head_location_x, h, w,params,fish_location,se_radius1,rot_box_wr, rotation_mat, n_figure);
            % Remove blob if fish mouth search fails
            if ~mouth_validity 
                continue;
            end
                    
            
            % Add diagnostics to image
            params.fish_idx = params.fish_idx+1;
            %if params.fish_idx == 3
            %    params.fish_idx = params.fish_idx-1;
            %    continue;
            %end
            mouth_color = [0,255,0];
            fdataCurr = draw_circle_arround_mouth(fdataCurr, params, mouth_x, mouth_y,w,h, 20,mouth_color);
            fdataCurr = draw_direction_line(fdataCurr, x,y,w,h,params);
            %fdataCurr = draw_fish_number(fdataCurr, mouth_x, mouth_y,w,h,params,L_idx);

                    
            % Save fish head clip 
            params = save_fish_head_clip(params,mouth_x,mouth_y,readerobj,h,w,f_idx, isHeadedRight,rotation_mat);



            % Classify
            if params.classify
                addpath('H:\Thesis - eating fishes\Code\ClassificationQuery'); 
                if params.use_HD
                    disp(sprintf('frame=%d, segment:=%d, mouth_x=%d, mouth_y=%d',f_idx,L_idx,uint32(2*mouth_x),uint32(2*mouth_y)));
                    n_1 = HD_readerobj.NumberOfFrames;
                    n_2 = readerobj.NumberOfFrames;
                    compression_shift = uint32((f_idx*(n_1-n_2))/n_1);   
                    HD_f_idx = f_idx+compression_shift; 
                    HD_mouth_x = mouth_x*2;
                    HD_mouth_y = mouth_y*2;
                    [params, head_file_name]=rotate_fish_head_clip(params,HD_mouth_x,HD_mouth_y,HD_readerobj,h,w,HD_f_idx, isHeadedRight,rotation_mat);
                else
                    disp(sprintf('frame=%d, segment=%d, mouth_x=%d, mouth_y=%d',f_idx,L_idx,uint32(mouth_x),uint32(mouth_y)));
                    [params, head_file_name]=rotate_fish_head_clip(params,mouth_x,mouth_y,readerobj,h,w,f_idx, isHeadedRight,rotation_mat);
                end
                [detection_results, query_param] = fish_classifier(head_file_name, params.Database);
                
                if params.use_HD
                    records_params = accumulate_detections(detection_results,records_params,HD_f_idx,HD_mouth_x,HD_mouth_y);
                else
                    records_params = accumulate_detections(detection_results,records_params,f_idx,mouth_x,mouth_y);
                end
                
            
            end

            
        end
        
        % Draw diagnostics
        if  params.draw_level==1 || params.draw_level==2
            figure(101);
            n_figure=n_figure+1;
            imshow(fdataCurr);
        end
        
        % Add diagnostics to video clip
        if params.draw_level==3
            params.graphic_idx = params.graphic_idx+1;
            %mov(params.graphic_idx).cdata = imresize(fdataCurr,0.25);
            mov(params.graphic_idx).cdata = fdataCurr;
            mov(params.graphic_idx).colormap = [];
        end
        

    end
    
    if params.classify
        record_eat_detections(query_log_file_eating, params.input_file,start_frame,end_frame,records_params, query_param); 
        record_no_eat_detections(query_log_file_non_eating, params.input_file,start_frame,end_frame,records_params, query_param);
    end
    
    % Save and play diagnostics on video clip
    if params.draw_level==3                     
        implay(mov);
        % save movie
        movie2avi(mov, params.output_file, 'compression', 'None');
    end

    t_elapsed = toc(tStart);
    [msg, errmsg] = sprintf(' Video search time = %d seconds',uint32(t_elapsed));
    disp ( msg) ;
end

