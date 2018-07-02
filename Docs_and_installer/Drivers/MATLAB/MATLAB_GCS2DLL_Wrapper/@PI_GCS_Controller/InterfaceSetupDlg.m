function [c] = InterfaceSetupDlg(c,szIdentifier)
%function [c] = InterfaceSetupDlg(c,szIdentifier)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

FunctionName = 'PI_InterfaceSetupDlg';
if(any(strcmp(FunctionName,c.dllfunctions)))
	if(nargin<2),    szIdentifier = '';end,
	try
		[c.ID, szIdentifier] = calllib(c.libalias,FunctionName,szIdentifier);
		if(c.ID<0)
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
