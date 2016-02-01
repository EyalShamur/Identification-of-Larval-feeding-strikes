function fdataCurr = draw_direction_line(fdataCurr, x,y,w,h,params)

    if params.draw_level==1 || params.draw_level==3 || params.draw_level==2
        for v_idx = 1:size(x,2)  
            if round(y(v_idx))-1 > 0 && round(x(v_idx))-1 >0
                if round(y(v_idx))+1 < h && round(x(v_idx))+1 <w
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,1)=255;
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,2)=0;
                    fdataCurr(round(y(v_idx))-1:round(y(v_idx))+1,round(x(v_idx))-1:round(x(v_idx))+1,3)=0;
                end
            end
        end
    end

end