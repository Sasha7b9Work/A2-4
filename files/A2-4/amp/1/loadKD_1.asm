  $include (c8051f020.inc)               ; Include register definition file.
	
NAME	MAIN
		
			org 0h;    cseg AT 0

            jmp begin;!!!!!!!!!!!1Main               ; Locate a jump to the start of code at 
					
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

						org	93h
						reti;jmp	keyb1		;IE6

						org	9bh
						reti;jmp	keyb2	   ;IE7



 
  

TMR2RLL  DATA 0cah;    // TIMER 2 RELOAD LOW                                       */
TMR2RLH  DATA 0cbh;    // TIMER 2 RELOAD HIGH 
 
						
Main         SEGMENT  CODE

				DSEG
  
bufind	DATA	40h;буффер индикации 12byte	(коды koi и коды букв )
;DATA 4ch
abin		DATA	4fh;4byte
adec		DATA	53h;10byte
chmas		DATA	6eh;
mabin		DATA	6fh
reacp		DATA	77h;результат чтения асп 4byte int (hex)

  
chkl		DATA	3dh		;счетчик задержки клавиатуры 2bait                         
chmasN		DATA	3fh		;n=2,n=10 суммирование n значений	
	
cellbit		DATA	20h
bitznak		BIT 	cellbit.0	;20.0		
bitmas		BIT 	cellbit.1	;20.1 бит заполнения массива		
znmat		BIT		cellbit.2	;20.2
bitrs		BIT		cellbit.3	;20.3
bitizm		BIT		cellbit.4	;20.4 вкл реж измерения
bitavp		BIT		cellbit.5	;20.5  бит режима avp
bitvi11		BIT		cellbit.6	;20.6	бит режима выч R
bitzus		BIT		cellbit.7	;20.7;флаг задержки	после установки us

cellbit1		DATA	21h
bitbuf		BIT 	cellbit1.0	;21.0		
bitprd		BIT 	cellbit1.1	;21.1  выдача вкл	
bitbon		BIT		cellbit1.2	;21.2  буфер вкл
bitmem		BIT		cellbit1.3	;21.3
bmem11		BIT		cellbit1.4	;21.4  	 бит ПАМ11
bmem12		BIT		cellbit1.5	;21.5    бит ПАМ12
bmem13		BIT		cellbit1.6	;21.6	бит ПАМ13	 
bitnul		BIT		cellbit1.7	;21.7 бит кнопки НУЛЬ

cellbit2		DATA	22h
bitt2		BIT 	cellbit2.0	;22.0 уст признак Tизм2		
bitmenu		BIT 	cellbit2.1	;22.1  бит режима меню(нажата кн меню)	
bitvi12		BIT		cellbit2.2	;22.2  
bitvi13		BIT		cellbit2.3	;22.3
bitvich		BIT		cellbit2.4	;22.4  	 1-е нажатие кн ВЫЧ R (режим ВЫЧ R)
bitvi21		BIT		cellbit2.5	;22.5    
bitvi31		BIT		cellbit2.6	;22.6	бит ПАМ13	 
;bitnul		BIT		cellbit2.7	;22.7 бит кнопки НУЛЬ	

	

rez_Ame   data 5eh;	 (РЕЗ1-AN)*K
rez_A	 data 62h	;РЕЗ сумма 100 (10)отсчетов измерения	 
rez_A1  data 66h	;РЕЗ1  среднее по массиву из 2,10 ти элементов int (hex)
rez_A0  data 6ah;
rez_A2	 data 7bh; A2

chinkor  data  98h;98..99;80h		;счетчик интервала коррекции  2byte
chavt	 data  81h		;счетчик автокалибровки	 2byte
chdel	 data  83h		; счетчик задержки
;float
kor0_AN	 data  84h		;4byte	AN
rezAp	 data  88h		;4byte	A+
rezAm	 data  8ch		;4byte	A-
koefKp	 data  90h		;4byte	K+
koefKm	 data  94h		;4byte 	K-
;hex 
parT	 data  9ah		;параметр времени измерения
chbefore data  9bh		;счетчик предварительного суммирования
rez_A3   data  9ch		;A3
;FLOAT
koefKD	data  0a0h	   ;KD
constE	data  0a4h	   ;E
constF	data  0a8h	   ;F
chind	data  0ach	   ;счетчик индикации
chbuf	data  0adh	   ;счетчик периода загрузки в буфер и интерфейс
diap	data  0aeh	   ;номер диапазона
parN	data  0afh	   ;N
level	data  0b0h		;уровень в меню, выч	,Tизм
vichR	data  0b1h		;параметр =11,12,13,21
marker  data  0b2h	   ;номер мигающего знакоместа
;data  0b3h
;внешнее ОЗУ 64K 
;		XSEG AT 100h											 
	PUBLIC 	  MASS0
MASS0  xdata 0080h;
MASS1  xdata 0084h;
MASS2  xdata 0088h;
MASS3  xdata 008ch;
MASS4  xdata 0090h;
MASS5  xdata 0094h;
MASS6  xdata 0098h;
MASS7  xdata 009ch;
MASS8  xdata 00a0h;
MASS9  xdata 00a4h;
;xdata 0038h;

 			rr0		EQU 00
		rr1	  equ	01
		rr6   equ 06
		rr2	  equ	02
		rr3	  equ	03
		rr7   equ 07

		r8   equ 08
		r9	  equ	09
		r10	  equ	10
		r11   equ 11

		
   
             rseg     Main          ; Switch to this code segment.

             using    0              ; Specify register bank for the following

org 100h
;$EJECT

begin:	   mov  sp, #0e0h
					mov		PCA0L,#00;=0x00;
					mov	PCA0MD,#00;= 0x00;
					mov	P0MDOUT,#1fh;=0x1f;
					mov	P1MDOUT,#86h;8fh;=0x8f;
					mov	P2MDOUT,#00;=0x00;
	//P2MDIN=0xff;//11111111;
	//P3MDOUT =0xff;
	mov	P74OUT ,#0ffh;=0xff;
	mov	REF0CN,#03h;=0x03;
	
	mov	XBR0,#14h;= 0x14;
	mov	XBR1,#00; =0x00;
	mov XBR2,#00;=0x00;
 
	mov	WDTCN,#0deh;=0xde;	 //запрет работы WDT
	mov	WDTCN,#0adh;=0xad;                                   
	mov	TMOD,#22h;=0x22;	//регистр режимов
	mov	CKCON,#30h;=0x30; //сист частота/12     
	mov	TH0,#0f9h;=0xf9;//	; Установка таймера
	mov	TL0,#0f9h;=0xf9; 
	mov	EIE1,#80h;=0x80;

	mov	DAC0CN,#80h;=0x80;
	mov	DAC1CN,#80h;=0x80;
	mov	OSCXCN,#67h;=0x67;

 

