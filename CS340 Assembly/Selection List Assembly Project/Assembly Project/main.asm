;------------------------------------------------------------------;
;Written by: John Knowles (jknowle2@my.athens.edu)		   ;
;Class: CS340 Summer 2015					   ;
;Date: July 14, 2015						   ;
;Assignment: List Selection Program                                ;
;Description:						   	   ;
;   Write an assembly program to create subtotals and totals based ;
;on input and selections made by a user. Include an All Done       ;
;selection that will finalize all totals when the user presses     ;
;enter or return on that selection.			           ;
;------------------------------------------------------------------;
TITLE MASM Selection List Project            (main.asm)

INCLUDE Irvine32.inc
.data
CR			 equ	    0dh								   ;CR is CarriageReturn in hex
LF			 equ	    0ah								   ;LF is LineFeed in hex

;Get the screen setup
screenDefault	 byte    "Welcome to the Pie-In-The-Skey Shopping Store!                              ",CR,LF
			 byte    "Rules: Up and Down Keys to move. Number keys to insert. Backspace to delete.",CR,LF
			 byte    "Entering 00 will also delete. When finished go to ALL DONE and press Enter. ",CR,LF
			 byte    "                                                                  SubTotal  ",CR,LF
			 byte    " __ Staples                $1.75                                        $0  ",CR,LF
			 byte    " __ Scissors               $2.35                                        $0  ",CR,LF
			 byte    " __ Stapler               $11.58                                        $0  ",CR,LF
			 byte    " __ Crate of Paper        $22.38                                        $0  ",CR,LF
			 byte    " __ Small Trash Can        $5.95                                        $0  ",CR,LF
			 byte    " __ Crayon Big Pack       $17.85                                        $0  ",CR,LF
			 byte    " __ Pack of Pens           $4.89                                        $0  ",CR,LF
			 byte    " __ Paperclips             $3.75                                        $0  ",CR,LF
			 byte    " __ Markers                $9.99                                        $0  ",CR,LF
			 byte    " __ Tissues                $1.99                                        $0  ",CR,LF
			 byte    " __ Pack of Pencils        $4.95                                        $0  ",CR,LF
			 byte    " __ InkJet Cartridge      $29.99                                        $0  ",CR,LF
			 byte    " __ Photo Paper            $9.50                                        $0  ",CR,LF
			 byte    " __ ALL DONE (Exit)                                                         ",CR,LF
			 byte    "				           Your Bill		        $0  ",CR,LF,0
prices		 dword   0,0,0,0,175,235,1158,2238,595,1785,489,375,999,199,495,2999,950		 ;prices of items in array
subtotal		 byte    12 dup(' '),0    					   ;places to store ascii subtotal value
total		 dword   0								   ;variable to store total in int value
subtotals		 dword   17 dup(0)							   ;array of subtotal in int value
totalOut		 byte    15 dup(' '),0						   ;array for ascii total
inVal		 byte    2 dup('_'),0						   ;array for ascii input values
num			 dword   0								   ;variable to store num input value
x			 byte    4								   ;beginning y grid value. Named x by mistake :D
y			 byte    2								   ;beginning x grid value. Named y by mistake :D
xSub			 byte    62								   ;x value for Subtotal
yTot			 byte    18								   ;y value for total
xTot			 byte    59								   ;x value for total
isNeg		 dword   0								   ;pointless but required for my ItoADollar proc
niceDay		 byte    "Your order is being processed. Have a nice day and come back soon :D",0
;niceDay is for final ouput when user is all done.

.code

;-------------------------------------------------------;
;Procedure:									 ;
MAIN PROC										 ;
;Description:									 ;
;   Main is used as a starting point to call			 ;
;other procedures and instructions					 ;
;-------------------------------------------------------;
lea edi,screenDefault			 ;edi index set to screenDefault ascii array
call printScreen				 ;print screenDefault for one time setup

call scroll					 ;function that handles all active screen movement and all procedures involved during user interaction

