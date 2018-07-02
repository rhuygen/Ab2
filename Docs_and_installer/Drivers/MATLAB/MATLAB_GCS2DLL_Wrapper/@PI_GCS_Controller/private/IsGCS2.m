function gcs2 = IsGCS2( c )
gcs2 = 1;
if(strcmp(c.DLLNameStub, 'E7XX_GCS_DLL') == 1)
    gcs2 = 0;
elseif(strcmp(c.DLLNameStub, 'HEX_GCS_DLL') == 1)
    gcs2 = 0;
elseif(strcmp(c.DLLNameStub, 'C843_GCS_DLL') == 1)
    gcs2 = 0;
elseif(strcmp(c.DLLNameStub, 'Mercury_GCS_DLL') == 1)
    gcs2 = 0;
elseif(strcmp(c.DLLNameStub, 'C7XX_GCS_DLL') == 1)
    gcs2 = 0;
end