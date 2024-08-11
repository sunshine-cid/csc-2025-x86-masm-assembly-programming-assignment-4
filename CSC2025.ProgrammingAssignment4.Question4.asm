; Student
; Professor
; Class: CSC 2025 XXX
; Week  - Programming HW #4 Question 4
; Date
; Program tests many calls from Irvine32 in a user-friendly and interactive way.

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data
	; Declare strings which will be used to format output or display messages to the user
	tabString BYTE 9,0 ; Store the value of Tab as a string for use later

	msgWelcome BYTE "Welcome to the Irvine Call Test Program! This program tests several functions included in the Irvine Library.",0

	msgReadChar BYTE "Please input a Char to have its Integer, Hex, and Binary values displayed: ", 0
	msgReadCharDigit BYTE "I'll tell you if the Character you entered was a digit!", 0
	msgReadCharIsDigit BYTE "Yes, it was a digit!", 0
	msgReadCharNotDigit BYTE "Nope! It wasn't a digit!", 0
	msgReadDec BYTE "Please input an Unsigned Decimal to have its Hex, and Binary values displayed: ", 0
	msgReadHex BYTE "Please input a Hex to have its Integer, and Binary values displayed: ", 0
	msgReadInt BYTE "Please input a Signed Integer to have its Hex, and Binary values displayed: ", 0

	msgStringTimingIntro BYTE "In this next section we'll be reading how fast you type a string (Max lengfth 128 Characters). Hit ENTER when you're done! So, get ready! And...", 0
	msgStringTimingLength BYTE "The length of the string you typed is: ", 0
	msgStringTimingTime BYTE "Time to type string in milliseconds: ", 0

	msgRandomIntro BYTE "In this section we'll seed the random number generator and display some random numbers. Please enjoy!", 0
	msgRandomize BYTE "Setting Random Seed based on current time...", 0
	msgRandom32 BYTE "Here is a 32-Bit (Psudo)Random Number: ",0
	msgRandomRange BYTE "Below is a random number from 0 and ", 0

	msgMemDump BYTE "Below you'll see a Hex memory dump of the programs Welcome Message: ", 0
	msgRegDump BYTE "Below you'll see a dump of the CPU Registers: ", 0

	msgDelay BYTE "We've inserted a delay for your pleasure. After 5 seconds, the program will exit. Thank you!"
	
	; Declare variables which will be used for the string timing part of the program
	stringTimingStartTime DWORD 2 DUP(0) ; GetDateTime returns 64-bits of data which can be stored in 2 DWORDs
	stringTimingEndTime	DWORD 2 DUP(0) ; GetDateTime returns 64-bits of data which can be stored in 2 DWORDs
	stringTimingMaxLength = 127
	stringTimingString BYTE stringTimingMaxLength + 1 DUP(?)
	stringTimingStringLength DWORD 0

	; Declare variables for the Random section of the program
	random32Value DWORD ? ; I'll use this to store the Random32 result, and then use it as the upper range for RandomRange

; **********************************************************************;
; Functional description of the main program		
; **Please note - More detailed descriptions are loacted at the beginning 
;	of each code section.
;	Inputs - This program accepts input many times. The first few sections 
;	read input as character, an unsigned integer, a hex value, and a signed
;	integer. In the string timing section we read imput as a string. 
;	Outputs - This porogram produces quite a bit of screen output. There are 
;	welcome messages and instructions for the various sections. In the 
;	first few sections it displays the conversions of various number types
;	like signed integer, hex, and binary seperated by tabs. In the string 
;	timing section it displays a wait message and a typing prompt and then
;	it displays the total characters typed and the time in milliseconds it 
;	took to type them. Then in the random number sections we're graced with
;	a few random numbers. Finally in the delay section we're told there 
;	will be a short delay before exiting the program.
;	Registers used and associated purpose of each - 
;		EAX is used quite a bit mainly to hols the value of or address of 
;	numerical output
;		EBX in only used explicitly once, to send the TYPE (variable size) of 
;	the variable welcome message to the DumpMem call.
;		ECX is used a few times. Part of ReadString as it's max length. 
;	To hold the divisor for DIV. And as the length of the memory space for 
;	DumpMem.
;		EDX is used many, many times in almost all areas to hold the offset 
;	for the variables that are screen output. It's also used to read strings 
;	into memory or from memory. It's udes as the remnainder holder when 
;	dividing with DIV.
;		ESI is used explicitly once to send the OFFSET of the welcome message 
;	variable to the DumpMem call.
;		AL is used in the ReadChar section since it outputs only 8-bits the 
;	rest of EAX must be 0'd out
;	Memory locations use and associated purpose of each - Direct addressing
;	is not used in this program. However, offsets are used to access strings
;	in almost all sections.
;	Functional details:
;		Pratically this program walks the user through several stages. The
;	goal is to use the list of functions from Table 5-1 in section 5.4 of 
;	Kip R. Irvine - Assembly Language for x86 Processors-Pearson (2019).
; **********************************************************************;

