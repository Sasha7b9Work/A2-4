$include (c8051f020.inc)               ; Include register definition file.

;+        CSEG AT 0
	 
NAME	MAIN
		  ; EXTRN CODE(end1)
		  ; EXTRN CODE(numb)
		  ; EXTRN CODE(SOROS)
		  ; EXTRN CODE(Abegin)

		;PUBLIC gener,bitmas,bitrs,bitznak 
		;PUBLIC meff
		;PUBLIC rez_A, rez_A0;	!!!!!!!!!!!!!
	org 0h;    cseg AT 0
 		jmp	begin	;Main        ; Locate a jump to the start of code at 
	org 3
		reti   
	org 0bh
		reti
	org 13h
		reti
	org 1bh
;? timer1
		reti
	org 23h
		jmp	rs_byte	;!reti
	org 2bh
		jmp	inter2	;Timer2, IE.5,IP.5(ET2,PT2)
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
		jmp		keyb1		;IE6
	org	9bh
		jmp		keyb2	   ;IE7

TMR2RLL  DATA 0cah;    // TIMER 2 RELOAD LOW                                       */
TMR2RLH  DATA 0cbh;    // TIMER 2 RELOAD HIGH 
 
Main         SEGMENT  CODE

		DSEG
  
bufind	DATA	40h;буффер индикации 12byte
abin		DATA	4fh	;4byte long~adec's digits
adec		DATA	53h	;53h..5dh 10byte
chmas		DATA	6eh	;счетчик эл-тов незаполн массива
mabin		DATA	6fh
reacp		DATA	77h	;результат чтения асп 4byte int (hex)
chkl		DATA	3dh	;счетчик задержки клавиатуры 2bait                         
chmasN	DATA	3fh	;n=2,n=10 суммирование n значений	=20(27.12.06)
savba		DATA	3ch	;сохр байта индикации при миганиии	
movrig      DATA	3bh	;крайне правое положение
movleft     DATA	3ah	;крайне левое положение                  
nuerr		DATA	39h	;номер ошибки (для интерфейса)	
nblok		DATA	38h	;номер введенного блока
nelem		DATA	37h	;номер элемента в блоке 0..200
saus		DATA	36h	;сохр упр слово
sadiap	DATA	34H	;сохр диапазон на кот проходила запись блока1
chind2	DATA	33h	;счетчик индикации
sadiap2	DATA	32h	;сохр диапазон на кот проходила запись блока2
sadiap3	DATA	31h	;сохр диапазон на кот проходила запись блока3
sadiap4	DATA	30h	;сохр диапазон на кот проходила запись блока4
;DATA		2fh
;;;;;
cellbit		DATA	20h
bitznak		BIT 	cellbit.0	;20.0		
bitmas		BIT 	cellbit.1	;20.1 бит заполнения массива		
znmat			BIT	cellbit.2	;20.2
bitrs			BIT	cellbit.3	;20.3
bitizm		BIT	cellbit.4	;20.4 вкл реж измерения
bitavp		BIT	cellbit.5	;20.5  бит режима avp
bitvi11		BIT	cellbit.6	;20.6	бит нажатия ввод режима вычислить R!!!
bitzus		BIT	cellbit.7	;20.7;флаг задержки	после установки us	

cellbit1		DATA	21h
;?bitbuf		BIT 	cellbit1.0	;21.0	
speed_rs		BIT 	cellbit1.0	;21.0
bitprd		BIT 	cellbit1.1	;21.1  выдача вкл	
bitbon		BIT	cellbit1.2	;21.2  буфер вкл
bitmem		BIT	cellbit1.3	;21.3 нажата кн память
;bmem11		BIT	cellbit1.4	;21.4  	 бит ПАМ11
bifl_kt		BIT	cellbit1.5	;21.5  бит для выч Км теста измерения  
;bmem13		BIT	cellbit1.6	;21.6		 
bitnul		BIT	cellbit1.7	;21.7 бит кнопки НУЛЬ

cellbit2		DATA	22h
bitt2			BIT 	cellbit2.0	;22.0 уст признак Tизм2	нажата кнопка Т	
bitmenu		BIT 	cellbit2.1	;22.1  бит режима меню(нажата кн меню)	
bitklb		BIT	cellbit2.2	;22.2  признак калибровки
bitv19		BIT	cellbit2.3	;22.3	бит установки скор итерфейса 19.6
bitvich		BIT	cellbit2.4	;22.4  1-е нажатие кн ВЫЧ R (режим ВЫЧ R)
biteizm		BIT	cellbit2.5	;22.5   признак теста измерения 
bitpar		BIT	cellbit2.6	;22.6	бит проведенного 1раз пароля 
bitoll		BIT	cellbit2.7	;22.7 бит перегрузки
;в реж измерения прибор измеряет (кнопка ИЗМ не нажата )
;при нажатии кнопок (T,МЕНЮ ,ПАМЯТЬ ,ВЫЧ R)прибор выходит из реж измерения
;и выдает т.н. буфер индикации	
cellbit3		DATA	23h
knizm			BIT 	cellbit3.0	;22.0 уст признак нажата кнопка ИЗМ	
bitmig		BIT 	cellbit3.1	;22.1 бит мигания при наборе конст 	
bitakt		BIT	cellbit3.2	;22.2  бит такта
bitznB		BIT	cellbit3.3	;22.3 БИТ ЗНАКА ПРИ ВВОДЕ константы В
bitprer		BIT	cellbit3.4	;22.4  	 
;bit			BIT		cellbit3.5	;22.5    
;bit			BIT		cellbit3.6	;22.6		 
;bit			BIT		cellbit3.7	;22.7

is_2		BIT	cellbit1.4	;бит 'to RS direct out'
is_mem	BIT	cellbit1.6	;21.6		 
is_izm	BIT	cellbit3.7
is_cmd	BIT	cellbit3.5
is_rs		BIT	cellbit3.6	;out rez_A3
buf_in	DATA	0DBh	;4
cnt_out	DATA	24h
cnt_in	DATA	25h
p_out		DATA	26h	;??
p_in		DATA	27h
cmd_rez	DATA	4Eh
RI		BIT	SCON0.0
TI		BIT	SCON0.1


rez_Ame	data 5eh;float	 (РЕЗ1-AN)*K
;hex
rez_A		data 62h	;РЕЗ сумма 100 (10)отсчетов измерения	 
rez_A1	data 66h	;РЕЗ1  среднее по массиву из 2,10 ти элементов int (hex)
rez_A0	data 6ah	;рез изм по нажатию кн НУЛЬ
rez_A2	data 7bh	; A2
chinkor	data  98h	;80h,счетчик интервала коррекции  2byte
chavt	 	data  81h	;счетчик автокалибровки	 2byte
chdel	 	data  83h	; счетчик задержки
;float
kor0_AN	data  84h	;4byte	AN	результат коррекции 0
rezAp		data  88h	;4byte	A+
rezAm	 	data  8ch	;4byte	A-
koefKp	data  90h	;4byte	K+
koefKm	data  94h	;4byte 	K-
;hex 
parT	 	data  9ah	;параметр времени измерения
chbefore	data  9bh	;счетчик предварительного суммирования
rez_A3  	data  9ch	;A3
;FLOAT
koefKD	data  0a0h	;KD коэфф диапазона
rez_Ak	data  0a4h	;Ak
parol		data  0a8h	;храним в памяти пароль
chind		data  0ach	;счетчик индикации
;chbuf	data  0adh	 ;счетчик периода загрузки в буфер и интерфейс
diap		data  0aeh	;номер диапазона
parN		data  0afh	;N  пар разрядности индикатора
level		data  0b0h	;уровень в меню, выч	,Tизм
vichR		data  0b1h	;параметр =11,12,13,21		state of menu VychR
marker	data  0b2h	;номер мигающего знакоместа
summa		data  0b3h	;ячейка для суммирования 	rez_A
load		data  0b7h	;яч для загрузки текстов на индикатор
work		data  0b8h	;рабочая ячейка
konstA	data  0bch	;введенная с экрана константа A
;konstB	data  0c0h	 ;введенная с экрана константа B
saven_bl2	data	0c0h	;копия адреса последней записанной ячейки блока2
saven_bl3	data  0c2h	;копия адреса последней записанной ячейки блока3 
	   ;c4 1bait
Rez_del	data  0c5h	;сумма n-значений /n
rez_R		data	0c9h	;рез вычисления R 4baita
interva	data  0cdh	;значение интервала (запись)2baita
chbuf		data  0cfh	;счетчик периода загрузки в буфер и интерфейс
saven_bl	data  0d3h	;номер ячейки в блоке 2 baita
volume	data	0d5h	;объем блока 2 baita
chblok	data	0d6h	;volume;кол измерений блока
copy_hl	data  0d7h	;адрес ячейки блока для просмотра 
saven_bl4	data  0d9h	;копия адреса последней записанной ячейки блока4
;data		0dbh e0h-граница стека

;внешнее ОЗУ 64K
;в обл внешнего озу 0..ffh читается страница рпзу и при записи в любую
;ячейку  стирается целая страница 0..ffh рпзу
;		XSEG AT 100h
	PUBLIC 	  MASS0
MASS0  xdata 0100h;	скользящий массив измерения
MASS1  xdata 0104h;
MASS2  xdata 0108h;
MASS3  xdata 010ch;
MASS4  xdata 0110h;
MASS5  xdata 0114h;
MASS6  xdata 0118h;
MASS7  xdata 011ch;
MASS8  xdata 0120h;
MASS9  xdata 0124h;
MASS10  xdata 0128h;
MASS11  xdata 012ch;
MASS12  xdata 0130h;
MASS13  xdata 0134h;
MASS14  xdata 0138h;
MASS15  xdata 013ch;
MASS16  xdata 0140h;
MASS17  xdata 0144h;
MASS18  xdata 0148h;
MASS19  xdata 014ch;
chbuf1  xdata 0e00h;счетчик буфера 1
;xdata	0e04
		rr0	EQU	00
		rr1	equ	01
		rr6   equ	06
		rr2	equ	02
		rr3	equ	03
		rr7   equ	07
		r8	equ	08
		r9	equ	09
		r10	equ	10
		r11   equ	11

             rseg     Main         ; Switch to this code segment.

             using    0            ; Specify register bank for the following

	org 100h
;$EJECT

begin:	mov		sp, #0e0h		;?8

		mov		PCA0L,#00;=0x00;
		mov		PCA0MD,#00;= 0x00;
		mov		P0MDOUT,#1fh;=0x1f;
		mov		P1MDOUT,#0cch;86h;8fh;=0x8f;
		mov		P2MDOUT,#00;=0x00;
	//P2MDIN=0xff;//11111111;
		mov		P3MDOUT,#3fh;
		mov		P74OUT ,#0ffh;=0xff;
		mov		REF0CN,#03h;=0x03;
	
		mov		XBR0,#14h;= 0x14;
		mov		XBR1,#00; =0x00;
		mov		XBR2,#00;=0x00
 		mov		P3,#0c0h
		mov		WDTCN,#0deh;=0xde;запрет работы WDT
		mov		WDTCN,#0adh;=0xad;                                   
		mov		TMOD,#22h;=0x22;	регистр режимов
		mov		CKCON,#30h;=0x30; сист частота/12     
		mov		TH0,#0f9h;=0xf9;  Установка таймера
		mov		TL0,#0f9h;=0xf9; 
		mov		EIE1,#80h;=0x80;

		mov		DAC0CN,#80h;=0x80;
		mov		DAC1CN,#80h;=0x80;
		mov		OSCXCN,#67h;=0x67;


gener:	;+mov		a, oscxcn
      	;+cjne	a,#11100111b,gener	;?E7
		mov		OSCICN,#88h;=0x84;
		mov		TMR2RLL,#0;=0;
		mov		TMR2RLH,#0d1h;=0xd1;
  
		setb  	TCON.6			;регистр управления
		setb		tcon.4
		mov		RSTSRC,#0;=00	;//источники сброса 
		mov		XBR2,#40h
		mov		XBR0,#0eh;06h;16h
		mov		SPI0CN,#03
		mov		spi0ckr,#31H;;;;;;;;#04
;установка скорости
		mov		SCON0,#50h;01010000;скорость обмена определяется таймером1
		mov		PCON,#10000000b;удвоенная скорость передачи SMOD0=1
		mov		CKCON,#00010000b;TIM=1			? was 30h
		mov		TMOD,#00100000b;реж2 внутр ист синхр ? was 22h
		mov		TCON,#01000000b;счетчик запущен	?.4,.6 was set
		mov		PCA0MD,#00		;PCA 
		mov		PCA0CPM0,#00000000b;00000110b;01000010b;
		mov		PCA0CPL0,#00
		mov		PCA0CPH0,#9ch;регулировка звука 088h;90h
		mov		PCA0CN,#40h
		mov		T2CON,#00
		mov	TH1,#244	;220~19600
		setb	TR1	;start Timer1

;?	mov   SBUF0,#37h

;	mov	3,#33
;	mov	r2,#30
;	mov	r0,#0DAh

;debug:	mov	A,r2
;		mov	@r0,A
;		inc	r2
;		inc	r0
;		djnz	3,debug	;jmp	debug	;interrupt debug


;	mov     SBUF,#7
;	jnb     TI,$
;	clr     TI

;		mov	IE,#90h	;RS, ?Tim1

;?		mov		r2,#50h			;57.6->19.2
;		mov		r3,#2ch
;		call	re4byte			;502ch 1 bait skor
;		mov		a,r8
;?		cjne		a,#00,yst19
		clr		bitv19			;57.6
		mov		TH1,#244
		mov		TL1,#0FDh
		jmp		yst1
yst19:	mov	dptr,#teS19_2
		setb	bitv19			;19,2
		mov	TH1,#220
yst1:
		setb	TR1	;start Timer1
		mov		EIE2,#30H;00110000
	;	mov		EIP2,#30H

;	mov	p_in,#buf_in	; for receive
;	mov	cnt_out,#0	;??
;	mov	cnt_in,#0

		mov	IE,#80h ;??80//Снятие блокировки всех прерываний+RS
;ozu
		clr	a
		mov	r0,#00h	
mecle:	mov	@r0,a 			;обнулить озу 256 байт
		inc	r0
		cjne	r0,#7fh,mecle
		mov	r0,#80h
meff:		mov	@r0,a 
		movx @r0,a
		inc	r0
		cjne	r0,#0dfh,meff


;		mov	cnt_out,#33		;+
;		mov	p_out,#0DAh

		call	clmassix
;обнулить внешнее озу 4кбайта
		mov	dptr,#0
extcle:	clr	a
		movx	@dptr,a
		inc	dptr
		mov	a,dph
		cjne	a,#10h,extcle

		mov		r0,#chinkor
		mov		@r0,#0;1;
		inc		r0
		mov		@r0,#19h;64h;0c8h;90h;

		mov		r0,#chavt
		mov		@r0,#1
		inc		r0
		mov		@r0,#90h

		mov		r0,#marker
		mov		@r0,#0ffh
		;mov		r0,#chind
		;mov		@r0,#1
		mov		a,#0ffh
		mov		p5,a
		mov		r1,#parT
		mov		@r1,#2			;Tizm=1s
		mov		r1,#diap
		mov		@r1,#5			;10-7a
		mov		sadiap,#5
		mov		r1,#parN
		mov		@r1,#2
		mov		a,#00h
		mov		p5,a
		setb		bitizm

		mov		r1,#chbefore
		mov		@r1,#0

		mov		dptr,#ch_1		;1->r2..r5 float
		call	ldc_long
		mov		r0,#koefKp	   ;1(float)->koefKp
		call	saver2
		mov		r0,#koefKm		;1(float)->koefKm
		call	saver2
		mov		r0,#koefKD
		call	saver2
		mov		r0,#chbuf
		call	saver2
		mov		dptr,#158h;1 блок(2е с конца измерение)	
		mov		r1,#saven_bl
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a

		mov			dptr,#478h;2 блок(2е с конца измерение)	
		mov		r1,#saven_bl2
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		mov			dptr,#798h;3 блок(2е с конца измерение)	
		mov		r1,#saven_bl3
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		mov		dptr,#0ab8h;4 блок(2е с конца измерение)	
		mov		r1,#saven_bl4
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		mov		nblok,#1			;номер введенного блока
		mov		nelem,#1
		mov		r0,#interva
		mov		@r0,#0
		inc		r0
		mov		@r0,#1
		mov		r0,#bufind
age2:
		mov		@r0,#0fdh	  ;погасить индикатор
		inc		r0
		cjne	r0,#bufind+12,age2		
		call	ind
		call	z_1s

		;зажечь все элементы индикации
		mov	r0,#bufind
ageon:	mov	@r0,#69h;0feh;?
		inc	r0
		cjne	r0,#bufind+12,ageon		
		call	ind
		call	z_1s		;1sec

		call	z_15;z_1ms
		orl	bufind+11,#10h;бит точки после 1 знакоместа

		mov	r4,#60h
		mov	r5,#00         
		call	iniacp;инициализация acp
		call	loadUS		;us 10-7 A

after_2:		
			
		setb		bitizm
	mov	p_in,#buf_in	; for receive
	mov	cnt_out,#0	;??
	mov	cnt_in,#0
	mov	IE,#90h ;Снятие блокировки всех прерываний+RS

rebyte:

	jnb	is_cmd,me3		;??
	call	cmd_tree
me3:
;after_2:		;??

		clr		bitoll
		jnb		p1.5,$
		jb		p1.5,$
		;mov		a,P6	   	;p6.4=0
		;anl		a,#0efh
		;mov		P6,a
		;nop
		;nop
				
		;mov		a,P6			;p6.4=1	
		;orl		a,#10h
		;mov		P6,a			    
		mov		a,#11h
		call	write
	;чтение acp
		call	read	
		mov 	reacp+1,A	;старший байт 
		call	read	
		mov 	reacp+2,A	;средний байт 
		call	read
		mov 	reacp+3,A		;мл байт

		mov		r0,#reacp+1
		mov		a,@r0
		jb		acc.7,znplus;
		setb	bitznak
		orl		a,#80h	;ост содерж яч 
		mov		@r0,a
				
mmm:		dec		r0;,#reacp
		mov		@r0,#0ffh
		jmp		goznak

mem10ms:	call		ind
		jmp		rebyte	;10ms

labelA:	;разрешить ie6,ie7
;		mov		a,chkl+1		;low
;		jnz		no0key
		mov		a,chkl
		jnb		acc.7,no0key;jnz			no0key
		mov		a,P3IF
		anl		a,#3fh
		mov		P3IF,a
		mov		EIE2,#30h ;EIE2.5,EIE2.4
		jmp		yes0key
		   
no0key:	;mov		r1,#chkl 
		;call	chdec
		clr		c
		mov		a,chkl+1;chkl-1
		subb		a,#1
		mov		chkl+1,a
		mov		a,chkl
		subb		a,#0
		mov		chkl,a

yes0key:
		jb		bitizm,rebyte
	 ;буфер 2 выдать на индикацию
		mov		a,chind2			;реже выдавать на индикацию
		jnz		nochind
		mov		chind2,#100
	 	call		ind
yes0key1:	call		z_1ms;z_01s
		;call	z_01s
		;call	z_01s
		jmp		labelA

nochind:	dec		a
		mov		chind2,a
		jmp		yes0key1;labelA
	
znplus:	clr	bitznak
		anl		a,#7fh;fdh			;+
		mov		@r0,a
		dec		r0	;,#reacp
		mov		@r0,#00h
			
goznak:
		mov 		r0,#reacp+3
		mov		a,@r0
		mov		r7,#5		;6 сдвиг на 5 разрядов вправо
sdvig3:		clr		c
		rrc		a
		djnz		r7,sdvig3	;d7,d6,d5	  мл байт
		mov		r2,a		;сохр байт
		dec		r0		;reacp+2
		mov		a,@r0
		push	acc
		clr		c
		mov		r7,#3;2
sdvig2:		clr		c
		rlc		a
		djnz		r7,sdvig2	;d12..d11	 средний байт
		orl		a,r2
		mov		reacp+3,a	;сформ мл байт
		pop	acc
		mov		r7,#5;6
sdvig1:		clr		c
		rrc		a
		djnz	r7,sdvig1		;d15,d14	  ср байт
		mov		r2,a  	;сохр
		mov		a,reacp+1
		push	acc
		;	push	acc
		mov		r7,#3;2
sdvig0:		clr		c
		rlc		a
		djnz	r7,sdvig0		;d21..d16
		orl		a,r2
		mov		reacp+2,a	;сформ средний  байт
		pop		acc		;reacp+1
		jb		acc.7,sdvm
;at here only speed change

;	jnb		speed_rs,sdvig4_
;??	jmp		
;sdvig4_:
		clr		c
		mov		r7,#5;6
