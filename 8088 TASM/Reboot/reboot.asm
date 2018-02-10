;------------------------------------------------------------------;
;Written by: John Knowles (jknowle2@my.athens.edu)                 ;
;Date: October 7, 2017                                             ;
;Project: 8088 16bit compatible reboot command for IBM XT clones   ;
;Development Tool: GUI Turbo Assembler x64 Ver 3.0.1 using TASM 4.1;
;Description:                                                      ;
;   Write an assembly program that allows users of old 16bit       :
;machines to reboot using a command. This is more pleasing to users;
;of the windows and linux world. CTRL-ALT-DEL reboots give the feel;
;of pressing a hard reset key. This is also for use on my old      ;
;Kaypro Professional Computer clone of the IBM XT.                 ;
;------------------------------------------------------------------;
.MODEL small
   .STACK 100h  
   .DATA
   RebootMessage DB 'Rebooting!',13,10,'$'
   .CODE
   
main proc
    
    mov  ax,@data
    mov  ds,ax                   ;set DS to point to the data segment

    mov  ah,9                    ;DOS print string function
    mov  dx,OFFSET RebootMessage ;point to "Rebooting!"
    int  21h                     ;display "Rebooting!"
    
    call delay
    call delay
    call delay
    call delay
       
    int 19h                       ;reboot interrupt
   
main endp


;-------------------------------------------------------;
;Procedure:                                             ;
delay proc                                              ;
;Description:                                           ;
;   Waste time before rebooting. This helps to make the ; 
;rebooting process seem seamless and natural.           ;
;-------------------------------------------------------;
    MOV     CX, 0FH                
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
delay endp


end main

