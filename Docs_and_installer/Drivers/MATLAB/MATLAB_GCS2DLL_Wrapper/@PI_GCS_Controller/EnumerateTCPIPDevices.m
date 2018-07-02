function DeviceLines = EnumerateTCPIPDevices(c,szFilter)
%function [DeviceLines] = EnumerateTCPIPDevices(c,szFilter)
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

FunctionName = 'PI_EnumerateTCPIPDevices';
if(any(strcmp(FunctionName,c.dllfunctions)))
	szDevices = blanks(10001);
	try
		[bRet,szDevices,szFilter] = calllib(c.libalias,FunctionName,szDevices,10000,szFilter);
		if (bRet==0)
            szDevices = '';% no devices found -> return empty string.
        end
        DeviceLines = regexp(szDevices, '\n', 'split');

	catch
		rethrow(lasterror);
	end
else
	error('%s not found',FunctionName);
end
