function records_params = record_detections(query_log_file, video_file,start_frame,end_frame,records_params)

        my_disp(strcat('video_file=',video_file), query_log_file); 
        my_disp(sprintf('start_frame=%d',uint32(start_frame)), query_log_file);
        my_disp(sprintf('end_frame=%d',uint32(end_frame)), query_log_file);

        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('MBH', query_log_file);
        my_disp('===', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.MBH_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.MBH_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.MBH_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.MBH_eating_events_table(query_idx,1)),int32(records_params.MBH_eating_events_table(query_idx,2)),int32(records_params.MBH_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('MIP', query_log_file);
        my_disp('===', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.MIP_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.MIP_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.MIP_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.MIP_eating_events_table(query_idx,1)),int32(records_params.MIP_eating_events_table(query_idx,2)),int32(records_params.MIP_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('STIP', query_log_file);
        my_disp('====', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.STIP_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.STIP_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.STIP_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.STIP_eating_events_table(query_idx,1)),int32(records_params.STIP_eating_events_table(query_idx,2)),int32(records_params.STIP_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('VIF', query_log_file); 
        my_disp('===', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.VIF_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.VIF_non_eat_event_num)), query_log_file);
         my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.VIF_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.VIF_eating_events_table(query_idx,1)),int32(records_params.VIF_eating_events_table(query_idx,2)),int32(records_params.VIF_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('MBH+MIP', query_log_file);
        my_disp('=======', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.MBH_MIP_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.MBH_MIP_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.MBH_MIP_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.MBH_MIP_eating_events_table(query_idx,1)),int32(records_params.MBH_MIP_eating_events_table(query_idx,2)),int32(records_params.MBH_MIP_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('MBH+VIF', query_log_file);
        my_disp('=======', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.MBH_VIF_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.MBH_VIF_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.MBH_VIF_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.MBH_VIF_eating_events_table(query_idx,1)),int32(records_params.MBH_VIF_eating_events_table(query_idx,2)),int32(records_params.MBH_VIF_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file); 
        my_disp('STIP+MIP+MBH', query_log_file);
        my_disp('============', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.STIP_MIP_MBH_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.STIP_MIP_MBH_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.STIP_MIP_MBH_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.STIP_MIP_MBH_eating_events_table(query_idx,1)),int32(records_params.STIP_MIP_MBH_eating_events_table(query_idx,2)),int32(records_params.STIP_MIP_MBH_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('MIP+MBH+VIF', query_log_file);
        my_disp('===========', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.MIP_MBH_VIF_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.MIP_MBH_VIF_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.MIP_MBH_VIF_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.MIP_MBH_VIF_eating_events_table(query_idx,1)),int32(records_params.MIP_MBH_VIF_eating_events_table(query_idx,2)),int32(records_params.MIP_MBH_VIF_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
        
        
        my_disp('', query_log_file);
        my_disp('', query_log_file);
        my_disp('STIP+MIP+MBH+VIF', query_log_file);
        my_disp('================', query_log_file);
        my_disp(sprintf('eat_event_num=%d',uint32(records_params.STIP_MIP_MBH_VIF_eat_event_num)), query_log_file);
        my_disp(sprintf('no_eat_event_num=%d',uint32(records_params.STIP_MIP_MBH_VIF_non_eat_event_num)), query_log_file);
        my_disp('frame   mouth_x   mouth_y', query_log_file);
        my_disp('-----   -------   -------', query_log_file);
        for query_idx=1:size(records_params.STIP_MIP_MBH_VIF_eating_events_table,1);
            msg = sprintf('%d      %d      %d',int32(records_params.STIP_MIP_MBH_VIF_eating_events_table(query_idx,1)),int32(records_params.STIP_MIP_MBH_VIF_eating_events_table(query_idx,2)),int32(records_params.STIP_MIP_MBH_VIF_eating_events_table(query_idx,3)));
            my_disp(msg, query_log_file);
        end
end