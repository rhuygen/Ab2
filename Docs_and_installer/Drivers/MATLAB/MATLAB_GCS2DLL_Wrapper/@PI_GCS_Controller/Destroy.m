function Destroy( c )
%DESTROY Controller object and unload library
if(IsConnected(c))
    c = CloseConnection(c);
end
UnloadGCSDLL(c);
clear c;