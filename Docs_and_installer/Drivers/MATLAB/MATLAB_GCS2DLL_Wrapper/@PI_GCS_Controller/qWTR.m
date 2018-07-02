function [bJoystickButtons] = qWTR(c,iJoystickIDs,iJoystickAxesIDs)
%function [bJoystickButtons] = qWTR(c,iJoystickIDs,iJoystickAxesIDs)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_qWTR';
if(any(strcmp(FunctionName,c.dllfunctions)))
	nValues = length(iJoystickIDs);
	bJoystickButtons = zeros(size(iJoystickIDs));
	piJoystickIDs = libpointer('int32Ptr',iJoystickIDs);
	piJoystickAxesIDs = libpointer('longPtr',iJoystickAxesIDs);
	pbJoystickButtons = libpointer('longPtr',bJoystickButtons);
	try
		[bRet,iJoystickIDs,iJoystickAxesIDs,bJoystickButtons] = calllib(c.libalias,FunctionName,c.ID,piJoystickIDs,piJoystickAxesIDs,pbJoystickButtons,nValues);
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
