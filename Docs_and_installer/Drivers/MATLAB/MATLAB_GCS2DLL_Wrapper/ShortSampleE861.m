%% Parameters

% Stage
stagename = 'N-661.21A';

% Connection
% -- if you want to use rs232
% connectionType = 'rs232';
% comPort = 1;
% baudRate = 115200;

% -- if you want to use usb
connectionType = 'usb';

%% Create Instance of controller class
if(~exist('Controller','var'))
	Controller = PI_GCS_Controller();
end;
if(~isa(Controller,'PI_GCS_Controller'))
	Controller = PI_GCS_Controller();
end; 


%% Start connection

if (~Controller.IsConnected)
    
    % connect using the serial port
    if (strcmpi(connectionType, 'rs232'))
        Controller = Controller.ConnectRS232(comPort, baudRate);
        Controller = Controller.InitializeController();
    end
    
    % connect using usb
    if (strcmpi(connectionType, 'usb'))
        % connect using the serial port
        disp('Enumerating USB devices');
        devices = Controller.EnumerateUSB('');
        %%devices = Controller.EnumerateTCPIPDevices('');
        s2 = regexp(devices, '\n', 'split');
        for lineindex = 1:size(s2,2)
            if(length(s2{lineindex}))
                disp(sprintf('Controller %d: %s',lineindex,s2{lineindex}));
            end
        end
        if(size(s2,2))
            lineindex = input('which controller do you want to connect with? Enter a number and confirm with ENTER, please\n');
            line = s2{lineindex};
            [start_inds,end_inds] = regexp(line,'SN [0-9]*');
            controller_name = s2{lineindex}(start_inds(1)+3:end_inds(1));
            Controller = Controller.ConnectUSB(controller_name);
        else
            Controller.Destroy;
            clear Controller;
            error('no controller was found');
        end
    end
end


%% query controller identification
Controller.qIDN()
% query axes
availableaxes = Controller.qSAI_ALL();
if(isempty(availableaxes))
	return;
end
axisname = availableaxes(1);


%% connect a stage
Controller.CST(axisname,stagename);
Controller.qCST(axisname)


%% switch on servo and search reference switch to reference stage
Controller.SVO(axisname,1);
Controller.FRF(axisname)
bReferencing = 1;
% wait for Referencing to finish
while(bReferencing)
    pause(0.1);
    bReferencing = (Controller.qFRF(axisname)==0);
end


%% move to random absolute position
dMin = Controller.qTMN(axisname);
dMax = Controller.qTMX(axisname);

position = rand(1)*(dMax-dMin)+dMin;
Controller.MOV(axisname, position);
% wait for motion to stop
while(Controller.IsMoving(axisname))
    pause(0.1);
end


%% perform a step
Controller.DRT(0,1,'0')
Controller.DRC(1,axisname,1)
Controller.DRC(2,axisname,2)
Controller.MVR(axisname,0.1)
while(Controller.IsMoving(axisname))
    pause(0.1);
end


%% read data from controller and plot
data = Controller.qDRR([1 2],1, 500);
plotyy(data(:,1),data(:,2),data(:,1),data(:,3));
grid on;
legend('Target Position', 'Current Position', ...
    'location', 'northeastoutside');


%% if you want to close the connection
Controller.CloseConnection;


%% if you want to unload the dll and destroy the class object
Controller.Destroy;
clear Controller;