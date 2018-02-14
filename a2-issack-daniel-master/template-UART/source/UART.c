/*
	* Modified from http://www.electronicwings.com for the purpose of assignment 2 CPSC359 W18
*/

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <wiringPi.h>
#include <wiringSerial.h>

int serial_port;

int InitUART ()
{

//  char dat;
  if ((serial_port = serialOpen ("/dev/serial0", 9600)) < 0)		/* open serial port */
  {
    fprintf (stderr, "Unable to open serial device: %s\n", strerror (errno)) ;
    return 1 ;
  }

  if (wiringPiSetup () == -1)							/* initializes wiringPi setup */
  {
    fprintf (stdout, "Unable to start wiringPi: %s\n", strerror (errno)) ;
    return 1 ;
  }

return 0;
}


void WriteStringUART(char * sPtr, int length){
	
	while(length > 0){
		serialPutchar(serial_port, *sPtr);
		sPtr++;
		length--;
	}

}

int ReadLineUART(char * bPtr, int bLength){
	char dat = '\0';
	int nChar = 0;
	while (nChar != bLength && dat != '\r') {
		
		if(serialDataAvail (serial_port))
		  { 
		    dat = serialGetchar (serial_port);		// receive character serially 	
		    serialPutchar(serial_port, dat);		// transmit character serially on port 
			*bPtr = dat;
			bPtr++;
			nChar++;
		  }
	}
	
	if (dat == '\r') {
		serialPutchar(serial_port, '\n');
		bPtr--;
		*bPtr = '\0';
	}
	
	return nChar-1;
	
}