.code
main proc

;-------------------------------- Clear Screen Section
;	Functional Details: In this section we use the Clrscr
;		call to clear the screen.
;	Inputs: NA
;	Outputs: Well, technically the screen will have changed to be blank
;	Registers: NA
;	Memory Locations: NA
;-------------------------------- 
	call Clrscr ; Clear the display
	
;-------------------------------- Welcome Message Section
;	Functional Details: In this section we load the OFFSET of the 
;		welcome message into EDX and call WriteString to display 
;		the text stored there.
;	Inputs: NA
;	Outputs: The welcome message string is displayed.
;	Registers: EDX which holds the memory offset for the welcome message
;	Memory Locations: NA
;-------------------------------- 
	mov edx, OFFSET msgWelcome ; Load and display the Welcome Message
	call WriteString
	call Crlf ; Move the display line down 1

;-------------------------------- Char to Int, Hex, Binary Section
;	Functional Details: This portion reads a single character as input 
;		(and immediate displays that character since ReadChar doesn't 
;		display what you type). The program then displays the value of 
;		that character as a signed integer, hex, and binary(seperated by 
;		a stored tab string). This section is unique in that we also call 
;		IsDigit on the character value to determine if the character is a 
;		digit or not, and then using some logic display an appropriate 
;		message about if it was a digit or not.
;	Inputs: A single character is taken as input
;	Outputs: A descriptive message informing the user is displayed, the 
;		input is then displayed as an int, hex, and binary. We then 
;		determine if the input was a digit or not and either display a 
;		message that sayss the input was a digit or display a message that 
;		says it was not.
;	Registers: EDX is used several times for output messages
;			   EAX/AL is used to hold the value of the input character.
;			   Zero Flag is used in a jump not zero comparison 
;	Memory Locations: While no direct addressing is used there are sevral 
;		memory offsets which reference stored strings which are used.
;-------------------------------- 
	; Display the Char to Int,Hex,Bin message
	mov  edx,OFFSET msgReadChar
	call WriteString

	call ReadChar ; Read the character
	call WriteChar ; Display the character typed, this is necessary since ReadChar doesn't display the Char typed
	movsx eax, al ; we need to overwrite the rest of the EAX register with the sign from AL becasue ReadChar loads the value to AL
	call Crlf ; Move the display line down 1

	; Display the value in EAX
	call WriteInt ; As an Int

	mov edx, OFFSET tabString ; Add the value to EDX to Tab the line over, and write the tab to the display
	call WriteString 
	
	call WriteHex
	
	mov edx, OFFSET tabString ; Add the value to EDX to Tab the line over, and write the tab to the display
	call WriteString 

	call WriteBin

	call Crlf ; Move the display line down 1
	
	; Was that a digit portion of this routine. Display the related message.
	mov  edx, OFFSET msgReadCharDigit
	call WriteString
	call Crlf ; Move the display line down 1

	; Build the logic paths for determining the message to display if the character was a digit

	call IsDigit
    jnz  charnotdigit ; If AL isn't a digit, jump to CHARNOTDIGIT

	mov  edx, OFFSET msgReadCharIsDigit
	call WriteString
	call Crlf ; Move the display line down 1

	jmp charexit

charnotdigit:	mov  edx, OFFSET msgReadCharNotDigit
				call WriteString
				call Crlf ; Move the display line down 1

charexit:		
	
	call Crlf ; Drop a line on the display 


;-------------------------------- Dec to Hex and Binary Section
;	Functional Details: In this section we take an unsigned integer as a string, store it 
;	in EAX, and then use WriteHex and WriteBin to display its hex and bin values.
;	Inputs: Take an unsigned integer in as a string
;	Outputs: Displays a descriptive message about what's expected. Display the value 
;	of that integer as hex and binary.
;	Registers: EDX is used as an offset holder to display messages
;			   EAX isn't explicitly used but the call's themselves use it to hold our 
;			   unsigned integer and read it.
;	Memory Locations: No direct addressing is used by an offset for a string is used 
;	to display an message.
;-------------------------------- 
	; Display the Dec to Hex,Bin message
	mov  edx,OFFSET msgReadDec
	call WriteString

	call ReadDec ; Read the unsigned integer
	call Crlf ; Move the display line down 1

	; Display the value in EAX as Hex
	call WriteHex 
	
	mov edx, OFFSET tabString ; Add the value to EDX to Tab the line over, and write the tab to the display
	call WriteString 

	; Display the value in EAX as Binary
	call WriteBin

	call Crlf ; Drop a line on the display
	call Crlf ; Drop a line on the display 

