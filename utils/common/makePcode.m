function makePcode(destFile,helpChoice,outputPath)
% Helps to extract help and convert into pcode

cd (outputPath);
if(helpChoice)
    
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