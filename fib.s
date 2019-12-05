/******************************************************************************
* File: search.s
* Author: ARUN A. M.
* Roll number: CS18M510
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Get N as input and find the Nth Fibanocci number using recursion and print the output 
  */


	@ BSS Section
      .bss

    @DATA Section

.data



.equ SWI_WRTSTR,	0x69   @Print String
.equ SWI_WRTINT, 	0x6b   @Print Interger
.equ SWI_READ,		0x6c   	@Read Input
.equ SWI_EXIT,		0x11 	@Stop execution

STDIN: .word	0x00		@STDIN Handle
STDOUT: .word	0x01	@STDOUT Handle

PRINT1:	.asciz "Enter the number\n"
PRINT2: .asciz "Nth Fibanocci Number is\n"



@.skip 1000



	@TEXT Section

.text
.global main

main:
	
	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT1
	SWI SWI_WRTSTR		@Print the string to request for the input 

	LDR r0, =STDIN
	LDR r0, [r0]
	SWI SWI_READ		@Read input from console
	MOV r2, r0			@Store N in r2

	PUSH {r2}
	BL FIB

	MOV r3, r1
	@Print the Nth Fibanocci sum
	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT2
	SWI SWI_WRTSTR		@Print string to console

	@Print the output
	LDR r1, =STDOUT
	LDR r0, [r1]
	MOV r1, r3
	SWI SWI_WRTINT		@Print output to console
	B EXIT


@Recursive Function to find the Nth Fibanocci number

FIB:
	@Check if n is 0 or 1, then fib is the number itself and return					
	POP {r2}		
	CMP r2,#1 	 	
	BLE RETURN_1

	@Push the return address to stack
	PUSH {LR}	

	@Find fib(n-1)
	SUB r2, r2,#1
	PUSH {r2}
	BL FIB 			
	
	@Save the intermediate result to stack
	PUSH {r1} 		

	@Find fib(n-2)
	SUB r2,r2,#1 
	PUSH {r2}
	BL FIB 			
	
	@Calculate fib(n) = fib(n-1) + fib(n-2)
	POP {r3}		
	ADD r1,r1,r3

	@Restore the value of n in r2
	ADD r2,r2,#2
	B RETURN		



@Save the value of r2 in r1 and jump to calling function
RETURN_1:
	MOV r1, r2
	MOV PC, LR

@POP the return address as PC to return to the calling function
RETURN:
	POP {PC}

EXIT: 
	SWI SWI_EXIT