sdvig4:		clr		c
		rrc		a
		djnz		r7,sdvig4	;d23,d22
		mov		reacp+1,a
		jmp		readyacp	;ankor;klmas

sdvm:		mov		r7,#5;6
sdvig6:	setb		c
		rrc		a
		djnz		r7,sdvig6 ;	  d23,d22
		mov		reacp+1,a
; reacp..reacp+3-результат чтения асп(hex) 
readyacp:	mov		r0,#chinkor
		mov		a,@r0
		jnb		acc.7,gopart
		jmp		sumt2
		
gopart:
		mov		r0,#parT	;параметр времени
		mov		r1,#chmasN
		cjne		@r0,#1,noparT1
	;РЕЗ+РЕЗ
		mov		r0,#reacp
		call		resar2	;reacp->r2..r5
		mov		r0,#summa+3	;rez_A+3
		call		ladd
		mov		r0,#summa;rez_A
		call		saver2
		mov		r1,#chmasN
		mov		@r1,#20;10
		mov		r0,#chbefore
		cjne		@r0,#99,nobef99
	;РЕЗ/100
		MOV	DPTR,#ch100 
allsum:	CALL  ldc_ltemp		 ; ltemp <-- 100
		call	zdiv;divide
		mov	r0,#rez_A
		call	saver2		;сумма 100 отсчетов /100
		mov	r0,#Rez_del
		call	saver2	

		mov		r0,#summa
		call		clear4

		mov		r1,#chbefore
		mov		@r1,#0
		jmp		klmas		;загр в массив скользящее ср
nobef99:	inc		@r0		 	;chbefore
		jmp		rebyte;labelA;метка A
;сначала суммируем 100 знач (не выводим на индикатор не расп в скользящий массив )
;а потом уже располагаем  в скользящий массив  из n


noparT1:	cjne	@r0,#2,noparT2
	;РЕЗ+РЕЗ
sumt2:
		mov	r0,#reacp
		call	resar2		;reacp->r2..r5
		mov	r0,#summa+3;rez_A+3
		call	ladd
		mov	r0,#summa;rez_A
		call	saver2
		mov	r0,#chbefore
		mov	r1,#chmasN
		mov	@r1,#10
		cjne	@r0,#19,nobef99;9,nobef99
	;РЕЗ/20
		MOV	DPTR,#ch20;ch10 
		jmp	allsum

noparT2:	cjne	@r0,#3,noparT3
		mov	r0,#reacp
		call	resar2		;reacp->r2..r5
		mov	r0,#summa+3;rez_A+3
		call	ladd
		mov	r0,#summa;rez_A
		call	saver2
		mov	r0,#chbefore
		mov	r1,#chmasN
		mov	@r1,#2;4					;n=4
		cjne	@r0,#9,nobef99;9,nobef99
	;РЕЗ/10
		MOV		DPTR,#ch10 
		jmp		allsum
			
noparT3:	cjne	@r0,#4,noparT4
aapar:		
		mov		r0,#reacp
		call		resar2		;reacp->r2..r5
		mov		r0,#summa+3;rez_A+3
		call		ladd
		mov		r0,#summa;rez_A
		call		saver2
		mov		r0,#chbefore
		mov		r1,#chmasN
		mov		@r1,#2;4
		cjne	@r0,#4,nobef99;9,nobef99
	;РЕЗ/10
		MOV		DPTR,#ch5
		jmp		allsum

noparT4:	mov		@r1,#2		;chmasN n=2
		mov		r0,#reacp
		call		resar2		;reacp->r2..r5
		mov		r0,#rez_A
		call		saver2
;загрузить А в массив из 2/10 значений

klmas:		 
		mov	r1,#chmasN
		cjne	@r1,#2,mas10
		MOV	dptr,#MASS0
		CALL	xCIKLWR   	  ; MASS0 --> MASS1

		mov	r0,#rez_A
		call	resar2		;->r2..r5
		mov	dptr,#MASS0
	      call	saveIr2        		; R2-R5 --> MAS0
	 	
	      MOV	dptr,#MASS1+3
	      CALL	addx
		jmp	endsum
;массив из 10-ти измерений	?
mas10:	cjne	@r1,#10,mas20
		mov	dptr,#MASS8
	      CALL	xCIKLWR	  	;MASS8->MASS9
		mov	dptr,#MASS7
	      CALL	xCIKLWR	  	;MASS7->MASS8
       	MOV	dptr,#MASS6
	      CALL	xCIKLWR 	   ; MASS6 --> MASS7
	      MOV	dptr,#MASS5
		CALL	xCIKLWR   	  ; MASS5 --> MASS6
	      MOV	dptr,#MASS4
		CALL	xCIKLWR   	  ; MASS4 --> MASS5
		mov	dptr,#MASS3
		CALL	xCIKLWR	  	;MASS3->MASS4
      	MOV	dptr,#MASS2

	      CALL	xCIKLWR 	   ; MASS2 --> MASS3
		MOV	dptr,#MASS1
	      CALL	xCIKLWR   	  ; MASS1 --> MASS2
	      MOV	dptr,#MASS0
		CALL	xCIKLWR   	  ; MASS0 --> MASS1

		mov	r0,#rez_A
		call	resar2		;->r2..r5
	;call	aform
		mov	dptr,#MASS0
	      call	saveIr2        		; R2-R5 --> MAS0
	 
	      MOV	dptr,#MASS1+3
	      CALL	addx
	      MOV	dptr,#MASS2+3
	      CALL	addx
	      MOV	dptr,#MASS3+3
	     CALL	addx
	      MOV	dptr,#MASS4+3
	      call	addx
		MOV	dptr,#MASS5+3
	     CALL	addx
	      MOV	dptr,#MASS6+3
	      CALL	addx
	      MOV	dptr,#MASS7+3
	     CALL	addx
	     MOV	dptr,#MASS8+3
	      call	addx
		MOV	dptr,#MASS9+3
	     call	addx
		jmp		endsum

rmas4:	jmp		mas4
;массив из 20-ти измерений
mas20:	cjne	@r1,#20,rmas4
		mov		dptr,#MASS18
	      CALL		xCIKLWR	  	;MASS18->MASS19	?
		mov		dptr,#MASS17
	      CALL		xCIKLWR	  	;MASS17->MASS18
       	MOV	  dptr,#MASS16
	      CALL	   xCIKLWR 	   ; MASS16 --> MASS17
	      MOV	   dptr,#MASS15
	       
	      CALL	   xCIKLWR   	  ; MASS15 --> MASS16
	      MOV	   dptr,#MASS14
	      CALL	   xCIKLWR   	  ; MASS14 --> MASS15
		mov		dptr,#MASS13
	      CALL		xCIKLWR	  	;MASS13->MASS14
      	MOV	   dptr,#MASS12
	      CALL	   xCIKLWR 	   ; MASS12 --> MASS13
	      MOV	   dptr,#MASS11
	        
	      CALL	   xCIKLWR   	  ; MASS11 --> MASS12
	      MOV	   dptr,#MASS10
	      CALL	   xCIKLWR   	  ; MASS10 --> MASS11
		MOV	   dptr,#MASS9
	      CALL	   xCIKLWR   	  ; MASS9 --> MASS10
		mov		dptr,#MASS8
	      CALL		xCIKLWR	  	;MASS8->MASS9
		mov		dptr,#MASS7
	     CALL		xCIKLWR	  	;MASS7->MASS8
     		MOV	  dptr,#MASS6
	      CALL	   xCIKLWR 	   ; MASS6 --> MASS7
	      MOV	   dptr,#MASS5
	      CALL	   xCIKLWR   	  ; MASS5 --> MASS6
	      MOV	   dptr,#MASS4
	      CALL	   xCIKLWR   	  ; MASS4 --> MASS5
		mov		dptr,#MASS3

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
		mov	dptr,#MASS0
	      call	saveIr2        		; R2-R5 --> MAS0
	      MOV	dptr,#MASS1+3
	      CALL	addx
	      MOV	dptr,#MASS2+3
	      CALL	addx
	      MOV	dptr,#MASS3+3
	     CALL	addx
	      MOV	dptr,#MASS4+3
	      call	addx
		MOV	dptr,#MASS5+3
	     CALL	addx
	     MOV	dptr,#MASS6+3
	     CALL	addx
	     MOV	dptr,#MASS7+3
	     CALL	addx
	     MOV	dptr,#MASS8+3
	     call	addx
		MOV	dptr,#MASS9+3
	     call	addx
;27
		MOV	   dptr,#MASS10+3
	      CALL	 addx
		MOV	dptr,#MASS11+3
	      CALL	 addx
	      MOV	dptr,#MASS12+3
	      CALL	 addx
	      MOV	dptr,#MASS13+3
	     CALL	 addx
	      MOV	dptr,#MASS14+3
	      call	 addx
		MOV   dptr,#MASS15+3
	     	CALL	 addx
	      MOV	dptr,#MASS16+3
	      CALL	 addx
	      MOV	dptr,#MASS17+3
	     CALL	 addx
	     MOV	dptr,#MASS18+3
	      call	 addx
		MOV	dptr,#MASS19+3
	     call	 addx
		jmp		endsum
;массив из 4х измерений
mas4:			
		MOV	   dptr,#MASS2
	      CALL	   xCIKLWR 	   ; MASS2 --> MASS3
	      MOV	   dptr,#MASS1
	      CALL	   xCIKLWR   	  ; MASS1 --> MASS2
	      MOV	   dptr,#MASS0
	      CALL	   xCIKLWR   	  ; MASS0 --> MASS1
		
		mov	r0,#rez_A
		call	resar2		;->r2..r5
	;call	aform
		mov	dptr,#MASS0
	      call	saveIr2        		; R2-R5 --> MAS0
	 
	      MOV	dptr,#MASS1+3
	      CALL	addx
	      MOV	dptr,#MASS2+3
	      CALL	addx
	      MOV	dptr,#MASS3+3
	     CALL	addx
	     
endsum:	;23.03	
		mov	r0,#chmas;8.11.06  		;0..n(0..2,0..10)
		inc	@r0
		mov	a,@r0	
		jb	bitmas,masfull		;массив заполнен 2/10 значениями
		cjne	a,chmasN,masx5
		setb	bitmas			;массив заполнен
masfull:	mov	chmas,chmasN
		mov	r0,#chmasN
		mov	a,@r0
;masfull:
		cjne	a,#2,nochn2
		MOV	DPTR,#ch2;10 
		CALL  ldc_ltemp		 ; ltemp <-- 2
		jmp	mas5div

nochn2:	cjne	a,#10,nochn10
		MOV	DPTR,#ch10 
		CALL  ldc_ltemp		 ; ltemp <-- 10
		jmp	mas5div

nochn10:	cjne	a,#20,nochn20
		MOV	DPTR,#ch20 
		CALL  ldc_ltemp		 ; ltemp <-- 20
		jmp	mas5div

nochn20:	MOV	DPTR,#ch4 
		CALL  ldc_ltemp		 ; ltemp <-- 4
		jmp	mas5div

masx5:	mov	ltemp+3,chmas			;массив не заполнен
		clr	a
		mov	ltemp+2,a
		mov	ltemp+1,a
  		mov	ltemp,a

mas5div:	CALL	zdiv;divide, R2-R5 =(MAS0+MAS1+MAS2+MAS3+MAS4)/5
;получен результат 3 байта и знак
		mov	r0,#rez_A1
		call	saver2		 ;сохр среднее по массиву
;;8.11.06			mov		chmasN,#0
		clr	c
		mov	r1,#parT
		mov	a,#2
		subb	a,@r1
		jnc	ankor		;T<3
			;A-=РЕЗ1				;T>3
		call	altof			;r2..r5->float
		mov	r0,#rez_Ame
		call	saver2

		mov	r0,#koefKp;->r8..r11
		mov	a,r2
		jnb	acc.7,nminus3
		mov	r0,#koefKm;->r8..r11
nminus3:	call	resar8
		call	flmul  ;результат в плавающем формате м.б. его сохранить?
		mov	r0,#rez_Ame
		call	saver2
		jmp	gotoKD

ankor:	mov	r0,#chinkor
		mov	a,@r0
		jnb	acc.7,nokorr
	;коррекция 0
		jmp	kornul
nokorr:	
		;mov	r10,#00		;	chavt
		;mov	r11,#00h
		mov	r0,#chavt	
		mov	a,@r0;call	chcmp		;сравн счетчик авто калибровки с 0h
		jnb	acc.7,nonulavt;jnz		nonulavt	
		mov	r10,#0;1;00;02		
		mov	r11,#0c8h;90h;0c8h;58h
		mov	r0,#chinkor
		call	chcmp
		jnz	noavk
	;автокалибровка
		jmp		autoka;noavk;

rafterK:	jmp		afterK

gotoKD:		clr		c
 		mov		r1,#parT
		mov		a,#4
		subb		a,@r1
		jnc		rafterK		;T<5
	;A1-=A-	*KD			;T>5
	;call		findkoef				;r2,r3-hex
	;call		rebyte2				;r2..r5- hex
	;	call	altof			;r2..r5->float
	;	mov	dptr,#CHtho;100000
	;	call	ldc_ltemp			;r8..r11
	;	call	fldiv
	;	call	move28
		mov	r0,#rez_Ame;->r2..r5   ?/
		call	resar2
	;call	flmul
		call	ftol			;float->int
		mov	r0,#rez_A1
		call	saver2
		mov	r0,#rez_A0;->r8..r11 hex
		call	resar8
		call	lsub		;A3=A-1-A0
		mov	r0,#rez_A3
		call	saver2

		jmp	labelB	;?upper
 ;;;;;;;;;;; 9.11.06
nonulavt:	mov	r0,#parT
		mov	a,@r0
		xrl	a,#01
		jnz	avtdec1
		mov	r1,#chavt+1	;T=1 chavt-10
		call	tenmin
kordec10:	mov	r1,#chinkor+1
		call	tenmin
		jmp	rezmul

rmo220:	jmp	mo220

avtdec1:	mov	r1,#chavt	
 		call	chdec		;chavt-1
;		jmp		kordec1;rezmul
noavk:	mov	r0,#parT
		mov	a,@r0
		xrl	a,#01
		jnz	kordec1
	;T=1 chinkor-10
		mov	r1,#chinkor+1
		call	tenmin
		jmp	rezmul

rnotestizm:	jmp	notestizm
kordec1:	mov	r1,#chinkor
		call	chdec 		; chinkor-1
		   ;9.11.06
;(РЕЗ1-АN)*K
rezmul:	mov	r0,#rez_A1;->r2..r5
		call	resar2
		call	altof	;r2..r5->float	6.06	
		mov	r0,#kor0_AN;->r8..r11
		call	resar8
		call	flsub
		mov	r0,#koefKp;->r8..r11
		mov	a,r2
		jnb	acc.7,nminus
		;jnb		bitznak,nminus
		
 		mov	r0,#koefKm;->r8..r11
nminus:	call	resar8
		call	flmul  ;результат в плавающем формате м.б. его сохранить?
		mov	r0,#rez_Ame
		call	saver2
 
afterK:	mov	a,r2
		anl	a,#7fh
		mov	r2,a
		mov	dptr,#ch_250;220;220000
		call	ldc_ltemp			;r8..r11=8
		call	flcmp
		jnc	rmo220		;A>220000

		jnb	biteizm,rnotestizm
		mov	r0,#vichR
		cjne	@r0,#21h,note21
		mov	r2,#50h		;-11a
		mov	r3,#18h		;k8
		call	rebyte2				;r2..r5- hex
		call	altof			;r2..r5->float
		push	rr2
		push	rr3
		push	rr4
		push	rr5
		mov	r2,#50h		;k10
		mov	r3,#20h
re11_7:	call	rebyte2			;r2..r5
		call	altof			;r2..r5->float
		call	move28
		pop	rr5
		pop	rr4
		pop	rr3
		pop	rr2
		call	fldiv
	;	mov			dptr,#ch_10
	;	call		ldc_ltemp			;r8..r11
	;	call		flmul
	;;;;;2.02.07
		push	rr2
		push	rr3
		push	rr4
		push	rr5
		mov	r2,#50h			;-11a
		mov	r3,#2ch			;Km
		call	rebyte2				;r2..r5- hex
		call	altof			;r2..r5->float
		call	move28
		pop	rr5
		pop	rr4
		pop	rr3
		pop	rr2
		call	flmul				;*Km
		mov	dptr,#CHtho;100000
		call	ldc_ltemp			;r8..r11=8
		call	fldiv

		jmp	temul
note21:	cjne	@r0,#22h,note22
		mov	r2,#50h			;-09a
		mov	r3,#10h			;k6
		call	rebyte2			;r2..r5- hex
		call	altof			;r2..r5->float
		push	rr2
		push	rr3
		push	rr4
		push	rr5
		mov	r2,#50h			;k8
		mov	r3,#18h
		jmp	re11_7
note22:	mov	r2,#50h			;-7a
		mov	r3,#08h			;k4
		call	rebyte2				;r2..r5- hex
		call	altof			;r2..r5->float
		push	rr2
		push	rr3
		push	rr4
		push	rr5
		mov	r2,#50h			;k6
		mov	r3,#10h
		jmp	re11_7	

notestizm:
		jnb	bitklb,komulpz
		mov	dptr,#chk	;100000
		call	ldc_long	;r2..r5
		jmp	komul
komulpz:	call	findkoef	;r2,r3-hex
		call	rebyte2		;r2..r5- hex
				
komul:	call	altof			;r2..r5->float
		mov	dptr,#CHtho;100000
		call	ldc_ltemp			;r8..r11=8
		call	fldiv
;A0,..	call	move28
temul:	call	move28
		mov	r0,#rez_Ame
		call	resar2
		call	flmul	  ;A1-=A-*KD  fl
		call	ftol			;float->int
		mov	r0,#rez_A1
		call	saver2
		call	altof			;r2..r5->float
		mov	a,r2
		anl	a,#7fh
		mov	r2,a
		mov	dptr,#ch_220;200;200000
		call	ldc_ltemp			;r8..r11=8
		call	flcmp
		jnc	rrmo220		;A>200000
	;	jnb		knizm,noavp;goA2;		bitizm,goA2	
	;	jb		bitavp,yesavp
		jnb	knizm,goA2
		jnb	bitvi11,qu_avp
		jmp	goA2
qu_avp: 	jb	bitavp,yesavp
noavp:	;jb	bitvi11,yesvich  ;уст после ввода A B (ввод ВЫЧИСЛИТЬ)
goA2:		;A2=A1-
		mov	r0,#rez_A1
		call	resar2
		mov	r0,#rez_A2
		call	saver2
goA3A2:	;A3=A2-A0
		mov	r0,#rez_A0
		call	resar8
		call	lsub
		mov	r0,#rez_A3
		call	saver2
		jb	bitvi11,yesvich

goonin:	;jmp	goonind;indA3;8.11.06
		mov	r0,#chind
		cjne	@r0,#0,rnochi0
		jmp	goonind;indA3

rrmo220:	jmp	mo220
rnochi0:	jmp	nochi0
gokaA2:	mov	r0,#rez_A1		;(float)
		call	saver2		;это необх для калибровки ,goA2 работает с этим знач
 		jmp	goA2

yesavp:	mov	a,r2
		anl	a,#7fh
		mov	r2,a
		mov	dptr,#ch_10th;10000
		call	ldc_ltemp			;r8..r11=8
		call	flcmp
		jnc	noavp		;A>10000	
		mov	r0,#diap		;10-11
		cjne	@r0,#9,avpgo
		jmp	noavp
avpgo:
		inc	@r0		;переключ диапазон на 1 позицию вниз
		cjne	@r0,#0ah,clmasv
		dec	@r0
clmasv:	;сбросить массив
		call	loadUS
		;call	louizm
		call	clmassix
		mov	r0,#summa
		call	clear4
		mov	r0,#rez_A0
		call	clear4
		clr	bitnul
		setb	bitzus	;bitbuf
		jmp	goonin

erra01:	pop	r11
		pop	r10
		pop	r9
		pop	r8
		clr	bitvich
		clr	bitvi11
		mov	nuerr,#34h;константа не должна быть равна0
		call	error
		call	ind
		call	z_1s
		jmp	goonin

mo500R_:
		jmp	mo500R
mo500I_:
		jmp 	mo500I		;error

yesvich:
		; 	mov		r0,#konstB
		;	call	resar2
		;	call	move28
		mov	r0,#rez_A3;A1
		call	resar2				;HEX
		call	altof			;r2..r5->float
		mov	a,r2			;модуль
		anl	a,#7fh
		mov	r2,a
;		call		fladd				;A1+B
				
		mov	dptr,#CH_500;
		call	ldc_ltemp			;r8..r11
		call	flcmp
		jc	mo500R_	;error <500 >22000
