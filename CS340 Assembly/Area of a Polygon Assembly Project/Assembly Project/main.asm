;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 16, 2015
;Assignment: Area of a Polygon
;Program Description:
;given multiple sets of vertices figure out the area of
;a polygon then print to a file
TITLE MASM Demo				(main.asm)

INCLUDE Irvine32.inc
.data
infname		byte  "polyin.txt",0 ;file name for input
infile      dword  0 ;input file handle
buff		byte  300 dup(0)  ;buffer containing data from input read
temp		dword ? ;temp value if needed
poly		dword 20 dup(?)
weight      dword ? ;number of vertices
xtotal      dword ? ;total of x multiply
ytotal      dword ? ;total of y multiply
answer1		dword ? ;answer for polygon 1
answer2		dword ? ;answer for polygon 2
answer3		dword ? ;answer for polygon 3
answer4		dword ? ;answer for polygon 4
answer5		dword ? ;answer for polygon 5
outname	byte  "polyouts.txt",0 ;output file name
outfile     dword 0    ;output file handler
p1          byte "Area of Polygon1: "
poly1       byte 3 dup(' ')
stop1       byte 0dh,0ah
p2          byte "Area of Polygon2: "
poly2       byte 3 dup(' ')
stop2       byte 0dh,0ah
p3			byte "Area of Polygon3: "
poly3       byte 3 dup(' ')
stop3       byte 0dh,0ah
p4			byte "Area of Polygon4: "
poly4		byte 3 dup(' ')
stop4       byte 0dh,0ah
p5			byte "Area of Polygon5: "
poly5		byte 3 dup(' ')
stop5		byte 0dh,0ah,0
;p1 through stop5 are a buffer zone for writing to a file



.code
main PROC

call readIn
;read data into buffer
lea esi,buff
;assign buffer to esi for manipulation

mov eax,4
;number of vertices moved to eax
mov weight,eax
;mov eax to weight
call findAns
;call FindAns to get the polygons area returned to eax
mov answer1,eax
;polygon1 answer assigned to answer1

mov eax,3 ;vertice number
mov weight,eax
call findAns
;call FindAns to get the polygons area returned to eax
mov answer2,eax
;place answer in answer2

mov eax,4 ;vertice number
mov weight,eax
call findAns
;call FindAns to get the polygons area returned to eax
mov answer3,eax
;place answer in answer3

mov eax,10 ;vertice number
mov weight,eax
call findAns
;call FindAns to get the polygons area returned to eax
mov answer4,eax
;place answer in answer3

mov eax,10 ;vertice number
mov weight,eax
call findAns
;call FindAns to get the polygons area returned to eax
mov answer5,eax
;place answer in answer5

call CloseFile
;make sure previous open file is closed

mov eax,answer1
lea esi,stop1
call ItoA
;using Int to Ascii the answer is converted

mov eax,answer2
lea esi,stop2
call ItoA
;using Int to Ascii the answer is converted

mov eax,answer3
lea esi,stop3
call ItoA
;using Int to Ascii the answer is converted

mov eax,answer4
lea esi,stop4
call ItoA
;using Int to Ascii the answer is converted

mov eax,answer5
lea esi,stop5
call ItoA
;using Int to Ascii the answer is converted

call writeOut
;call procedure to print to file

call CloseFile
;make sure previous open file is closed

exit
main ENDP

writeOut proc
lea edx,outname
;output file name is moved to edx
call CreateOutputFile
;create the file
mov outfile,eax
;mov file handler to outfile
lea esi,p1
;assign beginning of print data to esi
mov ecx,115
;set amount of bytes to print
mov edx,esi
;mov location of data to edx
call WriteToFile
;begin writing to the file
mov eax,outfile
;close the file handler to commit changes
ret
writeOut endp

findAns proc
lea edi,poly
;edi set to polygon array of x/y values
mov eax,0
;eax cleared to 0
call AtoI
;call A to I to convert 
lea edi,poly
;edi set to polygon array of x/y values
mov ecx,weight
;ecx set to the number of vertices
call calculateX
;calculate starting with x to multiply
lea edi,poly
;edi set to beginning position in array
mov ecx,weight
;ecx set to number of vertices
call calculateY
;calculate starting with y to multiply
call finalAns
;calculate final anser minusing x and y then diving by 2
call IncToNext
;increment to next esi buffer location holding next group of vertices
ret
findAns endp

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
mov ecx,300
;read in 300 bytes
call ReadFromFile
;call readFromFile to do the work
ret
readIn ENDP

AtoI proc
;convert ascii to integer
mov ebx,10
;divide by 10 
mov ecx,0
;counter is 0
mov eax,0
;eax is 0

