# -*- coding: utf-8 -*-
# ------------------------------------------------------------------------------

# GUI for ablation proceeding - Mackenzie University - MackGraphe - April 2017

# Felipe Bueno Hernandez - bueno_hernandez@hotmail.com

# ------------------------------------------------------------------------------

# Libraries

#The TKinter library varies from one version to another
from Local import returnPath
try:
    # for Python2
    from Tkinter import *   ## notice capitalized T in Tkinter 
    import tkMessageBox
    import tkFont  # Library to work with different fonts

except ImportError:
    # for Python3
    from tkinter import *   ## notice lowercase 't' in tkinter here
    import tkinter.messagebox
    from tkinter import font as tkFont
  
#The TKinter library varies from one version to another

import os  # Directory library

returnPath()

file = open('path.txt', 'r')

file_path = file.read()

file.close()

current_directory = file_path

os.chdir(file_path+'/Files')

import subprocess

try:

	from PIL import Image, ImageTk  # Image library
	
except ImportError:
		
	subprocess.call('pip install pillow')
	
	from PIL import Image, ImageTk  # Image library	

try:
	
	import numpy as np  # Array library

except ImportError:

	subprocess.call('pip install numpy')
	
	import numpy as np  # Array library

import copy  # Copy library

import winsound  # Sound play library

from threading import Thread  # Thread library, to prevent the sotware from "freezing" while running
  
from time import sleep  # Library to work with delay



module_not_installed = False

try:
    # It tries to import, otherwise installs it
    from pipython import GCSDevice, pitools  # PI Micro library
    
except ImportError:
    # Warning 
    subprocess.call("installation_error_correction.bat", shell = True)
    module_not_installed = True
    
import datetime

#sys.tracebacklimit = 0  # Hides the traceback (Error log)

# Libraries
# -------------------------------------------------------------------------------
# Window configurations
master = Tk()  # Necessary to create the main window
master.title("Graphene Ablation - Mackgraphe")  # Name of the window
# master.geometry("700x380") #Size of the window
master.minsize(700, 380)  # Minimum size of the window
master.maxsize(700, 380)  # Maximum size of the window
master.iconbitmap(r'favicon.ico')  # Window icon

# Window configurations
# -------------------------------------------------------------------------------
# Labels, positions and sizes

Label(master, text="Path:").place(x=35, y=48)
Label(master, text="Delay:").place(x=35, y=98)
Label(master, text="Spot:").place(x=35, y=148)
Label(master, text="s").place(x=170, y=98)
Label(master, text="mm").place(x=170, y=148)
Label(master, text="Ablation velocity:").place(x=240, y=98)
Label(master, text="Transition velocity:").place(x=240, y=148)
Label(master, text="mm/s").place(x=450, y=98)
Label(master, text="mm/s").place(x=450, y=148)
Label(master, text="Reference position:").place(x=251, y=200)
Label(master, text="Current position:").place(x=255, y=270)
# Labels, positions and sizes
# -------------------------------------------------------------------------------
# Images

mack = Image.open("mack.png")  # Mackenzie logo
photo_mack = ImageTk.PhotoImage(mack)
label = Label(image=photo_mack)
label.image = photo_mack
label.place(x=525, y=200)  # Logo position

m135 = Image.open("button_background.png")  # Grey square behind directional buttons
photo = ImageTk.PhotoImage(m135)
label = Label(image=photo)
label.image = photo
label.place(x=35, y=200)  # Grey square area position

# Images
# -------------------------------------------------------------------------------
# Font

helv36 = tkFont.Font(family='Helvetica', size=9, weight='bold')  # Font configuration

# Font
# -------------------------------------------------------------------------------
# Current position indicator

current_position_x_indicator = StringVar()  # Initializes a variable string in current_position_x_indicator
current_position_x_indicator.set('{:.5f}'.format(0.0))  # Format as 5 decimal places
labelx = Label(master, textvariable=current_position_x_indicator, font=helv36).place(x=247,
                                                                                     y=305)  # Position and font configuration

current_position_y_indicator = StringVar()  # Initializes a variable string in current_position_y_indicator
current_position_y_indicator.set('{:.5f}'.format(0.0))  # Format as 5 decimal places
labely = Label(master, textvariable=current_position_y_indicator, font=helv36).place(x=312,
                                                                                     y=305)  # Position and font configuration

# Current position indicator
# -------------------------------------------------------------------------------
# Global variables declarations

range = float(13) #Total movimentation range of the stages (6.5mm for each side, 13mm total)

path = ""  # Initializes as blank

def setPath(string):  # Path/directory variable
    global path
    path = string


canceled = False  # Initializes as false


def ablationCanceled(boolean):  # Flag indicating if the main routine was canceled
    global canceled
    canceled = boolean


able_to_close_window = True  # Initializes as true


def ableToCloseWindow(boolean):  # Flag indicating if it is possible to close window (when pressing cancel button)
    global able_to_close_window
    able_to_close_window = boolean


running = False  # Initializes as false


def isRunning(
        boolean):  # Lock to prevent from running more than one thread per time and to use the buttons (except cancel)
    global running
    running = boolean


global_position_x = 0  # Initializes global initial position x as 0


def globalPositionX(value):  # Global position x
    global global_position_x
    global_position_x = value


global_position_y = 0  # Initializes global initial position y as 0


def globalPositionY(value):  # Global position y
    global global_position_y
    global_position_y = value


connected = False  # Initializes as false


def isConnected(boolean):  # Flag indicating if the controllers are already connected
    global connected
    connected = boolean


connecting = False  # Initializes as false


def isConnecting(boolean):  # Flag indicating if the controlleres are being connected
    global connecting
    connecting = boolean


laser_on = False  # Initializes as false


def isLaserOn(boolean):  # Flag indicating if the laser is on (the shutter is activated)
    global laser_on
    laser_on = boolean


reference_x = 0.0  # Initializes reference x value as 0


def referenceX(value):  # Reference x (to dislocate the origin 0,0)
    global reference_x
    reference_x = value


reference_y = 0.0  # Initializes reference y value as 0


def referenceY(value):  # Reference y (to dislocate the origin 0,0)
    global reference_y
    reference_y = value


global MOVING  # String to test if axes are moving
MOVING = "OrderedDict([(u'1', True)])"


already_warned = False

def warned(status):
    global already_warned
    already_warned = status
    
    
on_start = ''

def OnStart(status):
    global on_start
    on_start = status
    
# Global variables declarations
# -------------------------------------------------------------------------------
# Text entries

