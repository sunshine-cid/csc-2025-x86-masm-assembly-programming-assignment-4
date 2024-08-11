; Student
; Professor
; Class: CSC 2025 XXX
; Week 4 - Programming HW #4 Part 1, Question 1
; Date
; Program computes the Fibonacci number sequence to the 10th number (the first 2 numbers are given). The numbers are stored sequentially in a defined memory location

; Standard 32-bit x86 Assembly program setup
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword


.data
	; Create array to store the Fibonaci number sequence, the first two values are given.
	Fib DWORD 1,1,?,?,?,?,?,?,?,?
	
; **********************************************************************;
; Functional description of the main program: 
; This program sets the loop counter to 8 (the first 2 numbers are given),
; sets ESI to the OFFSET of the beginning of our array, then increments
; the offset position to the third item. Then the loop begins. In each 
; iteration the following equation is completed F(n) = F(n-1) + F(n-2)
; This is done by loading the current position - 1 into BX and loading
; current position - 2 into AX. Then AX is ADDed to BX, and the saved
; value from BX is moved into the array at the current position. ESI
; is then incremented by the appropriate ammount by the TYPE value.
; This is the end of the loop and it automatically DECrements ECX and 
; repeats until the array has all 10 values.							
;	Inputs - This program does not take explicit input from the user	
;	Registers used and associated purpose of each - 
;		ECX - Tracks the loop counter (Starting at 8)
;		ESI - Holds the OFFSET for our current position in the array
;		EBX - Is loaded with the value of Array[CurrentPosition-1]. Is used
;		as F(n-1). And holds the value of F(n-1) + F(n-2).
;		EAX - Is loaded with the value of Array[CurrentPosition-2]. Is used
;		aS F(n-2).
;	Memory locations use and associated purpose of each - Starting at 
;		 OFFSET an array of 10 WORDs is initialized beginning with 1,1 and 
;		which will hold the first 10 values of the Fibonacci sequence 							
;	Functional details - Math is done in CPU registers and then moved
;		into memory. ESI is used to store the memory position of our array. 
;		ECX is used to limit our looping code.
; **********************************************************************;

.code
main proc
	
	mov ecx, 8 ; Set the loop counter to 8 (The first 2 numbers are provided)
	mov esi, OFFSET Fib ; Sets the array position offset to the beginning of the Fib memory position
	add esi, TYPE Fib * 2 ; This sets our current Fib offset (CurrentPosition) to the third number position in the array i.e. array[2]


L1:	; Loops until ECX = 0
	; The Fibonaci sequence can be defined as F(n) = F(n-1) + F(n-2)
	; The sequence can begin with either 0, 1 or 1, 1

	mov ebx, [esi - TYPE Fib * 1] ; This pulls the last number from the array i.e. array[CurrentPosition - 1]
	mov eax, [esi - TYPE Fib * 2] ; This pulls the last, last number from the array i.e. array[CurrentPosition - 2]
	
	add ebx, eax ; Add the values and store the results in BX
	mov [esi], ebx ; Store the result from EBX in the current array position

	add esi, TYPE Fib ; Increment the ESI pointer position to the next available space
	loop L1 ; Operand decriments the ECX counter, and loops until ECX = 0

	invoke ExitProcess,0
main endp
end main
