;-------------------------------------------------------------------
;Written by: John Knowles (jknowle2@my.athens.edu)			  ;
;Class: CS340 Summer 2015								  ;
;Date: July 14, 2015									  ;
;Assignment: Encrypt and Decrypt messages based on a key given	  ;
;-------------------------------------------------------------------
TITLE MASM Message Encryption Project			(main.asm)

INCLUDE Irvine32.inc
.data
CR		EQU  0dh					    ;carriage return
LF		EQU  0ah					    ;line feed
infname	byte  "Encryption.txt",0		    ;input file name
infile    dword  0					    ;input file handle
buff		byte  617 dup(?)			    ;read buffer
buffSZ	EQU  ($-buff)				    ;size of the input buffer if needed
outname   byte  "encryption output.txt",0   ;output file name
outfile   dword 0					    ;output file handle
outBuff	byte  1328 dup(' ')			    ;ouput buffer set to blank spaces
message	byte  400 dup(' ')			    ;message buffer
key		byte  400 dup(' ')			    ;encrypt key buffer
messageSZ dword 0					    ;size of the current message in buffer
keySZ     dword 0					    ;size of the current key in buffer
temp	     dword 0					    ;used for temp items if or where needed


.code
MAIN PROC
    call readIn		   ;read the data in
    lea edi,buff		   ;edi set to input buffer
    lea esi,outBuff		   ;esi set to output buffer
    mov ecx,4			   ;number of times to loop
loopzy:				   ;loop for encryption
    call readMessages	   ;read the message to encrypt
    call readKeys		   ;read the encryption key
    call writeMessage	   ;write unaltered message
    call extraSpacing	   ;needed because of characters that cause problems created by encryption
    call decryptMsg		   ;encrypt the message/decrypt the message. works both ways
    call writeMessage	   ;write encrypted message
    call extraSpacing	   ;needed because of characters that cause problems created by encryption
    call decryptMsg		   ;encrypt the message/decrypt the message. works both ways
    call writeMessage	   ;write decrypted message
    call addSpacing		   ;2line space between data sets
    mov eax,0			   ;cleared eax to 0
    mov messageSZ,eax	   ;messageSZ is 0
    mov keySZ,eax		   ;keySZ is zero
    loop loopzy

endItAll::
    call writeOut
    exit
MAIN ENDP

;extra spacing procedure to add lines in the event encryption causes problems
extraSpacing proc
mov al,CR				   ;move CR into al
mov [esi],al			   ;mov al into ESI output buffer
inc esi				   ;inc esi to next spot
mov al,LF				   ;move LF into al
mov [esi],al			   ;mov al into ESI output buffer
inc esi				   ;inc esi to next spot
ret
extraSpacing endp

;spacing added to output buffer between message/key sets
addSpacing proc
mov al,CR				   ;mov al = CR
mov [esi],al			   ;mov al into outputbuffer esi
inc esi				   ;mov to next output buffer location
mov bl,LF				   ;mov bl = LF
mov [esi],bl			   ;mov bl into output buffer location
inc esi				   ;inc to next output buffer location
mov [esi],al			   ;mov al into output buffer location
inc esi				   ;inc to next output buffer location
mov [esi],bl			   ;mov bl into output buffer location
inc esi				   ;inc to next output buffer location
ret
addSpacing endp


;named decryptMsg because it started as my decrypter function
;coincidentally became my enctrypter function because it preformed both tasks without code change
decryptMsg proc
push edi				   ;save input buffer
push esi				   ;save output buffer
lea edi,message		   ;edi = message array
lea esi,key			   ;esi = key array
mov temp,0			   ;temp = 0
L1:					   ;encryption/decryption loop
    mov al,[edi]		   ;al = message array value
    mov bl,[esi]		   ;bl = key array value
    cmp bl,0dh			   ;check for when key hits CR so it can be reset to first location
    je reset			   ;jump and reset key location for continued use
    xor al,bl			   ;xor al and bl. value stored in al
    mov [edi],al		   ;mov encrypted message value into message
    
    inc edi			   ;inc message array to next location
    inc esi			   ;inc key array to next location
    add temp,1			   ;increasing size of temp for message size compare
    mov edx,temp		   ;mov temp into edx
    cmp edx,messageSZ	   ;compare number of loops with size of the message
    je done			   ;if they are equal then I am done
    jmp L1			   ;else repeat loop
