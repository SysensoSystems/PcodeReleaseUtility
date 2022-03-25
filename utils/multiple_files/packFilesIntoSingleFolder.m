function packFilesIntoSingleFolder(files,helpChoice,outputPath)
% help choice to put the help for the required files in outputPath
% outputPath is to store the files

cd(outputPath);
for jj = 1:length(files)
    [filepath,name,ext] = fileparts(files{jj});
    % Extract the file Name
    destFile = strcat(name,ext);
    % Copy file to the output folder
    copyfile(files{jj},pwd);
    % Make pcode for the files with given help choice option
    makePcode(destFile,helpChoice{jj},outputPath)
end
end
