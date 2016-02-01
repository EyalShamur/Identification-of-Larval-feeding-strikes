function [status] = my_create_dir(dir_name)

    status=1;
    if ~exist(dir_name,'dir')  
        [s,message,messid] = mkdir(dir_name);
        if s == 0 % fail
            fprintf(message); 
            status=0 ; 
        end  
    end

end 