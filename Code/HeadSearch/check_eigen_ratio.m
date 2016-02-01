
w=100;
h=100;
my_img = uint8(zeros(w,h));
width = 80;
hight = 10;
iii=0;
        for i=h/2-hight/2:h/2+hight/2-1
            for j=w/2-width/2+iii:w/2+width/2-1-iii
                my_img(i,j)=255;
            end
            %iii=iii+1;
        end
        
 imshow(my_img);
 
        %radius3=3;
        %SE_d = strel('disk', radius3,8);
        %head_mask = imdilate(head_mask,SE_d);
        [L, num] = bwlabel(my_img, 8);
        [seg_y,seg_x] = find(L==1);

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
            
endofprig=1;
            
            