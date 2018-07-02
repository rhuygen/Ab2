function number = GetNrAxesInString( c, axesstring )
if(IsGCS2(c))
    lines = regexp(axesstring,'[\w-]+','match');
    number = length(lines);
else
    szAxes = strrep(szAxes,char(10),'');
    szAxes = strrep(szAxes,char(13),'');
    szAxes = strrep(szAxes,' ','');  
    number = length(axesstring);
end
