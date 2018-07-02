function c = PI_GCS_Controller()
% PI_GCS_Controller controller class constructor
%PI MATLAB Class Library Version 1.1.1
% This code is provided by Physik Instrumente(PI) GmbH&Co.KG.
% You may alter it corresponding to your needs.
% Comments and Corrections are very welcome.
% Please contact us by mailing to support-software@pi.ws. Thank you.


if nargin==0
	c.DLLNameStub = 'PI_GCS2_DLL';
	c.libalias = 'PI';
	c.ControllerName = [];
	c.DLLName = [];
	c = SetDefaults(c);
	% only load dll if it wasn't loaded before
	if(~libisloaded(c.libalias))
		c = LoadGCSDLL(c);
	end
	if(~libisloaded(c.libalias))
		error('DLL could not be loaded');
	end
	c = class(c,'PI_GCS_Controller');
end