endItALl::					 ;label that will be reached from within scroll when user is All Done
    mov dh,20					 ;y value is 20
    mov dl,6					 ;x value is 6
    call gotoxy				 ;mov cursor to location (x,y) (6,20)
    lea edi,niceDay				 ;edi is set to niceDay ascii array
    call printScreen			 ;print niceDay ascii array to screen

    mov dh,22					 ;y value is 22
    mov dl,0					 ;x value is 0
    call gotoxy				 ;mov cursor to that location

    exit
MAIN ENDP


;-------------------------------------------------------;
;Procedure:									 ;
scroll proc									 ;
;Description:									 ;
;   scroll handles all interaction and calculation	 ;
;involved with user interaction.					 ;
;-------------------------------------------------------;

top:							 ;being top loop
mov dh,x						 ;dh set to y value x
mov dl,y						 ;dl set to x value y
mov eax,0						 ;eax = 0
call gotoxy					 ;move cursor to given (x,y) location
call readChar					 ;read in a char
cmp  ah,48h					 ;check ah for upkey 
je upKey						 ;goto upKey label if ah is upkey

cmp ah,50h					 ;check ah for downkey
je downKey					 ;go to downKey label if ah is downkey

cmp al,CR						 ;check al for CarriageReturn
je enterKey					 ;if al is CR then go to enterKey label

cmp al,08h					 ;check al for backspace
je backspace					 ;if al is backspace then go to backspace label

cmp al,30h					 ;check al for a number
jge number					 ;if al is a number then go to number label

jmp top						 ;else something else was entered so go back up top for next input from user

upKey:						 ;upKey label
    cmp dh,4					 ;check if dh is set to lowest value already
    je top					 ;if dh is lowest then go back up top
    add x,-1					 ;else add -1 to x to lower value x=x-1
    call clearVal				 ;clear inVal betwen lines
    jmp top					 ;go up top
downKey:						 ;downKey label
    cmp dh,17 ;row 17			 ;check if dh is set to highest value already
    je top					 ;if dh is highest then go back up top
    add x,1					 ;else add 1 to x to increase value x=x+1
    call clearVal				 ;clear inVal between lines
    jmp top					 ;jump up top
enterKey:						 ;enter key label
    cmp dh,17					 ;make sure we are on line 17
    je endItAll				 ;if we are on 17 then endItAll. endItAll is in main proc
							 ;only way out of scroll procedure
    jmp top					 ;else jump up top
backspace:					 ;backspace label
    cmp dh,17					 ;row 17	   
    je top					 ;can't backspace on row 17 so go up top
    call clearVal				 ;clear inVal for current line when backspace is called
    mov dl,1					 ;setup to move to left 1 do clear user input on current line
    call gotoxy				 ;move cursor to left one
    lea edi,inVal				 ;edi = inVal array
    call printScreen			 ;printScreen to write cleared value
    mov num,0					 ;user input value set to 0

    lea edi,subtotal			 ;edi = subtotal ascii array
    call blankout				 ;clear subtotal for next use
    lea edi,totalOut			 ;edi = totalOut ascii array
    call blankout				 ;clear totalOut for next use
    call zeroSubTotal			 ;make sure dword subtotals array is 0 for current y location
    mov dh,x					 ;set dh to current y location
    mov dl,xSub				 ;set dl to subtotal x location
    call gotoxy				 ;move cursor to location set in dh,dl
    lea edi,subtotal			 ;edi = subtotal ascii array
    call printScreen			 ;print subtotal to screen
    call getTotal				 ;calculate total value
    call printTot				 ;print total value to screen
    jmp top
