   $include (c8051f020.inc)               ; Include register definition file.
	 
NAME	MAIN
		 ;	EXTRN  CODE(end1)
		 ;	EXTRN CODE(numb)
		  ; EXTRN CODE(SOROS)
		   ;EXTRN  CODE(Abegin)

		 	
			;PUBLIC gener,bitmas,bitrs,bitznak
			;PUBLIC meff
			;PUBLIC rez_A, rez_A0;	!!!!!!!!!!!!!
			org 0h;    cseg AT 0

                   jmp begin;;Main               ; Locate a jump to the start of code at 
					
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
						jmp		keyb1		;IE6

						org	9bh
						jmp		keyb2	   ;IE7




TMR2RLL  DATA 0cah;    // TIMER 2 RELOAD LOW                                       */
TMR2RLH  DATA 0cbh;    // TIMER 2 RELOAD HIGH 
 
Main         SEGMENT  CODE

				DSEG
  
bufind	DATA	40h;������ ��������� 12byte
;DATA 4ch
abin		DATA	4fh;4byte
adec		DATA	53h;53h..5dh 10byte
chmas		DATA	6eh;������� ��-��� �������� �������
mabin		DATA	6fh
reacp		DATA	77h;��������� ������ ��� 4byte int (hex)
chkl		DATA	3dh		;������� �������� ���������� 2bait                         
chmasN		DATA	3fh		;n=2,n=10 ������������ n ��������	=20(27.12.06)
savba		DATA	3ch;���� ����� ��������� ��� ��������	
movrig      DATA	3bh;������ ������ ���������
movleft     DATA	3ah; ������ ����� ���������                  
nuerr				DATA	39h;����� ������ (��� ����������)	
nblok				DATA	38h;����� ���������� �����
nelem				DATA	37h;����� �������� � ����� 0..200
saus				DATA	36h;���� ��� �����
sadiap			DATA	34H;���� �������� �� ��� ��������� ������ �����
;DATA		33H
;;;;;
 cellbit		DATA	20h
bitznak		BIT 	cellbit.0	;20.0		
bitmas		BIT 	cellbit.1	;20.1 ��� ���������� �������		
znmat		BIT		cellbit.2	;20.2
bitrs		BIT		cellbit.3	;20.3
bitizm		BIT		cellbit.4	;20.4 ��� ��� ���������
bitavp		BIT		cellbit.5	;20.5  ��� ������ avp
bitvi11		BIT		cellbit.6	;20.6	��� ������� ���� ������ ��������� R!!!
bitzus		BIT		cellbit.7	;20.7;���� ��������	����� ��������� us	

cellbit1		DATA	21h
bitbuf		BIT 	cellbit1.0	;21.0	
bitprd		BIT 	cellbit1.1	;21.1  ������ ���	
bitbon		BIT		cellbit1.2	;21.2  ����� ���
bitmem		BIT		cellbit1.3	;21.3 ������ �� ������
;bmem11		BIT		cellbit1.4	;21.4  	 ��� ���11
bifl_kt		BIT		cellbit1.5	;21.5  ��� ��� ��� �� ����� ���������  
;bmem13		BIT		cellbit1.6	;21.6		 
bitnul		BIT		cellbit1.7	;21.7 ��� ������ ����

cellbit2		DATA	22h
bitt2		BIT 	cellbit2.0	;22.0 ��� ������� T���2	������ ������ �	
bitmenu		BIT 	cellbit2.1	;22.1  ��� ������ ����(������ �� ����)	
bitklb		BIT		cellbit2.2	;22.2  ������� ����������
bitv19		BIT		cellbit2.3	;22.3		��� ��������� ���� ��������� 19.6
bitvich		BIT		cellbit2.4	;22.4  	 1-� ������� �� ��� R (����� ��� R)
biteizm		BIT		cellbit2.5	;22.5   ������� ����� ��������� 
bitpar		BIT		cellbit2.6	;22.6	��� ������������ 1��� ������ 
bitoll		BIT		cellbit2.7	;22.7 ��� ����������
;� ��� ��������� ������ �������� (������ ��� �� ������ )
;��� ������� ������ (T,���� ,������ ,��� R)������ ������� �� ��� ���������
;� ������ �.�. ����� ���������	
cellbit3		DATA	23h
knizm		BIT 	cellbit3.0	;22.0 ��� ������� ������ ������ ���	
bitmig		BIT 	cellbit3.1	;22.1 ��� ������� ��� ������ ����� 	
bitakt		BIT		cellbit3.2	;22.2  ��� �����
bitznB		BIT		cellbit3.3	;22.3 ��� ����� ��� ����� ��������� �
;bit		BIT		cellbit3.4	;22.4  	 
;bit		BIT		cellbit3.5	;22.5    
;bit		BIT		cellbit3.6	;22.6		 
;bit		BIT		cellbit3.7	;22.7
	
rez_Ame   data 5eh;float	 (���1-AN)*K
;hex
rez_A	 data 62h	;��� ����� 100 (10)�������� ���������	 
rez_A1  data 66h	;���1  ������� �� ������� �� 2,10 �� ��������� int (hex)
rez_A0  data 6ah;��� ��� �� ������� �� ����
rez_A2	 data 7bh; A2

chinkor  data  98h;80h		;������� ��������� ���������  2byte
chavt	 data  81h		;������� ��������������	 2byte
chdel	 data  83h		; ������� ��������
;float
kor0_AN	 data  84h		;4byte	AN	��������� ��������� 0
rezAp	 data  88h		;4byte	A+
rezAm	 data  8ch		;4byte	A-
koefKp	 data  90h		;4byte	K+
koefKm	 data  94h		;4byte 	K-
;hex 
parT	 data  9ah		;�������� ������� ���������
chbefore data  9bh		;������� ���������������� ������������
rez_A3   data  9ch		;A3
;FLOAT
koefKD	data  0a0h	   ;KD ����� ���������
rez_Ak	data  0a4h	   ;Ak
parol		data  0a8h	   ;������ � ������ ������
chind	data  0ach	   ;������� ���������
;chbuf	data  0adh	   ;������� ������� �������� � ����� � ���������
diap	data  0aeh	   ;����� ���������
parN	data  0afh	   ;N  ��� ����������� ����������
level	data  0b0h		;������� � ����, ���	,T���
vichR	data  0b1h		;�������� =11,12,13,21
marker  data  0b2h	   ;����� ��������� ����������
summa	data  0b3h	   ;������ ��������������� 	rez_A
load	data  0b7h	   ;�� ��� �������� ������� �� ���������
work	data  0b8h	  ;������� ������
konstA	data  0bch	  ;	��������� � ������ ��������� A
konstB	data  0c0h	   ;	��������� � ������ ��������� B
;	data  0c4h	   ;
Rez_del	data  0c5h	;����� n-�������� /n
rez_R		data	0c9h		;��� ���������� R 4baita
interva	data  0cdh;�������� ��������� (������)2baita
chbuf	data  0cfh	   ;������� ������� �������� � ����� � ���������
saven_bl	data  0d3h;����� ������ � ����� 2 baita
volume		data	0d5h;����� �����
chblok		data	0d6h;volume;��� ��������� �����
copy_hl		data  0d7h;����� ������ ��������� ���������� ������ ����� saven_bl
;data		0d9h

;������� ��� 64K 
;� ��� �������� ��� 0..ffh �������� �������� ���� � ��� ������ � �����
;������  ��������� ����� �������� 0..ffh ����
;		XSEG AT 100h
	PUBLIC 	  MASS0
MASS0  xdata 0100h;	���������� ������ ���������
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
;xdata 

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
					mov	P1MDOUT,#0cdh;86h;8fh;=0x8f;
					mov	P2MDOUT,#00;=0x00;
	//P2MDIN=0xff;//11111111;
	mov	P3MDOUT,#3fh;
	mov	P74OUT ,#0ffh;=0xff;
	mov	REF0CN,#03h;=0x03;
	
	mov	XBR0,#14h;= 0x14;
	mov	XBR1,#00; =0x00;
	mov XBR2,#00;=0x00;
 	mov	P3,#0c0h
	mov	WDTCN,#0deh;=0xde;	 //������ ������ WDT
	mov	WDTCN,#0adh;=0xad;                                   
	mov	TMOD,#22h;=0x22;	//������� �������
	mov	CKCON,#30h;=0x30; //���� �������/12     
	mov	TH0,#0f9h;=0xf9;//	; ��������� �������
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
  
		setb  TCON.6			;������� ����������
		 setb tcon.4

	mov	RSTSRC,#0;=00	;//��������� ������ 

	
     mov	XBR2,#40h
	 mov	XBR0,#06h;16h
	mov		SPI0CN,#03
	mov		spi0ckr,#31H;;;;;;;;#04
;��������� ��������
					mov		SCON0,#50h;01010000;�������� ������ ������������ ��������1
					mov		PCON,#10000000b;��������� �������� �������� SMOD0=1
					mov		CKCON,#00010000b;TIM=1
					mov		TMOD,#00100000b;���2 ����� ��� �����
					mov		TCON,#01000000b;������� �������
					mov			r2,#50h				;57.6->19.2
					mov			r3,#2ch
					call		re4byte			;502ch 1 bait skor
					mov			a,r8
					cjne		a,#00,yst19
					clr			bitv19			;57.6
					mov			TH1,#244
					jmp		  yst1
yst19:		mov			dptr,#teS19_2
					setb		bitv19			;19,2
					mov			TH1,#220
yst1:
					mov		EIE2,#30H;00110000
					mov	IE,#80h;//10000000	;//������ ���������� ���� ����������
;ozu
					clr	a
					mov	r0,#00h	
mecle:		mov	@r0,a 			;�������� ��� 256 ����
					inc	r0
					cjne	r0,#7fh,mecle
					mov	r0,#80h
meff:			mov	@r0,a 
					movx @r0,a
					inc	r0
			cjne	r0,#0dfh,meff
			call	clmassix
;�������� ������� ��� 4������
				mov			dptr,#0
extcle:	clr			a
				movx		@dptr,a
				inc			dptr
				mov			a,dph
				cjne		a,#10h,extcle

			mov		r0,#chinkor
			mov		@r0,#0;1;
			inc		r0
			mov		@r0,#64h;0c8h;90h;
			;;;;
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
			setb	bitizm

			mov		r1,#chbefore
			mov		@r1,#0
			;;;;;;
			mov		dptr,#ch_1		;1->r2..r5 float
			call	ldc_long
			mov		r0,#koefKp	   ;1(float)->koefKp
			call	saver2
			mov		r0,#koefKm		;1(float)->koefKm
			call	saver2
			mov		r0,#koefKD
			call	saver2
			mov			r0,#chbuf
			call	saver2	
			mov		nblok,#1			;����� ���������� �����
			mov		nelem,#1
			mov		r0,#interva
			mov		@r0,#0
			inc		r0
			mov		@r0,#1
			mov		r0,#bufind
age2:
			mov		@r0,#0fdh	  ;�������� ���������
			inc		r0
			cjne	r0,#bufind+12,age2		
			call	ind
			call	z_1s

				;������ ��� �������� ���������
			mov		r0,#bufind
ageon:	  	mov		@r0,#69h;0feh;?
			inc		r0
			cjne	r0,#bufind+12,ageon		
			call	ind
			call	z_1s		;1sec
;;;;;;;;;;;;;;;;
		
			call	z_15;z_1ms
			orl		bufind+11,#10h;��� ����� ����� 1 ����������
;;;;;;;;;;;;;;;;;;;
			mov		r4,#60h
			mov		r5,#00         
			call	iniacp;������������� acp
			call	loadUS		;us 10-7 A
			
rebyte:		clr		bitoll
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
			;������ acp
			call	read	
			mov 	reacp+1,A	;������� ���� 
			call	read	
			mov 	reacp+2,A	;������� ���� 
			call	read
			mov 	reacp+3,A		;�� ����
		   ;;;;;;;;;;;
		   mov		r0,#reacp+1
		   mov		a,@r0
			jb		acc.7,znplus;
			setb	bitznak
			orl		a,#80h	;��� ������ �� 
			mov		@r0,a
				
mmm:		dec		r0;,#reacp
			mov		@r0,#0ffh
			jmp		goznak

mem10ms:	call		ind
					jmp			rebyte				;10ms

labelA:		mov		r10,#0		
			mov		r11,#0
			mov		r0,#chkl
			call	chcmp
			jnz		no0key
			;��������� ie6,ie7	 
		;	mov		EIE2,#30h ;EIE2.5,EIE2.4
		;	mov		EIP2,#30h
		   
no0key:		mov		r1,#chkl 
					call	chdec
			;;;;;;;;;;;;
					jb		bitizm,rebyte
			 ;����� 2 ������ �� ���������

		 	call	ind
			call	z_01s
			call	z_01s
			call	z_01s
			jmp		labelA

znplus:		clr	bitznak
			anl		a,#7fh;fdh			;+
			mov		@r0,a
			dec		r0;,#reacp
			mov		@r0,#00h
			
goznak:	
;;;;;;;;;;;;;
			mov 	r0,#reacp+3
			mov		a,@r0
			mov		r7,#5;6 ����� �� 5 �������� ������
sdvig3:		clr		c
			rrc		a
			djnz	r7,sdvig3 ;d7,d6,d5	  �� ����
			mov		r2,a	;���� ����
			dec		r0		;	reacp+2
			mov		a,@r0
			push	acc
			clr		c
			mov		r7,#3;2
sdvig2:		clr		c
			rlc		a
			djnz	r7,sdvig2 ;d12..d11	 ������� ����
			orl		a,r2
			mov		reacp+3,a;����� �� ����
			pop		acc
			
			mov		r7,#5;6
sdvig1:		clr		c
			rrc		a
			djnz	r7,sdvig1 ;d15,d14	  �� ����
			mov		r2,a   ;����
			mov		a,reacp+1
			push	acc
		;;	push	acc
		   	mov		r7,#3;2
