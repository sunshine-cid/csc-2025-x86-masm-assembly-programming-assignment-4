; Student
; Professor
; Class: CSC 2025 XXX
; Week 4 - Programming HW #4 Part 1, Question 3
; Date
; Program reverses a predefined null-terminating string (source) storing the result in another array (target)

; Standard 32-bit x86 Assembly program setup
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

; predefined source and target strings
.data
source BYTE "This is the source string",0
target BYTE SIZEOF source DUP('#')

; **********************************************************************;
; Functional description of the main program							;
;	Inputs - There is no explicit input. However, a predefined string 
;   and target array are provided
;	Registers used and associated purpose of each -
;       ESI is used to point to the values, starting at the beginning, 
;       in the source string.
;       EDI is used to point to the values, beginning at the end, of the 
;       target string.
;       ECX is used to count through the length of the source array.
;       AL is used to store the characters as they are moved.
;	Memory locations use and associated purpose of each - No explicit 
;	    memory locations are used, but the source array is stored at 
;       OFFSET 0 and the target array is stored at OFFSET 1A
;	Functional details - The proghram begiuns by setting ESI to 
;       the beginning of the source array and EDI to the end of the target 
;       array. Then ECX is set to the length of the source. Then the 
;       marker for the beginnign of the loop is set. The value at the 
;       beginning of the array (ESI) is moved into AL, then that vale
;       is moved to EDI. We then increment ESI, and decriment EDI moving 
;       the pointers along the array in the appropriate direction. Thew loop
;       repeats, ending when we've moved through the length of the source string.
; **********************************************************************;

.code
main PROC
     mov esi, OFFSET source         ; source start-at-the-beginning index register
     mov edi, OFFSET target + SIZEOF target - 1 ; target start-at-the-end index register
     mov ecx, SIZEOF source         ; loop counter set to the size of the source array
     
L1: ; Loop runs ECX number of times
     mov al,[esi]       ; Store a character from source in AL
     mov [edi],al       ; Store the stored character in AL in target
     inc esi            ; Increment ESI index
     dec edi            ; Decriment EDI index
     loop L1            ; repeat for the length of the string

     invoke   ExitProcess,0
main ENDP
END main
