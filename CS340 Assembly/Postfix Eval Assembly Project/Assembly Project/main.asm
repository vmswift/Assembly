;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 23, 2015
;Assignment: Postfix Evaluation in Assembly
;Program Description:
;read in postfix problems from file
;solve and print the answers

TITLE MASM Postfix Evaluation				(main.asm)

INCLUDE Irvine32.inc
.data

infname		byte  "posfix exp.txt",0 ;input file name
infile      dword  0		;input file handle
buff		byte  344 dup(?) ;read buffer
outname    byte  "postfix output.txt",0 ;output file name
outfile     dword 0 ;output file handle
temp		dword ? ;temp if needed
myStack     dword 50 dup(0) ;my stack
mySize      dword 0      ;my current stack size
isNeg       dword 0      ;is negative check variable
ans			byte  "Solution1: " ;beginning of read out buffer
            byte  10 dup(' ') ;answer for problem1
stop1       byte  0dh,0ah
ans2	    byte  "Solution2: ";11
            byte  10 dup(' ') ;answer for problem2
stop2       byte  0dh,0ah
ans3	    byte  "Solution3: ";11
            byte  10 dup(' ') ;answer for problem3
stop3       byte  0dh,0ah
ans4	    byte  "Solution4: ";11
            byte  10 dup(' ') ;answer for problem4
stop4       byte  0dh,0ah
ans5	    byte  "Solution5: ";11
            byte  10 dup(' ') ;answer for problem5
stop5       byte  0dh,0ah 
ans6	    byte  "Solution6: ";11
            byte  10 dup(' ') ;answer for problem6
stop6       byte  0dh,0ah
ans7	    byte  "Solution7: ";11
            byte  10 dup(' ') ;answer for problem7
stop7       byte  0dh,0ah
ans8	    byte  "Solution8: ";11
            byte  10 dup(' ') ;answer for problem8
stop8       byte  0dh,0ah
ans9	    byte  "Solution9: ";11
            byte  10 dup(' ') ;answer for problem9
stop9       byte  0dh,0ah   
ans10	    byte  "Solution10: ";12
            byte  10 dup(' ') ;answer for problem10
stop10     byte  0dh,0ah
ans11	    byte  "Solution11: ";12
            byte  10 dup(' ') ;answer for problem11
stop11       byte  0dh,0ah
ans12	    byte  "Solution12: ";12
            byte  10 dup(' ') ;answer for problem12
stop12       byte  0dh,0ah
ans13	    byte  "Solution13: ";12
            byte  10 dup(' ') ;answer for problem13
stop13       byte  0dh,0ah,0
.code
main PROC
	call readIn
	;read in the data from file
	lea esi,buff
	;load buff address into esi
	mov cl,[esi]
	;set cl to the value of [esi]

	call checkDo
	;checks what operation to do and does it
	call popStk
	;pop off the answer from stack
	lea edi,stop1
	;mov stop1 address into edi
	call ItoA
	;convert answer to Ascii and put in what is before stop1

	call checkDo
	call popStk
	lea edi,stop2
	call ItoA
	;repitition of first checkDo set
	;Problem2

	call checkDo
	call popStk
	lea edi,stop3
	call ItoA
	;repitition of first checkDo set
	;Problem3

	call checkDo
	call popStk
	lea edi,stop4
	call ItoA
	;repitition of first checkDo set
	;Problem4

	call checkDo
	call popStk
	lea edi,stop5
	call ItoA
	;repitition of first checkDo set
	;Problem5

	call checkDo
	call popStk
	lea edi,stop6
	call ItoA
	;repitition of first checkDo set
	;Problem6

	call checkDo
	call popStk
	lea edi,stop7
	call ItoA
	;repitition of first checkDo set
	;Problem7

	call checkDo
	call popStk
	lea edi,stop8
	call ItoA
	;repitition of first checkDo set
	;Problem8

	call checkDo
	call popStk
	lea edi,stop9
	call ItoA
	;repitition of first checkDo set
	;Problem9

	call checkDo
	call popStk
	lea edi,stop10
	call ItoA
	;repitition of first checkDo set
	;Problem10
	
	call checkDo
	call popStk
	lea edi,stop11
	call ItoA
	;repitition of first checkDo set
	;Problem11

	call checkDo
	call popStk
	lea edi,stop12
	call ItoA
	;repitition of first checkDo set
	;Problem12

	call checkDo
	call popStk
	lea edi,stop13
	call ItoA
	;repitition of first checkDo set
	;Problem13

	call writeOut
	;write to output buffer starting at ans
	;will write all answers
endThis: 

exit
main ENDP

writeOut proc
lea edx,outname
;output file name is moved to edx
call CreateOutputFile
;create the file
mov outfile,eax
;mov file handler to outfile
lea esi,ans
;assign beginning of print data to esi
mov ecx,303
;set amount of bytes to print
mov edx,esi
;mov location of data to edx
call WriteToFile
;begin writing to the file
mov eax,outfile
;close the file handler to commit changes
call closeFile
ret
writeOut endp

readIn PROC
;read in all of the data at 1 time
lea edx,infname
;name of file is set for reading
call OpenInputFile
;open that file
mov infile,eax
;infile file handler set
mov eax,infile

lea edx,buff
;set edx to buffer
mov ecx,344
;read in 300 bytes
call ReadFromFile
;call readFromFile to do the work
ret
readIn ENDP

ItoA PROC 
		;procedure to convert int to ascii
		;requires esi and eax be set before call
		;esi must be set to a byte size array
		mov edx,0
		mov ebx,10
		;ebx set to 10 for division by 10 to get remainder

		dec edi
		;decrement esi because esi is set beyond that of array
		cmp eax,0
		jl doThis
		;handles negative numbers
