function [bRet] = WPA(c,sPassWd,sAxes,uiParIDs)
%function [bRet] = WPA(c,sPassWd,sAxes,uiParIDs)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_WPA';
if(any(strcmp(FunctionName,c.dllfunctions)))
	puiParIDs = libpointer('uint32Ptr',uiParIDs);
	try
		[bRet,sPassWd,sAxes,uiParIDs] = calllib(c.libalias,FunctionName,c.ID,sPassWd,sAxes,puiParIDs);
		if(bRet==0)
			iError = GetError(c);
			szDesc = TranslateError(c,iError);
			error(szDesc);
		end
	catch
		rethrow(lasterror);
	end
else
	error('%s not found',FunctionName);
end