sdvig0:		clr		c
			rlc		a
			djnz	r7,sdvig0 ;	  d21..d16
			orl		a,r2
			mov		reacp+2,a	; ����� �������  ����
			pop		acc	  ;reacp+1
			;;;;;;;;;;;;;;
			jb		acc.7,sdvm
			clr		c
			mov		r7,#5;6
sdvig4:		clr		c
			rrc		a
			djnz	r7,sdvig4 ;	  d23,d22
			mov		reacp+1,a
			jmp		readyacp;ankor;klmas
;;;;;;;;;;;;					
sdvm:		mov		r7,#5;6
sdvig6:		setb		c
			rrc		a
			djnz	r7,sdvig6 ;	  d23,d22
			mov		reacp+1,a
							
; reacp..reacp+3-��������� ������ ���(hex) 
;;;;;;;;;
readyacp:
					mov		r0,#chinkor
			mov		a,@r0
			jnb		acc.7,gopart
				jmp		sumt2
		
gopart:
			mov		r0,#parT	;�������� �������
			mov		r1,#chmasN
			cjne	@r0,#1,noparT1
			;���+���
			mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#summa+3;rez_A+3
			call	ladd
			mov		r0,#summa;rez_A
			call	saver2
			 mov		r1,#chmasN
			mov		@r1,#20;10
			mov		r0,#chbefore
			cjne	@r0,#99,nobef99
			;���/100
			MOV	   DPTR,#ch100 
allsum:		CALL   ldc_ltemp		 ; ltemp <-- 100
			call	zdiv;divide
			mov		r0,#rez_A
			call	saver2		;����� 100 �������� /100
			mov		r0,#Rez_del
			call	saver2	
		   ;;;;;
		   mov		r0,#summa
		   call		clear4

			mov		r1,#chbefore
			mov		@r1,#0
			jmp		klmas		;���� � ������ ���������� ��
nobef99:	inc		@r0		 	;chbefore
			jmp		rebyte;labelA;����� A
;������� ��������� 100 ���� (�� ������� �� ��������� �� ���� � ���������� ������ )
;� ����� ��� �����������  � ���������� ������  �� n



noparT1:	cjne	@r0,#2,noparT2
			;���+���
sumt2:
			 mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#summa+3;rez_A+3
			call	ladd
			mov		r0,#summa;rez_A
			call	saver2
			mov		r0,#chbefore
			mov		r1,#chmasN
			mov		@r1,#10
			cjne	@r0,#19,nobef99;9,nobef99
			;���/20
			MOV	   DPTR,#ch20;ch10 
			jmp		allsum
			;;;;;;;
			

noparT2:	cjne	@r0,#3,noparT3

							 mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#summa+3;rez_A+3
			call	ladd
			mov		r0,#summa;rez_A
			call	saver2
			mov		r0,#chbefore
			mov		r1,#chmasN
			mov		@r1,#4					;n=4
			cjne	@r0,#9,nobef99;9,nobef99
			;���/10
			MOV	   DPTR,#ch10 
			jmp		allsum
			
noparT3:	cjne	@r0,#4,noparT4
aapar:		
	 mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#summa+3;rez_A+3
			call	ladd
			mov		r0,#summa;rez_A
			call	saver2
			mov		r0,#chbefore
			mov		r1,#chmasN
			mov		@r1,#4
			cjne	@r0,#4,nobef99;9,nobef99
			;���/10
			MOV	   DPTR,#ch5
			jmp		allsum

		
noparT4:   mov		@r1,#2		;chmasN n=2
			mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#rez_A
			call	saver2
;��������� � � ������ �� 2/10 ��������
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
;������ �� 10-�� ���������
mas10:  		cjne	@r1,#10,mas20
					mov			dptr,#MASS8
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
			 jmp		endsum

rmas4:		jmp			mas4
;������ �� 20-�� ���������
mas20:		cjne	@r1,#20,rmas4
					mov			dptr,#MASS18
	        CALL		xCIKLWR	  	;MASS18->MASS19
					mov			dptr,#MASS17
	        CALL		xCIKLWR	  	;MASS17->MASS18
       		MOV	  dptr,#MASS16
	        CALL	   xCIKLWR 	   ; MASS16 --> MASS17
	        MOV	   dptr,#MASS15
	       
	       CALL	   xCIKLWR   	  ; MASS15 --> MASS16
	       MOV	   dptr,#MASS14
	       
	       CALL	   xCIKLWR   	  ; MASS14 --> MASS15
			mov			dptr,#MASS13

	       CALL		xCIKLWR	  	;MASS13->MASS14
      		MOV	   dptr,#MASS12
	       
	       CALL	   xCIKLWR 	   ; MASS12 --> MASS13
	       MOV	   dptr,#MASS11
	        
	      CALL	   xCIKLWR   	  ; MASS11 --> MASS12
	       MOV	   dptr,#MASS10
	      
	       CALL	   xCIKLWR   	  ; MASS10 --> MASS11
				 MOV	   dptr,#MASS9
	        CALL	   xCIKLWR   	  ; MASS9 --> MASS10

					mov			dptr,#MASS8
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
;27
				MOV	   dptr,#MASS10+3
	      CALL	 addx
				MOV	   dptr,#MASS11+3
	      CALL	 addx
	      MOV	   dptr,#MASS12+3
	      CALL	 addx
	      MOV	   dptr,#MASS13+3
	     CALL	 addx
	      MOV	dptr,#MASS14+3
	      call	 addx
				MOV	   dptr,#MASS15+3
	     	CALL	 addx
	      MOV	   dptr,#MASS16+3
	      CALL	 addx
	      MOV	   dptr,#MASS17+3
	     CALL	 addx
	     MOV	dptr,#MASS18+3
	      call	 addx
				MOV			dptr,#MASS19+3
	     call	 addx
				jmp		endsum
;������ �� 4� ���������
mas4:			
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
	     
	;23.03		
endsum:
				mov		r0,#chmas;8.11.06  		;0..n(0..2,0..10)
				inc		@r0
				mov		a,@r0	
				jb		bitmas,masfull		;������ �������� 2/10 ����������
				
				cjne	a,chmasN,masx5
				setb	bitmas			;������ ��������
masfull:		mov		chmas,chmasN
				mov		r0,#chmasN
				mov		a,@r0
;masfull:
				cjne	a,#2,nochn2
				MOV	   DPTR,#ch2;10 
				CALL   ldc_ltemp		 ; ltemp <-- 2
				jmp		mas5div

nochn2:		cjne	a,#10,nochn10
						MOV	   DPTR,#ch10 
				CALL   ldc_ltemp		 ; ltemp <-- 10
				jmp		mas5div

nochn10:	cjne	a,#20,nochn20
						MOV	   DPTR,#ch20 
				CALL   ldc_ltemp		 ; ltemp <-- 20
				jmp		mas5div

nochn20:	MOV	   DPTR,#ch4 
				CALL   ldc_ltemp		 ; ltemp <-- 4
				jmp		mas5div

masx5:			mov	ltemp+3,chmas			;������ �� ��������
				clr	a
				mov	ltemp+2,a
				mov	ltemp+1,a
  				mov	ltemp,a

mas5div:
				CALL	   zdiv;divide   			 ; R2-R5 =
			    		 ; = (MAS0+MAS1+MAS2+MAS3+MAS4)/5

			
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;������� ��������� 3 ����� � ����
			mov		r0,#rez_A1
			call	saver2		 ;���� ������� �� �������
;;8.11.06			mov		chmasN,#0
 ;;;;;;;;;;;;
 ;;;;;;;;;;;;
 			clr		c
 			mov		r1,#parT
			mov		a,#2
			subb	a,@r1
			jnc		ankor		;T<3
			;A-=���1				;T>3
			call	altof			;r2..r5->float
			mov		r0,#rez_Ame
			call	saver2
			;;;;
			mov		r0,#koefKp;->r8..r11
			mov		a,r2
			jnb		acc.7,nminus3
			mov		r0,#koefKm;->r8..r11
nminus3:		call	resar8
			call	flmul  ;��������� � ��������� ������� �.�. ��� ���������?
			mov		r0,#rez_Ame
			call	saver2
			jmp		gotoKD

ankor:	
			mov		r0,#chinkor
			mov		a,@r0
			jnb		acc.7,nokorr
			;��������� 0
			jmp	  	kornul
nokorr:	
			;mov		r10,#00		;	chavt
			;mov		r11,#00h
			mov		 r0,#chavt	
			mov			a,@r0;call	chcmp		;����� ������� ���� ���������� � 0h
			jnb		acc.7,nonulavt;jnz		nonulavt	
			mov		r10,#0;1;00;02		
			mov		r11,#0c8h;90h;0c8h;58h
			mov		r0,#chinkor
			call	chcmp
			jnz		noavk
			;��������������
			jmp		autoka;noavk;

rafterK:		jmp		afterK
;;;;;;;;;;
 gotoKD:		clr		c
 			mov		r1,#parT
			mov		a,#4
			subb	a,@r1
			jnc		rafterK		;T<5
			;A1-=A-	*KD			;T>5
			;call		findkoef				;r2,r3-hex
			;	call		rebyte2				;r2..r5- hex
				
			;	call	altof			;r2..r5->float
			;	mov	dptr,#CHtho;100000
			;	call	ldc_ltemp			;r8..r11
			;	call	fldiv
			;	call	move28
			
			mov		r0,#rez_Ame;->r2..r5   ???????????/
			call	resar2
				;call	flmul
			call	ftol			;float->int
			mov		r0,#rez_A1
			call	saver2
			mov		r0,#rez_A0;->r8..r11 hex
			call	resar8
			call	lsub		;A3=A-1-A0
			mov		r0,#rez_A3
			call	saver2
			jmp		labelB	
 ;;;;;;;;;;; 9.11.06
nonulavt:	 mov		r0,#parT
			mov		a,@r0
			xrl		a,#01
			jnz		avtdec1
			mov		r1,#chavt+1	;T=1 chavt-10
			call	tenmin
kordec10:	mov		r1,#chinkor+1
			call	tenmin
			jmp		rezmul

rmo220:		jmp		mo220

avtdec1:	mov		r1,#chavt	
 			call	chdec		;chavt-1
;			jmp		kordec1;rezmul
noavk:		mov		r0,#parT
			mov		a,@r0
			xrl		a,#01
			jnz		kordec1
			;T=1 chinkor-10
		mov		r1,#chinkor+1
			call	tenmin
			jmp		rezmul

rnotestizm:		jmp			notestizm
kordec1:	mov		r1,#chinkor
			call	chdec 		; chinkor-1
		   ;9.11.06
			;;;;;;;;;;;;;;
			;;;;;;;;;;;;;
;(���1-�N)*K
rezmul:
			mov		r0,#rez_A1;->r2..r5
			call	resar2
			call	altof	;r2..r5->float	6.06	
			mov		r0,#kor0_AN;->r8..r11
			call	resar8
			call	flsub
			mov		r0,#koefKp;->r8..r11
			mov		a,r2
			jnb		acc.7,nminus
			;jnb		bitznak,nminus
		
 			mov		r0,#koefKm;->r8..r11
nminus:		call	resar8
			call	flmul  ;��������� � ��������� ������� �.�. ��� ���������?
			mov		r0,#rez_Ame
			call	saver2
 
afterK:			
;;;;;;;;;;;;;;
				mov		a,r2
				anl		a,#7fh
				mov		r2,a
				mov	dptr,#ch_250;220;220000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		rmo220		;A>220000
				;;;;;;;;;
				jnb			biteizm,rnotestizm
				mov			r0,#vichR
				cjne		@r0,#21h,note21
				mov			r2,#50h			;-11a
				mov			r3,#18h			;k8
				call		rebyte2				;r2..r5- hex
				call		altof			;r2..r5->float
				push		rr2
				push		rr3
				push		rr4
				push		rr5
				mov			r2,#50h			;k10
				mov			r3,#20h
re11_7:	call		rebyte2			;r2..r5
				call		altof			;r2..r5->float
				call		move28
				pop			rr5
				pop			rr4
				pop			rr3
				pop			rr2
				call		fldiv
			;	mov			dptr,#ch_10
			;	call		ldc_ltemp			;r8..r11
			;	call		flmul
				;;;;;2.02.07
				push		rr2
				push		rr3
				push		rr4
				push		rr5
				mov			r2,#50h			;-11a
				mov			r3,#2ch			;Km
				call		rebyte2				;r2..r5- hex
				call		altof			;r2..r5->float
				call		move28
				pop			rr5
				pop			rr4
				pop			rr3
				pop			rr2
				call		flmul				;*Km
				mov	dptr,#CHtho;100000
				call	ldc_ltemp			;r8..r11=8
				call	fldiv
				;;;;;
				jmp			temul	
note21:	cjne		@r0,#22h,note22
				mov			r2,#50h			;-09a
				mov			r3,#10h			;k6
				call		rebyte2				;r2..r5- hex
				call		altof			;r2..r5->float
				push		rr2
				push		rr3
				push		rr4
				push		rr5
				mov			r2,#50h			;k8
				mov			r3,#18h
				jmp			re11_7
note22:	mov			r2,#50h			;-7a
				mov			r3,#08h			;k4
				call		rebyte2				;r2..r5- hex
				call		altof			;r2..r5->float
				push		rr2
				push		rr3
				push		rr4
				push		rr5
				mov			r2,#50h			;k6
				mov			r3,#10h
				jmp			re11_7	
				;;;;;;;;;
notestizm:
				jnb		bitklb,komulpz
				mov	dptr,#chk;100000
				call	ldc_long			;r2..r5
				jmp		komul
komulpz:call		findkoef				;r2,r3-hex
				call		rebyte2				;r2..r5- hex
				
komul:	call	altof			;r2..r5->float
				mov	dptr,#CHtho;100000
			call	ldc_ltemp			;r8..r11=8
				call	fldiv
