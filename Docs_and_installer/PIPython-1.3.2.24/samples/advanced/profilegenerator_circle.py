#!/usr/bin python
# -*- coding: utf-8 -*-
"""This example shows how to realize a cyclic circular motion with the profile generator."""

from math import cos, sin, pi

from pipython import GCSDevice, pitools
from pipython.datarectools import getservotime

CONTROLLERNAME = 'C-884.DB'  # 'C-884' will also work
STAGES = ('M-111.1DG', 'M-111.1DG', 'NOSTAGE', 'NOSTAGE')  # connect stages to axes
REFMODE = ('FNL', 'FNL')  # reference the connected stages

PERIOD = 5.0  # duration of one sine period in seconds as float
NUMPOINTS = 100  # number of points for one period as integer
STARTPOS = (1.0, 1.0)  # start position of the circular motion as float for both axes
AMPLITUDE = (1.0, 1.0)  # amplitude (i.e. diameter) of the circular motion as float for both axes
NUMCYLES = 10  # number of cycles of sine periods
BUFFERSIZE = 10  # minimum number of points in buffer until motion is started


def main():
    """Connect controller, setup stages and start profile generator."""
    with GCSDevice(CONTROLLERNAME) as pidevice:
        pidevice.InterfaceSetupDlg(key='sample')
        print('connected: {}'.format(pidevice.qIDN().strip()))
        print('initialize connected stages...')
        pitools.startup(pidevice, stages=STAGES, refmode=REFMODE)
        runprofile(pidevice)


def runprofile(pidevice):
    """Configure two trajectories, move to start position and start and feed the profile generators.
    @type pidevice : pipython.gcscommands.GCSCommands
    """
    assert 2 == len(pidevice.axes[:2]), 'this sample requires two connected axes'
    trajectories = (1, 2)
    xvals = [2 * pi * float(i) / float(NUMPOINTS) for i in range(NUMPOINTS)]
    xtrajectory = [STARTPOS[0] + AMPLITUDE[0] / 2.0 * sin(xval) for xval in xvals]
    ytrajectory = [STARTPOS[0] + AMPLITUDE[0] / 2.0 * cos(xval) for xval in xvals]
    print('move axes {} to their start positions {}'.format(pidevice.axes[:2], (xtrajectory[0], ytrajectory[0])))
    pidevice.MOV(pidevice.axes[:2], (xtrajectory[0], ytrajectory[0]))
    pitools.waitontarget(pidevice, pidevice.axes[:2])
    servotime = getservotime(pidevice)
    tgtvalue = int(float(PERIOD) / float(NUMPOINTS) / servotime)
    print('set %d servo cycles per point -> period of %.2f seconds' % (tgtvalue, tgtvalue * servotime * NUMPOINTS))
    pidevice.TGT(tgtvalue)
    print('clear existing trajectories')
    pidevice.TGC(trajectories)
    for cyclenum in range(1, NUMCYLES + 1):
        pointnum = 0
        print('\r%s' % (' ' * 40)),
        while pointnum < NUMPOINTS:
            if pidevice.qTGL(1)[1] < BUFFERSIZE:
                pidevice.TGA(trajectories, (xtrajectory[pointnum], ytrajectory[pointnum]))
                pointnum += 1
                print('\rappend cycle {}/{}, point {}/{}'.format(cyclenum, NUMCYLES, pointnum, NUMPOINTS)),
            if BUFFERSIZE == NUMPOINTS * (cyclenum - 1) + pointnum:
                print('\nstarting trajectories')
                pidevice.TGS(trajectories)
            if NUMCYLES == cyclenum and NUMPOINTS == pointnum:
                print('\nfinishing trajectories')
                pidevice.TGF(trajectories)
    pitools.waitontrajectory(pidevice, trajectories)
    print('done')


if __name__ == '__main__':
    # import logging
    # logging.basicConfig(level=logging.DEBUG)
    main()
