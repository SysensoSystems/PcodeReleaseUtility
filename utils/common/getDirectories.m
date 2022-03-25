function directory = getDirectories()
dirpath = dir();
directory = struct([]);
count = 1;
for ii = 1:length(dirpath)
    if dirpath(ii).isdir
        if(strcmp(dirpath(ii).name,'.'))
        elseif(strcmp(dirpath(ii).name,'..'))
        else
            directory(count).name = dirpath(ii).name;
            count = count+1;
        end
    end
end