number:						 ;number label
    cmp dh,17					 ;check if at all done location
    je top					 ;go back up and try again

    cmp al,'9'					 ;check if value is great than '9'
    jg top					 ;go back up and try again

    lea esi,inVal				 ;load array for number of items into esi
    inc esi					 ;mov inVal array to 1s location
    mov cl,[esi]				 ;get current 1s location value

    lea esi,inVal				 ;reset to first array value but 10s location value

    cmp cl,'_'					 ;is the 10s location blank
    jne doThis					 ;if not blank do this

    cmp al,'0'					 ;if 10s location is blank and input value is 0
    je backspace				 ;get out of here if previous statement is true

    mov [esi],cl				 ;move 1s location into 10s location
    inc esi					 ;move to 1s location in byte array
    mov [esi],al				 ;set 1s location to input value
    mov dl,1					 ;set cursor y value to 1
    call gotoxy				 ;move cursor to the left by one
    lea edi,inVal				 ;load current number of items array into edi
    call printScreen			 ;print the current number to the screen
    call AtoI					 ;convert the number to integer and store in num
    call getSubTot				 ;getSubTotal for current position
    call printSubtot			 ;printsubtotal for current position
    call getTotal				 ;get total value
    call printTot				 ;print total

    lea edi,subtotal			 ;edi = subtotal ascii array
    call blankout				 ;clear subtotal for next use
    lea edi,totalOut			 ;edi = totalOut ascii array
    call blankout				 ;clear totalOut for next use
    jmp top
doThis:						 ;doThis label
    cmp cl,'0'					 ;if cl is ascii 0
    je set_					 ;jump equal to set
L1:
    mov [esi],cl				 ;move 1s location into 10s location
    inc esi					 ;move to 1s location in byte array
    mov [esi],al				 ;set 1s location to input value
    mov dl,1					 ;set cursor y value to 1
    call gotoxy				 ;move cursor to the left by one
    lea edi,inVal				 ;load current number of items array into edi
    call printScreen			 ;print the current number to the screen
    call AtoI					 ;convert the number to integer and store in num
    call getSubTot				 ;get subtotal for current location
    call printSubtot			 ;print subtotal for current location
    call getTotal				 ;get total for current location
    call printTot				 ;print total

    lea edi,subtotal			 ;edi = subtotal ascii array
    call blankout				 ;clear subtotal for next use
    lea edi,totalOut			 ;edi = totalOut ascii array
    call blankout				 ;clear totalOut for next use
    jmp top					 ;go back up top
set_:
    cmp al,'0'					 ;if al 0 and next space is _ then treat a backspace
    je backspace				 ;jump to backspace, why add pointless code here
    mov cl,'_'					 ;do this if next space is _ and al is a number
    jmp L1					 ;jump to L1 to handle the work :D

ret
scroll endp

;-------------------------------------------------------;
;Procedure:									 ;
printTot proc									 ;
;Description:									 ;
;   Print the value of totalOut ascii array to screen   ;
;at a set (x,y) location.						 ;
;-------------------------------------------------------;

mov dh,18						 ;y is set to 18
mov dl,xTot					 ;x is set to xTot
call gotoxy					 ;move cursor location
lea edi,totalOut				 ;edi = totalOut ascii array
call printScreen				 ;print totalOut ascii array
ret
printTot endp



;-------------------------------------------------------;
;Procedure:									 ;
printSubtot proc								 ;
;Description:									 ;
;   Print the value of the subtotal ascii array to	 ;
;screen at current y value and constant x value.		 ;
;-------------------------------------------------------;

mov dh,x						 ;set y to current y value
mov dl,xSub					 ;set x to constant subtotal x value
call gotoxy					 ;move cursor location
lea edi,subtotal				 ;edi = subtotal ascii array
call printScreen				 ;print subtotal ascii array
ret
printSubtot endp



;-------------------------------------------------------;
;Procedure:									 ;
zeroSubTotal proc								 ;
;Description:									 ;
;   Zero out the subtotal dword value stored in the     ;
;array subtotal. This is done based on current item.    ;
;-------------------------------------------------------;

lea edi,subtotals				 ;edi = subtotals dword array
mov ebx,4						 ;set ebx to 4 based on dword value
mov eax,0						 ;eax = 0
mov al,x						 ;move y value x into al
mul ebx						 ;multiply current y value by 4
add edi,eax					 ;move subtotal array to reflect current y value
mov eax,0						 ;eax = 0
mov [edi],eax					 ;current subtotals array location value is equal to 0
zeroSubTotal endp



;-------------------------------------------------------;
;Procedure:									 ;
getSubTot proc									 ;
;Description:									 ;
;   Calculate subtotal for current item based on the    ;
;location of the cursor.							 ;
;-------------------------------------------------------;