;-------------------------------- Hex to Int, Binary Section
;	Functional Details: This section accepts a hex value as string input 
;		and then displays the equilivent signed integer and binary value.
;	Inputs: Takes a hex value in as a string.
;	Outputs: Displays a descriptive message about what's expected. After input
;		displays the value recieved as a signed integer and binary values.
;	Registers: EDX is used several times to hold the values of string messages.
;			   EAX is used behind the scenes to hold our input value and read 
;			   by the calls that display the signed integer and binary values.
;	Memory Locations: No direct addressing is used but we do use offsets to 
;		reference string locations in memory.
;-------------------------------- 
	; Display the Char to Int,Hex,Bin message
	mov  edx,OFFSET msgReadHex
	call WriteString

	call ReadHex ; Read the Hex value
	call Crlf ; Move the display line down 1

	; Display the value in EAX as Int
	call WriteInt 
	
	mov edx, OFFSET tabString ; Add the value to EDX to Tab the line over, and write the tab to the display
	call WriteString 

	; Display the value in EAX as Binary
	call WriteBin

	call Crlf ; Drop a line on the display
	call Crlf ; Drop a line on the display 

;-------------------------------- Int to Hex and Binary Section
;	Functional Details: This section accepts a signed integer as a string input 
;	and then displays its hex and binary equivelants.
;	Inputs: Accepts a signed integer value as a string.
;	Outputs: Displays a message indicating what's expected. After recieving 
;	input it will display the hex and binary equivelant of that value.
;	Registers: EDX is used several times to hold the values of string messages.
;			   EAX is used behind the scenes to hold our input value and read 
;			   by the calls that display the hex and binary values.
;	Memory Locations: No direct addressing is used but we do use offsets to 
;		reference string locations in memory.
;-------------------------------- 
	; Display the Char to Int,Hex,Bin message
	mov  edx,OFFSET msgReadInt
	call WriteString

	call ReadInt ; Read the unsigned integer
	call Crlf ; Move the display line down 1

	; Display the value in EAX as Hex
	call WriteHex 
	
	mov edx, OFFSET tabString ; Add the value to EDX to Tab the line over, and write the tab to the display
	call WriteString 

	; Display the value in EAX as Binary
	call WriteBin

	call Crlf ; Drop a line on the display
	call Crlf ; Drop a line on the display 

;-------------------------------- Read String Timing Section
;	Functional Details: In this section, after a descriptive and wait message, 
;	the user is prompted to enter a string. The before and after times are 
;	stored and the total time taken to type the string is calculated. Then the 
;	length of the string is displayed along with the time in milliseconds it 
;	took to type it. INVOKE GetDateTime is tricky since it returns 64 bits, 
;	which was causing overruns. I addressed this by creating a 2 value array of 
;	DWORDS which store the upper and lower 32 bits of that return.
;	Inputs: User is prompted to input a string with a max length of 128.
;	Outputs: The string is output while the user types, but also the length of 
;	the string and the time it took to type the string, in milliseconds, is 
;	displayed.
;	Registers:  EDX is used many times to hold the offset so we can output 
;	strings to the display. But it is also used to hold the remainder for DIV, 
;	and must be cleared before using DIV.
;				EAX is also used to hold values which are output to the screen 
;				or used with DIV.
;				ECX is used to hold the max string value for reading input, 
;				and it's used as the divisor in the DIV operan.
;	Memory Locations: No direct addressing is used in this program but many 
;	offsets are used to display messages.
;-------------------------------- 
	; Display the Styring Timing Intro Message
	mov  edx,OFFSET msgStringTimingIntro
	call WriteString
	call Crlf ; Drop a line on the display

	; Display the Wait Message
	call WaitMsg
	call Crlf ; Drop a line on the display

	; Record the start time!
	INVOKE GetDateTime, OFFSET stringTimingStartTime

	; Setup and read the string!
	mov edx, OFFSET stringTimingString
	mov ecx, stringTimingMaxLength
	call ReadString
	
	; Record the end time!
	INVOKE GetDateTime, OFFSET stringTimingEndTime

	call Crlf ; Drop a line on the display 

	; ReadString automatically puts the length in EAX, but we're going to 
	; use StrLength to save the length to our variable
	mov  edx, OFFSET stringTimingString
    call StrLength
    mov  stringTimingStringLength,eax

	; Calculate the time difference
	mov eax, stringTimingEndTime
	sub eax, stringTimingStartTime
	mov stringTimingEndTime, eax

	; Display the length of the string typed
	mov  edx,OFFSET msgStringTimingLength
	call WriteString
	mov eax, stringTimingStringLength
    call WriteInt
	call Crlf ; Drop a line on the display 

	; Display the time in ms it took to type the string
	mov  edx,OFFSET msgStringTimingTime
	call WriteString

	; Load the time into EAX and divide by 10000 to get ms
	mov eax, stringTimingEndTime
	mov edx, 0 ; The 'remainder' holder must be cleared before DIV will work!
	mov ecx, 10000
    div ecx

	call WriteInt
	call Crlf ; Drop a line on the display 
	call Crlf ; Drop a line on the display

