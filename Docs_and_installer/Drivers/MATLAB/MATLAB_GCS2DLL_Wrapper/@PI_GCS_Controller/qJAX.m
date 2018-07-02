function [szAxes] = qJAX(c,iJoystickIDs,iJoystickAxesIDs)
%function [szAxes] = qJAX(c,iJoystickIDs,iJoystickAxesIDs)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_qJAX';
if(any(strcmp(FunctionName,c.dllfunctions)))
	piJoystickIDs = libpointer('int32Ptr',iJoystickIDs);
	piJoystickAxesIDs = libpointer('int32Ptr',iJoystickAxesIDs);
	szAxes = blanks(100);
	nValues = length(iJoystickIDs);
	try
		[bRet,iJoystickIDs,iJoystickAxesIDs,szAxes] = calllib(c.libalias,FunctionName,c.ID,iJoystickIDs,iJoystickAxesIDs,nValues,szAxes,99);
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
