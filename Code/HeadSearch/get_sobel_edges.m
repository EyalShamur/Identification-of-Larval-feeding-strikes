function [n_edges, n_figure, edge_img ] = get_sobel_edges(roi, params, curr_window, curr_borders , n_figure)

    m_lowery=curr_borders(1);
    m_uppery=curr_borders(2);
    m_leftx=curr_borders(3);
    m_rightx=curr_borders(4);
    
    sobel_filter_ud = fspecial('sobel');% returns an up-down  3-by-3 filter h
    sobel_filter_du = (-1)*fspecial('sobel');% returns a down-up 3-by-3 filter h
    edge_img_hor = (imfilter(curr_window,sobel_filter_ud,'replicate'));
    edge_img_ver = (imfilter(curr_window,sobel_filter_ud','replicate'));
    edge_img_1 = max(abs(edge_img_hor),abs(edge_img_ver));
    edge_img_hor = (imfilter(curr_window,sobel_filter_du,'replicate'));
    edge_img_ver = (imfilter(curr_window,sobel_filter_du','replicate'));
    edge_img_2 = max(abs(edge_img_hor),abs(edge_img_ver));
    edge_img = max((edge_img_2),(edge_img_1));
    %lap_filter = fspecial('laplacian',0.1);% 
    %edge_img = imfilter(curr_window,lap_filter,'replicate');


    %edge_img = uint8(edge(curr_window,'log'))*255;
    active_edge_img = edge_img.*uint8(roi(m_lowery:m_uppery,m_leftx:m_rightx));
    n_edges=find(abs(active_edge_img)>params.edge_magnitude);%80
    clean_edge_img_bw=zeros(size(active_edge_img));
    clean_edge_img_bw(n_edges)=1;

    if params.draw_level==1
        figure(n_figure+1);
        n_figure=n_figure+1;
        imshow(edge_img);


        figure(n_figure+1);
        n_figure=n_figure+1;
        imshow(clean_edge_img_bw);
    end


end