;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 9, 2015
;Assignment: Average Routine Printout results
;Program Description:
;compute average for any set of numbers
;Print out the Sum, Average, and what is left in the registers
TITLE MASM Demo				(main.asm)

INCLUDE Irvine32.inc
.data

myData DWORD 100,-50,125,94,35,-192,82,634
	   DWORD 193,999,-524,1,-5,300,15,81,414
	   DWORD 143,132,52,-62,38,56,42,-81,55,43
	   DWORD 121,215,0
;Data to be processed
sums   DWORD ?
;variable to store the sum of the data
avg	   DWORD ?
;variable to store the avg of the data
count  DWORD ?
;variable to store the amount of variables in the data
remainder DWORD ?
ary1   byte "Sum: "
bry1   byte 4 dup(' ') ;filled with blankspaces
stop   byte  0dh,0ah
ary2   byte "Avg:  "
bry2   byte 3 dup(' ') ;filled with blankspaces
stop2  byte  0dh,0ah
ary3   byte "Remainder: "
bry3   byte 3 dup(' ') ;filled with blank
stop3  byte 0dh,0ah,0
;ary1 through stop3 is for printing
;bry1, bry2, bry3 are for the conversion of int to ascii

.code
main PROC
	lea esi,myData
	;move the offest of myData into esi

	call sum
	;call the procedure to sum up the data while taking count

	call average
	;call the procedure to average the data


	lea esi,stop
	;move the offset of stop into esi so bry1 can be traversed in reverse

	mov eax,sums
	;move the sum value into eax, which is value to be converted

	call convert
	;call convert which makes use of the previous 2 statements


	lea esi,stop2
	;move the offset of stop2 into esi so bry2 can be traversed in reverse

	mov eax,avg
	;move the avg value into eax, which is the value to be converted

	call convert
	;call convert procedure which makes use of the previous 2 statements

	lea esi,stop3
	;move the offset of stop3 into esi so bry3 can be traversed in reverse

	mov eax,remainder
	;move the reaminder value into eax, which will be converted to ascii

	call convert
	;convert eax to ascii and place into esi/bry3 array

	lea esi,ary1
	;setup esi for printing based on memory location

	call printChars
	;call print procedure

	call DumpRegs
	;call irvine register dump

    exit
main ENDP


sum PROC ;procedure to find array sum and size
	mov ecx,0
	;make sure ecx is 0
	mov edx,0
	;make sure edix is 0
	mov eax,0
	;make sure eax is 0

loopit:	add eax,[esi]
		;beginning of not equal loop loopit
		;add value from esi array location into eax

		add esi,4
		;bump array to next position in esi

		add ecx,1
		;add 1 to array size counter ecx

		cmp edx,[esi]
		;check if esi location current value is 0

		jne loopit
		;if esi is not 0 then loop on

	mov sums,eax
	;after loop is over move eax value into sums variable

	mov count,ecx
	;after loop is over move ecx array size counter into count variable

	ret
sum ENDP

average PROC 
;procedure to find array average value

	mov eax,sums
	;move sum of array into eax
	mov edx,0
	;make sure edx is clear
	mov ebx,count
	;move array size into ebx

	div ebx
	;divide eax which is 3056 by ebx which is 29

	mov avg,eax
	;mov eax value which contains the average into avg variable

	mov remainder,edx
	;mov remainder into its memory storage

	ret
average ENDP

convert PROC 
		;procedure to convert int to ascii
		;requires esi and eax be set before call
		;esi must be set to a byte size array

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
convert ENDP

printChars PROC 
;print characters in array or consecutive memory locations
;esi must be set to byte size array before calling

nextChar: 
		;begin nextChar loop

		mov al,[esi]
		;move value from esi current location into al register

		cmp al,0
		;check if al is null

		je allDone
	    ;previous compare says al register is equal to 0
		;then go to return statement and get out of here
		;only way to break loop

		call writeChar
		;call irvine writeChar to print single 
		;byte size character from al register

		inc esi
		;increment esi to next memory location by 1 byte

		jmp nextChar
		;unconditional jump to nextChar label

allDone: ret
;allDone label for getting out of here

printChars ENDP

END main