f = open(file_path+'\configuration_values.txt','r')
file = f.read().split('\n')

file_path_txt = file_delay = file[6].split('=')[1]

setPath(file_path_txt)

path_var = StringVar()
path_var.set(file_path_txt)  # Delay default value
path_entry = Entry(master, width=67, textvariable=path_var)  # Text entry for path directory
path_entry.place(x=85, y=50)


file_delay = file[0].split('=')[1]

delay_var = StringVar()
delay_var.set(file_delay)  # Delay default value
delay_entry = Entry(master, width=10, textvariable=delay_var)  # Text entry for delay default value
delay_entry.place(x=85, y=100)


file_spotsize = file[2].split('=')[1]
  
spotsize_var = StringVar()
spotsize_var.set(file_spotsize)  # Spotsize default value
spotsize_entry = Entry(master, width=10, textvariable=spotsize_var)  # Text entry for spotsize default value
spotsize_entry.place(x=85, y=150)


file_ablation_velocity = file[1].split('=')[1]

ablation_velocity_var = StringVar()
ablation_velocity_var.set(file_ablation_velocity)  # Ablation velocity default value
ablation_velocity_entry = Entry(master, width=10,
                                textvariable=ablation_velocity_var)  # Text entry for ablation velocity
ablation_velocity_entry.place(x=365, y=100)


file_transition_velocity = file[3].split('=')[1]

transition_velocity_var = StringVar()
transition_velocity_var.set(file_transition_velocity)  # Transition velocity default value
transition_velocity_entry = Entry(master, width=10,
                                  textvariable=transition_velocity_var)  # Text entry for transition velocity
transition_velocity_entry.place(x=365, y=150)


file_referencex = file[4].split('=')[1]

set_reference_var_x = StringVar()
set_reference_var_x.set('{:.5f}'.format(float(file_referencex)))
set_reference_entry_x = Entry(master, width=7,
                              textvariable=set_reference_var_x)  # Text entry for setting the manualy the reference on axis X
set_reference_entry_x.place(x=250, y=235)


file_referencey = file[5].split('=')[1]

set_reference_var_y = StringVar()
set_reference_var_y.set('{:.5f}'.format(float(file_referencey)))
set_reference_entry_y = Entry(master, width=7,
                              textvariable=set_reference_var_y)  # Text entry for setting the manualy the reference on axis Y
set_reference_entry_y.place(x=315, y=235)

f.close()

# Text entries
# -------------------------------------------------------------------------------
# Functions


def saveValuesOnFile():
	file_delay = float(delay_entry.get())
	file_ablation_velocity = float(ablation_velocity_entry.get())
	file_spotsize = float(spotsize_entry.get())
	file_transition_velocity = float(transition_velocity_entry.get())
	file = open(file_path+'\configuration_values.txt','w')
	file.write('delay='+str(file_delay)+'\n')
	file.write('ablation_velocity='+str(file_ablation_velocity)+'\n')
	file.write('spotsize='+str(file_spotsize)+'\n')
	file.write('transition_velocity='+str(file_transition_velocity)+'\n')
	file.write('referencex='+str(reference_x)+'\n')
	file.write('referencey='+str(reference_y)+'\n')   
	file.write('filepath='+str(path)+'\n')  
	file.close()

def activateLaser():
    AXIS_X.DIO(2, 1)  # Activates the OUTPUT 2


def deactivateLaser():
    AXIS_X.DIO(2, 0)  # Deactivates the OUTPUT 2


def activateShutter():
    AXIS_X.DIO(1, 1)  # Activates the OUTPUT 1


def deactivateShutter():
    AXIS_X.DIO(1, 0)  # Deactivates the OUTPUT 1


def setVelocity():  # Changes the current velocity depending on the flag laser_on ("if on" usually slower than "if off")
    if laser_on:

        vel1 = float(ablation_velocity_entry.get())  # Gets the value from text box entry
        AXIS_X.VEL(1, vel1)  # Sets the velocity in x (Only sets the velocity)
        AXIS_Y.VEL(1, vel1)  # Sets the velocity in y (Only sets the velocity)

    else:

        vel2 = float(transition_velocity_entry.get())  # Gets the value from text box entry
        AXIS_X.VEL(1, vel2)  # Sets the velocity in x (Only sets the velocity)
        AXIS_Y.VEL(1, vel2)  # Sets the velocity in y (Only sets the velocity)


def goToZero():  # Function go to zero and deactivate laser/shutter


    if connected and not running:  # Only works when controllers are connected and the main thread is not running

        globalPositionX(0.0)  # Sets global position x to zero
        globalPositionY(0.0)  # Sets global position y to zero

        vel2 = float(transition_velocity_entry.get())  # Gets the value from text box entry
        AXIS_X.VEL(1, vel2)  # Sets the velocity in x (Only sets the velocity)
        AXIS_Y.VEL(1, vel2)  # Sets the velocity in y (Only sets the velocity)

        if laser_on:  # If laser is on change print Laser OFF
            cls = os.system('cls')
            print ("Laser OFF")
            isLaserOn(False)  # Sets the flag to false

        deactivateShutter()
        deactivateLaser()

        AXIS_X.MOV(1,
                   0 + reference_x)  # Moves the stage to (0 + reference value x). MOV command is absolute, MVR is in relation to the current position

        AXIS_Y.MOV(1,
                   0 + reference_y)  # Moves the stage to (0 + reference value y). MOV command is absolute, MVR is in relation to the current position

        button_on["text"] = "ON"  # Changes the status indicated on the button

        while (str(AXIS_Y.IsMoving()) == MOVING or str(AXIS_X.IsMoving()) == MOVING):  # Wait while axes are moving
            pass  # Does nothing

        current_position_x_indicator.set(
            '{:.5f}'.format(0.0))  # Sets the current position value on current position x indicator
        current_position_y_indicator.set(
            '{:.5f}'.format(0.0))  # Set the current position value on current position y indicator
 
            
def ablation():

    if not running:  # Prevents from running the thread more than once and from executing the functions from other buttons (besides cancel)
    
        if not connected:
            OnStart('ABLATION')
            
        ablationCanceled(False)  # Makes sure that the flag is off
        ableToCloseWindow(False)  # Sets the flag to false and forbids closing the window
        t1 = Thread(target=run)  # Create a thread
        t1.start()  # Run the thread           
            