loopsy:
		;beginning of loopsy jne loop

		mov edx,0
		;edx remainder is reset to zero every time

		div ebx
		;divied eax by ebx which is 10, remainder stored in edx

		add dl,30h
		;add 48 which is 30h in hex to current value
		;stored in edx but used as byte size dl

		mov [edi],dl
		;move ascii converted value in dl into byte size array esi

		dec edi
		;move from right to left in array

		cmp eax,0
		;check if eax has anything to divide

		jne loopsy
		;if eax is equal to zero then we are out of here
		jmp ending
doThis:
		mov ebx,-1
		mul ebx
		;convert eax into a positive by mul by -1
		mov ebx,1
		mov isNeg,ebx
		;set isNeg to 1 so that is it true a negative is present
		mov ebx,10
		;set ebx back to 10
		jmp loopsy
		;jump back into loopsy
ending:
		mov ebx,isNeg
		cmp ebx,0
		je endNow
		;if isNeg is 0 then get out of here now
		mov dl,'-'
		mov [edi],dl
		;put a negative sign out front on converted ItoA
		mov ebx,0
		;set ebx 0
		mov isNeg,ebx
		;clear isNeg by setting to 0
		
endNow:
	ret

ItoA ENDP

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
		  call pushStk
		  ;push int into stack on the way out of procedure
		  ret
AtoI endp

pushStk  proc

push eax
;save eax on user stack
push ebx
;save ebx on user stack
mov eax,mySize
;move mySize on eax
add eax,1
;add one to mySize
mov mySize,eax
;move the increased stack size to mySize
sub eax,1
;remove 1 from eax to get correct stack position at the top
mov ebx,4
;mov 4 into ebx
mul ebx
;mul eax by 4 to get correct increment for dword
lea edi,myStack
;mov myStack into edi
add edi,eax
;mov to top of myStack
pop ebx
;mov ebx off of user stack and put back in ebx
pop eax
;mov eax off of user stack and put back in eax
mov [edi],eax
;mov the int value on eax

ret
pushStk endp

popStk proc

mov eax,mySize
;mov mySize into eax
push ebx
;save ebx on user stack
cmp eax,0
je endIt
;if mySize is zero get out of here
sub eax,1
;remove 1 from total stack size
mov mySize,eax
;save changed size into mySize
mov ebx,4
mul ebx
;mul by 4 to get correct increment for dword
lea edi,myStack
;set edi to address of myStack
add edi,eax
;set edi to top of stack
pop ebx
;pop ebx back off the user stack
mov eax,[edi]
;return stop value in myStack using eax

endIt:
ret
popStk endp

checkDo proc
loopIt:
	cmp cl,'+'
	je L1
	cmp cl,'-'
	je L2
	cmp cl,'*'
	je L3
	cmp cl,' '
	je L4
	cmp cl,0dh
	je skip1
	cmp cl,0ah
	je skip2
	cmp cl,'0'
	je L5
	cmp cl,'1'
	je L5
	cmp cl,'2'
	je L5
	cmp cl,'3'
	je L5
	cmp cl,'4'
	je L5
	cmp cl,'5'
	je L5
	cmp cl,'6'
	je L5
	cmp cl,'7'
	je L5
	cmp cl,'8'
	je L5
	cmp cl,'9'
	je L5
	cmp cl,'$'
	;setup to kill loop if $ is reached
	je endIt
	;set of jumps to go to different labels based on cl value
L1:
	;do this for addition
	call doAdd
	;adder function
	inc esi
	;inc esi to next location
	mov cl,[esi]
	;setup cl to read data from next location
	jmp loopIt
	;jump back into the loop
L2:
	;do this for subtraction
	call doSub
	;sub function
	inc esi
	;mov esi to next location
	mov cl,[esi]
	;set cl to esi new value
	jmp loopIt
	;jump back in the loop
L3:
	;do this for multiply
	call doMul
	;multiplier function
	inc esi
	;mov to next esi location
	mov cl,[esi]
	;set cl to esi new value
	jmp loopIt
	;jump back in the loop
L4:
	;do this for blank spaces
	inc esi
	;move esi to next location
	mov cl,[esi]
	;set cl to new esi value
	jmp loopIt
	;jump back in the loop
L5:
	;do this for letters 0 through 9
	call AtoI
	;convert Ascii to Int
    jmp loopIt
	;jump back into the loop
skip1:
	;on carriage return do this 
	inc esi
	;inc esi to next location
	mov cl,[esi]
	;set cl to new esi value
	jmp endit
	;end the loop and get out of here
skip2:
	;on linefeed do this
	inc esi
	;inc esi to next location
	mov cl,[esi]
	;set cl to new esi value
	jmp loopit
	;jump back in the loop

endIt:
ret
checkDo endp

doAdd proc
	;do this for adding
	call popStk
	;return and remove top of stack
	mov ebx,eax
	;move top into ebx
	call popStk
	;return and remove top of stack
	add eax,ebx
	;add eax and ebx items from stack
	call pushStk
	;push added value back onto stack
ret
doAdd endp

doSub proc
	;do this for subtraction
	call popStk
	;return and remove top of stack
	mov ebx,eax
	;move returned stack top into ebx
	call popStk
	;return and remove top of stack
	sub eax,ebx
	;subtract ebx from eax
	call pushStk
	;push subtracted value back onto stack
ret
doSub endp

doMul proc
	;do this for multiplication
	call popStk
	;return and remove top of stack
	mov ebx,eax
	;move returned stack top into ebx
	call popStk
	;return and remove top of stack
	mul ebx
	;multiply eax and ebx
	call pushStk
	;push multiplication value back onto stack
ret
doMul endp

END MAIN