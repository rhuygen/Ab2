function bRet = KCP (c, szSource, szDestination)
% function bRet = KSD(c, szNameOfCoordSystem, szAxes, ValueArray)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

%% Parameters

FunctionName = 'PI_KCP';


%% Check for errors

if (0 > c.ID)
    error ('The controller is not connected');
end

if ( ~any (strcmp (FunctionName, c.dllfunctions ) ) )
    error ('%s not found', FunctionName);
end


%% Call the libary function

% Call library
try
    [bRet] = calllib (c.libalias, FunctionName, c.ID, szSource, szDestination);
    if (bRet == 0)
        iError = GetError (c);
        szDesc = TranslateError (c,iError);
        error (szDesc);
    end
catch
    rethrow (lasterror);
end


