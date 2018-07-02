// StaticLoadSample_DataRecorder.cpp : 
// Sample program to demonstrate:

// 1. Usage of Lib file to link dll statically in MS VC++
//   - make sure the linker finds the PI_GCS2_DLL.lib
//   - make sure the PI_GCS2_DLL.dll is accessible at program launch
//   - Borland C++: use the implib.exe tool to generate the tlb file
// 2. Basic open loop and closed loop motion, referencing
// 3. Usage of the data recorder with asynchronous reading
//
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include "PI_GCS2_DLL.h"
bool ReferenceIfNeeded(int ID, char* axis)
{
	BOOL bReferenced;
	BOOL bFlag;
	if(!PI_qFRF(ID, axis, &bReferenced))
			return false;
	if(!bReferenced)
	{// if needed,
		// reference the axis using the refence switch
		printf("Referencing axis %s...\n",axis);
		if(!PI_FNL(ID, axis))
			return false;

		// Wait until the reference move is done.
		bFlag = false;
		while(bFlag != TRUE)
		{
			if(!PI_IsControllerReady(ID, &bFlag))
				return false;
		}
	}
	return true;
}


void ReportError(int iD)
{
	int err = PI_GetError(iD);
	char szErrMsg[300];
	if(PI_TranslateError(err,szErrMsg,299))
	{
		printf("Error %d occured: %s\n",err,szErrMsg);
	}
}

void CloseConnectionWithComment(int iD, const char* comment)
{
	printf(comment);
	ReportError(iD);
	PI_CloseConnection(iD);
	_getch();
}


int main(int argc, char* argv[])
{
	srand((unsigned int)time(NULL));
	int iD = PI_ConnectRS232(1,115200);

	double dVal = 1;
	char szAxis[] = "1";
	const BOOL flag=true;
	if(iD>-1)
	{
		char szIDN[200];
		if(PI_qIDN(iD,szIDN,199) == FALSE)
		{
			CloseConnectionWithComment(iD,"qIDN failed. Exiting.\n");
			return FALSE;
		}
		printf("qIDN returned: %s\n",szIDN);

		if(PI_SVO(iD,szAxis,&flag) == FALSE)
		{
			CloseConnectionWithComment(iD,"qIDN failed. Exiting.\n");
			return FALSE;
		}

		if(!ReferenceIfNeeded(iD,szAxis))
		{
			CloseConnectionWithComment(iD,"Not referenced, Referencing failed.\n");
			return FALSE;
		}

		Sleep(1000);
		printf("Moving axis %s...\n",szAxis);
		if(!PI_MOV(iD,szAxis,&dVal))
		{
			CloseConnectionWithComment(iD,"Not referenced, Referencing failed.\n");
			return FALSE;
		}

		PI_CloseConnection(iD);
		printf("Close connection.\n",szAxis);
	}
	else
	{
		printf("Could not connect to C-867\n");
	}
	_getch();
	
	return 0;
}