;!
		mov	dptr,#CH_22T;
		call	ldc_ltemp			;r8..r11
		call	flcmp
		jnc 	mo500I_
;!
		call	move28
		push	r8
		push	r9
		push	r10
		push	r11
		mov	r0,#konstA
		call	resar2
		mov	dptr,#ch0
		call	ldc_ltemp
		call	flcmp
		jz	erra01
		mov	dptr,#CH_B
		CALL  ldc_ltemp		 ; ltemp <-- 10-7
		call	flmul				;A*10-7
		pop	r11
		pop	r10
		pop	r9
		pop	r8
		call	fldiv			;результат R
		mov	r0,#rez_R
		call	saver2
		call	ftol			;float->hex

		mov	r0,#abin
		call	saver2


			jnb	is_rs,mr_5		;??
			jnb	bitvi11,mr_5	;alternative
			mov	r0,#rez_R
			jnb	bitoll,moveR3_
;			mov	r0,#rez_R
			mov	@R0,#81h
moveR3_:
			clr	EA
;			mov	A,#rez_R
;			mov	p_out,A
;			mov	cnt_out,#4
			mov	SBUF0,#7Fh	;was cmd_rez
tx1:
		jnb   TI,tx1
		clr   TI
		mov	SBUF0,@r0
		inc	r0
tx2:
		jnb   TI,tx2
		clr   TI
		mov	SBUF0,@r0
		inc	r0
tx3:
		jnb   TI,tx3
		clr   TI
		mov		SBUF0,@r0
		inc		r0
tx4:
		jnb   TI,tx4
		clr   TI
		mov		SBUF0,@r0
		inc		r0
		setb	EA
mr_5:

		mov	r0,#bufind
age9:
		mov	@r0,#" "	  ;погасить индикатор
		inc	r0
		cjne	r0,#bufind+11,age9
		mov	r0,#rez_R
		call	resar2

		mov	dptr,#CH_fl
		CALL  ldc_ltemp
		call	fldiv
		mov	r0,#work		;степень +
		mov	@r0,#0
		mov	r0,#work+1;степень -
		mov	@r0,#0
compa1:	mov	dptr,#ch_1;
		call	ldc_ltemp			;r8..r11
		call	flcmp
		jc	equ0		;<1
		mov	r0,#work			;степень +
		inc	@r0
		mov	dptr,#ch_10;
		call	ldc_ltemp			;r8..r11
		call	fldiv
		jmp	compa1				;work значение степени n(hex)  

mo500R:	mov	dptr,#teOLR
		call	lotext		 
		call	ind
		jmp	nobavp;nobitizm
mo500I:	mov	dptr,#teOLI
		call	lotext		 
		call	ind
		jmp	nobavp;nobitizm
equ0:		;	call		ftol			;float->int
		mov	r0,#work		;степень +
		cjne	@r0,#0,equ00
				
compa2:	mov	dptr,#ch_1;
		call	ldc_ltemp			;r8..r11
		call	flcmp
		jnc	equ00		;>1
		mov	r0,#work+1			;степень -
		dec	@r0							;0,ff(-1),fe(-2)...
		mov	dptr,#ch_10;
		call	ldc_ltemp			;r8..r11
		call	flmul
		jmp	compa2				;work значение степени n(hex)  

equ00:		
		mov	r0,#adec
		mov	r1,#abin+3	;hex->10
		call	bindec

;если степень полож убирать младший байт
;чтобы уложиться в 5 разрядов, если отриц располагать
;число в bufind..bufind+5
		mov	r0,#work
		cjne	@r0,#0,outr
		inc	r0			;work+1
		cjne	@r0,#0ffh,bufr3	;6разрядов нужно вывести 5
		inc	@r0;!!!!!!!!!?
		mov	r0,#adec+8		;разместить в буфер индикации R
		jmp	bufr30

bufr3:	inc	@r0			;?!!!!!!!!n+1
		mov	r0,#adec+9
bufr30:	mov	r1,#bufind+5;6
		mov	r7,#5;7
bufr2:	mov	a,@r0
		add	a,#30h
		mov	@r1,a
		dec	r1
		dec	r0
		djnz	r7,bufr2

		mov	r0,#abin
		call	clear4
		mov	r0,#work+1
		jmp	outr5
;work!=0 значит после дел на 10**9 получили число > с чем 6 разрядов					
outr:		mov	r0,#adec+9;разместить в буфер индикации R
		clr	c
		mov	r1,#work
		mov	a,r0
		dec	a					;n-1
		subb	a,@r1
		mov	r0,a			;adec+9-n !!!!!!!!!!!!!!!
		mov	r1,#bufind+5;т к число разрядов > чем знакомест
		mov	r7,#5;7
bufr:		mov	a,@r0
		add	a,#30h
		mov	@r1,a
		dec	r1
		dec	r0
		djnz	r7,bufr

		mov	r0,#abin
		call	clear4
		mov	r0,#work
outr5:	mov	a,@r0
		mov	abin+3,a
			;n(hex)->abin
		call	findR				;a=2(10-2)...11(10-11)
		add	a,abin+3
		mov	abin+3,a
		mov	r0,#adec
		mov	r1,#abin+3	;hex->10
		call	bindec
		mov	bufind+8,adec+9
		mov	bufind+7,adec+8
		mov	bufind+9,#66h
		orl	bufind+11,#10h;запятая после 1го знакоместа
		jmp	nobavp;nobitizm;	goonin;call	ind
					
mo220:	jnb	bitavp,indoll
		jnb	knizm,indoll	;bitizm,indoll
		mov	r0,#diap
		cjne	@r0,#0,nodi2
		   ;10-2
indoll:	jnb	bitizm,goonin1;чтобы не OLL было при нажатии кнопок меню,пам,вычR
		mov	dptr,#teOLL;OLL
		call	lotext
		jnb	bitvi11,goonin2
		mov	dptr,#teOLI
		call	lotext
		call	ind
goonin2:	setb	bitoll
goonin1:	jmp	goonin

nodi2:	dec	@r0	;переключить на 1 позицию вверх
		cjne	@r0,#0ffh,nodi9
		inc	@r0
nodi9:	call	loadUS
		;call	louizm
		;сбросить массив
		call	clmassix
		mov	r0,#summa
		call	clear4
		mov	r0,#rez_A0
		call	clear4
		clr	bitnul	
		setb	bitzus	;bitbuf флаг задержки	после установки us						 
		jmp	goonin

nochi0:	dec	@r0			;СТИ-1
		jmp	labelB	
nop3_0:	;;	;rez_A-rez_A0
		;;			mov		r0,#rez_A0
		;;			call	resar8
		;;			call	lsub
		;;			mov		r0,#rez_A
		;;;			call	saver2

no3parN:	cjne	@r1,#2,no2parN
		;в байт 0  записать пробел
		mov	r1,#bufind+6
		mov	@r1,#" ";0fdh;
		jmp	seeind		;moveA3

no2parN:			;в байты 0 и 1 записать пробел
		mov	r1,#bufind+5
		mov	@r1,#" ";0fdh;" "
		inc	r1
		mov	@r1,#" ";0fdh;" "
		jmp	seeind		;moveA3
rseeind:	jmp	seeind

goonind:		  ; ВЫДАЧА НА ИНДИКАТОР РЕЗУЛЬТАТА


moveA3:	;нажата кн вычR	не выдавать на индикатор не портить bufind..
		;по нажатию кн по прерыванию по выходу из прерыв прог доходит
		;до конца цикла измерения результат не размещать в буфере
		;не забывать сбрасывать по выходу из режима обр кнопки 
		;и возврату в режим измерения
		jb		bitvich,rnorvich
		jb		bitt2,rnorvich
		jb		bitoll,rseeind
		jb		bitmenu,rseeind
		jb		bitmem,rseeind
	; mov		r0,#rez_A3
	;call	resar2
 	;call	ftol			;float->int r2..r5
		mov	r0,#rez_A3;->r2..r5	  передать A3 в индикатор
		call	resar2;????????????????17.01.07
				
		call	maform
		mov	r0,#abin
		call	saver2
		mov	r0,#adec
		mov	r1,#abin+3	;hex->10
		call	bindec
				
		mov	r0,#adec+9;разместить в буфер индикации
		mov	r1,#bufind+6
		mov	r7,#7
bufdec:	mov	a,@r0
		add	a,#30h
		mov	@r1,a
		dec	r1
		dec	r0
		djnz	r7,bufdec
		mov	r0,#bufind+7
		mov	@r0,#2dh	  ;-2..-9
		mov	r0,#bufind
		mov	@r0,#2bh
		jnb	znmat,nozzmi;bitznak,nozzmi
		mov	@r0,#2dh
nozzmi:	mov	r1,#diap
		mov	r0,#bufind+8
		mov	a,@r1
		cjne	a,#8,nodi8
		jb	biteizm,seegoon
		mov	@r0,#30h		 ;10-10
		dec	r0
		mov	@r0,#63h;31h
		inc	r0
		jmp	seegoon
nodi8:	cjne	a,#9,nodis9
		jb	biteizm,seegoon
		mov	@r0,#31h	   ;10-11
		dec	r0
		mov	@r0,#63h;31h
			
		inc	r0
		jmp	seegoon

rnorvich:	jmp	norvich
rno3parN:	jmp	no3parN

nodis9:	add	a,#32h
		mov	@r0,a;#37h;"T";
seegoon:	inc	r0
		mov	@r0,#"A";"E";
		inc	r0
		mov	@r0,#00h ;=feh в нач установе для поджига всех сегм
		inc	r0;		mov		bufind+11
		mov	@r0,#010h		;bufind+11.4 точка после первой цифры
					
;;;;;;goonind:
		mov	r1,#parN	; ??????
		cjne	@r1,#3,rno3parN ;  8.11.06
	
seeind:				;;;;;;;;;;;;;
		mov		r0,#bufind+10
		mov		a,@r0
		jnb		bitnul,nnnul
		orl		a,#08h
		mov		@r0,a
nnnul:	mov		r1,#parT
		cjne		@r1,#2,nsec1
		orl		a,#20h	  ;1s
		mov		@r0,a
		jmp		nsec10
nsec1:	cjne		@r1,#1,nsec11
		orl		a,#40h			;10s
		mov		@r0,a
		jmp		nsec10
				
nsec11:	orl		a,#10h
		mov		@r0,a			 ;0,1s

nsec10:	mov		r0,#bufind+10	
		mov		a,@r0;mov		@r0,a
		jnb		bitavp,nobavp
		orl		a,#04		;bufind+10.2
		mov		@r0,a
	;	mov		@r0,a	
nobavp:	mov		r0,#bufind+10	
		mov		a,@r0;mov		@r0,a	
		jnb		knizm,nobitizm
		orl		a,#02
		mov		@r0,a
nobitizm:			
		jnb		bitakt,notakt
		clr		bitakt
		anl		bufind+10,#0feh
		jmp		taktind
notakt:	setb	bitakt
		orl		bufind+10,#01					
taktind:		
;;;;;;;;;
		jnb		biteizm,yesind
		mov		r1,#vichR
		mov		r0,#bufind+8
		mov		@r0,#'T'
		inc		r0
		cjne	@r1,#21h,test9i
		mov		@r0,#31h;11A
		;	dec		r0
		;	mov		@r0,#63h
		jmp		yesind

test9i:	cjne		@r1,#22h,test7i
		mov		@r0,#32h;39h;09A
		jmp		yesind
test7i:	mov		@r0,#33h;37h;07A
;;;;;;;;;
yesind:		
		jnb		bitklb,noklb
		orl		bufind+10,#80h; on kmp
noklb:	jnb		bitbon,nobuf
		orl		bufind+11,#02h; on pysk
nobuf:		;;;;;
          	jnb		knizm,anlp1
		mov		r1,#diap
		clr		c
		mov		a,#1
		subb		a,@r1
		jc		nop1oll
anlp1:	jnb		p1.1,nop1oll
		mov		nuerr,#35h
		call		error	;ошибка 5 перегрузка на диап 10-2,10-3	
nop1oll:	call		ind	;пп выдачи на индикатор


;	jnb	is_cmd,norvich		;??
;	call	cmd_tree



norvich: 
     		mov		r0,# parT
		mov		r1,#chind
		cjne		@r0,#1,rnot1in
labelB:	;;;;;;;;;;;
		;сдвиг по алгоритму чтобы посмотреть в цапе 
		mov 		r0,#rez_A3+3
		;;;;;;;;
		mov		r1,#work+3
		mov		a,@r0
		mov		r7,#7;кол сдв вправо
dvig3:	clr		c
		rrc		a
		djnz	r7,dvig3 ;d7,d6,d5	  мл байт
		mov		r2,a	;сохр байт
		dec		r0		;rez_A3+2
		mov		a,@r0
		push	acc
		clr		c
		mov		r7,#1
dvig2:	clr		c
		rlc		a
		djnz	r7,dvig2 ;d12..d11	 средний байт
		orl		a,r2
		mov		@r1,a;сформ мл байт
		dec		r1
		pop		acc
			
		mov		r7,#7
dvig1:	clr		c
		rrc		a
		djnz	r7,dvig1 ;d18	  ср байт
		mov		r2,a   ;сохр
		dec		r0
		mov		a,@r0 ;rez_A3+1
		push	acc
		
		mov		r7,#1
dvig0:	clr		c
		rlc		a
		djnz	r7,dvig0 ;	  d21..d16
		orl		a,r2
		mov		@r1,a	; сформ средний  байт
		dec		r1
		pop		acc	  ;rez_A3+1
			;;;;;;;;;;;;;;
;			jb		acc.7,dvm
		clr		c
		mov		r7,#7
dvig4:	clr		c
		rrc		a
		djnz	r7,dvig4 ;	  d22
		mov		r2,a	;сохр
		dec		r0		;	rez_A3
		mov		a,@r0
		;;;;;
		mov		r7,#1
vig0:		clr		c
		rlc		a
		djnz	r7,vig0 ;	  d24..d30
		orl		a,r2
		mov		@r1,a	; сформ   байт
		dec		r1
		mov		a,@r0
		;;;;;
		jb		acc.7,dvm
		clr		c
		mov		r7,#7
vig4:		clr		c
		rrc		a
		djnz	r7,vig4 ;	  d
		jmp		endsdv

rnot1in:	jmp		not1in

;;;;;;;;;;;;					
dvm:		mov		r7,#7
dvig6:	setb		c
		rrc		a
		djnz	r7,dvig6 ;	  d31
endsdv:	mov		@r1,a
							
 ;->work   
;? 		jnb			is_mem,md_3		???????????????????????
;		call		resa_hl
;		call		reA3_m		;write A3 to Mem
;		call		save_hlm		;bound of 200
;		setb		EA
;		sjmp		me_5

md_3:

md_5:
	jnb	is_rs,me_5
	jb	bitvi11,me_5	;??rez_R is out
	jnb	bitoll,moveA3_
	mov	r0,#rez_A3
	mov	@R0,#81h
moveA3_:
	mov	A,#rez_A3	;Ame,..; bufind - no use: for fastest isn't screen output
	mov	p_out,A
	mov	cnt_out,#4
	mov	SBUF0,#7Fh	;was cmd_rez
me_5:			;??????????????????
 		jnb	is_2,me_6
		call	resa_hl ;dptr=(saven_bl)/2/3/4
		call	loA3_X	;4 inc dptr
		call	save_hl	;адрес след ячейки внешн озу храним в ячейке saven_bl
		mov			r0,#diap
		mov			a,@r0
		mov			r1,#nblok
		cjne		@r1,#1,nosv1	;?????
		mov			sadiap,a
		jmp			tostro
nosv1:	cjne		@r1,#2,nosv2
		mov			sadiap2,a
		jmp			tostro
nosv2:	cjne		@r1,#3,nosv3
		mov			sadiap3,a
		jmp			tostro
nosv3:		
		mov			sadiap4,a
tostro:

;		inc		cnt_out
;		mov		a,#200
;		subb	a,cnt_out
		dec		cnt_out
		mov		A,cnt_out
		jnz		me_6
		clr		is_2
		mov		R0,#parT
		mov		@R0,#2	;1 sec
		mov	IE,#90h ;Снятие блокировки всех прерываний+RS
;	setb	is_izm	;???
	jmp	after_2	;keyb1
me_6:
			;??????????????????
		mov		dptr,#chzap
		call	ldc_long
		mov		r0,#work+3
		call	ladd
		mov		a,r5
		mov		DAC0L,a
			
		mov		a,r4
		mov		DAC0H,a

					;;;;;;;;;;
		mov			r0,#chbuf		;float
		call		resar2
		mov			dptr,#ch_2;ch0;ch_1
		call		ldc_ltemp
		call		flcmp
		jnc			rnobuf0
					
		mov			dptr,#ch_1
		call		ldc_ltemp
		call		flsub
		mov			dptr,#chbuf1			;СБ1 внешн озу
		mov			a,r2
		movx		@dptr,a
		inc			dptr
		mov			a,r3
		movx		@dptr,a
		inc			dptr
		mov			a,r4
		movx		@dptr,a
		inc			dptr
		mov			a,r5
		movx		@dptr,a
					
					
					;jnc			rnobuf0
		jb		bitprd,yesprd	;передать   A3 в буфер
		jb		bitbon,yesbuf	;записать   A3 в буфер
		jmp		gocikle
rnobuf0:	jmp		nobuf0
yesprd:	;передать   A3 в буфер
		jmp		goonT
yesbuf:		;записать   A3 в буфер
		call		resa_hl;dptr-
		call		loA3_X	;адрес след ячейки внешн озу храним
									;в ячейке saven_bl
		call		save_hl
		mov			r0,#diap
		mov			a,@r0
		mov			r1,#nblok
		cjne		@r1,#1,nosav1
		mov			sadiap,a
		jmp			gotostrob
nosav1:	cjne		@r1,#2,nosav2
		mov			sadiap2,a
		jmp			gotostrob
nosav2:	cjne		@r1,#3,nosav3
		mov			sadiap3,a
		jmp			gotostrob
nosav3:		
		mov			sadiap4,a
		jmp			gotostrob

			;строб
gotostrob:
		mov		a,P6	   	;p6.4=0
		anl		a,#0efh
		mov		P6,a
		nop
		nop
		mov		a,P6			;p6.4=1	
		orl		a,#10h
		mov		P6,a
				;;;;;;;;;
		mov		a,PCA0CPM0;	
		orl		a,#46h;anl		a,#0fbh
		mov		PCA0CPM0,a
		mov		TH2,#0d0h
		mov		TL2,#00

		setb		T2CON.2
		setb		ET2;IE.5			    
goonT:	mov		r0,#interva;high  byte loadr2
		mov		a,@r0
		mov		r4,a
		inc		r0
		mov		a,@r0
		mov		r5,a
		clr		a
		mov		r3,a
		mov		r2,a				;r2..r5-interval(hex)
		call		altof			;r2..r5->interval (float)

		mov		r0,#parT
		cjne		@r0,#1,nott1
		mov		dptr,#ch_2	 
		call		ldc_ltemp
		jmp		intmul

nott1:	cjne	@r0,#2,nott2
		mov		dptr,#ch_10	 
		call		ldc_ltemp
									
intmul:	call		flmul					;*10
intmul1:	mov		dptr,#chbuf1	;СБ1
		movx	a,@dptr
		mov		r8,a
		inc		dptr
		movx	a,@dptr
		mov		r9,a
		inc		dptr
		movx	a,@dptr
		mov		r10,a
		inc		dptr
		movx	a,@dptr
		mov		r11,a
		call		fladd		;СБ+СБ1
intmul2:	mov			r0,#chbuf
		call		saver2		;*2
				
		jmp		gocikle

nott2:	cjne	@r0,#3,nott3
		mov			dptr,#ch_2	 
		call		ldc_ltemp
		call		flmul
		jmp			intmul2					;*2


nott3:	cjne	@r0,#4,nott4
		mov			dptr,#ch_10	 
		call		ldc_ltemp	;/10*4
		call		fldiv
		mov			dptr,#ch_4	 
		call		ldc_ltemp
		call		flmul
		jmp		intmul2

nott4:	cjne	@r0,#5,nott5
 		mov		dptr,#ch_2	 
		call		ldc_ltemp;*2
		call		flmul
		jmp		intmul2;T=5
nott5:	;	mov		dptr,#ch_1	 
		;	call		ldc_ltemp
		;	call		flmul
		jmp	intmul2					;*1


gocikle:	jnb	bitzus,nofz			
		call	z_05s	 ;0,5c
		call	z_05s	 ;0,5c
		clr	bitzus	;bitbuf бит задержки засылки us
nofz:		jmp 	labelA;rebyte


yestt5:	jmp		gocikle

nobuf0:	mov		r0,#chbuf
 		call		resar2
		mov			dptr,#ch_1	 
		call		ldc_ltemp
		call		flsub
		mov			r0,#chbuf	
		call		saver2  
		jmp		gocikle