temul:				call	move28
				mov		r0,#rez_Ame
				call	resar2
		
				call	flmul	  ;A1-=A-*KD  fl
				
				call	ftol			;float->int
				mov		r0,#rez_A1
				call	saver2
				call	altof			;r2..r5->float
				mov	dptr,#ch_220;200;200000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		rrmo220		;A>200000
			;	jnb		knizm,noavp;goA2;		bitizm,goA2	
			;	jb		bitavp,yesavp
				jnb		knizm,goA2
				jnb		bitvi11,qu_avp
				jmp		goA2
qu_avp: 		jb		bitavp,yesavp
noavp:	;		jb		bitvi11,yesvich  ;��� ����� ����� A B (���� ���������)
goA2:			 ;A2=A1-
				 mov		r0,#rez_A1
				call	resar2
				mov		r0,#rez_A2
				call	saver2
goA3A2:			 ;A3=A2-A0
				  mov		r0,#rez_A0
				call	resar8
				call	lsub
				mov		r0,#rez_A3
				call	saver2
				;;;;;;
				jb		bitvi11,yesvich
goonin:		   ;jmp		goonind;indA3;8.11.06
				mov		r0,#chind
				cjne	@r0,#0,rnochi0
				jmp		goonind;indA3

rrmo220:		jmp		mo220
rnochi0:		jmp		nochi0
gokaA2:			mov		r0,#rez_A1			;(float)
						call	saver2				;��� ����� ��� ���������� ,goA2 �������� � ���� ����
 					jmp		goA2
;;;;;;;;;;;;;;;;
yesavp:		   	mov		a,r2
				anl		a,#7fh
				mov		r2,a
				mov	dptr,#ch_10th;10000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		noavp		;A>10000	
				mov		r0,#diap		;10-11
				cjne	@r0,#9,avpgo
				jmp		noavp
avpgo:			
				inc		@r0		;�������� �������� �� 1 ������� ����
				cjne	@r0,#0ah,clmasv
				dec		@r0
clmasv:		;�������� ������
			call	loadUS
			;call	louizm
			call	 clmassix
				mov		r0,#summa
				call	clear4
				mov		r0,#rez_A0
				call	clear4
				setb		bitzus;bitbuf;;;;;;;;;;;;									 
			   jmp	   goonin

yesvich:  	
		;		 	mov		r0,#konstB
		;		call	resar2
		;		call	move28
				mov		r0,#rez_A3;A1
				call	resar2				;HEX
				
				call		altof			;r2..r5->float
				mov		a,r2			;������
				anl		a,#7fh
				mov		r2,a
		;		call		fladd				;A1+B
				
				mov	dptr,#CH_500;
				call	ldc_ltemp			;r8..r11
				call	flcmp
				jc			mo500R;error <500 >22000
				mov	dptr,#CH_22T;
				call	ldc_ltemp			;r8..r11
				call	flcmp
				jnc 		mo500I		;error
				;;;;;;;;;;;;
				call		move28
				push		r8
				push		r9
				push		r10
				push		r11
				mov		r0,#konstA
				call	resar2
				mov		dptr,#CH_B
				CALL   ldc_ltemp		 ; ltemp <-- 10-7
				call		flmul				;A*10-7
				pop			r11
				pop			r10
				pop			r9
				pop			r8
				call		fldiv			;��������� R
				mov			r0,#rez_R
				call		saver2
				call		ftol			;float->hex
				;;;;;;;;;;
					mov		r0,#abin
					call	saver2
;;;;;;;;
						mov		r0,#bufind
age9:
			mov		@r0,#" "	  ;�������� ���������
			inc		r0
			cjne	r0,#bufind+11,age9
					
					mov		r0,#rez_R
					call		resar2
;;;;;;;;;;
				mov		dptr,#CH_fl
				CALL   ldc_ltemp
				call		fldiv

				mov		r0,#work		;������� +
				mov		@r0,#0
				mov		r0,#work+1;������� -
				mov		@r0,#0
compa1:	mov	dptr,#ch_1;
				call	ldc_ltemp			;r8..r11
				call	flcmp
				jc		equ0		;<1
				mov		r0,#work			;������� +
				inc		@r0
				mov		dptr,#ch_10;
				call	ldc_ltemp			;r8..r11
				call		fldiv
				jmp		compa1				;work �������� ������� n(hex)  
				;;;;;;;;;;;;;;;;;;;
mo500R:	mov		dptr,#teOLR
			  call		lotext		 
				call		ind
				jmp			nobavp;nobitizm
mo500I:	mov		dptr,#teOLI
			  call		lotext		 
				call		ind
				jmp			nobavp;nobitizm
equ0:		;;;;;	call		ftol			;float->int
				mov		r0,#work		;������� +
				cjne	@r0,#0,equ00
				
compa2:	mov	dptr,#ch_1;
				call	ldc_ltemp			;r8..r11
				call	flcmp
				jnc		equ00		;>1
				mov		r0,#work+1			;������� -
				dec		@r0							;0,ff(-1),fe(-2)...
				mov		dptr,#ch_10;
				call	ldc_ltemp			;r8..r11
				call		flmul
				jmp		compa2				;work �������� ������� n(hex)  


equ00:		
						mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec

						;���� ������� ����� ������� ������� ����
						;����� ��������� � 5 ��������, ���� ����� �����������
						;����� � bufind..bufind+5
					mov		r0,#work
					cjne	@r0,#0,outr
					inc		r0			;work+1
					cjne		@r0,#0ffh,bufr3		;6�������� ����� ������� 5
					inc			@r0;!!!!!!!!!?
					mov			r0,#adec+8;���������� � ����� ��������� R
					jmp			bufr30
					;;;;;;;;;;;;;;
bufr3:		inc		@r0			;?!!!!!!!!n+1
						mov		r0,#adec+9
bufr30:		mov		r1,#bufind+5;6
					mov		r7,#5;7
bufr2:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufr2

					mov		r0,#abin
					call		clear4
					mov		r0,#work+1
				jmp		outr5
;work!=0 ������ ����� ��� �� 10**9 �������� ����� > � ��� 6 ��������					
outr:			mov		r0,#adec+9;���������� � ����� ��������� R
					clr		c
					mov		r1,#work
					mov		a,r0
					dec		a					;n-1
					subb	a,@r1
					mov		r0,a			;adec+9-n !!!!!!!!!!!!!!!
				mov		r1,#bufind+5;� � ����� �������� > ��� ���������
					mov		r7,#5;7
bufr:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufr

					mov		r0,#abin
					call		clear4
				mov		r0,#work
outr5:			mov		a,@r0
					mov		abin+3,a
								;n(hex)->abin
					call	findR				;a=2(10-2)...11(10-11)
					add		a,abin+3
					mov		abin+3,a
					mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec
					mov		bufind+8,adec+9
					mov		bufind+7,adec+8
					mov		bufind+9,#66h
					jmp		nobavp;nobitizm;	goonin;call	ind
					
				;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;

mo220:		   jnb		bitavp,indoll
			   jnb		knizm,indoll;bitizm,indoll
				mov		r0,#diap
				cjne	@r0,#0,nodi2
			   ;10-2
indoll:			mov		dptr,#teOLL;OLL
				call	lotext
				setb	bitoll
				jmp		goonin	

nodi2:		   dec		@r0	;����������� �� 1 ������� �����

				cjne	@r0,#0ffh,nodi9
				inc		@r0

nodi9:		call	loadUS
				;call	louizm
				;�������� ������
				call	 clmassix
				mov		r0,#summa
				call	clear4
				mov		r0,#rez_A0
				call	clear4	
				setb	bitzus;bitbuf	;���� ��������	����� ��������� us						 
			   jmp	   goonin

nochi0:			dec		@r0			;���-1
				jmp		labelB	

	
;;;;;;;;;;;;;;;

nop3_0:	;;	;rez_A-rez_A0
		;;			mov		r0,#rez_A0
		;;			call	resar8
		;;			call	lsub
		;;			mov		r0,#rez_A
		;;;			call	saver2
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 indA3:				mov		r0,#rez_A3	 ;A3 ->� ������� �����(6��� �������� � � ���)
					call	resar2
					mov		dptr,#ch100		 
					call	ldc_ltemp	 
					call	zdiv		;rez_A3/100=r2..r5
				
					mov		a,r4
					jb		acc.7,aless0
					orl		a,#08			;rez_A>0 d11=1
					mov		DAC0H,a
									;�� ����
					mov		a,r5
					mov		DAC0L,a
					jmp		moveA3;

no3parN:			cjne	@r1,#2,no2parN
					;� ���� 0  �������� ������
					mov		r1,#bufind+6
					mov		@r1,#" ";0fdh;
					jmp		seeind;moveA3

no2parN:			;� ����� 0 � 1 �������� ������
					mov		r1,#bufind+5
					mov		@r1,#" ";0fdh;" "
					inc		r1
					mov		@r1,#" ";0fdh;" "
					jmp		seeind;moveA3
 rseeind:		jmp		seeind
aless0:				cpl		a
					anl		a,#0f7h		;d11=0
					mov		DAC0H,a
									;�� ����
					mov		a,r5
					cpl		a
					mov		DAC0L,a
goonind:		  ; ������ �� ��������� ����������
				
					
moveA3:	;������ �� ���R	�� �������� �� ��������� �� ������� bufind..
		;�� ������� �� �� ���������� �� ������ �� ������ ���� �������
		;�� ����� ����� ��������� ��������� �� ��������� � ������
		;�� �������� ���������� �� ������ �� ������ ��� ������ 
		;� �������� � ����� ���������
					jb		bitvich,rnorvich
					jb		bitt2,rnorvich
					jb		bitoll,rseeind
					
					jb		bitmenu,rseeind
 					jb		bitmem,rseeind
;;;;;;;;;;;;;;
					; mov		r0,#rez_A3
					;call	resar2
				 	;call	ftol			;float->int r2..r5
;;;;;;;;
					mov		r0,#rez_A3;->r2..r5	  �������� A3 � ���������
					call	resar2;????????????????17.01.07
				
					call	maform
					mov		r0,#abin
					call	saver2
;;;;;;;;
					
					mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec
				
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+6
					mov		r7,#7
bufdec:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufdec
					mov		r0,#bufind+7
					mov		@r0,#2dh	  ;-2..-9
					mov		r0,#bufind
					mov		@r0,#2bh
					jnb		znmat,nozzmi;bitznak,nozzmi
					mov		@r0,#2dh
nozzmi:				mov		r1,#diap
					mov		r0,#bufind+8
					mov		a,@r1
					cjne	a,#8,nodi8
					mov		@r0,#30h		 ;10-10
					dec		r0
					mov		@r0,#63h;31h
					inc		r0
					jmp		seegoon
nodi8:				cjne	a,#9,nodis9
				
					mov		@r0,#31h	   ;10-11
					dec		r0
					mov		@r0,#63h;31h
				
					inc		r0
					jmp		seegoon

rnorvich:		jmp		norvich
rno3parN:		jmp		no3parN

nodis9:				add		a,#32h
					mov		@r0,a;#37h;"T";
seegoon:			inc		r0
					mov		@r0,#"A";"E";
					inc		r0
					mov		@r0,#00h ;=feh � ��� �������� ��� ������� ���� ����
					inc		r0;		mov		bufind+11
					mov		@r0,#010h		;bufind+11.4 ����� ����� ������ �����
					
;;;;;;;;;;;;;;;
;;;;;;goonind:
					mov		r1,#parN	; ??????
					cjne	@r1,#3,rno3parN ;  8.11.06
	
seeind:				;;;;;;;;;;;;;
					mov		r0,#bufind+10
					mov		a,@r0
					jnb		bitnul,nnnul
					orl		a,#08h
					mov		@r0,a
 nnnul:		mov		r1,#parT
					cjne	@r1,#2,nsec1
					orl		a,#20h	  ;1s
					jmp		nsec10
nsec1:		cjne	@r1,#1,nsec11
					orl		a,#40h			;10s
					jmp		nsec10
				
nsec11:		orl		a,#10h
						 ;0,1s
;;;;;;;;;;;;;;;;
nsec10:		


					mov		r0,#bufind+10	
					mov		@r0,a
					jnb		bitavp,nobavp
					orl		a,#04		;bufind+10.2
					mov		@r0,a
					mov		@r0,a	
nobavp:		mov		r0,#bufind+10	
					mov		@r0,a	
				   jnb		knizm,nobitizm
					orl		a,#02
					 mov		@r0,a
nobitizm:			
					jnb		bitakt,notakt
					clr		bitakt
					anl		bufind+10,#0feh
					jmp		taktind
notakt:				setb	bitakt
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
test9i:		cjne	@r1,#22h,test7i
					mov		@r0,#32h;39h;09A
					jmp		yesind
test7i:		mov		@r0,#33h;37h;07A
;;;;;;;;;
yesind:		
					jnb		bitklb,noklb
					orl		bufind+10,#80h; on kmp
noklb:		jnb		bitbon,nobuf
					orl		bufind+11,#02h; on pysk
nobuf:		call	ind	   ;�� ������ �� ���������
norvich: 
     				mov		r0,# parT
					mov		r1,#chind
					cjne	@r0,#1,rnot1in
labelB:			   ;;;;;;;;;;;
					;����� �� ��������� ����� ���������� � ���� 
						mov 	r0,#rez_A3+3
			;;;;;;;;
			mov		r1,#work+3
			mov		a,@r0
			mov		r7,#7;��� ��� ������
dvig3:		clr		c
			rrc		a
			djnz	r7,dvig3 ;d7,d6,d5	  �� ����
			mov		r2,a	;���� ����
			dec		r0		;rez_A3+2
			mov		a,@r0
			push	acc
			clr		c
			mov		r7,#1
dvig2:		clr		c
			rlc		a
			djnz	r7,dvig2 ;d12..d11	 ������� ����
			orl		a,r2
			mov		@r1,a;����� �� ����
			dec		r1
			pop		acc
			
			mov		r7,#7
