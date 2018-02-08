;Written by: John Knowles (jknowle2@my.athens.edu)
;Class: CS340 Summer 2015
;Date: June 30, 2015
;Assignment: Nude Plays Profit Program
;Program Description:
;determine what ticket price is best from $2.75 to $1.50
;data will be manipulated based on a given set of invariants

TITLE MASM Nude Plays Profit Assembly Program			(main.asm)

INCLUDE Irvine32.inc
.data
CR     EQU   0dh
LF     EQU   0ah
isNeg       dword 0      ;is negative check variable
outname     byte  "play profit output.txt",0 ;output file name
outfile     dword 0 ;output file handle
myBuff      byte  10 dup(' ') ;conversion buffer to copy to output buff
header      BYTE "Ticket Price      Patrons    Profit" ;begin output buffer
			byte  CR,LF
outBuff		byte  1020 dup(' ')
			byte "Best Ticket price is: "
best        byte 4 dup(' ') ;end output buffer
buffSZ      equ ($-header) ;size of output buffer
inPrice     EQU   275 ;initial ticket price of 2.75
finPrice    EQU   150 ;final ticket price of 1.50
inPatrons   EQU   130 ;initial patrons
inCost      EQU   88 ;initial cost per patron
price       dword ?
patrons     dword ?
profit      dword ?
cost		dword ?
bestProfit  dword 0
bestPrice   dword 0

.code
MAIN PROC
lea esi,outBuff ;esi set to output buffer
call setInitialV ;initial value set on this call
loops:
call calcProfit ;calculate the profit
call checkProfit ;check against current largest profit
call write2Buff ;write data to buffer
call checkEnd ;check if loop needs to end
jmp loops

endAll::
;end the loop
	push bestPrice ;mov bestPrice to stack
	pop eax        ;mov bestPrice to eax
	lea edi,best+4 ;edi set for ItoA conversion
	call ItoADollar ;convert final price dollar value
	call writeOut ;write buffer to file

    exit
MAIN ENDP

checkEnd proc
;check if loop is at it's end

push price
;price on stack
pop eax
;eax is price
cmp eax,150
je endAll
;check if eax is 150
;if so then jump to main proc to endAll
;or else fall through

push price
pop eax
;eax is price
add eax,-5
;minus 5 from price
push eax
pop price
;price saved to memory

push patrons
pop eax
;eax is patrons
add eax,15
;add 15 to patrons
push eax
pop patrons
;save patrons to memory

push cost
pop eax
;eax is cost
add eax,3
;add 3 to eax
push eax
pop cost
;cost saved to memory
ret
checkEnd endp

write2buff proc
lea edi,header
;edi is set to header for conversion
push price
pop eax
;eax is set to price
call ItoADollar
;convert to Dollar ascii value
lea edi,myBuff
;edi set to myBuff
call copyTo
;copy converted data to outBuff
call blankOut
;blankout myBuff
call setSpaces
;possible space between numbers

lea edi,header
;edi is set to header for conversion
push patrons
pop eax
;eax is set to patrons
call ItoA
;convert to ascii value
lea edi,myBuff
;edi set to myBuff
call copyTo
;copy converted data to outBuff
call blankOut
;blankout myBuff
call setSpaces
;possible spaces between numbers

lea edi,header
;edi is set to header for conversion
push profit
pop eax
;eax is profit
call ItoADollar
;convert to Dollar ascii value
lea edi,myBuff
;edi set to myBuff
call copyTo
;copy converted data to outBuff
call blankOut
;blankout myBuff
call setCRLF
;set CR and LF in outBuff
ret
write2buff endp

setCRLF proc
;add CR LF to a buffer
mov al,CR
;al is CR
mov [esi],al
;mov CR to current esi
inc esi
;increment esi
mov al,LF
;al is LF
mov [esi],al
;mov LF to current esi
inc esi
;incrment esi
ret
setCRLF endp