gener:     mov a, oscxcn
           cjne a,#11100111b,gener
                       
  	mov	OSCICN,#88h;=0x84;
    mov TMR2RLL,#0;=0;
    mov	TMR2RLH,#0d1h;=0xd1;
  
		setb  TCON.6			;регистр управления
		 setb tcon.4

	mov	RSTSRC,#0;=00	;//источники сброса 

	;mov	IE,#80h;//10000000	;//Снятие блокировки всех прерываний
     mov	XBR2,#40h
	 mov	XBR0,#06h;16h
	mov		SPI0CN,#03
	mov		spi0ckr,#31H;;;;;;;;#04
;ozu
			clr	a
			mov	r0,#00h	
mecle:		mov	@r0,a 			;обнулить озу 256 байт
			inc	r0
			cjne	r0,#7fh,mecle
			mov	r0,#80h
meff:		mov	@r0,a 
			movx @r0,a
			inc	r0
			cjne	r0,#0dfh,meff
			call	clmassix
			mov		r0,#chinkor
			mov		@r0,#02;600;
			inc		r0
			mov		@r0,#58h;258h
			;;;;
			mov		r0,#chavt
			mov		@r0,#07h;2eh
			inc		r0
			mov		@r0,#0d0h;0e0h
			mov		r0,#parT
			mov		@r1,#2			;Tizm=1s
			mov		r1,#diap
			mov		@r1,#5			;10-7a
			mov		r1,#parN
			mov		@r1,#2
			;;;;;;
			mov		dptr,#ch_1		;1->r2..r5 float
			call	ldc_long
			mov		r0,#koefKp	   ;1(float)->koefKp
			call	saver2
			mov		r0,#koefKm		;1(float)->koefKm
			call	saver2
			 ;погасить индикатор
			mov		r0,#bufind
age1:
			mov		@r0,#0fdh;" ";0ffh   ;-----
			inc		r0
			cjne	r0,#bufind+11,age1		
			call	ind
		;чтение пам прогр(5000h) 1 страница(ffh)
;и запись во внешнее озу(0000h)
copyP:		  mov		ie,#00h
				mov		r1,#0			;
				mov		r2,#50h
				mov		r3,#00
				call	copyPP
				;внести изменения во внешн озу
				;KD=3f 80 00 00	(KD=1)
				mov		r7,#12		;diap
				mov		r1,#0
gowr:			mov		a,#00h
				movx	@r1,a
				inc		r1
				mov		a,#01h
				movx	@r1,a
				inc		r1
				mov		a,#86h
				movx	@r1,a
				inc		r1
				mov		a,#0a0h
				movx	@r1,a
				inc		r1
				djnz	r7,gowr
;стереть страницу пап прогр 
				mov		dptr,#5000h
				mov		r7,#0ffh
				call	cle256
;и запись в ячейки коэфф памяти прогр (3000h) 
				mov		r7,#0ffh
				mov		r1,#0				;external ram
				mov		dptr,#5000h
				call	wrpage
				jmp		$










			call	iniacp;инициализация acp
			call	loadUS		;us 10-7 A
			;зажечь все элементы индикации
			mov		r0,#bufind
ageon:	  	mov		@r0,#0feh;?
			inc		r0
			cjne	r0,#bufind+11,ageon		
			call	ind
			call	z_1s		;1sec
			
			call	z_ss
		   		;-7A
		   call	z_1s		;1sec
		   jmp	$

rebyte:		jb		p1.3,$
			jnb		p1.3,$
			mov		a,#11h
			call	write
			;чтение acp
			call	read	
			mov 	reacp+1,A	;старший байт 
			call	read	
			mov 	reacp+2,A	;средний байт 
			call	read
			mov 	reacp+3,A		;мл байт
		   ;;;;;;;;;;;
		   mov		r0,#reacp+1
		   mov		a,@r0
			jb		acc.7,znplus;
			setb	bitznak
			orl		a,#80h	;ост содерж яч 
			mov		@r0,a
				
mmm:		dec		r0;,#reacp
			mov		@r0,#0ffh
			jmp		goznak


labelA :	mov		r10,#0		
			mov		r11,#0
			mov		r0,#chkl
			call	chcmp
			jnz		no0key
			;разрешить ie6,ie7	 
		;	mov		EIE2,#30h ;EIE2.5,EIE2.4
		;	mov		EIP2,#30h
		   
no0key:		mov		r1,#chkl 
			call	chdec
			jb		bitizm,rebyte
			 ;буфер 2 выдать на индикацию
			 call	ind

			jmp		rebyte;???????????///
znplus:		clr	bitznak
			anl		a,#7fh;fdh			;+
			mov		@r0,a
			dec		r0;,#reacp
			mov		@r0,#00h
			
goznak:	
;;;;;;;;;;;;;
			mov 	r0,#reacp+3
			mov		a,@r0
			mov		r7,#5;6
sdvig3:		clr		c
			rrc		a
			djnz	r7,sdvig3 ;d7,d6,d5	  мл байт
			mov		r2,a	;сохр байт
			dec		r0		;	reacp+2
			mov		a,@r0
			push	acc
			clr		c
			mov		r7,#3;2
sdvig2:		clr		c
			rlc		a
			djnz	r7,sdvig2 ;d12..d11	 средний байт
			orl		a,r2
			mov		reacp+3,a;сформ мл байт
			pop		acc
			
			mov		r7,#5;6
sdvig1:		clr		c
			rrc		a
			djnz	r7,sdvig1 ;d15,d14	  ср байт
			mov		r2,a   ;сохр
			mov		a,reacp+1
			push	acc
		;;	push	acc
		   	mov		r7,#3;2
sdvig0:		clr		c
			rlc		a
			djnz	r7,sdvig0 ;	  d21..d16
			orl		a,r2
			mov		reacp+2,a	; сформ средний  байт
			pop		acc	  ;reacp+1
			;;;;;;;;;;;;;;
			jb		acc.7,sdvm
			clr		c
			mov		r7,#5;6
sdvig4:		clr		c
			rrc		a
			djnz	r7,sdvig4 ;	  d23,d22
			mov		reacp+1,a
			jmp		ankor;klmas
;;;;;;;;;;;;					
sdvm:		mov		r7,#5;6
sdvig6:		setb		c
			rrc		a
			djnz	r7,sdvig6 ;	  d23,d22
			mov		reacp+1,a				
