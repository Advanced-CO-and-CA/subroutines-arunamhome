/******************************************************************************
* File: search.s
* Author: ARUN A. M.
* Roll number: CS18M510
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Store an array and search for the input element and return position of element in array if present
  Otherwise output -1 
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

PRINT1:	.asciz "Enter the number of elements in Array\n"
PRINT2: .asciz "Enter elements\n"
PRINT3: .asciz "Enter search element\n"
PRINT4: .asciz "Position of element is\n"

.align
ARRAY: .word 0x00

@.skip 1000

.align
OUT_INDEX: .word 0x00;

	@TEXT Section

.text
.global main

main:
	
	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT1
	SWI SWI_WRTSTR		@String printed to console

	LDR r0, =STDIN
	LDR r0, [r0]
	SWI SWI_READ		@Read input from console
	MOV r2, r0			@Array Size saved in r2
	CMP r2, #0			@Check if size is 0
	BEQ	EXIT


	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT2
	SWI SWI_WRTSTR		@String printed to console

	LDR r3, =ARRAY
	MOV r7, r2			@Save array size in another register for later use
READ_LOOP: 
	LDR r0, =STDIN
	LDR r0, [r0]
	SWI SWI_READ		@Read input from console
	MOV r1, r0				
	STR r1, [r3]		@Store elements to array
	ADD r3, r3, #4			@Increment 4bytes to iterate to next index
	SUB r2, r2, #1			@Decrement number of elements
	CMP r2, #0
	BNE READ_LOOP

	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT3
	SWI SWI_WRTSTR		@String printed to console

	LDR r0, =STDIN
	LDR r0, [r0]
	SWI SWI_READ		@Read input from console
	MOV r4, r0			@Search element saved in r2

	LDR r5, =ARRAY 		@Load the array for searching


	LDR r3, =ARRAY
	
	BL SEARCH

	@Print the position of search element in array
	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r1, =PRINT4
	SWI SWI_WRTSTR		@String printed to console

	@Print the output
	LDR r1, =STDOUT
	LDR r0, [r1]
	LDR r2, =OUT_INDEX
	LDR r1, [r2]
	SWI SWI_WRTINT		@String printed to console
	B EXIT

SEARCH:
	@PUSH Link Register to stack for returning to the calling function
	PUSH {LR}
	MOV r6, #0			@Position counter
SEARCH_LOOP:
	LDR r3, [r5]	@Load element to r3 from array
	ADD r5, r5, #4		@Point to next element
	
	ADD r6, r6, #1
	CMP r4, r3			@Check if search element and array element is same
	BEQ RETURN			@Jump to print the position of searched element in array
	SUB r7, r7, #1		@Decrement the size of array to check for array size
	CMP r7, #0			@Check if position reached 
	BNE SEARCH_LOOP

	@Not found the element
	MOV r6, #-1			@Since element not found, set output to -1

RETURN:
	LDR r8, =OUT_INDEX
	STR r6, [r8]
	@POP the eariler pushed LR to PC to return to main program
	POP {PC}



EXIT:
	SWI SWI_EXIT

	