def onOff():
        
    if not running:

        if not connected:
            connect()  # Connects the controllers and referentiates the axes
            OnStart('LASER')
        
        if not laser_on and connected:
            
            cls = os.system('cls')
            print ("Laser ON")
            activateShutter()
            activateLaser()
            isLaserOn(True)  # Sets the flag to true
            button_on["text"] = "OFF"  # Changes the status indicated on the button


        elif laser_on and connected:
            
            cls = os.system('cls')
            print ("Laser OFF")
            deactivateShutter()
            deactivateLaser()
            isLaserOn(False)  # Sets the flag to false
            button_on["text"] = "ON"  # Changes the status indicated on the button


def connect_thread():
    
    if not connected:
        if not connecting:  # Lock to prevent from running twice

            isConnecting(True)  # Sets the flag connecting to true
            
            cls = os.system('cls')            
            
            print ("Connecting controllers...")
            sleep(2)
            global AXIS_X  # Global variable has to be initiated to be used by all functions
    
            com_port = -1
            
            while com_port < 10 and not connected:
                com_port += 1
                try:
                    #print "Trying to connect to COM/USB port number {}".format(com_port)
                    # ----------------------------------------------------------------------------------------------------------
                    # Connection routine
    
                    driver_directory = current_directory+'\Driver\PI_GCS2_DLL_x64.dll'
                    
                    AXIS_X = GCSDevice('E-861',driver_directory) #Diretório dos drivers
                    AXIS_X.OpenRS232DaisyChain(comport=com_port, baudrate=9600)
                        # c863.OpenUSBDaisyChain(description='1234567890')
                        # c863.OpenTCPIPDaisyChain(ipaddress='192.168.178.42')
                    daisychainid = AXIS_X.dcid
                        
                    AXIS_X.ConnectDaisyChainDevice(1, daisychainid)
                    global AXIS_Y
                    AXIS_Y = GCSDevice('E-861', driver_directory) #Diretório dos drivers
                    AXIS_Y.ConnectDaisyChainDevice(2, daisychainid)
                    #print('\n{}:\n{}'.format(AXIS_X.GetInterfaceDescription(), AXIS_X.qIDN()))
                    #print('\n{}:\n{}'.format(AXIS_Y.GetInterfaceDescription(), AXIS_Y.qIDN()))
    
                    # Connection routine
                    # ----------------------------------------------------------------------------------------------------------
                    # Referecing
    
                    pidevice1 = AXIS_X
                    pidevice2 = AXIS_Y
    
                    REFMODE = ('FRF',)  # FRF - Type of referencing
                    print ("Referencing axis 1 (X)...")
    
                    pitools.startup(pidevice1, refmode=REFMODE)  # Command to referentiate
                    print ("Referencing axis 2 (Y)...")
                    pitools.startup(pidevice2, refmode=REFMODE)  # Command to referentiate
                    print ("Controllers connected!")
    
                    while (str(AXIS_Y.IsMoving()) == MOVING or str(AXIS_X.IsMoving()) == MOVING):  # While axes are moving
                        pass  # Do nothing
    
                    isConnected(True)  # Sets the flag to true
                    goToZero()  # Function go to zero and deactivate laser/shutter
                    
                
    
                    # Referecing
                    # ----------------------------------------------------------------------------------------------------------
                    # Referencing error, controller not connected
    
                except Exception:  # If does not identify controllers
                    
                    
                    
                    if com_port == 10:
                        
                        
                        cls = os.system('cls')
                        
                        print ("ERROR 1: The controllers could not be recognized, please check if the controllers and USB cable are properly connected!")
        				
                        ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)
                        isConnected(False)  # Sets the flag to false
                        ableToCloseWindow(True)
                        isConnecting(False)  # Sets the flag to false
                
                        winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
      		
        
                        # Referencing error, controller not connected
                        # ----------------------------------------------------------------------------------------------------------

            isConnecting(False)  # Sets the flag to false
            if connected:
                if on_start == 'LASER':
                    onOff()
                elif on_start == 'ABLATION':
                    ablation()
                elif on_start == 'CANCEL':
                    print ("CANCELED!")
                                       
                OnStart('')
    
    
def connect():  # Connects the controllers and referentiates the axes

        if not running:  # Prevents from running the thread more than once and from executing the functions from other buttons (besides cancel)

            if not connected:
                
                if not connecting:  # Lock to prevent from running twice
                    
                            
                    t2 = Thread(target=connect_thread)  # Create a thread
                    t2.start()  # Run the thread
        

def browse_file():  # Function to get file path

    if not running and not connecting:

        from tkFileDialog import askopenfilename  # Library to use browse (open files manually)

        content = askopenfilename()  # Gets the path as string

        if not (content == ""):  # If the path gotten is not empty
            
            cls = os.system('cls')
            print ("Chosen file: {}".format(content))

            path_entry.delete('0', END)  # Erases the previous path on the text box
            path_entry.insert('0', content)  # Inserts the current path on the text box

            setPath(content)  # Sets the current path to the global variable
            
button1 = Button(master, text="Browse", command=browse_file, height=1,
                 width=8)  # Button configurations (button function above)
button1.place(x=425 + 100, y=45)  # Button placed on x,y coordinates on window