; reacp..reacp+3-результат чтения асп(hex) 
;;;;;;;;;

   

			mov		r0,#parT	;параметр времени
			mov		r1,#chmasN
			cjne	@r0,#1,noparT1
			;РЕЗ+РЕЗ
			mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#rez_A+3
			call	ladd
			mov		r0,#chbefore
			cjne	@r0,#99,nobef99
			;РЕЗ/100
			MOV	   DPTR,#ch100 
			CALL   ldc_ltemp		 ; ltemp <-- 100
			call	divide
			mov		r0,#rez_A
			call	saver2		;сумма 100 отсчетов /100
			mov		@r1,#10		;chmasN (n)=10
			jmp		klmas		;загр в массив скользящее ср
nobef99:	inc		@r0		 	;chbefore
			jmp		rebyte;labelA;метка A
;сначала суммируем 100 знач (не выводим на индикатор не расп в скользящий массив )
;а потом уже располагаем  в скользящий массив  из n



noparT1:	cjne	@r0,#2,noparT2
			;РЕЗ+РЕЗ
			mov		r0,#chbefore
			cjne	@r0,#9,nobef99
			;РЕЗ/10
			mov		@r1,#10		;chmasN (n)=10
			jmp		klmas		;загр в массив скользящее ср

noparT2:	cjne	@r0,#3,noparT3
noparT3:	cjne	@r0,#4,noparT4
			mov		@r1,#10		;n=10
			jmp		klmas
noparT4:   mov		@r1,#2		;n=2

;загрузить А в массив из 2/10 значений
;;;;;;;;;;;;;;;
klmas:		 
			mov		r1,#chmasN
			cjne	@r1,#2,mas10
			MOV	   dptr,#MASS0
	        CALL	   xCIKLWR   	  ; MASS0 --> MASS1

			mov		r0,#rez_A
			call	resar2		;->r2..r5
		   	mov			dptr,#MASS0
	      call		saveIr2        		; R2-R5 --> MAS0
	 	
	      MOV	   dptr,#MASS1+3
	      CALL	 addx
		  jmp		endsum
mas10:  	mov			dptr,#MASS8
	        CALL		xCIKLWR	  	;MASS8->MASS9
			mov			dptr,#MASS7
	        CALL		xCIKLWR	  	;MASS7->MASS8
       		MOV	  dptr,#MASS6
	        CALL	   xCIKLWR 	   ; MASS6 --> MASS7
	        MOV	   dptr,#MASS5
	       
	       CALL	   xCIKLWR   	  ; MASS5 --> MASS6
	       MOV	   dptr,#MASS4
	       
	       CALL	   xCIKLWR   	  ; MASS4 --> MASS5
			mov			dptr,#MASS3

	       CALL		xCIKLWR	  	;MASS3->MASS4
      		MOV	   dptr,#MASS2
	       
	       CALL	   xCIKLWR 	   ; MASS2 --> MASS3
	       MOV	   dptr,#MASS1
	        
	      CALL	   xCIKLWR   	  ; MASS1 --> MASS2
	       MOV	   dptr,#MASS0
	      
	       CALL	   xCIKLWR   	  ; MASS0 --> MASS1

			
			mov		r0,#rez_A
			call	resar2		;->r2..r5
				;call	aform
				mov			dptr,#MASS0
	      call		saveIr2        		; R2-R5 --> MAS0
	 
	      MOV	   dptr,#MASS1+3
	      CALL	 addx
	      MOV	   dptr,#MASS2+3
	      CALL	 addx
	      MOV	   dptr,#MASS3+3
	     CALL	 addx
	      MOV	dptr,#MASS4+3
	      call	 addx
		MOV	   dptr,#MASS5+3
	     CALL	 addx
	      MOV	   dptr,#MASS6+3
	      CALL	 addx
	      MOV	   dptr,#MASS7+3
	     CALL	 addx
	     MOV	dptr,#MASS8+3
	      call	 addx
		MOV			dptr,#MASS9+3
	     call	 addx
	;23.03		
endsum:
				mov		r0,#chmas  		;0..n(0..2,0..10)
				inc		@r0
				mov		a,@r0	
				jb		bitmas,masfull		;массив заполнен 2/10 значениями
				
				cjne	a,chmasN,masx5
				setb	bitmas			;массив заполнен
				mov		r0,#chmas
				mov		a,@r0
masfull:		cjne	a,#2,nochn2
				MOV	   DPTR,#ch2;10 
				CALL   ldc_ltemp		 ; ltemp <-- 2
				jmp		mas5div

nochn2:			MOV	   DPTR,#ch10 
				CALL   ldc_ltemp		 ; ltemp <-- 10
				jmp		mas5div

masx5:			mov	ltemp+3,chmas			;массив не заполнен
				clr	a
				mov	ltemp+2,a
				mov	ltemp+1,a
  				mov	ltemp,a

mas5div:
				CALL	   zdiv;divide   			 ; R2-R5 =
			    		 ; = (MAS0+MAS1+MAS2+MAS3+MAS4)/5

			
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;получен результат 3 байта и знак
			mov		r0,#rez_A1
			call	saver2		 ;сохр среднее по массиву
			mov		chmasN,#0
 ;;;;;;;;;;;;
 ;;;;;;;;;;;;
 			clr		c
 			mov		r1,#parT
			mov		a,#2
			subb	a,@r1
			jnc		ankor		;T<3
			;A-=РЕЗ1				;T>3
			mov		r0,#rez_Ame
			call	saver2
			jmp		gotoKD

ankor:		mov		r10,#0		
			mov		r11,#0
			mov		r0,#chinkor
			call	chcmp
			jnz		nokorr
			;коррекция 0
			jmp	  	kornul

nokorr:		mov		r10,#00		;	chavt
			mov		r11,#00h
			mov		 r0,#chavt	
			call	chcmp		;сравн счетчик авто калибровки с 0h
			jnz		nonulavt	
			mov		r10,#02		
			mov		r11,#58h
			mov		r0,#chinkor
			call	chcmp
			jnz		noavk
			;автокалибровка
			jmp		autoka
;;;;;;;;;;
 gotoKD:		clr		c
 			mov		r1,#parT
			mov		a,#4
			subb	a,@r1
			jnc		afterK		;T<5
			;A1-=A-	*KD			;T>5
			
			mov		r0,#rez_Ame;->r2..r5   ???????????/
			call	resar2
			call	altof	;r2..r5->float		
			mov		r0,#koefKD;->r8..r11
			call	resar8
			call	flmul
			call	ftol			;float->int
			mov		r0,#rez_A1
			call	saver2
			mov		r0,#rez_A0;->r8..r11 hex
			call	resar8
			call	lsub		;A3=A-1-A0
			mov		r0,#rez_A3
			call	saver2
			jmp		labelB	
 ;;;;;;;;;;;
