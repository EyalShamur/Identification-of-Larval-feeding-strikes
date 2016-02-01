function [ scaled_mat , shift, m, num_of_bad_bins] = my_scale( my_mat  )
%MY_SCALE Summary of this function goes here
%   Detailed explanation goes here
    scaled_mat = my_mat;
    [a, b] = size(my_mat);
    if a ==0  || isempty(a)
        num_of_bad_bins = 0;
        return;
    end
    
    max_val = (max(my_mat));
    min_val = (min(my_mat));
    shift = (-min_val);
    counter = 0;
    for j=1:size(max_val,2)
        if max_val(1,j)-min_val(1,j) > 0
            m(1,j) = 1.0/(max_val(1,j)-min_val(1,j));
        else
            m(1,j) = 1.0;
            counter=counter+1;
        end
    end
    
    for i=1:size(my_mat,1)
        %shift to 0
        scaled_mat(i,:) = my_mat(i,:)+shift;

        %scale to be in the interval(0...1)
        scaled_mat(i,:) = scaled_mat(i,:).*m;
    end
    num_of_bad_bins = counter;
    sz = size(max_val,2);
    disp(sprintf('Num of bad bins (all zeros): %d out of %d',counter,sz));

end



