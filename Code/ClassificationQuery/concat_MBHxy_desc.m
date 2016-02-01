function [mbh, mbh_file] = concat_MBHxy_desc(mbh_dir,clip_idx)

    desc_len = 96;  % 96
    mbhx=[];
    mbhy=[];
    mbh=[];
    mbh_file='';
    
    % Output
    MBH_desc_dir = sprintf('%s\\DESCRIPTOR',mbh_dir);
    
    if ~my_create_dir(MBH_desc_dir); return; end;


    f1 = sprintf('%.4d',clip_idx);
    %msg = sprintf('***************  Max-Min MBH:  video  %s  ***************\n',...
    %                                  f1);
    %fprintf(msg);
    x_dir = strcat(mbh_dir,'\MBHx\MBHx_7-',f1);
    y_dir = strcat(mbh_dir,'\MBHy\MBHy_7-',f1);
    x_dir_output = strcat(mbh_dir,'\MBHx\MBHx_DESCRIPTOR\MBHx_7-',f1);
    y_dir_output = strcat(mbh_dir,'\MBHy\MBHy_DESCRIPTOR\MBHy_7-',f1);
    mbhx_file = strcat(x_dir_output ,'.mat');
    mbhy_file = strcat(y_dir_output ,'.mat');
    mbh_file = strcat(mbh_dir,'\DESCRIPTOR\MBH_7-',f1,'.mat');
    %---------------------------

    mbhx_txt_file = strcat(x_dir ,'.txt');
    mbhy_txt_file = strcat(y_dir ,'.txt');
    fidx = fopen(mbhx_txt_file);
    fidy = fopen(mbhy_txt_file);

    i=0;
    while ~feof(fidx) && ~feof(fidy)
        i=i+1;

        % # point-type x y t sigma2 tau2 detector-confidence dscr-hog(72) dscr-hof(90)
        m_x = fscanf(fidx, '%f', [desc_len 1]);  
        if size(m_x,1) ~=desc_len
            break;
        end
        m_y = fscanf(fidy, '%f', [desc_len 1]);
        if size(m_y,1) ~=desc_len
            break;
        end
        mbhx(1:desc_len,i) = m_x;
        mbhy(1:desc_len,i) = m_y;
    end

    if (~isempty(mbhx)) && (~isempty(mbhy))
        mbh=[mbhx; mbhy;];
    else
        mbh(1:2*desc_len,1) = 0;
    end
    %save(mbhx_file,'mbhx');
    %save(mbhy_file,'mbhy');
    save(mbh_file,'mbh');


    fclose('all');
        
    
    

       


end