nonulavt:	mov		r1,#chavt	
 			call	chdec	;dec		@r1			;chavt-1
noavk:		mov		r1,#chinkor
			call	chdec 		; chinkor-1

			;;;;;;;;;;;;;;
			;;;;;;;;;;;;;
;(РЕЗ1-АN)*K
			mov		r0,#rez_A1;->r2..r5
			call	resar2
			call	altof	;r2..r5->float	6.06	
			mov		r0,#kor0_AN;->r8..r11
			call	resar8
			;;call	altof	;r2..r5->float
 			call	flsub
			mov		r0,#koefKp;->r8..r11
			mov		a,r2
			;jnb		acc.7,nminus
			jnb		bitznak,nminus
		
 			mov		r0,#koefKm;->r8..r11
nminus:		call	resar8
			call	flmul  ;результат в плавающем формате м.б. его сохранить?
			call	ftol			;float->int
			mov		r0,#rez_Ame
			call	saver2
 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;
afterK:			clr		P3.4
				nop
				nop
				setb	P3.4
;;;;;;;;;;;;;;
				call	altof			;r2..r5->float
				mov	dptr,#ch_220;220000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		rmo220		;A>220000
				mov		r0,#koefKD		;KD->r8..r11
				call	resar8
				call	flmul	  ;A1-=A-*KD  fl
				
				call	ftol			;float->int
				mov		r0,#rez_A1
				call	saver2
				call	altof			;r2..r5->float
				mov	dptr,#ch_200;200000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		mo220		;A>200000
				jnb		bitizm,goA2	
				jb		bitavp,yesavp	
noavp:			jb		bitvi11,yesvich
goA2:			 ;A2=A1-
				 mov		r0,#rez_A1
				call	resar2
				mov		r0,#rez_A2
				call	saver2
goA3A2:			 ;A3=A2-A0
				  mov		r0,#rez_A0
				call	resar2
				mov		r0,#rez_A3
				call	saver2
				;;;;;;
goonin:			mov		r0,#chind
				cjne	@r0,#0,nochi0
				clr		P3.4
				nop
				nop
				setb	P3.4	  ;??????????????????????/
				jmp		nop3_0

				jb		P3.0,nop3_0	;;;;;;;;;;;;;;;;;;;;;;;;;;
				mov		r0,#rez_A0		;r2..r5->rez_A0
				call	saver2			;ЗАПОМНИТЬ СМЕЩЕНИЕ НУЛЯ
				jmp		rebyte		;age2
 rmo220:		jmp		mo220


;;;;;;;;;;;;;;;;
yesavp:		   	mov	dptr,#ch_10th;10000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jc		noavp		;A>10000	
				mov		r0,#diap		;10-11
				cjne	@r0,#9,noavp
				dec		@r1		;переключ диапазон на 1 позицию вниз
				cjne	@r0,#0ffh,clmasv
				mov		@r0,#0
clmasv:		;сбросить массив
											 
			   jmp	   goonin

yesvich:  	;A2=E/A1-+F
				 mov		r0,#constE
				call	resar2
				  mov		r0,#rez_A1
				call	resar8
				call	fldiv
				 mov	r0,#constF
				call	resar8
				call	fladd
				mov		r0,#rez_A2
				call	saver2
				jmp		goA3A2

mo220:		   jnb		bitavp,indoll
			   jnb		bitizm,indoll
				mov		r0,#diap
				cjne	@r0,#0,nodi2
			   ;10-2
indoll:			;OLL
				jmp		goonin	

nodi2:		   inc		@r0	;переключить на 1 позицию вверх

				cjne	@r0,#10,nodi9
				dec		@r0
nodi9:			;сбросить массив
				setb	bitzus	;флаг задержки	после установки us						 
			   jmp	   goonin

nochi0:			dec		@r0			;СТИ-1
				jmp		labelB	

	
;;;;;;;;;;;;;;;

nop3_0:	;;	;rez_A-rez_A0
		;;			mov		r0,#rez_A0
		;;			call	resar8
		;;			call	lsub
		;;			mov		r0,#rez_A
		;;;			call	saver2
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 					mov		r0,#rez_A3	 ;A3 ->в десятич форму(6дес разрядов и в кои)
					call	resar2
					mov		dptr,#ch100		 
					call	ldc_ltemp	 
					call	zdiv		;rez_A3/100=r2..r5
				
					mov		a,r4
					jb		acc.7,aless0
					orl		a,#08			;rez_A>0 d11=1
					mov		DAC0H,a
									;мл байт
					mov		a,r5
					mov		DAC0L,a
					jmp		moveA3;goonind

no3parN:			cjne	@r1,#2,no2parN
					;в байт 0  записать пробел
					mov		r1,#bufind+6
					mov		@r1,#" "
					jmp		seeind;moveA3

no2parN:			;в байты 0 и 1 записать пробел
					mov		r1,#bufind+5
					mov		@r1,#" "
					inc		r1
					mov		@r1,#" "
					jmp		seeind;moveA3

aless0:				cpl		a
					anl		a,#0f7h		;d11=0
					mov		DAC0H,a
									;мл байт
					mov		a,r5
					cpl		a
					mov		DAC0L,a
;goonind:		   mov		r1,#parN	; ??????
;					cjne	@r1,#3,no3parN
					
moveA3:	
					mov		r0,#rez_A3;->r2..r5	  передать A3 в индикатор
					call	resar2
				
					call	maform
					mov		r0,#abin
					call	saver2
;;;;;;;;
					
					mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec
				
					mov		r0,#adec+9;разместить в буфер индикации
					mov		r1,#bufind+6
					mov		r7,#7
bufdec:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufdec
					mov		r0,#bufind+7
					mov		@r0,#2dh
					mov		r0,#bufind
					mov		@r0,#2bh
					jnb		znmat,nozzmi;bitznak,nozzmi
					mov		@r0,#2dh
nozzmi:				mov		r0,#bufind+8
					mov		@r0,#37h;"T";
					inc		r0
					mov		@r0,#"A";"E";
					inc		r0
					mov		@r0,#00h
					inc		r0;		mov		bufind+11
					mov		@r0,#0c0h
goonind:		   mov		r1,#parN	; ??????
					cjne	@r1,#3,no3parN
				
;moveA3:	
seeind:			call	ind
					    
         			mov		r0,# parT
					mov		r1,#chind
					cjne	@r0,#1,not1in
