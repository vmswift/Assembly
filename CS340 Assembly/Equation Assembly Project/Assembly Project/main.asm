;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: May 26, 2015
;Assignment: Equation
;Program Description:
;Write a program in assembly using MASM that can evaluate
; Z = ( A + B ) * 2 - ( C - D ) * 3 + 7^5
; where A=35 B=17 C=86 D=52

TITLE Equation Program				(main.asm)

INCLUDE Irvine32.inc 
;Given library we will use in this class

.data
A dword 35
;32bit Variable A intialized to the value of 35

B dword 17
;32bit Variable B initialized to the value of 17

letC dword 86
;Variable changed from C to letC because C is a reserved word
;32bit Variable letC initialized to the value of 86

D dword 52
;32bit Variable D initialized to the value of 52

temp dword ?
;32bit temp Variable for storing data between calculations if needed

temp2 dword ?
;32bit temp Variable for storing data between calculations if needed

.code
main PROC

mov eax,A
;move A into eax to setup for calculation of (A + B)
;A is 35

add eax,B
;add B to the value of eax (which is A) for (A + B) calculation
;B is 17 and the result of the adding will be stored in eax with a value of 52

add eax,eax
;eax is added to eax to simulate the *2 portion of the equation
;value will be stored in eax. 52 + 52 = 104

mov temp,eax
;value from (A + B) * 2 calculations moved to temp so eax can be free for other calculations

mov eax,letC
;move letC (which is C) into eax to setup for calculation of (C - D)

sub eax,D
;subtract the value of D from the value of eax for (C - D) calculation
;value will be stored in eax. 86 - 52 = 34

add eax,34
;value of eax is now equal to that of *2 but we need *3


add eax,34
;value of eax is now equal to that of the *3 calculation
;eax is now equal to 102

mov temp2,eax
;save temp2(102) into eax

mov eax,temp
;move 104 from temp into eax


sub eax,temp2
;subtract 104-102=2
;at this point (A + B) * 2 - (C - D) * 3 has been solved

mov temp,eax
;store 2 in temp or later use

mov eax,0
;eax set to 0 for solving of 7^5

mov ecx,2401
;7^5 is 16807
;7 goes in 16807 a total of 2401 times;


loops:
;loop label is called loops
  
	add eax,7
	;add 7 to eax with each pass to help simulate 7^5

	loop loops
	;call the loops loop until counter is 0


add eax,temp
;add the value temp (16807) with eax (2)
;at this point the entire equation is solved
;all answers were checked with register values and with hand written work at every step
;final answer is 17017


call DumpRegs
;output register values to screen

    exit
main ENDP

END main