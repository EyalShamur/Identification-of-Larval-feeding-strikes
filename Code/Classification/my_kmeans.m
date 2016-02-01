

function [output] =  my_kmeans(data, kmeans_type, k, n_presentors, assign_center)
            
            
            
% inputs:
%          data : collection of points to be classified/assigned , 
%                 valve of each element should be in the interval [0,1]
%                 each point is a colomn in data array. 
%                 Valve of each element is adopted inside this func to  the integer interval [0,255]
%                 for  vl_hikmeans(...) and vl_ikmeans(...) 
%          k :    num of clusters
%          kmeans_type:1= matlab poor kmeans
%                      2= hirarcial kmeans by using elkan method in vlfeat lib
%                      3= ikmans by using elkan method in vlfeat lib
%          n_presentors: 0 means no presentors. kmean use all data. 
%          assign_center: true=assign cluster center to each point. 
%                         false=assign cluster tag (id)  to each point
            
        if(ispc)
            run('C:\Program Files\MATLAB\R2008b Student\toolbox\vlfeat\toolbox\vl_setup')  % add vlfeat lib
        else
            if(isunix)
                run('/home/shared/tal-research/eyalsh38/vlfeat/toolbox/vl_setup')  % add vlfeat lib
            else
                 disp ( 'my_kmeans supports pc and unix platforms only') ;
                 output=0;
                 return;
            end
        end
        
            
         use_old_kmeans = kmeans_type==1;
         use_hi_kmeans = kmeans_type==2;
         use_i_kmeans = kmeans_type==3;
         if(use_old_kmeans)
                PRSZ=1000;
                r=int32(rand(PRSZ,1)*size(hsv_vector,1));
                presentors=hsv_vector(r,:);

                % find centroids  C of clusters by K-means
                tStart=tic;
                [IDX, C] = kmeans(presentors,k,'emptyaction','drop'); 
                t_elapsed = toc(tStart);
                [msg, errmsg] = sprintf('\n kmeans time = %d \n',t_elapsed);
                    disp ( msg) ;

                    tStart=tic;
                % assign centroid for each 
                  dist = zeros(size(C,1),1);
                    for m=1:size(hsv_vector,1)
                        for j=1:size(C,1)
                            dist(j) = sum((hsv_vector(m)-C(j)).*(hsv_vector(m)-C(j)));
                        end
                        cluster_id = find(dist==min(dist));
                        hsv_vector(m) = C(cluster_id(1));
                    end          

                t_elapsed = toc(tStart);
                [msg, errmsg] = sprintf('\n kmeans time = %d \n',t_elapsed);
                disp ( msg) ;
         end      
             
        if(use_hi_kmeans)
            % Heirarchial Integer K-means
             tStart=tic;
            if( n_presentors == 0)
                K=4; % num of branches for vertex ( num os sons)
                nleaves = k;  % 5000
                data = uint8(data*255);
                [tree,AT] = vl_hikmeans(data,K,nleaves,'method', 'elkan') ;
            else
            
            
                r=int32(rand(n_presentors,1)*size(data,1));
                idx = find(r==0);
                if isempty(idx) == false
                r(idx)=1;
                end
                presentors=data(:,r);
                K=4; % num of branches for vertex ( num os sons)
                nleaves = k;  % 5000
                p_data = uint8(presentors*255);
                % data has clmn wise representation. ie. each clmn represents a point

               

                [tree,A] = vl_hikmeans(p_data,K,nleaves,'method', 'elkan') ;


                % classify new data
                newdata = uint8(data*255);
                AT       = vl_hikmeanspush(tree,newdata) ;
            end
            
            m = size(AT,1); % tree height
            
            
            if(assign_center) % assign cluster center to each point
                [ m t] = size(AT); % m= tree height  t=num of newdata points
                for t=1:length(data)
                    my_tree = tree;
                    for z=1:m%-1
                        if isempty(my_tree.sub)
                            if isempty(my_tree.centers)
                                % do nothing. use the cluster_center found in
                                % prev loop.
                                break;
                            else
                                cluster_center = my_tree.centers(:,AT(z,t));
                            end
                        else
                            cluster_center = my_tree.centers(:,AT(z,t)); % keep cluster_center of prev loop
                            my_tree = my_tree.sub(AT(z,t));  % update my_tree for next iter

                        end
                    end

                    cluster_center = double(cluster_center')/255;
                    output(t,:)=cluster_center;
                  
                end
            else  % assign cluster tag for each point ( cluster id)
                m = size(AT,1); % tree height
                n = size(AT,2); % num of newdata points
                tags = zeros(n,1);
                for t=1:n
                   tag = 0;
                   for i=1:m
                      tag = tag+(AT(i,t)-1)*power(K,m-i);
                  end
                  tags(t)=tag;
                end
                
            end
            output=tags;

            t_elapsed = toc(tStart);
            [msg, errmsg] = sprintf('\n hi_kmean time = %d \n',t_elapsed);
            disp ( msg) ;
        end
                
       if(use_i_kmeans)           
            PRSZ=1000;
            r=int32(rand(PRSZ,1)*size(data,1));
            idx = find(r==0);
            if isempty(idx) == false
            r(idx)=1;
            end
            presentors=data(r,:);
            K = 166;  % 5000
            data = uint8(presentors'*255);
            % data has clmn wise representation. ie. each clmn represents rgb

            tStart=tic;
           [C,A] = vl_ikmeans(data,K,'method', 'elkan') ;
           newdata = uint8(data'*255);
           AT = vl_ikmeanspush(newdata,C) ;
            for id=1:length(data)
                output(id,:)=double(C(:,AT(id))')/255;
            end
            t_elapsed = toc(tStart);
            [msg, errmsg] = sprintf('\n assign centroid time = %d \n',t_elapsed);
            disp ( msg) ;
       end
        
       
end