labelB:				mov		r0,#chbuf	  ;T=1
					cjne	@r0,#0,nobuf0
					jb		bitprd,yesprd	;передать   A3 в буфер
					jb		bitbon,yesbuf	;записать   A3 в буфер
					jmp		gocikle

yesprd:	;передать   A3 в буфер
					jmp		goonT
yesbuf:	;записать   A3 в буфер
goonT:			  	mov		r0,#parT
					mov		r1,#chbuf
					cjne	@r0,#1,nott1
				;	mov		@r1,#
					jmp		gocikle

nott1:				cjne	@r0,#5,nott5

					jmp		gocikle

nott5:		 clr		c
 			mov		r1,#parT
			mov		a,#4
			subb	a,@r1
			jnc		yestt5		;T<5
gocikle:	jnb		bitbuf,nofz					
				 ;0,5c
			clr	bitbuf
nofz:		jmp 	labelA;rebyte

yestt5:		jmp		gocikle

nobuf0:				dec		@r0
					jmp		gocikle


not1in:				cjne	@r0,#2,not2in
					mov		@r1,#1		 ;T=2
					jmp 	labelB

not2in:				cjne	@r0,#3,not3in
					mov		@r1,#9		;T=3
					jmp 	labelB
not3in:				mov		@r1,#19
					jmp 	labelB



;коррекция 0
KORnul:		mov		r0,#chdel
			cjne	@r0,#0,nonuldel
				
			mov		a,P5	   ;p5.3=1
			orl		a,#08
			mov		P5,a
			nop
			nop
				
			mov		a,P5		  ;p5.0=0
			anl		a,#0feh
			mov		P5,a
			jmp		chdelmo

nonuldel:  	cjne	@r0,#40,no4del
			;рез ->AN
		;	mov		r0,#rez_A;->r2..r5
		;	call	resar2
			mov		a,reacp		;r2..r5	&&&&&&&&&&&
				mov		r2,a
				mov		a,reacp+1
				mov		r3,a
				mov		a,reacp+2
				mov		r4,a
				mov		a,reacp+3
				mov		r5,a
				;;;;;;;;;;
			call	altof		;r2..r5->float
			mov		r0,#kor0_AN;->kor0_AN
			call	saver2
				
			mov		a,P5	   	;p5.0=1
			orl		a,#01
			mov		P5,a
			nop
			nop
				
			mov		a,P5			;p5.3=0	
			anl		a,#0f7h
			mov		P5,a			
			
chdelmo:	mov		r0,#chdel
			inc		@r0		;chdel+1
			jmp		 rebyte

no4del:		cjne	@r0,#80,chdelmo
			mov		@r0,#0		;chdel
			mov		r0,#chinkor
			mov		@r0,#02;600;
			inc		r0
			mov		@r0,#58h;258h
			jmp		 rebyte

;автокалибровка
autoka:	 ;;  mov		r0,#chavt
		 ;;  call		chcmp
		 ;;  jz		nulavt
		;;   mov		r1,#chavt
		;;   call		chdec;chavt-1
		 ;; jmp		rebyte
nulavt:  ;;;;;
			mov		r0,#chdel
			cjne	@r0,#0,nndelch
			orl		P5,#08		   ;p5.3=1
			nop
			nop
			anl		P5,#0fdh		;p5.1=0
			inc		@r0
			jmp		 rebyte

nndelch:	cjne	@r0,#100,n4delch
			;pez->A+
			;K+=000/(A+-AN)
			;mov		r0,#rez_A;->r2..r5
			;call	resar2
				mov		a,reacp		;r2..r5	&&&&&&&&&&&
				mov		r2,a
				mov		a,reacp+1
				mov		r3,a
				mov		a,reacp+2
				mov		r4,a
				mov		a,reacp+3
				mov		r5,a
				;;;;;;;;;;;;;;;
			call	altof			;r2..r5->float
			mov		r0,#rezAp;->rezAp
			call	saver2				
			mov		r0,#kor0_AN;kor0_AN->r8..r11
			call	resar8				
			call	flsub		; r2..r5(A+-AN)
			call	move28	   ;r2..r5->r8..r11
			mov		dptr,#CHtho;000->r2..r5 float
			call	ldc_long		
			call	fldiv
			mov		a,r2
			anl		a,#7fh
			mov		r2,a
			mov		r0,#koefKp;->koefKp
			call	saver2
		  
		;	anl		P5,#0feh		;p5.0=0	
		mov		a,P5
			anl		a,#0feh
			mov		P5,a
			mov		r0,#chdel
			inc		@r0			  ;ch+1
			jmp		rebyte

n4delch:	cjne	@r0,#200,n8delch
			; pez->A-
			;K-=000/(A--AN)
		;	mov	r0,#rez_A;->r2..r5
		;	call	resar2
			mov		a,reacp		;r2..r5	&&&&&&&&&&&
				mov		r2,a
				mov		a,reacp+1
				mov		r3,a
				mov		a,reacp+2
				mov		r4,a
				mov		a,reacp+3
				mov		r5,a
				;;;;;;;;;;;;;;;
			call	altof			;r2..r5->float
			mov		r0,#rezAm;->rezAm
			call	saver2				
			mov		r0,#kor0_AN;kor0_AN->r8..r11
			call	resar8				
			call	flsub			; r2..r5(A--AN)
			call	move28	   		;r2..r5->r8..r11
			mov		dptr,#CHtho	;000->r2..r5 float
			call	ldc_long		
			call	fldiv
			mov		a,r2
			anl		a,#7fh
			mov		r2,a
			mov		r0,#koefKm;->koefKm
			call	saver2
		   
			;orl		P5,#01			    ;p5.0=1
			mov		a,P5
			orl		a,#01
			mov		P5,a
			nop
			nop
			;orl		P5,#02h	        	;p5.1=1	
			mov		a,P5
			orl		a,#02
			mov		P5,a
		 	mov		r0,#chdel
			inc		@r0			  ;ch+1
		   jmp	  rebyte

n8delch:	cjne	@r0,#255,n12delch
			mov		@r0,#0
			mov		r1,#chavt
			mov		@r1,#9ch;2eh;10=2ee0h
			inc		r1
			mov		@r1,#40h;0e0h
			jmp		rebyte
n12delch:	inc		@r0
			jmp		rebyte