lea esi,prices					 ;esi = prices dword array
lea edi,subtotals				 ;edi = subtotals dword array
mov ebx,4						 ;set ebx to 4 based on dword value
mov eax,0						 ;eax = 0
mov al,x						 ;move y value x into al
mul ebx						 ;multiply current y value by 4
add esi,eax					 ;mov to item price for current location
add edi,eax					 ;mov to item subtotal for current location
mov eax,[esi]					 ;mov item price into eax
mov ebx,num					 ;mov num of items user wants into ebx
mul ebx						 ;mul itemprice by number user wants
mov [edi],eax					 ;mov that answer into subtotal
lea edi,total					 ;edi = subtotals ascii array
call ItoADollar				 ;convert subtotal to Ascii
ret
getSubTot endp



;-------------------------------------------------------;
;Procedure:									 ;
getTotal proc									 ;
;Description:									 ;
;   Calculate the total of the subtotals and set total  ;
;dword and totalOut ascii array to repective values.    ;
;-------------------------------------------------------;

push ebx						 ;save ebx
lea edi,subtotals				 ;edi = subtotals dword array
mov ecx,17					 ;loop counter set to 17 loops
mov total,0					 ;reset total dword to 0
loopsy:						 ;loopsy label
    mov ebx,[edi]				 ;mov subtotal value into ebx
    add eax,ebx				 ;eax = eax + subtotal value
    add edi,4					 ;next subtotal location
loop loopsy					 ;loop until counter is 0
lea edi,inVal					 ;edi = totalOut ascii array
call ItoADollar				 ;covnert eax to ascii and store in totalout ascii array
pop ebx						 ;restore ebx
ret
getTotal endp



;-------------------------------------------------------;
;Procedure:									 ;
AtoI proc										 ;
;Description:									 ;
;   Special AtoI designed to deal with inVal only.      ;
;-------------------------------------------------------;

mov eax,0						 ;eax = 0
lea edi,inVal					 ;edi = inVal 2 location ascii array
mov ecx,0						 ;ecx = 0
mov cl,[edi]					 ;mov 10s location ascii value into cl
cmp cl,'_'					 ;mov check if cl is a '_' or not
je doThis						 ;if cl is '_' then do This
add cl,-30h					 ;else make cl a int
mov eax,ecx					 ;eax = eax + cl(ecx dword)
mov ebx,10					 ;ebx = 10
mul ebx						 ;mov eax value to 10s location
inc edi						 ;next inVal location (1s location)
mov ecx,0						 ;ecx = 0
mov cl,[edi]					 ;mov inVal 1s location into cl
add cl,-30h					 ;convert cl ascii into int
add eax,ecx					 ;eax = eax + cl(ecx dword)
mov num,eax					 ;mov convert ascii to int value into num
jmp ending					 ;jump to the ending we are done
doThis:						 ;do this label
inc edi						 ;inc edi to 1s location
mov ecx,0						 ;ecx = 0
mov cl,[edi]					 ;mov inVal 1s location into cl
add cl,-30h					 ;mov convert cl from ascii to int
add eax,ecx					 ;eax = eax + cl(ecx dword)
mov num,eax					 ;mov int number of items into num
ending:						 ;ending label
ret
AtoI endp



;-------------------------------------------------------;
;Procedure:									 ;
clearVal proc									 ;
;Description:									 ;
;   Clear inVal ascii array to default value of '__'    ;
;-------------------------------------------------------;

lea edi,inVal					 ;edi = inVal 2location ascii array
mov cl,'_'					 ;cl = '_'
mov [edi],cl					 ;inVal 10s place = '_'
inc edi						 ;mov to inVal 1s location
mov [edi],cl					 ;inVal 1s place = '_'
ret
clearVal endp



;-------------------------------------------------------;
;Procedure:									 ;
blankOut proc									 ;
;Description:									 ;
;   Requires edi to be set before call. Sets an array   ;
;of ascii to blank spaces. Upon hitting null the        ;
;procedure stops and returns. Ascii array must end in a ;
;zero or null.									 ;
;-------------------------------------------------------;

