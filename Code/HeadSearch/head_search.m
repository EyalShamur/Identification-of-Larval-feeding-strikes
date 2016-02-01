function [head_mask] = head_search(currFrame, margine, draw_level,std_gap,avg_sz)

clear head_img
%currFrame = imadjust(currFrame);
    [h, w] = size(currFrame);
    head_img = zeros(h, w);

    ww_s = uint32(margine+1); %uint32(w/8);
    ww_e = uint32(w-margine); %uint32(w-w/8);
    hh_s = uint32(margine+1); %uint32(h/8);
    hh_e = uint32(h-margine); %uint32(h-h/8);
    active_img = currFrame(hh_s:hh_e,ww_s:ww_e);
    active_img = reshape(active_img,size(active_img,1)*size(active_img,2),1);
    %std_ = std(single(active_img));
    %mean_ = mean(single(active_img));
    %head_idx = find(currFrame<mean_-4*std_);
    active_img_for_std = reshape(currFrame,size(currFrame,1)*size(currFrame,2),1);
    
    std_ = std(single(active_img));
    avg_filter = fspecial('average', [avg_sz avg_sz]); %[250 250]
    avg_img = imfilter(currFrame,avg_filter,'symmetric'); %replicate
    diff_img = int32(currFrame)-int32(avg_img);
    head_idx = find(diff_img<-std_gap*std_);
    
    
    
    
    

    head_img(head_idx) = 255;
    if draw_level==1
    	figure(30);
    	imshow(head_img);
    end
    head_img = medfilt2(head_img, [7 7]);

    
    if draw_level==1
    	figure(31);
    	imshow(head_img);
    end


    
    SE_erode = strel('rectangle', [5  5]);
    SE_dilate = strel('disk', 2,6);  % prev radius = 5 
    head_mask_erode = imerode(head_img,SE_erode);
    if draw_level==1
    	figure(32);
    	imshow(head_mask_erode);
    end

    head_mask = uint8(imdilate(head_mask_erode,SE_dilate));
    if draw_level==1
    	figure(33);
    	imshow(head_mask);
    end  
    
    % remove margines
    head_mask(1:margine,:)=0;
    head_mask(:,1:margine)=0;
    head_mask(size(head_mask,1)-margine:size(head_mask,1),:)=0;
    head_mask(:,size(head_mask,2)-margine:size(head_mask,2))=0;
    
    if draw_level==1
    	figure(34);
    	imshow(head_mask);
    end  
    
end