not1in:	cjne	@r0,#2,not2in
		mov		@r1,#1		 ;T=2
		jmp 	labelB

not2in:	cjne	@r0,#3,not3in
		mov		@r1,#1;9		;T=3
		jmp 	labelB
not3in:	mov		@r1,#3;19
		jmp 	labelB


;;;;;;;;;;;3.11.06

;;коррекция 0
KORnul:	mov		r0,#chdel
		cjne	@r0,#0,nonuldel
				
		mov		a,p4			;сохр  us
		mov		saus,a
		mov		a,p5
		mov		saus+1,a

		mov		dptr,#kor0us
		call	lospus		;упр слово коррекции 0
		jmp	chdelmo

nonuldel:  	;cjne	@r0,#7,no4del
		cjne	@r0,#3,no4del
			;рез ->AN
		mov	r0,#rez_A;->r2..r5
		call	resar2
					;;;;;;;;;;
		call	altof		;r2..r5->float
		mov	r0,#kor0_AN;->kor0_AN
		call	saver2
				
		mov		a,saus			;восстан исходное упр слово
		mov		p4,a
		mov		a,saus+1
		mov		p5,a 		
chdelmo:	mov		r0,#chdel
		inc		@r0		;chdel+1
		jmp		 rebyte

no4del:		;cjne	@r0,#14,chdelmo
		cjne	@r0,#6,chdelmo
		mov		@r0,#0		;chdel
		mov		r0,#chinkor
		mov		@r0,#2;00;
		inc		r0
		mov		@r0,#58h;0c8h
		call	clmassix;сбросить массив скольз среднего
bonpart:
		jnb		bitbon,rebyter
		mov		r0,#chbuf
		call		resar2
		mov		r1,#parT
		cjne		@r1,#2,no6del
		mov		dptr,#ch_7;5
no5del:
		call		ldc_ltemp
		call		flsub	
		mov		r0,#chbuf
		call		saver2
		jmp		rebyte
no6del:
		mov		dptr,#ch_1
		jmp		no5del

rebyter:	jmp		rebyte

tekaout:	mov		r1,#chavt
		mov		@r1,#0ch;6;1;
		inc		r1
		mov		@r1,#80h;40h;
		jmp		noavk

;автокалибровка
autoka:	jb		bitbon,tekaout;rebyter
nulavt:  ;;;;;
		mov		r0,#chdel
		cjne	@r0,#0,nndelch
		mov		a,p4			;сохр  us
		mov		saus,a
		mov		a,p5
		mov		saus+1,a

		mov   a,p5
		orl		a,#04		   ;p5.2=1
		nop
		nop
		anl		a,#3fh		;p5.6,p5.7=0
		mov   p5,a
		inc		@r0
		jmp		 rebyte
nndelch:	cjne	@r0,#3,n4delch
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
		mov	r0,#rezAp;->rezAp
		call	saver2				
		mov	r0,#kor0_AN;kor0_AN->r8..r11
		call	resar8				
		call	flsub		; r2..r5(A+-AN)
		call	move28	   ;r2..r5->r8..r11
		mov	dptr,#CH2tho;000->r2..r5 float
		call	ldc_long		
		call	fldiv
		mov	a,r2
		anl	a,#7fh
		mov	r2,a
		mov	r0,#koefKp;->koefKp
		call	saver2
		 
		;anl		P5,#0feh		;p5.0=0	
		mov	a,P5
		anl	a,#3bh;acp-
		mov	P5,a
		mov	r0,#chdel
		inc	@r0			  ;ch+1
		jmp	rebyte

n4delch:	cjne	@r0,#6,n8delch
		; pez->A-
		;K-=000/(A--AN)
		;	mov	r0,#rez_A;->r2..r5
		;	call	resar2
		mov	a,reacp		;r2..r5	&&&&&&&&&&&
		mov	r2,a
		mov	a,reacp+1
		mov	r3,a
		mov	a,reacp+2
		mov	r4,a
		mov	a,reacp+3
		mov	r5,a
				;;;;;;;;;;;;;;;
		call	altof			;r2..r5->float
		mov	r0,#rezAm;->rezAm
		call	saver2				
		mov	r0,#kor0_AN;kor0_AN->r8..r11
		call	resar8				
		call	flsub			; r2..r5(A--AN)
		call	move28	   		;r2..r5->r8..r11
		mov	dptr,#CH2tho	;000->r2..r5 float
		call	ldc_long		
		call	fldiv
		mov	a,r2
		anl	a,#7fh
		mov	r2,a
		mov	r0,#koefKm;->koefKm
		call	saver2
		 
		mov	a,saus			;восстан исходное упр слово
		mov	p4,a
		mov	a,saus+1
		mov	p5,a 		
		mov	r0,#chdel
		inc	@r0			  ;ch+1
		jmp	rebyte

n8delch:	cjne		@r0,#9,n12delch
		mov		@r0,#0
		mov		r1,#chavt
		mov		@r1,#3eh;0ch;
		inc		r1
		mov		@r1,#80h;
		call		clmassix     ;сбросить массив среднего
		jmp		rebyte;	bonpart;
n12delch:	inc		@r0
		jmp		rebyte



		            
rout6:	jmp		out6
rlabelF:	jmp		labelF	
rknrazr:	jmp		knrazr	
rknopt:	jmp		knopt
rizman:	jmp		izman
	
no0chkl:	jmp		kkout6
;?never here
		mov		P3IF,#00;		обязательно сбросить опять приходит на обработку прерывания
		mov		P3,#0c0h
		reti
keyb1:	;IE6
;;;;;
 		;	mov			a,chkl+1		;low
		;	jnz			no0chkl
		;	mov			a,chkl				;high
		;	jnz			no0chkl
;;;;;
		mov		EIE2,#00H
		mov		P3IF,#00
				
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
		push	dpl
		push	dph
				;clr		bitmig
		  ;;;;;;;;;;;;;;
		 call	z_01s;0,1s
				;	call	z_01s
				;восстан знакоместо при мигании
				;т к в соотв яч буфера индикации пишется 20h(пробел)
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		mov		@r1,savba
				;;;;;;;;;;;
;???
		
		jnb		is_izm,gout6__
		clr		is_izm
			jmp	izman	;button 'izm'?

;gout6_:
;		jnb		is_mem,gout6__
;		clr		is_mem
;			jmp	findmem	;button 'mem'?

gout6__:	;usual

		mov		a,p3
		jb		acc.6,outviR;выход из режима выч R
gout6:	mov		a,p3
		orl		a,#0ffh		; p3.(5-0)<-3f
		mov		p3,a
		mov		a,p3
		jnb		acc.6,rout6		;error
		jnb		bitizm,rlabelF
		mov		p3,#0feh		;реж IZM
		mov		a,p3
		jnb		acc.6,rizman
				;;;;;;
		jb		bitklb,goklb
		mov		p3,#0fdh
		mov		a,p3
		jnb		acc.6,rknrazr		  ;labelC
		mov		p3,#0fbh
		mov		a,p3
		jnb		acc.6,knright		;->
		mov		p3,#0f7h
		mov		a,p3
		jnb		acc.6,rknopt			;T
		mov		p3,#0efh
		mov		a,p3
		jnb		acc.6,pyskst			;pysk/stop
		mov		p3,#0dfh
		mov		a,p3
		jnb		acc.6,knvich
		jmp		izmpaT

outviR:	jnb		bitvi11,gout6	
		clr		bitvich				;выход из режима выч R	
		clr		bitvi11
				
goklb: 	jmp		out6

pyskst:	jb	bitbon,bufon		;pysk/stop
		setb	bitbon	;уст реж буфер вкл
;??		mov	r1,#volume	;work	обьем блока
;		mov	@r1,#00
;		inc	r1
;		mov	@r1,#0c7h		;320h/4
		orl	bufind+11,#02h	; on pysk
		call	ind
		jmp	izmpaT
bufon:	clr	bitbon	;уст реж буфер выкл
		anl	bufind+11,#0fdh; off pysk
		call	ind
		jmp	izmpaT

tizmri:	mov	r1,#level
		cjne	@r1,#1,right2
				;10s->HET
		jmp		right3

right2:	inc		@r1
		call		lolevT
		;call	loadT	;нажата кн-> в реж Tизм 
right3:	call		ind
		jmp		izmfun

			
			
knright:	mov		r1,#diap
		;перекл диапазон 1 поз вверх сбр массив
		dec		@r1
		cjne	@r1,#0ffh,diinc
		mov		@r1,#0
		jmp		izmfun
diinc:	call		clmassix
		mov		r0,#summa
		call		clear4
		mov		r0,#rez_A0
		call		clear4
		clr		bitnul		;гасить светодиод НУЛЬ	
		call		loadUS
		jmp		izmfun

vit2_10:	jmp		out6


knvich:	;12.02.07
		mov		r0,#parT
		clr		c
		mov		a,#4 
		subb		a,@r0
		jc		vit2_10;не нажимать кнопку ВЫЧ R T=10ms,2ms
		jb		biteizm,vit2_10;не нажимать кнопку ВЫЧ во время теста
		jb		bitvi11,onvich
		clr		bitizm
		setb		bitvich
				
		mov		r0,#vichR
		mov		@r0,#11h;;????????or 0
			;ВЫЧИСЛИТЬ
		mov		dptr,#teVICH
		call		lotext
		call		z_1s;;;;;;;
		jmp		viout;izmpaT

onvich:	clr		bitvich	;???
						;;;;;;;;28.02
		clr		bitvi11
		setb		bitizm
						;;;;;;;;;
		mov		r0,#vichR
		mov		@r0,#0
		jmp		izmpaT
; изм упр слова при нажатии ИЗМ	d3(k5 p4),d3(u5 p5)
louizm:	jnb		knizm,lou
		mov		r1,#diap
		clr		c
		mov		a,#3
		subb		a,@r1
		jnc		lldi23	;10-2..10-5
			;10-6..10-11
		mov		a,p4
		anl		a,#0f7h	;d3
		mov		p4,a
lldi23:	mov	   	a,@r1
		xrl		a,#3
		jnz		lldi3
		jmp		lldi2		;10-5
lldi3:	mov	   	a,@r1
		xrl		a,#2		;
		jnz		lou		
lldi2:	mov		a,p5		;10-4
		orl		a,#08
		mov		p5,a
lou:		ret
			  ;;;;;;
izman:	jb		biteizm,ontest	
		jb		knizm,knizmon
izman1:
		setb		knizm		;уст реж ИЗМ ВКЛ
		;	d3(k5 p4),d3(u5 p5)заслать us
		call		louizm 
		jmp		izmfun


knizmon:	clr		knizm		;уст реж ИЗМ ВЫКЛ
		call		loadUS;восстановить us
izmfun:			
		setb		bitzus;bitbuf
ontest:	jmp		labelE;;;;;;;;;;;;
				;;;;;;;;;;;;;;
izmpaT:
;;;;;;;;;;;;;;;;;
 		;	clr		c 
		;	mov		r1,#parN

		;	mov		r0,#diap
		;	mov		a,#6    	
		;	subb	a,@r0
		;	jnc		labelE		;	  ;10-2..10-8
			  
		;	mov		@r1,#2		;10-9..10-11		
		;	jmp		labelE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
labelE:	mov		r0,#parT
		mov		r1,#chkl
		cjne	@r0,#1,izmt2
		mov		@r1,#0
		inc		r1
		mov		@r1,#1;2
		jmp		out6
izmt2:	cjne	@r0,#2,izmt3
		mov		@r1,#0
		inc		r1
		mov		@r1,#2;10;20
		jmp		out6

izmt3:	mov		@r1,#0
		inc		r1
		mov		@r1,#10;20;0
		jmp		out6




knopt: ;кнопка T				???
		clr		bitizm
		setb		bitt2
		mov		r1,#load
		mov		@r1,#4;1s
		call		loadT		;T=1S,10S,HET,0.1S,50mS,
		
viout:	mov		r1,#chkl
		mov		@r1,#03
		inc		r1
		mov		@r1,#0e8h		;1000
		jmp		out6

knrazr:		 ;???
labelC:	clr		c
		mov		r0,#parN
		mov		r1,#parT
		mov		a,#2
		subb		a,@r1
		jc		labelE		;T>2
		cjne		@r0,#1,noN1c
		mov		@r0,#2		;N=2
		jmp		labelE

noN1c:	cjne		@r0,#2,not_1
		mov		@r0,#3		;N=3	  ;10-2..10-8
		jmp		labelE

not_10:	
not_1:	mov		@r0,#1				;N=1
		jmp		labelE

rtizmri:	jmp		tizmri

ttout:	mov		p3,#0f7h
		jb		p3.6,viout
		setb		bitizm	;отжатие кнопки t
		clr		bitt2
		jmp		labelE
labelf:	   		
		jnb		bitt2,nofizm
		mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,ttout;outF
		mov		r1,#load;parT
		cjne		@r1,#5,noft1
		   ;t=10s
		jmp		viout;out6;ft1izm

noft1:	inc		@r1;dec		@r1
ft1izm:	call	loadT;в буфер 2 записать текст с соотв load(parT)
			;call	ind
		jmp		viout;out6;??????????????/

		;увеличить счетчик задержки клавиатуры
outF:		mov		r0,#chkl
		mov		@r0,#27h
		inc		r0
		mov		@r0,#10h
		jmp		out6;out7

noviR1:	jmp		noviR
outvich:	mov		r0,#vichR
		mov		@r0,#0
		clr		bitvich
		clr		bitvi11
		clr		bitmenu
		setb		bitizm
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp		labelE;out6	

nofizm:	jnb		bitvich,noviR1
		mov		p3,#0dfh
		jnb		p3.6,outvich;отжатие кнопки вычR
		mov		r0,#vichR
		cjne	@r0,#11h,no11v6
		mov		p3,#0fbh;->
		jb		p3.6,rviout;outF
		mov		@r0,#12h		;11= вычислить
vvrr6:	mov		dptr,#teIZMK	;	изм конст;teVICH
		call		lotext
		jmp		viout	;outF
	
no11v6:	cjne	@r0,#12h,no12v6
		mov		p3,#0fbh;->
		jb		p3.6,rviout;outF
		mov		@r0,#11h;13h
		mov		dptr,#teVICH;teOUT
		call		lotext
rviout:	jmp		viout;outF
		
no12v6:	cjne	@r0,#13h,no13v6
		mov		p3,#0fbh;->
		jb		p3.6,rviout;outF
		mov		@r0,#11h
		mov		dptr,#teVICH
		call		lotext
		jmp		viout;outF

;кн -> A= 0000		???
;кн -> B= +00000
no13v6:	mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,chanZ
		mov		a,movrig
		cjne	a,#7,kon_B	
		mov		r0,#marker	;A= 0000
		cjne	@r0,#7,mark0_8	;курсор справа ?
rikn:		mov		a,movleft
		mov		@r0,a		; уст курсор в кр левую поз+1
;			29.12.06
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
		jmp		viout;outF

kon_B:	mov		r0,#marker	;B= +00000
		cjne	@r0,#8,mark0_8		;курсор справа ?
		jmp		rikn
mark0_8:
;				29.12.06
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа ->B=+00000
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
		mov		r0,#marker
		inc		@r0		;	сдвинуть курсор вправо на 1
		clr		bitmig
		cjne	@r0,#9,outma
		dec		r0;ppp
outma:	jmp		viout;outF

chanZ:	mov		p3,#0feh
		mov		a,p3
		jb		acc.6,chanma
			;изм знак в старшем разряде на противоположн
		mov		a,bufind+3
		cjne		a,#2bh,noplus
		mov		bufind+3,#2dh		;+->-	
		jmp		viout;outF
noplus:
		mov		bufind+3,#2bh		;-/+-
		jmp		viout;outF
chanma:	mov		p3,#0fdh
		mov		a,p3
		jb		acc.6,outFl;labelL1
		;clr		bitmig
labelL1:	call		vvchibl;f	;увеличить цифру 

outFl:	mov		r1,#chkl
		mov		@r1,#01
		inc		r1
		mov		@r1,#0f4h		;1000
		jmp		out6
		
;;;;;;;;;кнопка -> в режиме кнопки меню

rlabelL:	jmp		labelL

rfindmem:	jmp		findmem

noviR:	jnb		bitmenu,rfindmem;17.01.07
;;;;;;;;;;;;;
		mov		r0,#vichR
		mov		a,#15h
		clr		c
		subb		a,@r0
		jc		ri21_23

		mov		p3,#0fbh; реж кн меню ->
		jb		p3.6,ri6
		mov		r0,#vichR
		cjne	@r0,#15h,norime
		mov		@r0,#11h
norime1:	call		lomenu
ri6:		jmp		viout;out6
norime:	inc		@r0
		jmp		norime1
	
ri21_23:	mov		a,#23h		;->
		clr		c
		subb		a,@r0
		jc		ri_31
		mov		p3,#0fbh
		jb		p3.6,ri6
		cjne		@r0,#23h,no23ri
		mov		@r0,#21h
		call		lomenu
		jmp		viout;out6
no23ri:	inc		@r0
		jmp		norime1
ri_31:	cjne		@r0,#31h,no31ri;->19.2->57.6->19.2

;;
		mov		p3,#0fbh
		jb		p3.6,ri6
;;
		jnb		bitv19,gosk19
		mov		dptr,#teS57_6;57,6
		call		lotext
		anl		bufind+11,#03h
		orl		bufind+11,#80h
		clr		bitv19
	mov	R0,#0
		sjmp		viout2			;??begin	;??
gosk19:	mov		dptr,#teS19_2
		call		lotext
		anl		bufind+11,#03h
		orl		bufind+11,#80h
		setb	bitv19
	mov	R0,#0
;		jmp		viout

viout2:
;	mov		dph,#50h
;	mov		dpl,#0C2h
;	clr		a
;	movc	@a+dptr,0	;R0
	setb	speed_rs

		jmp		viout	;begin	;??



;labelS2:	jmp		out6

no31ri:	mov		a,#52h;42h		;->
		clr		c
		subb		a,@r0
		jc		ri6
		mov		p3,#0fbh			;41,42
		jnb		p3.6,rlabelN	;кнопка ->(пароль 000)
		mov		p3,#0fdh
		jb		p3.6,ri6
		jmp		labelL1					;кнопка 0..9  (пароль 000)
rlabelN:	jmp		labelN
moutF:	jmp		viout;outF
;;;;;;;;;;;;;;;;;;;;;;;;;
rnnmemb:	jmp		nnmemb

nbimenu:
findmem:	jnb		bitmem,rnnmemb
		mov		r1,#level							;-> кн ПАМЯТЬ (ОЧИСТКА ->ЗАПИСЬ-> ПРОСМОТР)
		cjne		@r1,#11h,nomem11
					
		mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,moutF
		mov		@r1,#12h
		mov		dptr,#teWR	;			ЗАПИСЬ
		call		lotext
		jmp		viout;outF

nomem11:   cjne		@r1,#12h,nomem12
		mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,moutF
		mov		@r1,#13h
		mov		dptr,#teLIST		;ПРОСМОТР
		call		lotext
		jmp		viout;outF
nomem12:	cjne		@r1,#13h,nomem13
		mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,moutF
		mov		@r1,#14h
		mov		dptr,#teSTAT			;СТАТИСТИКА
		call		lotext
		jmp		viout;outF
			
nomem13:	cjne		@r1,#14h,labelL
		mov		p3,#0fbh
		mov		a,p3
		jb		acc.6,moutF
		mov		@r1,#11h
		mov		dptr,#teCLE			;ОЧИСТКА
		call		lotext
		jmp		viout;outF
labelL:	
		;;;;;
		mov			p3,#0dfh
		jnb			p3.6,moutF;в реж очистка полная не отрабатывать ВЫЧ R
		
		;ПОЛНАЯ->БЛОК 00(level 21->22)	???
		mov		r0,#level
		cjne		@r0,#21h,nobl21
		mov		@r0,#22h		;->БЛОК 
		mov		dptr,#teBL
me21_22:	call		lotext
			
		call		z_05s;задержка чтобы не проскакивала пргр на следующий уровень
		jmp		viout;outF

nobl21:	cjne		@r0,#22h,nobl22
		mov		dptr,#teFULL
		mov		@r0,#21h		;->ПОЛНАЯ

		jmp		me21_22

;labl21:	   cjne	@r0,#21h,nolev1
;			mov		p3,#0fbh
;			mov		a,p3
;			jb		acc.6,loutF
;			cjne	@r0,#21h,labl22
;			mov		@r0,#22h
			;БЛОК
;			call	lotext
;			jmp		outF
;labl22:		mov		@r0,#21h
			;ПОЛНАЯ
;			call	lotext
;			jmp		outF
		 