setSpaces proc
;add spaces between stuff
mov ecx,1
;ecx is 1
loopys:
mov al,' '
;al is blankspace
mov [esi],al
;mov al into esi
inc esi
;inc esi to next spot
loop loopys
;loop
inc esi
;inc esi to next spot
ret
setSpaces endp

copyTo proc
mov ecx,10
;ecx set to myBuff size
loopy:
mov al,[edi]
;mov current myBuff value into al
mov [esi],al
;mov al into outputBuffer
inc edi
;increment edi
inc esi
;increment esi
loop loopy
;loop 10 times
inc esi
;increment esi after loop
ret
copyTo endp

checkProfit proc
;check if current is largest profit
push bestProfit
;bestProfit on stack
push profit
;profit on stack
pop eax
;eax is profit
pop ebx
;ebx is bestProfit
cmp eax,ebx
jl endIt
;check if current price is larger than bestProfit
;if it is less then endIt
mov bestProfit,eax
;mov profit into bestProfit
push price
;price on stack
pop  bestPrice
;price saved into bestPrice memory
endIt:
ret
checkProfit endp

calcProfit PROC
;calculate profit from plays
push price
;price on stack
push patrons
;patrons on stack
pop ebx
;ebx is patrons
pop eax
;eax is price
mul ebx
;eax * ebx
push eax
;total before cost taken out on stack

push patrons
;patrons on stack
push cost
;cost on stack
pop ebx
;ebx is cost
pop eax
;eax is patrons
mul ebx
;eax * ebx for total cost value

mov ebx,eax
;total cost moved into ebx
pop eax
;total moved off of stack
sub eax,ebx
;total - total cost = total profit
push eax
;push total profit on stack
pop profit
;mov total profit into profit memory
ret
calcProfit ENDP


setInitialV PROC
;set initial values
mov eax, inPrice
;eax is inPrice
mov ebx, inPatrons
;ebx is inPatrons
mov price, eax
;price is inPrice
mov patrons,ebx
;patrons is inPatrons
mov eax,inCost
;eax is inCost
mov cost,eax
;cost is inCost
ret
SetInitialV ENDP

ItoADollar PROC 
		;procedure to convert int to ascii
		;requires edi and eax be set before call
		;edi must be set to a byte size array
		mov edx,0
		mov ebx,10
		mov ecx,0
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
		cmp ecx,1
		je addP
		;do this to add a period to cash
goBack:
		inc ecx
		cmp eax,0
		;check if eax has anything to divide

		jne loopsy
		;if eax is equal to zero then we are out of here
		jmp ending
doThis:
		neg eax
		;negate eax
		mov ebx,1
		mov isNeg,ebx
		;set isNeg to 1 so that is it true a negative is present
		mov ebx,10
		;set ebx back to 10
		jmp loopsy
		;jump back into loopsy
addP:
		push ecx
		;save ecx
		mov cl,'.'
		;cl set to  '.'
		mov [edi],cl
		;mov cl into edi
		dec edi
		;dec edi to next position
		pop ecx
		;return ecx back to original value
		jmp goBack
		;go back to loop to inc ecx
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
		mov dl,'$' 
		mov [edi],dl
		;mov dollar sign in front
	ret

ItoADollar ENDP

ItoA PROC 
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

writeOut proc
lea edx,outname
;output file name is moved to edx
call CreateOutputFile
;create the file
mov outfile,eax
;mov file handler to outfile
lea esi,header
;assign beginning of print data to esi
mov ecx,buffSZ
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

blankOut proc
;procedure to blankout an array

lea edi,myBuff ;edi is myBuff
mov ecx,0 ;ecx is 0
loopy:
	mov al,' ' ;al set to blank space
	mov [edi],al ;mov al into [edi]
	inc ecx ;add 1 to ecx
	inc edi ;next edi position
	cmp ecx,10  ;check if ecx is 10
	jne loopy
ret
blankOut endp

END MAIN