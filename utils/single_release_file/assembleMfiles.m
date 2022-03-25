function assembleMfiles(parentPath, varargin)
% Helps to assemble the given files into the parentPath
%

%--------------------------------------------------------------------------
outputFileId = fopen(parentPath,'a');

% Reading the child and adding the contents to the output.


%Get list of files from varargin
childPaths = varargin{1};
xx=length(childPaths);

%write content of files into parentPath
for ii = 1:xx
    childFile = childPaths{ii};
    if string(childFile) == string(parentPath)
        continue;
    end
    if isfile(childFile)
        childFileId = fopen(childFile,'r+');
        
        
        while 1
            temp = fgetl(childFileId);
            if ~ischar(temp)
                break
            end
            fprintf(outputFileId,'\n%s',temp);
        end
         fclose(childFileId);
    end
   
end
%--------------------------------------------------------------------------
fclose(outputFileId);
end