nobl22:	cjne	@r0,#23h,go31l
rigblo:	mov		p3,#0fbh
		jb		p3.6,llev2

labL2:	  ;  уст курсор в правую позицию 
				;	кнопка			->
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
		clr		bitmig
;;;;;;;;;;;;;;;;
		mov		r0,#marker	;курсор справа 	?
		mov		a,movrig
		clr		c
		subb		a,@r0
		jz		equ1l
		mov		a,movrig;уст в правую позицию
		mov		@r0,a
		jmp		viout;outF					 
equ1l:	mov		a,movleft;уст в левую позицию
		mov		@r0,a	
loutF:	jmp		viout;outF
		

go31l:	cjne	@r0,#31h,go41l
		jmp		rigblo
go41l:	cjne	@r0,#41h,norig2
		jmp		rigblo

llev2:	mov		p3,#0fdh
		jb		p3.6,loutF
		jmp		labelL1

;->
norig2:	clr		c		;32,33,34,42
		mov		a,#31h
		subb		a,@r0
		jnc		loutF
rigblok:	mov		p3,#0fbh  ;32,33,34,42
		jb		p3.6,lev2go
labelN:	cjne		@r0,#43h,labN_2
		jmp		loutF
labN_2:	cjne		@r0,#44h,labN_1	
		jmp		loutF				
			;				29.12.06
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
labN_1:	mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
;;;;;;;;;;;;;;;;;;;
		mov		r0,#marker	;курсор справа 	?
		mov		a,movrig
		clr		c
		subb		a,@r0
		jnz		noequ1
		mov		a,movleft;уст в крайнюю левую позицию
		mov		@r0,a
		jmp		viout;outF
noequ1:	;29.12.06
;;;;;;;;;;;;;;;;;;
			;восстан знакоместо при мигании
			  ;т к в соотв яч буфера индикации пишется 20h(пробел)
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		;mov		@r1,savba
		inc		r1
		mov		savba,@r1
;;;;;;;;;;;;;;;	
		call		marri;уст сдвиг в правую	позицию
		jmp		viout;outF
lev2go:	mov		p3,#0fdh
		jnb		p3.6,rlabelL1
		jmp		viout;outF

rlabelL1:	jmp		labelL1

nnmemb:

norim6:	   ;kn menu
out6:		pop		dph
		pop		dpl
		pop		rr7	
		pop		rr6
		pop		rr5
		pop		rr4
		pop		rr3
		pop		rr2
		pop		rr1			        
		pop		rr0
		pop		psw
		pop		acc
	;clr		bitmig
	;mov		EIE2,#30H
	;mov		a,P3IF
	;anl		a,#0bfh
	;mov		P3IF,a
	;mov		P3,#0c0h
	;;;;;;
kkout6:
		mov		P3IF,#00 ;обязательно сбросить опять приходит на обработку прерывания
		mov		P3,#0c0h
		clr		bitmig
		mov		a,P6	   	;p6.4=0
		anl		a,#0efh
		mov		P6,a
		nop
		nop
		mov		a,P6			;p6.4=1	
		orl		a,#10h
		mov		P6,a	
			;;;;;;;;;
		mov		a,PCA0CPM0;	
		orl		a,#46h;anl		a,#0fbh
		mov		PCA0CPM0,a

		mov		TH2,#0d0h
		mov		TL2,#00

		setb		T2CON.2
		setb		ET2;IE.5
			;;;;;;;;		    
		reti


knKMP:	jmp		out7
rout7:	jmp		out7	
rlabelH:	jmp		labelH
rknNUL:	jmp		knNUL
rknleft:	jmp		knleft

no0chk:	mov		P3IF,#00;		обязательно сбросить опять приходит на обработку прерывания
		mov		P3,#0c0h
		reti

rknMEM:	jmp		knMEM

keyb2:	;IE7
;;;;;
 		;	mov			a,chkl		;low
		;	jb			acc.7,no0chk;
			;jnz			no0chk
			;mov			a,chkl				;high
			;jnz			no0chk
;;;;
		mov		EIE2,#00H
		mov		P3IF,#00

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
		push	dpl
		push	dph
			;clr		bitmig
		  ;;;;;;;;;;;;;;
		call	z_01s	;0,1s
			  ;восстан знакоместо при мигании
			  ;т к в соотв яч буфера индикации пишется 20h(пробел)
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		mov		@r1,savba
				;;;;;;;;;;;

        	mov		a,p3
		jb		acc.7,rout7
		mov		a,p3
		mov		a,#0ffh		; p3.(5-0)<-3f
		mov		p3,a
		mov		a,p3
		jnb		acc.7,rout7		;error
		jnb		bitizm,rlabelH
		mov		p3,#0feh		;реж IZM
		mov		a,p3
		jnb		acc.7,rknNUL
		mov		p3,#0fdh
		mov		a,p3
		jnb		acc.7,knKMP
		mov		p3,#0fbh
		mov		a,p3
		jnb		acc.7,rknleft
		mov		p3,#0f7h
		nop
		nop
		nop
		nop
		mov		a,p3
		jnb		acc.7,knAVP
		mov		p3,#0efh
		mov		a,p3
		jnb		acc.7,rknMEM
		mov		p3,#0dfh
		mov		a,p3	
		jnb		acc.7,knmenu
an_t7:		   ;;;;;;;;;;;;
		
;	clr		c
;	mov		r1,#parN
;
;			mov		r0,#diap
;			mov		a,#6    	
;			subb	a,@r0
;			jnc		goto7		;	  ;10-2..10-8
			  
;			mov		@r1,#2		;10-9..10-11		
			
			;;;;;;;;;;;;
goto7:	mov		r1,#parT
		mov		r0,#chkl
		cjne		@r1,#1,not1_7
		mov		@r0,#00
		inc		r0
		mov		@r0,#1;2
		jmp		out7
			

not1_7:	cjne		@r1,#2,not2_7
		mov		@r0,#00
		inc		r0
		mov		@r0,#2;10;20
		jmp		out7
not2_7:	mov		@r0,#00
		inc		r0
		mov		@r0,#10;20;0
merr:		jmp		out7


knmenu:

;		mov	cnt_out,#33		;+
;		mov	p_out,#0DAh


		jb		bitvi11,merr
		jb		biteizm,menuoff
				;;;;;
		jb		bitklb,klboff
		clr		bitizm		;off IZM
		setb		bitmenu
		clr		bitoll
		mov		dptr,#teTESI 	;в буф2 записать ТЕСТ-ИЗМЕР
		call		lotext
		anl		bufind+11,#03h	;погасить запятые
		call		ind
		mov		r0,#vichR
		mov		@r0,#11h
		jmp		onmem11
menuoff:
		mov		r0,#vichR
		mov		@r0,#00
		clr		biteizm
		call		loadus
		jmp		out7

klboff:	clr		bitklb
		call		loadUS
		mov		r0,#vichR
		mov		@r0,#00
		jmp		out7

rendkalib:	jmp		endkalib

knAVP:	jb		bitklb,rendkalib	
		jb		bitavp,meavp
		setb		bitavp
		jmp		an_t7;onmem11
meavp:	clr		bitavp
		jmp		an_t7;onmem11

knleft:	jb		bitklb,lefkl
				;;;;;;;;
		mov		r1,#diap
		inc		@r1		;перекл диапазон 1 поз в сбр массив
		cjne	@r1,#0ah,nodi6
		dec		@r1
lefkl:	jmp		an_t7

nodi6:		   ;	cjne	@r1,#0,an_t7
		call		clmassix
		mov		r0,#summa
		call		clear4	
		mov		r0,#rez_A0
		call		clear4
		clr		bitnul		;гасить светодиод НУЛЬ	
		call		loadUS
		jmp		an_t7

knNUL:	jb		bitnul,ybnul
		setb		bitnul
		mov		r0,#rez_A3	;A3
		call		resar2
		mov		r0,#rez_A0	
		call		saver2;A0<-A3
		jmp		goto7;an_t7

ybnul:	clr		bitnul
		mov		DPTR,#ch0 
		CALL  	ldc_long		 ; r2..r5 <-- 0
		mov		r0,#rez_A0	;A0=0
		call		saver2
		jmp		goto7;an_t7

labelH:	jnb		bitt2,nolah
		mov		p3,#0fbh   ;вход в режим изм Т
		anl		bufind+10,#8fh
		mov		r1,#load;parT
		jb		p3.7,rhnot1
		cjne	@r1,#0,inct;
		jmp		out7;hyest6
inct:		dec		@r1			;Tизм+1
			
		call		loadT	;в буфер2 записать текст  в соотв с	Tизм
hnot2:		;	call	ind
		jmp		onmem11;out7
rhnot1:	jmp		hnot1
 ;rnoviR:		jmp		noviR
rlabelK:	jmp		labelK
rlabelI:	jmp		labelI		
 ;;;;;;;;;;;;;;;;;;;

nolah:	jnb		bitvich,rlabelK	
		;увеличить счетчик задержки клавиатуры
		;;		mov		r0,#chkl
		;;		mov		@r0,#27h
		;;		inc		r0
		;;		mov		@r0,#10h

		mov		r0,#vichR
		cjne	@r0,#11h,rhnor11;rlabelI;;
		mov		p3,#0fbh   ;<-
		jb		p3.7,noh37;routF
    		cjne	@r0,#11h,hr12
		mov		@r0,#12h;11h;= вычислить
		mov		dptr,#teIZMK	;	изм конст;teVICH
hvi1113:	call		lotext	;в буфер 2 записать текст в соотв с состоянием
		jmp		onmem11;goto7

hr12:		cjne	@r0,#12h,hnor12			;???
lovich:	mov		@r0,#11h
		mov		dptr,#teVICH
		jmp		hvi1113		
hnor12:	cjne	@r0,#13h,rhnor11
loizmk:	mov		@r0,#12h
		mov		dptr,#teIZMK	;	изм конст
		    		   
		jmp		hvi1113

rhnor11:	jmp		hnor11

rvvizko:	jmp		vvizko
vioutF:	clr		bitvich
		clr		bitvi11
		jmp		viout;outF
toutF:	jmp		viout;outF

noh37:	mov		p3,#0f7h
		jb		p3.7,toutF;vioutF
		cjne	@r0,#11h,rvvizko
		setb		bitvi11	   ;нажат ввод ВЫЧИСЛИТЬ
		setb		bitizm
		anl		bufind+11,#07h
		orl		bufind+11,#10h;точка после 1 знакоместа
		jmp		goto7;


rnoh37:	jmp		noh37
norr11:	cjne	@r0,#12h,norr12
		mov		p3,#0fbh   ;<-
		jb		p3.7,rnoh37;routF
		mov		@r0,#11;12->11
		jmp		lovich

labelI2:	jmp		labelI
norr12:	cjne	@r0,#13h,labelI2
		mov		p3,#0fbh   ;<-
		jb		p3.7,rnoh37
		mov		@r0,#12h
		jmp		loizmk
			;;;;
clrvich:	clr		bitvich
		setb		bitizm
		mov		r0,marker
		mov		@r0,#0ffh
		jmp		goto7;	routF

;rnoh37:	jmp		noh37
 ;ввод изм конст
hnor11:	cjne	@r0,#12h,norr12;clrvich
		mov		p3,#0fbh   
		jb		p3.7,rnoh37;lovich;;изм конст <-  выч
		mov		@r0,#11h
		jmp		lovich

vvizko:	mov		r0,#vichR
		mov		a,@r0
		;	cjne	@r0,#12h,clrvich
		cjne	a,#12h,clrvich
		mov		@r0,#21h		;изм конст->U=+0000	(vvod)
		mov		r0,#marker
		mov		@r0,#4;9
		mov		movleft,#4
		mov		movrig,#7
		mov		dptr,#teAequ0
		call		lotext
		call		outA
		anl		bufind+11,#0fh
	;	mov		a,bufind+11
	;	anl		a,#0f0h
	;	mov		bufind+11,a
		orl		bufind+11,#40h;бит точки после 7 знакоместа(a=000.0 v)
		jmp		goto7;routF
;hnor13:	jmp		hnor12		
izchi:	cjne	@r0,#21h,tlabelI
;<- при вводе цифр А				
		;mov		p3,#0fbh   
		;jnb		p3.7,li21
		;clr		bitmig
		mov		r0,#marker
		dec		@r0
		cjne	@r0,#2,li21
		inc		@r0;marker=3 +/-
li21:		clr		bitmig
		jmp		goto7;outF

tlabelI:	jmp		labelI

;			load    0 1 2 3 4 5		
sootv:	db		6,5,4,3,2,1;parT
;
nnnott:	jmp		viout
;нажата кн ввод при наборе Т
hnot1:	mov		p3,#0f7h
		jb		p3.7,nnnott;routF;out7
		cjne	@r1,#5,nohnot1	;r1=load
		mov		r1,#bufind+10;в буфере 1 зажечь 10s
		mov		a,@r1
		anl		a,#8fh
		orl		a,#40h;.6
		mov		@r1,a
		jmp		loadb
			
				
loadB:	mov		r0,#parT
		mov		dptr,#sootv
		mov		r1,#load		
		mov		a,@r1;load
		movc	a,@a+dptr
		mov		@r0,a
		call		loab12	;установить B1,B2 в соотв с Tизм
			 ;r4=b1 r5=b2
		call		iniacp;инициализация АЦП
		call		loadUS
		call		clmassix	
		setb		bitizm
		clr		bitt2
		anl		bufind+10,#8fh
		clr		c
 		mov		r0,#parT
		mov		r1,#parN
		mov		a,#2
		subb		a,@r0
		jnc		loadB2
		mov		@r1,#1;N=1	   ;T>=2
bout7:	jmp		goto7;out7

loadB2:	cjne	@r1,#2,bout7
		mov		@r1,#2;N=2
		jmp		goto7;out7
nohnot2:	;в буфере 1 зажечь <=0,1s
		mov		r1,#bufind+10
		mov		a,@r1
		orl		a,#10h;.4
		mov		@r1,a
		call		ind
		jmp		loadB
nohnot1:	cjne	@r1,#4,nohnot2	;ввод кнопка Т  
		mov		r1,#bufind+10;в буфере 1 зажечь 1s
		mov		a,@r1
		orl		a,#20h;.5
		mov		@r1,a
		jmp		loadB

;кнопка ПАМЯТЬ			???
knMEM:	jb		bitklb,bout7	;в реж калибровки не нажимать память
		clr		bitizm		;off IZM
		mov		dptr,#teLIST	;CLE
		call		lotext		;в буф2 записать ОЧИСТКА
		setb		bitmem		;нажата кнопка ПАМЯТЬ
		anl		bufind+11,#0efh	;убрать точку с 1го знакоместа
		orl		bufind+11,#01	;зажечь светодиод память
		call		ind
		mov		r0,#level
		mov		@r0,#13h;11h

onmem11:	mov		r0,#chkl
		mov		@r0,#03
		inc		r0
		mov		@r0,#0e8h	;1000
		jmp		out7		;goto7

rnomemk:	jmp		nomemk		;
outkmem:	mov		r0,#level
		mov		@r0,#0
		mov		r0,#vichR
		mov		@r0,#0
		clr		bitmem
		clr		bitvich
		clr		bitvi11
		clr		bitmenu
		setb		bitizm
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp		vvod2_10
				
offmenum:	jmp	goto7	

labelK:
		jnb	bitmem,rnomemk		;кн память (ввод и <-)
			;;;;;;;
		mov	p3,#0dfh;(код кнопки меню)
		jnb	p3.7,offmenum
			;;;;;;;
		mov	p3,#0efh
		jnb	p3.7,outkmem		;отжатие кн память на любом уровне обработки памяти
		mov	r0,#level
		cjne	@r0,#11h,klev1;nome11
lefmem11:	mov	p3,#0fbh
		mov	a,p3
		jb	acc.7,rkvvod0
		cjne	@r0,#11h,locle		;<-memory
		mov	@r0,#14h
lolist:	mov	dptr,#teSTAT
		call	lotext		 ;СТАТИСТИКА
		jmp	onmem11;goto7;
rkvvod0:	jmp	kvvod0


locle:	cjne		@r0,#12h,lowr		;<-memory
		mov		@r0,#11h		   ;ОЧИСТКА
loadcle:	mov		dptr,#teCLE
		call		lotext
		jmp		onmem11;goto7

lowr:		cjne	@r0,#13h,lostat
		mov		@r0,#12h
lowr1:	mov		dptr,#teWR		  ;ЗАПИСЬ
		call		lotext
		jmp		onmem11;goto7

lostat:	mov		@r0,#13h
 		mov		dptr,#teLIST		  ;ПРОСМОТР
		call		lotext
		jmp		onmem11;goto7
me_14:	cjne	@r0,#14h,klev22
 		mov		@r0,#13h
		mov		dptr,#teLIST		  ;;ПРОСМОТР
		call		lotext
		jmp		goto7
 klev1:	cjne	@r0,#12h,klev2
 		jmp		lefmem11
klev2:	cjne	@r0,#13h,klev3;11-14   klev22	  ;11-13 нет
 		jmp		lefmem11
klev3:	cjne	@r0,#14h,klev22;
 		jmp		lefmem11
;<- vvod на более низких уровнях
klev22:	cjne	@r0,#21h,klev21
lev220:	mov		p3,#0fbh
		jb		p3.7,kgo23
		cjne	@r0,#21h,kfullr
		mov		@r0,#22h
		mov		dptr,#teBL
		call		lotext
		jmp		goto7;outF
kfullr:	jmp		kfull				
klev21:	cjne	@r0,#22h,klev23
		jmp		lev220

rlabL2:	jmp		labL2
rlabM:	jmp		labM
ques:		jmp		out7
ddoutfr:	jmp		ddoutf

klev23:	cjne	@r0,#23h,rlabM
		mov	p3,#0fbh
		jnb		p3.7,ques;errr labL2
		mov	p3,#0f7h
		jb		p3.7,ddoutfr
				;	считать с индикатора  
		clr			c
		mov		a,bufind+7	
		subb		a,#30h
		cjne		a,#0,chaibl
		mov		a,#1			;номера блоков 1..4
chaibl:	mov		nblok,a
			   	 ;очистить блок памяти с набранным номером
				;150h..1000h( 150h+nblok*320h)
		call		adrblok		;dptr-
		mov			r1,#work		;обьем блока
		mov			@r1,#03
		inc			r1
		mov			@r1,#20h			;320h
	mov	r1,#volume	;??обьем блока for write
	mov	@r1,#00
	inc	r1
	mov	@r1,#0c7h		;320h/4
goonoff:
		clr			a
		movx		@dptr,a
		inc			dptr
		mov			r1,#work+1
		call		chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,goonoff
		clr	bitmem	;сбр признак памяти 
		setb	bitizm
		;после очистки блока сохраняем в saven_bl 
		;адрес второго с конца измерения поэтому добавляем 8
		call		adrblok;dptr-начало блока
		;	mov			a,dpl
		;	add			a,#8
		;	mov			dpl,a
		;	mov			a,dph
		;	addc		a,#0
		;	mov			dph,a
		call		save_hl;подготовка записи в начало блока
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp			vvod2_10
		jmp	goto7

rddoutf:	jmp		ddoutf
rgo23no:	jmp		go23no

;vvod 	БЛОК->БЛОК 00		
kgo23:	mov	p3,#0f7h
		jb		p3.7,rddoutf
		cjne	@r0,#21h,rgo23no
		;очистить память 150..dd0h
			;1й блок
		mov			dptr,#150h
		mov			r1,#work		;обьем блока
		mov			@r1,#03
		inc			r1
		mov			@r1,#20h			;320h
gooff1:
		clr			a
		movx		@dptr,a
		inc			dptr
		mov			r1,#work+1
		call		chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,gooff1
		mov			dptr,#150h;начало 1 го блока
		;после очистки блока сохраняем в saven_bl 
		;адрес второго с конца измерения поэтому добавляем 8
;				call		save_hl;подготовка записи в начало блока
;2й блок
		mov			dptr,#470h
		mov			r1,#work		;обьем блока
		mov			@r1,#03
		inc			r1
		mov			@r1,#20h			;320h
gooff2:
		clr			a
		movx		@dptr,a
		inc			dptr
		mov			r1,#work+1
		call		chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,gooff2
		mov			dptr,#470h;начало 2 го блока
;			call		save_hl;подготовка записи в начало блока
;3й блок
		mov			dptr,#790h
		mov			r1,#work		;обьем блока
		mov			@r1,#03
		inc			r1
		mov			@r1,#20h			;320h

gooff3:
		clr			a
		movx		@dptr,a
		inc			dptr	
		mov			r1,#work+1
		call		chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,gooff3
		mov			dptr,#790h;начало 3 го блока
		;после очистки блока сохраняем в saven_bl 
		;адрес второго с конца измерения поэтому добавляем 8
		;	call		save_hl;подготовка записи в начало блока
