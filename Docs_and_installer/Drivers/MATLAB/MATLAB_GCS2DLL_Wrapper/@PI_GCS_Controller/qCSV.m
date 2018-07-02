function [dOutValues1] = qCSV(c)
%function [dOutValues1] = qCSV(c)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_qCSV';
if(any(strcmp(FunctionName,c.dllfunctions)))
	dOutValues1 = zeros(1,1);
	pdOutValues1 = libpointer('doublePtr',dOutValues1);
	try
		[bRet,dOutValues1] = calllib(c.libalias,FunctionName,c.ID,pdOutValues1);
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
