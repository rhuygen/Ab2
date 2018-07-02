function [dOutValues1] = GetAvailableDRRValues(c)
% function [dOutValues1] = GetAvailableDRRValues(c)
% Use this function to retrieve asynchronously read data
% the recording is started using the qDRR command with the nowaiting option
% set to true.
% All available data is being read, that means either the requested amount
% 'numberofvalues' of the qDRR call is returned, or the amount of data
% already returned from the controller
% Example:
%
% % start reading values
% cont_class_instance = cont_class_instance.qDRR(tableIDs,startoffset,numberofvalues,nowaiting);
% % do something else
% pause 0.5;
% % get recorded data
% data = cont_class_instance.GetAvailableDRRValues();

% This code is provided by Physik Instrumente(PI) GmbH&Co.KG
% You may alter it corresponding to your needs
% Comments and Corrections are very welcome
% Please contact us by mailing to support-software@pi.ws

i =  GetAsyncBufferIndex(c);
[nTables ] = c.DataRecorder.ValuesSize(1);
[iNumber] = c.DataRecorder.ValuesSize(2);
iNumber = min(i / nTables,iNumber);
setdatatype(c.DataRecorder.ppdValues,'doublePtr',nTables,iNumber);
dOutValues1 = c.DataRecorder.ppdValues.Value';
dOutValues1 = [((0:iNumber-1)*c.DataRecorder.SampleTime)',dOutValues1];
