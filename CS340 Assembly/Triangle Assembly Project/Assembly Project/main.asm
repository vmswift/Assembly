;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 16, 2015
;Assignment: Triangle?
;Program Description:
;write a program to find if a data given is of a triangle
;using a^2+b^2=c^2, read data from file, 
;no requiremnts were made to print to file
TITLE MASM Demo				(main.asm)

INCLUDE Irvine32.inc
.data
infname		byte  "data.txt",0 ;input file name
infile      dword  0     ;input file handle
buff		byte  150 dup(' ') ;read buffer
sideA		dword ? ;sideA value
sideB		dword ? ;sideB value
sideC		dword ? ;sideC value
temp		dword ? ;temp if needed
tri			byte "Is a Triagle",0ah,0dh,0ah,0dh,0
notTri      byte "Not a Triangle!",0ah,0dh,0ah,0dh,0
;last two arrays are for printing on the fly

.code
main PROC
call readIn
;read in data to buff
call closeFile
;close file that was opened
lea esi,buff
;esi set to buffer

loopy: 
call AtoI
;convert to Int until anything but digits
mov sideA,eax
;mov converted digit into sideA for storage
call IncToNext
;mov to next digit

call AtoI
;conver ascii number to int
mov sideB,eax
;mov eax into sideB for storage
call IncToNext
;inc to next digit

call AtoI
;convert digit to int
mov sideC,eax
;saved converted digit into sideC
call NextLine
;prints LF,CR
call checkTri
;check if data given forms a triangle
;prints if it is or not
call IncToNext
;inc to next line of digits in buffer
jmp loopy
;unconditional jump
;IncToNext will catch my eof marker '$'
;and kill the loop with endAll


endALL::
;endAll can be called within any procedure to kill a loop when needed
call dumpRegs
exit
main ENDP

readIn PROC
;read in all of the data at 1 time
lea edx,infname
;read in file name set
call OpenInputFile
;open read in file
mov infile,eax
;file handler save in infile
lea edx,buff
;address for buff set to edx
mov ecx,150
;number of bytes to read in is 150
call ReadFromFile
;read data from file
mov eax,infile
;set file handle back into eax
ret
readIn ENDP

AtoI proc
;convert ascii to integer
mov eax,0
;eax is zero
mov ebx,10
;ebx is 10 for multiply
mov ecx,0
;ecx is 0
nextChar:
		  mov cl,[esi]
		  ;move current esi into cl
		  mov temp,eax
		  ;mov eax into temp
		  mov al,cl
		  ;mov cl into al
		  call writeChar
		  ;print al
		  mov eax,temp
		  ;restore eax to original value

		  cmp cl,'0'
		  jl getOut
		  ;check if cl is less than '0'

		  cmp ecx,'9'
		  jg getOut
		  ;check if ecx is greater than '9'

		  add cl,-30h
		  ;add -30h to cl to convert to single int
		  mul ebx
		  ;multiply eax by 10 to make room for single int
		  add eax,ecx
		  ;add single into to eax
		  inc esi
		  ;increment esi to next location
		  jmp nextChar
		  ;unconditional jump to nextChar
getOut: 
		  ;label to kill loop
		  ret
AtoI endp

IncToNext proc
;inc to next set of digits
loopsy:   inc esi
		  ;increment esi to next location
		  mov cl,[esi]
		  ;mov esi into cl
		  cmp ecx,'$'
		  je endAll
		  ;if ecx is '$' then stop then break loop in main program
		  cmp cl,'0'
		  jl loopsy
		  ;if cl is less than '0' then keep searching
		  cmp ecx,'9'
		  jg loopsy
		  ;if ecx is great than 9 then keep searching
ret
IncToNext endp



NextLine proc
;go to next line output between line reads

mov al,0dh
;mov CR into al
call writeChar
;print CR
mov al,0ah
;move LF into al
call writeChar
;print LF
ret
NextLine endp



