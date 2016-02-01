function feature_vec = VIF_create_feature_vec(VIF_params,path,file_name)
%       
% Inputs:
%          path , file_name    - of the AVI file. 
%
% Outputs:
%          feature_vec    -  vector of VIF features, size = M * N * 21. 
%{
	%FR   = 25;            % frame rate
	movment_int = 1;      % frames intervat between Current frame and Prev frame
	N = 3;  %4;              % number of  vertical blocks in frame
	M = 3;  %4;              % number of  horisontal blocks in frame
    T = 1.0;%1.0;         % Threshold
    H = 21; %21;        hist_size
	S  = 17;% =n_time_sections.  added by Eyal
    per_cell = 1;
    %K=4;
%}    
   	movment_int = VIF_params.movment_int;      % frames intervat between Current frame and Prev frame
	N = VIF_params.N;  %4;              % number of  vertical blocks in frame
	M = VIF_params.M;  %4;              % number of  horisontal blocks in frame
    T = VIF_params.T;%1.0;         % Threshold
    H = VIF_params.H; %21;        hist_size
	S  = VIF_params.S;% =n_time_sections.  added by Eyal
    per_cell = VIF_params.per_cell;
     
    
    
	%mov1 = aviread(fullfile(path,file_name));
    mov =  VideoReader(fullfile(path,file_name));
%mcd = mov.cdata;

	frame_gap = 2*movment_int;

	index = 0;
	%flow = zeros(100,134);
    flow = zeros(mov.Height,mov.Width);
	% for every Frame
	%for f = 1:frame_gap:length(mov)- frame_gap -5 
    
    
    Section_length = floor((mov.NumberOfFrames- frame_gap -5)/S);% added by Eyal
    feature_vec = [];% added by Eyal
    for section=1:S  % added by Eyal
        start_frame = (section-1)*Section_length+1; % added by Eyal
        end_frame = section*Section_length;% added by Eyal
        
        for f= start_frame:frame_gap:end_frame% added by Eyal
        %for f = 1:frame_gap:mov.NumberOfFrames- frame_gap -5


            % Ignore 3 first frames of the clip 
            Prev_F =           read(mov,f+3);%mov(f + 3).cdata;                                    
            Current_F =        read(mov,f + 3 + movment_int);%mov(f + 3 + movment_int).cdata;
            Next_F =           read(mov,f + 3 + 2*movment_int);%mov(f + 3 + 2*movment_int).cdata;

            % if colored movie change to gray levels
            if size(Current_F,3)>1                                                       
                Prev_F = rgb2gray(Prev_F);
                Current_F = rgb2gray(Current_F);
                Next_F = rgb2gray(Next_F);
            end

            Prev_F = single(Prev_F);
            Current_F = single(Current_F);
            Next_F = single(Next_F);
    %{
            eyal remove this. need to be returned
            rescale = 100 / size(Current_F,1);
            if rescale < 0.8
                Prev_F = imresize(Prev_F, rescale);
                Current_F = imresize(Current_F, rescale);
                Next_F = imresize(Next_F, rescale);
            end
    %}

            [m1,vx1,vy1] = VIF_create_frame_flow(Prev_F, Current_F,  N, M);
            index = index + 1;
            [m2,vx2,vy2] = VIF_create_frame_flow(Current_F, Next_F,  N, M );
            delta = abs(m1 - m2);
            flow = flow + double(delta > T*(mean2(delta)));
        end
        flow = flow./index;
        
        %feature_vec = VIF_create_block_hist(flow,N,M);
        temp = VIF_create_block_hist(flow,N,M, H, per_cell);% added by Eyal
        %feature_vec_per_section(:,section) = temp;% added by Eyal
 feature_vec = [feature_vec temp];
    end % added by Eyal
 
 %for section=1:S  % added by Eyal
 %   feature_vec = [feature_vec  feature_vec_per_section(:,section) ];
 %end
end