dvig1:		clr		c
			rrc		a
			djnz	r7,dvig1 ;d18	  �� ����
			mov		r2,a   ;����
			dec		r0
			mov		a,@r0 ;rez_A3+1
			push	acc
		
		   	mov		r7,#1
dvig0:		clr		c
			rlc		a
			djnz	r7,dvig0 ;	  d21..d16
			orl		a,r2
			mov		@r1,a	; ����� �������  ����
			dec		r1
			pop		acc	  ;rez_A3+1
			;;;;;;;;;;;;;;
;			jb		acc.7,dvm
			clr		c
			mov		r7,#7
dvig4:		clr		c
			rrc		a
			djnz	r7,dvig4 ;	  d22
			mov		r2,a   ;����
			dec		r0;	rez_A3
			mov		a,@r0
			;;;;;
			mov		r7,#1
vig0:		clr		c
			rlc		a
			djnz	r7,vig0 ;	  d24..d30
			orl		a,r2
			mov		@r1,a	; �����   ����
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

rnot1in:		jmp		not1in

;;;;;;;;;;;;					
dvm:		mov		r7,#7
dvig6:		setb		c
			rrc		a
			djnz	r7,dvig6 ;	  d31
endsdv:		mov		@r1,a
							
 ;->work   
 			
			mov		dptr,#chzap
			call	 ldc_long
			 mov		r0,#work+3
			call	ladd
			mov		a,r5
			mov		DAC1L,a
			
			mov		a,r4
			mov		DAC1H,a

					;;;;;;;;;;
					mov			r0,#chbuf	
					call		resar2  
					mov			dptr,#ch_1	 
					call		ldc_ltemp
					call		flsub
					mov			r0,#chbuf	
					call		saver2  
					mov			dptr,#ch_1
					call		ldc_ltemp
					call		flcmp
					
					
					
					jnc			rnobuf0
					jb		bitprd,yesprd	;��������   A3 � �����
					jb		bitbon,yesbuf	;��������   A3 � �����
					jmp		gocikle
rnobuf0:	jmp		nobuf0
yesprd:	;��������   A3 � �����
					jmp		goonT
yesbuf:		;��������   A3 � �����
					call		resa_hl;dptr-
					call		loA3_X	;����� ���� ������ ����� ��� ������
									;� ������ saven_bl
					call		save_hl
					mov			r0,#diap
					mov			a,@r0
					mov			sadiap,a
					;�����
						mov		a,P6	   	;p6.4=0
			anl		a,#0efh
			mov		P6,a
			nop
			nop
				
			mov		a,P6			;p6.4=1	
			orl		a,#10h
			mov		P6,a			    
goonT:			  	mov		r0,#interva;high  byte loadr2
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
								cjne	@r0,#1,nott1
				
				mov			dptr,#ch_2	 
				call		ldc_ltemp
intmul:	call		flmul
intmul1:mov			r0,#chbuf
				call		saver2		;*2
				jmp		gocikle

nott1:			cjne	@r0,#2,nott2
						mov			dptr,#ch_10	 
				call		ldc_ltemp
				jmp			intmul					;*10

nott2:			cjne	@r0,#3,nott3
						mov			dptr,#ch_2	 
				call		ldc_ltemp
				jmp			intmul					;*2


nott3:		cjne	@r0,#4,nott4
					mov			dptr,#ch_10	 
					call		ldc_ltemp	;/10*4
					call		fldiv
					mov			dptr,#ch_4	 
					call		ldc_ltemp
					jmp		intmul

nott4:		cjne	@r0,#5,nott5
 						mov			dptr,#ch_5	 
					call		ldc_ltemp
					call		fldiv		;/5
					jmp		intmul1;T=5
nott5:			mov			dptr,#ch_1	 
				call		ldc_ltemp
				jmp			intmul					;*1


gocikle:	jnb		bitzus,nofz			
			call	z_05s	 ;0,5c
			call	z_05s	 ;0,5c
			clr	bitzus;bitbuf ��� �������� ������� us
nofz:		jmp 	labelA;rebyte


yestt5:		jmp		gocikle

nobuf0:				mov		r0,#chbuf
 							call		resar2
								mov			dptr,#ch_1	 
				call		ldc_ltemp
				call		flsub
					jmp		gocikle


not1in:				cjne	@r0,#2,not2in
					mov		@r1,#1		 ;T=2
					jmp 	labelB

not2in:				cjne	@r0,#3,not3in
					mov		@r1,#1;9		;T=3
					jmp 	labelB
not3in:				mov		@r1,#3;19
					jmp 	labelB


;;;;;;;;;;;3.11.06

;;��������� 0
KORnul:		mov		r0,#chdel
			cjne	@r0,#0,nonuldel
				
			mov		a,p4			;����  us
			mov		saus,a
			mov		a,p5
			mov		saus+1,a

			mov		dptr,#kor0us
			call	lospus		;��� ����� ��������� 0
			jmp		chdelmo

nonuldel:  	;cjne	@r0,#7,no4del
						cjne	@r0,#3,no4del
			;��� ->AN
			mov		r0,#rez_A;->r2..r5
			call	resar2
	
				;;;;;;;;;;
			call	altof		;r2..r5->float
			mov		r0,#kor0_AN;->kor0_AN
			call	saver2
				
			mov		a,saus			;������� �������� ��� �����
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
			mov		@r0,#00;1;00;02;600;
			inc		r0
			mov		@r0,#0c8h;90h;0c8h;58h;258h
			call	clmassix;�������� ������ ������ ��������
			jmp		 rebyte

;��������������
autoka:	 ;;  mov		r0,#chavt
		 ;;  call		chcmp
		 ;;  jz		nulavt
		;;   mov		r1,#chavt
		;;   call		chdec;chavt-1
		 ;; jmp		rebyte
nulavt:  ;;;;;
			mov		r0,#chdel
			cjne	@r0,#0,nndelch
			mov		a,p4			;����  us
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
			mov		r0,#rezAp;->rezAp
			call	saver2				
			mov		r0,#kor0_AN;kor0_AN->r8..r11
			call	resar8				
			call	flsub		; r2..r5(A+-AN)
			call	move28	   ;r2..r5->r8..r11
			mov		dptr,#CH2tho;000->r2..r5 float
			call	ldc_long		
			call	fldiv
			mov		a,r2
			anl		a,#7fh
			mov		r2,a
			mov		r0,#koefKp;->koefKp
			call	saver2
		  
		;	anl		P5,#0feh		;p5.0=0	
		mov		a,P5
			anl		a,#3bh;acp-
			mov		P5,a
			mov		r0,#chdel
			inc		@r0			  ;ch+1
			jmp		rebyte

n4delch:	cjne	@r0,#6,n8delch
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
			mov		dptr,#CH2tho	;000->r2..r5 float
			call	ldc_long		
			call	fldiv
			mov		a,r2
			anl		a,#7fh
			mov		r2,a
			mov		r0,#koefKm;->koefKm
			call	saver2
		   
			mov		a,saus			;������� �������� ��� �����
			mov		p4,a
			mov		a,saus+1
			mov		p5,a 		
		 	mov		r0,#chdel
			inc		@r0			  ;ch+1
		   jmp	  rebyte

n8delch:	cjne	@r0,#9,n12delch
			mov		@r0,#0
			mov		r1,#chavt
			mov		@r1,#0ch;6;1;
			inc		r1
			mov		@r1,#80h;40h;
			call   clmassix     ;�������� ������ ��������
			jmp		rebyte
n12delch:	inc		@r0
			jmp		rebyte



		            
rout6:		jmp		out6
rlabelF:	jmp		labelF	
rknrazr:	jmp		knrazr	
rknopt:		jmp		knopt
rizman:		jmp		izman	
keyb1:	;IE6 
				mov		EIE2,#00H
				
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
				;clr		bitmig
		  ;;;;;;;;;;;;;;
		  		call	z_01s;0,1s
					call	z_01s
				;������� ���������� ��� �������
				;� � � ����� �� ������ ��������� ������� 20h(������)
			  	mov		r0,#marker
			  	mov		a,#bufind
				add		a,@r0			;a=bufind+marker
				mov		r1,a
				mov		@r1,savba
				;;;;;;;;;;;
     			mov		a,p3
				jb		acc.6,outviR;����� �� ������ ��� R
gout6:				mov		a,p3
				orl		a,#0ffh		; p3.(5-0)<-3f
				mov		p3,a
				mov		a,p3
				jnb		acc.6,rout6		;error
				jnb		bitizm,rlabelF
				mov		p3,#0feh		;��� IZM
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
				clr		bitvich				;����� �� ������ ��� R	
				clr		bitvi11
				
goklb: 		jmp		out6

pyskst:			jb	bitbon,bufon		;pysk/stop
				setb	bitbon	;��� ��� ����� ���
				mov			r1,#volume;work		;����� �����
				mov			@r1,#00
				inc			r1
				mov			@r1,#0c7h			;320h/4
				orl		bufind+11,#02h; on pysk
				call		ind
				jmp		izmpaT
bufon:			clr		bitbon	;��� ��� ����� ����
					anl		bufind+11,#0fdh; off pysk
					call	ind
				jmp		izmpaT

tizmri:			mov		r1,#level
				cjne	@r1,#1,right2
				;10s->HET
				jmp		right3

right2:			inc		@r1
				call	lolevT
				;call	loadT	;������ ��-> � ��� T��� 
right3:			call	ind
				jmp		izmfun

			
			
knright:	

				mov		r1,#diap
			;������ �������� 1 ��� ����� ��� ������
				dec		@r1
				cjne	@r1,#0ffh,diinc
				mov		@r1,#0
				jmp  izmfun
diinc:			call	 clmassix
				mov		r0,#summa
				call	clear4
				mov		r0,#rez_A0
				call	clear4	
				call	loadUS
				 jmp  izmfun

knvich:		   jb		bitvi11,onvich
				clr		bitizm
				setb	bitvich
				
				mov		r0,#vichR
				mov		@r0,#11h;;????????or 0
				;���������
				mov	dptr,#teVICH
				call	lotext
			   call		z_1s;;;;;;;
				jmp		 viout;izmpaT

onvich:			clr		bitvich
				mov		r0,#vichR
				mov		@r0,#0
			 	jmp		 izmpaT
; ��� ��� ����� ��� ������� ���	d3(k5 p4),d3(u5 p5)
louizm:		   jnb		knizm,lou
				mov		r1,#diap
				clr		c
				mov		a,#3
				subb	a,@r1
				jnc		lldi23	  ;10-2..10-5
				;10-6..10-11
				mov		a,p4
				anl		a,#0f7h	  ;d3
				mov		p4,a
lldi23:			mov	   	a,@r1
				xrl		a,#3
				jnz		lldi3
				jmp		lldi2	;10-5
lldi3:			mov	   	a,@r1
				xrl		a,#2		;
				jnz		lou		
lldi2:		 	mov		a,p5		;10-4
				orl		a,#08
				mov		p5,a
lou:			ret
			  ;;;;;;
izman:			jb		knizm,knizmon
				setb	knizm		;��� ��� ��� ���
			;	d3(k5 p4),d3(u5 p5)������� us
				call	louizm 
				jmp		izmfun
knizmon:		clr		knizm		;��� ��� ��� ����
				call	loadUS;������������ us
izmfun:			
				setb	bitzus;bitbuf
				jmp		labelE;;;;;;;;;;;;
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




knopt: ;������ T
			   clr		bitizm
			   setb		bitt2
			   mov		r1,#load
			   mov		@r1,#4;1s
			   call		loadT		;T=1S,10S,HET,0.1S,50mS,
			mov		r1,#chkl
			mov		@r1,#27h
			inc		r1
			mov		@r1,#10h
			   jmp		out6

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
			mov		@r0,#3		;N=3	  ;10-2..10-8
			jmp		labelE

not_10:	
not_1:		mov		@r0,#1				;N=1
			jmp	labelE

rtizmri:	jmp		tizmri
ttout:		setb	bitizm;������� ������ t
					clr		bitt2
					jmp		out6
labelf:	   		
			jnb		bitt2,nofizm
		   mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,ttout;outF
		   mov		r1,#load;parT
		   cjne		@r1,#5,noft1
		   ;t=10s
		   jmp		out6;ft1izm

noft1:	   inc		@r1;dec		@r1
ft1izm:		call	loadT;� ����� 2 �������� ����� � ����� load(parT)
			;call	ind
		jmp		out6;??????????????/

			;��������� ������� �������� ����������
outF:		mov		r0,#chkl
			mov		@r0,#27h
			inc		r0
			mov		@r0,#10h
			jmp		out6;out7

noviR1:		jmp		noviR
outvich:	mov			r0,#vichR
					mov			@r0,#0
					clr			bitvich
					clr			bitvi11
					clr			bitmenu
					setb		bitizm
					mov			r0,#marker
					mov			@r0,#0ffh
					jmp			out6	

nofizm:	 	jnb		bitvich,noviR1
						mov		p3,#0dfh
						jnb		p3.6,outvich;������� ������ ���R
			mov		r0,#vichR
			cjne	@r0,#11h,no11v6
			mov			p3,#0fbh;->
			jb			p3.6,outF
			mov		@r0,#12h		;11= ���������
vvrr6:		mov		dptr,#teIZMK	;	��� �����;teVICH
			call	lotext
			jmp		outF
	
no11v6:		cjne	@r0,#12h,no12v6
			mov		p3,#0fbh;->
			jb		p3.6,outF
			mov		@r0,#13h
			mov		dptr,#teOUT
			call	lotext
			jmp		outF
		
no12v6:		cjne	@r0,#13h,no13v6
						mov		p3,#0fbh;->
			jb		p3.6,outF
			mov		@r0,#11h
			mov		dptr,#teVICH
			call	lotext
			jmp		outF

;�� -> A= 0000
;�� -> B= +00000
no13v6:		mov		p3,#0fbh
			mov		a,p3
			jb		acc.6,chanZ
			mov		a,movrig
			cjne	a,#7,kon_B	
			mov		r0,#marker	;A= 0000
			cjne	@r0,#7,mark0_8		;������ ������ ?
