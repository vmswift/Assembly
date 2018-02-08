;------------------------------------------------------------------;
;Written by: John Knowles (jknowle2@my.athens.edu)			  ;
;Class: CS340 Summer 2015								  ;
;Date: July 7, 2015										  ;
;Assignment: Recursive GCF function for any give set of data       ;
;------------------------------------------------------------------;
TITLE MASM recursive GCF demo			(main.asm)

INCLUDE Irvine32.inc
.data
isNeg   dword	 0			  ;isNeg check for AtoI ItoA conversions
N	   EQU  12[ebp]		  ;N set to stack value
M	   EQU  8[ebp]			  ;M set to stack value
myBuff      byte  2 dup(' ')	  ;conversion buffer to copy to output buff
varN        dword 90		  ;starting value for variable N
varM		  dword 36		  ;starting value for variable M
ans		  dword ?			  ;answer storage location

.code
MAIN PROC

mov ecx,13			   ;ecx set to 13 for number of loops to make
loopzy:				   ;beginning of loop
    push varN			   ;push N on stack
    push varM			   ;push M on stack
    call gcf			   ;calculate/get GCF
    mov ans,eax		   ;answer stored in eax, save in ans
    call writeNMA		   ;write value of N, M, and the Answer to screen
    add varN,-1		   ;change N for next loop
    add varM,1			   ;change M for next loop
    loop loopzy		   ;run loop again until ecx is 0

    exit
MAIN ENDP

;procedure to write values N, M, and Ans to screen
writeNMA proc

push ecx				   ;save ecx loop counter size

lea edi,varN			   ;load address of varN into edi for reverse traversal in converting values to ascii
mov eax,varN			   ;eax = varN
call ItoA				   ;convert varN to ascii and store value in myBuff
call writeBuff			   ;call writeBuff to write myBuff to screen
mov al,' '			   ;al = ' '
call writeChar			   ;write a ' ' to screen

call blankOut			   ;blankout myBuff

lea edi,varN			   ;mov first location after myBuff into edi
mov eax,varM			   ;eax = varM
call ItoA				   ;convert varM to ascii and store value in myBuff
call writeBuff			   ;write myBuff to screen

call blankOut			   ;blankout myBuff

mov al,0dh			   ;al = CR
call writeChar			   ;write CR to screen
mov al,0ah			   ;al = LF
call writeChar			   ;write LF to screen

lea edi,varN			   ;mov first location after myBuff into edi
mov eax,ans			   ;mov 
call ItoA				   ;convert ans to ascii and store value in myBuff
call writeBuff			   ;write myBuff to screen
call blankOut			   ;blankout myBuff

mov al,0dh			   ;al = CR
call writeChar			   ;write CR to screen
mov al,0ah			   ;al = LF
call writeChar			   ;write LF to screen
pop ecx				   ;restore loop counter
ret
writeNMA endp


;procedure to write myBuff to screen
writeBuff proc

push ecx				   ;save loop counter from procedure using this
lea edi,myBuff			   ;load first location of myBuff into edi
mov ecx,2				   ;loop size is 2
loopsy:
    mov al,[edi]		   ;mov myBuff value into al
    call writeChar		   ;write myBuff value to screen
    inc edi			   ;next myBuff location
    loop loopsy		   ;loop until counter is 0

pop ecx				   ;restore loop counter from procedure using this
ret
writeBuff endp

;recursive procedure to find the GCF of N and M
gcf proc

push ebp				   ;save ebp
mov ebp,esp			   ;ebp = esp
mov eax,N				   ;mov stack value N into eax
mov ebx,M				   ;mov stack value M into ebx
cmp ebx,0				   ;check if M is 0
je L1				   ;if M is 0 then go L1
call doMod			   ;do % to get remainder
push ebx				   ;save N for next recursive call
push edx				   ;save M for next recursive call
call gcf				   ;gcf call itself resursivly

endit:
pop ebp				   ;restore ebp
ret 8				   ;remove N and M upon return
L1:					   ;go here when M is 0
    jmp endit			   ;go to endit
gcf endp

doMod proc
xor edx,edx
div ebx

ret
doMod endp


ItoA PROC 
	     ;reused code
		;procedure to convert int to ascii
		;requires edi and eax be set before call
		;edi must be set to a byte size array
		mov edx,0
		mov ebx,10
		;ebx set to 10 for division by 10 to get remainder

		dec edi
		;decrement edi because edi is set beyond that of array
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
		;move ascii converted value in dl into byte size array edi

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
		inc edi
		;put a negative sign out front on converted ItoA
		mov ebx,0
		;set ebx 0
		mov isNeg,ebx
		;clear isNeg by setting to 0
		
endNow:
		
	ret

ItoA ENDP


;procedure to blankout myBuff
blankOut proc

push ecx	  ;save ecx
;reused code
;procedure to blankout an array

lea edi,myBuff ;edi is myBuff
mov ecx,0 ;ecx is 0
loopy:
	mov al,' ' ;al set to blank space
	mov [edi],al ;mov al into [edi]
	inc ecx ;add 1 to ecx
	inc edi ;next edi position
	cmp ecx,2 ;check if ecx is 5
	jne loopy
pop ecx	  ;restore ecx
ret
blankOut endp



END MAIN