def run():  # Main thread (routine)


    if not connected:
        connect()  # Connects the controllers and referentiates the axes
   
    if connected:

        if path == "":  # If the path is empty does not run the thread
            cls = os.system('cls')
            print ("ERROR 2: No file chosen!")
            winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
            ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)
            ableToCloseWindow(True)
            isRunning(False)

        else:
            isRunning(True)  # Sets to true the flag to prevent from running the thread twice
            
            cls = os.system('cls')
            
            print ("Initializing:")
            
            if on_start == 'CANCEL':
                
                ablationCanceled(True)
               
                OnStart('')
            
            start_time = datetime.datetime.now().replace(microsecond=0)

            # MOVIMENTATION AND DIRECTION CONSTANTS
            RIGHT = 1;
            DIAG_DOWN_RIGHT = 2;
            DOWN = 3;
            DIAG_LEFT_DOWN = 4;
            LEFT = 5;
            DIAG_LEFT_UP = 6;
            UP = 7;
            DIAG_UP_RIGHT = 8;
            LASER_OFF_CONST = 0;
            MOVE_NEXT_POINT = 50;
            LASER_ON_CONST = 100;
            EMPTY_ELEMENT = 1000000

            # MOVIMENTATION AND DIRECTION CONSTANTS

            imagem = Image.open(path)  # Opens the image file that is was provided
            imagem_swap = imagem.convert('L')  # Converts to shades of grey
            imagem_swap = imagem_swap.point(lambda x: 0 if x < 128 else 255,
                                            '1')  # Filters in 128 to black and white array

            pixels = list(imagem_swap.getdata())  # Puts the pixels in a list
            width, height = imagem_swap.size  # Gets the height and width of the image

            step = float(spotsize_entry.get())  # Gets the spot size to calculates the final image size
            size_x = width * step
            size_y = height * step
            print ("%fmm by %fmm (13mm by 13mm max)." % (size_x, size_y))
            sleep(2)

            if (
                    size_x > range or size_y > range):  # Gives an error if image dimensions are greater than 13 mm for one of the sides
                cls = os.system('cls')
                print ("ERROR 3: Image size is greater than allowed, try reducing the spot size if possible!")
                winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
                ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)
            elif (size_x / 2 + abs(reference_x) > range/2 or size_y / 2 + abs(
                    reference_y) > range/2):  # Gives an error if the image with the dislocated origin has coordinates out of reach
                cls = os.system('cls')
                print ("ERROR 4: (Image size + reference) is greater than allowed, try reducing the spot size if possible!")
                winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
                ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)

            imagem_swap = [pixels[i * width:(i + 1) * width] for i in
                           xrange(height)]  # Recreates the image with height and width obtained

            horizontal_size = width + 2;  # Size in x to create a with frame (to prevent the image from touching the edges)
            vertical_size = height;  # Size in y to create a with frame (to prevent the image from touching the edges)

            ones = np.ones((vertical_size, 1)) * 255  # Creates a white line standing
            ones2 = np.ones((1, horizontal_size)) * 255  # Creates a white line lying
            imagem_swap = np.concatenate((ones, imagem_swap, ones),
                                         1)  # Concatenates two lines on the sides with the image in the middle
            imagem_swap = np.concatenate((ones2, imagem_swap, ones2),
                                         0)  # Concatenates two lines on top and botton with the image in the middle
            imagem = imagem_swap  # Copies the image

            dimensions = imagem.shape  # Puts the dimensions on a variable
            rows = imagem_swap.shape[0]  # Gets the number of lines
            columns = imagem_swap.shape[1]  # Gets the number of columns

            total_number_of_black_pixels = len(np.where(imagem_swap == 0)[
                                                   0])  # Gets the number of black pixels (important for the thread to know where to pass by with the laser)
            if total_number_of_black_pixels == 0:
                cls = os.system('cls')
                print ("ERROR 6: The image file contains no pixels or is too bright and the pixels were lost in the black and white conversion, feel free to adjust at 'imagem_swap = imagem_swap.point(lambda x: 0 if x < 128 else 255,'1')' (current threshold: 128)!")
                winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
                ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)

            ablated_pixels = 0  # Initializes the counting as 0

            row = 0  # Initializes row as 0 (row is different from the total number of rows)
            column = 0  # Initializes column as 0 (column is different from the total number of columns)

            row_scan = 0  # Row where to initialize the scan for pixels
            column_scan = 0  # Column where to initialize the scan for pixels

            position_to_start_ablation = [0,
                                          0]  # Initialization as a list. Everytime there is a jump from one point to another the coordinates will be put here

            broke = 0  # Flag to break the pixel scanning

            while (
                        row < rows and broke == 0 and not canceled):  # loop inside a loop does the scan from left to right, from above to below, everytime the column ends it jumps to the next line
                while (column < columns and broke == 0 and not canceled):

                    if (imagem[row][column] == 0):  # If it finds a black pixel
                        position_to_start_ablation = [row, column]  # Gets the starting coordinates
                        broke = 1  # Sets the flag to interrupt the scan

                    column = column + 1  # Next column

                row = row + 1  # Next row
                column = 1;  # Resets the column

            laser_position = copy.copy(position_to_start_ablation)  # Copies the list (coordinate x, coordinate y)
            doing_ablation = False  # Delete this to see if it causes some issues!!!!

            routine_initial_position = position_to_start_ablation  # Copies the list (coordinate x, coordinate y)

            routine_initial_position[0] = routine_initial_position[0] - round(dimensions[0] / float(
                2))  # Converts from array position to absolute coordinates x (From array  [1,1][1,2][1,3]    to coordinates  [-1,-1][-1, 0][-1, 1]
            routine_initial_position[1] = routine_initial_position[1] - round(dimensions[1] / float(
                2))  # Converts from array position to absolute coordinates y (            [2,1][2,2][2,3]                    [ 0,-1][ 0, 0][ 0, 1]
            # (            [3,1][3,2][3,3]                    [ 1,-1][ 1, 0][ 1, 1]
            row = laser_position[0]  # Gets the position where the laser must go to
            column = laser_position[1]  # Gets the position where the laser must go to

            movement_direction = [
                                     EMPTY_ELEMENT] * total_number_of_black_pixels * 4  # Creates an array 4 times bigger than the number of pixels to assign each movimentation direction (4 times was estipulated to make room for each direction value, in the end the remaining empty elements will be removed)
            transition_points_row = [
                                        EMPTY_ELEMENT] * total_number_of_black_pixels  # Creates an stipuled size array to put row coordinates (when jumping from one point to another)
            transition_points_column = [
                                           EMPTY_ELEMENT] * total_number_of_black_pixels  # Creates an stipuled size array to put column coordinates (when jumping from one point to another)

            current_direction_element = 0  # Current index of direction array (initialized in 0)
            current_movimentation_element = 0  # Current index of movimentation array (initialized in 0)

            progress = 0  # To show progress
            loading = -1  # To show progress

           # if not canceled:
                #cls = os.system('cls')
                #print ("Calculating trajectory:")

            while (ablated_pixels < total_number_of_black_pixels and not canceled):
                if (not doing_ablation):
                    movement_direction[
                        current_direction_element] = LASER_OFF_CONST;  # Puts the command value to deactivate the laser/shutter
                    current_direction_element = current_direction_element + 1;  # Moves to next element
                    movement_direction[
                        current_direction_element] = MOVE_NEXT_POINT;  # Puts the command value to jump to the next coordinate (without ablation)
                    current_direction_element = current_direction_element + 1;  # Moves to next element
                    movement_direction[
                        current_direction_element] = LASER_ON_CONST;  # Puts the command value to activate the laser/shutter
                    current_direction_element = current_direction_element + 1;  # Moves to next element

                    current_position = [laser_position[0], laser_position[1]]

                    current_position[0] = laser_position[0] + 1 - round(dimensions[0] / float(2))
                    current_position[1] = laser_position[1] + 1 - round(dimensions[1] / float(2))

                    transition_points_row[current_movimentation_element] = current_position[0]

                    transition_points_column[current_movimentation_element] = current_position[1]
                    current_movimentation_element = current_movimentation_element + 1

                    doing_ablation = True

                if (imagem[laser_position[0]][laser_position[1]] == 0):
                    imagem[laser_position[0]][laser_position[1]] = 255
                    doing_ablation = True

                    ablated_pixels = ablated_pixels + 1

                    # -------------------------------------------------------------------------------Shows the progress
                    progress = ablated_pixels / float(total_number_of_black_pixels) * 100
                    if (progress > loading + 1):

                        loading = progress
                        if not canceled:
                            cls = os.system('cls')
                          
                            print ("Calculating trajectory: %i%s" % (ablated_pixels / float(total_number_of_black_pixels) * 100,
                                            "%"))  # Print progress as percentage
                        # -------------------------------------------------------------------------------Shows the progress

                    laser_position[0] > 0 and laser_position[1] > 0 and laser_position[0] < rows and laser_position[
                                                                                                         1] < columns

                    if (imagem[laser_position[0], laser_position[1] + 1] == 0 and imagem[
                            laser_position[0] - 1, laser_position[1]] == 255):

                        movement_direction[current_direction_element] = RIGHT;

                        current_direction_element = current_direction_element + 1;

                        laser_position[1] = laser_position[1] + 1;


                    elif (imagem[laser_position[0] + 1, laser_position[1]] == 0 and imagem[
                        laser_position[0], laser_position[1] + 1]):

                        movement_direction[current_direction_element] = DOWN;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] + 1;




                    elif (imagem[laser_position[0], laser_position[1] - 1] == 0 and imagem[
                            laser_position[0] + 1, laser_position[1]] == 255):

                        movement_direction[current_direction_element] = LEFT;

                        current_direction_element = current_direction_element + 1;

                        laser_position[1] = laser_position[1] - 1;




                    elif (imagem[laser_position[0] - 1, laser_position[1]] == 0 and imagem[
                        laser_position[0], laser_position[1] - 1]):

                        movement_direction[current_direction_element] = UP;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] - 1;

                    elif (imagem[laser_position[0] + 1, laser_position[1] + 1] == 0 and imagem[
                            laser_position[0] - 1, laser_position[1] + 1]):

                        movement_direction[current_direction_element] = DIAG_DOWN_RIGHT;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] + 1;
                        laser_position[1] = laser_position[1] + 1;

                    elif (imagem[laser_position[0] + 1, laser_position[1] - 1] == 0 and imagem[
                            laser_position[0] + 1, laser_position[1] + 1]):

                        movement_direction[current_direction_element] = DIAG_LEFT_DOWN;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] + 1;
                        laser_position[1] = laser_position[1] - 1;



                    elif (imagem[laser_position[0] - 1, laser_position[1] - 1] == 0 and imagem[
                            laser_position[0] + 1, laser_position[1] - 1]):

                        movement_direction[current_direction_element] = DIAG_LEFT_UP;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] - 1;
                        laser_position[1] = laser_position[1] - 1;


                    elif (imagem[laser_position[0] - 1, laser_position[1] + 1] == 0 and imagem[
                            laser_position[0] - 1, laser_position[1] - 1]):

                        movement_direction[current_direction_element] = DIAG_UP_RIGHT;

                        current_direction_element = current_direction_element + 1;

                        laser_position[0] = laser_position[0] - 1;
                        laser_position[1] = laser_position[1] + 1;


                else:
                    if (doing_ablation):

                        doing_ablation = False

                        row = row_scan
                        column = column_scan

                        broke = 0
                        while (
                                    row < rows and broke == 0 and not canceled):  # loop inside a loop does the scan from left to right, from above to below, everytime the column ends it jumps to the next line
                            while (column < columns and broke == 0 and not canceled):
                                if (imagem[row][column] == 0):  # If it finds a black pixel

                                    row_scan = row  # Keeps the position in which was found black pixel, to start from here again if doing another scan
                                    column_scan = column  # Keeps the position in which was found black pixel, to start from here again if doing another scan

                                    laser_position[0] = row
                                    laser_position[1] = column
                                    position_to_start_ablation[0] = row
                                    position_to_start_ablation[1] = column

                                    broke = 1  # Flag to break the pixel scanning

                                column = column + 1  # Next column
                            column = 1  # Resets the column
                            row = row + 1  # Next row

            if not canceled:
                doing_ablation = False  # ????????

                movement_direction = filter(lambda a: a != EMPTY_ELEMENT,
                                            movement_direction)  # Filters the remaining EMPTY_ELEMENTS on the array which was stipulated 4 times bigger than the total number o black pixels

                movimentation = 0  # Initializes the element number as 0
                subsequent_points = 1  # Initializes number of subsequent equal points in a row as 1

                toggle = 0  # Initializes the counting of how many times the code jumped from one point to another (transition points)

                delay = float(delay_entry.get())  # Gets the value from text box entry

                loading = -1  # Initializes variable as -1

                transition_points_row = filter(lambda a: a != EMPTY_ELEMENT, transition_points_row)

                transition_points_row = [item * step for item in transition_points_row]

                transition_points_column = filter(lambda a: a != EMPTY_ELEMENT, transition_points_column)

                transition_points_column = [item * step for item in transition_points_column]

                CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached

                activateLaser()

                if not canceled:
                    cls = os.system('cls')
                    
                    print ("Starting ablation...")
                    
                    sleep(2)
                    
                   # cls = os.system('cls')
                    
                   # print ("Progress:")

                button_on["text"] = "ON"  # Changes the status indicated on the button
                isLaserOn(False)  # ??????????????

                while (movimentation < len(
                        movement_direction) and not canceled):  # Do until all the elements have been computated


                    if (movement_direction[movimentation] == RIGHT):  # If the direction of movimentation is right


                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (CURRENT_DIRECTION == RIGHT):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       step * subsequent_points)  # Move right by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x + step * subsequent_points)  # Calculates the current x position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[
                            movimentation] == DIAG_DOWN_RIGHT):  # If the direction of movimentation is the diagonal left down


                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (
                            CURRENT_DIRECTION == DIAG_DOWN_RIGHT):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       step * subsequent_points)  # Move right by N times the step (only if a direction is repeated more than once in a row)
                            AXIS_Y.MVR(1,
                                       step * subsequent_points)  # Move down by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING and str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x + step * subsequent_points)  # Calculates the current x position
                            globalPositionY(
                                global_position_y + step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[movimentation] == DOWN):  # If the direction of movimentation is down

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (CURRENT_DIRECTION == DOWN):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_Y.MVR(1,
                                       step * subsequent_points)  # Move down by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionY(
                                global_position_y + step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[
                            movimentation] == DIAG_LEFT_DOWN):  # If the direction of movimentation is the diagonal left down

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached

                        if (
                            CURRENT_DIRECTION == DIAG_LEFT_DOWN):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       -step * subsequent_points)  # Move left by N times the step (only if a direction is repeated more than once in a row)
                            AXIS_Y.MVR(1,
                                       step * subsequent_points)  # Move down by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING and str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x - step * subsequent_points)  # Calculates the current x position
                            globalPositionY(
                                global_position_y + step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[movimentation] == LEFT):  # If the direction of movimentation is left

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (CURRENT_DIRECTION == LEFT):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       -step * subsequent_points)  # Move left by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x - step * subsequent_points)  # Calculates the current x position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[
                            movimentation] == DIAG_LEFT_UP):  # If the direction of movimentation is the diagonal left up

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (CURRENT_DIRECTION == DIAG_LEFT_UP):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       -step * subsequent_points)  # Move left by N times the step (only if a direction is repeated more than once in a row)
                            AXIS_Y.MVR(1,
                                       -step * subsequent_points)  # Move up by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING and str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x - step * subsequent_points)  # Calculates the current x position
                            globalPositionY(
                                global_position_y - step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[movimentation] == UP):  # If the direction of movimentation is up

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (CURRENT_DIRECTION == UP):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_Y.MVR(1,
                                       -step * subsequent_points)  # Move up by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionY(
                                global_position_y - step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[
                            movimentation] == DIAG_UP_RIGHT):  # If the direction of movimentation is the diagonal up right

                        if ((movimentation + 1) < len(
                                movement_direction)):  # If the current position + 1 is smaller than the total size of the array (Example: the array has 20 elements, this if will be true only until 19)
                            CURRENT_DIRECTION = movement_direction[movimentation + 1]  # Get next element on the array
                        else:
                            CURRENT_DIRECTION = 10  # Random value assigned to state that the final element of the array was reached
                        if (
                            CURRENT_DIRECTION == DIAG_UP_RIGHT):  # If the next element direction is equal to the current
                            subsequent_points = subsequent_points + 1  # Add 1 to how many times in sequence

                        else:

                            AXIS_X.MVR(1,
                                       step * subsequent_points)  # Move right by N times the step (only if a direction is repeated more than once in a row)
                            AXIS_Y.MVR(1,
                                       -step * subsequent_points)  # Move up by N times the step (only if a direction is repeated more than once in a row)

                            while ((str(AXIS_Y.IsMoving()) == MOVING and str(
                                    AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                                pass  # Do nothing

                            globalPositionX(
                                global_position_x + step * subsequent_points)  # Calculates the current x position
                            globalPositionY(
                                global_position_y - step * subsequent_points)  # Calculates the current y position

                            subsequent_points = 1  # Resets the value to be used by next direction

                    if (movement_direction[
                            movimentation] == LASER_OFF_CONST):  # If the current value on movement_direction array is a command to deactivate the shutter

                        deactivateShutter()

                    if (movement_direction[
                            movimentation] == MOVE_NEXT_POINT):  # If the current value on movement_direction array is a command to move to next point


                        vel2 = float(transition_velocity_entry.get())  # Gets the value from text box entry
                        AXIS_X.VEL(1, vel2)  # Sets the velocity in x (Only sets the velocity)
                        AXIS_Y.VEL(1, vel2)  # Sets the velocity in x (Only sets the velocity)

                        AXIS_X.MOV(1, transition_points_column[
                            toggle] + reference_x)  # Moves the stage x to (current transition point + ref)

                        AXIS_Y.MOV(1, transition_points_row[
                            toggle] + reference_y)  # Moves the stage y to (current transition point + ref)

                        while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                                AXIS_X.IsMoving()) == MOVING) and not canceled):  # While axes are moving
                            pass  # Do nothing

                        globalPositionX(transition_points_column[
                                            toggle] + reference_x)  # Sets current position to (current transition point + ref)
                        globalPositionY(transition_points_row[
                                            toggle] + reference_y)  # Sets current position to (current transition point + ref)

                        toggle = toggle + 1  # Next value on the arrays of transition points

                        vel1 = float(
                            ablation_velocity_entry.get())  # Gets the velocity value from text box entry
                        AXIS_X.VEL(1, vel1)  # Sets the velocity in x (Only sets the velocity)
                        AXIS_Y.VEL(1, vel1)  # Sets the velocity in y (Only sets the velocity)

                    if (movement_direction[
                            movimentation] == LASER_ON_CONST):  # If the current value on movement_direction array is a command to activate the shutter

                        activateShutter()
                        sleep(delay)  # Waits time for each shutter activation

                    # -------------------------------------------------------------------------------Shows the progress
                    movimentation = movimentation + 1
                    progress = movimentation / float(len(movement_direction)) * 100
                    if (progress > loading + 0.5):

                        loading = progress

                        if not canceled:
                            cls = os.system('cls')
                            print ("Progress: %.2f%s" % (
                            movimentation / float(len(movement_direction)) * 100, "%")) # Print progress as percentage
                    # -------------------------------------------------------------------------------Shows the progress

                vel2 = float(transition_velocity_entry.get())  # Gets the value from text box entry
                AXIS_X.VEL(1, vel2)  # Sets to transition velocity
                AXIS_Y.VEL(1, vel2)  # Sets to transition velocity

                deactivateShutter()
                AXIS_X.MOV(1, 0 + reference_x)  # Sends back to (0 + ref)

                AXIS_Y.MOV(1, 0 + reference_y)  # Sends back to (0 + ref)
                while ((str(AXIS_Y.IsMoving()) == MOVING or str(
                        AXIS_X.IsMoving()) == MOVING) and not canceled):  # While moving
                    pass  # Do nothing

                globalPositionX(0 + reference_x)  # Sets current position to (0 + ref)
                globalPositionY(0 + reference_y)  # Sets current position to (0 + ref)
                
                current_position_x_indicator.set('{:.5f}'.format(global_position_x))  # Sets the current position value on current position x indicator
                current_position_y_indicator.set('{:.5f}'.format(global_position_y))  # Sets the current position value on current position y indicator

        deactivateLaser()
    #  if not canceled: #Uncomment this for a infite loop
    #      run()         #Uncomment this for a infite loop


    if connected and not canceled:
        cls = os.system('cls')
        print ("CONCLUDED!")
        
        end_time = datetime.datetime.now().replace(microsecond=0)
        
        print ("Time: {}".format(end_time-start_time))

        winsound.PlaySound('Windows Notify System Generic.wav', winsound.SND_FILENAME)  # Plays sound located on folder "\Files"


    elif (connected):
        #cls = os.system('cls')
        print ("CANCELED!")
        winsound.PlaySound('Windows Exclamation.wav', winsound.SND_FILENAME)  # Plays sound located on folder "\Files"

    ablationCanceled(False)  # Resets the flag
    goToZero()  # Function go to zero and deactivate laser/shutter
    ableToCloseWindow(True)  # Allows the user to close the window
    isRunning(False)  # Resets the flag to be able to run the thread again and execute the functions from other buttons