;4й блок
		mov			dptr,#0ab0h
		mov			r1,#work		;обьем блока
		mov			@r1,#03h
		inc			r1
		mov			@r1,#20h			;320h
gooff4:
		clr			a
		movx		@dptr,a
		inc			dptr
		mov			r1,#work+1
		call		chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,gooff4
		mov			dptr,#0ab0h;начало 4 го блока
		;после очистки блока сохраняем в saven_bl 
		;адрес второго с конца измерения поэтому добавляем 8
;			call		save_hl;подготовка записи в начало блока
			;;;;26.02.07
		mov		a,nblok
		cjne	a,#1,cl_hl1
		mov		dptr,#150h
		mov		r1,#saven_bl
cl_hl:	mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		;;;;;;;;
		clr		bitmem
		setb	bitizm
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp			vvod2_10;jmp		goto7

cl_hl1:	cjne		a,#2,cl_hl2
		mov			dptr,#470h
		mov		r1,#saven_bl2
		jmp			cl_hl

cl_hl2:	cjne		a,#3,cl_hl3
		mov			dptr,#790h
		mov		r1,#saven_bl3
		jmp			cl_hl

cl_hl3:	mov			dptr,#0ab0h
		mov		r1,#saven_bl4
		jmp			cl_hl

go23no:	mov		@r0,#23h
		mov			movrig,#8
		mov		movleft,#7
		jmp		loblok;БЛОК 00
kfull:	mov		@r0,#21h
		jmp		gofull
			
					
nomemk:	jmp		labelS			;нажат ввод меню
			
nome11:	mov		p3,#0fbh
		mov		a,p3
		jb		acc.7,kvvod0
		cjne		@r0,#12h,mem12no	
		mov		@r0,#11h		;ОЧИСТКА
		jmp		 loadcle

mem12no:	;cjne		@r0,#13h,lowr		
		mov		@r0,#12h		   ;
		jmp		lowr1			  ;ЗАПИСЬ
kvvod0:	mov		p3,#0f7h			;knopka vvod
		jb		p3.7,ddoutf
		mov		r0,#level
		cjne		@r0,#11h,mvv11
		mov		@r0,#21h		;ПОЛНАЯ
gofull:	mov		dptr,#teFULL
		call		lotext
		jmp		onmem11;mlabL2	;<-????????/

ddoutf:		;<- БЛОК 00(ОЧИСТКА)
;необходимо не портить цифру в следуюем сслева знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		dec		r1	;	inc		r1
		mov		savba,@r1
		clr		bitmig
;;;;;;;;;;;;;;;;
		mov		r0,#marker	;курсор слева 	?
		mov		a,movleft
		clr		c
		subb		a,@r0
		jnz		left21
		mov		a,movrig;уст в правую позицию
		mov		@r0,a

		jmp		goto7						 
left21:	mov		a,movleft;уст в левую позицию
		mov		@r0,a	
		jmp		goto7


mvv11:	cjne		@r0,#12h,mvv12
		mov		@r0,#31h
loblok:	mov		dptr,#teBL0;БЛОК 0
		call		lotext
		mov		a,nblok
		add		a,#30h
		mov		bufind+7,a
		mov		r0,#marker
		mov		@r0,#7
				;mov		movrig,#9
				;mov		movleft,#6
		jmp		onmem11
mvv12:	cjne		@r0,#14h,bl_li
		mov		@r0,#61h
		mov		dptr,#teMIN;
		call	lotext
		call	vichmin
		call	z_1s
		jmp		onmem11

bl_li:	mov		@r0,#41h		; БЛОК 00(ЗАПИСЬ И ПРОСМОТР)
		jmp		loblok



mlabL2:		;jmp		labL2
					;  уст курсор в правую позицию 
				;				29.12.06
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
;;;;;;;;;;;;;;;;
		mov		r0,#marker	;курсор справа 	?
		mov		a,movrig
		clr		c
		subb	a,@r0
		jz	   equ2l
		mov		a,movrig;уст в правую позицию
		mov		@r0,a
;			lool
		jmp		goto7						 
equ2l:	mov		a,movleft;уст в левую позицию
		mov		@r0,a	
		jmp		goto7
		
rnom31:	jmp			nom31
labM:		cjne	@r0,#31h,rnom31
		mov		p3,#0fbh
		jnb		p3.7,mlabL2
		mov		p3,#0f7h
		jb		p3.7,ddoutf
			   
		mov		@r0,#32h			;ИНТ 0000
			   	;	считать с индикатора  
blokvv:	clr		c
		mov		a,bufind+7	
		subb		a,#30h
		cjne		a,#0,blokvvc
		mov		a,#1			;номера блоков 1..4

blokvvc:	mov		nblok,a
		mov		dptr,#teINT;ИНТ 0000c
		call		lotext
		mov		r0,#interva+1
		mov		r1,#abin+3
		mov		a,@r0
		mov		@r1,a
		dec			r0
		dec			r1
		mov		a,@r0
		mov		@r1,a
		dec		r1
		clr		a
		mov		@r1,a
		dec		r1
		mov		@r1,a
								 	
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call	bindec
				
		mov		r0,#adec+9;разместить в буфер индикации
		mov		r1,#bufind+8
		mov		r7,#4
bloin:	mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz	r7,bloin
		mov		r0,#marker
		mov		@r0,#5
		mov		movrig,#8
		mov		movleft,#5
		mov		r0,#parT
		cjne		@r0,#6,innot6
		anl		bufind+11,#0f0h;after 5- 0.000c
		orl		bufind+11,#04h
			
		jmp		goto7
innot6:	cjne		@r0,#3,innot3
		anl		bufind+11,#0f0h;after 7- 000.0c
		orl		bufind+11,#20h
				;call		ind
		jmp		out7;goto7
innot3:	clr		c
		mov		a,#3
		subb		a,@r0
		jnc		innot1_2
		anl		bufind+11,#0f0h;after 6- 00.00c
		orl		bufind+11,#40h
		jmp		goto7

innot1_2:
		anl		bufind+11,#0fh;0h;0000c
		clr		bitmig
				;call		ind		нет необходимости пришет пробел		
rgoto7:	jmp	   goto7;outF

nom31:	cjne		@r0,#32h,nom32
		mov		p3,#0fbh
		jb		p3.7,vvinte		;ввод интервал;no31n
				
lefcur:		;;кн <- 32 нач блок 000
;необходимо не портить цифру в следуюем сслева знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		clr		bitmig
		mov		r0,#marker;нажата кн <- при вводе цифр нач блок 000
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		dec		r1;;;;;;;;;;;
		mov		savba,@r1
					
		mov		r0,#marker	;курсор слева?
		mov		a,movleft
		clr		c
		subb	a,@r0
		jnz	   noequ2
		mov		a,movrig
		mov		@r0,a;уст в крайнюю правую позицию
		jmp		goto7
noequ2:	call	marle;сдвинуть курсор в  лево на 1позицию	
		jmp	   goto7	
								  

;;;;;;;;;;;;;;;;;;
vvinte:		;ввод интервал				
no31n:	mov		p3,#0f7h
		jb		p3.7,rgoto7
		mov		@r0,#33h
				;считать с индикатора введенный интервал
		mov		r7,#10
		mov		r0,#adec
		call	clearN
		call	upak4			
		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		mov		r1,#abin
		mov		r0,#interva+1
		mov		a,@r1
		mov		@r0,a
		dec		r0
		inc		r1
		mov		a,@r1
		mov		@r0,a
				
		mov		r0,#volume			;объем блока
		mov		@r0,#0
		inc		r0
		mov		@r0,#0c7h
		call		adrblok;dptr
		call		save_hl;1я ячейка блока
		mov		r0,#marker
		mov		@r0,#0ffh
		setb		bitizm
		clr		bitmem
vvod2_10:	mov		r0,#parT
		cjne		@r0,#5,no10msv
		mov			dptr,#te10ms
t2msme:	call		lotext
					
		call		ind
no2msv: 	jmp	   goto7;
no10msv:	cjne		@r0,#6,no2msv	
		mov			dptr,#te2ms
		jmp			t2msme



nom32:	cjne		@r0,#33h,nom33
		mov		p3,#0fbh
		jnb		p3.7,lefcur
		mov		p3,#0f7h
		jb		p3.7,no2msv;rgoto7
		;запомнить номер ячейки конца блока
		mov	@r0,#34h
INTn:		mov		r7,#10
		mov		r0,#adec
		call	clearN
		call	upak3			
		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		call	loadr2			;r2..r5
		call	altof			;r2..r5->int
dgoto7:	jmp		goto7

rlefcur:	jmp		lefcur

nom33:	cjne		@r0,#34h,labelP
		mov		p3,#0fbh
		jnb		p3.7,rlefcur
		mov		p3,#0f7h
		jb		p3.7,dgoto7
		mov		@r0,#35h
		mov		r0,#marker
		mov		@r0,#0ffh
		;T1<-число на индикаторе
		;vvod КОН БЛ 000
		mov		r0,#chbuf		;счетчик периода загрузки в буфер и интерфейс
		mov		@r0,#30h  
		clr		bitmem
		setb		bitizm;;;;	
		jmp	   goto7
vodm11_15:	jmp		vvodm11_15
me11_15de:	jmp		me11_15dec
moutkmem:	jmp		outkmem

nmem_menu:	jmp		out7			;нажата память в режиме меню
;обработка кнопки меню ввод
labelS:	jnb			bitmenu,labelP
		mov			p3,#0efh
		jnb			p3.7,nmem_menu
		mov			p3,#0dfh
		jnb			p3.7,moutkmem
		mov			r0,#vichR
		mov			a,#15h
		clr			c
		subb		a,@r0
		jc		rme21_23
			
		mov		p3,#0fbh
		jb 		p3.7,vodm11_15
		mov		r0,#vichR
		cjne		@r0,#11h,me11_15de;<-
		mov		@r0,#15h
		mov		dptr,#teKALIB
		call		lotext
		jmp		onmem11
menuon:	clr		bitmenu			;off menu
		setb		bitizm

		mov		r0,#vichR
		mov		@r0,#0
		jmp		onmem11

					;;;;;
	
rme21_23:	jmp		me21_23	
			
;режим просмотра
labelP:		cjne		@r0,#41h,govvlist
		mov		@r0,#42h
			;	считать с индикатора  
		clr		c
		mov		a,bufind+7	
		subb		a,#30h
		cjne		a,#0,chaipr
		mov		a,#1
chaipr:		mov		nblok,a
		mov		dptr,#teCH;ОТСЧЕТ 000
		call		lotext
		anl		bufind+11,#0efh;убрать точку с 1го знакоместа
		mov		r0,#marker
		mov		@r0,#7
		mov		movrig,#9
		mov		movleft,#7
		call		z_1s
		jmp	   goto7;outF
label43:	jmp		label7

rlist_43:	jmp			list_43					
mlabL2r:	jmp			mlabL2
govvlist:	cjne		@r0,#42h,rlist_43	;?button
		mov			p3,#0fbh
		jnb			p3.7,mlabL2r;кн <- ОТСЧЕТ 000
		mov			p3,#0f7h
		jb			p3.7,label43
		mov			@r0,#43h;vvod 
		mov			r0,#marker
		mov			@r0,#0ffh
		mov		r7,#10
		mov		r0,#adec
		call	clearN
		call	upak3			
		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		call	loadr2			;r2..r5
		mov		a,r5				;сохр номер элемента
		mov		nelem,a
		call	altof			;r2..r5->int
		mov		dptr,#ch_1;
		call	ldc_ltemp			;r8..r11
		call	flsub
		mov		dptr,#ch_4;
		call	ldc_ltemp			;r8..r11
		call	flmul				;(n(номер отсчета)-1)*4+адр нач блока
		call		ftol			;r2..r5->hex
		push		rr2
		push		rr3
		push		rr4
		push		rr5
		call		adrblok;dptr-
		pop			rr5
		pop			rr4
		pop			rr3
		pop			rr2
		mov			r1,#copy_hl+1;saven_bl+1;сохр адрес внешн озу введенного элемента
		mov			a,dpl
		add			a,r5
		mov			dpl,a
		mov			@r1,a		;low
		mov			a,dph
		addc		a,r4
		mov			dph,a
		dec			r1
		mov			@r1,a			;high
li42_43:
		call		reA3_X		;r2..r5/выдать рез из внешн пам на индикатор
		mov		dptr,#ch10
		call	ldc_ltemp
		call	zdiv			;form4=invertif <0; divide
		call	maform		;setb/clr	znmat
		mov		r0,#abin
		call	saver2		;r2..r5-> @r0..@r0+3
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call	bindec
			
		mov		r0,#adec+9;разместить в буфер индикации
		mov		r1,#bufind+5
		mov		r7,#7
ch43:		mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz	r7,ch43
		mov		r0,#bufind+7
		mov		@r0,#2dh	  ;-2..-9
		mov		r0,#bufind
		mov		@r0,#2bh
		jnb		znmat,nozzmi43;bitznak,nozzmi
		mov		@r0,#2dh	;'-'

nozzmi43:	mov		a,nblok
		cjne	a,#1,nozzmi1		
		mov		r1,#sadiap;diap
		jmp		nozzbl
nozzmi1:	cjne	a,#2,nozzmi2		
		mov		r1,#sadiap2;diap
		jmp		nozzbl
nozzmi2:	cjne	a,#3,nozzmi3		
		mov		r1,#sadiap3;diap
		jmp		nozzbl

nozzmi3: mov		r1,#sadiap4;diap
nozzbl:	 mov		r0,#bufind+8
				mov		a,@r1
		cjne	a,#8,nodi8_43
		mov		@r0,#30h		 ;10-10
		dec		r0
		mov		@r0,#63h;31h
		inc		r0
		jmp		see_l43

nodi8_43:	cjne	a,#9,nodi9_43
		mov		@r0,#31h	   ;10-11
		dec		r0
		mov		@r0,#63h;31h
		inc		r0
		jmp		see_l43

nodi9_43:	add		a,#32h
		mov		@r0,a;
see_l43:	inc		r0
		mov		@r0,#"A";"E";
		;	inc		r0
		;	mov		@r0,#00h ;=feh в нач установе для поджига всех сегм
		;	inc		r0;		mov		bufind+11
		;	mov		@r0,#0d0h		;bufind+11.4 точка после первой цифры
		orl		bufind+11,#10h
out43:	call		ind
		call		z_1s
		jmp		out7					

		;;;;;;;;	
label7:	mov		r0,#chkl
		mov		@r0,#3
		inc		r0
		mov		@r0,#0e8h		;1000
		jmp		out7;
list_43:	cjne	@r0,#43h,noli_43
		mov		p3,#0fbh		;43h <-
		jb		p3.7,vvod43		;vvod
		clr		bitmem
		setb	bitizm
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp		goto7;6.03.07;label7;по кн <- выход из просмотра

vvod43:	mov		@r0,#44h
		mov		a,nelem;вывод порядкового номера в блоке 
		inc		a
		mov		abin+3,a
						
		mov		nelem,a
		clr		a
		mov		abin+2,a
		mov		abin+1,a
		mov		abin,a
					
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call	bindec
		mov		r0,#bufind;почистить индикатор
		mov		r7,#10
		mov		a,#20h
cle20:	mov		@r0,a
		inc		r0
		djnz	r7,cle20
			;;;;;;
		mov		dptr,#teCH;ОТСЧЕТ 000
		call		lotext
		anl		bufind+11,#0efh;убрать точку с 1го знакоместа
		mov		r0,#adec+9;разместить в буфер индикации
		mov		r1,#bufind+9
		mov		r7,#3
ch43_42:	mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz	r7,ch43_42
		call		ind
		call		z_1s
		jmp		out7
noli_43:	cjne		@r0,#44h,vvosta
		mov			@r0,#43h
		mov			r1,#copy_hl+1;saven_bl+1
		mov			a,@r1
		mov			dpl,a
		dec			r1
		mov			a,@r1;high
		mov			dph,a
		inc			dptr
		inc			dptr
		inc			dptr
		inc			dptr
		mov			a,dph
		mov			@r1,a
		inc			r1
		mov			a,dpl
		mov			@r1,a				;сохр адр внешн озу
		jmp			li42_43;вывод значения следующего в блоке

vvosta:	cjne		@r0,#61h,vvostad
		mov			@r0,#62h
		mov			dptr,#teMAX;
		call		lotext
		call		vichmax
		call		z_05s;z_1s
		jmp		goto7

vvostad:	cjne		@r0,#62h,rousta
		mov			@r0,#63h
		mov		dptr,#teMid;
		call	lotext
		call		vichmean
		call		z_05s
		jmp		goto7

rousta:	cjne		@r0,#63h,rousta1
		mov			@r0,#61h
		mov		dptr,#teMin;
		call	lotext
		call		vichmin
		call		z_05s
rousta1:	jmp		goto7

rLABELP:	jmp		LABELP
vvodm11_15:	mov		r0,#vichR;vvod
		mov		p3,#0f7h
		jb		p3.7,rLABELP;????
				
		cjne		@r0,#11h,tome21
		mov		@r0,#21h;vvod
		mov		dptr,#teTE11
		call		lotext
		anl		bufind+11,#03h ;погасить запятые
		jmp		onmem11

me11_15dec:	dec		@r0				;<-
lokame1:	call		lomenu
		jmp		onmem11

tome21:	cjne		@r0,#12h,tome13
		;вкл тест интерфейса
		jmp		testrs;??????????
		jmp		onmem11

tome13:	cjne		@r0,#13h,tome14
		mov		@r0,#31h
					
		mov		r2,#50h				;57.6->19.2
		mov		r3,#2ch
		call		re4byte			;28..2bh 3bait-parol,1 bait skor
		mov		a,r8
		cjne		a,#00,skor19
		mov		dptr,#teS57_6;57,6
		call		lotext
		orl		bufind+11,#80h
		clr		bitv19
		jmp		onmem11
skor19:	mov		dptr,#teS19_2
		call		lotext
		setb		bitv19
		orl		bufind+11,#80h
		jmp		onmem11
					

tome14:	cjne		@r0,#14h,tome15
		setb		bitizm
		mov		r0,#chavt
		mov		@r0,#0
		inc		r0
		mov		@r0,#0
outmenu:	clr		bitmenu
		jmp		out7

goparom:	mov		r0,#vichR		;режим меню 52
		mov		@r0,#52h			;пароль уже ввели
		jmp		goparol
tome15:	jnb		p1.0,goparom
		mov		nuerr,#36h
		call		error
		call		ind
		call		z_01s
		jmp		tome15;	onmem11

		jmp		goparom;jb		bitpar,goparom	
		mov		@r0,#51h;ПАРОЛЬ 000
		call		lomenu
		mov		r0,#marker
		mov		@r0,#7
		mov		movrig,#9
		mov		movleft,#7
		;setb		bitizm
		jmp		onmem11


me21_23:	mov		r0,#vichR		;<-
		mov		a,#23h
		clr		c
		subb		a,@r0
		jc		labelS1
		mov		p3,#0fbh
		jb 		p3.7,vv21_23
		cjne		@r0,#21h,me21_23dec;-<
		mov		@r0,#23h
		mov		dptr,#teTE7
		call		lotext
		jmp		onmem11

me21_23dec:	dec		@r0
		call		lomenu
		jmp		onmem11

;onmem12:	jmp		viout;	outF	;(ie7)				
						
vv21_23:	mov		p3,#0f7h		;vvod
		jb		p3.7,onmem12
		cjne		@r0,#21h,test22
		;mov		dptr,#tabt11;заслать ус 11А
tests:	call		lotpus
		setb		biteizm;запомнить режим ТИ
		setb		bitizm
		clr		bitmenu;обнулить т к не будет индикации измерения	
		jmp		goto7;onmem11

test22:	cjne		@r0,#22h,test23
		;	mov			dptr,#tabt9;заслать ус 9А
		jmp		tests	

test23:
		;	mov			dptr,#tabt7;заслать ус 7А
		jmp		tests	

left_s:	jmp		left_sk

onmem12:
		mov		r7,#0ffh		;??
		jmp		viout;	outF	;(ie7)				

labelS1:	cjne		@r0,#31h,me_41
		mov			p3,#0fbh			;<-
		jnb			p3.7,left_s
		mov			p3,#0f7h
		jb			p3.7,onmem12
		;запомнить признак установленной скорости в рпзу
;чтение пам прогр(5000h) 1 страница(ffh)
;и запись во внешнее озу(0000h)
		mov		r1,#0			;
		mov		r2,#50h
		mov		r3,#00
		call	copyPP
		;внести изменения во внешн озу
		;KD=00 01 86 A0	(KD=1)
		;коэфф *100000 и переведенный в hex формат
		;согласно адресов диапазонов и адресов яч вн озу 
		mov		r1,#2ch
		mov		a,#0;57,6
		jnb		bitv19,spwri
		mov		a,#1;19.6
