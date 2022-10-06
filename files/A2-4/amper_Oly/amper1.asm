$include (c8051f310.inc)               ; Include register definition file.

NAME	MAIN

			org 0h;    cseg AT 0
           jmp begin;;;;Main               ; Locate a jump to the start of code at 
					
						org 3
						reti
						org 0bh
						reti
						org 13h
						reti
						org 1bh
						reti
						org 23h
						reti
						org 2bh
						reti
						org 33h
						reti
						org 3bh
						reti
						org 43h
						reti
						org 4bh
						reti
						org 53h
						reti
						org 5bh
						
						reti
						org 63h
						reti
						org 6bh
						reti
						 org 73h
						reti
						
Main         SEGMENT  CODE
						

             rseg     Main          ; Switch to this code segment.

             using    0              ; Specify register bank for the following

org 100h
;$EJECT

begin:	     ;;;;;;;;;;;;;;;;;;;;
					 mov  sp, #0e0h
					 mov	PCA0L,#0
					 mov PCA0MD, #00000000b
					 mov p0mdout,#00000000b;
					 mov p1mdout, #10111111b;
					 mov p2mdout, #00111111b;
					 mov p2mdin, #11111111b;
					 mov p3mdout, #00010111b;00000000b
					 mov P0MDIN,#11110010b;
					 mov P3MDIN,#00010111b;; #11111111b
           mov p0skip, #10001101b;
				mov	P1SKIP,#00001111b;00001110b
				mov P1MDIN, #11110000b;11110001b
					 mov xbr0,#00000101b	;10100101b
					 mov XBR1, #01000010b;01000000b
					 mov IT01CF, #00000000b

          
					 mov smb0cf, #11000010b 
 mov SCON0,#10h                                   
	                                                                  
           mov  TMOD, #00100010B		;регистр режимов
					 mov CKCON, #00110000b    ;сист частота/12                 ; Установка таймера
					 mov th0,#0f9h
					 mov tl0,#0f9h 
					 MOV EIE1,#10000000B;разрешение прер по индикации

					 mov amx0p,#00010011b
					 mov amx0n,#00011111b
					 mov adc0cf,#11111000b
					mov adc0cn,#10000000b;;;;;;;;
					 mov oscxcn,#11100111b
gener:     mov a, oscxcn
           cjne a,#11100111b,gener
mov clksel,#00000001b                    
					 mov OSCICN,#01000011b 
					 mov tmr2rll,#0
					 mov tmr2rlh,#0d1h
					 ;mov tmr2h,#68h;d1h;TIMER2           
           mov tmr2cn,#00001100b
					 clr tmr2cn.6
					 mov tmr3l,#0cch
					 mov tmr3h,#0f8h
					 mov tmr3rll,#0cch
					 mov tmr3rlh,#0f8h
					 mov tmr3cn,#00000100b
           setb  TCON.6			;регистр управления
					 setb tcon.4
					mov	VDM0CN,#80h		;упр монитором питания
					mov	RSTSRC,#02h		;источники сброса
				 mov ie,#10000000b	;Снятие блокировки всех прерываний
           
           ;setb  IP.5                                                   ;Присваивание таймеру 1 высшего приоритета
         ;  mov  TL1, #0			;Занесение константы в младший байт таймера 1
         ;  mov  TH1, #0fah;f2h		;Занесение константы в старший байт тайм
							mov	sp,#0e0h
							mov	IE,#90h			;d4-прер по интерф
							;;;;;;;;;;;
							setb	IP.4
						mov  TL1, #0			;Занесение константы в младший байт таймера 1
           	mov  TH1, #0d0h;;f2h		;Занесение константы в старший байт таймера 1
				
			

					mov pca0cph2, #080h
					 mov pca0cpl2, #080h
          			 mov pca0md, #00000101b
					 mov pca0cpm0, #00100000b
					 mov pca0cpm1, #00100000b
					 
					 mov pca0cpm2, #00000011b
					 mov	CPT1CN,#10000000b
					 mov	CPT0CN,#10000000b
					mov		REF0CN,#00000010b
					mov	adc0h,#0
					mov	adc0l,#0


;;;;;;;;;;;;;;;;;;;;;;;;;

			





;;;;;;;;;;;;;;;;;;;;;;;;;;
END
						