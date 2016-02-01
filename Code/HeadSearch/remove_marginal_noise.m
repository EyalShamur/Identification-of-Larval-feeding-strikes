function [currFrame]=remove_marginal_noise(currFrame, draw_level, corner_y, corner_x)

    [h, w] = size(currFrame);
    
mean_val = mean(reshape(currFrame,h*w,1));
    chroma_key = currFrame(corner_y,corner_x);
    ck_threshh=6;
    bw_img = zeros(size(currFrame));
    idx=find(abs(currFrame-chroma_key)<ck_threshh);
    bw_img(idx)=1;
    
    radius=4;
    SE_erode = strel('disk', radius,8);
    bw_img = imerode(bw_img,SE_erode);
    radius=2;
    SE_dilate = strel('disk', radius,8);
    bw_img = imdilate(bw_img,SE_dilate);
    if draw_level==1
        figure(20);
        imshow(bw_img*255);
    end

    [L, num] = bwlabel(bw_img, 8);
    mask=zeros(size(currFrame));
    for L_idx = 1:num
        [seg_y,seg_x] = find(L==L_idx);
        diff_yx = abs(seg_y - corner_y)+abs(seg_x - corner_x);
        in_the_correct_margine = find(diff_yx < 2);
        if isempty(in_the_correct_margine)  % check the segment is the segment on the desire corner
            continue;
        end
        
        % fish segment is arround 5000 pixels
        if size(seg_y,1) < 1000 % too small segment
            continue;
        end

        if size(seg_y,1) > h*w/5 % too large segment
            continue;
        end
        
        
        
        for fill_idx=1 : size(seg_y,1)
              mask(seg_y(fill_idx,1), seg_x(fill_idx,1) )=255; 
        end
    end
    radius=6;
    SE_dilate = strel('disk', radius,8);
    mask = imdilate(mask,SE_dilate);
    idx_msk = find(mask>0);
    currFrame(idx_msk)=uint8(mean_val);
    if draw_level==1
        figure(21);
        imshow(currFrame); 
    end
end