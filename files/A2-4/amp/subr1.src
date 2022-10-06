 ;in-r1-count
chdec:		;mov		r1,#chavt		;chavt-1
			mov		a,@r1
			mov		r4,a
			inc		r1
			mov		a,@r1
			mov		r5,a
			clr		rr2
			clr		rr3
			mov		dptr,#ch1	 
			call	ldc_ltemp
			call	lsub
			mov		a,r5
			mov		@r1,a
			dec		r1
			mov		a,r4
			mov		@r1,a
			ret	 



;пп выдачи на индикатор 12 байт   bufind..bufind+11
 ind:	 mov		r0,#bufind+11
		 mov		r7,#12
 nexin:	clr		p0.6
		mov		a,@r0
		mov		SPI0DAT,a
		jb		TXBSY,$
		setb	p0.6
		call	z_9
		dec		r0
		djnz	r7,nexin
	   ret

zapadc:   mov R2,#8
sdv:      setb P1.7
          rlc A
		mov P1.6,C
		call tim2
				
		clr P1.7
		call tim2
		djnz R2,sdv
		setb P1.6
		ret

chtadc:   mov R2,#8
sdv1:     setb P1.7
          call tim2
		clr P1.7
		mov C,P1.6
		rlc A
		call tim2
		djnz R2,sdv1
		ret

tim:      mov R6,#30h;38h
tim1:     djnz R6,tim1
          ret
          
tim2:     mov R6,#10h;14h
tim3:     djnz R6,tim3
          ret

;запись из acc
write_x1: clr	c
writeD_x1:
		  mov P3.1,c        ;запись
          mov P2,A
		  setb P3.3
		  call z_5
		  clr P3.3
		  mov P2,#0FFh
		  ret

;чтение в acc
read_x2:  clr	c  
          mov P3.1,c        ;чтение
          setb P3.2
		  setb P3.3
		call z_5
		  mov A,P2
		  clr P3.3
		  clr P3.2
		  ret


loop:     call read_x2;x2    ;ожидание флага готовности
		  jb ACC.7,loop     ;переход на чтение, если бит А(7)=1
		   ret           ;возврат, если бит А(7)<>1
				 
				   

;задержка 100 мкс
z_100:    mov R1,#78h     ;загрузка первого числа
z100:     mov R2,#2h     ;загрузка второго числа
count:    djnz R2, count;декремент R2 и внутренний цикл, если R2<>0 	
          djnz R1, z100 ;декремент R1 и внутренний цикл, если R1<>0
          ret           

;задержка 34 мкс
z_5:      mov R3,#8Bh      ;загрузка числа
ct:       djnz R3,ct
          ret

;задержка 15 мс
z_15:     mov R1,#0FAh    ;загрузка первого числа
z15:      mov R2,#0EDh   ;загрузка второго числа
zz:       djnz R2, zz 	;декремент R2 и внутренний цикл, если R2<>0
          djnz R1, z15  ;декремент R1 и внутренний цикл, если R1<>0
          ret   
					  
;????????
;задержка 1с
z_1s:   mov		r5,#01fh 
co2s:	mov 	R6,#0ffh     
z1s:     mov 	R7,#0ffh     
co1s:   djnz 	R7, co1s	
        djnz 	R6, z1s 
		djnz	r5,co2s
          ret           

 z_ss:   mov		r5,#06fh 
coss:	mov 	R6,#0ffh     
zss:     mov 	R7,#0ffh     
cozs:   djnz 	R7, cozs	
        djnz 	R6, zss 
		djnz	r5,coss
          ret           
;dptr+4-приемник
;dptr-источник
;r7-кол байт  
xCIKLWR:
			mov		r7,#4	
lwrx:	movx	a,@dptr
			push	dph
			push	dpl
			inc		dptr
			inc		dptr
			inc		dptr
			inc		dptr
			movx	@dptr,a
			pop		dpl
			pop		dph
			
			inc		dptr
			djnz	r7,lwrx
			ret
;r2..r5->@dptr..@dptr+3				
saveIr2:		mov	a,r2
					movx	@dptr,a
					inc	dptr
					mov	a,r3
					movx	@dptr,a
					inc	dptr
					mov	a,r4
					movx	@dptr,a
					inc	dptr
					mov	a,r5
					movx	@dptr,a
					ret
;r2..r5-> @r0..@r0+3

saver2:		mov	a,r2
					mov	@r0,a
					inc	r0
					mov	a,r3
					mov	@r0,a
					inc	r0
					mov	a,r4
					mov	@r0,a
					inc	r0
					mov	a,r5
					mov	@r0,a
					ret 
;r8..r11-> @r0..@r0+3

saver8:		mov	a,r8
					mov	@r0,a
					inc	r0
					mov	a,r9
					mov	@r0,a
					inc	r0
					mov	a,r10
					mov	@r0,a
					inc	r0
					mov	a,r11
					mov	@r0,a
					ret 

clmassix:	mov			r7,#28h
			mov     dptr,#MASS0        ;забить массив A нулями
clmax:  	mov	     a,#00h
             movx    @dptr,a
             inc     dptr
            djnz		r7,clmax                
             mov     chmas,a
             clr     bitmas
            ret

;r1-яЁшхьэшъ
;r0-шёЄюўэшъ
;r7-ъюы срщЄ  
CIKLWR:
			mov		r7,#4	