;-------------------------------- Random Number Display Section
;	Functional Details: In this section, after informing the user about what 
;	will be happening, we seed the random number generator, generate a 
;	(psudo)random 32-bit integer, then generate another random number between 
;	0 and the 32-bit random number we generated.
;	Inputs: No input is taken in this section.
;	Outputs: Informational messages and the results of our random number 
;	generation are displayed.
;	Registers:  EDX is used repeatedly to hold offsets to messages which are 
;	displayed.
;				EAX is used to hold randomly generated values and several calls
;				reference it to display those values. It's also used to set the 
;				upper range in RandomRange.
;	Memory Locations: No direct addressing is used in this program but many 
;	offsets are used to display messages.
;-------------------------------- 
	; Display the Random Number Section Message
	mov  edx,OFFSET msgRandomIntro
	call WriteString
	call Crlf ; Drop a line on the display

	; Display Randomize message
	mov  edx,OFFSET msgRandomize
	call WriteString
	call Crlf ; Drop a line on the display
	call Randomize

	; Display Random32 message
	mov  edx,OFFSET msgRandom32
	call WriteString
	; Call Random32 for a 32-bit random value
	call Random32
	call WriteInt
	call Crlf ; Drop a line on the display

	; Store our result in a variable to be used later.
	; mov random32Value, eax
	
	; Dislpay Random Range
	mov  edx,OFFSET msgRandomRange
	call WriteString
	; Dislpay the unsigned number range - 1 since random range returns a value between 0 and n-1
	dec eax
	call WriteDec
	call Crlf ; Drop a line on the display

	; Increase number value by 1 so RandomRange will return accurate results
	inc eax
	call RandomRange ; RandomRange uses EAX to set the upper range value, then overwrites with the generated value.
	call WriteDec

	call Crlf ; Drop a line on the display
	call Crlf ; Drop a line on the display 

;--------------------------------- Memory Dump Display Section
;	Functional Details: In this section we memory dump the programs initial 
;	welcome message, then we dump the current CPU registers.
;	Inputs: No explicit user input.
;	Outputs: Relevant messages describing what is happening are displayed. 
;	We display, in HEX as per DumpMem's way, the program's initial welcome 
;	message. We then dump the current CPU registers.
;	Registers:	EDX is used repeatedly to display messages or point to the offset 
;				of strings in memory.
;				EAX is used to hold the result of StringLength
;				ECX is used to hold the length of the value which will be 
;				memory dumped.
;				EBX is used to hold the variable size (TYPE) of the thing being 
;				memory dumped.
;				ESI points to the memory offset of the thing we're memory 
;				dumping.
;	Memory Locations: No direct addressing is used in this program but many 
;	offsets are used to display messages.
;-------------------------------- 
	; Display the mem dump message
	mov  edx,OFFSET msgMemDump
	call WriteString
	call Crlf ; Drop a line on the display
	
	; Setup for a DumpMem ESI for memory offset, ECX for length, and EBX for TYPE
	mov esi, OFFSET msgWelcome
	
	; Rather than hard coding the length of the welcome message we read it's length and save it in ECX
	mov  edx, OFFSET msgWelcome
    call StrLength
    mov  ecx,eax
	
	mov ebx, TYPE msgWelcome
	
	call DumpMem
	call Crlf ; Drop a line on the display

	; Display the register dump message
	mov  edx,OFFSET msgRegDump
	call WriteString
	call Crlf ; Drop a line on the display

	call DumpRegs

	call Crlf ; Drop a line on the display

;-------------------------------- Delay Section
;	Functional Details: In this section we dislpay a message indicating we're 
;	going to call a 5 second delay
;	Inputs: No input is taken
;	Outputs: We dispaly a message indicating what we're doing behind the scenes
;	Registers: EAX is used to hold the value of 5000. Which is the time in 
;	milliseconds we'll be pausing the program
;	Memory Locations: No direct addressing is used in this program but many 
;	offsets are used to display messages.
;-------------------------------- 
	; Display the Delay section message
	mov  edx,OFFSET msgDelay
	call WriteString
	call Crlf ; Drop a line on the display
	
	mov eax, 5000 ; set the delay for 5 seconds (5000ms)
	call Delay

	; Bye bye
	exit ; Call Irvine's exit function
main endp
end main
