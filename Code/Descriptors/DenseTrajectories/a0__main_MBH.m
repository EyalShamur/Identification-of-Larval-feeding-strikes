

start_clip = 1;
end_clip = 20;

executable_file = 'DenseTrajectories.exe';
executable_folder = 'H:\\thesis - eating fishes\\Code\\Descriptors\\DenseTrajectories\\DenseTrajectories\\Release';

cmd = sprintf(' "%s\\\\%s" %d %d',executable_folder,executable_file,start_clip,end_clip);

%cmd = ' "H:\\thesis - eating fishes\\Code\\Descriptors\\DenseTrajectories\\DenseTrajectories\\Debug\\DenseTrajectories.exe" 1 2';
system(cmd);