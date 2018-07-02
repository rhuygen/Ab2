// DynamicLoadSample.cpp : Defines the entry point for the console application.
//

#define GCS_TRANSLATOR_SUB_DIRECTORY  "\\PI\\GCSTranslator\\"
#define GCS_DLLNAME  "PI_GCS2_DLL.dll"
#define GCS_FUNC_PREFIX "PI_"
#include <stdio.h>
#include <conio.h>
#include <windows.h>
#include <shlobj.h>
#include <time.h>
typedef BOOL (WINAPI *FP_ConnectRS232)( int , int);
typedef BOOL (WINAPI *FP_CloseConnection)( int );
typedef BOOL (WINAPI *FP_qIDN)( int , char*, int);
typedef BOOL (WINAPI *FP_GcsCommandset)( int , char*);
typedef BOOL (WINAPI *FP_GcsGetAnswer)(int,char*,int);
typedef BOOL (WINAPI *FP_GcsGetAnswerSize)(int,int*);
typedef BOOL (WINAPI *FP_qERR)(int, int*);
typedef BOOL (WINAPI *FP_IsMoving)(int, char*,BOOL*);
typedef BOOL (WINAPI *FP_qFRF)(int, char*,BOOL*);

// Function Pointer Variables
FP_ConnectRS232 pConnectRS232;
FP_qIDN pqIDN;
FP_CloseConnection pCloseConnection;
FP_GcsCommandset pGcsCommandset;
FP_GcsGetAnswer pGcsGetAnswer;
FP_GcsGetAnswerSize pGcsGetAnswerSize;
FP_qERR pqERR;
FP_IsMoving pIsMoving;
FP_qFRF	pqFRF;
bool IsControllerReady(int iID)
{
	int iAS=0;
// you have to make sure the answer buffer is emptied before calling this function
	pGcsCommandset(iID,"\7");
	while(iAS==0)
	{
		Sleep(50);
		pGcsGetAnswerSize(iID,&iAS);
	}
	char szAns[10];
	pGcsGetAnswer(iID,szAns,9);
	return szAns[0]&1;
	
}
bool ReferenceStage(int iID,char* szAxis)
{
	char szCommand[50];
	sprintf(szCommand,"SVO %s 1",szAxis);
	if(!pGcsCommandset(iID,szCommand))
		return false;
	do
	{
		Sleep(1);
	}while(!IsControllerReady(iID));
	sprintf(szCommand,"FRF %s",szAxis);
	if(!pGcsCommandset(iID,szCommand))
		return false;
	do
	{
		Sleep(1);
	}while(!IsControllerReady(iID));
	BOOL bOK;
	pqFRF(iID,szAxis,&bOK);
	return (bOK==TRUE);
}
bool MoveTo(int iID,char* szAxis,double dTarget)
{
	bool bOK = true;
	char szCommand[50];
	sprintf(szCommand,"MOV %s %g",szAxis,dTarget);
	if(!pGcsCommandset(iID,szCommand))
		return false;
	BOOL bFlag;
	do
	{	
		Sleep(100);
		bOK &=pIsMoving(iID,szAxis,&bFlag);
	}while(bFlag);
	sprintf(szCommand,"POS? %s",szAxis);
	if(!pGcsCommandset(iID,szCommand))
		return false;
	int iAS=0;
	while(iAS==0)
	{
		Sleep(50);
		bOK &=pGcsGetAnswerSize(iID,&iAS);
	}
	char szAns[20];
	bOK &= pGcsGetAnswer(iID,szAns,19);
	printf("Position after move: %s\n",szAns);
	return bOK;
}
int main(int argc, char* argv[])
{
	int iComPort = 1;
	int iBaudRate = 115200;
	char szAxis[] = "1";

	srand(time(NULL));
	int iID;
	char* szFuncName[100];
	char szProgramDataPath[300];
	
	HRESULT result = SHGetFolderPathA(NULL, CSIDL_COMMON_APPDATA,NULL,0,szProgramDataPath);
	if(result != S_OK)
	{
		return -1;
	}
	char* szGCSDLLName = new char[strlen(szProgramDataPath) + strlen(GCS_TRANSLATOR_SUB_DIRECTORY) + strlen(GCS_DLLNAME) +1];
	sprintf(szGCSDLLName,"%s%s%s",szProgramDataPath,GCS_TRANSLATOR_SUB_DIRECTORY,GCS_DLLNAME);
	printf("Open %s dynamically\n",szGCSDLLName);
	HINSTANCE hPI_Dll = LoadLibrary(szGCSDLLName);
	if(hPI_Dll!=NULL)
	{
		try
		{
			printf("LoadLibrary(\"%s\") successfull\n",szGCSDLLName);


			// get function pointers
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "ConnectRS232");
			pConnectRS232 = (FP_ConnectRS232)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pConnectRS232==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "qIDN");
			pqIDN = (FP_qIDN)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pqIDN==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "CloseConnection");
			pCloseConnection = (FP_CloseConnection)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pCloseConnection==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "GcsCommandset");
			pGcsCommandset = (FP_GcsCommandset)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pGcsCommandset==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "GcsGetAnswer");
			pGcsGetAnswer = (FP_GcsGetAnswer)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pGcsGetAnswer==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "GcsGetAnswerSize");
			pGcsGetAnswerSize = (FP_GcsGetAnswerSize)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pGcsGetAnswerSize==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "qERR");
			pqERR = (FP_qERR)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pqERR==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "IsMoving");
			pIsMoving = (FP_IsMoving)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pIsMoving==NULL)
				throw(-1);
			sprintf((char*)szFuncName,"%s%s",GCS_FUNC_PREFIX , "qFRF");
			pqFRF = (FP_qFRF)GetProcAddress(hPI_Dll,(LPCSTR)szFuncName);
			if(pqFRF==NULL)
				throw(-1);

			printf("All function pointers are loaded\n");

			// connect to controller
			iID = pConnectRS232(iComPort,iBaudRate);
			if(iID<0)
				throw(-2);
			char szIDN[100];
			if(!pqIDN(iID,szIDN,99))
				throw(-3);
			printf("Successfully connected to %s\n",szIDN);

			// Reference
			if(!ReferenceStage(iID,szAxis))
				throw(-4);

			double dTarget;
			do // random motion
			{
				dTarget = rand()*1.0/RAND_MAX;
				if(!MoveTo(iID,szAxis,dTarget))
					throw(-4);

			}while(!kbhit());
			pCloseConnection(iID);
			

		}
		catch(int iErr)
		{
			switch(iErr)
			{
			case(-1):
				{
					printf("Loading function %s failed\n",szFuncName);
				};break;
			case(-2):
				{
					printf("Connecting on COM %d with %d baud failed\n",iComPort,iBaudRate);
				}break;
			case(-3):
				{
					int iGCSERR;
					if(!pqERR(iID,&iGCSERR))
						printf("Reading the GCS error failed\n");
					else
						printf("A GCS function failed with Error %d\n",iGCSERR);
					pCloseConnection(iID);
				}
			case(-4):
				{
					printf("A Special Function failed\n");
					pCloseConnection(iID);
				}
			}
		}
		catch(...)
		{

		}
	}
	else
	{
		LPVOID lpMsgBuf;
		DWORD dw = GetLastError(); 
		FormatMessage(
			FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_SYSTEM |
			FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL,
			dw,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
			(LPTSTR) &lpMsgBuf,
			0, NULL );

		printf("LoadLibrary(\"%s\") failed with error %d:\n%s\n",szGCSDLLName,dw,lpMsgBuf);
		LocalFree(lpMsgBuf);
	}
	getch();
	return 0;
}

