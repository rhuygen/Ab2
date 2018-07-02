function UnloadGCSDLL( c )
if(libisloaded(c.libalias))
    unloadlibrary(c.libalias);
end