reset:
    lea esi,key		   ;esi reset to key first array location
    jmp L1			   ;go back and repeat the loop

done:
pop esi				   ;restore output buffer
pop edi				   ;restore input buffer
ret
decryptMsg endp


;early 1st version encrypter
;switched to decryptMsg because it preformed both encryption and decryption
;not comment needed not used in this program
;xorKeyMsg proc
;push edi
;push esi
;lea edi,message
;lea esi,key
;L1:
;    mov al,[edi]
;    cmp al,0dh
;    je done
;    mov bl,[esi]
;    cmp bl,0dh
;    je reset
;    xor al,bl
;    mov [edi],al
;    inc edi
;    inc esi
;    jmp L1
;reset:
;    lea esi,key
;    jmp L1
;
;done:
;pop esi
;pop edi
;ret
;xorKeyMsg endp


;write message encrypte or decrypted to output buffer
writeMessage proc
push edi				   ;save input buffer
lea edi,message		   ;edi = message array

L1:
    mov al,[edi]		   ;message location move into al
    mov [esi],al		   ;message location moved into output buffer esi
    cmp al,LF			   ;check if message location is equal to LF 
    je L2				   ;jump to L2 when al == LF
    inc edi			   ;next message location
    inc esi			   ;next output buffer location
    jmp L1			   ;repeat loop

L2: 
    inc esi			   ;when al is equal to line feed inc once and get out of here

pop edi				   ;restore input buffer
ret
writeMessage endp


;read message from input buffer
readMessages proc
push esi				   ;save output buffer
lea esi,message		   ;esi = message arrray
L1:					   ;loop start for reading message
    mov al,[edi]		   ;al = input buffer location value
    mov [esi],al		   ;message buffer = input buffer value
    cmp al,0dh			   ;check if end of message in input buffer is reached
    je ending			   ;if we are at the end then jump to ending
    add messageSZ,1		   ;add 1 to message size
    inc edi			   ;mov to next input buffer location
    inc esi			   ;mov to next message buffer location
    jmp L1			   ;uncoditional loop

ending:				   ;when CR is reached then do this
    inc edi			   ;next input buffer location
    inc esi			   ;next message buffer location
    mov al,[edi]		   ;mov LF into al from input buffer
    mov [esi],al		   ;mov LF into message buffer
    inc edi			   ;next intput buffer location
    pop esi			   ;restore output buffer
ret
readMessages endp

;code to read in encryption key from input buffer
readKeys proc
push esi				   ;save output buffer
lea esi,key			   ;esi = key array
L1:					   ;loop start for reading key
    mov al,[edi]		   ;al = input buffer location
    mov [esi],al		   ;key buffer location value = intput buffer location value
    cmp al,0dh			   ;check if end of key in input buffer is reached
    je ending			   ;if we are at the end then jump to ending
    add keySZ,1		   ;increase key size with each pass
    inc edi			   ;next input buffer location
    inc esi			   ;next key buffer location
    jmp L1			   ;uncoditional loop

ending:				   ;when CR is reached then do this
    inc edi			   ;next input buffer location	   
    inc esi			   ;next key buffer location
    mov al,[edi]		   ;mov LF from input buffer into AL
    mov [esi],al		   ;mov LF into key buffer location value
    inc edi			   ;next input buffer location
    pop esi			   ;restore output buffer
ret
readKeys endp

;code to read in data from file to a buffer array
readIn PROC
;reused code. contains ugly comment placement
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
mov ecx,617
;read in 617 bytes
call ReadFromFile
;call readFromFile to do the work
ret
readIn ENDP

;code to read out data to a file from a buffer array
writeOut proc
;reused code. contains ugly comment placement
;read in all of the data at 1 time
lea edx,outname
;output file name is moved to edx
call CreateOutputFile
;create the file
mov outfile,eax
;mov file handler to outfile
lea esi,outBuff
;assign beginning of print data to esi
mov ecx,1328
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

END MAIN