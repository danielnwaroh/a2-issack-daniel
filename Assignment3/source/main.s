

@ Code section
.section .text


.global main
main:

	ldr		r0, =creators
	bl		printf
	
	ldr		r0,	=fmt2
	bl		printf
	
	

	haltLoop$:
		b	haltLoop$

@ Data section
.section .data

@prints
creators:
.asciz		"\r\nCreated by: Issack John, Daniel Nwaroh and Steve Khanna\r\n\n"

fmt2:
.asciz		"Please press a button...\r\n\n"

fmt3:
.asciz		"You have pressed %s\r\n"

fmt4:
.asciz		"Program is terminating...\r\n"

JPL:
.asciz		"Joy-pad LEFT"

JPR:		
.asciz		"Joy-pad RIGHT"

JPU:
.asciz		"Joy-pad UP"

JPD:
.asciz		"Joy-pad DOWN"

RBP:
.asciz		"right bumper"

LBP:
.asciz		"left bumper"

STR:
.asciz		"select button"