#------------------------------------------------------------------------------------------------------------------------
#ABLATION DEF ON HEADER
button2 = Button(master, text="Ok", command=ablation, height=1,
                 width=5)  # Button configurations (button function above)
button2.place(x=510 + 105, y=45)  # Button placed on x,y coordinates on window
#------------------------------------------------------------------------------------------------------------------------

def moveRight():
    if not running:

        if not connected:
            connect()  # Connects the controllers and referentiates the axes

        if connected:

            step = float(spotsize_entry.get())  # Get step size from spotsize_entry
            setVelocity()  # Set the velocity (it differs if laser is active or not)

            # Tests if the movement is inside the allowed values (value must be within the range)
            if (global_position_x + reference_x + step) > range/2:
                # Tests if the movement is inside the allowed values (value must be within the range)

                if not already_warned:
                    warned(True)                
                    cls = os.system('cls')
                    print ("Maximum travel range reached!")
                    winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

            else:
                
                warned(False)

                AXIS_X.MVR(1,
                           step)  # Moves the stage y by (step). OBS: Movimentation relative to current (MVR) and not absolute (MOV)

                # while(str(AXIS_X.IsMoving()) == MOVING):  #While moving wait
                #    pass

                globalPositionX(global_position_x + step)  # Calculates the current x position

                current_position_x_indicator.set('{:.5f}'.format(
                    global_position_x))  # Sets the current position value on current position x indicator