spwri:	movx	@r1,a
;стереть страницу пап прогр 
		mov		dptr,#5000h
		mov		r7,#0ffh
		call	cle256
;и запись в ячейки коэфф памяти прогр (3000h) 
		mov		r7,#0ffh
		mov		r1,#0				;external ram
		mov		dptr,#5000h
		call	wrpage
	mov	RSTSRC,#10h	;??reset
		
		clr	TR1	;stop Timer1
		jb		bitv19,outsko1	;загр Т1 в соотв с установленной скоростью
		mov			TH1,#244		;57.6
		jmp			outsko
outsko1:	mov			TH1,#220		;19.6
		setb	TR1	;start Timer1

outsko:	clr		bitmenu
		setb		bitizm
		jmp			out7

rlabels4:	jmp		labels4
rlabelS13:	jmp		labelS13

me_52:	cjne		@r0,#52h,rlabels4
		mov			p3,#0fbh;<-
		jb			p3.7,vv_52v	;ввод в калибровке
		mov		r0,#marker		;сдвиг маркера влево при калибр
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		dec		r1;inc		r1
		mov		savba,@r1
						
		mov		r0,#marker
		dec		@r0				
		clr		bitmig
		mov		a,movleft
		cjne	@r0,#0,me_52v;ажата кн <- при вводе цифр калибровки
		inc			@r0
me_52v:	jmp			goto7
	
vv_52v:	mov		p3,#0f7h
		jnb		p3.7,rvvkali52
		jmp			goto7
rvvkali52:	jmp		vvkali52


me_41:	cjne		@r0,#51h,me_52;rlabels4
		mov		p3,#0fbh;<-
		jnb		p3.7,rlabelS13
		mov		p3,#0f7h
		jb		p3.7,vvmenu
		;ввод пароля
			
;	считать с индикатора 
		mov		r7,#14
		mov		r0,#abin
		call	clearN			
			
;чтение номера байта с индикатора(3байта)
;bufind+3..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;ст            мл
		mov		r0,#bufind+9;
		mov		r1,#adec+9
		mov		r7,#3;3bait
upav1:		clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upav1;adec+7..adec+9
		mov		r2,#50h				;parol 000x    (5028h )
		mov		r3,#28h
		call		re4byte			;r8..r11(3 bait parol)
		jmp			goparol

		mov			a,r8			;сравнить пароль с индикатором
		cjne		a,adec+7,parerr
		mov			a,r9	
		cjne		a,adec+8,parerr
		mov			a,r10
		cjne		a,adec+9,parerr
				;равны
goparol:	mov		r0,#vichR		;режим меню 52
		mov		@r0,#52h		;0000-n
		mov		dptr,#teKD;00000-nA
		call		lotext
		;;;;;;;;;
		;n(hex)->abin
		call	findR				;a=2(10-2)...11(10-11)
		add		a,abin+3
		mov		abin+3,a
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call	bindec
		mov		bufind+8,adec+9
		mov		bufind+7,#2dh
		orl			bufind+10,#80h;зажечь KMП
		orl			bufind+11,#10h;точка после 1 знакоместа
		mov		r1,#diap
		mov		r0,#bufind+8
		mov		a,@r1
		cjne	a,#8,nodi8k
		mov		@r0,#30h		 ;10-10
		dec		r0
		mov		@r0,#63h;31h
		jmp		nodisk9
nodi8k:	cjne	a,#9,nodisk9
				
		mov		@r0,#31h	   ;10-11
		dec		r0
		mov		@r0,#63h;31h
				

nodisk9:	mov		r0,#marker
		mov		@r0,#1
		mov		movleft,#1
		mov		movrig,#5
					
vvmenu:	jmp		goto7

parerr:	mov		nuerr,#32h
		call		error
		call		ind
		call		z_1s
		clr		bitmenu
		setb		bitizm
		mov		r0,#marker
		mov		@r0,#0ffh
		jmp		goto7

left_sk:	jnb		bitv19,tosk19;<-
		mov		dptr,#teS57_6;57,6
		call		lotext
		orl		bufind+11,#80h
		clr		bitv19
		jmp		onmem11;goto7
tosk19:	mov		dptr,#teS19_2
		call		lotext
		orl		bufind+11,#80h
		setb		bitv19
		jmp		onmem11;goto7

labelS13:;<- MENU(ПАРОЛЬ 000)
	
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем слева знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		dec		r1;inc		r1
		mov		savba,@r1
					
		mov		r0,#marker
		dec		@r0				
		clr		bitmig
		mov		a,movleft
		cjne		@r0,#6,onmem13;;нажата кн <- при вводе цифр ПАРОЛЬ 000
		inc		@r0
		jmp		goto7
;;;;;;;

vvkali52:	;введено значение для калибровки
					;число на индикаторе ->Ak  (52h)
					;	считать с индикатора 
		mov		r7,#14
		mov		r0,#abin
		call	clearN			
				
;чтение номера байта с индикатора(3байта)
;bufind+1..bufind+5
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;ст            мл
		mov		r0,#bufind+5;
		mov		r1,#adec+9
		mov		r7,#5;5bait
upav2:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upav2;adec+7..adec+9

		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		call	loadr2			;r2..r5
		call	altof	;r2..r5->float
		mov	dptr,#ch_10;10
		call	ldc_ltemp			;r8..r11=8
		call	flmul
		mov		r0,#rez_Ak
		call	saver2
		clr			bitmenu
		setb		bitklb
		orl		bufind+10,#80h;зажечь KMП
		setb		bitizm;бит калибровки уже установлен
		mov		r0,#marker
		mov		@r0,#0ffh
		mov		r0,#chkl
		mov		@r0,#0ffh
		inc		r0
		mov		@r0,#0ffh;38h
		call		z_1s
		jmp		out7


		jmp		goto7
					 
onmem13:	jmp		goto7	;(ie7)

labels4:	cjne		@r0,#42h,vvkali52
		mov			p3,#0fbh;<-
		jnb		p3.7,onmem13
		mov		p3,#0f7h;vvod
		jb		p3.7,onmem13
		jmp		out7							
;;;;;;;
labelI:
		mov		p3,#0feh
		mov		a,p3
		jb		acc.7,nopoint
		;
		jmp		goto7;out7

nopoint:	mov		p3,#0fbh
		mov		a,p3
		jb		acc.7,nopoin7
labelS3:	mov		r0,#marker
		mov		a,movleft
		cjne		a,#3,poina1
		cjne		@r0,#3,nomarl;26
		;mov		@r0,#9
poina2:	mov		a,movrig		;кн <- B=+00000
		mov		@r0,a
		jmp		goto7;	out7

poina1:	cjne		@r0,#4,nomarl;кн <- A= 0000
		jmp		poina2


nomarl:			;				29.12.06
;;;;;;;;;;;;;;;;;;
;необходимо не портить цифру в следуюем справа знакоместе
;т е сохранить ее в ячейке для мигания в противном случае
;при сдвиге курсора мигания вправо переносилась цифра с предыдущего 
;	знакоместа
		mov		r0,#marker
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		inc		r1
		mov		savba,@r1
						
		mov		r0,#marker
		dec		@r0				
		clr		bitmig
		mov			a,movleft
		cjne		a,#3,poinA
		cjne	@r0,#2,gogo7;out7;;нажата кн <- при вводе цифр B=+00000
poin3:	inc		@r0
;нажат ввод А =000000 запомнить константу А
nopoin7:	mov		p3,#0f7h
		mov		a,p3
		jb		acc.7,gogo7;out7
		mov		r0,#vichR
		mov		a,@r0
		cjne	@r0,#21h,no21p7
		mov		@r0,#11h
			;	считать с индикатора  упаковать в плавающий формат
			;   сохранить
		mov		r7,#14
		mov		r0,#abin
		call	clearN			
		call	upakA
				
		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		call	loadr2			;r2..r5
		call	altof			;r2..r5->float
		mov	r0,#konstA
		call	saver2
		mov	dptr,#ch0
		call	ldc_ltemp
		call		flcmp
		jz		erra0
;26
		mov		r0,#marker
		mov		@r0,#0ffh
				
		mov		dptr,#teVICH;teBequ0
		call	lotext
		;	call		outB
		anl		bufind+11,#0bfh		;гашение точки bufind+7
		;	orl		bufind+11,#80h
		jmp		goto7

erra0:	mov		r0,#marker
		mov		@r0,#0ffh
		mov			nuerr,#34h;константа не должна быть равна0
		call		error
		call		ind
		call		z_1s
		mov			r0,#vichR
		mov			@r0,#0
		clr			bitvich
		clr			bitvi11
		setb		bitizm
		mov			r0,#marker
		mov			@r0,#0ffh
gogo7:	jmp			out7;goto7

poinA:	cjne	@r0,#3,out7;;нажата кн <- при вводе цифр A= 0000
		jmp		poin3

no21p7:	  	;считать с индикатора  упаковать в плавающий формат
			;сохранить
		mov		r7,#14
		mov		r0,#abin
		call	clearN			
		call	upakB			
		mov		r0,#abin
		mov		r1,#adec			;мл         ст
		call	decbin			;abin..abin+3 (hex)
		call	loadr2			;r2..r5
		call	altof			;r2..r5->int
		jnb		bitznB,pozB
		mov		a,r2
		orl		a,#80h
		mov		r2,a			;знак-
pozB:		;mov		r0,#konstB
		;call	saver2

		mov		r1,#marker	 ;B=000000-> ВЫЧИСЛИТЬ
		mov		@r1,#0ffh
		mov		r0,#vichR
		mov		@r0,#11h
		jmp		lovich	   ;3.01.07ВЫЧИСЛИТЬ
				

out7:		 ;mov		IE,#80h
		pop		dph
		pop		dpl
		pop		rr7	
		pop		rr6
		pop		rr5
		pop		rr4
		pop		rr3
		pop		rr2
		pop		rr1			        
		pop		rr0
		pop		psw
		pop		acc
		mov		P3IF,#00;		обязательно сбросить опять приходит на обработку прерывания
		mov		P3,#0c0h
		;	mov		EIE2,#30H
		clr		bitmig
		mov		a,P6	   	;p6.4=0
		anl		a,#0efh
		mov		P6,a
		nop
		nop
		mov		a,P6			;p6.4=1	
		orl		a,#10h
		mov		P6,a
		;;;;;;;;;
		mov		a,PCA0CPM0;		TOG0
		orl		a,#46h	;anl		a,#0fbh
		mov		PCA0CPM0,a
		mov		TH2,#0d0h
		mov		TL2,#00
		setb		T2CON.2
		setb		ET2	;IE.5
					    
		reti

lomenu:	mov		r0,#vichR
		cjne	@r0,#11h,menu12
		mov		dptr,#teTESI
lome1:	call	lotexT
		ret
menu12:	cjne	@r0,#12h,menu13
		mov		dptr,#teTESR
		jmp		lome1
menu13:	cjne	@r0,#13h,menu14
		mov		dptr,#teSKOR
		jmp		lome1
menu14:	cjne	@r0,#14h,menu15
		mov		dptr,#teAVK
		jmp		lome1
menu15:	cjne	@r0,#15h,menu21
		mov		dptr,#teKALIB
		jmp		lome1

menu21:	cjne	@r0,#21h,menu22
		mov		dptr,#teTE11
		jmp		lome1
menu22:	cjne	@r0,#22h,menu23
		mov		dptr,#teTE9
		jmp		lome1
menu23:	cjne	@r0,#23h,menu31
		mov		dptr,#teTE7
		jmp		lome1
menu31:	cjne	@r0,#31h,menu41
		mov		dptr,#teS57_6
		jmp		lome1

menu41:		
		mov		dptr,#tePAR
		jmp		lome1
yesvi_kr:	jmp		yesvi_km
endkalib:;KD=Ak/A3
		jb		bifl_kt,yesvi_kr;выч коэфф Км
		mov		r0,#rez_A3
		call		resar2
				
		call		altof			;->float
		mov		a,r2
		anl		a,#7fh
		mov		r2,a
		call		move28
		mov		r0,#rez_Ak
		call		resar2
		call		fldiv
						
		mov		dptr,#CHtho;100000
		call		ldc_ltemp			;r8..r11=8
		call		flmul
		call		ftol		;r2..r5->hex коэфф KD (РЕЗ ИЗМ ЧИСЛО 6разрядное)

		mov		r0,#koefKD
		call		saver2
		;запись в рпзу в соотв ячейку
			
		mov		r1,#0			;счит рпзу во внешн озу
		mov		r2,#50h
		mov		r3,#00
		call		copyPP
		;внести изменения во внешн озу
		call		findext			;r1-внешн озу
		mov		r0,#koefKD
		call		resar2
		mov		a,r2
		movx		@r1,a
		inc		r1
		mov		a,r3
		movx		@r1,a
		inc		r1
		mov		a,r4
		movx		@r1,a
		inc		r1
		mov		a,r5
		movx		@r1,a
		;коэфф *100000 и переведенный в hex формат
		;согласно адресов диапазонов и адресов яч вн озу 
		;стереть страницу пап прогр 
		mov		dptr,#5000h
		mov		r7,#0ffh
		call		cle256
;и запись в ячейки коэфф памяти прогр (3000h) 
		mov		r7,#0ffh
		mov		r1,#0				;external ram
		mov		dptr,#5000h
		call		wrpage
;2.2.07
		mov		r1,#diap
		cjne		@r1,#5,fulkalib
		;jb		bifl_kt,yesvi_km;выч коэфф Км
		setb		bifl_kt
		;call		loadus
		mov		dptr,#tabt7;заслать ус 7А	
		clr		a
		movc		a,@a+dptr				;high byte
		mov		p4,a
		inc		dptr
		clr		a
		movc		a,@a+dptr				;low byte
		mov		p5,a
		jmp		goto7;	out_kali

;;;
fulkalib:
		clr		bitklb
		setb		bitpar			;пароль провели 1 раз успешно
		mov		dptr,#teEND
		call		lotext
		call		ind
out_kali:	call		z_1s
		call		z_1s
		jmp		goto7
yesvi_km:		;выч коэфф Км=(10**5/A2)*K7/K5
		mov		r2,#50h			;-11a
		mov		r3,#14h			;k7
		call		rebyte2				;r2..r5- hex
		call		altof			;r2..r5->float
		push		rr2
		push		rr3
		push		rr4
		push		rr5
		mov		r2,#50h			;k5
		mov		r3,#0ch
		call		rebyte2			;r2..r5
		call		altof			;r2..r5->float
		call		move28
		pop		rr5
		pop		rr4
		pop		rr3
		pop		rr2
		call		fldiv			;K7/K5

		mov	dptr,#CHtho;100000
		call	ldc_ltemp			;r8..r11=8
		call	flmul				;r2..r5 ;K7/K5*10**5
		push		rr2
		push		rr3
		push		rr4
		push		rr5
				
		mov			r0,#rez_A3
		call		resar2
		call		altof				;r2..r5->float
		call		move28
		pop			rr5
		pop			rr4
		pop			rr3
		pop			rr2
		call		fldiv		;Km	

		mov	dptr,#CHtho;100000
		call	ldc_ltemp			;r8..r11=8
		call	flmul				;r2..r5
		call	ftol			;r2..r5->hex коэфф Km(РЕЗ ИЗМ ЧИСЛО 6разрядное)
		mov			r0,#koefKD;2ое исп ячейки koefKD
		call		saver2
		;запись в рпзу в соотв ячейку
		mov		r1,#0			;счит рпзу во внешн озу
		mov		r2,#50h
		mov		r3,#00
		call	copyPP
		;внести изменения во внешн озу
		mov			r0,#koefKD
		call		resar2
		mov			r1,#2ch			;r1-внешн озу коэфф Km
			
		mov			a,r2
		movx		@r1,a
		inc			r1
		mov			a,r3
		movx		@r1,a
		inc			r1
		mov			a,r4
		movx		@r1,a
		inc			r1
		mov			a,r5
		movx		@r1,a
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

		clr		bifl_kt
		call	loadus
		jmp		fulkalib

;выч среднего по блоку
;вых r2..r5
vichmean:	
					;;;;;;;;;;
		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov			a,dpl
		mov			r7,a
		mov			a,dph
		mov			r6,a
		call		resa_hl;save_bl->dptr

		clr		c; в начало блока?
		mov			a,dpl
		subb		a,r7
		mov			r7,a
		jnz			oldmean
		mov			a,dph
		subb		a,r6
		mov			r6,a
		jz			outmea;
;;;;;;;;;;
oldmean:
		call		resa_hl;save_bl->dptr
		mov			r0,#copy_hl
		mov			a,dph
		mov			@r0,a
		inc			r0
		mov			a,dpl
		mov			@r0,a
		mov			r0,#work
		call		clear4
		mov			r0,#chblok;volume
		mov			@r0,#0
meng:		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov			a,dpl
		mov			r7,a
		mov			a,dph
		mov			r6,a
		mov			r0,#copy_hl;call		resa_hl;save_bl->dptr
		mov			a,@r0
		mov			dph,a
		inc			r0
		mov			a,@r0
		mov			dpl,a
		clr			c;-4
		mov			a,dpl
		subb		a,#4
		mov			dpl,a
		mov			a,dph
		subb		a,#0
		mov			dph,a;dptr-4
		;;;;;;;;
		mov		r1,#copy_hl;saven_bl	;сохранить dptr 
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		;;;;;;;;;
		clr		c;пришли в начало блока?
		mov			a,dpl
		subb		a,r7
		mov			r7,a
		jnz			nextmea
		mov			a,dph
		subb		a,r6
		mov			r6,a
		jz			outmea;
					
		;продолжаем сравнение
		;;;;;;;;;;;		
nextmea:	call		loahl_r2	;из яч внешн озу ->r2..r5
		call		altof;->float
		call		move28			;r8..r11
		mov			r0,#work
		call		resar2
		call		fladd
		mov			r0,#work
		call		saver2
		mov			r0,#chblok;volume;кол измерений блока
		inc			@r0
		jmp			meng
outmea:		
		call		loahl_r2	;из яч внешн озу ->r2..r5
		call		altof;->float
		call		move28			;r8..r11
		mov			r0,#work
		call		resar2
		call		fladd
		mov			r0,#work
		call		saver2
		clr			a
		mov			r2,a
		mov			r3,a
		mov			r4,a
		mov			r0,#chblok;volume;кол измерений блока...200d
		mov			a,@r0
		add			a,#1
		mov			r5,a
		call		altof;r2..r5 float
		call		move28
		mov			r0,#work
		call		resar2
		call		fldiv
		mov			dptr,#ch_10	 
		call		ldc_ltemp
		call		fldiv
		call		ftol				;->hex
		call	maform
		mov		r0,#abin
		call	saver2
;;;;;;;;
					
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call	bindec
				
		mov		r0,#adec+9;разместить в буфер индикации
		mov		r1,#bufind+9
		mov		r7,#5
bufmea:	mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz	r7,bufmea
		mov		r0,#bufind+4
		mov		@r0,#2bh	  
		jnb		znmat,nozmea
		mov		@r0,#2dh
nozmea:	orl		bufind+11,#05h
		ret


loahl_r2:	movx		a,@dptr		;из яч внешн озу ->r2..r5
		mov			r2,a
		inc			dptr
		movx		a,@dptr
		mov			r3,a
		inc			dptr
		movx		a,@dptr
		mov			r4,a
		inc			dptr
		movx		a,@dptr
		mov			r5,a	
		ret

min4_hl:	clr			c;-4
		mov			a,dpl
		subb		a,#4
		mov			dpl,a
		mov			a,dph
		subb		a,#0
		mov			dph,a;dptr-4
		ret

routmin:	jmp		outmin
;мин значение по по блоку
vichmin:	;;;;;;;;;;
		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov			a,dpl
		mov			r7,a
		mov			a,dph
		mov			r6,a
		call		resa_hl;save_bl->dptr

		clr		c; в начало блока?
		mov			a,dpl
		subb		a,r7
		mov			r7,a
		jnz			oldmin
		mov			a,dph
		subb		a,r6
		mov			r6,a
		jz			routmin;
;;;;;;;;;;
oldmin:
 		call		resa_hl;save_bl->dptr
										
;с конца блока адрес 2го измерение
		call		min4_hl
					
		mov		r0,#work	;блок анализируется с конца 1я измерение загружается в work
					
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		dptr
					
		mov		r0,#work
		call		resar2
		call		altof;->float;r2..r5
		mov		r0,#work
		call		saver2

		call		min4_hl
		;call		min4_hl
		mov		r0,#copy_hl
		mov		a,dph
		mov		@r0,a
		inc		r0
		mov		a,dpl
		mov		@r0,a
			
		mov		r0,#chblok;volume
		mov		@r0,#0
