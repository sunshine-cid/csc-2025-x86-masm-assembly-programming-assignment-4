; Student
; Professor
; Class: CSC 2025 XXX
; Week 4 - Programming HW #4 Part 1, Question 2
; Date
; Program reverses the values in an array. It's built to work regardless of the array's size, and mostly-regardless of the arrays type

; Standard 32-bit x86 Assembly program setup
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword


.data
	; Create an integer array of 10 values, but design the program to allow for more values if necessary
	intArray DWORD 1,2,3,4,5,6,7,8,9,10

; **********************************************************************;
; Functional description of the main program:
;	Inputs - This program doesn't take explicit input from the user. It
;		does however utilize an array in the code
;	Registers used and associated purpose of each -
;		ESI - Holds the first-half index position of the array
;		EDI - Holds the last-half index position of the array
;		AL - Holds the first position (ESI) value, is swapped with the 
;		last (EDI) value, and then is used to move the last (EDI) value 
;		into the first position (ESI)
;	Memory locations use and associated purpose of each - No explicit 
;		memory locations are used. But the array is stored at OFFSET 0			;					
;	Functional details - First ESI and EDI are set to the beginning and
;		end of the array respectively. The there is the beginning of the 
;		loop marker. A comparison is made between the ESI and EDI. If
;		ESI is greater than or equal to EDI we JuMP to the EXIT marker.
;		Then we move the value from ESI into AL, swap al and EDI, and then
;		move AL into ESI. Effectively swapping the first index and last index values.
;		We then ADD to ESI and SUB from EDI the size of the array item.
;		Then we JuMP back to the beginning of the loop.
; **********************************************************************;

.code
main proc
	
	mov esi, OFFSET intArray	; Set ESI to the frist position index of the array.
	mov edi, OFFSEt intArray + (TYPE intArray * LENGTHOF intArray - TYPE intArray) ; Set EDI to the last position index of the array 
	
L1:	; Loops indefinately until a CoMParison (>=) breakes the loop

	cmp esi, edi			; Compare the start and end indexes
    jge EXIT				; If the comparison is greater than or equal JuMP to EXIT (Effectively break the loop)
	
	mov al, [esi]			; Move first-half position value into EAX
	xchg al, [edi]			; Swap last-half position value with EAX
	mov [esi], al			; Move EAX value into the first-half position

	add esi, TYPE intArray	; Increment the first-half position index by the size of the array element
	sub edi, TYPE intArray	; Decrement the last-half position index by the size of the array element

	jmp L1 ; JuMP to to beginning of the loop (L1)

; The EXIT is here so we can conditionally JuMP out of our loop
EXIT:

	invoke ExitProcess,0
main endp
end main