button_right = Button(master, text="→", command=moveRight, height=1,
                      width=2)  # Button configurations (button function above)
button_right.place(x=148, y=255)  # Button placed on x,y coordinates on window


def moveUp():
    if not running:

        if not connected:
            connect()  # Connect controllers and referentiates the axes

        if connected:

            step = float(spotsize_entry.get())  # Get step size from spotsize_entry
            setVelocity()  # Set the velocity (it differs if laser is active or not)

            # Tests if the movement is inside the allowed values (value must be within the range)
            if (global_position_y + reference_y - step) < (-range/2):
                # Tests if the movement is inside the allowed values (value must be within the range)

                if not already_warned:
                    warned(True)                
                    cls = os.system('cls')
                    print ("Maximum travel range reached!")
                    winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

            else:
    
                warned(False)
                
                AXIS_Y.MVR(1,
                           -step)  # Moves the stage y by (-step). OBS: Movimentation relative to current (MVR) and not absolute (MOV)

                # while(str(AXIS_Y.IsMoving()) == MOVING): #While moving wait
                #    pass

                globalPositionY(global_position_y - step)  # Calculates the current y position

                current_position_y_indicator.set('{:.5f}'.format(
                    global_position_y))  # Sets the current position value on current position y indicator


button_up = Button(master, text="↑", command=moveUp, height=1, width=2)  # Button configurations (button function above)
button_up.place(x=95, y=202)  # Button placed on x,y coordinates on window


