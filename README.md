# csc-2025-x86-masm-assembly-programming-assignment-4

x86 MASM 10-Week Condensed College Course CSC-2025 this is the fourth programming assignment

----------

1. (20 Pts) Write a program that uses a loop to generate the first 10 values of the Fibonacci number sequence, described by the following formula:
  >𝐹𝑖𝑏(1) = 1, 𝐹𝑖𝑏(2) = 1, 𝐹𝑖𝑏(𝑛) = 𝐹𝑖𝑏(𝑛 − 1) + 𝐹𝑖𝑏(𝑛 − 2)
  Save the sequence sequentially in a defined memory location.

2. (20 Pts) Write a program that defines an integer array in memory, and then uses a loop with indirect or indexed addressing to reverse the elements of an integer array, in place. Do not copy the elements to any other array. Use the SIZEOF, TYPE, and LENGTHOF operators to make the program as flexible as possible if the array size and type should be changed in the future.

3. (20 Pts) Write a program with a loop and indirect addressing that copies a string from source to target, reversing the character order in the process. Use the following variables:
  >source BYTE "This is the source string",0
  >
  >target BYTE SIZEOF source DUP('#')

4. (40 Pts) Write a program to test the following procedures from Table 5-1 in section 5.4.

  a. Clrscr
  
  b. Delay
  
  c. DumpMem
  
  d. DumpRegs
  
  e. GetDateTime

  f. IsDigit

  g. Randomize
  
  h. Random32

  i. RandomRange

  j. ReadChar

  k. ReadDec

  l. ReadHex

  m. ReadInt

  n. ReadString

  o. StrLength

  p. WaitMsg

  q. WriteBin

  r. WriteChar

  s. WriteHex

  t. WriteInt

Your program must include at least one instance of each of the procedures.

Your program must be interactive, user-friendly, and display clear/logical output results.

Note: There are 3 Library Test Programs in Section 5.4 that can be used as models, if desired.