rikn:		mov		a,movleft
			mov		@r0,a				; ��� ������ � �� ����� ���+1
;				29.12.06
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
			   	mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					inc		r1
					mov		savba,@r1
				jmp		outF

kon_B:		mov		r0,#marker	;B= +00000
					cjne	@r0,#8,mark0_8		;������ ������ ?
					jmp		rikn
mark0_8:
;				29.12.06
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	���������� ->B=+00000
					mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					inc		r1
					mov		savba,@r1
			mov		r0,#marker
			inc		@r0		;	�������� ������ ������ �� 1
			clr		bitmig
			cjne	@r0,#9,outma
			dec		r0;ppp
outma:		jmp		outF

chanZ:		mov		p3,#0feh
			mov		a,p3
			jb		acc.6,chanma
			;��� ���� � ������� ������� �� �������������
			mov		a,bufind+3
			cjne		a,#2bh,noplus
			mov			bufind+3,#2dh		;+->-	
			jmp		outF
noplus:
			mov			bufind+3,#2bh		;-/+-
			jmp		outF
chanma:	  	mov		p3,#0fdh
			mov		a,p3
			jb		acc.6,outFl;labelL1
			;clr		bitmig
labelL1:	call	vvchibl;f	;��������� ����� 

outFl:			jmp		outF
		
nor11:		;	�����
		mov		@r0,#13h  ;12->13
		mov		dptr,#teOUT
;		jmp		vi1113

;;;;;;;;;������ -> � ������ ������ ����



rlabelL:	jmp			labelL
;findmem:		jmp		out6
noviR:		jnb			bitmenu,findmem;17.01.07
;;;;;;;;;;;;;
					mov			r0,#vichR
					mov			a,#15h
					clr			c
					subb		a,@r0
					jc			ri21_23

					mov		p3,#0fbh; ��� �� ���� ->
					jb		p3.6,ri6
					mov		r0,#vichR
					cjne	@r0,#15h,norime
					mov		@r0,#11h
norime1:	call		lomenu
ri6:			jmp		out6
norime:		inc		@r0
					jmp		norime1
	
ri21_23:	mov			a,#23h		;->
					clr			c
					subb		a,@r0
					jc			ri_31
					mov			p3,#0fbh
					jb			p3.6,ri6
					cjne		@r0,#23h,no23ri
					mov			@r0,#21h
					call		lomenu
					jmp			out6
no23ri:		inc			@r0
					jmp			norime1
ri_31:		cjne		@r0,#31h,no31ri;->19.2->57.6->19.2
					jnb			bitv19,gosk19
					mov			dptr,#teS57_6;57,6
					call		lotext
					clr			bitv19
					jmp		out6
gosk19:		mov			dptr,#teS19_2
					call		lotext
					setb		bitv19
					jmp			out6



;labelS2:	jmp			out6

no31ri:		mov			a,#52h;42h		;->
					clr			c
					subb		a,@r0
					jc			ri6
					mov			p3,#0fbh			;41,42
					jnb			p3.6,rlabelN	;������ ->(������ 000)
					mov			p3,#0fdh
					jb			p3.6,ri6
					jmp		labelL1					;������ 0..9  (������ 000)
rlabelN:		jmp		labelN
moutF:		jmp		outF
;;;;;;;;;;;;;;;;;;;;;;;;;
rnnmemb:	jmp		nnmemb

nbimenu:
findmem:	jnb		bitmem,rnnmemb
			mov		r1,#level							;-> �� ������ (������� ->������-> ��������)
		   cjne		@r1,#11h,nomem11
		   
		   mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#12h
		   mov		dptr,#teWR	;			������
		   call		lotext
		   jmp		outF

nomem11:   cjne		@r1,#12h,nomem12
			mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#13h
		   mov		dptr,#teLIST		;��������
		   call		lotext
		   jmp		outF
nomem12:	 cjne		@r1,#13h,nomem13
					mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#14h
		   mov		dptr,#teSTAT			;����������
		   call		lotext
		     jmp		outF
			
nomem13:cjne		@r1,#14h,labelL
			mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#11h
		   mov		dptr,#teCLE			;�������
		   call		lotext
		     jmp		outF
labelL:	
			;������->���� 00(level 21->22) 
				mov			r0,#level
				cjne		@r0,#21h,nobl21
				mov			@r0,#22h		;->���� 
				mov			dptr,#teBL
me21_22:call		lotext
			
				call		z_05s;�������� ����� �� ������������ ���� �� ��������� �������
				jmp			outF

nobl21:	cjne		@r0,#22h,nobl22
				mov			dptr,#teFULL
				mov			@r0,#21h		;->������

				jmp			me21_22

;labl21:	   cjne	@r0,#21h,nolev1
;			mov		p3,#0fbh
;			mov		a,p3
;			jb		acc.6,loutF
;			cjne	@r0,#21h,labl22
;			mov		@r0,#22h
			;����
;			call	lotext
;			jmp		outF
;labl22:		mov		@r0,#21h
			;������
;			call	lotext
;			jmp		outF
		 
nobl22:		cjne	@r0,#23h,go31l
rigblo:		mov		p3,#0fbh
					jb		p3.6,llev2
labL2:	  ;  ��� ������ � ������ ������� 
				;	������			->
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
					mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					inc		r1
					mov		savba,@r1
					clr		bitmig
;;;;;;;;;;;;;;;;
		  mov		r0,#marker	;������ ������ 	?
			mov		a,movrig
			clr		c
			subb	a,@r0
			jz	   equ1l
			mov		a,movrig;��� � ������ �������
			mov		@r0,a
			jmp		outF					 
equ1l:		mov		a,movleft;��� � ����� �������
			mov		@r0,a	
loutF:	jmp		outF
		

go31l:		cjne	@r0,#31h,go41l
			jmp		rigblo
go41l:		cjne	@r0,#41h,norig2
			jmp		rigblo

llev2:		mov		p3,#0fdh
			jb		p3.6,loutF
			jmp		labelL1

;->
norig2:	   clr		c		;32,33,34,42
			mov		a,#31h
			subb	a,@r0
			jnc		loutF
rigblok:	mov		p3,#0fbh  ;32,33,34,42
			jb		p3.6,lev2go
labelN:	
			;				29.12.06
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
					mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					inc		r1
					mov		savba,@r1
;;;;;;;;;;;;;;;;;;;
			mov		r0,#marker	;������ ������ 	?
			mov		a,movrig
			clr		c
			subb	a,@r0
			jnz	   noequ1
			mov		a,movleft;��� � ������� ����� �������
			mov		@r0,a
			jmp		outF
noequ1:	;29.12.06
;;;;;;;;;;;;;;;;;;
			;������� ���������� ��� �������
			  ;� � � ����� �� ������ ��������� ������� 20h(������)
			   	mov		r0,#marker
			  	mov		a,#bufind
				add		a,@r0			;a=bufind+marker
				mov		r1,a
				;mov		@r1,savba
				inc		r1
				mov		savba,@r1
;;;;;;;;;;;;;;;;	
			call	marri;��� ����� � ������	�������
			jmp		outF
lev2go:		mov		p3,#0fdh
			jnb		p3.6,rlabelL1
			jmp		outF

rlabelL1:	jmp		labelL1

nnmemb:
				


norim6:	   ;kn menu
out6:		
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
			   mov		EIE2,#30H
			   mov		a,P3IF
				anl		a,#0bfh
				mov		P3IF,a
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
			reti

rknMEM:			jmp		knMEM
knKMP:		   jmp		out7
rout7:			jmp		out7	
rlabelH:		jmp		labelH
rknNUL:		jmp		knNUL
rknleft:		jmp		knleft
keyb2:	;IE7
				mov		EIE2,#00H
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
			  ;������� ���������� ��� �������
			  ;� � � ����� �� ������ ��������� ������� 20h(������)
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
				mov		p3,#0feh		;��� IZM
				mov		a,p3
				jnb		acc.7,rknNUL
				mov		p3,#0fdh
				mov		a,p3
				jnb		acc.7,knKMP
				mov		p3,#0fbh
				mov		a,p3
				jnb		acc.7,rknleft
				mov		p3,#0f7h
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
goto7:			mov		r1,#parT
				mov		r0,#chkl
				cjne	@r1,#1,not1_7
				mov		@r0,#00
				inc		r0
				mov		@r0,#2
				jmp		out7
			

not1_7:			cjne	@r1,#2,not2_7
					mov		@r0,#0eh;00
				inc		r0
				mov		@r0,#38h;20
				jmp		out7
not2_7:		   	mov		@r0,#00
				inc		r0
				mov		@r0,#200
merr:		jmp		out7


knmenu:	jb		bitvi11,merr
				jb		biteizm,menuoff
			 clr		bitizm		;off IZM
				setb		bitmenu
				mov		dptr,#teTESI 	;� ���2 �������� ����-�����
				call	lotext
				
				mov		r0,#vichR
				mov		@r0,#11h
				jmp		onmem11
menuoff:
				mov		r0,#vichR
				mov		@r0,#00
				clr		biteizm
				call	loadus
				jmp		out7
				mov		RSTSRC,#10h
				;jmp		begin;onmem11

rendkalib:		jmp		endkalib

knAVP:	jb		bitklb,rendkalib	
				jb		bitavp,meavp
				setb	bitavp
				jmp		onmem11
meavp:			clr		bitavp
				jmp		onmem11

knleft:	jb		bitklb,lefkl
				;;;;;;;;
			   mov		r1,#diap
				inc		@r1		;������ �������� 1 ��� � ��� ������
				cjne	@r1,#0ah,nodi6
				dec		@r1
lefkl:	jmp		an_t7

nodi6:		   ;	cjne	@r1,#0,an_t7
				 call	 clmassix
				mov		r0,#summa
				call	clear4	
				mov		r0,#rez_A0
				call	clear4	
				call	loadUS
			   jmp		an_t7

knNUL:			jb		bitnul,ybnul
				setb	bitnul
				mov		r0,#rez_A3	;A3
				call	resar2
				mov		r0,#rez_A0	
				call	saver2;A0<-A3
				jmp		goto7;an_t7

ybnul:			clr		bitnul
				 mov	DPTR,#ch0 
				CALL   ldc_long		 ; r2..r5 <-- 0
				mov		r0,#rez_A0	;A0=0
				call	saver2
				jmp		goto7;an_t7

labelH:		  	jnb		bitt2,nolah
				mov		p3,#0fbh   ;���� � ����� ��� �
				anl		bufind+10,#8fh
				mov		r1,#load;parT
				jb		p3.7,rhnot1
				cjne	@r1,#0,inct;
				jmp		out7;hyest6
inct:			dec		@r1			;T���+1
			
			call	loadT	;� �����2 �������� �����  � ����� �	T���
hnot2:		;	call	ind
				jmp		out7

 rhnot1:		jmp		hnot1
 ;rnoviR:	jmp		noviR
 rlabelK:	jmp		labelK
 rlabelI:	jmp		labelI		
 ;;;;;;;;;;;;;;;;;;;
nolah:		jnb		bitvich,rlabelK	
				
			;;;;;;
			;��������� ������� �������� ����������
		;;		mov		r0,#chkl
		;;		mov		@r0,#27h
		;;		inc		r0
		;;		mov		@r0,#10h
			;;;;;;

		   	mov		r0,#vichR
			cjne	@r0,#11h,rhnor11;rlabelI;;
			mov		p3,#0fbh   ;<-
			jb		p3.7,noh37;routF
    		cjne	@r0,#11h,hr12
			mov		@r0,#13h	;11= ���������
			mov		dptr,#teOUT;teVICH
hvi1113:	call	lotext	;� ����� 2 �������� ����� � ����� � ����������
			jmp		goto7;outF
hr12:		cjne	@r0,#12h,hnor12
lovich:		mov		@r0,#11h
			mov		dptr,#teVICH
			jmp		hvi1113		
hnor12:		cjne	@r0,#13h,rhnor11
loizmk:		mov		@r0,#12h
			mov		dptr,#teIZMK	;	��� �����
		    		   
			jmp		hvi1113

rhnor11:		jmp		hnor11

rvvizko:		jmp		vvizko
vioutF:			clr		bitvich
						clr		bitvi11
						jmp		outF
toutF:			jmp	outF

noh37:		mov		p3,#0f7h
			jb		p3.7,toutF;vioutF
			cjne	@r0,#11h,rvvizko
			setb	bitvi11	   ;����� ���� ���������
    	 setb	bitizm
			 anl		bufind+11,#07h
			 orl		bufind+11,#10h;����� ����� 1 ����������
routF:		jmp		out7;goto7;outF



rnoh37:		jmp		noh37

norr11:		cjne	@r0,#12h,norr12
			mov		p3,#0fbh   ;<-
			jb		p3.7,rnoh37;routF
			mov		@r0,#11;12->11
			jmp		lovich

labelI2:		jmp		labelI
norr12:	   	cjne	@r0,#13h,labelI2
			mov		p3,#0fbh   ;<-
			jb		p3.7,rnoh37
			mov		@r0,#12h
			jmp		loizmk
			;;;;
clrvich:		clr		bitvich
			setb	bitizm
			mov		r0,marker
			mov		@r0,#0ffh
			 jmp	goto7;	routF

;rnoh37:		jmp		noh37
 ;���� ��� �����
hnor11:		cjne	@r0,#12h,norr12;clrvich
			 mov		p3,#0fbh   
			jb		p3.7,rnoh37;lovich;;��� ����� <-  ���
			mov		@r0,#11h
			jmp		lovich

