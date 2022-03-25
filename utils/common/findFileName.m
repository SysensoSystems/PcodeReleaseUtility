function findFileName(filePath)
for ii = 1:length(filePath)
[filepath,name,ext] = fileparts(filePath(ii))
if(strcmp(name,'.m')
end
end