def moveDown():
    if not running:

        if not connected:
            connect()  # Connects the controllers and referentiates the axes

        if connected:

            step = float(spotsize_entry.get())  # Get step size from spotsize_entry
            setVelocity()  # Set the velocity (it differs if laser is active or not)

            # Tests if the movement is inside the allowed values (value must be within range)
            if (global_position_y + reference_y + step) > range/2:
                # Tests if the movement is inside the allowed values (value must be within range)
                
                if not already_warned:
                    warned(True)                
                    cls = os.system('cls')
                    print ("Maximum travel range reached!")
                    winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

            else:
    
                warned(False)
                
                AXIS_Y.MVR(1,
                           step)  # Moves the stage y by (step). OBS: Movimentation relative to current (MVR) and not absolute (MOV)

                # while(str(AXIS_Y.IsMoving()) == MOVING): #While moving wait
                #    pass  

                globalPositionY(global_position_y + step)  # Calculates the current y position

                current_position_y_indicator.set('{:.5f}'.format(
                    global_position_y))  # Sets the current position value on current position y indicator


button_down = Button(master, text="↓", command=moveDown, height=1,
                     width=2)  # Button configurations (button function above)
button_down.place(x=95, y=311)  # Button placed on x,y coordinates on window


def moveLeft():
    if not running:

        if not connected:
            connect()  # Connects the controllers and referentiates the axes

        if connected:

            step = float(spotsize_entry.get())  # Get step size from spotsize_entry
            setVelocity()  # Set the velocity (it differs if laser is active or not)

            # Tests if the movement is inside the allowed values (value must be within range)
            if (global_position_x + reference_x - step) < (-range/2):
                # Tests if the movement is inside the allowed values (value must be within range)
                
                if not already_warned:
                    warned(True)
                    cls = os.system('cls')
                    print ("Maximum travel range reached!")
                    winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

            else:
                
                warned(False)
                
                AXIS_X.MVR(1,
                           -step)  # Moves the stage x by (-step). OBS: Movimentation relative to current (MVR) and not absolute (MOV)

                # while(str(AXIS_X.IsMoving()) == MOVING): #While moving wait
                #    pass

                globalPositionX(global_position_x - step)  # Calculates the current x position

                current_position_x_indicator.set('{:.5f}'.format(
                    global_position_x))  # Sets the current position value on current position x indicator


button_left = Button(master, text="←", command=moveLeft, height=1,
                     width=2)  # Button configurations (button function above)
button_left.place(x=37, y=255)  # Button placed on x,y coordinates on window