vvizko:		mov		r0,#vichR
			mov		a,@r0
		;	cjne	@r0,#12h,clrvich
			cjne	a,#12h,clrvich
			mov		@r0,#21h		;��� �����->U=+0000	(vvod)
			mov		r0,#marker
			mov		@r0,#4;9
			mov		movleft,#4
			mov		movrig,#7
			mov		dptr,#teAequ0
			call	lotext
			
			call	outA
			anl			bufind+11,#0fh
	;	mov		a,bufind+11
	;	anl		a,#0f0h
	;	mov		bufind+11,a
			orl		bufind+11,#40h;��� ����� ����� 7 ����������(a=000.0 v)
			
			jmp		goto7;routF
;hnor13:		jmp		hnor12		
izchi:		cjne	@r0,#21h,tlabelI
;<- ��� ����� ���� �				
		;	 mov		p3,#0fbh   
		;	jnb		p3.7,li21
	;clr		bitmig
			mov		r0,#marker
			dec		@r0
			cjne	@r0,#2,li21
			inc		@r0;marker=3 +/-
li21:		clr		bitmig
			jmp		goto7;outF

tlabelI:	jmp		labelI

;			load    0 1 2 3 4 5		
sootv:		db		6,5,4,3,2,1;parT
;

;������ �� ���� ��� ������ �
hnot1:			mov		p3,#0f7h
				jb		p3.7,routF;out7
				cjne	@r1,#5,nohnot1	;r1=load
				mov		r1,#bufind+10;� ������ 1 ������ 10s
				mov		a,@r1
				anl		a,#8fh
				orl		a,#40h;.6
				mov		@r1,a
				jmp		loadb
				
				
loadB:			mov		r0,#parT
				mov		dptr,#sootv
				mov		r1,#load		
				mov		a,@r1;load
				movc	a,@a+dptr
				mov		@r0,a
				call		loab12	;���������� B1,B2 � ����� � T���   ??????
				 ;r4=b1 r5=b2
				call	iniacp;������������� ���
				call	loadUS
				call	clmassix	
				setb	bitizm
				clr		bitt2

				anl		bufind+10,#8fh
				 clr		c
 			     mov		r0,#parT
				 mov		r1,#parN
			     mov		a,#2
			    subb		a,@r0
			    jnc			loadB2
				mov		@r1,#1;N=1	   ;T>=2
bout7:			jmp		goto7;out7

loadB2:			cjne	@r1,#2,bout7
				mov		@r1,#2;N=2
				jmp		goto7;out7
nohnot2:		;� ������ 1 ������ <=0,1s
				mov		r1,#bufind+10
				mov		a,@r1
				orl		a,#10h;.4
				mov		@r1,a
				call		ind
				jmp		loadB
nohnot1:		cjne	@r1,#4,nohnot2	;���� ������ �  
				mov		r1,#bufind+10;� ������ 1 ������ 1s
				mov		a,@r1
				orl		a,#20h;.5
				mov		@r1,a
				jmp		loadB

;������ ������
knMEM:		 	clr		bitizm		;off IZM
				mov		dptr,#teCLE
				call	lotext	  ;� ���2 �������� �������
				setb	bitmem	   ;������ ������ ������
				anl		bufind+11,#0efh;������ ����� � 1�� ����������
				orl		bufind+11,#01;������ ��������� ������
				call		ind
				mov		r0,#level
				mov		@r0,#11h
onmem11:		mov		r0,#chkl
				mov		@r0,#03
				inc		r0
				mov		@r0,#0e8h		;1000
				jmp		out7;goto7;out7

rnomemk:		jmp		nomemk		;

outkmem:	mov			r0,#level
					mov			@r0,#0
					mov			r0,#vichR
					mov			@r0,#0
					clr			bitmem
					clr			bitvich
					clr			bitvi11
					clr			bitmenu
					setb		bitizm
					mov			r0,#marker
					mov			@r0,#0ffh
					jmp			vvod2_10
					jmp			goto7	
labelK:

;;;;;;;;;;;;
			  jnb		bitmem,rnomemk		;�� ������ (���� � <-)
				mov			p3,#0efh
				jnb			p3.7,outkmem		;������� �� ������ �� ����� ������ ��������� ������
				 mov		r0,#level
			  cjne		@r0,#11h,klev1;nome11
lefmem11:	  mov		p3,#0fbh
			  mov		a,p3
			  jb		acc.7,rkvvod0
			  cjne		@r0,#11h,locle		;<-memory
			  mov		@r0,#14h
lolist:		  mov		dptr,#teSTAT
			  call		lotext		 ;����������
			  jmp	goto7;	outF

rkvvod0:	jmp		kvvod0


locle:		cjne		@r0,#12h,lowr		;<-memory
			  mov		@r0,#11h		   ;�������
loadcle:	  mov		dptr,#teCLE
			  call		lotext
			  jmp		goto7;outF

lowr:			cjne	@r0,#13h,lostat
					mov		@r0,#12h
 lowr1:		mov		dptr,#teWR		  ;������
			call	lotext
			jmp		goto7;outF

lostat:		mov		@r0,#13h
 				mov		dptr,#teLIST		  ;��������
			call	lotext
			jmp		goto7;outF

me_14:cjne		@r0,#14h,klev22
 					mov		@r0,#13h
			mov		dptr,#teLIST		  ;;��������
			call	lotext
			jmp		goto7
 klev1:		 cjne	@r0,#12h,klev2
 			jmp		lefmem11
klev2:		 cjne	@r0,#13h,klev3;11-14   klev22	  ;11-13 ���
 			jmp		lefmem11
klev3:		 cjne	@r0,#14h,klev22;
 			jmp		lefmem11
;<- vvod �� ����� ������ �������
klev22:		cjne	@r0,#21h,klev21
lev220:		mov		p3,#0fbh
			jb		p3.7,kgo23
			cjne	@r0,#21h,kfullr
			mov		@r0,#22h
			mov		dptr,#teBL
			call	lotext
			jmp		goto7;outF
kfullr:		jmp		kfull				
klev21:		cjne	@r0,#22h,klev23
			jmp		lev220

rlabL2:		jmp		labL2
rlabM:		jmp		labM
ques:			jmp		out7
ddoutfr:	jmp		ddoutf

klev23:		 cjne	@r0,#23h,rlabM
			 mov	p3,#0fbh
			 jnb		p3.7,ques;errr labL2
			 mov	p3,#0f7h
			 jb		p3.7,ddoutfr
					;	������� � ����������  
				clr			c
			   mov		a,bufind+7	
				 subb		a,#30h
				 cjne		a,#0,chaibl
				 mov		a,#1			;������ ������ 1..4
chaibl:	 	
					mov		nblok,a
			   
			 ;�������� ���� ������ � ��������� �������
			 ;150h..1000h( 150h+nblok*320h)
				call		adrblok		;dptr-

				mov			r1,#work		;����� �����
				mov			@r1,#03
				inc			r1
				mov			@r1,#20h			;320h

goonoff:
				clr			a
				movx		@dptr,a
				inc			dptr

				mov			r1,#work+1
				call		chminus
				mov		r0,#work
			mov		a,@r0
			jnb		acc.7,goonoff

			 clr	bitmem	;��� ������� ������ 
			 setb	bitizm
			 mov		r0,#marker
			 mov		@r0,#0ffh
				jmp			vvod2_10
			 jmp	goto7

rddoutf:	jmp		ddoutf

;vvod 	����->���� 00		
kgo23:		 mov	p3,#0f7h
			jb		p3.7,rddoutf
			cjne	@r0,#21h,go23no
			;�������� ������ 150..dd0h
			;1� ����
			 mov			dptr,#150h
				mov			r1,#work		;����� �����
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
;2� ����
mov			dptr,#470h
				mov			r1,#work		;����� �����
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

;3� ����
			mov			dptr,#490h
				mov			r1,#work		;����� �����
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
;4� ����
mov			dptr,#0ab0h
				mov			r1,#work		;����� �����
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
			clr		bitmem
			setb	bitizm
				mov		r0,#marker
			 mov		@r0,#0ffh
			jmp			vvod2_10;jmp		goto7

go23no:	   mov		@r0,#23h
					mov			movrig,#8
					mov		movleft,#7
			jmp		loblok;���� 00

kfull:		mov		@r0,#21h
			jmp		gofull
			
					
nomemk:		jmp		labelS			;����� ���� ����
			
nome11:		  mov		p3,#0fbh
			  mov		a,p3
			  jb		acc.7,kvvod0
			  cjne		@r0,#12h,mem12no	
			  mov		@r0,#11h		;�������
			  jmp		 loadcle

mem12no:	;cjne		@r0,#13h,lowr		
			  mov		@r0,#12h		   ;
			  jmp		lowr1			  ;������

kvvod0:		  mov		p3,#0f7h			;knopka vvod
			  jb		p3.7,ddoutf
			  mov		r0,#level
			  cjne		@r0,#11h,mvv11
			  mov		@r0,#21h		;������
gofull:		  mov		dptr,#teFULL
			  call		lotext
				jmp		mlabL2	;<-????????/

ddoutf:		;<- ���� 00(�������)
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
						mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					dec		r1	;	inc		r1
					mov		savba,@r1
					clr		bitmig
;;;;;;;;;;;;;;;;
		  mov		r0,#marker	;������ ����� 	?
			mov		a,movleft
			clr		c
			subb	a,@r0
			jnz	   left21
			mov		a,movrig;��� � ������ �������
			mov		@r0,a

			jmp		goto7						 
left21:		mov		a,movleft;��� � ����� �������
			mov		@r0,a	
			jmp		goto7


mvv11:		  cjne		@r0,#12h,mvv12
				mov		@r0,#31h
loblok:		 	mov		dptr,#teBL0;���� 0
				call	lotext
				mov			a,nblok
				add			a,#30h
				mov			bufind+7,a
				mov		r0,#marker
				mov		@r0,#7
				;mov		movrig,#9
				;mov		movleft,#6
				jmp		goto7;outF
mvv12:	cjne		@r0,#14h,bl_li
				mov			@r0,#61h
				mov		dptr,#teMIN;
				call	lotext
				call	vichmin
				call	z_1s
				jmp		out7;goto7;outF

bl_li:		mov		@r0,#41h		; ���� 00(������ � ��������)
				jmp		loblok



mlabL2:		;jmp		labL2
					;  ��� ������ � ������ ������� 
				;				29.12.06
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
					mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					inc		r1
					mov		savba,@r1
;;;;;;;;;;;;;;;;
		  mov		r0,#marker	;������ ������ 	?
			mov		a,movrig
			clr		c
			subb	a,@r0
			jz	   equ2l
			mov		a,movrig;��� � ������ �������
			mov		@r0,a
;			lool
			jmp		goto7						 
equ2l:		mov		a,movleft;��� � ����� �������
			mov		@r0,a	
			jmp		goto7
		
rnom31:		jmp			nom31
labM:			cjne	@r0,#31h,rnom31
				mov		p3,#0fbh
				jnb		p3.7,mlabL2
			   mov		p3,#0f7h
			   jb		p3.7,ddoutf
			   
			   mov		@r0,#32h			;��� 0000
			   	;	������� � ����������  
blokvv:		clr			c
			   mov		a,bufind+7	
				 subb		a,#30h
				 cjne		a,#0,blokvvc
				 mov		a,#1			;������ ������ 1..4

blokvvc: mov		nblok,a
			   mov		dptr,#teINT;��� 0000c
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
				
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+8
					mov		r7,#4
bloin:				mov		a,@r0
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
				anl			bufind+11,#0f0h;after 5- 0.000c
				orl			bufind+11,#80h
			
				jmp			goto7
innot6:	cjne		@r0,#3,innot3
				anl			bufind+11,#0f0h;after 7- 000.0c
				orl			bufind+11,#20h
				;call		ind
				jmp			out7;goto7
innot3:	clr			c
				mov			a,#3
				subb		a,@r0
				jnc			innot1_2
				anl			bufind+11,#0f0h;after 6- 00.00c
				orl			bufind+11,#40h
				
				jmp			goto7

innot1_2:
				anl			bufind+11,#0fh;0h;0000c
				
				call		ind				
rgoto7:	jmp	   goto7;outF

nom31:		   cjne		@r0,#32h,nom32
				mov		p3,#0fbh
				jb		p3.7,vvinte		;���� ��������;no31n
				
lefcur:		;;�� <- 32 ��� ���� 000
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
						clr		bitmig
						mov		r0,#marker;������ �� <- ��� ����� ���� ��� ���� 000
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					dec		r1;;;;;;;;;;;
					mov		savba,@r1
					
						mov		r0,#marker	;������ �����?
			mov		a,movleft
			clr		c
			subb	a,@r0
			jnz	   noequ2
			mov		a,movrig
			mov		@r0,a;��� � ������� ������ �������
			jmp		goto7
noequ2:		call	marle;�������� ������ �  ���� �� 1�������	
			jmp	   goto7	
								  

;;;;;;;;;;;;;;;;;;
vvinte:		;���� ��������				
no31n:		   mov		p3,#0f7h
				jb		p3.7,rgoto7
				mov		@r0,#33h
				;������� � ���������� ��������� ��������
					mov		r7,#10
				mov		r0,#adec
				call	clearN
				call	upak4			
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				mov		r1,#abin
				mov		r0,#interva+1
				mov		a,@r1
				mov		@r0,a
				dec		r0
				inc		r1
				mov		a,@r1
				mov		@r0,a
				
				mov		r0,#volume			;����� �����
				mov		@r0,#0
				inc		r0
				mov		@r0,#0c7h
				call		adrblok;dptr
				call		save_hl;1� ������ �����
			   mov		r0,#marker
			   mov		@r0,#0ffh
				 setb		bitizm
				 clr		bitmem
vvod2_10: mov		r0,#parT
				 cjne		@r0,#5,no10msv
					mov			dptr,#te10ms
t2msme:		call		lotext
					call		ind
no2msv:   jmp	   goto7;
no10msv:	cjne		@r0,#6,no2msv	
					mov			dptr,#te2ms
				jmp			t2msme



nom32:		 cjne		@r0,#33h,nom33
			 mov		p3,#0fbh
			 jnb		p3.7,lefcur
			 mov		p3,#0f7h
			 jb		p3.7,no2msv;rgoto7
			 ;��������� ����� ������ ����� �����
			 mov	@r0,#34h
