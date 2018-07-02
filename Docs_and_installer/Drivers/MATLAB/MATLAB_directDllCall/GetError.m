function [iRet] = GetError(ID)
%function [iRet] = GetError(ID)

if(strcmp(mexext , 'mexw64'))
    matlabIs64bit = true;
else
    matlabIs64bit = false;
end


% Set dll extension
if (matlabIs64bit)
    extension = '_x64';
else
    extension = '';
end

dllName = 'PI_GCS2_DLL';
dllDllName = [dllName,extension];

try
    [iRet] = calllib(dllDllName,'PI_GetError',ID);
catch
    rethrow(lasterror);
end
