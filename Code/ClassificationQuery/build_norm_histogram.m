function [hist] = build_norm_histogram(class,hist_volume,hist_nbins)



index = 0;

    hist = double(zeros(1,hist_nbins)); 
    nsbsps = size(class,1);

    if nsbsps~=0
        for i_sbsp = 1: nsbsps
            index = index+1;
            if class(index)>hist_nbins || class(index)<0
                disp('BUG !!!  BUG !!! in build_norm_histogram(...)');
                disp('index acceeds num of bins. Check that the num of hisogram bins is power of K ( usualy K=4)'); 
                disp(sprintf('index = %d while num of histogram bins is :',class(index),hist_nbins));
                %class(index)
                continue;
            end
            hist(1,class(index)) = hist(1,class(index))+1; % +1 as there is a class 0
        end
    end
    
    hist = (hist*hist_volume)/nsbsps;  % norm



if index ~= size(class,1)
    disp('BUG !!!  BUG !!! in build_norm_histogram(...)');
end


%plot(hist);
end