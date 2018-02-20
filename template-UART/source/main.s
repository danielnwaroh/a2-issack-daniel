
@ Code section
.section    .text

.global main

main: 
            bl      InitUART        	@ Initialize the UART
                  
            		@Prints out creator names
            ldr     r0, =fmt    	@ String pointer
            mov     r1, #48        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART
            b		command

errorMessage:		@print out error message, bad command
			ldr		r0,	=fmt6		@ String pointer
			mov		r1,	#25			@ String's length
			bl		WriteStringUART	@ Write the string to the UART
			

command:			@Ask for the command to be executed
            ldr     r0, =fmt1    	@ String pointer
            mov     r1, #28        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART
			
            ldr     r0, =charBuffer @ buffer address
            mov		r1,	#64			@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read.
					
			@initializing
			ldr		r10,	=charBuffer
			
			@comparing string lengths		
			cmp 	r0,	#3
			beq		andOp
			cmp		r0,	#2
			beq		orOp
			b		errorMessage
			
			@compare input with the string "AND"		
andOp:		
			mov		r9,	#1
			ldrb	r5,	[r10, #0]
			ldrb	r6,	[r10, #1]
			ldrb	r7,	[r10, #2]
						
			cmp	r5,	#65
			bne	errorMessage

			cmp	r6,	#78
			bne	errorMessage

			cmp	r7,	#68
			bne	errorMessage

			b	askFirNum

			@compare input with the string "OR"
orOp:		
			mov		r9,	#2
			
			ldrb	r5,	[r10, #0]
			ldrb	r6,	[r10, #1]

			cmp	r5,	#79
			bne	errorMessage
		
			cmp	r6,	#82
			bne	errorMessage

			b		askFirNum
			
askFirNum:		
			@Ask for the first input
            ldr     r0, =fmt2    	@ String pointer
            mov     r1, #40        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART


            ldr     r0, =charBuffer2 		@ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read.
			
			ldr		r4,	=charBuffer2
			cmp		r0,	#32
			ble		skip		@IF THERE ARE FOUR CHARACTERS THEN SKIP THE FIRST ERROR CHECK STAGE		
			bl		binError	@BRANCH AND PRINT ERROR MESSAGE
			b		askFirNum
			
skip:		bl		binaryCheck		@CHECK THE INPUT FOR NON-BINARY CHAR
			cmp		r1,	#0
			beq		askFirNum		@IF CONTAINED NON-BINARY CHAR THEN ASK FOR INPUT AGAIN
			
			ldr		r8,	=charBuffer2	@NEW SPOT FOR THE FIRST INPUT, SO THAT WE CAN GET IT AGAIN FOR LATER USE

askSecNum:			
			@Ask for the second input
            ldr     r0, =fmt3    	@ String pointer
            mov     r1, #41        	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART

            ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read
					
			ldr		r4,	=charBuffer
			cmp		r0,	#32
			ble		skip1			@IF THERE ARE FOUR CHARACTERS THEN SKIP THE FIRST ERROR CHECK STAGE			
			bl		binError		@BRANCH AND PRINT ERROR MESSAGE
			b		askSecNum
			
skip1:		bl		binaryCheck		@CHECK THE INPUT FOR NON-BINARY CHAR
			cmp		r1,	#0
			beq		askSecNum		@IF CONTAINED NON-BINARY CHAR THEN ASK FOR INPUT AGAIN
			
			mov		r5,	#0
			
			mov		r0,	r8			@First num
			mov		r1,	r4			@Second num
			
			mov		r2,	#0
		
			mov		r5,	#0
			mov		r6,	#0
			
convertTop:
			ldrb	r8,	[r0, r2]	@First input
			ldrb	r4,	[r1, r2]	@Second input
			
			sub		r8,	r8,	#48												@ Converts ascii to binary
			sub		r4,	r4,	#48												@ Converts ascii to binary
			
			lsl		r5,	r5, #1
			lsl		r6,	r6, #1
				
			cmp		r8,	#1
			bne		next
			add		r5,	r5,	#1		

	next:		
			cmp		r4,	#1
			bne		next2
			add		r6,	r6,	#1
	next2:	
			
			add		r2,	r2,	#1
			cmp		r2,	#32
			blt		convertTop
					
			mov		r0,	r5
			mov		r1,	r6
			
			mov		r8,	r0
			mov		r4,	r1
			@and		r5,	r8,	r4
			
			cmp		r9,	#1
			bgt		doOr
			
			@mov		r6,	r5
			@mov		r9,	#0
			@ldr		r3,	=result
			
doAnd:
			and		r5,	r8,	r4
			b		next3

doOr:
			orr		r5,	r8,	r4
			b		next3
	
next3:		
			mov		r6,	r5
			mov		r9,	#0
			ldr		r3,	=result
			
convertLoop:
			and 	r7,	r6, #1
			cmp		r7,	#1
			beq		add1
				
add0:		mov		r4,	#48
			str		r4, [r3, r9]
			b		overAdd1
			
add1:		mov		r4,	#49
			str		r4, [r3, r9]
overAdd1:
			asr		r6,	r6,	#1
			add		r9,	r9,	#1
			cmp		r9,	#32
			blt		convertLoop
			
reverseLoop:
			
			mov		r7,	#0
			ldr		r6, =finalResult
			mov		r5,	#31
			mov		r8,	#0
			
reverseTop:

			ldr		r7,	[r3, r5]
			str		r7, [r6, r8]
			
			add		r8,	r8,	#1
			sub		r5,	r5,	#1
			cmp		r5,	#0
			bge		reverseTop
			
			ldr		r0,	=fmt5		@ String pointer
			mov		r1,	#15			@ String's length
			bl		WriteStringUART	@ Write the string to the UART

			ldr		r0,	=finalResult
			mov		r1,	#32
			bl		WriteStringUART
				
			b		command
			
	haltLoop$:  
			b       haltLoop$
			
			


			
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			
			@check if input contains any non binary numbers
binaryCheck:
			push	{r4, r5, fp, lr}

			mov		fp,	sp
			sub		sp,	#16
			
			mov		r5, #0
			mov		r1, #1
			
BCTop:
			ldrb	r2,	[r4, r5]
			
			cmp		r2,	#48
			blt		done
			
			cmp		r2,	#49
			bgt		done
			
			add		r5,	r5,	#1
			cmp		r5,	r0
			blt		BCTop
			
			b		good
			
done:		bl		binError
			mov		r1,	#0
good:
			add		sp,	#16
			pop		{r4, r5, fp, pc}
			mov 	pc, lr
			
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		
		@PRINT OUT THE ERROR MESSAGE WHEN THE NUMBER ENTERED IS NOT ACCEPTABLE
binError:
		push	{fp, lr}

		mov		fp,	sp
		sub		sp,	#8
		
			@print out error message, bad number
		ldr		r0,	=fmt4		@ String pointer
		mov		r1,	#22			@ String's length
		bl		WriteStringUART	@ Write the string to the UART
		
		add		sp,	#8
		
		pop		{fp, pc}
		mov		pc,	lr
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	

@ Data section
.section    .data

@input prints
fmt1:
.ascii		"\r\nPlease enter a command:\r\n>"
fmt2:
.ascii		"Please enter the first binary number:\r\n>"
fmt3:
.ascii		"Please enter the second binary number:\r\n>"

@prints
fmt:
.ascii		"\r\nCreator names: Issack John and Daniel Nwaroh\r\n"
fmt4:
.ascii		"Wrong number format!\r\n"
fmt5:
.ascii		"The result is: "
fmt6:
.ascii		"Command not recognized!\r\n"

result:
.rept		64
.byte		0
.endr

finalResult:
.rept		64
.byte		0
.endr




@error checking
andString:
.ascii		"AND"
orString:
.ascii		"OR"


charBuffer:
.rept		64
.byte		0
.endr

charBuffer2:
.rept		64
.byte		0
.endr

charBuffer3:
.rept		64
.byte		0
.endr		
