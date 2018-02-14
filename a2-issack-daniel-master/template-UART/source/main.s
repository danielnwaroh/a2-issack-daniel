
@ Code section
.section    .text

.global main
main: 
      
            bl      InitUART        	@ Initialize the UART
            
            		@Prints out creator names
            ldr     r0, =fmt    	@ String pointer
            mov     r1, #46        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART
            b		command

errorMessage:		@print out error message, bad command
			ldr		r0,	=fmt6		@ String pointer
			mov		r1,	#25			@ String's length
			bl		WriteStringUART	@ Write the string to the UART

command:			@Ask for the command to be executed
            ldr     r0, =fmt1    	@ String pointer
            mov     r1, #25        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART
			
			
            ldr     r0, =charBuffer @ buffer address
            mov		r1,	#64			@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read.
					
			@initializing
			//mov		r4,	#0
			ldr		r10,	=charBuffer
			
			@comparing string lengths		
			cmp 	r0,	#3
			beq		loopAND
			cmp		r0,	#2
			beq		loopOR
			b		errorMessage
			
			@compare input with the string "AND"		
loopAND:	ldrb	r9,	=andString
andTop:				
			ldrb	r5,	[r10, #0]
			ldrb	r6,	[r10, #1]
			ldrb	r7,	[r10, #2]
						
			cmp	r5,	#65
			bne	errorMessage

			cmp	r6,	#78
			bne	errorMessage

			cmp	r7,	#68
			bne	errorMessage

			b	done

			

			@compare input with the string "OR"
loopOR:		ldrb	r9,	=orString
orTop:		
			ldrb	r5,	[r10, #0]
			ldrb	r6,	[r10, #1]

			cmp	r5,	#79
			bne	errorMessage
		
			cmp	r6,	#82
			bne	errorMessage

			b		done
			
done:		
			@Ask for the first input
            ldr     r0, =fmt2    	@ String pointer
            mov     r1, #39        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART


            ldr     r0, =charBuffer 		@ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read.
					
			@Ask for the second input
            ldr     r0, =fmt3    	@ String pointer
            mov     r1, #40        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART


            ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read
					

	haltLoop$:  
			b       haltLoop$

@ Data section
.section    .data

@input prints
fmt1:
.ascii		"Please enter a command:\r\n"
fmt2:
.ascii		"Please enter the first binary number:\r\n"
fmt3:
.ascii		"Please enter the second binary number:\r\n"

@prints
fmt:
.ascii		"Creator names: Issack John and Daniel Nwaroh\r\n"
fmt4:
.ascii		"wrong number format!\r\n"
fmt5:
.ascii		"The result is: %d\r\n"
fmt6:
.ascii		"Command not recognized!\r\n"

@error checking
andString:
.ascii		"AND"
orString:
.ascii		"OR"


charBuffer:
.rept		64
.byte		0
.endr
