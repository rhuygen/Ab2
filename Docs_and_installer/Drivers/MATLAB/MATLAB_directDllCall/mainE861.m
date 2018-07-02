%Simple sample
%loadlibrary(libname, hfile)
%[x1, ..., xN] = calllib(libname, funcname, arg1, ..., argN)

%% Parameters

% Stage
stagename = 'N-661.21A';

% Connection
% -- if you want to connect via RS232
connectionType = 'rs232';
comPort = 1;
baudRate = 115200;


%% Get library - Retrieve whether MATLAB is used in its 32bit or 64bit version

% Get information
if(strcmp(mexext, 'mexw64'))
    matlabIs64bit = true;
else
    matlabIs64bit = false;
end


% Set dll extension
if (matlabIs64bit)
    extension = '_x64';
else
    extension = '';
end

dllName = 'PI_GCS2_DLL';
dllHeaderFileName = dllName;
dllDllName = [dllName, extension];


%% Unload old inctance if exisiting

% Check wether lib is loaded from previous run
if (libisloaded(dllDllName))
    try
        unloadlibrary(dllDllName);

    catch
        rethrow(lasterror);
    end
end


%% Load PI_GCS2DLL.dll
disp('loading library ...');
[notfound, warnings] = loadlibrary(dllDllName, dllHeaderFileName);


% Check wether PI_GCS2DLL.dll was loaded succesfully
if(~libisloaded(dllDllName)) %dllName loadet == 1; not loadet == 0
    error('The Library "dllName" could not be loaded"');
end

% Show all existing lib functions
% libfunctions(dllDllName, '-full')
% libfunctionsview(dllDllName)


%% Connect

% RS232 connection
if (strcmpi(connectionType, 'rs232'))
    try
        [ID]=calllib(dllDllName, 'PI_ConnectRS232', comPort, baudRate) %115200
        
        if (ID<0)
            error('Could not connect to controller');
        end
    catch
        rethrow(lasterror);
    end
    
end


%% Identification (*IDN?)
% The *IDN? (Identification) query causes a device to return a string to
% identify itself

stringLength = 100;
idn = blanks(stringLength);
try
    [bRet, idn] = calllib( dllDllName, 'PI_qIDN', ID, idn, stringLength)
    if (bRet<0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end


%% Initialization (qSAI)

stringLength = 100;
szAllAxesNames = blanks(stringLength);

try
    [bRet, szAllAxesNames] = calllib(dllDllName, 'PI_qSAI', ID, szAllAxesNames, stringLength - 1 )
    if (bRet<0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end

availableaxes = regexp(szAllAxesNames, '[\w-]+','match'); %Splits string in words/characters
numberOfAxis = length(availableaxes);


%% Reference stage (FRF)

axisname = availableaxes{1};

try
    [bRet] = calllib(dllDllName,'PI_FRF', ID, axisname) %reference all Heaxapod axes
    if (bRet==0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end


iValues = zeros(numberOfAxis,1);
piValues = libpointer('int32Ptr',iValues);
ref=1;

% wait for Referencing to finish.
%PI_qFRF answers true if the absolute position is known, e.g. because
%-the last FNL, FPL or FRF command was successful
%-the current position was set with POS
%-the stage has an absolute sensor
%Starting a reference motion should reset qFRF to false.

while (ref)
    pause(0.1);
    
    try
        [bRet,szAxes,piValues] = calllib(dllDllName, 'PI_qFRF' ,ID ,axisname , piValues);
        if (bRet==0)
            iError = GetError(ID);
            szDesc = TranslateError(iError);
            error(szDesc);
        end
    catch
        rethrow(lasterror);
    end
    
    ref = any(piValues == 0);
end


%% Switch Servo On (SVO)

iValues = 1;
piValues = libpointer('int32Ptr',iValues);
try
    [bRet] = calllib(dllDllName,'PI_SVO', ID, axisname, piValues) %reference all Heaxapod axes
    if (bRet==0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end


%% Get min and max (qTMN, qTMX)

dMin = libpointer('doublePtr',0);
try
    [bRet, axisname, dMin] = calllib(dllDllName, 'PI_qTMN', ID, axisname, dMin)
    if (bRet<0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end

dMax = libpointer('doublePtr',0);
try
    [bRet, axisname, dMax] = calllib(dllDllName, 'PI_qTMX', ID, axisname, dMax)
    if (bRet<0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end

%% Move Stage

position = dMax;
pdValues = libpointer('doublePtr', position);

try
    [bRet,axisname,dValues] = calllib(dllDllName, 'PI_MOV', ID, axisname, pdValues);
    if (bRet==0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end

iValues = 0;
piValues = libpointer('int32Ptr', iValues);
moving=1;

while(any(piValues == 0))
    pause(0.1);
    
    try
        [bRet, axisname, piValues] = calllib(dllDllName, 'PI_IsMoving', ID, axisname, piValues);
        if (bRet==0)
            iError = GetError(ID);
            szDesc = TranslateError(iError);
            error(szDesc);
        end
    catch
        rethrow(lasterror);
    end
    moving = (piValues==1);
end


%% Retrieve Position

	dValues = zeros(numberOfAxis,1);
	pdPositionHome_new = libpointer('doublePtr',dValues);
    axisname = ''; %retrieve position of all axes
try
    [bRet, szAxes, pdPositionHome_new] = calllib( dllDllName, 'PI_qPOS', ID, axisname, pdPositionHome_new)
    if (bRet<0)
        iError = GetError(ID);
        szDesc = TranslateError(iError);
        error(szDesc);
    end
catch
    rethrow(lasterror);
end


%% Close connection and unload library
try
    calllib(dllDllName, 'PI_CloseConnection', ID);
    
catch
    rethrow(lasterror);
end

unloadlibrary(dllDllName);