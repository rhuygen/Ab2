function [dOutValues1] = qDRR(c,iTables,iStart,iNumber,nowaiting)
%function [out] = qDRR(c)

% This code is provided by Physik Instrumente(PI) GmbH&Co.KG
% You may alter it corresponding to your needs
% Comments and Corrections are very welcome
% Please contact us by mailing to support-software@pi.ws

FunctionName = sprintf('%s_qDRR',c.libalias);
if(strmatch(FunctionName,c.dllfunctions))
	piTables = libpointer('int32Ptr',iTables);
	nTables = length(iTables);
	hlen = 1000;
	header = blanks(hlen+1);
%BOOL PI_FUNC_DECL PI_qDRR(long ID, const int* piRecTableIdsArray,  int iNumberOfRecChannels,  int iOffsetOfFirstPointInRecordTable,  int iNumberOfValues, double** pdValueArray, char* szGcsArrayHeader, int iGcsArrayHeaderMaxSize);

	ppdData = libpointer('doublePtr');
    c.DataRecorder.ValuesSize = [0 0];
	dOutValues1 = 0;
	try
		[bRet,iTables,ppdData,header] = calllib(c.libalias,FunctionName,c.ID,piTables,nTables,iStart,iNumber,ppdData,header,hlen);
	catch
		rethrow(lasterror);
    end
	if(bRet==0)
        iError = GetError(c);
        szDesc = TranslateError(c,iError);
        error(szDesc);
    end
    wait = 1;
    if(nargin==5)
        if(nowaiting)
            wait = 0;
        end
    end

    headerlines = regexp(header,'\n','split');
    sampletime = -1;
    timeind = -1;
    for n = 1:length(headerlines)
        currentline = headerlines{n};
        if(~isempty(strfind(currentline,'DIM'))),nTables = str2num(currentline(strfind(currentline,'=')+1:end));end;
        if(~isempty(strfind(currentline,'NDATA'))),iNumber = str2num(currentline(strfind(currentline,'=')+1:end));end;            
        if(~isempty(strfind(currentline,'SAMPLE_TIME'))),sampletime = str2double(currentline(strfind(currentline,'=')+1:end));end;            
        if(~isempty(strfind(currentline,'TIME')) && ~isempty(strfind(currentline,'NAME')))
            number = currentline( (strfind(currentline,'NAME') + 4):( strfind(currentline,'=') -1));
            timeind = str2num(number) + 1;
        end
    end
    i = 0;
    if(wait)
        while(i<(nTables*iNumber))
            pause(0.1);
            i =  GetAsyncBufferIndex(c);
        end
        setdatatype(ppdData,'doublePtr',nTables,iNumber);
        dOutValues1 = ppdData.Value';
        
        % put time information as first column
        if(sampletime>0)
            dOutValues1 = [([0:iNumber-1]*sampletime)',dOutValues1];
        else
            if(timeind>0)
                dOutValues1 = [dOutValues1(:,timeind),dOutValues1];
            else
                dOutValues1 = [([0:iNumber-1])',dOutValues1];
            end
        end
    else
        c.DataRecorder.ppdValues = ppdData;
        c.DataRecorder.ValuesSize = [nTables iNumber];% als member speichern!!
        c.DataRecorder.SampleTime = sampletime;
    end
%     keyboard;
   
else
	error('%s not found',FunctionName);
end