checkTri proc
	;check if A is larger than B or C
	mov eax,sideA
	mov ebx,sideB
	call checkSidesAB
	;check A with B and C then report back answer
	cmp ebx,0
	je  L1
	;if A isn't largest then check B
	cmp ebx,1
	je L3
	;if A is largest then go to L3 for add check

L1:
	;check if B is larger than A or C
	mov eax,sideB
	mov ebx,sideA
	call checkSidesAB
	;check B with A and B then report back
	cmp ebx,0
	je L2
	;not a triangle then check side C at L2
	cmp ebx,1
	je L4
	;if a triangle go to L4 for add check

L2:
	;check if C is larger than A or B
	mov eax,sideC
    mov ebx,sideA
	call checkSideC
	;check C with A and B then report back answer
	cmp ebx,0
	je notTriangle
	;not a triangle
	cmp ebx,1
	je L5
	;if a triangle go to L5 for add check

L3: ;if side A was larger than B or C do this
	mov ebx,0
	add ebx,sideB
	add ebx,sideC
	cmp eax,ebx
	jl triangle
	;if A is less than B+C then triangle
	cmp eax,ebx
	jge notTriangle
	;if A is greater than B+C then notTriangle
	
L4: ;if side B was larger than A or C do this
	mov ebx,0
	add ebx,sideA
	add ebx,sideC
	cmp eax,ebx
	jl triangle
	;if B is less than A+C then triangle
	cmp eax,ebx
	jge notTriangle
	;if B is greater than A+C then notTriangle

L5: ;if side C was larger than A or B do this
	mov ebx,0
	add ebx,sideA
	add ebx,sideB
	cmp eax,ebx
	jl triangle
	;if C is less than A+B then triangle
	cmp eax,ebx
	jge notTriangle
	;if C is greater than A+B then notTriangle

notTriangle:
	;prints not a triangle to screen
	lea edi,notTri
	call printChars
	jmp endit

triangle:
	;prints that it is a triangle
	lea edi,tri
	call printChars
	jmp endit
endit: ret
checkTri endp



checkSidesAB proc
;check for largest value in side A and B
cmp eax,ebx
jge loop1
;if eax is greater or equal then loop1
cmp eax,ebx
jl loop2
;if eax is less than then loop2

loop1:
		  mov ebx,sideC
		  cmp eax,ebx
		  ;check how a or b compares to c
		  jge loop3
		  ;if eax is great then loop 3
		  cmp eax,ebx
		  jl loop2
		  ;if eax is less then loop 2
		   
loop3:
		 
		  mov ebx,1
		  ;indicates that eax is largest
		  jmp endit
loop2: 
		  mov ebx,0
		  ;indicates eax is not largest
endit:
ret
checkSidesAB endp



checkSideC proc
;check for largest value in side C
cmp eax,ebx
jg loop1
;if c is great than A go to loop1
cmp eax,ebx
jle loop2
;if c is less than A go to loop2

loop1:
		  mov ebx,sideB
		  ;set ebx to B
		  cmp eax,ebx
		  jg loop3
		  ;if C is greater than B go to loop3
		  cmp eax,ebx
		  jle loop2
		  ;if C is less than B go to loop2
loop3:
		  mov ebx,1
		  ;indicates C is largest
		  jmp endit

loop2: 
		  mov ebx,0
		  ;indicates not largest
endit:
ret
checkSideC endp


printChars PROC 
;print characters in array or consecutive memory locations
;edi must be set to byte size array before calling
;reused code modified to take edi instead of esi

nextChar: 
		;begin nextChar loop

		mov al,[edi]
		;move value from edi current location into al register

		cmp al,0
		;check if al is null

		je allDone
	    ;previous compare says al register is equal to 0
		;then go to return statement and get out of here
		;only way to break loop

		call writeChar
		;call irvine writeChar to print single 
		;byte size character from al register

		inc edi
		;increment edi to next memory location by 1 byte

		jmp nextChar
		;unconditional jump to nextChar label

allDone: ret
;allDone label for getting out of here

printChars ENDP

END main