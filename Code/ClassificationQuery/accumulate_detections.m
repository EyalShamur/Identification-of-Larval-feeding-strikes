function records_params = accumulate_detections(detection_results,records_params,f_idx,mouth_x,mouth_y)

                 
                
                
    if detection_results.MBH_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.MBH_eat_event_num = records_params.MBH_eat_event_num+1;
        records_params.MBH_eating_events_table(records_params.MBH_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.MBH_non_eat_event_num=records_params.MBH_non_eat_event_num+1;
        records_params.MBH_no_eating_events_table(records_params.MBH_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y]; 
    end
    
    
    
    
    if detection_results.MIP_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.MIP_eat_event_num = records_params.MIP_eat_event_num+1;
        records_params.MIP_eating_events_table(records_params.MIP_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.MIP_non_eat_event_num=records_params.MIP_non_eat_event_num+1;
        records_params.MIP_no_eating_events_table(records_params.MIP_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end
    
     
     
    
    
    if detection_results.VIF_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.VIF_eat_event_num = records_params.VIF_eat_event_num+1;
        records_params.VIF_eating_events_table(records_params.VIF_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.VIF_non_eat_event_num=records_params.VIF_non_eat_event_num+1;
        records_params.VIF_no_eating_events_table(records_params.VIF_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end   
    
    
    
    
    if detection_results.STIP_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.STIP_eat_event_num = records_params.STIP_eat_event_num+1;
        records_params.STIP_eating_events_table(records_params.STIP_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.STIP_non_eat_event_num=records_params.STIP_non_eat_event_num+1;
        records_params.STIP_no_eating_events_table(records_params.STIP_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end   
    
    
    
    
    if detection_results.MBH_MIP_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.MBH_MIP_eat_event_num = records_params.MBH_MIP_eat_event_num+1;
        records_params.MBH_MIP_eating_events_table(records_params.MBH_MIP_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.MBH_MIP_non_eat_event_num=records_params.MBH_MIP_non_eat_event_num+1;
        records_params.MBH_MIP_no_eating_events_table(records_params.MBH_MIP_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end
 
    
    
    
    if detection_results.MBH_VIF_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.MBH_VIF_eat_event_num = records_params.MBH_VIF_eat_event_num+1;
        records_params.MBH_VIF_eating_events_table(records_params.MBH_VIF_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.MBH_VIF_non_eat_event_num=records_params.MBH_VIF_non_eat_event_num+1;
        records_params.MBH_VIF_no_eating_events_table(records_params.MBH_VIF_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y]; 
    end
    
    
    if detection_results.STIP_MIP_MBH_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.STIP_MIP_MBH_eat_event_num = records_params.STIP_MIP_MBH_eat_event_num+1;
        records_params.STIP_MIP_MBH_eating_events_table(records_params.STIP_MIP_MBH_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.STIP_MIP_MBH_non_eat_event_num=records_params.STIP_MIP_MBH_non_eat_event_num+1;
        records_params.STIP_MIP_MBH_no_eating_events_table(records_params.STIP_MIP_MBH_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end
    
    
    if detection_results.MIP_MBH_VIF_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.MIP_MBH_VIF_eat_event_num = records_params.MIP_MBH_VIF_eat_event_num+1;
        records_params.MIP_MBH_VIF_eating_events_table(records_params.MIP_MBH_VIF_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.MIP_MBH_VIF_non_eat_event_num=records_params.MIP_MBH_VIF_non_eat_event_num+1;
        records_params.MIP_MBH_VIF_no_eating_events_table(records_params.MIP_MBH_VIF_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end
    
    
    
    if detection_results.STIP_MIP_MBH_VIF_eating_class == 1  % marked as eating event
        %msg= sprintf('eating event detected: frame: %d x=%d y=%d',f_idx,int32(mouth_x),int32(mouth_y));
        %disp(msg);
        records_params.STIP_MIP_MBH_VIF_eat_event_num = records_params.STIP_MIP_MBH_VIF_eat_event_num+1;
        records_params.STIP_MIP_MBH_VIF_eating_events_table(records_params.STIP_MIP_MBH_VIF_eat_event_num,:) = [f_idx,mouth_x,mouth_y];     
    else % marked as no eating event
        records_params.STIP_MIP_MBH_VIF_non_eat_event_num=records_params.STIP_MIP_MBH_VIF_non_eat_event_num+1;
        records_params.STIP_MIP_MBH_VIF_no_eating_events_table(records_params.STIP_MIP_MBH_VIF_non_eat_event_num,:) = [f_idx,mouth_x,mouth_y];
    end

end