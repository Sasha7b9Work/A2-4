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
				;KD=00 01 86 A0	(KD=1)
				;коэфф *100000 и переведенный в hex формат
				;согласно адресов диапазонов и адресов яч вн озу 
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


;адрес ячеек веншнего озу соответствующего диапазона KD
;(5000h..5027h)
;		0000h			;10-2
;		0004h			;10-3
;		0008h			;10-4
;		000ch			;10-5
;		0010h			;10-6
;		0014h			;10-7
;		0018h			;10-8
;		001ch			;10-9
;		0020h			;10-10
;		0024h			;10-11
;		0028h			;parol







		
		
		
		

				
		
		



		
 			  
		


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
						