rout6:		jmp		out6
rlabelF:	jmp		labelF	
rknrazr:	jmp		knrazr		
;;;;;;;;;;;;
keyb1:	;IE6 
				push	acc
				push	psw
				push	rr0
				push	rr1
				push	rr2
				push	rr3
				push	rr4
				push	rr5
				push	rr6
				push	rr7
		  ;;;;;;;;;;;;;;
		  		;0,1s
				jb		p3.6,rout6
				orl		p3,#03fh		; p3.(5-0)<-3f
				jnb		p3.6,rout6		;error
				jnb		bitizm,rlabelF
				mov		p3,#0feh		;реж IZM
				jnb		p3.6,izman
				mov		p3,#0fdh
				jnb		p3.6,rknrazr		  ;labelC
				mov		p3,#0fbh
				jnb		p3.6,knright		;->
				mov		p3,#0f7h
				jnb		p3.6,knopt			;T
				mov		p3,#0efh
				jnb		p3.6,pyskst			;pysk/stop
				mov		p3,#0dfh
			   jnb		p3.6,knvich
				jmp		izmpaT

pyskst:			jb	bitbon,bufon		;pysk/stop
				setb	bitbon	;уст реж буфер вкл
				jmp		izmpaT
bufon:			clr		bitbon	;уст реж буфер выкл
				jmp		izmpaT

tizmri:			mov		r1,#level
				cjne	@r1,#1,right2
				;10s->HET
				jmp		right3

right2:			inc		@r1
				call	lolevT
				;call	loadT	;нажата кн-> в реж Tизм 
right3:			call	ind
				jmp		izmfun

knright:	

				mov		r1,#diap
				cjne	@r1,#0,diinc
				jmp  izmfun

diinc:			;перекл диапазон 1 поз вверх сбр массив
				inc		@r1
				 jmp  izmfun

knvich:		   jb		bitvi11,onvich
				clr		bitizm
				setb	bitvich
				mov		r0,#vichR
				mov		@r0,#11h;;????????or 0
				;ВЫЧИСЛИТЬ
				mov	dptr,#teVICH
				call	lotext
			   call		ind
				jmp		 viout;izmpaT

onvich:			clr		bitvich
				mov		r0,#vichR
				mov		@r0,#0
			 	jmp		 izmpaT
			  ;;;;;;
izman:			jb		bitizm,knizmon
				setb	bitizm		;уст реж ИЗМ ВКЛ
				;заслать us

				jmp		izmfun
knizmon:		clr		bitizm		;уст реж ИЗМ ВЫКЛ
				;заслать us
izmfun:			setb	bitbuf
izmpaT:
labelE:			mov		r0,#parT
				mov		r1,#chkl
				cjne	@r0,#1,izmt2
				mov		@r1,#0
				inc		r1
				mov		@r1,#2
				jmp		out6
izmt2:		 	cjne	@r0,#2,izmt3
				mov		@r1,#0
				inc		r1
				mov		@r1,#20
				jmp		out6

izmt3:		 	mov		@r1,#0
				inc		r1
				mov		@r1,#200
				jmp		out6




knopt: ;кнопка T
			   clr		bitizm
			   setb		bitt2
			   call		loadT		;T=1S,10S,HET,0.1S,50mS,
			   call		ind

viout:		mov		r1,#chkl
			mov		@r1,#03
			inc		r1
			mov		@r1,#0e8h		;1000
			jmp		out6

knrazr:		 
labelC:		 clr		c
			mov		r0,#parN
			mov		r1,#parT
			mov		a,#2
			subb	a,@r1
			jc		labelE		;T>2
			cjne	@r0,#1,noN1c
			mov		@r0,#2		;N=2
			jmp		labelE

noN1c:		cjne	@r0,#2,not_1
			cjne	@r1,#1,not_1
			clr		c
			mov		r0,#diap
			mov		a,#6    	;10-2..10-8
			subb	a,@r0
			jc		not_1	    
			mov		@r0,#3		;N=3	  ;10-2..10-8
			jmp		labelE
not_1:		mov		@r0,#1				;N=1
			jmp	labelE

rtizmri:	jmp		tizmri
labelf:	   		
			jnb		bitt2,nofizm
		   mov		p3,#0fbh
		   jnb		p3.6,outF
		   mov		r1,#parT
		   cjne		@r1,#1,noft1
		   mov		@r1,#2
		   call	loadT		;в буфер 2 записать НЕТ
		   ;0,5s
		   jmp		ft1izm

noft1:	   dec		@r1
ft1izm:		call	loadT;в буфер 2 записать текст с соотв parT
			call	ind
outF:;??????????????/

nofizm:	 	jnb		bitvich,noviR
			mov		r0,#vichR
			cjne	@r0,#11,no11v6
			mov		@r0,#11h		;11= вычислить
			mov		dptr,#teVICH
			call	lotext
			;;???jmp		outF
vvrr6:		mov		p3,#0fbh
			jb		p3.6,outF
    		cjne	@r0,#13h,nor13
			mov		@r0,#11h		;11= вычислить
			mov		dptr,#teVICH
vi1113:		call	lotext	;в буфер 2 записать текст в соотв с состоянием
			jmp		outF
		
nor13:		cjne	@r0,#11,nor11
			mov		@r0,#12h
			mov		dptr,#teIZMK	;	изм конст
		    call	lotext		   
			jmp		vi1113

no11v6:		cjne	@r0,#12,no12v6
			jmp		vvrr6
no12v6:		cjne	@r0,#13,no13v6
			jmp		vvrr6


no13v6:		mov		p3,#0fbh
			jb		p3.6,chanZ
			mov		r0,#marker	
			cjne	@r0,#9,mark0_8		;курсор справа ?
			mov		@r0,#0				; уст курсор в кр левую поз+1
			jmp		outF

mark0_8:	inc		@r0		;	сдвинуть курсор вправо на 1
			cjne	@r0,#10,outma
outma:		jmp		outF

chanZ:		mov		p3,#0feh
			jb		p3.6,chanma
			;изм знак в старшем разряде на противоположн
			jmp		outF
chanma:
		
nor11:		;	выход
		mov		@r0,#13h  ;12->13
		mov		dptr,#teOUT
		jmp		vi1113



yesviR:		clr		bitvi11;????????/
			jb		bmem11,labelL
noviR:		





labelL:
out6:			pop		rr7	
				pop		rr6
				pop		rr5
				pop		rr4
				pop		rr3
				pop		rr2
				pop		rr1			        
				pop		rr0
				pop		psw
				pop		acc

			reti