INTn:			mov		r7,#10
				mov		r0,#adec
				call	clearN
				call	upak3			
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				call	loadr2			;r2..r5
				call	altof			;r2..r5->int
dgoto7:			 jmp		goto7

rlefcur:		jmp		lefcur

nom33:		cjne		@r0,#34h,labelP
			  mov		p3,#0fbh
			 jnb		p3.7,rlefcur
			 mov		p3,#0f7h
			 jb		p3.7,dgoto7
			 mov		@r0,#35h
			 mov		r0,#marker
			 mov		@r0,#0ffh
			 ;T1<-����� �� ����������
			 		  ;vvod ��� �� 000
			 mov		r0,#chbuf		;������� ������� �������� � ����� � ���������
			 mov		@r0,#30h  
			 clr		bitmem
			 setb		bitizm;;;;	
			jmp	   goto7
vodm11_15:			jmp		vvodm11_15
me11_15de:			jmp		me11_15dec
moutkmem:				jmp		outkmem

;��������� ������ ���� ����
labelS:		jnb			bitmenu,labelP
					mov			p3,#0dfh
					jnb			p3.7,moutkmem
					mov			r0,#vichR
					mov			a,#15h
					clr			c
					subb		a,@r0
					jc			rme21_23
			
					mov			p3,#0fbh
					jb 			p3.7,vodm11_15
					mov			r0,#vichR
					cjne			@r0,#11h,me11_15de;<-
					mov			@r0,#15h
					mov			dptr,#teKALIB
					call		lotext
					jmp			onmem11
menuon:		clr		bitmenu			;off menu
					setb	bitizm

				mov		r0,#vichR
				mov		@r0,#0
				jmp		onmem11

					;;;;;
	
rme21_23:		jmp		me21_23	
			
;����� ���������
labelP:			cjne		@r0,#41h,govvlist
						mov			@r0,#42h
						;	������� � ����������  
					clr			c
			   mov		a,bufind+7	
				 subb		a,#30h
				 cjne		a,#0,chaipr
				 mov		a,#1
chaipr:				 mov		nblok,a
			   mov		dptr,#teCH;������ 000
			   call		lotext
				anl		bufind+11,#0efh;������ ����� � 1�� ����������
			   mov		r0,#marker
			   mov		@r0,#7
			   mov		movrig,#9
			   mov		movleft,#7
					call		z_1s
		   jmp	   goto7;outF
label43:		jmp		label7

rlist_43:			jmp			list_43					
mlabL2r:			jmp			mlabL2
govvlist:			cjne		@r0,#42h,rlist_43
								mov			p3,#0fbh
							jnb			p3.7,mlabL2r;�� <- ������ 000
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
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				call	loadr2			;r2..r5
				mov		a,r5				;���� ����� ��������
				mov		nelem,a
				call	altof			;r2..r5->int
				mov		dptr,#ch_1;
				call	ldc_ltemp			;r8..r11
				call	flsub
				mov		dptr,#ch_4;
				call	ldc_ltemp			;r8..r11
				call	flmul				;(n(����� �������)-1)*4+��� ��� �����
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
				mov			r1,#copy_hl+1;saven_bl+1;���� ����� ����� ��� ���������� ��������
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
				call		reA3_X		;r2..r5/������ ��� �� ����� ��� �� ���������
				mov		dptr,#ch10;
				call	ldc_ltemp
				call	zdiv	
				;;;;;;;;;;;
				call	maform
				;;;;

				;;;;;;;
					mov		r0,#abin
					call	saver2
					mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec
				
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+5
					mov		r7,#7
ch43:				mov		a,@r0
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
					mov		@r0,#2dh
nozzmi43:				mov		r1,#sadiap;diap
					mov		r0,#bufind+8
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
nodi9_43:		add		a,#32h
					mov		@r0,a;
see_l43:			inc		r0
					mov		@r0,#"A";"E";
			;	inc		r0
			;	mov		@r0,#00h ;=feh � ��� �������� ��� ������� ���� ����
			;	inc		r0;		mov		bufind+11
			;	mov		@r0,#0d0h		;bufind+11.4 ����� ����� ������ �����
			orl			bufind+11,#10h
out43:		call		ind
					call		z_1s
					jmp		out7					

				;;;;;;;;	
label7:	mov		r0,#chkl
				mov		@r0,#04;3
				inc		r0
				mov		@r0,#0e8h		;1000
				jmp		out7;
list_43:		cjne	@r0,#43h,noli_43
						mov		p3,#0fbh		;43h <-
						jb		p3.7,vvod43		;vvod
						clr		bitmem
						setb	bitizm
						mov		r0,#marker
						mov		@r0,#0ffh
						jmp		label7;�� �� <- ����� �� ���������

vvod43:			mov		@r0,#44h
						mov		a,nelem;����� ����������� ������ � ����� 
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
					mov		r0,#bufind;��������� ���������
					mov		r7,#10
					mov		a,#20h
cle20:		mov		@r0,a
					inc		r0
					djnz	r7,cle20
					;;;;;;
					mov		dptr,#teCH;������ 000
			   call		lotext
				anl		bufind+11,#0efh;������ ����� � 1�� ����������
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+9
					mov		r7,#3
ch43_42:				mov		a,@r0
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
						mov			@r1,a				;���� ��� ����� ���
					jmp			li42_43;����� �������� ���������� � �����

vvosta:			cjne		@r0,#61h,vvostad
						mov			@r0,#62h
						mov			dptr,#teMAX;
						call		lotext
						call		vichmax
						call		z_1s
						jmp		goto7

vvostad:		;cjne		@r0,#61h
						mov			@r0,#63h
						mov		dptr,#teMid;
						call	lotext
						call		vichmean
						jmp		goto7

rLABELP:		jmp			LABELP
vvodm11_15:	mov			r0,#vichR;vvod
						mov			p3,#0f7h
					jb			p3.7,rLABELP;????
				

					cjne			@r0,#11h,tome21
					mov			@r0,#21h;vvod
					mov			dptr,#teTE11
					call		lotext
					jmp			onmem11

me11_15dec:		dec		@r0				;<-
lokame1:	call		lomenu
					jmp			onmem11

tome21:		cjne			@r0,#12h,tome13
					;��� ���� ����������
					jmp		testrs;??????????
					jmp			onmem11

tome13:		cjne			@r0,#13h,tome14
					mov			@r0,#31h
					
					mov			r2,#50h				;57.6->19.2
					mov			r3,#2ch
					call		re4byte			;28..2bh 3bait-parol,1 bait skor
					mov			a,r8
					cjne		a,#00,skor19
					mov			dptr,#teS57_6;57,6
					call		lotext
					clr			bitv19

					jmp		onmem11
skor19:		mov			dptr,#teS19_2
					call		lotext
					setb		bitv19
	
					jmp			onmem11
					

tome14:		cjne			@r0,#14h,tome15
					setb		bitizm
					mov			r0,#chavt
					mov			@r0,#0
					inc			r0
					mov			@r0,#0
outmenu:	clr			bitmenu
					jmp			out7

goparom:	mov		r0,#vichR		;����� ���� 52
					mov			@r0,#52h			;������ ��� �����
					jmp			goparol
tome15:		jb		bitpar,goparom	
					mov			@r0,#51h;������ 000
					call		lomenu
					mov			r0,#marker
					mov			@r0,#7
					mov			movrig,#9
					mov			movleft,#7
					;setb		bitizm
					jmp			onmem11


me21_23:	mov			r0,#vichR		;<-
					mov			a,#23h
					clr			c
					subb		a,@r0
					jc			labelS1
					mov			p3,#0fbh
					jb 			p3.7,vv21_23
					cjne		@r0,#21h,me21_23dec;-<
					mov			@r0,#23h
					mov			dptr,#teTE7
					call		lotext
					jmp			onmem11
me21_23dec:	
					dec			@r0
					call		lomenu
					jmp			onmem11
onmem12:	jmp		outF	;(ie7)				
						
vv21_23:	mov		p3,#0f7h		;vvod
					jb		p3.7,onmem12
					cjne		@r0,#21h,test22
					;mov			dptr,#tabt11;������� �� 11�
tests:		call		lotpus
					setb		biteizm;��������� ����� ��
					setb		bitizm
					clr			bitmenu;�������� � � �� ����� ��������� ���������	
					jmp			onmem11
test22:		cjne		@r0,#22h,test23
				;	mov			dptr,#tabt9;������� �� 9�
					jmp		tests	
test23:
				;	mov			dptr,#tabt7;������� �� 7�
					jmp		tests	
left_s:		jmp			left_sk
labelS1:	cjne		@r0,#31h,me_41
					mov			p3,#0fbh			;<-
					jnb			p3.7,left_s
					mov			p3,#0f7h
					jb			p3.7,onmem12
					;��������� ������� ������������� �������� � ����

;������ ��� �����(5000h) 1 ��������(ffh)
;� ������ �� ������� ���(0000h)
					mov		r1,#0			;
				mov		r2,#50h
				mov		r3,#00
				call	copyPP
				;������ ��������� �� ����� ���
				;KD=00 01 86 A0	(KD=1)
				;����� *100000 � ������������ � hex ������
				;�������� ������� ���������� � ������� �� �� ��� 
				mov		r1,#2ch
				mov		a,#0;57,6
				jnb		bitv19,spwri
				mov		a,#1;19.6
spwri:	movx	@r1,a
;������� �������� ��� ����� 
				mov		dptr,#5000h
				mov		r7,#0ffh
				call	cle256
;� ������ � ������ ����� ������ ����� (3000h) 
				mov		r7,#0ffh
				mov		r1,#0				;external ram
				mov		dptr,#5000h
				call	wrpage
	
				jb		bitv19,outsko1	;���� �1 � ����� � ������������� ���������
					mov			TH1,#244		;57.6
					jmp			outsko
outsko1:					mov			TH1,#220		;19.6
outsko:		clr		bitmenu
					setb		bitizm
					jmp			out7

rlabels4:		jmp		labels4
rlabelS13:	jmp		labelS13

me_41:		cjne		@r0,#51h,rlabels4
					mov		p3,#0fbh;<-
					jnb		p3.7,rlabelS13
					mov		p3,#0f7h
					jb		p3.7,vvmenu
					;���� ������
				
;	������� � ���������� 
				mov		r7,#14
				mov		r0,#abin
				call	clearN			
				
;������ ������ ����� � ����������(3�����)
;bufind+3..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
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
					mov			r2,#50h				;parol 000x    (5028h )
					mov			r3,#28h
					call		re4byte			;r8..r11(3 bait parol)
jmp			goparol
				mov			a,r8			;�������� ������ � �����������
				cjne		a,adec+7,parerr
				mov			a,r9	
				cjne		a,adec+8,parerr
				mov			a,r10
				cjne		a,adec+9,parerr
				;�����
goparol:	mov		r0,#vichR		;����� ���� 52
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

					mov		r1,#diap
					mov		r0,#bufind+8
					mov		a,@r1
					cjne	a,#8,nodi8k
					mov		@r0,#30h		 ;10-10
					dec		r0
					mov		@r0,#63h;31h
					jmp		nodisk9
nodi8k:				cjne	a,#9,nodisk9
				
					mov		@r0,#31h	   ;10-11
					dec		r0
					mov		@r0,#63h;31h
				

nodisk9:	mov			r0,#marker
					mov			@r0,#1
					mov			movleft,#1
					mov			movrig,#5
					
vvmenu:		jmp		goto7

parerr:		mov			nuerr,#32h
					call		error
					call		ind
					call		z_1s
					clr			bitmenu
					setb		bitizm
					mov			r0,#marker
					mov			@r0,#0ffh
					jmp		goto7

left_sk:		jnb			bitv19,tosk19;<-
					mov			dptr,#teS57_6;57,6
					call		lotext
					clr			bitv19
					jmp		out7
tosk19:		mov			dptr,#teS19_2
					call		lotext
					setb		bitv19
					jmp		out7

labelS13:;<- MENU(������ 000)
	
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
			   	mov		r0,#marker
			  	mov		a,#bufind
					add		a,@r0			;a=bufind+marker
					mov		r1,a
					dec		r1;inc		r1
					mov		savba,@r1
						
						mov		r0,#marker
						dec		@r0				
				clr		bitmig
				mov			a,movleft
				cjne	@r0,#6,onmem13;;������ �� <- ��� ����� ���� ������ 000
				inc		@r0
					jmp		goto7
;;;;;;;

vvkali52:	;������� �������� ��� ����������
					;����� �� ���������� ->Ak  (52h)
					;	������� � ���������� 
				mov		r7,#14
				mov		r0,#abin
				call	clearN			
				
;������ ������ ����� � ����������(3�����)
;bufind+1..bufind+5
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
				mov		r0,#bufind+5;
				mov		r1,#adec+9
				mov		r7,#5;5bait
upav2:		clr		c
				mov		a,@r0
				subb	a,#30h
				mov		@r1,a
				dec		r0
				dec		r1
				djnz	r7,upav2;adec+7..adec+9

				mov		r0,#abin
				mov		r1,#adec			;��         ��
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
					;������ KM�
					setb		bitizm;��� ���������� ��� ����������
					mov			r0,#marker
					mov			@r0,#0ffh
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

nopoint:		mov		p3,#0fbh
				mov		a,p3
				jb		acc.7,nopoin7
labelS3:mov		r0,#marker
				mov		a,movleft
				cjne	a,#3,poina1
				cjne	@r0,#3,nomarl;26
				;mov		@r0,#9
poina2:	mov			a,movrig		;�� <- B=+00000
				mov			@r0,a
				jmp		goto7;	out7

poina1:		cjne	@r0,#4,nomarl;�� <- A= 0000
					jmp		poina2


