function [szAnswer] = TranslateError(iErrorCode)
%function [szAnswer] = TranslateError(c,iErrorCode)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to c.wurm@pi.ws. Thank you.

szAnswer = blanks(1001);

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
    [bRet,szAnswer] = calllib(dllDllName,'PI_TranslateError',iErrorCode,szAnswer,1000);
catch
    rethrow(lasterror);
end
