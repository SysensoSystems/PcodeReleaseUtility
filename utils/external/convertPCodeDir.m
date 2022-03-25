function convertPCodeDir(root)

convertfilesToPCode(root);

end
%--------------------------------------------------------------------------
function [] = convertfilesToPCode(path_name)
mFiles = dir([path_name '\' '*.m']);
if ~isempty(mFiles)
    pcode(path_name,'-inplace')
end
sub_directories = getDirectories(path_name);
for ii = 1:length(sub_directories)
    subdir_path_name = [path_name '\' sub_directories(ii).name];
    convertfilesToPCode(subdir_path_name)
end

end
%--------------------------------------------------------------------------
function directories = getDirectories(path_name)
directories = struct([]);
count = 1;
dirPath = dir(path_name);
for ii = 1:length(dirPath)
    if dirPath(ii).isdir
        if strcmp(dirPath(ii).name,'.')
        elseif strcmp(dirPath(ii).name,'..')
        else
            directories(count).name = dirPath(ii).name;
            count = count+1;
        end
    end
end

end
