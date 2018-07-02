function bRet = DRC(c,iValues1,szAxes,iValues2)
% function bRet = DRC(c,iValues1,szAxes,iValues2)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_DRC';
if(any(strcmp(FunctionName,c.dllfunctions)))
	piValues1 = libpointer('int32Ptr',iValues1);
	piValues2 = libpointer('int32Ptr',iValues2);
	try
		[bRet,piValues1,szAxes,piValues2] = calllib(c.libalias,FunctionName,c.ID,piValues1,szAxes,piValues2);
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
