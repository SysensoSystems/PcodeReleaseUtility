function packFilesWithFolderStructure(files,helpChoice,outputPath)
% This function helps to create the PCode for the given files with folder
% structure in the mentioned ouput path
% Syntax :
%       packFilesWithFolderStructure(files,helpChoice,outputPath)
% files - required files to create the PCode
% helpChoice - cell Array of logical array for the given files which
% decides the help option for given files.

% Initialize values
slashCount = [];
pathStored = {};
for ii = 1:length(files)
    % To find the length of the given directory
    slashCount(ii) = length(strfind(files{ii},'\'));
end
% To create the parent directory in outputPath
a = min(slashCount);
% To get the parent directory Name
b = max(strfind(slashCount,a));
minSlashLocation = max(strfind(files{b},'\'));
str = files{b}(1:(minSlashLocation));
for jj = 1:length(files)
    % Sepearate the folder structure 
    pathStored(jj) = {erase(files{jj},str)};
end
% Change directory to output directory
cd(outputPath);

for kk = 1:length(pathStored)
    % To get the fileName and ext
    [filePath,name,ext] = fileparts(pathStored{kk});
    % copy files in the folders and subfolders
    if(~strcmp(filePath,''))
        mkdir(filePath);
        warning('off','MATLAB:MKDIR:DirectoryExists')
        cd(filePath);
        copyfile(files{kk},pwd);
        destFile = strcat(outputPath,'\',pathStored{kk});
        makePcode(destFile,helpChoice{kk},pwd);
    % Copy files in the parent directory
    else
        copyfile(files{kk},outputPath);
        destFile = strcat(outputPath,'\',name,ext);
        makePcode(destFile,helpChoice{kk},outputPath);
    end
% Change directory into Parent Directry
cd(outputPath);
end
end
%--------------------------------------------------------------------------