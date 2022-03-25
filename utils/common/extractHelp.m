function extractHelp(destFile)
%Helps to extract the help from the given file.

    mFile = fopen(destFile,'r+');
    helpStr = help(destFile);
    fclose(mFile);
    fid = fopen(destFile,'w+');   
    helpStr = ['%',strrep(helpStr,char(10),[char(10),'%'])];
    fprintf(fid,'%s\n',helpStr);
    fclose(fid);


end