nomarl:			;				29.12.06
;;;;;;;;;;;;;;;;;;
;���������� �� ������� ����� � �������� ������ ����������
;� � ��������� �� � ������ ��� ������� � ��������� ������
;��� ������ ������� ������� ������ ������������ ����� � ����������� 
;	����������
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
				cjne	@r0,#2,out7;;������ �� <- ��� ����� ���� B=+00000
poin3:	inc		@r0
;����� ���� � =000000 ��������� ��������� �
nopoin7:	   mov		p3,#0f7h
				mov		a,p3
				jb		acc.7,out7
				mov		r0,#vichR
				mov		a,@r0
				cjne	@r0,#21h,no21p7
				mov		@r0,#11h
			;	������� � ����������  ��������� � ��������� ������
			;   ���������
				mov		r7,#14
				mov		r0,#abin
				call	clearN			
				call	upakA
				
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				call	loadr2			;r2..r5
				call	altof			;r2..r5->int
				mov		r0,#konstA
				call	saver2
;26
				mov		r0,#marker
				mov		@r0,#0ffh
				
				mov		dptr,#teVICH;teBequ0
				call	lotext
			;	call		outB
				anl		bufind+11,#0bfh		;������� ����� bufind+7
			;	orl		bufind+11,#80h
				jmp		goto7;out7

poinA:		cjne	@r0,#3,out7;;������ �� <- ��� ����� ���� A= 0000
					jmp		poin3

no21p7:		  	;	������� � ����������  ��������� � ��������� ������
			;   ���������
				mov		r7,#14
				mov		r0,#abin
				call	clearN			
				call	upakB			
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				call	loadr2			;r2..r5
				call	altof			;r2..r5->int
				jnb		bitznB,pozB
				mov		a,r2
				orl		a,#80h
				mov		r2,a			;����-
pozB:		mov		r0,#konstB
				call	saver2

				mov		r1,#marker	 ;B=000000-> ���������
				mov		@r1,#0ffh
				mov		r0,#vichR
				mov		@r0,#11h
			  jmp		lovich	   ;3.01.07���������
				

out7:		   	;mov		IE,#80h
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
				mov		a,P3IF
				anl		a,#7fh
				mov		P3IF,a
				mov		P3,#0c0h
;clr		bitmig
				mov		EIE2,#30H
clr		bitmig
					mov		a,P6	   	;p6.4=0
			anl		a,#0efh
			mov		P6,a
			nop
			nop
				
			mov		a,P6			;p6.4=1	
			orl		a,#10h
			mov		P6,a			    
				reti


				


lomenu:		mov		r0,#vichR
					cjne	@r0,#11h,menu12
					mov		dptr,#teTESI
lome1:			call	lotexT
					ret
menu12:		cjne	@r0,#12h,menu13
					mov		dptr,#teTESR
					jmp		lome1
menu13:		cjne	@r0,#13h,menu14
					mov		dptr,#teSKOR
					jmp		lome1
menu14:		cjne	@r0,#14h,menu15
					mov		dptr,#teAVK
					jmp		lome1
menu15:			cjne	@r0,#15h,menu21
					mov		dptr,#teKALIB
					jmp		lome1

menu21:	cjne	@r0,#21h,menu22
					mov		dptr,#teTE11
					jmp		lome1
menu22:		cjne	@r0,#22h,menu23
					mov		dptr,#teTE9
					jmp		lome1
menu23:		cjne	@r0,#23h,menu31
					mov		dptr,#teTE7
					jmp		lome1
menu31:		cjne	@r0,#31h,menu41
					mov		dptr,#teS57_6
					jmp		lome1

menu41:		
					mov		dptr,#tePAR
					jmp		lome1

yesvi_kr:		jmp			yesvi_km
endkalib:;KD=Ak/A3
					jb			bifl_kt,yesvi_kr;��� ����� ��
					mov			r0,#rez_A3
					call		resar2
				
				call	altof			;->float
					mov			a,r2
					anl			a,#7fh
					mov			r2,a
				call		move28
					mov			r0,#rez_Ak
					call		resar2
					call		fldiv
						
				mov	dptr,#CHtho;100000
				call	ldc_ltemp			;r8..r11=8
				call	flmul
				call	ftol		;r2..r5->hex ����� KD (��� ��� ����� 6���������)

					mov			r0,#koefKD
					call		saver2
					;������ � ���� � ����� ������
			
					mov		r1,#0			;���� ���� �� ����� ���
				mov		r2,#50h
				mov		r3,#00
				call	copyPP
				;������ ��������� �� ����� ���
				call		findext			;r1-����� ���
				mov			r0,#koefKD
					call		resar2
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
				;����� *100000 � ������������ � hex ������
				;�������� ������� ���������� � ������� �� �� ��� 
;������� �������� ��� ����� 
				mov		dptr,#5000h
				mov		r7,#0ffh
				call	cle256
;� ������ � ������ ����� ������ ����� (3000h) 
				mov		r7,#0ffh
				mov		r1,#0				;external ram
				mov		dptr,#5000h
				call	wrpage
;2.2.07
				mov			r1,#diap
				cjne		@r1,#5,fulkalib
				;jb			bifl_kt,yesvi_km;��� ����� ��
				setb		bifl_kt
				;call		loadus
				mov			dptr,#tabt7;������� �� 7�	
			clr		a
			movc	a,@a+dptr				;high byte
			mov		p4,a
			inc		dptr
			clr		a
			movc	a,@a+dptr				;low byte
			mov		p5,a
				jmp		goto7;	out_kali

;;;
fulkalib:
					clr		bitklb
					setb	bitpar			;������ ������� 1 ��� �������
					mov		dptr,#teEND
					call	lotext
					call	ind
out_kali:	call	z_1s
					call	z_1s
					jmp		goto7
yesvi_km:		;��� ����� ��=(10**5/A2)*K7/K5
				mov			r2,#50h			;-11a
				mov			r3,#14h			;k7
				call		rebyte2				;r2..r5- hex
				call		altof			;r2..r5->float
				push		rr2
				push		rr3
				push		rr4
				push		rr5
				mov			r2,#50h			;k5
				mov			r3,#0ch
			call		rebyte2			;r2..r5
				call		altof			;r2..r5->float
				call		move28
				pop			rr5
				pop			rr4
				pop			rr3
				pop			rr2
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
				call	ftol			;r2..r5->hex ����� Km(��� ��� ����� 6���������)
				mov			r0,#koefKD;2�� ��� ������ koefKD
				call		saver2
				;������ � ���� � ����� ������
				mov		r1,#0			;���� ���� �� ����� ���
				mov		r2,#50h
				mov		r3,#00
				call	copyPP
				;������ ��������� �� ����� ���
				mov			r0,#koefKD
				call		resar2
				mov			r1,#2ch			;r1-����� ��� ����� Km
			
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
				;����� *100000 � ������������ � hex ������
				;�������� ������� ���������� � ������� �� �� ��� 
;������� �������� ��� ����� 
				mov		dptr,#5000h
				mov		r7,#0ffh
				call	cle256
;� ������ � ������ ����� ������ ����� (3000h) 
				mov		r7,#0ffh
				mov		r1,#0				;external ram
				mov		dptr,#5000h
				call	wrpage

					clr		bifl_kt
					call	loadus
					jmp		fulkalib

;��� �������� �� �����
;��� r2..r5
vichmean:	
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
meng:			call		adrblok;dptr-��� ������ 1� ����� ����� 
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
						mov		r1,#copy_hl;saven_bl	;��������� dptr 
						mov		a,dph
					  mov		@r1,a
						inc		r1
						mov		a,dpl
						mov		@r1,a
						;;;;;;;;;
						clr		c;������ � ������ �����?
						mov			a,dpl
						subb		a,r7
						mov			r7,a
						jnz			nextmea
						mov			a,dph
						subb		a,r6
						mov			r6,a
						jz			outmea;
						
						;���������� ���������
						;;;;;;;;;;;		
nextmea:		call		loahl_r2	;�� �� ����� ��� ->r2..r5
					call		altof;->float
					call		move28			;r8..r11
					mov			r0,#work
					call		resar2
					call		fladd
					mov			r0,#work
					call		saver2
					mov			r0,#chblok;volume;��� ��������� �����
					inc			@r0
					jmp			meng
outmea:		
					call		loahl_r2	;�� �� ����� ��� ->r2..r5
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
					mov			r0,#chblok;volume;��� ��������� �����...200d
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
				
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+9
					mov		r7,#5
bufmea:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufmea
					mov		r0,#bufind+4
					mov		@r0,#2bh	  
					jnb		znmat,nozmea
					mov		@r0,#2dh
nozmea:		orl		bufind+11,#05h
					ret


loahl_r2:	movx		a,@dptr		;�� �� ����� ��� ->r2..r5
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

;��� �������� �� �� �����
vichmin:	
 					call		resa_hl;save_bl->dptr
										
;� ����� ����� ����� 2�� ���������
					call		min4_hl
					
						mov			r0,#work	;���� ������������� � ����� 1� ��������� ����������� � work
					
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			dptr
					
					mov			r0,#work
					call		resar2
					call		altof;->float;r2..r5
					mov			r0,#work
					call		saver2

					call		min4_hl
					;call		min4_hl

					mov			r0,#copy_hl
					mov			a,dph
					mov			@r0,a
					inc			r0
					mov			a,dpl
					mov			@r0,a
				
					mov			r0,#chblok;volume
					mov			@r0,#0
ming:			call		adrblok;dptr-��� ������ 1� ����� ����� 
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
						mov		r1,#copy_hl;saven_bl	;��������� dptr 
						mov		a,dph
					  mov		@r1,a
						inc		r1
						mov		a,dpl
						mov		@r1,a
						;;;;;;;;;
						clr		c;������ � ������ �����?
						mov			a,dpl
						subb		a,r7
						mov			r7,a
						jnz			nextmin
						mov			a,dph
						subb		a,r6
						mov			r6,a
						jz			outmin;
						
						;���������� ���������
						;;;;;;;;;;;		
nextmin:	mov			r0,#work
					call		resar2
					;call		altof;->float;r2..r5
					call		move28;->r8..r11
					call		loahl_r2		;�� �� ����� ��� ->r2..r5

					call		altof;->float;r2..r5
					
					call		flcmp
					jnc			nomini
					mov			r0,#work;<
					call		saver2;r2..r5
nomini:			mov			r0,#chblok;volume;��� ��������� �����
					inc			@r0
					jmp			ming

outmin:		mov			r0,#work;1�� ��������� �����
					call		resar2
				;	call		altof;->float;r2..r5
					call		move28;->r8..r11
					call		loahl_r2		;�� �� ����� ��� ->r2..r5

					call		altof;->float;r2..r5
					
					call		flcmp
					jnc			minivix
					mov			r0,#work;<
					call		saver2;r2..r5
					;;;;;;;;;

minivix:	mov			r0,#work
					call		resar2

					;call		altof;->float
				
					mov			dptr,#ch_10	 
					call		ldc_ltemp
					call		fldiv
					call		ftol				;->hex
					;;;
					call		maform
					mov			r0,#abin
					call		saver2
;;;;;;;;
					
					mov		r0,#adec
					mov		r1,#abin+3	;hex->10
					call	bindec
				
					mov		r0,#adec+9;���������� � ����� ���������
					mov		r1,#bufind+9
					mov		r7,#5
bufmin:				mov		a,@r0
					add		a,#30h
					mov		@r1,a
					dec		r1
					dec		r0
					djnz	r7,bufmin
					mov		r0,#bufind+4
					mov		@r0,#2bh	  
					jnb		znmat,nozmin
					mov		@r0,#2dh
nozmin:		orl		bufind+11,#05h
					ret



;��� �������� �� �� �����
vichmax:	
					call		resa_hl;save_bl->dptr
					
					
;� ����� ����� ����� 2�� ���������
					call		min4_hl
					
						mov			r0,#work	;���� ������������� � ����� 1� ��������� ����������� � work
					
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			r0
					inc			dptr
					movx		a,@dptr
					mov			@r0,a
					inc			dptr
					
					mov			r0,#work
					call		resar2
					call		altof;->float;r2..r5
					mov			r0,#work
					call		saver2

					call		min4_hl
				;	call		min4_hl

					mov			r0,#copy_hl
					mov			a,dph
					mov			@r0,a
					inc			r0
					mov			a,dpl
					mov			@r0,a
				
					mov			r0,#chblok;volume
					mov			@r0,#0
maxg:			call		adrblok;dptr-��� ������ 1� ����� ����� 
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
						mov		r1,#copy_hl;saven_bl	;��������� dptr 
						mov		a,dph
					  mov		@r1,a
						inc		r1
						mov		a,dpl
						mov		@r1,a
						;;;;;;;;;
						clr		c;������ � ������ �����?
						mov			a,dpl
						subb		a,r7
						mov			r7,a
						jnz			nextmax
						mov			a,dph
						subb		a,r6
						mov			r6,a
						jz			outmax;
						
						;���������� ���������
						;;;;;;;;;;;		
nextmax:	mov			r0,#work
					call		resar2
					;call		altof;->float;r2..r5
					call		move28;->r8..r11
					call		loahl_r2		;�� �� ����� ��� ->r2..r5

					call		altof;->float;r2..r5
					
					call		flcmp
					jc			nomaxi
					mov			r0,#work;>
					call		saver2;r2..r5
nomaxi:			mov			r0,#chblok;volume;��� ��������� �����
					inc			@r0
					jmp			maxg
outmax:		mov			r0,#work;1�� ��������� �����
					call		resar2
				;	call		altof;->float;r2..r5
					call		move28;->r8..r11
					call		loahl_r2		;�� �� ����� ��� ->r2..r5

					call		altof;->float;r2..r5
					
					call		flcmp
					jc			maxvix
					mov			r0,#work;>
					call		saver2;r2..r5
					;;;;;;;;;

maxvix:		jmp		minivix



$include (d:\amp\subr5.asm) 	
$include (d:\amp\sarifm3.asm) 					
$include (d:\amp\floatm.asm)
$include (d:\amp\wriread.asm)
					      
END
						