nextChar:
		  mov cl,[esi]
		  ;mov current location value to cl
		  cmp cl,' '
		  ;check if cl is blankspace
		  je L1
		  ;jump to L1 if cl is blankspace
		  cmp cl,0dh
		  ;check if cl is CR
		  je L2
		  ;jump to L2 if cl is CR
		  cmp cl,'0'
		  ;cmp cl to '0'
		  jl getOut
		  ;if cl is less then get out of here
		  cmp cl,'9'
		  ;cmp cl to '9'
		  jg getOut
		  ;if cl is greater then get out of here
		  
		  add cl,-30h
		  ;remove 30 hex to get int number
		  imul ebx
		  ;multiply by 10 to make room for single digit int
		  add eax,ecx
		  ;add singl digit to eax
		  inc esi
		  ;inc esi to next location
		  jmp nextChar
		  ;jump to nextCharacter loop spot

L1:
		  mov [edi],eax
		  ;at blank space we save converted digit into edi array index
		  mov eax,0
		  ;clean up eax
		  add edi,4
		  ;increment edi for next location
		  inc esi
		  ;inc esi
		  jmp nextChar
		  ;jump nextChar to continue loop
L2:
		  ;hit a carraige return
		  mov [edi],eax
		  ;backup eax into edi
		  jmp getOut
		  ;get out of here
getOut: 
		  ret
AtoI endp

IncToNext proc
;increment to next number value on next line
loopsy:   inc esi
		  mov cl,[esi]
		  ;mov for check for digit
		  cmp cl,'0'
		  jl loopsy 
		  ;loop again for digit
		  cmp cl,'9'
		  jg loopsy
		  ;loop again for digit
ret
IncToNext endp

calculateX proc
;calculat the values of xi t* yi+1
;requires edi be set to array of choice
;requires ecx be set to the number of vertices
mov eax,0
;make sure eax is 0
mov xtotal,eax
;zero out xtotal
mov edx,[edi+4]
;save the value of y1 into edx
;y value 1 stored for final calculation

loopsy:	mov eax,[edi]
	    ;mov current position of array into eax
		cmp ecx,1
		je L1
		;check if number of vertices is 1 then jump to L1
		mov ebx,[edi+12]
		;mov yi+1 into ebx
		mul ebx
		;multiply ebx
		add xtotal,eax
		;add eax to xtotal
		add edi,4
		;inc edi to next position 

		loop loopsy
L1:
		;do this for last vertice
		mov ebx,edx
		;mov y1 into ebx
		mul ebx
		;multiply final x value by y1
		add xtotal,eax
		;add final value to xtotal
ret
calculateX endp

calculateY proc
;calculate the values of xi+1 * yi
;requires edi be set to arrray of choice
;requires ecx be set to the number of vertices
mov eax,0
;eax zeroed out
mov ytotal,eax
;ytotal zeroed out
mov edx,[edi]
;x1 value saved to edx
add edi,4
;increment edi to y1 position for calculation
loopsy:	mov eax,[edi]
		;mov current position into eax
		cmp ecx,1
		je L1
		;if number of vertices is 1, jump to L1
		mov ebx,[edi+4]
		;mov into ebx the xi+1 value
		mul ebx
		;multiply yi and xi+1
		add edi,4
		;inc edi by 4
		add ytotal,eax
		;add eax to ytotal
		loop loopsy
		;loop to count number of vertices
L1:
		mov ebx,edx
		;mov x1 value into ebx
		mul ebx
		;multiply yfianl by x1
		add ytotal,eax
		;add eax to ytotal
ret
calculateY endp

finalAns   proc
;calculate area of polygon
mov eax,ytotal
;eax is ytotal
mov ebx,xtotal
;ebx is xtotal
sub eax,ebx
;subtract ebx from eax
mov ebx,2
;mov 2 into ebx
idiv ebx
;divide eax by 2
ret
finalAns   endp

ItoA PROC 
		;procedure to convert int to ascii
		;requires esi and eax be set before call
		;esi must be set to a byte size array
		mov edx,0
		mov ebx,10
		;ebx set to 10 for division by 10 to get remainder

		dec esi
		;decrement esi because esi is set beyond that of array

loopsy:
		;beginning of loopsy jne loop

		mov edx,0
		;edx remainder is reset to zero every time

		div ebx
		;divied eax by ebx which is 10, remainder stored in edx

		add dl,30h
		;add 48 which is 30h in hex to current value
		;stored in edx but used as byte size dl

		mov [esi],dl
		;move ascii converted value in dl into byte size array esi

		dec esi
		;move from right to left in array

		cmp eax,0
		;check if eax has anything to divide

		jne loopsy
		;if eax is equal to zero then we are out of here

	ret
ItoA ENDP

END main