ming:		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov		a,dpl
		mov		r7,a
		mov		a,dph
		mov		r6,a

		mov		r0,#copy_hl;call		resa_hl;save_bl->dptr
		mov		a,@r0
		mov		dph,a
		inc		r0
		mov		a,@r0
		mov		dpl,a
				
		clr		c;-4
		mov		a,dpl
		subb		a,#4
		mov		dpl,a
		mov		a,dph
		subb		a,#0
		mov		dph,a;dptr-4
		;;;;;;;;
		mov		r1,#copy_hl;saven_bl	;сохранить dptr 
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
						;;;;;;;;;
		clr		c;пришли в начало блока?
		mov			a,dpl
		subb		a,r7
		mov			r7,a
		jnz			nextmin
		mov			a,dph
		subb		a,r6
		mov			r6,a
		jz			outmin;
						
		;продолжаем сравнение
						;;;;;;;;;;;		
nextmin:	mov			r0,#work
		call		resar2
		;call		altof;->float;r2..r5
		call		move28;->r8..r11
		call		loahl_r2		;из яч внешн озу ->r2..r5

		call		altof;->float;r2..r5
					
		call		flcmp
		jnc			nomini
		mov			r0,#work;<
		call		saver2;r2..r5
nomini:	mov			r0,#chblok;volume;кол измерений блока
		inc			@r0
		jmp			ming

outmin:	mov			r0,#work;1ое измерение блока
		call		resar2
		;call		altof;->float;r2..r5
		call		move28;->r8..r11
		call		loahl_r2		;из яч внешн озу ->r2..r5

		call		altof;->float;r2..r5
					
		call		flcmp
		jnc			minivix
		mov			r0,#work;<
		call		saver2;r2..r5
					;;;;;;;;;

minivix:	mov		r0,#work
		call		resar2
		;call		altof;->float
		mov		dptr,#ch_10	 
		call		ldc_ltemp
		call		fldiv
		call		ftol				;->hex
		;;;
		call		maform
		mov		r0,#abin
		call		saver2
;;;;;;;;
		mov		r0,#adec
		mov		r1,#abin+3	;hex->10
		call		bindec
		mov		r0,#adec+9;разместить в буфер индикации
		mov		r1,#bufind+9
		mov		r7,#5
bufmin:	mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz		r7,bufmin
		mov		r0,#bufind+4
		mov		@r0,#2bh	  
		jnb		znmat,nozmin
		mov		@r0,#2dh
nozmin:	orl		bufind+11,#05h
		ret


routmax:	jmp		outmax
;мин значение по по блоку
vichmax:	;;;;;;;;;;
		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov		a,dpl
		mov		r7,a
		mov		a,dph
		mov		r6,a
		call		resa_hl;save_bl->dptr
		clr		c; в начало блока?
		mov		a,dpl
		subb		a,r7
		mov		r7,a
		jnz		oldmax
		mov		a,dph
		subb		a,r6
		mov		r6,a
		jz		routmax;
;;;;;;;;;;
oldmax:
		call		resa_hl;save_bl->dptr
;с конца блока адрес 2го измерение
		call		min4_hl
		mov		r0,#work	;блок анализируется с конца 1я измерение загружается в work
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		r0
		inc		dptr
		movx		a,@dptr
		mov		@r0,a
		inc		dptr
					
		mov		r0,#work
		call		resar2
		call		altof;->float;r2..r5
		mov		r0,#work
		call		saver2
		call		min4_hl
		;	call		min4_hl
		mov		r0,#copy_hl
		mov		a,dph
		mov		@r0,a
		inc		r0
		mov		a,dpl
		mov		@r0,a
		mov		r0,#chblok;volume
		mov		@r0,#0
maxg:		call		adrblok;dptr-адр ячейки 1й соотв блока 
		mov		a,dpl
		mov		r7,a
		mov		a,dph
		mov		r6,a
		mov		r0,#copy_hl;call		resa_hl;save_bl->dptr
		mov		a,@r0
		mov		dph,a
		inc		r0
		mov		a,@r0
		mov		dpl,a
		clr		c;-4
		mov		a,dpl
		subb		a,#4
		mov		dpl,a
		mov		a,dph
		subb		a,#0
		mov		dph,a;dptr-4
			;;;;;;;;
		mov		r1,#copy_hl;saven_bl	;сохранить dptr 
		mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
	;;;;;;;;;
		clr		c;пришли в начало блока?
		mov		a,dpl
		subb		a,r7
		mov		r7,a
		jnz		nextmax
		mov		a,dph
		subb		a,r6
		mov		r6,a
		jz		outmax;
		;продолжаем сравнение
		;;;;;;;;;;;		
nextmax:	mov		r0,#work
		call		resar2
		;call		altof;->float;r2..r5
		call		move28;->r8..r11
		call		loahl_r2		;из яч внешн озу ->r2..r5
		call		altof;->float;r2..r5
		call		flcmp
		jc		nomaxi
		mov		r0,#work;>
		call		saver2;r2..r5
nomaxi:	mov		r0,#chblok;volume;кол измерений блока
		inc		@r0
		jmp		maxg
outmax:	mov		r0,#work;1ое измерение блока
		call		resar2
		;call		altof;->float;r2..r5
		call		move28;->r8..r11
		call		loahl_r2		;из яч внешн озу ->r2..r5
		call		altof;->float;r2..r5
		call		flcmp
		jc		maxvix
		mov		r0,#work;>
		call		saver2;r2..r5
maxvix:	jmp		minivix


bufl_dec:	mov		r0,#chbuf	
		call		resar2  
		mov		dptr,#ch_1	 
		call		ldc_ltemp
		call		flsub
		mov		r0,#chbuf	
		call		saver2  
		ret

;прерывание таймера Т2
inter2:		
		mov		a,PCA0CPM0
		anl		a,#0bfh				
		mov		PCA0CPM0,a
		;mov		a,T2CON		;T2CON.2=0
		;anl		a,#0fbh
		mov		T2CON,#00;a
		clr		IE.5
		reti

;пп выдачи на индикатор 12 байт   bufind..bufind+11
 ind:	;;;
 		mov		a,EIE2
		mov		r2,a;save
		mov		EIE2,#00H
 		call		mign
 		mov		r0,#bufind;+11
		mov		r7,#12
 nexin:	clr		p0.7;6
		mov		a,@r0
		mov		SPI0DAT,a
		jb		TXBSY,$
		setb		p0.7;6
		call		z_9	 	;25mks
		inc		r0;dec		r0
		djnz		r7,nexin
		mov		a,r2
		mov		EIE2,a;#30H
		ret

rs_byte:
;		jnb	RI,S_R2
;		clr	RI
;		clr	C
;		mov	A,SBUF

;S_R2:		;transfer
;		jnb   TI,$
;		clr   TI
	;	mov   SBUF0,r2
	;	reti
;!!! real interrupt filling
		;jnb	is_2,S_R2	;256 samples -> clr
		;reti	;there direct out
S_R2:
		push	PSW
		push	ACC

		mov	A,cnt_out
		jz	S_R4	;after last
		clr	C
		subb 	A,#1
		jc	S_R5		;empty buf
		jnb   TI,S_R3
		clr   TI
		mov	cnt_out,A
;??		push	1
		mov	1,p_out
		mov	A,@R1
;		pop	1
		inc	p_out
;S_R_:
;		jnb   TI,S_R_
;		clr   TI
		mov   SBUF0,A
		jmp	S_R5
S_R3:
		nop
	
S_R4:
		clr	TI
		
S_R5:
;?		jb	is_cmd,S_R9		deadloop RS?
		mov	A,cnt_in
		clr	C
		subb	A,#3
		jc	S_R7	;cmd isn't received
S_R6:		mov	cnt_in,#0
		mov	p_in,#buf_in	; for new
		setb	is_cmd
		jmp	S_R9;reti

S_R7:
		jnb	RI,S_R9
		clr	RI
		mov	A,SBUF0
;??		push	1
		mov	R1,p_in
		mov	@R1,A
		inc	p_in
		inc	cnt_in
		mov	A,cnt_in
		cjne	A,#3,S_R9
;??		pop	1
		jmp	S_R6
S_R9:
		pop	ACC
		pop	PSW
		reti
cmd_tree:					;??
		mov	cmd_rez,#7Fh
		mov	r0,#buf_in
;		mov	A,#'B'
;		subb	A,@R0
;		jz	ta0
		cjne	@R0,#'B',tb_0
		jmp		ta0
tb_0:
			jmp		tb
ta0:
		inc	r0
		cjne	@R0,#0,ta1
		clr	is_rs		;B0
		jmp	tr9
ta1:
		cjne	@R0,#1,ta2
		setb	is_rs	;?
		mov		R0,#parT
		mov		A,@R0
		cjne	A,#6,ta2_
		setb	is_2
	mov	IE,#80h ;Снятие enable RS
		mov	cnt_out,#0	;?200
		clr		is_rs
		jmp	tr9
ta2_:
		cjne	A,#5,ta3_
		setb	is_2
		mov	IE,#80h
		mov	cnt_out,#0	;?200
		clr		is_rs
ta3_:
		jmp	tr9
ta2:	;?#2 real need
		mov	R0,#0F4h	;?F8h	;abin
		clr	EA
		mov	R1,#diap
		mov	A,@R1
		mov	@R0,A
		inc	R0
		mov	R1,#parT
		mov	A,@R1
		mov	@R0,A
		inc	R0
		mov	R1,#nblok
		mov	A,@R1
		mov	@R0,A
		inc	R0
		mov	R1,#parN
		mov	A,@R1
		mov	@R0,A
		inc	R0
		mov	A,20h	;bitizm,AVP,bitvi11 usefool
	jnb		bitnul,ta3
		orl	A,#80h
		jmp	ta4
ta3:
		anl	A,#7Fh
ta4:
	jnb		knizm,ta5
		orl	A,#1h
		jmp	ta6
ta5:
		anl	A,#0FEh
ta6:
		mov	@R0,A
		inc	R0

		mov	R1,#interva
		mov	A,@R1
		mov	@R0,A
		inc	r0
		inc	r1
		mov	A,@R1
		mov	@R0,A		;interva+1
		inc	r0

		mov	R1,#konstA	;?B3 to make
		mov	A,@R1
		mov	R2,A	;??4bytes
		inc	r1
		mov	A,@R1
		mov	R3,A
		inc	r1
		mov	A,@R1
		mov	R4,A
		inc	r1
		mov	A,@R1
		mov	R5,A
		call	ftol
		mov	A,R4
		mov	@R0,A
		inc	r0
		mov	A,R5
		mov	@R0,A

		mov	p_out,#00F4h	;abin
		mov	cnt_out,#9	;was 11
		jmp	tr9
		
tb:
		cjne	@R0,#'L',tc
		inc	r0
		mov	A,@R0
		clr	C
		subb	A,#10
		jnc	mtb2	;
		mov	A,@R0
		mov	R0,#diap
		mov	@R0,A
	call	loadUS
		jmp	tr9

mtb2:		mov	cmd_rez,#7Dh	;Err par
		jmp	tr9


tc:
		cjne	@R0,#'T',td
		inc	r0
		mov	A,@R0
		clr	C
		subb	A,#7
		jc		tc1
		jmp		mtf2	;
tc1:
		mov		A,@R0
		mov		R0,#parT
		mov		@R0,A
		cjne	A,#6,tc2
;		jnb		is_rs,tc2		yet=0
		setb	is_2
			mov	IE,#80h
		mov		cnt_out,#0	;?200
		clr		is_rs
		jmp		tr9
tc2:		cjne	A,#5,tc3
;		jnb		is_rs,tc3
		setb	is_2
	mov	IE,#80h
		mov		cnt_out,#0	;?200
		clr		is_rs
		jmp		tr9
tc3: clr	is_2
		jmp		tr9

td:
		cjne	@R0,#'R',mte
		inc	r0
		mov	A,@R0			;AAAAAAnn, nn=cmd
		anl	A,#3
		cjne	A,#0,te1
		clr	bitvi11
		jmp	tr9
te1:
		cjne	A,#1,te2
		setb	bitvi11
		jmp	tr9
te2:
		cjne	A,#03h,mtf2
		mov	cmd_rez,#7Dh	;Err par
		jmp	tr9
mtf2:		;=2
	mov	A,@R0
		clr	C
		rrc	A
		clr	C
		rrc	A
	push	2		;?
	push	3		;?
	push	4		;?
	push	5		;?
		mov	r4,A
		inc	r0
		mov	A,@R0
		mov	r5,A
		mov	r3,#0
		mov	r2,#0
		call	altof			;r2..r5->float
		mov	r0,#konstA
		call	saver2
	pop	5
	pop	4
	pop	3
	pop	2
		jmp	tr9

mte:
		cjne	@R0,#'H',mtf
		inc	r0
		mov	A,@R0
		clr	C
		subb	A,#4
		jnc	mtf2	;
		mov	A,@R0
		mov	R0,#parN
;	inc	A
		mov	@R0,A
;		inc	parN
		jmp	tr9


mtf:		cjne	@R0,#'A',mtg
		inc	r0
		cjne	@R0,#0,mtf1
		clr	bitavp
		jmp	tr9
mtf1:		setb	bitavp
		jmp	tr9

mtg:		cjne	@R0,#'Q',mth
		inc	r0
		cjne	@R0,#1,mtf3
		setb	bitnul	;?clr, as Izm?
		mov		r0,#rez_A3	;A3
		call		resar2
		mov		r0,#rez_A0	
		call		saver2;A0<-A3
		call		loadUS
		jmp	tr9
mtf3:		cjne	@R0,#02,mtf2
;		clr	bitnul	;?clr, as Izm?
;		mov	r0,#rez_A0
;		call	clear4
;		call	loadUS
;		jmp	tr9
		setb	EA
		clr	is_cmd				
;		pop	1
;		pop	1
;		jmp	ybnul
	clr		bitnul
		mov		DPTR,#ch0 
		CALL  	ldc_long		 ; r2..r5 <-- 0
		mov		r0,#rez_A0	;A0=0
		call		saver2
		jmp		tr9	;goto7

mth:		cjne	@R0,#'I',mti0
		inc	r0
		cjne	@R0,#0,mth1
		setb	knizm	;?bitizm
		mov	A,cmd_rez
		mov	SBUF0,A
		clr	is_cmd
	setb	is_izm
	jmp	keyb1		;--

mti0:	jmp	mti

mth1:
		cjne	@R0,#1,mth2
;		clr	bitizm			;begin reset
		clr	knizm	;?bitizm
		mov	A,cmd_rez
		mov	SBUF0,A
		clr	is_cmd
	setb	is_izm
	jmp	keyb1		;--

mth2:	;I2
;		clr	is_2	;end 10&2 ms
;		clr	is_rs	;end 10&2 ms
		jmp	tr9

mti:		cjne	@R0,#'S',mtx		;RS speed
;		inc	r0
;	clr	EA
;		cjne	@R0,#0,mti1
;		mov	TH1,#220	;19600
;		setb	EA
;		jmp	tr9
mti1:
;		mov	TH1,#244
;		setb	EA
;		jmp	tr9

mtx:
		cjne	@R0,#'M',mty
		inc	r0
		mov	A,@R0			;AAAAAnnn, nnn=cmd
		anl	A,#7
		cjne	A,#5,mtx5
		mov	A,@R0
		clr	C
		rrc	A
		clr	C
		rrc	A
		clr	C
		rrc	A
		mov	R1,#nblok
		mov	@R1,A
	call	adrblok

	call	save_hl
		jmp	tr9

mty: jmp	mty2

mtx5:		clr	C
		subb	A,#6
		jnc	mtf4
		mov	A,@R0
		cjne	@R0,#0,mtx0
		jmp	chaibl9		;clear??SP
mtf4:		mov	cmd_rez,#7Dh	;Err par
		jmp	tr9

mtx0:
		cjne	@R0,#3,mtx1	
		clr		bitbon
		anl	bufind+11,#0fdh;??jmp bufon
		call	ind
		jmp	tr9
;mtx0_:
;		mov	A,cmd_rez
;		mov	SBUF0,A
;		clr	is_cmd
;	setb	is_mem	;?
;		pop	0		;?
;	jmp	labelB;keyb1	;---

mtx1:
		cjne	@R0,#2,mtx2		;start
		setb	bitbon	;bitmem
		mov	r1,#volume	;work	обьем блока
		mov	@r1,#00
		inc	r1
		mov	@r1,#0c7h		;320h/4
		orl	bufind+11,#02h	; on pysk
		call	ind
		jmp		tr9

mtx2:
		cjne	@R0,#4,mtx3		;to PC
		call	adrblok		;dptr-
	call	save_hl
;		setb	is_mem
;-		setb	bitbon	;?Mem will to fill?

		clr	EA
		mov	cnt_out,#200
		mov	SBUF0,#7Fh
mtxa:
	call	reA3_X		;over r2..r5<-внешн пам
	mov			r1,#copy_hl+1;next?
	mov			a,dpl
	mov			@r1,a		;low
	mov			a,dph
	dec			r1
	mov			@r1,a			;high
	mov		dptr,#ch10
		call	ldc_ltemp
		call	zdiv			;form4=invertif <0; divide
		call	maform		;setb/clr	znmat
		mov		r0,#rez_A3	;?
mtxb:
		jnb   TI,mtxb
		clr   TI
		mov	SBUF0,@r0
		inc	r0
mtxc:
		jnb   TI,mtxc
		clr   TI
		mov	SBUF0,@r0
		inc	r0
mtxd:
		jnb   TI,mtxd
		clr   TI
		mov	SBUF0,@r0
		inc	r0
mtxe:
		jnb   TI,mtxe
		clr   TI
		mov		SBUF0,@r0

		mov			r1,#copy_hl+1;saven_bl+1;сохр адрес внешн озу введенного элемента
		mov			A,@r1		;low
		mov			dpl,A
		dec			r1
		mov			A,@r1			;high
		mov			dph,A
		djnz	cnt_out,mtxa

		setb	EA
		jmp	tr9

mtx3:		;M1 only
		clr	EA
		mov	A,@R0
		clr	C
		rrc	A
		clr	C
		rrc	A
		clr	C
		rrc	A
		mov	R1,#interva
		mov	@R1,A
		inc	r0
		inc	r1
		mov	A,@R0
		mov	@R1,A		;interva+1
		jmp	tr9


mty2:
		cjne	@R0,#7Fh,tz
		mov	SBUF0,#7Fh
		jmp	tr9

tz:
		mov	cmd_rez,#7Eh	;Err cmd

tr9:		mov	A,cmd_rez
		mov	SBUF0,A
		setb	EA
		clr	is_cmd
		ret

chaibl9:	;M0-Mem clear
		clr		EA
		call	adrblok
		mov		r1,#work
		mov		@r1,#03
		inc		r1
		mov		@r1,#20h			;320h
goonof9:
		clr		a
		movx	@dptr,a
		inc		dptr
		mov		r1,#work+1
		call	chminus
		mov		r0,#work
		mov		a,@r0
		jnb		acc.7,goonof9
	call	adrblok
	call	save_hl
		jmp	tr9

reA3_m:	clr	EA		;Mem to PC
;		mov		r0,#0F9h
;		movx	a,@dptr
;		mov		@r0,a
;		inc		r0
;		inc		dptr
;		movx	a,@dptr
;		mov		@r0,a
;		inc		r0
;		inc		dptr
;		movx	a,@dptr
;		mov		@r0,a
;		inc		r0
;		inc		dptr
;		movx	a,@dptr
;		mov		@r0,a
;		inc		dptr
;		mov		p_out,#0F9h
;		mov		cnt_out,#4
;		mov	SBUF0,#7Fh	;was cmd_rez
;		ret

save_hlm:	mov		a,nblok
		cjne	a,#1,sm_hl1
		mov		r1,#saven_bl
sm_hl:	mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
		;не конец ли блока
		mov			r1,#volume+1;work+1
		call		chminus
		mov		r0,#volume
		mov		a,@r0
		jnb		acc.7,noend_m
		clr		is_mem			;?breakpoint
;		anl			bufind+11,#0fdh	;?
;		call		ind							;?
noend_m: ret
sm_hl1:	cjne	a,#2,sm_hl2
				mov		r1,#saven_bl2
				jmp		sm_hl
sm_hl2:	cjne	a,#3,sm_hl3
				mov		r1,#saven_bl3
				jmp		sm_hl
sm_hl3:	mov		r1,#saven_bl4
				jmp		sm_hl


$include (subr7.asm) 	
$include (sarifm3.asm) 					
$include (floatm.asm)
$include (wriread.asm)

;$include (d:\amper\subr7.asm) 	
;$include (d:\amper\sarifm3.asm) 					
;$include (d:\amper\floatm.asm)
;$include (d:\amper\wriread.asm)
					      
END
						