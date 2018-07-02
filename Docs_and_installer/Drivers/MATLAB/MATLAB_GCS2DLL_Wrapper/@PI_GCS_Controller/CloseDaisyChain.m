function CloseDaisyChain(c)
%function CloseDaisyChain(c)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

if(c.ID<0), error('The controller is not connected'),end;
FunctionName = 'PI_CloseDaisyChain';
if(any(strcmp(FunctionName,c.dllfunctions)))
	try
		calllib(c.libalias,FunctionName,c.ID);
		c = SetDefaults(c);
	catch
		rethrow(lasterror);
	end
else
	error('%s not found',FunctionName);
end
