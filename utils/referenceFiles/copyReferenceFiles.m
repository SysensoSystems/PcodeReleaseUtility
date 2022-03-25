function copyReferenceFiles(referenceFiles,outputPath,FolderStructure)
% Helps to copy the given files into the required output folder with or
% without folder structure

% Change directory to output
cd(outputPath);
% Initialize Data
slashCount = [];
pathStored = {};

for ii = 1:length(referenceFiles)
    % To find the length of the given directory
    slashCount(ii) = length(strfind(referenceFiles{ii},'\'));
end
% To create the parent directory in outputPath
a = min(slashCount);
% To get the parent directory Name
b = max(strfind(slashCount,a));
minSlashLocation = max(strfind(referenceFiles{b},'\'));
str = referenceFiles{b}(1:(minSlashLocation));
for jj = 1:length(referenceFiles)
    % Sepearate the folder structure 
    pathStored(jj) = {erase(referenceFiles{jj},str)};
end
% If true pack with folder structure
if(FolderStructure)
    for jj = 1:length(referenceFiles)
        [filePath,name,ext] = fileparts(pathStored{jj});
        if(~strcmp(filePath,''))
            mkdir(filePath);
            cd(filePath);
            copyfile(referenceFiles{jj},pwd);
        else
            copyfile(referenceFiles{jj},outputPath);
        end
        cd(outputPath);
    end

else
    for jj = 1:length(referenceFiles)
        [filepath,name,ext] = fileparts(referenceFiles{jj});
        filename = strcat(name,ext);
        copyfile ([filepath '\' filename ])
    end
end
end