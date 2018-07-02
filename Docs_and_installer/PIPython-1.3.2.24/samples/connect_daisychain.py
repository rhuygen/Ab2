#!/usr/bin python
# -*- coding: utf-8 -*-
"""This example shows how to connect three controllers on a daisy chain."""

from pipython import GCSDevice


# C-863 controller with device ID 3, this is the master device
# E-861 controller with device ID 7
# C-867 controller with device ID 1

def main():
    """Connect three controllers on a daisy chain."""
    with GCSDevice('E-861','C:\Users\Felipe\Dropbox\Coisas da bolsa\Drivers\MATLAB\MATLAB_directDllCall\PI_GCS2_DLL_x64.dll') as E861:
        E861.OpenRS232DaisyChain(comport=3, baudrate=9600)
        # c863.OpenUSBDaisyChain(description='1234567890')
        # c863.OpenTCPIPDaisyChain(ipaddress='192.168.178.42')
        daisychainid = E861.dcid
        E861.ConnectDaisyChainDevice(1, daisychainid)
        with GCSDevice('E-861', 'C:\Users\Felipe\Dropbox\Coisas da bolsa\Drivers\MATLAB\MATLAB_directDllCall\PI_GCS2_DLL_x64.dll') as e861:
            e861.ConnectDaisyChainDevice(2, daisychainid)
            print('\n{}:\n{}'.format(E861.GetInterfaceDescription(), E861.qIDN()))
            print('\n{}:\n{}'.format(e861.GetInterfaceDescription(), e861.qIDN()))
            
            E861.MOV(1,0.5)

if __name__ == '__main__':
    # import logging
    # logging.basicConfig(level=logging.DEBUG)
    main()