def close():  # Disconnects the controllers and daisychain
    
    goToZero() 
        
    AXIS_X.CloseConnection()
    AXIS_Y.CloseConnection()
    AXIS_X.CloseDaisyChain()
    AXIS_Y.CloseDaisyChain()
        
    isConnected(False)  # Sets the flag to false
    cls = os.system('cls')
    print ("Controllers disconnected!")


#-------------------------------------------------------------------------------------------------------------------------
#LASER BUTTON DEF ON THE HEADER
button_on = Button(master, text="ON", command=onOff, height=1, width=4)  # Button configurations (button function above)
button_on.place(x=88, y=255)  # Button placed on x,y coordinates on window

#------------------------------------------------------------------------------------------------------------------------


def cancel():  # When pressing the button while running the code, it cancels. When pressing when IDLE que window closes

    if connecting:
        cls = os.system('cls')
        print ("Please wait for referencing to end!")
        #winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound
        OnStart('CANCEL')

    elif not canceled and not able_to_close_window and not connecting:
        
        cls = os.system('cls')
        print ("Canceling...")

        ablationCanceled(True)  # Sets to true the flag to interrupt the main thread (run)

    elif able_to_close_window:

                if connected:
                    close()  # Disconnects the controllers and daisychain
		
                saveValuesOnFile()
		
                master.destroy()  # Closes the window


button3 = Button(master, text="Cancel", command=cancel, height=1,
                 width=18)  # Button configurations (button function above)
button3.place(x=525, y=95)  # Button placed on x,y coordinates on window

button_zera = Button(master, text="Go to zero", command=goToZero, height=1,
                     width=18)  # Button configurations (button function on the top of the code)
button_zera.place(x=525, y=145)  # Button placed on x,y coordinates on window


def setReference():
    
    if not running and not connecting:

        if not connected:
            connect()  # Conects the controllers and referentiates the axes

        # Tests if the value written on the entries is inside the allowed values (value must be within range
        if (float(set_reference_entry_x.get()) > range/2 or float(set_reference_entry_x.get()) < (-range/2) or float(
                set_reference_entry_y.get()) > range/2 or float(set_reference_entry_y.get()) < (-range/2)):
            # Tests if the value written on the entries is inside the allowed values (value must be within range)
            
            cls = os.system('cls')
            print ("ERROR 5: Reference position out of bounds (value must be within range)!")
            winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

        else:

            referenceX(float(set_reference_entry_x.get()))  # Sets the value on text box entry x to reference x
            referenceY(float(set_reference_entry_y.get()))  # Sets the value on text box entry y to reference x
            
            cls = os.system('cls')
            print ("Reference setted!")
            
            goToZero()  # Function go to zero and deactivate laser/shutter


button_set = Button(master, text="Set", command=setReference, height=1,
                    width=5)  # Button configurations (button function above)
button_set.place(x=405, y=231)  # Button placed on x,y coordinates on window


def getReference():  # Function to get reference from current position
    
    ref_obtained = False

    if not running and not connecting:

        if not connected:
            connect()  # Conects the controllers and referentiates the axes

        if global_position_x != 0:  # If current value x has changed

            referenceX(
                global_position_x + reference_x)  # Sets the reference x to (global position x + reference position x)
            set_reference_var_x.set('{:.5f}'.format(
                reference_x))  # Sets the current position value on the position indicator on screen (SET) X
            current_position_x_indicator.set(
                '{:.5f}'.format(0.0))  # Sets the value on current position x indicator text box to 0.0
            
            ref_obtained = True
 

        if global_position_y != 0:  # If current value y has changed

            referenceY(
                global_position_y + reference_y)  # Sets the reference y to (global position y + reference position y)
            set_reference_var_y.set('{:.5f}'.format(
                reference_y))  # Sets the current position value on the position indicator on screen (SET) Y
            current_position_y_indicator.set(
                '{:.5f}'.format(0.0))  # Sets the value on current position y indicator text box to 0.0
            
            ref_obtained = True    
  
        if ref_obtained:
            cls = os.system('cls')
            print ("Reference obtained!") 
            
        goToZero()  # Function go to zero and deactivate laser/shutter


button_get = Button(master, text="Get", command=getReference, height=1,
                    width=5)  # Button configurations (button function above)
button_get.place(x=405, y=301)  # Button placed on x,y coordinates on window


def resetReference():  # Function to reset the reference position to 0.0

    if not running and not connecting:

        if not connected:
            connect()  # Conect controllers and referentiate the axes

        set_reference_var_x.set('{:.5f}'.format(0.0))  # Sets 0.0 on the position indicator on screen (SET) X
        set_reference_var_y.set('{:.5f}'.format(0.0))  # Sets 0.0 on the position indicator on screen (SET) Y
        referenceX(0.0)  # Sets to 0.0 the reference position x
        referenceY(0.0)  # Sets to 0.0 the reference position y
        
        cls = os.system('cls')
        print ("Reference reseted!")   

        goToZero()  # Function go to zero and deactivate laser/shutter


button_reset = Button(master, text="Reset", command=resetReference, height=1,
                      width=5)  # Button configurations (button function above)
button_reset.place(x=405, y=266)  # Button placed on x,y coordinates on window


def on_closing():  # Function to disconnect controls upon closing the window on "X"

    if connected:
        close()  # Disconnects the controllers and daisychain

    if not connecting:
			
        saveValuesOnFile()
		
        master.destroy()  # Closes the window
    else:
        
        cls = os.system('cls')
        print ("Please wait for referencing to end!")
        #winsound.PlaySound('Windows Ding.wav', winsound.SND_FILENAME)  # Play sound

if module_not_installed:
    tkMessageBox.showinfo("Installation error", 'PIMikro modules not installed properly, please install setup.py by typing "python setup.py install" as administrator on the CMD!\n\nFile located at Ablation_2.0\Docs_and_installer\PIPython-1.3.2.24.\n')

def keyevent(event):
    
    if event.keycode == 37:
        moveLeft()
    elif event.keycode == 38:
        moveUp()
    elif event.keycode == 39:
        moveRight()
    elif event.keycode == 40:
        moveDown()
    elif event.keycode == 32:
        onOff()
    elif event.keycode == 79:
        browse_file()
    elif event.keycode == 13:
        run()
    elif event.keycode == 81:
        cancel()
    

       

master.bind("<Control - Key>", keyevent) #You press Ctrl and a key at the same time       

master.protocol("WM_DELETE_WINDOW", on_closing)  # Calls the function on_closing upon closing


master.mainloop()  # Necessary to open the main window



