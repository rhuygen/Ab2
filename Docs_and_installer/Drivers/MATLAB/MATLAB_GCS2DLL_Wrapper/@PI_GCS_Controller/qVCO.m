function iValues = qVCO(c,szAxes)
% function iValues = qVCO(c,szAxes)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_qVCO';
if(any(strcmp(FunctionName,c.dllfunctions)))
	if(nargin==1)
		szAxes = '';
	end
	len = GetNrAxesInString(c,szAxes);
	if(len == 0)
			if(~c.initialized) error('Controller must be initialized when no axes ID is given');end;
			len = c.NumberOfAxes;
	end
	if(len == 0)
		return;
	end
	iValues = zeros(len,1);
	piValues = libpointer('int32Ptr',iValues);
	try
		[ret,szAxes,iValues] = calllib(c.libalias,FunctionName,c.ID,szAxes,piValues);
		if(ret==0)
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