rknMEM:			jmp		knMEM
knKMP:		   jmp		out7
rout7:			jmp		out7	
rlabelH:		jmp		labelH
keyb2:	;IE7
				push	acc
				push	psw
				push	rr0
				push	rr1
				push	rr2
				push	rr3
				push	rr4
				push	rr5
				push	rr6
				push	rr7
		  ;;;;;;;;;;;;;;
			   ;0,1s
				jb		p3.7,rout7
				orl		p3,#03fh		; p3.(5-0)<-3f
				jnb		p3.7,rout7		;error
				jnb		bitizm,rlabelH
				mov		p3,#0feh		;реж IZM
				jnb		p3.7,knNUL
				mov		p3,#0fdh
				jnb		p3.7,knKMP
				mov		p3,#0fbh
				jnb		p3.7,knleft
				mov		p3,#0f7h
				jnb		p3.7,knAVP
			    mov		p3,#0efh
				jnb		p3.7,rknMEM
				mov		p3,#0dfh
				jnb		p3.7,knmenu
an_t7:			mov		r1,#parT
				mov		r0,#chkl
				cjne	@r1,#1,not1_7
				mov		@r0,#00
				inc		r0
				mov		@r0,#2
				jmp		out7
			

not1_7:			cjne	@r1,#2,not2_7
				mov		@r0,#00
				inc		r0
				mov		@r0,#20
				jmp		out7
not2_7:		   	mov		@r0,#00
				inc		r0
				mov		@r0,#200
				jmp		out7


knmenu:			 clr		bitizm		;off IZM
				mov		dptr,#teTEST	;в буф2 записать ТЕСТ-ИЗМЕР
				call	lotext
				call	ind
				jmp		onmem11

knAVP:			jb		bitavp,meavp
				setb	bitavp
				jmp		onmem11
meavp:			clr		bitavp
				jmp		onmem11

knleft:		   mov		r1,#diap
				cjne	@r1,#9,nodi6
				jmp		an_t7

nodi6:		   	cjne	@r1,#0,an_t7
				dec		@r1		 ;перекл диапазон 1 поз в сбр массив
				call	loadUS
			   jmp		an_t7

knNUL:			jb		bitnul,ybnul
				setb	bitnul
				mov		r0,#rez_A3	;A3
				call	resar2
				mov		r0,#rez_A0	
				call	saver2;A0<-A3
				jmp		an_t7

ybnul:			clr		bitnul
				 mov	DPTR,#ch0 
				CALL   ldc_long		 ; r2..r5 <-- 0
				mov		r0,#rez_A0	;A0=0
				call	saver2
				jmp		an_t7

labelH:		  	jnb		bitt2,nolah
				mov		p3,#0fbh
				mov		r1,#parT
				jb		p3.7,hnot1
				
				cjne	@r1,#6,hyest6
				inc		@r1			;Tизм+1
			
			call	loadT	;в буфер2 записать текст  в соотв с	Tизм
hnot2:			call	ind
				jmp		out7

 ;rnoviR:	jmp		noviR
 rlabelK:	jmp		labelK		
 ;;;;;;;;;;;;;;;;;;;
nolah:		jnb		bitvich,rlabelK	
		   	mov		r0,#vichR
			cjne	@r0,#11h,hnor11;labelI
			mov		p3,#0fbh
			jb		p3.7,noh37;routF
    		cjne	@r0,#11,hr12
			mov		@r0,#13h	;11= вычислить
			mov		dptr,#teOUT;teVICH
hvi1113:	call	lotext	;в буфер 2 записать текст в соотв с состоянием
			jmp		outF
hr12:		cjne	@r0,#12,hnor12
			mov		@r0,#11h
			mov		dptr,#teVICH
			jmp		hvi1113		
hnor12:		cjne	@r0,#13,hnor11
			mov		@r0,#12h
			mov		dptr,#teIZMK	;	изм конст
		    call	lotext		   
			jmp		hvi1113

noh37:		mov		p3,#0f7h
			jnb		p3.7,routF
			cjne	@r0,#11,norr11
			setb	bitvich
			setb	bitizm
routF:		jmp		outF

norr11:		cjne	@r0,#12,norr12
			setb	bitvi21
			mov		dptr,#teAequ0
			call	lotext
			call	ind
			jmp		routF;???????//

norr12:		clr		bitvich
			setb	bitizm
			jmp		routF;???????//

hnor11:		cjne	@r0,#12h,hnor13
			jmp		hr12
hnor13:		jmp		hnor12		
				
		



;;;;;;;;;;;;;;;;;

hyest6:		   	mov		dptr,#teNO
				call	lotext		;в буфер2 записать НЕТ
				;загрузить буфер 2 в инд
				;0,5s
				 jmp	hnot2


hnot1:			mov		p3,#0f7h
				jb		p3.7,out7
				cjne	@r1,#1,nohnot1
				cjne	@r1,#2,nohnot2
				;в буфере 1 зажечь 1s
loadB:			;установить B1,B2 в соотв с Tизм   ??????
				call	iniacp;инициализация АЦП
				 clr		c
 			     mov		r1,#parT
			     mov		a,#3
			    subb		a,@r1
			    jc			loadB2;T>=2
				;N=1
				jmp		out7
loadB2:			cjne	@r1,#2,out7
;N=2
				jmp		out7
nohnot2:		;в буфере 1 зажечь <=0,1s
				jmp		loadB
nohnot1:		;в буфере 1 зажечь 10s
				jmp		loadB

knMEM:		 	clr		bitizm		;off IZM
				call	lotext	  ;в буф2 записать ОЧИСТКА
				call	ind
				setb	bmem11	   ;ПАМ11
onmem11:		mov		r0,#chkl
				mov		@r0,#03
				inc		r0
				mov		@r0,#0e8h		;1000
				jmp		out7
labelK:
labelI:
out7:		   pop		rr7	
				pop		rr6
				pop		rr5
				pop		rr4
				pop		rr3
				pop		rr2
				pop		rr1			        
				pop		rr0
				pop		psw
				pop		acc

				reti

loadUS:		mov		r1,#diap
			mov		a,@r1
			rl		a;*2
			mov		r4,a			;save a
			mov		dptr,#tabus
			movc	a,@a+dptr
			mov		r2,a			;high byte
			mov		a,p4
			anl		a,#01
			orl		a,r2
			mov		p4,a
			inc		r4
			mov		a,r4
			movc	a,@a+dptr
			mov		r3,a			;low byte
			mov		a,p5
			anl		a,#07
			orl		a,r3
			mov		p5,a
			ret


tabus:	   db		88h,0d8h	 ;10-2
			db      88h,0e8h	 ;10-3
			db		88h,0d0h	 ;10-4
			db		88h,0e0h	 ;10-5
			db      92h,0d8h	 ;10-6
			db		92h,0e8h	 ;10-7
			db		0a4h,0d8h	 ;10-8
			db      0a4h,0e8h	 ;10-9
			db		0c0h,0d8h	 ;10-10
			db		0c0h,0e8h	 ;10-11

