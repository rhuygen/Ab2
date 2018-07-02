'''connects PI controller, references the axes and makes some demo motions'''

import pyPICommands
reload(pyPICommands)

from random import random
from time import sleep


CONNECTED_AXES = ['1']


def init_axes(cmds):
    '''references the axes'''
    ref_ok = cmds.qFRF(' '.join(CONNECTED_AXES))
    for axis_to_ref in CONNECTED_AXES:
        cmds.SVO({axis_to_ref:1})        # switch on servo
        if ref_ok[axis_to_ref] != 1:
            print 'referencing axis ' + axis_to_ref
            cmds.FNL(axis_to_ref)

    axes_are_referencing = True
    while axes_are_referencing:
        sleep(0.1)
        ref = cmds.IsMoving(' '.join(CONNECTED_AXES))
        axes_are_referencing = sum(ref.values()) > 0

    
if __name__ == "__main__":
    CMDS = pyPICommands.pyPICommands('PI_GCS2_DLL', 'PI_')
    RS232_COMPORT = 1
    RS232_BAUDRATE = 115200
    try:
        if not CMDS.ConnectRS232(RS232_COMPORT, RS232_BAUDRATE):
            print 'Cannot connect to COM %d, %d Baud' % \
                (RS232_COMPORT, RS232_BAUDRATE)
            exit()
        print "Connected to " + CMDS.qIDN()
        
        init_axes(CMDS)

        MIN_TRAVEL = CMDS.qTMN(' '.join(CONNECTED_AXES))
        MAX_TRAVEL = CMDS.qTMX(' '.join(CONNECTED_AXES))

        NUM_STEPS = 10        
        for i in range(NUM_STEPS):
            targets = {}
            print "step %d/%d - moving to\t" % (i + 1, NUM_STEPS),
            for axis_to_move in CONNECTED_AXES:
                targets[axis_to_move] = (random() \
                    * (MAX_TRAVEL[axis_to_move] - MIN_TRAVEL[axis_to_move])) \
                    + MIN_TRAVEL[axis_to_move]
                print '%s: %.2f\t' % (axis_to_move, targets[axis_to_move]),
            print
            CMDS.MOV(targets)
            axes_are_moving = True
            while axes_are_moving:
                sleep(0.1)
                moving = CMDS.IsMoving(' '.join(CONNECTED_AXES))
                axes_are_moving = sum(moving.values()) > 0

        CMDS.CloseConnection()
        
    except Exception as exc:
        ERR_NUM = CMDS.GetError()
        print 'GCS ERROR %d: %s' % (ERR_NUM, CMDS.TranslateError(ERR_NUM))
        CMDS.CloseConnection()
        raise exc    