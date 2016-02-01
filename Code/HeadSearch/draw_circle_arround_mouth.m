function fdataCurr = draw_circle_arround_mouth(fdataCurr, params, mouth_x, mouth_y,w,h,r, color)

    if params.draw_level==1 || params.draw_level==3 || params.draw_level==2
        %r=20;
        th = 0:pi/20:2*pi;
        xunit = uint32(r * cos(th) + mouth_x);
        yunit = uint32(r * sin(th) + mouth_y);

        for a_idx=1:41
            if (yunit(a_idx)-2 > 0) && (xunit(a_idx)-2>0)
                if ((yunit(a_idx)+2)<h) && ((xunit(a_idx)+2)<w)
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 1) = color(1);
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 2) = color(2);
                    fdataCurr(uint32(floor((yunit(a_idx)-2))):uint32(floor((yunit(a_idx)+2))), uint32(floor((xunit(a_idx)-2))):uint32(floor((xunit(a_idx)+2))) , 3) = color(3);
                end
            end
        end
    end

end