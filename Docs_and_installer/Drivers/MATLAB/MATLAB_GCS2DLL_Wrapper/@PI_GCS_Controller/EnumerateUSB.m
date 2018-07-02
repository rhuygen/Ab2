function varargout = EnumerateUSB(c,szFilter)
%function [szDevices] = EnumerateUSB(c,szFilter)

% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.

FunctionName = 'PI_EnumerateUSB';
if(strmatch(FunctionName,c.dllfunctions))
    szDevices = blanks(1001);
    try
        [bRet,szDevices,szFilter] = calllib(c.libalias,FunctionName,szDevices,1000,szFilter);
        if (bRet==0)
            szDevices = '';% no devices found -> return empty string.
        end
        DeviceLines = regexp(szDevices, '\n', 'split');
        for n = 1:length(DeviceLines)
            DeviceItems = regexp(DeviceLines{n}, ' ', 'split');
            if(length(DeviceItems)>=6)
                DeviceInfoStruct(n).Vendor = DeviceItems{1};
                DeviceInfoStruct(n).ControllerName = [DeviceItems{2},' ',DeviceItems{3},' ',DeviceItems{4}];
                DeviceInfoStruct(n).SN = DeviceItems{6};
            end
        end
    catch
        rethrow(lasterror);
    end
else
    error('%s not found',FunctionName);
end
if nargout >= 1
    varargout{1} = szDevices;
end
if nargout >= 2
    varargout{2} = DeviceInfoStruct;
end
