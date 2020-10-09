import random
import serial
import matplotlib.pyplot as plt
from drawnow import *

values = []

plt.ion()
cnt=0

#serialArduino = serial.Serial('/dev/ttyACM0', 19200)

def plotValues():
    plt.title('Serial value from Arduino')
    plt.grid(True)
    plt.ylabel('Values')
    plt.plot(values, 'rx-', label='values')
    plt.legend(loc='upper right')

#pre-load dummy data
for i in range(0,26):
    values.append(0)
    
while True:
    #while (serialArduino.inWaiting()==0):
        #pass
    #valueRead = serialArduino.readline()
    valueRead = random.randint(0, 255)

    #check if valid value can be casted
    try:
        valueInInt = int(valueRead)
        print(valueInInt)
        if valueInInt <= 1024:
            if valueInInt >= 0:
                values.append(valueInInt)
                values.pop(0)
                drawnow(plotValues)
            else:
                print("Invalid! negative number")
        else:
            print("Invalid! too large")
    except ValueError:
        print("Invalid! cannot cast")
