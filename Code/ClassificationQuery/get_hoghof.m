function [hoghof] = get_hoghof(stip_txt_file)

        hog = [];
        hof = [];
        hoghof=[];

        fid = fopen(stip_txt_file);
        tline1 = fgetl(fid);
        tline2 = fgetl(fid);
        tline3 = fgetl(fid);
        i=0;
        while ~feof(fid)
            i=i+1;
            % # point-type x y t sigma2 tau2 detector-confidence dscr-hog(72) dscr-hof(90)
            params = fscanf(fid, '%f', [7 1]);  
            t_hog = fscanf(fid, '%f', [72 1]);
            if size(t_hog,1) ~=72
                break;
            end
            hog(1:72,i) = t_hog;
            t_hof = fscanf(fid, '%f', [90 1]);
            if size(t_hof,1) ~=90
                break;
            end
            hof(1:90,i) = t_hof;
            hoghof(1:162,i)=[hog(1:72,i);hof(1:90,i);];
        end
        
        if (~isempty(hog)) && (~isempty(hof))
            % do nothing
        else
            hog(1:72,1) = 0;
            hof(1:90,1) = 0;
            hoghof(1:162,1)=0;
 
        end

        fclose('all');
        

end