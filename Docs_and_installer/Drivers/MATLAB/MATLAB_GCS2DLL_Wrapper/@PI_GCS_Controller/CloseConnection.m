function c = CloseConnection(c)
% function InterfaceSetupDlg()
FunctionName = sprintf('%s_CloseConnection',c.libalias);  
% foundit = cellfun(@(x) (strcmp(x,FunctionName)),c.dllfunctions,'UniformOutput',true);
if(strmatch(FunctionName,c.dllfunctions))
    calllib(c.libalias,FunctionName,c.ID);
    c = SetDefaults(c);
else
    error(sprintf('%s not found',FunctionName));
end