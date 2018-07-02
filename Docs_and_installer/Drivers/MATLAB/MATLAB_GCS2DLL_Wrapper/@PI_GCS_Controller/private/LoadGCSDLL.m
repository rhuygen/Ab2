function c = LoadGCSDLL(c)

%% Retrieve whether MATLAB is used in its 32bit or 64bit version

% Get information
if(strcmp(mexext , 'mexw64'))
    matlabIs64bit = true;
else
    matlabIs64bit = false;
end

% Set dll extension
if (matlabIs64bit)
    extension = '_x64.dll';
else
    extension = '.dll';
end


%% Retrieve library path

gcspath = '';

% To use the default dll, uncomment the following section
% Look in regedit entry
try
    gcspath = winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\PI\GCSTranslator','Path');
catch
    
    
    try
        gcspath = winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Wow6432Node\PI\GCSTranslator','Path');
    catch
        
        
        try
            gcspath = winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Wow6464Node\PI\GCSTranslator','Path');
        catch
            
            % Do nothing
        end
    end
end


% If the regedit entry was retrieved succesfully and the gcspath variable contains a valid folder
if(exist(gcspath,'dir')==7)
    
    % Check whether path name is: 'xxx\xxx' (instead of 'xxx\xxx\')
    if(~strcmp(gcspath(end),'\'))
        gcspath = [gcspath,'\'];
        
        % Check whether path name is: 'xxx\xxx\\' (instead of 'xxx\xxx\')
    elseif((strcmp(gcspath(end-1:end),'\\')))
        gcspath = gcspath(1:end-1);
    end
    
    % If regedit entry wasn't retrieved, look for standard folders
else
    if(exist('c:\programme\pi\gcstranslator\','dir')==7)
        gcspath     = 'c:\programme\pi\gcstranslator\';
        
    elseif(exist('c:\program files\pi\gcstranslator\','dir')==7)
        gcspath     = 'c:\program files\pi\gcstranslator\';
        
    elseif(exist('c:\ProgramData\PI\GCSTranslator\','dir')==7)
        gcspath     = 'c:\ProgramData\PI\GCSTranslator\';
        
    end
    
end


% If the gcspath variable doesn't contain a valid folder, look in the
% project folder
if(~(exist(gcspath,'dir')==7))
    
    gcspath = mfilename('fullpath');
    
    % Retrieve path of the MATLAB sample
    methodName  = '@PI_GCS_Controller\\private\\LoadGCSDLL';
    replace     = '';
    gcspath     = regexprep(gcspath,methodName,replace);
    
    % To use the default dll, uncomment the following section
    % Raise error because dll
    if (matlabIs64bit)
        warning(['The default path of "PI_GCS2_DLL_x64.dll" could not be determined. Hence it is assumed "PI_GCS2_DLL_x64.dll" can be found in the folder of your sample: ', ...
            gcspath, ...
            '. If this folder doesn''t contain the dll, an error will occur.']);
    else
        warning(['The default path of "PI_GCS2_DLL.dll" could not be determined. Hence it is assumed "PI_GCS2_DLL.dll" can be found in the folder of your sample: ', ...
            gcspath, ...
            '. If this folder doesn''t contain the dll, an error will occur.']);
    end

end



%% Check if library exists on retrieved path

%If the retrieved path in "gcspath" doesen't contain the library, raise an
%error message.
c.DLLName = [gcspath,c.DLLNameStub,extension];
if (~(exist(c.DLLName,'file') == 2))
    if (matlabIs64bit)
        error(['The folder of your sample ', ...
            '(', gcspath, ')', ...
            'doesn''t contain the "PI_GCS2_DLL_x64.dll". ', ...
            'This library is essential for communication between your Computer and the PI controller. ', ...
            'You can easily fix this problem by manually searching for the "PI_GCS2_DLL_x64.dll" on your system and copy it into the folder of your sample.']);
    else
        error(['The folder of your sample ', ...
            '(', gcspath, ')', ...
            'doesn''t contain the "PI_GCS2_DLL_x64.dll". ', ...
            'This library is essential for communication between your Computer and the PI controller. ', ...
            'You can easily fix this problem by manually searching for the "PI_GCS2_DLL_x64.dll" on your system and copy it into the folder of your sample.']);
    end
end



%% Load DLL

% goto: Aktuell/passend für dieses Release???
if strcmp(c.DLLNameStub , 'C843_PM_GCS_DLL')
    c.hfile = ['C843_GCS_DLL.h'];
else
    c.hfile = [c.DLLNameStub,'.h']; %goto: müsste hier nicht auch auf 64bit überprüft werden???
end


% only load dll if it wasn't loaded before
if(~libisloaded(c.libalias))
    disp('Loading dll ...');
    try
        [notfound,warnings] = loadlibrary (c.DLLName,c.hfile,'alias',c.libalias);
    catch
        error('DLL could not be loaded');
    end
end


c.dllfunctions = libfunctions(c.libalias);



