;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 30, 2015
;Assignment: Pin Check Program
;Program Description:
;given 5 digit data verify which is a valid pin code
;based on the instructions
TITLE MASM Pin Check Assmebly Program			(main.asm)

INCLUDE Irvine32.inc
.data
infname		byte  "PIN.txt",0 ;file name for input
infile      dword  0 ;input file handle
buff		byte  150 dup('$')  ;buffer containing data from input read
outname     byte  "PINs Checked.txt",0 ;output file name
outfile     dword 0 ;output file handle
CR          EQU   0dh 
LF			EQU   0ah
outBuff     byte  160 dup(' ') ;output buffer for saving output data as it is processed
buffSZ      equ ($-outBuff) ;gets size of buffer for writeOut proc

five		equ [ebp+8] ;3rd element in stack
four		equ [ebp+12] ;4th element in stack
three		equ [ebp+16] ;5th element in stack
two			equ [ebp+20] ;6th element in stack
one			equ [ebp+24] ;7th element in stack
;five through one are labeled to indicate position for pin values

.code
MAIN PROC
	call readIn ;read data into buff

	lea  esi,buff ;esi set to input data buff
	lea edi,outBuff ;edi set to output buff

toHere:
	mov al,[esi]
	;first value of each line
	cmp al,'$'
	je endALL
	;break loop and jump to endAll if input buffer has '$'

	mov [edi],al ;write to output Buffer
	push eax ;just first value onto stack
	inc edi ;increment edi
	inc esi ;increment esi

	mov al,[esi] ;2nd pin value
	mov [edi],al ;write to output Buffer
	push eax ;push 2nd pin value
	inc edi ;increment edi
	inc esi ;increment esi

	mov al,[esi]
	mov [edi],al ;write to output Buffer
	push eax
	inc edi ;increment edi
	inc esi ;increment esi

	mov al,[esi]
	mov [edi],al ;write to output Buffer
	push eax
	inc edi ;increment edi
	inc esi ;increment esi

	mov al,[esi]
	mov [edi],al ;write to output Buffer
	push eax
	inc edi ;increment edi
	inc esi ;increment esi

	inc esi ;increment esi
	inc esi ;increment esi

	mov eax,0      ; set eax/ax/al to 0
	call setCRLF   ; add CR and LF to outBuff
	call checkPin  ;check the pin
	call printAnswer ;print eax answer to outBuff for current pin
	jmp toHere
	;loop to toHere location unconditionally



endALL:
	call writeOut
    ;write the output to file
    exit
MAIN ENDP

printAnswer proc
	;print answer from eax
	mov [edi],al
	; mov answer into outBuff
	inc edi
	;increment esi
	call setCRLF
	;add CRLF to outBuff
ret
printAnswer endp

checkPin proc
push ebp
;save ebp on stack
mov ebp,esp
;set ebp to esp value
push ebx
;save ebx on stack

mov bl,one
mov al,'1'
;return value if pin isn't within range
cmp bl,'5'
jl endIt
cmp bl,'9'
jg endIt
;endIt if not in range or else fall through

mov bl,two
mov al,'2'
;return value if pin isn't within range
cmp bl,'2'
jl endIt
cmp bl,'5'
jg endIt
;endIt if not in range or else fall through

mov bl,three
mov al,'3'
;return value if pin isn't within range
cmp bl,'4'
jl endIt
cmp bl,'8'
jg endIt
;endIt if not in range or else fall through

mov bl,four
mov al,'4'
;return value if pin isn't within range
cmp bl,'1'
jl endIt
cmp bl,'4'
jg endIt
;endIt if not in range or else fall through

mov bl,five
mov al,'5'
;return value if pin isn't within range
cmp bl,'3'
jl endIt
cmp bl,'6'
jg endIt
;endIt if not in range or else fall through

mov al,'0'
;if all the loops fall through then the pin is valid
;set to '0' for valid

endIt:
	pop ebx ;return saved value to ebx
	pop ebp ;return ebp saved value
	ret 20 ;return and knock off 20 bytes past saved ret address
checkPin endp

setCRLF proc
;procedure writes CR and LF to a output buffer
;mostly reused data from another program
;I have written

push eax ;save eax

mov al,CR
mov [edi],al
;set current edi position to CR
inc edi
;next edi position

mov al,LF
mov [edi],al
;set current edi position to LF
inc edi
;set edi to next blankspace filled location

pop eax ;return eax to saved value

ret
setCRLF endp

writeOut proc
lea edx,outname
;output file name is moved to edx
call CreateOutputFile
;create the file
mov outfile,eax
;mov file handler to outfile
lea edi,outBuff
;assign beginning of print data to esi
mov ecx,buffSZ
;set amount of bytes to print
mov edx,edi
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
mov ecx,150
;read in 150 bytes
call ReadFromFile
;call readFromFile to do the work
ret
readIn ENDP

END MAIN