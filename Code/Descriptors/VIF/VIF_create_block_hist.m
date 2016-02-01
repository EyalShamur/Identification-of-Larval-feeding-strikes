function frame_hist = VIF_create_block_hist( flow,N,M, hist_size,per_cell )

	hight = size(flow,1);
	width = size(flow,2);

	B_hight = floor((hight - 11)/N);
	B_width = floor((width - 11)/M);
%H = fspecial('Gaussian',[N M],1.0);% added by Eyal

	frame_hist = [];
	for y = 6: B_hight:hight - B_hight - 5
		for x = 6: B_width:width - B_width - 5
			block_hist = VIF_block_hist(flow( y: y + B_hight -1, x: x + B_width -1,:),hist_size);
            
            if per_cell
                 % apply Gaussin weights % added by Eyal
                %block_hist = block_hist*H(ceil(y/B_hight),ceil(x/B_width));% added by Eyal
                frame_hist = [frame_hist   block_hist];% added by Eyal
            else
                frame_hist = [frame_hist ; block_hist];  % original
            end
            

            
		end
	end

end

function  block_hist = VIF_block_hist(flow, hist_size)
    hist_interval = 1/(hist_size-1);  % added by Eyal
    flow_vec = reshape(flow, numel(flow), 1);
    %Count = histc(flow_vec,0:0.05:1);
    Count = histc(flow_vec,0:hist_interval:1);  % added by Eyal
    block_hist = Count/sum(Count);

end



