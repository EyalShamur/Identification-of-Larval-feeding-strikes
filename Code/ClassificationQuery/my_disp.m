function  my_disp( msg, log_file_name )
%MY_DISP Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(log_file_name,'a+' );  %Open file, or create new file, for writing; append data to the end of the file.
if fid<0
        fprintf('Error: Can''t open log file %s \r\n',log_file_name);
        return;
end
if isstruct(msg)
    f = fieldnames(msg);
    for i=1: size(f,1)
        fieldname =char(f(i)); 
        field_value = getfield(msg,fieldname);
        if isinteger(field_value)
            fprintf(fid,'%s = %d\r\n',fieldname,field_value);
        end
        if ischar(field_value)
            fprintf(fid,'%s = %s\r\n',fieldname,field_value);
        end
        if isfloat(field_value)
            fprintf(fid,'%s = %f\r\n',fieldname,field_value);
        end
        
    end
else
        if isinteger(msg)
            fprintf(fid,'%d\r\n',msg);
        end
        if ischar(msg)
            fprintf(fid,'%s\r\n',msg);
        end
        if isfloat(msg)
            fprintf(fid,'%f\r\n',msg);
        end
    %fprintf(fid,msg);
    %fprintf(fid,'\r\n');

end
fclose(fid);
disp(msg);

end