;загрузка текста в буфер 2 bufind+0..bufind9
;в зав от parT (Tизм)
loadT:		mov		r1,#parT
lolevT:		mov		r0,#bufind+0
			mov		r3,#9
			mov		b,#9
			mov		a,@r1
			mul		ab
			mov		r4,a			;save a
			mov		dptr,#textT
	lod1:	movc	a,@a+dptr
			mov		@r0,a
			inc		r0
			inc		r4
			mov		a,r4
			djnz	r3,lod1
			ret		
;загрузка текста в буфер 2 bufind+0..bufind9			
;dptr-адр строки текста		
lotext:	   	
			mov		r3,#9
			mov		r0,#bufind+0
lodt:     	clr		a
			movc	a,@a+dptr
			mov		@r0,a
			inc		r0
			inc		dptr
			djnz	r3,lodt
			ret		


   textT:	db		0ffh,0ffh,"T","=",31h,"S",0ffh,0ffh,0ffh	 ;0
			db		0ffh,0ffh,"T","=",31h,30h,"S",0ffh,0ffh		 ;1
   teNO:	db		0ffh,0ffh,0ffh,"H","E","T",0ffh,0ffh,0ffh	 ;2
			db		0ffh,0ffh,30h,".",31h,"S",0ffh,0ffh,0ffh	 ;3
			db		0ffh,0ffh,35h,30h,"m","S",0ffh,0ffh,0ffh	 ;4
			db		0ffh,0ffh,31h,30h,"m","S",0ffh,0ffh,0ffh	 ;5
			db		0ffh,0ffh,0ffh,32h,"m","S",0ffh,0ffh,0ffh	 ;6

 teVICH:	db		'В','Ы','Ч','И','С','Л','И','Т','Ь'
 teAequ0:  	db		0ffh,'A','=','+',30h,30h,30h,30h,0ffh,0ffh
 teBequ0:	db		0ffh,'B','=','+',30h,30h,30h,30h,0ffh,0ffh
 teMENU:	db	0ffh,0ffh,'M','E','H','Ю',0ffh,0ffh,0ffh

 teTEST:	db	0ffh,0ffh,'T','E','C','T',0ffh,0ffh,0ffh

 teKALIB:	 db	0ffh ,'K','A','Л','И','Б','P',0ffh,0ffh
 teIZMK:	db	'И','З','М','И',0ffh,'О','Н','С','Т'
 teOUT:		db	0ffh,0ffh,'В','Ы','Х','О','Д',0ffh,0ffh

 ;;;;;;;;;;;;;;;;;;;         
;управление AD7731
iniacp:		mov		a,#03
			call	write
			mov		a,#40h;b1=40h;80h
			call	write
	  		mov		a,#04;b2=04
			call	write
			mov		a,#02
			call	write
			mov		a,#0a1h
			call	write
			mov		a,#74h
			call	write
			jb		p1.3,$
			mov		a,#02
			call	write
			mov		a,#81h
			call	write
			mov		a,#74h
			call	write
			jb		p1.3,$
			mov		a,#02
			call	write
			mov		a,#21h
			call	write
			mov		a,#74h
			call	write
			ret
			;;;;;;;;;;;;;;;;

 vvchif:;	clr	cellbi2.1
			mov		a,marker			;изм цифры
;			mov		r0,#makoi			;0000
			add		a,r0
			mov		r0,a
			inc		@r0
			cjne	@r0,#0ah,chif
			mov	@r0,#0
chif:		ret


;загрузка коэф KD в зависимости от диапазона
loadKD:
;;;;;;;;;;;;
 ;;;;;;;;;;;;;;
;r7-количество байт
;dptr-адр 1-й ячейки сектора
;
cle256:
			 ; push	rr7						;стирание r7 байт(запись в ячейки ff)
							
mm3:		MOV		PSCTL,#02
				
				MOV		PSCTL,#03
				mov		FLSCL,#0a5h
				mov		FLSCL,#0f1h
					
				mov		a,#0ffh
				movx	@dptr,a				;wr
				ret
				
;;;;;;;;;;;;;;
;r7-количество байт
;dptr-адр ячейки для записи
;r1-адр ячейки
wr4bait:
mm5:
			MOV		PSCTL,#03;00				;обязательно для каждого записи байта
				
				MOV		PSCTL,#01			;обязательно для каждого записи байта
;				mov		FLKEY,#0a5h		;обязательно для каждого записи байта
;				mov		FLKEY,#0f1h		;обязательно для каждого записи байта
					
			  mov	a,@r1
				movx	@dptr,a				;wr
				inc		dptr
				inc		r1
				djnz	r7,mm5
				ret

;чтение памяти программ в r8..r11
;вх-r2,r3-адр яч памяти прогр
re4byte:	mov			dph,r2
					mov			dpl,r3
					clr			a
					movc		a,@a+dptr
					mov			r8,a
					inc			dptr
					clr			a
					movc		a,@a+dptr
					mov			r9,a
					inc			dptr
					clr			a
					movc		a,@a+dptr
					mov			r10,a
					inc			dptr
					clr			a
					movc		a,@a+dptr
					mov			r11,a						;r8..r11
					ret





							

;;;;;;;;;;;;;
;r7-количество байт
;dptr-адр ячейки для записи
;r1-адр ячейки

wrpage:
WW5:
			mov		IE,#0
			MOV		FLSCL,#01;FLWE(FLSCL.0)обязательно для каждого записи байта
				
			MOV		PSCTL,#03;FLWE(PSCTL.1,.0)обязательно для каждого записи байта
			MOV		PSCTL,#00
			movx	a,@r1
			MOV		PSCTL,#01
			movx	@dptr,a				;wr
			MOV		PSCTL,#00
			inc		dptr
			inc		r1
			djnz	r7,WW5
			mov		IE,#80h
			ret
			
;;;;;;;;;;;;;;;;;;;;;;;;;
;чтение памяти программ во внешнее озу
;вх-r2,r3-адр яч памяти прогр
;r1- яч внешнее озу
copyPP:		mov			dph,r2
					mov			dpl,r3
					mov			r7,#0ffh
copy1:		clr			a
					movc		a,@a+dptr
					movx			@r1,a
					inc			dptr
					inc			r1
					djnz		r7,copy1
					ret
;;;;;;;;;;;;;;;;;;;;;;;;;

				



$include (d:\amp\subr1.asm) 	
$include (d:\amp\sarifm3.asm) 					
$include (d:\amp\floatm.asm)
;$include (d:\amp\wriread.asm)					      
END
						