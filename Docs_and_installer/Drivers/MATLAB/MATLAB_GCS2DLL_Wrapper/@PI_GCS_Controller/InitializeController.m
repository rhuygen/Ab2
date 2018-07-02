function c = InitializeController(c)
%function c = InitializeController(c)

% This code is provided by Physik Instrumente(PI) GmbH&Co.KG
% You may alter it corresponding to your needs
% Comments and Corrections are very welcome
% Please contact us by mailing to support-software@pi.ws

c.IDN = qIDN(c);
c.IDN = strrep(c.IDN,'\n','');
c.IDN = strrep(c.IDN,'\r','');
try
    c.NumberOfAnalogInputs = qTNR(c);
catch
    c.NumberOfAnalogInputs = 0;
end
try
    c.GCSVersion = qCSV(c);
catch
    c.GCSVersion = 1;
end
try
    szAxes = qSAI_ALL(c);
catch
    szAxes = qSAI(c);
end

c.NumberOfAxes = GetNrAxesInString(c,szAxes);
c.initialized = 1;