there:						 ;there loop label
mov al,[edi]					 ;mov ascii array value into al
cmp al,0						 ;check if at end of ascii array (al==0)
je done						 ;if that is true then jump to done
mov al,' '					 ;mov blankspace into al
mov [edi],al					 ;mov blanksapce into ascii array
inc edi						 ;mov to next array location
jmp there						 ;unconditional jump to there
done:						 ;done label
ret
blankOut endp



;-------------------------------------------------------;
;Procedure:									 ;
printScreen proc								 ;
;Description:									 ;
;   EDI must be set to an ascii array ending in a 0.    ;
;Prints ascii array to screen until reaching 0.         ;
;-------------------------------------------------------;

mov al,[edi]					 ;mov ascii array value into al
L1:							 ;begin L1 loop
call writeChar					 ;write character in al to screen
inc edi						 ;inc to next ascii array location
mov al,[edi]					 ;mov ascii array value into al
cmp al,0						 ;check if ascii array is at 0
je endThis					 ;if at 0 then endThis
jmp L1						 ;else unconditional jump to L1
endThis:						 ;endThis label
ret
printScreen endp



;-------------------------------------------------------;
;Procedure:									 ;
ItoADollar PROC								 ;
;Description:									 ;
;   Procedure to convert an int value into ascii dollar.;
;Requires edi and eax be set before call. Requires edi  ;
;be set to memory location right after array for        ;
;reverse traversal. Special modified version of         ;
;ItoADollar that deals with ascii byte size arrays that ;
;end in null or 0. Almost entirely reused code from the ;
;nude plays profit program.                             ;
;-------------------------------------------------------;

		push edx				 ;save edx
		mov edx,0				 ;edx = 0
		mov ebx,10			 ;ebx set to 10 for division by 10 to get remainder
		mov ecx,0				 ;edx = 0
		dec edi				 ;only change made from the original code, necessary because of 0 at array ends
		dec edi				 ;decrement edi because edi is set beyond that of array
		cmp eax,0				 ;check if eax is 0
		jl doThis				 ;if eax is less than 0 jump to doThis for negative numbers
loopsy:						 ;beginning of loopsy jne loop
		mov edx,0				 ;edx remainder is reset to zero every time
		div ebx				 ;divied eax by ebx which is 10, remainder stored in edx
		add dl,30h			 ;add 48 which is 30h in hex to current value
							 ;stored in edx but used as byte size dl
		mov [edi],dl			 ;move ascii converted value in dl into byte size array edi
		dec edi				 ;move from right to left in array
		cmp ecx,1				 ;check if ecx == 1
		je addP		           ;je to addP to add a period for cash value
goBack:						 ;goBack  label for continuing after adding a period
		inc ecx				 ;inc ecx by 1
		cmp eax,0				 ;check if eax has anything to divide
		jne loopsy			 ;continue jne loopsy loop if eax is not 0
		jmp ending			 ;if eax is equal to zero then we jump to ending
doThis:						 ;doThis label for handling negative numbers
		neg eax				 ;negate eax
		mov ebx,1				 ;ebx = 1
		mov isNeg,ebx			 ;set isNeg to 1 so that is it true a negative is present
		mov ebx,10			 ;set ebx back to 10
		jmp loopsy			 ;jump back into loopsy
addP:						 ;addP label for adding a period
		push ecx				 ;save ecx
		mov cl,'.'			 ;cl set to  '.'
		mov [edi],cl			 ;mov cl into edi
		dec edi				 ;mov edi to next position
		pop ecx				 ;return ecx back to saved value
		jmp goBack			 ;go back to loop to inc ecx
ending:						 ;ending label
		mov ebx,isNeg			 ;ebx = isNeg dword
		cmp ebx,0				 ;check if ebx == 0
		je endNow				 ;if value isn't negative then endNow
		mov dl,'-'			 ;dl = '-'
		mov [edi],dl			 ;put a negative sign out front on converted ItoA
		mov ebx,0				 ;ebx = 0
		mov isNeg,ebx			 ;isNeg = 0 for next use
		
endNow:
		mov dl,'$'			 ;dl = '$'
		mov [edi],dl			 ;mov dollar sign in front of money value
		pop edx				 ;restore edx to original value
	ret

ItoADollar ENDP

END MAIN
