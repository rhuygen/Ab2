unit PI_GCS2_DLL;

{////////////////////////////////////////////////////////////////////////////// }
{/// This is a part of the PI-Software Sources }
{/// Copyright (C) 1995-2014 PHYSIK INSTRUMENTE GmbH }
{/// All rights reserved. }
{/// }

interface
uses
{$IFDEF WIN32}
  Windows;
{$ELSE}
  Wintypes, WinProcs;
{$ENDIF}

Type
  PChar            = PAnsiChar;
  Char             = AnsiChar;


Const
  maxarrlen     = 1024*1024;

type
  TIntegerArray    = array of Integer;
  TDoubleArray     = array of Double;
  TDArray          = array[0..maxarrlen] of double;
  PDoubleArray     = ^TDArray;
  TBoolArray       = array of Bool;

{///////////////////////////////// }
{/// E-7XX Bits (PI_BIT_XXX). // }
{///////////////////////////////// }

{+// Curve Controll PI_BIT_WGO_XXX*/ }
const
  PI_BIT_WGO_START_DEFAULT = $00000001;
const
  PI_BIT_WGO_START_EXTERN_TRIGGER = $00000002;
const
  PI_BIT_WGO_WITH_DDL_INITIALISATION = $00000040;
const
  PI_BIT_WGO_WITH_DDL = $00000080;
const
  PI_BIT_WGO_START_AT_ENDPOSITION = $00000100;
const
  PI_BIT_WGO_SINGLE_RUN_DDL_TEST = $00000200;
const
  PI_BIT_WGO_EXTERN_WAVE_GENERATOR = $00000400;
const
  PI_BIT_WGO_SAVE_BIT_1 = $00100000;
const
  PI_BIT_WGO_SAVE_BIT_2 = $00200000;
const
  PI_BIT_WGO_SAVE_BIT_3 = $00400000;

{+// Wave-Trigger PI_BIT_TRG_XXX*/ }
const
  PI_BIT_TRG_LINE_1 = $0001;
const
  PI_BIT_TRG_LINE_2 = $0002;
const
  PI_BIT_TRG_LINE_3 = $0003;
const
  PI_BIT_TRG_LINE_4 = $0008;
const
  PI_BIT_TRG_ALL_CURVE_POINTS = $0100;

{+// Data Record Configuration PI_DRC_XXX*/ }
const
  PI_DRC_DEFAULT = 0;
const
  PI_DRC_AXIS_TARGET_POS = 1;
const
  PI_DRC_AXIS_ACTUAL_POS = 2;
const
  PI_DRC_AXIS_POS_ERROR = 3;
const
  PI_DRC_AXIS_DDL_DATA = 4;
const
  PI_DRC_AXIS_DRIVING_VOL = 5;
const
  PI_DRC_PIEZO_MODEL_VOL = 6;
const
  PI_DRC_PIEZO_VOL = 7;
const
  PI_DRC_SENSOR_POS = 8;


{+// P(arameter)I(nfo)F(lag)_M(emory)T(ype)_XX*/ }
const
  PI_PIF_MT_RAM = $00000001;
const
  PI_PIF_MT_EPROM = $00000002;
const
  PI_PIF_MT_ALL = (PI_PIF_MT_RAM or PI_PIF_MT_EPROM);

{+// P(arameter)I(nfo)F(lag)_D(ata)T(ype)_XX*/ }
const
  PI_PIF_DT_INT = 1;
const
  PI_PIF_DT_FLOAT = 2;
const
  PI_PIF_DT_CHAR = 3;


{////////////////////////////////////////////////////////////////////////////// }
{/// DLL initialization and comm functions }

function PI_InterfaceSetupDlg(const szRegKeyName: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ConnectRS232(nPortNr: Integer; 
                         iBaudRate: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 
{+//* }
{-* Starts background thread which tries to establish connection to controller with given RS-Settings. }
{-* \param … }
{-* \return ID of new thread (>=0), error code (<0) if not }
{= }

function PI_TryConnectRS232(port: Integer; 
                            baudrate: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{+//* }
{-* Starts background thread which tries to establish connection to controller with given USB-Settings. }
{-* \param … }
{-* \return ID of new thread (>=0), error code (<0) if not }
{= }

function PI_TryConnectUSB(const szDescription: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{+//* }
{-* Check if thread with given ID is running trying to establish communication }
{-* \return TRUE if thread is running, FALSE if no thread is running with given ID }
{= }

function PI_IsConnecting(threadID: Integer; 
                         var bCOnnecting: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{+//* }
{-* Get ID of connected controller for given threadID }
{-* \return ID of new controller (>=0), error code (<0) if there was an error, no thread running, or thread has not finished yet }
{= }

function PI_GetControllerID(threadID: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{+//* }
{-* Cancel connecting thread with given ID }
{-* \return TRUE if thread was cancelled, FALSE if no thread with given ID was running }
{= }


function PI_CancelConnect(threadI: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{$IFNDEF WIN32}

function PI_ConnectRS232ByDevName(const szDevName: PChar; 
                                  BaudRate: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 
{$ENDIF}

function PI_OpenRS232DaisyChain(iPortNumber: Integer; 
                                iBaudRate: Integer; 
                                var pNumberOfConnectedDaisyChainDevices: Integer; 
                                szDeviceIDNs: PChar; 
                                iBufferSize: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ConnectDaisyChainDevice(iPortId: Integer; 
                                    iDeviceNumber: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

procedure PI_CloseDaisyChain(iPortId: Integer) cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_ConnectNIgpib(nBoard: Integer; 
                          nDevAddr: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_ConnectTCPIP(const szHostname: PChar; 
                         port: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_EnableTCPIPScan(iMask: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_EnumerateTCPIPDevices(szBuffer: PChar; 
                                  iBufferSize: Integer; 
                                  const szFilter: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ConnectTCPIPByDescription(const szDescription: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OpenTCPIPDaisyChain(const szHostname: PChar; 
                                port: Integer; 
                                var pNumberOfConnectedDaisyChainDevices: Integer; 
                                szDeviceIDNs: PChar; 
                                iBufferSize: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_EnumerateUSB(szBuffer: PChar; 
                         iBufferSize: Integer; 
                         const szFilter: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ConnectUSB(const szDescription: PChar): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ConnectUSBWithBaudRate(const szDescription: PChar; 
                                   iBaudRate: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OpenUSBDaisyChain(const szDescription: PChar; 
                              var pNumberOfConnectedDaisyChainDevices: Integer; 
                              szDeviceIDNs: PChar; 
                              iBufferSize: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_IsConnected(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

procedure PI_CloseConnection(ID: Integer) cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GetError(ID: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SetErrorCheck(ID: Integer; 
                          bErrorCheck: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_TranslateError(errNr: Integer; 
                           szBuffer: PChar; 
                           iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SetTimeout(ID: Integer; 
                       timeoutInMS: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SetDaisyChainScanMaxDeviceID(maxID: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_EnableReconnect(ID: Integer; 
                            bEnable: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SetNrTimeoutsBeforeClose(ID: Integer; 
                                     nrTimeoutsBeforeClose: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_GetInterfaceDescription(ID: Integer; 
                                    szBuffer: PChar; 
                                    iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// general }

function PI_qERR(ID: Integer; 
                 var pnError: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qIDN(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_INI(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHLP(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHPA(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHPV(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCSV(ID: Integer; 
                 var pdCommandSyntaxVersion: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOVF(ID: Integer; 
                 const szAxes: PChar; 
                 var piValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RBT(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_REP(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_BDR(ID: Integer; 
                iBaudRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qBDR(ID: Integer; 
                 var iBaudRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DBR(ID: Integer; 
                iBaudRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDBR(ID: Integer; 
                 var iBaudRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVER(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSSN(ID: Integer; 
                 szSerialNumber: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CCT(ID: Integer; 
                iCommandType: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCCT(ID: Integer; 
                 var iCommandType: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTVI(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IFC(ID: Integer; 
                const szParameters: PChar; 
                const szValues: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qIFC(ID: Integer; 
                 const szParameters: PChar; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IFS(ID: Integer; 
                const szPassword: PChar; 
                const szParameters: PChar; 
                const szValues: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qIFS(ID: Integer; 
                 const szParameters: PChar; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qECO(ID: Integer; 
                 const szSendString: PChar; 
                 szValues: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_MOV(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qMOV(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MVR(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MVE(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_POS(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qPOS(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IsMoving(ID: Integer; 
                     const szAxes: PChar; 
                     var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HLT(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_STP(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_StopAll(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qONT(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RTO(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qRTO(ID: Integer; 
                 const szAxes: PChar; 
                 var piValueArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ATZ(ID: Integer; 
                const szAxes: PChar; 
                const pdLowvoltageArray: PDouble; 
                const pfUseDefaultArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qATZ(ID: Integer; 
                 const szAxes: PChar; 
                 var piAtzResultArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_AOS(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qAOS(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HasPosChanged(ID: Integer; 
                          const szAxes: PChar; 
                          var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GetErrorStatus(ID: Integer; 
                           var pbIsReferencedArray: Bool; 
                           var pbIsReferencing: Bool; 
                           var pbIsMovingArray: Bool; 
                           var pbIsMotionErrorArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 



function PI_SVA(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSVA(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SVR(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_DFH(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDFH(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GOH(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_qCST(ID: Integer; 
                 const szAxes: PChar; 
                 szNames: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CST(ID: Integer; 
                const szAxes: PChar; 
                const szNames: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVST(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qPUN(ID: Integer; 
                 const szAxes: PChar; 
                 szUnit: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SVO(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSVO(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SMO(ID: Integer; 
                const szAxes: PChar; 
                const piValueArray: PInteger): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSMO(ID: Integer; 
                 const szAxes: PChar; 
                 var piValueArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DCO(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDCO(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_BRA(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qBRA(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_RON(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qRON(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_VEL(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVEL(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_JOG(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qJOG(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_qTCV(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_VLS(ID: Integer; 
                dSystemVelocity: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVLS(ID: Integer; 
                 var pdSystemVelocity: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_ACC(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qACC(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_DEC(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDEC(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_VCO(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVCO(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SPA(ID: Integer; 
                const szAxes: PChar; 
                const iParameterArray: PCardinal; 
                const pdValueArray: PDouble; 
                const szStrings: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSPA(ID: Integer; 
                 const szAxes: PChar; 
                 var iParameterArray: Cardinal; 
                 var pdValueArray: Double; 
                 szStrings: PChar; 
                 iMaxNameSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SEP(ID: Integer; 
                const szPassword: PChar; 
                const szAxes: PChar; 
                const iParameterArray: PCardinal; 
                const pdValueArray: PDouble; 
                const szStrings: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSEP(ID: Integer; 
                 const szAxes: PChar; 
                 var iParameterArray: Cardinal; 
                 var pdValueArray: Double; 
                 szStrings: PChar; 
                 iMaxNameSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WPA(ID: Integer; 
                const szPassword: PChar; 
                const szAxes: PChar; 
                const iParameterArray: PCardinal): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DPA(ID: Integer; 
                const szPassword: PChar; 
                const szAxes: PChar; 
                const iParameterArray: PCardinal): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_TIM(ID: Integer; 
                dTimer: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTIM(ID: Integer; 
                 var pdTimer: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RPA(ID: Integer; 
                const szAxes: PChar; 
                const iParameterArray: PCardinal): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SPA_String(ID: Integer; 
                       const szAxes: PChar; 
                       const iParameterArray: PCardinal; 
                       const szStrings: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSPA_String(ID: Integer; 
                        const szAxes: PChar; 
                        const iParameterArray: PCardinal; 
                        szStrings: PChar; 
                        iMaxNameSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SEP_String(ID: Integer; 
                       const szPassword: PChar; 
                       const szAxes: PChar; 
                       const iParameterArray: PCardinal; 
                       const szStrings: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSEP_String(ID: Integer; 
                        const szAxes: PChar; 
                        var iParameterArray: Cardinal; 
                        szStrings: PChar; 
                        iMaxNameSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SPA_int64(ID: Integer; 
                      const szAxes: PChar; 
                      const iParameterArray: PCardinal; 
                      const piValueArray: Pint64): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSPA_int64(ID: Integer; 
                       const szAxes: PChar; 
                       var iParameterArray: Cardinal; 
                       var piValueArray: int64): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SEP_int64(ID: Integer; 
                      const szPassword: PChar; 
                      const szAxes: PChar; 
                      const iParameterArray: PCardinal; 
                      const piValueArray: Pint64): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSEP_int64(ID: Integer; 
                       const szAxes: PChar; 
                       var iParameterArray: Cardinal; 
                       var piValueArray: int64): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_STE(ID: Integer; 
                const szAxes: PChar; 
                const dOffsetArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSTE(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IMP(ID: Integer; 
                const szAxes: PChar; 
                const pdImpulseSize: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IMP_PulseWidth(ID: Integer; 
                           cAxis: Char; 
                           dOffset: Double; 
                           iPulseWidth: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qIMP(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SAI(ID: Integer; 
                const szOldAxes: PChar; 
                const szNewAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSAI(ID: Integer; 
                 szAxes: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSAI_ALL(ID: Integer; 
                     szAxes: PChar; 
                     iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_CCL(ID: Integer; 
                iComandLevel: Integer; 
                const szPassWord: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCCL(ID: Integer; 
                 var piComandLevel: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_AVG(ID: Integer; 
                iAverrageTime: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qAVG(ID: Integer; 
                 var iAverrageTime: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_qHAR(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qLIM(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTRS(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FNL(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FPL(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FRF(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FED(ID: Integer; 
                const szAxes: PChar; 
                const piEdgeArray: PInteger; 
                const piParamArray: PInteger): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qFRF(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DIO(ID: Integer; 
                const piChannelsArray: PInteger; 
                const pbValueArray: PBool; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDIO(ID: Integer; 
                 const piChannelsArray: PInteger; 
                 var pbValueArray: Bool; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTIO(ID: Integer; 
                 var piInputNr: Integer; 
                 var piOutputNr: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_IsControllerReady(ID: Integer; 
                              var piControllerReady: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSRG(ID: Integer; 
                 const szAxes: PChar; 
                 const iRegisterArray: PInteger; 
                 var iValArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_ATC(ID: Integer; 
                const piChannels: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qATC(ID: Integer; 
                 const piChannels: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qATS(ID: Integer; 
                 const piChannels: PInteger; 
                 const piOptions: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SPI(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSPI(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SCT(ID: Integer; 
                dCycleTime: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSCT(ID: Integer; 
                 var pdCycleTime: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_SST(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSST(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_qCTV(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValarray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CTV(ID: Integer; 
                const szAxes: PChar; 
                const pdValarray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CTR(ID: Integer; 
                const szAxes: PChar; 
                const pdValarray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCAV(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValarray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCCV(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValarray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCMO(ID: Integer; 
                 const szAxes: PChar; 
                 var piValArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CMO(ID: Integer; 
                const szAxes: PChar; 
                const piValArray: PInteger): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// Macro commands }

function PI_IsRunningMacro(ID: Integer; 
                           var pbRunningMacro: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_BEG(ID: Integer; 
                    const szMacroName: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_START(ID: Integer; 
                      const szMacroName: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_NSTART(ID: Integer; 
                       const szMacroName: PChar; 
                       nrRuns: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_MAC_START_Args(ID: Integer; 
                           const szMacroName: PChar; 
                           const szArgs: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_NSTART_Args(ID: Integer; 
                            const szMacroName: PChar; 
                            nrRuns: Integer; 
                            const szArgs: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_END(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_DEL(ID: Integer; 
                    const szMacroName: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_DEF(ID: Integer; 
                    const szMacroName: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_qDEF(ID: Integer; 
                     szBuffer: PChar; 
                     iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_qERR(ID: Integer; 
                     szBuffer: PChar; 
                     iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MAC_qFREE(ID: Integer; 
                      var iFreeSpace: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qMAC(ID: Integer; 
                 const szMacroName: PChar; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qRMC(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_DEL(ID: Integer; 
                nMilliSeconds: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WAC(ID: Integer; 
                const szCondition: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MEX(ID: Integer; 
                const szCondition: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_VAR(ID: Integer; 
                const szVariable: PChar; 
                const szValue: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVAR(ID: Integer; 
                 const szVariables: PChar; 
                 szValues: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ADD(ID: Integer; 
                const szVariable: PChar; 
                value1: Double; 
                value2: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CPY(ID: Integer; 
                const szVariable: PChar; 
                const szCommand: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// String commands. }

function PI_GcsCommandset(ID: Integer; 
                          const szCommand: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GcsGetAnswer(ID: Integer; 
                         szAnswer: PChar; 
                         iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GcsGetAnswerSize(ID: Integer; 
                             var iAnswerSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// limits }

function PI_qTMN(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTMX(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_NLM(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qNLM(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_PLM(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qPLM(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SSL(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSSL(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVMO(ID: Integer; 
                 const szAxes: PChar; 
                 const pdValarray: PDouble; 
                 var pbMovePossible: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCMN(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCMX(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// Wave commands. }

function PI_IsGeneratorRunning(ID: Integer; 
                               const piWaveGeneratorIds: PInteger; 
                               var pbValueArray: Bool; 
                               iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTWG(ID: Integer; 
                 var piWaveGenerators: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WAV_SIN_P(ID: Integer; 
                      iWaveTableId: Integer; 
                      iOffsetOfFirstPointInWaveTable: Integer; 
                      iNumberOfPoints: Integer; 
                      iAddAppendWave: Integer; 
                      iCenterPointOfWave: Integer; 
                      dAmplitudeOfWave: Double; 
                      dOffsetOfWave: Double; 
                      iSegmentLength: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WAV_LIN(ID: Integer; 
                    iWaveTableId: Integer; 
                    iOffsetOfFirstPointInWaveTable: Integer; 
                    iNumberOfPoints: Integer; 
                    iAddAppendWave: Integer; 
                    iNumberOfSpeedUpDownPointsInWave: Integer; 
                    dAmplitudeOfWave: Double; 
                    dOffsetOfWave: Double; 
                    iSegmentLength: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WAV_RAMP(ID: Integer; 
                     iWaveTableId: Integer; 
                     iOffsetOfFirstPointInWaveTable: Integer; 
                     iNumberOfPoints: Integer; 
                     iAddAppendWave: Integer; 
                     iCenterPointOfWave: Integer; 
                     iNumberOfSpeedUpDownPointsInWave: Integer; 
                     dAmplitudeOfWave: Double; 
                     dOffsetOfWave: Double; 
                     iSegment: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF};

function PI_WAV_PNT(ID: Integer;
                    iWaveTableId: Integer;
                    iOffsetOfFirstPointInWaveTable: Integer;
                    iNumberOfPoints: Integer;
                    iAddAppendWave: Integer;
                    const pdWavePoints: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF};

function PI_WAV_NOISE(ID: Integer; 
                      iWaveTableId: Integer; 
                      iAddAppendWave: Integer; 
                      dAmplitudeOfWave: Double; 
                      dOffsetOfWave: Double; 
                      iSegmentLength: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_QWAV(ID: Integer; 
                    const piWaveGeneratorIdsArray: PInteger; 
                     const piParamereIdsArray: PInteger; 
                     var pdValueArray: Double; 
                     iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WGO(ID: Integer; 
                const piWaveGeneratorIdsArray: PInteger; 
                const iStartModArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWGO(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WGC(ID: Integer; 
                const piWaveGeneratorIdsArray: PInteger; 
                const piNumberOfCyclesArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWGC(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWGI(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWGN(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WSL(ID: Integer; 
                const piWaveGeneratorIdsArray: PInteger; 
                const piWaveTableIdsArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWSL(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piWaveTableIdsArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DTC(ID: Integer; 
                const piDdlTableIdsArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDTL(ID: Integer; 
                 const piDdlTableIdsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WCL(ID: Integer; 
                const piWaveTableIdsArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTLT(ID: Integer; 
                 var piNumberOfDdlTables: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qGWD_SYNC(ID: Integer; 
                      iWaveTableId: Integer; 
                      iOffsetOfFirstPointInWaveTable: Integer; 
                      iNumberOfValues: Integer; 
                      var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qGWD(ID: Integer; 
                 const iWaveTableIdsArray: PInteger; 
                 iNumberOfWaveTables: Integer; 
                 iOffset: Integer; 
                 nrValues: Integer; 
                 var pdValarray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WOS(ID: Integer; 
                const iWaveTableIdsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWOS(ID: Integer; 
                 const iWaveTableIdsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WTR(ID: Integer; 
                const piWaveGeneratorIdsArray: PInteger; 
                const piTableRateArray: PInteger; 
                const piInterpolationTypeArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWTR(ID: Integer; 
                 const piWaveGeneratorIdsArray: PInteger; 
                 var piTableRateArray: Integer; 
                 var piInterpolationTypeArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DDL(ID: Integer; 
                iDdlTableId: Integer; 
                iOffsetOfFirstPointInDdlTable: Integer; 
                iNumberOfValues: Integer; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDDL_SYNC(ID: Integer; 
                      iDdlTableId: Integer; 
                      iOffsetOfFirstPointInDdlTable: Integer; 
                      iNumberOfValues: Integer; 
                      var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDDL(ID: Integer; 
                 const iDdlTableIdsArray: PInteger; 
                 iNumberOfDdlTables: Integer; 
                 iOffset: Integer; 
                 nrValues: Integer; 
                 var pdValarray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DPO(ID: Integer; 
                const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qWMS(ID: Integer; 
                 const piWaveTableIds: PInteger; 
                 var iWaveTableMaximumSize: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 



{//////////////////////////////////////////////////////////////////////////////// }
{///// Trigger commands. }

function PI_TWC(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_TWS(ID: Integer; 
                const piTriggerChannelIdsArray: PInteger; 
                const piPointNumberArray: PInteger; 
                const piSwitchArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTWS(ID: Integer; 
                 const iTriggerChannelIdsArray: PInteger; 
                 iNumberOfTriggerChannels: Integer; 
                 iOffset: Integer; 
                 nrValues: Integer; 
                 var pdValarray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CTO(ID: Integer; 
                const piTriggerOutputIdsArray: PInteger; 
                const piTriggerParameterArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CTOString(ID: Integer; 
                      const piTriggerOutputIdsArray: PInteger; 
                      const piTriggerParameterArray: PInteger; 
                      const szValueArray: PChar; 
                      iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCTO(ID: Integer; 
                 const piTriggerOutputIdsArray: PInteger; 
                 const piTriggerParameterArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCTOString(ID: Integer; 
                       const piTriggerOutputIdsArray: PInteger; 
                       const piTriggerParameterArray: PInteger; 
                       szValueArray: PChar; 
                       iArraySize: Integer; 
                       iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_TRO(ID: Integer; 
                const piTriggerOutputIds: PInteger; 
                const pbTriggerState: PBool; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTRO(ID: Integer; 
                 const piTriggerOutputIds: PInteger; 
                 var pbTriggerState: Bool; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_TRI(ID: Integer; 
                const piTriggerInputIds: PInteger; 
                const pbTriggerState: PBool; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTRI(ID: Integer; 
                 const piTriggerInputIds: PInteger; 
                 var pbTriggerState: Bool; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_CTI(ID: Integer; 
                const piTriggerInputIds: PInteger; 
                const piTriggerParameterArray: PInteger; 
                const szValueArray: PChar; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qCTI(ID: Integer; 
                 const piTriggerInputIds: PInteger; 
                 const piTriggerParameterArray: PInteger; 
                 szValueArray: PChar; 
                 iArraySize: Integer; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// Record tabel commands. }

function PI_qHDR(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTNR(ID: Integer; 
                 var piNumberOfRecordCannels: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DRC(ID: Integer; 
                const piRecordTableIdsArray: PInteger; 
                const szRecordSourceIds: PChar; 
                const piRecordOptionArray: PInteger): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDRC(ID: Integer; 
                 const piRecordTableIdsArray: PInteger; 
                 szRecordSourceIds: PChar; 
                 var piRecordOptionArray: Integer; 
                 iRecordSourceIdsBufferSize: Integer; 
                 iRecordOptionArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDRR_SYNC(ID: Integer; 
                      iRecordTablelId: Integer; 
                      iOffsetOfFirstPointInRecordTable: Integer; 
                      iNumberOfValues: Integer; 
                      var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDRR(ID: Integer; 
                 const piRecTableIdIdsArray: PInteger; 
                 iNumberOfRecChannels: Integer; 
                 iOffsetOfFirstPointInRecordTable: Integer; 
                 iNumberOfValues: Integer; 
                 var pdValueArray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DRT(ID: Integer; 
                const piRecordChannelIdsArray: PInteger; 
                const piTriggerSourceArray: PInteger; 
                const szValues: PChar; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDRT(ID: Integer; 
                 const piRecordChannelIdsArray: PInteger; 
                 var piTriggerSourceArray: Integer; 
                 szValues: PChar; 
                 iArraySize: Integer; 
                 iValueBufferLength: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RTR(ID: Integer; 
                piReportTableRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qRTR(ID: Integer; 
                 var piReportTableRate: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_WGR(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qDRL(ID: Integer; 
                 const piRecordChannelIdsArray: PInteger; 
                 var piNuberOfRecordedValuesArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// Piezo-Channel commands. }

function PI_VMA(ID: Integer; 
                const piPiezoChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVMA(ID: Integer; 
                 const piPiezoChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_VMI(ID: Integer; 
                const piPiezoChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVMI(ID: Integer; 
                 const piPiezoChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_VOL(ID: Integer; 
                const piPiezoChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qVOL(ID: Integer; 
                 const piPiezoChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTPC(ID: Integer; 
                 var piNumberOfPiezoChannels: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ONL(ID: Integer; 
                const iPiezoCannels: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qONL(ID: Integer; 
                 const iPiezoCannels: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// Sensor-Channel commands. }

function PI_qTAD(ID: Integer; 
                 const piSensorsChannelsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTNS(ID: Integer; 
                 const piSensorsChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTSP(ID: Integer; 
                 const piSensorsChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SCN(ID: Integer; 
                const piSensorsChannelsArray: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSCN(ID: Integer; 
                 const piSensorsChannelsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTSC(ID: Integer; 
                 var piNumberOfSensorChannels: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{////////////////////////////////////////////////////////////////////////////// }
{/// PIEZOWALK(R)-Channel commands. }

function PI_APG(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qAPG(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_OAC(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOAC(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OAD(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOAD(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_ODC(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qODC(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OCD(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOCD(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OSM(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOSM(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OSMf(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 const pdValueArray: PDouble; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOSMf(ID: Integer; 
                  const piPIEZOWALKChannelsArray: PInteger; 
                  var pdValueArray: Double; 
                  iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OVL(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOVL(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOSN(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_SSA(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSSA(ID: Integer; 
                 const piPIEZOWALKChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RNP(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_PGS(ID: Integer; 
                const piPIEZOWALKChannelsArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTAC(ID: Integer; 
                 var pnNrChannels: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTAV(ID: Integer; 
                 const piChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OMA(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qOMA(ID: Integer; 
                 const szAxes: PChar; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OMR(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// Joystick }

function PI_qJAS(ID: Integer; 
                 const iJoystickIDsArray: PInteger; 
                 const iAxesIDsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_JAX(ID: Integer; 
                iJoystickID: Integer; 
                iAxesID: Integer; 
                const szAxesBuffer: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qJAX(ID: Integer; 
                 const iJoystickIDsArray: PInteger; 
                 const iAxesIDsArray: PInteger; 
                 iArraySize: Integer; 
                 szAxesBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qJBS(ID: Integer; 
                 const iJoystickIDsArray: PInteger; 
                 const iButtonIDsArray: PInteger; 
                 var pbValueArray: Bool; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_JDT(ID: Integer; 
                const iJoystickIDsArray: PInteger; 
                const iAxisIDsArray: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_JLT(ID: Integer; 
                iJoystickID: Integer; 
                iAxisID: Integer; 
                iStartAdress: Integer; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qJLT(ID: Integer; 
                 const iJoystickIDsArray: PInteger; 
                 const iAxisIDsArray: PInteger; 
                 iNumberOfTables: Integer; 
                 iOffsetOfFirstPointInTable: Integer; 
                 iNumberOfValues: Integer; 
                 var pdValueArray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_JON(ID: Integer; 
                const iJoystickIDsArray: PInteger; 
                const pbValueArray: PBool; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qJON(ID: Integer; 
                 const iJoystickIDsArray: PInteger; 
                 var pbValueArray: Bool; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// fast scan commands }

function PI_AAP(ID: Integer; 
                const szAxis1: PChar; 
                dLength1: Double; 
                const szAxis2: PChar; 
                dLength2: Double; 
                dAlignStep: Double; 
                iNrRepeatedPositions: Integer; 
                iAnalogInput: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FIO(ID: Integer; 
                const szAxis1: PChar; 
                dLength1: Double; 
                const szAxis2: PChar; 
                dLength2: Double; 
                dThreshold: Double; 
                dLinearStep: Double; 
                dAngleScan: Double; 
                iAnalogInput: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FLM(ID: Integer; 
                const szAxis: PChar; 
                dLength: Double; 
                dThreshold: Double; 
                iAnalogInput: Integer; 
                iDirection: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FLS(ID: Integer; 
                const szAxis: PChar; 
                dLength: Double; 
                dThreshold: Double; 
                iAnalogInput: Integer; 
                iDirection: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FSA(ID: Integer; 
                const szAxis1: PChar; 
                dLength1: Double; 
                const szAxis2: PChar; 
                dLength2: Double; 
                dThreshold: Double; 
                dDistance: Double; 
                dAlignStep: Double; 
                iAnalogInput: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FSC(ID: Integer; 
                const szAxis1: PChar; 
                dLength1: Double; 
                const szAxis2: PChar; 
                dLength2: Double; 
                dThreshold: Double; 
                dDistance: Double; 
                iAnalogInput: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_FSM(ID: Integer; 
                const szAxis1: PChar; 
                dLength1: Double; 
                const szAxis2: PChar; 
                dLength2: Double; 
                dThreshold: Double; 
                dDistance: Double; 
                iAnalogInput: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qFSS(ID: Integer; 
                 var piResult: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// optical boards (hexapod) }

function PI_SGA(ID: Integer; 
                const piAnalogChannelIds: PInteger; 
                const piGainValues: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qSGA(ID: Integer; 
                 const piAnalogChannelIds: PInteger; 
                 var piGainValues: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_NAV(ID: Integer; 
                const piAnalogChannelIds: PInteger; 
                const piNrReadingsValues: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qNAV(ID: Integer; 
                 const piAnalogChannelIds: PInteger; 
                 var piNrReadingsValues: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 
{/// more hexapod specific }

function PI_GetDynamicMoveBufferSize(ID: Integer; 
                                     var iSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// PIShift }

function PI_qCOV(ID: Integer; 
                 const piChannelsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MOD(ID: Integer; 
                const szItems: PChar; 
                const iModeArray: PCardinal; 
                const szValues: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qMOD(ID: Integer; 
                 const szItems: PChar; 
                 const iModeArray: PCardinal; 
                 szValues: PChar; 
                 iMaxValuesSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


function PI_qDIA(ID: Integer; 
                 const iIDArray: PCardinal; 
                 szValues: PChar; 
                 iBufferSize: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHDI(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// HID }

function PI_qHIS(ID: Integer; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HIS(ID: Integer; 
                const iDeviceIDsArray: PInteger; 
                const iItemIDsArray: PInteger; 
                const iPropertyIDArray: PInteger; 
                const szValues: PChar; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIE(ID: Integer; 
                 const iDeviceIDsArray: PInteger; 
                 const iAxesIDsArray: PInteger; 
                 var pdValueArray: Double; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIB(ID: Integer; 
                 const iDeviceIDsArray: PInteger; 
                 const iButtonIDsArray: PInteger; 
                 var pbValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HIL(ID: Integer; 
                const iDeviceIDsArray: PInteger; 
                const iLED_IDsArray: PInteger; 
                const pnValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIL(ID: Integer; 
                 const iDeviceIDsArray: PInteger; 
                 const iLED_IDsArray: PInteger; 
                 var pnValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HIN(ID: Integer; 
                const szAxes: PChar; 
                const pbValueArray: PBool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIN(ID: Integer; 
                 const szAxes: PChar; 
                 var pbValueArray: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HIA(ID: Integer; 
                const szAxes: PChar; 
                const iFunctionArray: PInteger; 
                const iDeviceIDsArray: PInteger; 
                const iAxesIDsArray: PInteger): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIA(ID: Integer; 
                 const szAxes: PChar; 
                 const iFunctionArray: PInteger; 
                 var iDeviceIDsArray: Integer; 
                 var iAxesIDsArray: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HDT(ID: Integer; 
                const iDeviceIDsArray: PInteger; 
                const iAxisIDsArray: PInteger; 
                const piValueArray: PInteger; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHDT(ID: Integer; 
                 const iDeviceIDsArray: PInteger; 
                 const iAxisIDsArray: PInteger; 
                 var piValueArray: Integer; 
                 iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_HIT(ID: Integer; 
                const piTableIdsArray: PInteger; 
                const piPointNumberArray: PInteger; 
                const pdValueArray: PDouble; 
                iArraySize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qHIT(ID: Integer; 
                 const piTableIdsArray: PInteger; 
                 iNumberOfTables: Integer; 
                 iOffsetOfFirstPointInTable: Integer; 
                 iNumberOfValues: Integer; 
                 var pdValueArray: PDoubleArray; 
                 szGcsArrayHeader: PChar; 
                 iGcsArrayHeaderMaxSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }

function PI_qMAN(ID: Integer; 
                 const szCommand: PChar; 
                 szBuffer: PChar; 
                 iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }

function PI_KSF(ID: Integer; 
                const szNameOfCoordSystem: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KEN(ID: Integer; 
                const szNameOfCoordSystem: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KRM(ID: Integer; 
                const szNameOfCoordSystem: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KLF(ID: Integer; 
                const szNameOfCoordSystem: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KSD(ID: Integer; 
                const szNameOfCoordSystem: PChar; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KST(ID: Integer; 
                const szNameOfCoordSystem: PChar; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KSW(ID: Integer; 
                const szNameOfCoordSystem: PChar; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KLD(ID: Integer; 
                const szNameOfCoordSystem: PChar; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KSB(ID: Integer; 
                const szNameOfCoordSystem: PChar; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MRT(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_MRW(ID: Integer; 
                const szAxes: PChar; 
                const pdValueArray: PDouble): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKLT(ID: Integer; 
                 const szStartCoordSystem: PChar; 
                 const szEndCoordSystem: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKEN(ID: Integer; 
                 const szNamesOfCoordSystems: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKET(ID: Integer; 
                 const szTypes: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKLS(ID: Integer; 
                 const szNameOfCoordSystem: PChar; 
                 const szItem1: PChar; 
                 const szItem2: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KLN(ID: Integer; 
                const szNameOfChild: PChar; 
                const szNameOfParent: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKLN(ID: Integer; 
                 const szNamesOfCoordSystems: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qTRA(ID: Integer; 
                 const szAxes: PChar; 
                 const pdComponents: PDouble; 
                 var pdValueArray: Double): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_qKLC(ID: Integer; 
                 const szNameOfCoordSystem: PChar; 
                 const szNameOfCoordSystem2: PChar; 
                 const szItem1: PChar; 
                 const szItem2: PChar; 
                 buffer: PChar; 
                 bufsize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_KCP(ID: Integer; 
                const szSource: PChar; 
                const szDestination: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

{////////////////////////////////////////////////////////////////////////////// }
{/// Spezial }

function PI_GetSupportedParameters(ID: Integer; 
                                   var piParameterIdArray: Integer; 
                                   var piCommandLevelArray: Integer; 
                                   var piMemoryLocationArray: Integer; 
                                   var piDataTypeArray: Integer; 
                                   var piNumberOfItems: Integer; 
                                   const iiBufferSize: Integer; 
                                   szParameterName: PChar; 
                                   const iMaxParameterNameSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GetSupportedControllers(szBuffer: PChar; 
                                    iBufferSize: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GetAsyncBufferIndex(ID: Integer): Integer cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_GetAsyncBuffer(ID: Integer; 
                           var pdValueArray: PDoubleArray): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 



function PI_AddStage(ID: Integer; 
                     const szAxes: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_RemoveStage(ID: Integer; 
                        const szStageName: PChar): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OpenUserStagesEditDialog(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_OpenPiStagesEditDialog(ID: Integer): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 


{//////////////////////////////////////////////////////////////////////////////// }
{/// for internal use }

function PI_DisableSingleStagesDatFiles(ID: Integer; 
                                        bDisable: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function PI_DisableUserStagesDatFiles(ID: Integer; 
                                      bDisable: Bool): Bool cdecl  {$IFDEF WIN32} stdcall {$ENDIF}; 

function GetPIDllVersion: string;

{$IFDEF __cplusplus}
{$ENDIF}

implementation
uses
  sysutils;

function GetPIDllVersion: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize('PI_GCS2_DLL.DLL', Dummy);
  if VerInfoSize = 0 then Exit;
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo('PI_GCS2_DLL.DLL', 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  result:='PI_GCS2_DLL.DLL'+' Version '+result;
  FreeMem(VerInfo, VerInfoSize);
end;

function PI_InterfaceSetupDlg; external 'PI_GCS2_DLL.DLL';
function PI_ConnectRS232; external 'PI_GCS2_DLL.DLL';
function PI_TryConnectRS232; external 'PI_GCS2_DLL.DLL';
function PI_TryConnectUSB; external 'PI_GCS2_DLL.DLL';
function PI_IsConnecting; external 'PI_GCS2_DLL.DLL';
function PI_GetControllerID; external 'PI_GCS2_DLL.DLL';
function PI_CancelConnect; external 'PI_GCS2_DLL.DLL';
{$IFNDEF WIN32}
function PI_ConnectRS232ByDevName; external 'PI_GCS2_DLL.DLL';
{$ENDIF}
function PI_OpenRS232DaisyChain; external 'PI_GCS2_DLL.DLL';
function PI_ConnectDaisyChainDevice; external 'PI_GCS2_DLL.DLL';
procedure PI_CloseDaisyChain; external 'PI_GCS2_DLL.DLL';
function PI_ConnectNIgpib; external 'PI_GCS2_DLL.DLL';
function PI_ConnectTCPIP; external 'PI_GCS2_DLL.DLL';
function PI_EnableTCPIPScan; external 'PI_GCS2_DLL.DLL';
function PI_EnumerateTCPIPDevices; external 'PI_GCS2_DLL.DLL';
function PI_ConnectTCPIPByDescription; external 'PI_GCS2_DLL.DLL';
function PI_OpenTCPIPDaisyChain; external 'PI_GCS2_DLL.DLL';
function PI_EnumerateUSB; external 'PI_GCS2_DLL.DLL';
function PI_ConnectUSB; external 'PI_GCS2_DLL.DLL';
function PI_ConnectUSBWithBaudRate; external 'PI_GCS2_DLL.DLL';
function PI_OpenUSBDaisyChain; external 'PI_GCS2_DLL.DLL';
function PI_IsConnected; external 'PI_GCS2_DLL.DLL';
procedure PI_CloseConnection; external 'PI_GCS2_DLL.DLL';
function PI_GetError; external 'PI_GCS2_DLL.DLL';
function PI_SetErrorCheck; external 'PI_GCS2_DLL.DLL';
function PI_TranslateError; external 'PI_GCS2_DLL.DLL';
function PI_SetTimeout; external 'PI_GCS2_DLL.DLL';
function PI_SetDaisyChainScanMaxDeviceID; external 'PI_GCS2_DLL.DLL';
function PI_EnableReconnect; external 'PI_GCS2_DLL.DLL';
function PI_SetNrTimeoutsBeforeClose; external 'PI_GCS2_DLL.DLL';
function PI_GetInterfaceDescription; external 'PI_GCS2_DLL.DLL';
function PI_qERR; external 'PI_GCS2_DLL.DLL';
function PI_qIDN; external 'PI_GCS2_DLL.DLL';
function PI_INI; external 'PI_GCS2_DLL.DLL';
function PI_qHLP; external 'PI_GCS2_DLL.DLL';
function PI_qHPA; external 'PI_GCS2_DLL.DLL';
function PI_qHPV; external 'PI_GCS2_DLL.DLL';
function PI_qCSV; external 'PI_GCS2_DLL.DLL';
function PI_qOVF; external 'PI_GCS2_DLL.DLL';
function PI_RBT; external 'PI_GCS2_DLL.DLL';
function PI_REP; external 'PI_GCS2_DLL.DLL';
function PI_BDR; external 'PI_GCS2_DLL.DLL';
function PI_qBDR; external 'PI_GCS2_DLL.DLL';
function PI_DBR; external 'PI_GCS2_DLL.DLL';
function PI_qDBR; external 'PI_GCS2_DLL.DLL';
function PI_qVER; external 'PI_GCS2_DLL.DLL';
function PI_qSSN; external 'PI_GCS2_DLL.DLL';
function PI_CCT; external 'PI_GCS2_DLL.DLL';
function PI_qCCT; external 'PI_GCS2_DLL.DLL';
function PI_qTVI; external 'PI_GCS2_DLL.DLL';
function PI_IFC; external 'PI_GCS2_DLL.DLL';
function PI_qIFC; external 'PI_GCS2_DLL.DLL';
function PI_IFS; external 'PI_GCS2_DLL.DLL';
function PI_qIFS; external 'PI_GCS2_DLL.DLL';
function PI_qECO; external 'PI_GCS2_DLL.DLL';
function PI_MOV; external 'PI_GCS2_DLL.DLL';
function PI_qMOV; external 'PI_GCS2_DLL.DLL';
function PI_MVR; external 'PI_GCS2_DLL.DLL';
function PI_MVE; external 'PI_GCS2_DLL.DLL';
function PI_POS; external 'PI_GCS2_DLL.DLL';
function PI_qPOS; external 'PI_GCS2_DLL.DLL';
function PI_IsMoving; external 'PI_GCS2_DLL.DLL';
function PI_HLT; external 'PI_GCS2_DLL.DLL';
function PI_STP; external 'PI_GCS2_DLL.DLL';
function PI_StopAll; external 'PI_GCS2_DLL.DLL';
function PI_qONT; external 'PI_GCS2_DLL.DLL';
function PI_RTO; external 'PI_GCS2_DLL.DLL';
function PI_qRTO; external 'PI_GCS2_DLL.DLL';
function PI_ATZ; external 'PI_GCS2_DLL.DLL';
function PI_qATZ; external 'PI_GCS2_DLL.DLL';
function PI_AOS; external 'PI_GCS2_DLL.DLL';
function PI_qAOS; external 'PI_GCS2_DLL.DLL';
function PI_HasPosChanged; external 'PI_GCS2_DLL.DLL';
function PI_GetErrorStatus; external 'PI_GCS2_DLL.DLL';
function PI_SVA; external 'PI_GCS2_DLL.DLL';
function PI_qSVA; external 'PI_GCS2_DLL.DLL';
function PI_SVR; external 'PI_GCS2_DLL.DLL';
function PI_DFH; external 'PI_GCS2_DLL.DLL';
function PI_qDFH; external 'PI_GCS2_DLL.DLL';
function PI_GOH; external 'PI_GCS2_DLL.DLL';
function PI_qCST; external 'PI_GCS2_DLL.DLL';
function PI_CST; external 'PI_GCS2_DLL.DLL';
function PI_qVST; external 'PI_GCS2_DLL.DLL';
function PI_qPUN; external 'PI_GCS2_DLL.DLL';
function PI_SVO; external 'PI_GCS2_DLL.DLL';
function PI_qSVO; external 'PI_GCS2_DLL.DLL';
function PI_SMO; external 'PI_GCS2_DLL.DLL';
function PI_qSMO; external 'PI_GCS2_DLL.DLL';
function PI_DCO; external 'PI_GCS2_DLL.DLL';
function PI_qDCO; external 'PI_GCS2_DLL.DLL';
function PI_BRA; external 'PI_GCS2_DLL.DLL';
function PI_qBRA; external 'PI_GCS2_DLL.DLL';
function PI_RON; external 'PI_GCS2_DLL.DLL';
function PI_qRON; external 'PI_GCS2_DLL.DLL';
function PI_VEL; external 'PI_GCS2_DLL.DLL';
function PI_qVEL; external 'PI_GCS2_DLL.DLL';
function PI_JOG; external 'PI_GCS2_DLL.DLL';
function PI_qJOG; external 'PI_GCS2_DLL.DLL';
function PI_qTCV; external 'PI_GCS2_DLL.DLL';
function PI_VLS; external 'PI_GCS2_DLL.DLL';
function PI_qVLS; external 'PI_GCS2_DLL.DLL';
function PI_ACC; external 'PI_GCS2_DLL.DLL';
function PI_qACC; external 'PI_GCS2_DLL.DLL';
function PI_DEC; external 'PI_GCS2_DLL.DLL';
function PI_qDEC; external 'PI_GCS2_DLL.DLL';
function PI_VCO; external 'PI_GCS2_DLL.DLL';
function PI_qVCO; external 'PI_GCS2_DLL.DLL';
function PI_SPA; external 'PI_GCS2_DLL.DLL';
function PI_qSPA; external 'PI_GCS2_DLL.DLL';
function PI_SEP; external 'PI_GCS2_DLL.DLL';
function PI_qSEP; external 'PI_GCS2_DLL.DLL';
function PI_WPA; external 'PI_GCS2_DLL.DLL';
function PI_DPA; external 'PI_GCS2_DLL.DLL';
function PI_TIM; external 'PI_GCS2_DLL.DLL';
function PI_qTIM; external 'PI_GCS2_DLL.DLL';
function PI_RPA; external 'PI_GCS2_DLL.DLL';
function PI_SPA_String; external 'PI_GCS2_DLL.DLL';
function PI_qSPA_String; external 'PI_GCS2_DLL.DLL';
function PI_SEP_String; external 'PI_GCS2_DLL.DLL';
function PI_qSEP_String; external 'PI_GCS2_DLL.DLL';
function PI_SPA_int64; external 'PI_GCS2_DLL.DLL';
function PI_qSPA_int64; external 'PI_GCS2_DLL.DLL';
function PI_SEP_int64; external 'PI_GCS2_DLL.DLL';
function PI_qSEP_int64; external 'PI_GCS2_DLL.DLL';
function PI_STE; external 'PI_GCS2_DLL.DLL';
function PI_qSTE; external 'PI_GCS2_DLL.DLL';
function PI_IMP; external 'PI_GCS2_DLL.DLL';
function PI_IMP_PulseWidth; external 'PI_GCS2_DLL.DLL';
function PI_qIMP; external 'PI_GCS2_DLL.DLL';
function PI_SAI; external 'PI_GCS2_DLL.DLL';
function PI_qSAI; external 'PI_GCS2_DLL.DLL';
function PI_qSAI_ALL; external 'PI_GCS2_DLL.DLL';
function PI_CCL; external 'PI_GCS2_DLL.DLL';
function PI_qCCL; external 'PI_GCS2_DLL.DLL';
function PI_AVG; external 'PI_GCS2_DLL.DLL';
function PI_qAVG; external 'PI_GCS2_DLL.DLL';
function PI_qHAR; external 'PI_GCS2_DLL.DLL';
function PI_qLIM; external 'PI_GCS2_DLL.DLL';
function PI_qTRS; external 'PI_GCS2_DLL.DLL';
function PI_FNL; external 'PI_GCS2_DLL.DLL';
function PI_FPL; external 'PI_GCS2_DLL.DLL';
function PI_FRF; external 'PI_GCS2_DLL.DLL';
function PI_FED; external 'PI_GCS2_DLL.DLL';
function PI_qFRF; external 'PI_GCS2_DLL.DLL';
function PI_DIO; external 'PI_GCS2_DLL.DLL';
function PI_qDIO; external 'PI_GCS2_DLL.DLL';
function PI_qTIO; external 'PI_GCS2_DLL.DLL';
function PI_IsControllerReady; external 'PI_GCS2_DLL.DLL';
function PI_qSRG; external 'PI_GCS2_DLL.DLL';
function PI_ATC; external 'PI_GCS2_DLL.DLL';
function PI_qATC; external 'PI_GCS2_DLL.DLL';
function PI_qATS; external 'PI_GCS2_DLL.DLL';
function PI_SPI; external 'PI_GCS2_DLL.DLL';
function PI_qSPI; external 'PI_GCS2_DLL.DLL';
function PI_SCT; external 'PI_GCS2_DLL.DLL';
function PI_qSCT; external 'PI_GCS2_DLL.DLL';
function PI_SST; external 'PI_GCS2_DLL.DLL';
function PI_qSST; external 'PI_GCS2_DLL.DLL';
function PI_qCTV; external 'PI_GCS2_DLL.DLL';
function PI_CTV; external 'PI_GCS2_DLL.DLL';
function PI_CTR; external 'PI_GCS2_DLL.DLL';
function PI_qCAV; external 'PI_GCS2_DLL.DLL';
function PI_qCCV; external 'PI_GCS2_DLL.DLL';
function PI_qCMO; external 'PI_GCS2_DLL.DLL';
function PI_CMO; external 'PI_GCS2_DLL.DLL';
function PI_IsRunningMacro; external 'PI_GCS2_DLL.DLL';
function PI_MAC_BEG; external 'PI_GCS2_DLL.DLL';
function PI_MAC_START; external 'PI_GCS2_DLL.DLL';
function PI_MAC_NSTART; external 'PI_GCS2_DLL.DLL';
function PI_MAC_START_Args; external 'PI_GCS2_DLL.DLL';
function PI_MAC_NSTART_Args; external 'PI_GCS2_DLL.DLL';
function PI_MAC_END; external 'PI_GCS2_DLL.DLL';
function PI_MAC_DEL; external 'PI_GCS2_DLL.DLL';
function PI_MAC_DEF; external 'PI_GCS2_DLL.DLL';
function PI_MAC_qDEF; external 'PI_GCS2_DLL.DLL';
function PI_MAC_qERR; external 'PI_GCS2_DLL.DLL';
function PI_MAC_qFREE; external 'PI_GCS2_DLL.DLL';
function PI_qMAC; external 'PI_GCS2_DLL.DLL';
function PI_qRMC; external 'PI_GCS2_DLL.DLL';
function PI_DEL; external 'PI_GCS2_DLL.DLL';
function PI_WAC; external 'PI_GCS2_DLL.DLL';
function PI_MEX; external 'PI_GCS2_DLL.DLL';
function PI_VAR; external 'PI_GCS2_DLL.DLL';
function PI_qVAR; external 'PI_GCS2_DLL.DLL';
function PI_ADD; external 'PI_GCS2_DLL.DLL';
function PI_CPY; external 'PI_GCS2_DLL.DLL';
function PI_GcsCommandset; external 'PI_GCS2_DLL.DLL';
function PI_GcsGetAnswer; external 'PI_GCS2_DLL.DLL';
function PI_GcsGetAnswerSize; external 'PI_GCS2_DLL.DLL';
function PI_qTMN; external 'PI_GCS2_DLL.DLL';
function PI_qTMX; external 'PI_GCS2_DLL.DLL';
function PI_NLM; external 'PI_GCS2_DLL.DLL';
function PI_qNLM; external 'PI_GCS2_DLL.DLL';
function PI_PLM; external 'PI_GCS2_DLL.DLL';
function PI_qPLM; external 'PI_GCS2_DLL.DLL';
function PI_SSL; external 'PI_GCS2_DLL.DLL';
function PI_qSSL; external 'PI_GCS2_DLL.DLL';
function PI_qVMO; external 'PI_GCS2_DLL.DLL';
function PI_qCMN; external 'PI_GCS2_DLL.DLL';
function PI_qCMX; external 'PI_GCS2_DLL.DLL';
function PI_IsGeneratorRunning; external 'PI_GCS2_DLL.DLL';
function PI_qTWG; external 'PI_GCS2_DLL.DLL';
function PI_WAV_SIN_P; external 'PI_GCS2_DLL.DLL';
function PI_WAV_LIN; external 'PI_GCS2_DLL.DLL';
function PI_WAV_NOISE; external 'PI_GCS2_DLL.DLL';
function PI_WAV_RAMP; external 'PI_GCS2_DLL.DLL';
function PI_WAV_PNT; external 'PI_GCS2_DLL.DLL';
function PI_qWAV; external 'PI_GCS2_DLL.DLL';
function PI_WGO; external 'PI_GCS2_DLL.DLL';
function PI_qWGO; external 'PI_GCS2_DLL.DLL';
function PI_WGC; external 'PI_GCS2_DLL.DLL';
function PI_qWGC; external 'PI_GCS2_DLL.DLL';
function PI_qWGI; external 'PI_GCS2_DLL.DLL';
function PI_qWGN; external 'PI_GCS2_DLL.DLL';
function PI_WSL; external 'PI_GCS2_DLL.DLL';
function PI_qWSL; external 'PI_GCS2_DLL.DLL';
function PI_DTC; external 'PI_GCS2_DLL.DLL';
function PI_qDTL; external 'PI_GCS2_DLL.DLL';
function PI_WCL; external 'PI_GCS2_DLL.DLL';
function PI_qTLT; external 'PI_GCS2_DLL.DLL';
function PI_qGWD_SYNC; external 'PI_GCS2_DLL.DLL';
function PI_qGWD; external 'PI_GCS2_DLL.DLL';
function PI_WOS; external 'PI_GCS2_DLL.DLL';
function PI_qWOS; external 'PI_GCS2_DLL.DLL';
function PI_WTR; external 'PI_GCS2_DLL.DLL';
function PI_qWTR; external 'PI_GCS2_DLL.DLL';
function PI_DDL; external 'PI_GCS2_DLL.DLL';
function PI_qDDL_SYNC; external 'PI_GCS2_DLL.DLL';
function PI_qDDL; external 'PI_GCS2_DLL.DLL';
function PI_DPO; external 'PI_GCS2_DLL.DLL';
function PI_qWMS; external 'PI_GCS2_DLL.DLL';
function PI_TWC; external 'PI_GCS2_DLL.DLL';
function PI_TWS; external 'PI_GCS2_DLL.DLL';
function PI_qTWS; external 'PI_GCS2_DLL.DLL';
function PI_CTO; external 'PI_GCS2_DLL.DLL';
function PI_CTOString; external 'PI_GCS2_DLL.DLL';
function PI_qCTO; external 'PI_GCS2_DLL.DLL';
function PI_qCTOString; external 'PI_GCS2_DLL.DLL';
function PI_TRO; external 'PI_GCS2_DLL.DLL';
function PI_qTRO; external 'PI_GCS2_DLL.DLL';
function PI_TRI; external 'PI_GCS2_DLL.DLL';
function PI_qTRI; external 'PI_GCS2_DLL.DLL';
function PI_CTI; external 'PI_GCS2_DLL.DLL';
function PI_qCTI; external 'PI_GCS2_DLL.DLL';
function PI_qHDR; external 'PI_GCS2_DLL.DLL';
function PI_qTNR; external 'PI_GCS2_DLL.DLL';
function PI_DRC; external 'PI_GCS2_DLL.DLL';
function PI_qDRC; external 'PI_GCS2_DLL.DLL';
function PI_qDRR_SYNC; external 'PI_GCS2_DLL.DLL';
function PI_qDRR; external 'PI_GCS2_DLL.DLL';
function PI_DRT; external 'PI_GCS2_DLL.DLL';
function PI_qDRT; external 'PI_GCS2_DLL.DLL';
function PI_RTR; external 'PI_GCS2_DLL.DLL';
function PI_qRTR; external 'PI_GCS2_DLL.DLL';
function PI_WGR; external 'PI_GCS2_DLL.DLL';
function PI_qDRL; external 'PI_GCS2_DLL.DLL';
function PI_VMA; external 'PI_GCS2_DLL.DLL';
function PI_qVMA; external 'PI_GCS2_DLL.DLL';
function PI_VMI; external 'PI_GCS2_DLL.DLL';
function PI_qVMI; external 'PI_GCS2_DLL.DLL';
function PI_VOL; external 'PI_GCS2_DLL.DLL';
function PI_qVOL; external 'PI_GCS2_DLL.DLL';
function PI_qTPC; external 'PI_GCS2_DLL.DLL';
function PI_ONL; external 'PI_GCS2_DLL.DLL';
function PI_qONL; external 'PI_GCS2_DLL.DLL';
function PI_qTAD; external 'PI_GCS2_DLL.DLL';
function PI_qTNS; external 'PI_GCS2_DLL.DLL';
function PI_qTSP; external 'PI_GCS2_DLL.DLL';
function PI_SCN; external 'PI_GCS2_DLL.DLL';
function PI_qSCN; external 'PI_GCS2_DLL.DLL';
function PI_qTSC; external 'PI_GCS2_DLL.DLL';
function PI_APG; external 'PI_GCS2_DLL.DLL';
function PI_qAPG; external 'PI_GCS2_DLL.DLL';
function PI_OAC; external 'PI_GCS2_DLL.DLL';
function PI_qOAC; external 'PI_GCS2_DLL.DLL';
function PI_OAD; external 'PI_GCS2_DLL.DLL';
function PI_qOAD; external 'PI_GCS2_DLL.DLL';
function PI_ODC; external 'PI_GCS2_DLL.DLL';
function PI_qODC; external 'PI_GCS2_DLL.DLL';
function PI_OCD; external 'PI_GCS2_DLL.DLL';
function PI_qOCD; external 'PI_GCS2_DLL.DLL';
function PI_OSM; external 'PI_GCS2_DLL.DLL';
function PI_qOSM; external 'PI_GCS2_DLL.DLL';
function PI_OSMf; external 'PI_GCS2_DLL.DLL';
function PI_qOSMf; external 'PI_GCS2_DLL.DLL';
function PI_OVL; external 'PI_GCS2_DLL.DLL';
function PI_qOVL; external 'PI_GCS2_DLL.DLL';
function PI_qOSN; external 'PI_GCS2_DLL.DLL';
function PI_SSA; external 'PI_GCS2_DLL.DLL';
function PI_qSSA; external 'PI_GCS2_DLL.DLL';
function PI_RNP; external 'PI_GCS2_DLL.DLL';
function PI_PGS; external 'PI_GCS2_DLL.DLL';
function PI_qTAC; external 'PI_GCS2_DLL.DLL';
function PI_qTAV; external 'PI_GCS2_DLL.DLL';
function PI_OMA; external 'PI_GCS2_DLL.DLL';
function PI_qOMA; external 'PI_GCS2_DLL.DLL';
function PI_OMR; external 'PI_GCS2_DLL.DLL';
function PI_qJAS; external 'PI_GCS2_DLL.DLL';
function PI_JAX; external 'PI_GCS2_DLL.DLL';
function PI_qJAX; external 'PI_GCS2_DLL.DLL';
function PI_qJBS; external 'PI_GCS2_DLL.DLL';
function PI_JDT; external 'PI_GCS2_DLL.DLL';
function PI_JLT; external 'PI_GCS2_DLL.DLL';
function PI_qJLT; external 'PI_GCS2_DLL.DLL';
function PI_JON; external 'PI_GCS2_DLL.DLL';
function PI_qJON; external 'PI_GCS2_DLL.DLL';
function PI_AAP; external 'PI_GCS2_DLL.DLL';
function PI_FIO; external 'PI_GCS2_DLL.DLL';
function PI_FLM; external 'PI_GCS2_DLL.DLL';
function PI_FLS; external 'PI_GCS2_DLL.DLL';
function PI_FSA; external 'PI_GCS2_DLL.DLL';
function PI_FSC; external 'PI_GCS2_DLL.DLL';
function PI_FSM; external 'PI_GCS2_DLL.DLL';
function PI_qFSS; external 'PI_GCS2_DLL.DLL';
function PI_SGA; external 'PI_GCS2_DLL.DLL';
function PI_qSGA; external 'PI_GCS2_DLL.DLL';
function PI_NAV; external 'PI_GCS2_DLL.DLL';
function PI_qNAV; external 'PI_GCS2_DLL.DLL';
function PI_GetDynamicMoveBufferSize; external 'PI_GCS2_DLL.DLL';
function PI_qCOV; external 'PI_GCS2_DLL.DLL';
function PI_MOD; external 'PI_GCS2_DLL.DLL';
function PI_qMOD; external 'PI_GCS2_DLL.DLL';
function PI_qDIA; external 'PI_GCS2_DLL.DLL';
function PI_qHDI; external 'PI_GCS2_DLL.DLL';
function PI_qHIS; external 'PI_GCS2_DLL.DLL';
function PI_HIS; external 'PI_GCS2_DLL.DLL';
function PI_qHIE; external 'PI_GCS2_DLL.DLL';
function PI_qHIB; external 'PI_GCS2_DLL.DLL';
function PI_HIL; external 'PI_GCS2_DLL.DLL';
function PI_qHIL; external 'PI_GCS2_DLL.DLL';
function PI_HIN; external 'PI_GCS2_DLL.DLL';
function PI_qHIN; external 'PI_GCS2_DLL.DLL';
function PI_HIA; external 'PI_GCS2_DLL.DLL';
function PI_qHIA; external 'PI_GCS2_DLL.DLL';
function PI_HDT; external 'PI_GCS2_DLL.DLL';
function PI_qHDT; external 'PI_GCS2_DLL.DLL';
function PI_HIT; external 'PI_GCS2_DLL.DLL';
function PI_qHIT; external 'PI_GCS2_DLL.DLL';
function PI_qMAN; external 'PI_GCS2_DLL.DLL';
function PI_KSF; external 'PI_GCS2_DLL.DLL';
function PI_KEN; external 'PI_GCS2_DLL.DLL';
function PI_KRM; external 'PI_GCS2_DLL.DLL';
function PI_KLF; external 'PI_GCS2_DLL.DLL';
function PI_KSD; external 'PI_GCS2_DLL.DLL';
function PI_KST; external 'PI_GCS2_DLL.DLL';
function PI_KSW; external 'PI_GCS2_DLL.DLL';
function PI_KLD; external 'PI_GCS2_DLL.DLL';
function PI_KSB; external 'PI_GCS2_DLL.DLL';
function PI_MRT; external 'PI_GCS2_DLL.DLL';
function PI_MRW; external 'PI_GCS2_DLL.DLL';
function PI_qKLT; external 'PI_GCS2_DLL.DLL';
function PI_qKEN; external 'PI_GCS2_DLL.DLL';
function PI_qKET; external 'PI_GCS2_DLL.DLL';
function PI_qKLS; external 'PI_GCS2_DLL.DLL';
function PI_KLN; external 'PI_GCS2_DLL.DLL';
function PI_qKLN; external 'PI_GCS2_DLL.DLL';
function PI_qTRA; external 'PI_GCS2_DLL.DLL';
function PI_qKLC; external 'PI_GCS2_DLL.DLL';
function PI_KCP; external 'PI_GCS2_DLL.DLL';
function PI_GetSupportedParameters; external 'PI_GCS2_DLL.DLL';
function PI_GetSupportedControllers; external 'PI_GCS2_DLL.DLL';
function PI_GetAsyncBufferIndex; external 'PI_GCS2_DLL.DLL';
function PI_GetAsyncBuffer; external 'PI_GCS2_DLL.DLL';
function PI_AddStage; external 'PI_GCS2_DLL.DLL';
function PI_RemoveStage; external 'PI_GCS2_DLL.DLL';
function PI_OpenUserStagesEditDialog; external 'PI_GCS2_DLL.DLL';
function PI_OpenPiStagesEditDialog; external 'PI_GCS2_DLL.DLL';
function PI_DisableSingleStagesDatFiles; external 'PI_GCS2_DLL.DLL';
function PI_DisableUserStagesDatFiles; external 'PI_GCS2_DLL.DLL';

end.