lwr:	mov	a,@r0
			mov	@r1,a
			inc		r1
			inc		r0
			djnz	r7,lwr
			ret	
;r2..r5-> @dptr..@dptr+3

zmul:	call	maform
		call	lmul
		call	bform
		ret

zdiv:	call	maform
		call	divide
		call	bform
		ret

maform:	mov a,r2
    	rlc a
    	jnc 		fo1m
		setb		znmat
		call   form4
		ret
fo1m:	clr		znmat
		ret

bform:	jnb		znmat,fo2m
		call	form4
fo2m:	ret
  
;r2..r5 яхЁхтхёЄш т фюя ъюф
form4:  	mov a,r5
    	cpl a
    	add a,#1
    	mov r5,a
    	mov a,r4
    	cpl a
    	addc    a,#0
    	mov r4,a
    	mov a,r3
	    cpl a
    	addc    a,#0
    	mov r3,a
    	mov a,r2
    	cpl a
    	addc    a,#0
    	mov r2,a
    	ret

zcmp:	call		maform
		call		lcmp
		push		psw
		call	bform
		pop		psw
		ret


;@r0..@r0+3->r8..r11

resar8:	mov	a,@r0
		mov	ltemp,a
		inc	r0
		mov	a,@r0
		mov	ltemp+1,a
		inc	r0
		mov	a,@r0
		mov	ltemp+2,a
		inc	r0
		mov	a,@r0
		mov	ltemp+3,a
		ret

;
;r0- рфЁхё _ўхщъш єяръютрээюую фтюшўэюую ўшёыр  
;r2,a фтюшўэюх ўшёыю 2 срщЄр 
;т_ї- @r0 єяръютрээюх фхё_Єшўэюх ўшёыю BCD 3 срщЄр 
;r2 a    ўшёыю 180
;00 b4
;т_ї- mabin..mabin+2
;     80 01 00
 
cond:	xch	a,r0	
		mov	r1,a
		xch	a,r0
		mov	r4,#03
dcoa:	mov	@r1,#00
		inc	r1
		djnz	r4,dcoa
		mov	r3,#10h
dcob:	clr	c
		rlc	a
		xch	a,r2
		rlc	a
		xch	a,r2
		xch	a,r0
		mov	r1,a
		xch	a,r0
		mov	r4,#03
		mov	r5,a
dcoc:	mov	a,@r1 
		addc	a,@r1
		da	a
		mov	@r1,a
		inc	r1
		djnz	r4,dcoc
		mov	a,r5
		jc	dcod
		djnz	r3,dcob
		clr	c
dcod:	nop
		ret

move28:	mov	ltemp,r2			;r2..r5->ltemp
		mov	ltemp+1,3
		mov	ltemp+2,4
		mov	ltemp+3,5
		ret

;@r0..@r0+3->r2..r5

resar2:	mov	a,@r0
		mov	r2,a
		inc	r0
		mov	a,@r0
		mov	r3,a
		inc	r0
		mov	a,@r0
		mov	r4,a
		inc	r0
		mov	a,@r0
		mov	r5,a
		ret

;25mkc !!!!!!!!!!!!!!!1
z_9:      mov R3,#4Bh      ;загрузка числа
	       djnz R3,$
          ret

;запись   передаваемый байт в acc
;передача байта послед кодом старшими разрядами  вперед
write:	   mov R2,#8
			clr  c	
wr1:    	clr		P1.2
		    nop 
			rlc A
			mov P1.1,C
		   call tim2
		   setb P1.2
           call tim2
		  djnz R2,wr1
		  clr P1.1
		 ret

;принимаемый байт в acc
;прием байта последовательным кодом старшими разрядами вперед
read:    mov R2,#8
re1:     clr P1.2
         call tim2	  ;5mks
		mov C,P1.0
		rlc A		
		setb P1.2
		call tim2
		djnz R2,re1
		ret

 ;in r0-count	
;r10,r11-значение с котоым сравнивается счетчик
;r2..r5 -значение счетчика
chcmp:;	mov		 r0,#chavt					;>=7500(1d4ch
		mov			a,@r0
		mov			r4,a
		inc			r0
		mov			a,@r0
		mov			r5,a
		mov			r3,#0
		mov			r2,#0
		mov			r8,#0;clr			r8
		mov			r9,#0;clr			r9
		call		lcmp
		ret



ch0:	db	00,00,00,00
ch10:	db	00,00,00,0ah		        	;10
ch5:	db	00,00,00,05						;5
ch954:	db 00,00,03,0b9h						;954
ch10000:	db 00,00,03h,0e8h						;10000
ch100:	db 00,00,00,64h	;100
ch2:	db	00,00,00,02						
;CH_953:	db 3fh,74h,37h,72h;0,953971
;CH_953:	db 3fh,74h,1ch,71h;0,953558
;CH_953:	db 3fh,74h,02,0d2h;0.953168
ch1:	db  00,00,00,01
ch_1:	db	3fh,80h,00,00			
CH_953:	db 3fh,74h,1eh,0dfh		;0,953596
CHtho:	db	47h,0c3h,50h,00;48h,43h,50h,00;30d40 h	-000	
ch_220:	db  48h,56h,0d8h,00;220000 -035b60 h
ch_200:	db  48h,56h,0d8h,00;200000 -030d40 h
ch_10th:db  46h,1ch,40h,00;10000-2710h