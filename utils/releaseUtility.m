function releaseUtility(packagingMethod,folderOption,allFiles,helpChoice,mainFunctionPath,outputPath)
% Helps to release the files in a required format. This will reduce
% the time and effort during the release process.
%
% Syntax :
%  >> releaseUtility(packagingMethod,folderOption,allFiles,helpChoice,mainFunctionPath,outputPath)
%
% packagingMethod:
%       'single' - For a pcode file.
%       'multiple' - For a multiple pcode files.
%
% folderOption: This is applicable only for multiple packagingMethod.
%       'flat' - Files will be populated directly to the outputPath
%       'retain' - Files will be populated by retaining the relative folder structure.
%
% allFiles: List of files in the development folder will be given in a cell array.
%
% helpChoice: File-wise help choice (Logical array of n*1)
%       true - Help required, false - Help not required.
%
% mainFunctionPath - This is applicable only for single packagingMethod.
% Toplevel function path.
%
% outputPath: Release folder path
%
%--------------------------------------------------------------------------

switch(packagingMethod)
    case 'multiple'
        packMultipleFiles(allFiles,folderOption,helpChoice,outputPath);
    case 'single'
        packSingleFile(allFiles,helpChoice,mainFunctionPath,outputPath);
    otherwise
        disp('Invalid option');
end
% Copy the reference allFiles to the output path.
if isequal(folderOption,'flat')
    referenceFiles = {};
    for ii = 1:length(allFiles)
        if isempty(regexp(allFiles{ii},'\.m$'))
            referenceFiles = [referenceFiles; allFiles{ii}];
        end
    end
    copyReferenceFiles(referenceFiles,outputPath);
end
helpdlg('PCode Generated Successfully','Success');

end
%% packMultipleFiles
function packMultipleFiles(allFiles,folderOption,helpChoice,outputPath)
% Helps to pack multiple allFiles into a single/multiple folder(s). Also
% handels the file-wise .m/.p conversion requirement.

switch(folderOption)
    case 'flat'
        % Packing into a single folder.
        packFilesIntoSingleFolder(allFiles,helpChoice,outputPath);
    case 'retain'
        % Packing into mulitple folder.
        packFilesWithFolderStructure(allFiles,helpChoice,outputPath);
end

end
%% packSingleFile
function packSingleFile(allFiles,helpChoice,mainFunctionPath,outputPath)
% Packs all the given .m files into a single .m/.p file.

childFiles = setdiff(allFiles,mainFunctionPath);
cd(outputPath);
% Assemble the files into a single file
assemebleMFiles(mainFunctionPath,outputPath,childFiles);
[filepath,name,ext] = fileparts(mainFunctionPath);
destFile = strcat(outputPath,'\',name,ext);
topIndex = find(strcmpi(mainFunctionPath,allFiles));
if helpChoice(topIndex)
    % Single .m & .p file
    % pack with the help of folder path
    helpRequired = true;
else
    % Single .m file
    % pack with the help of folder path
    helpRequired = false;
end
makePcode(destFile,helpRequired,outputPath);

end
%% copyReferenceFiles
function copyReferenceFiles(referenceFiles,outputPath)
% copy the required files to outputPath
cd(outputPath);
for jj = 1:length(referenceFiles)
    [filepath,name,ext] = fileparts(referenceFiles{jj});
    filename = strcat(name,ext);
    copyfile ([filepath '\' filename ])
end

end
%% assemebleMFiles
function assemebleMFiles(parentPath,outputPath,varargin)
% Helps to assemble the given files
copyfile(parentPath,outputPath);
cd (outputPath);
% Get the file information
[filepath,name,ext] = fileparts(parentPath);
destFile = strcat(name,ext);
outputFileId = fopen(destFile,'a');
childPaths = varargin{1};
xx = length(childPaths);
for ii = 1:xx
    childFile = childPaths{ii};
    if ~isempty(regexp(childFile,'\.m$'))
        if isequal(childFile,parentPath)
            continue;
        end
        if exist(childFile,'file')
            childFileId = fopen(childFile,'r+');
            while true
                temp = fgetl(childFileId);
                if ~ischar(temp)
                    break
                end
                fprintf(outputFileId,'\n%s',temp);
            end
            fclose(childFileId);
        end
    end
end
% Close all the file handles.
fclose(outputFileId);

end
%% makePcode
function makePcode(destFile,helpChoice,outputPath)
% Helps to extract help and convert into pcode
if ~isempty(regexp(destFile,'\.m$'))
    cd (outputPath);
    if helpChoice
        mFile = fopen(destFile,'r+');
        helpStr = help(destFile);
        pcode(destFile);
        fclose(mFile);
        fid = fopen(destFile,'w+');
        helpStr = ['%',strrep(helpStr,char(10),[char(10),'%'])];
        fprintf(fid,'%s\n',helpStr);
        fclose(fid);
    else
        pcode(destFile);
        delete(destFile);
        
    end
end

end
%% packFilesIntoSingleFolder
function packFilesIntoSingleFolder(allFiles,helpChoice,outputPath)
% help choice to put the help for the required files in outputPath
% outputPath is to store the files

cd(outputPath);
for jj = 1:length(allFiles)
    [filepath,name,ext] = fileparts(allFiles{jj});
    % Extract the file Name
    destFile = strcat(name,ext);
    % Copy file to the output folder
    copyfile(allFiles{jj},pwd);
    % Make pcode for the files with given help choice option
    makePcode(destFile,helpChoice(jj),outputPath)
end

end
%% packFilesWithFolderStructure
function packFilesWithFolderStructure(allFiles,helpChoice,outputPath)
% Initialize values
slashCount = [];
pathStored = {};
for ii = 1:length(allFiles)
    % To find the length of the given directory
    slashCount(ii) = length(strfind(allFiles{ii},'\'));
    
end
% To create the parent directory in outputPath
a = min(slashCount);
% To get the parent directory Name
b = max(strfind(slashCount,a));
slashLocs = strfind(allFiles{b},'\');
minSlashLocation = slashLocs(end-1);
str = allFiles{b}(1:(minSlashLocation));

for jj = 1:length(allFiles)
    % Sepearate the folder structure
    pathStored(jj) = {strrep(allFiles{jj},str,'')};
end
% Change directory to output directory
cd(outputPath);

for kk = 1:length(pathStored)
    % To get the fileName and ext
    [filePath,name,ext] = fileparts(pathStored{kk});
    % copy files in the folders and subfolders
    if(~strcmp(filePath,''))
        
        warning('off','MATLAB:MKDIR:DirectoryExists');
        %tempPath =
        destFile = strcat(outputPath,'\',pathStored{kk});
        [destFilePath,dname,dext] = fileparts(destFile);
        mkdir(destFilePath);
        cd(destFilePath);
        copyfile(allFiles{kk});
        if ~isempty(regexp(destFile,'\.m$'))
            makePcode(destFile,helpChoice(kk),destFilePath);
        end
        % Copy files in the parent directory
    else
        copyfile(allFiles{kk},outputPath);
        destFile = strcat(outputPath,'\',name,ext);
        % Call MakePCode function
        if ~isempty(regexp(destFile,'\.m$'))
            makePcode(destFile,helpChoice(kk),outputPath);
        end
    end
    % Change directory into Parent Directry
    cd(outputPath);
end

end