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
					 mov p0mdout,#00000000b;$$$$$$$$$$$$$$$$$$$
					 mov p1mdout, #10111111b;
					 mov p2mdout, #00111111b;
					 mov p2mdin, #11111111b;
					 mov p3mdout, #00010111b;00000000b
					 mov P0MDIN,#11110010b;  $$$$$$$$$$$$$$$$$$$$$
					 mov P3MDIN,#11111111b
           mov p0skip, #10001101b;$$$$$$$$$$$$$$$$$$$$$$$$
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
				 mov ie,#00000000b	;Снятие блокировки всех прерываний
           
          	
					
					 ;setb  IP.5                                                   ;Присваивание таймеру 1 высшего приоритета
         ;  mov  TL1, #0			;Занесение константы в младший байт таймера 1
         ;  mov  TH1, #0fah;f2h		;Занесение константы в старший байт тайм
							mov	sp,#0e0h
						;	mov	IE,#90h			;d4-прер по интерф
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

;;;;;;;;;;;;;;;;;
start: 



        mov R1,#2Eh
clean:  CLR A
        mov		@R1,a
        inc		R1 
				cjne	R1,#4Eh,clean
				call ind
      	mov		R1,#2eh
mm:			mov a,#2Dh

  			mov		@R1,a
				inc		R1
				cjne	R1,#31h,mm
				mov R2,#30h
mm1:		mov a,R2
      	mov		@R1,a
        inc R2
				inc R1
      	cjne	R2,#3Ah,mm1
mm2:		mov a,#2Dh
    	  mov		@R1,a
				inc R1
      	cjne	R1,#4Eh,mm2
       
				call ind

        call onesec
       
       
        mov R1,#2Eh
mm3:    mov a,#20h
    		mov		@R1,a
				inc		R1
				cjne	R1,#32h,mm3
        mov a,#55h
	    	mov		@R1,a
      	inc		R1
        mov a,#3Dh
      	mov		@R1,a
        inc		R1
        mov a,#0FFh
      	mov		@R1,a
      	inc		R1
        mov a,#2Eh
	    	mov		@R1,a
      	inc		R1
mm4:    mov a,#0FFh
    		mov		@R1,a
				inc		R1
				cjne	R1,#3Ah,mm4
mm5:		mov a,#20h
    		mov		@R1,a
				inc		R1
				cjne	R1,#3Eh,mm5
        mov a,#0b8h
      	mov		@R1,a
        inc		R1
        mov a,#0b7h
      	mov		@R1,a
        inc		R1
        mov a,#0bch
      	mov		@R1,a
        inc		R1
        mov a,#65h
      	mov		@R1,a
        inc		R1
        mov a,#70h
      	mov		@R1,a
        inc		R1
        mov a,#65h
      	mov		@R1,a
        inc		R1
        mov a,#0bdh
      	mov		@R1,a
        inc		R1
        mov a,#0b8h
      	mov		@R1,a
        inc		R1
        mov a,#65h
      	mov		@R1,a
        inc		R1
mm6:   	mov a,#20h
    		mov		@R1,a
				inc		R1
				cjne	R1,#4Eh,mm6

        call ind

        call onesec

      

        mov R1,#34h
        
mmm:		mov @R1,#30h
        MOV A,R1
				xchd A,@R1
					call ind	
        inc		R1

	      cjne	R1,#39h,mmm
				;		call ind
				jmp start  	


;;;;;;;;;;;;;;;


  
         
ind:				 
				  clr P3.4
					call z_100         ;строб
					setb P3.4

					clr P3.3

          call z_15         ;задержка 15 мс
          clr c          ;установка регистра команд
          mov A,#30h     ;устанавливаем разрядность шины
					call x1              ;переход к записи
					call z_15         ;задержка 15 мс
					call x1               ;переход к записи
					call z_100        ;задержка 100 мкс
         
					call x1               ;запись
         
					call loop                     ;проверка флага BF

          mov A,#38h     ;устанавливаем режим развертки изображения в две строки
        	call x1               ;запись
        	call loop                     ;проверка флага BF

        	mov A,#06h     ;устанавливаем режим автоматического перемещения курсора слева-направо после вывода каждого символа 
         	call x1               ;запись
					call loop                     ;проверка флага BF 

          mov A,#02h     ;начало строки адресуется в начале DDRAM
					call x1               ;запись
					call loop                     ;проверка флага BF

          mov A,#0Ch     ;включаем отбражение на экране ЖКИ-модуля, без отображения курсоров
					call x1               ;запись
					call loop                     ;проверка флага BF
          
			
	
  			
				
      		mov R0,#2Eh       ;загрузка счетчика

M2:	    	call	loop
					setb c         ;установка регистра данных
          
					mov A,@R0      ;пересылаем содержимое R0 в аккумулятор
          call x1               ;запись
          inc R0          ;инкремент счетчика
		
				  cjne R0,#3Eh,M2  ;сравнение аккумулятора с константой и переход, если не =0  

         	

f5:		   
          clr c          ;установка регистра команд
		  	  call loop                     ;проверка флага BF
  			  mov A,#0C0h 
        	call x1               ;запись
					call loop                     ;проверка флага BF

  				mov R0,#3Eh      ;загрузка счетчика

M3:		  	call	loop                    ;проверка флага BF
        	setb c        ;установка регистра данных
        	mov A,@R0     ;пересылаем содержимое R0 в аккумулятор
         	call x1               ;запись
         	inc R0          ;инкремент счетчика
			
					cjne R0,#4Eh,M3  ;сравнение аккумулятора с константой и переход, если не =0
			
					ret

			 
       
;подпрограммы

;задержка 1 с
onesec:   mov R3,#42h
z_1:      call z_15
          djnz R3,z_1
          ret

;задержка 0.5 с
z_500:    mov R3,#21h
z500:     call z_15
          djnz R3,z500
          ret

;задержка 15 мс
z_15:     mov R1,#0FAh    ;загрузка первого числа
z15:      mov R2,#0EDh   ;загрузка второго числа
zz:       djnz R2, zz 	;декремент R2 и внутренний цикл, если R2<>0
          djnz R1, z15  ;декремент R1 и внутренний цикл, если R1<>0
          ret           ;возврат
					 				    

;задержка 100 мкс
z_100:    mov R1,#78h     ;загрузка первого числа
z100:     mov R2,#2h     ;загрузка второго числа
count:    djnz R2, count;декремент R2 и внутренний цикл, если R2<>0 	
          djnz R1, z100 ;декремент R1 и внутренний цикл, если R1<>0
          ret           ;возврат

;задержка 34 мкс
z_5:      mov R3,#8Bh      ;загрузка числа
ct:       djnz R3,ct
          ret


;задержка 2 мкс
z_2:      mov R3,#4h      ;загрузка числа
ct2:       djnz R3,ct2
          ret

x1:       mov P3.1,c        ;запись
          mov P2,A
			 	  setb P3.3
				
			    call z_5
					
				  clr P3.3
				  mov P2,#0FFh
				  ret



x2:    
          mov P3.1,c        ;чтение
          setb P3.2
				  setb P3.3
					call z_2
				  mov A,P2
				  clr P3.3
				  clr P3.2
				  ret


				 
				 
loop:     call x2       ;ожидание флага готовности
				  jb ACC.7,loop     ;переход на чтение, если бит А(7)=1
			    ret           ;возврат, если бит А(7)<>1
				 
				   


END
						