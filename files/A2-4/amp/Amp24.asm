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
adec		DATA	53h;10byte
chmas		DATA	6eh;������� ��-��� �������� �������
mabin		DATA	6fh
reacp		DATA	77h;��������� ������ ��� 4byte int (hex)
chkl		DATA	3dh		;������� �������� ���������� 2bait                         
chmasN		DATA	3fh		;n=2,n=10 ������������ n ��������	=20(27.12.06)
savba		DATA	3ch;���� ����� ��������� ��� ��������	
movrig      DATA	3bh;������ ������ ���������
movleft     DATA	3ah; ������ ����� ���������                  
nuerr				DATA	39h;����� ������ (��� ����������)		

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
bitmem		BIT		cellbit1.3	;21.3
bmem11		BIT		cellbit1.4	;21.4  	 ��� ���11
bmem12		BIT		cellbit1.5	;21.5    ��� ���12
bmem13		BIT		cellbit1.6	;21.6	��� ���13	 
bitnul		BIT		cellbit1.7	;21.7 ��� ������ ����

cellbit2		DATA	22h
bitt2		BIT 	cellbit2.0	;22.0 ��� ������� T���2	������ ������ �	
bitmenu		BIT 	cellbit2.1	;22.1  ��� ������ ����(������ �� ����)	
bitklb		BIT		cellbit2.2	;22.2  ������� ����������
bitv19		BIT		cellbit2.3	;22.3		��� ��������� ���� ��������� 19.6
bitvich		BIT		cellbit2.4	;22.4  	 1-� ������� �� ��� R (����� ��� R)
biteizm		BIT		cellbit2.5	;22.5   ������� ����� ��������� 
bitvi31		BIT		cellbit2.6	;22.6	��� ���13	 
bitoll		BIT		cellbit2.7	;22.7
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
chbuf	data  0adh	   ;������� ������� �������� � ����� � ���������
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
nblok	data  0c4h	   ;����� �����
Rez_del	data  0c5h	;����� n-�������� /n
rez_R		data	0c9h		;��� ���������� R
;data  0cfh;�������� =11,12,13,21
;data  0d0h

;������� ��� 64K 
;		XSEG AT 100h
	PUBLIC 	  MASS0
MASS0  xdata 0080h;	���������� ������ ���������
MASS1  xdata 0084h;
MASS2  xdata 0088h;
MASS3  xdata 008ch;
MASS4  xdata 0090h;
MASS5  xdata 0094h;
MASS6  xdata 0098h;
MASS7  xdata 009ch;
MASS8  xdata 00a0h;
MASS9  xdata 00a4h;
MASS10  xdata 00a8h;
MASS11  xdata 00ach;
MASS12  xdata 00b0h;
MASS13  xdata 00b4h;
MASS14  xdata 00b8h;
MASS15  xdata 00bch;
MASS16  xdata 00c0h;
MASS17  xdata 00c4h;
MASS18  xdata 00c8h;
MASS19  xdata 00cch;
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
			mov		r0,#chinkor
			mov		@r0,#0;1;
			inc		r0
			mov		@r0,#0c8h;90h;
			;;;;
			mov		r0,#chavt
			mov		@r0,#3;1
			inc		r0
			mov		@r0,#20h;90h

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
;START
;					rez_A0=0;
;	 SUMM=0; //��������� ����������� �������
;	 over_mas=0;
;	 count_mas=0;

			mov		r0,#bufind
age2:
			mov		@r0,#0fdh	  ;�������� ���������
			inc		r0
			cjne	r0,#bufind+12,age2		
			call	ind
			call	z_1s

				;������ ��� �������� ���������
			mov		r0,#bufind
ageon:	  	mov		@r0,#0feh;?
			inc		r0
			cjne	r0,#bufind+12,ageon		
			call	ind
			call	z_1s		;1sec
;;;;;;;;;;;;;;;;
			mov		r0,#bufind
			mov		@r0,#30H;"A"
			inc		r0
			mov		@r0,#30H;"�"
			inc		r0
			mov		@r0,#30H;"�"
			inc		r0
			mov		@r0,#34H;2dh
			inc		r0
			mov		@r0,#35H;"H"
			inc		r0
			mov		@r0,#36h
			inc		r0
			mov		@r0,#37h
			inc		r0
			mov		@r0,#2dh
 			inc		r0
			mov		@r0,#37h
			inc		r0
			mov		@r0,#"A";31h
			inc		r0
		
dd:			call	ind
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
			mov		a,P6	   	;p6.4=0
			anl		a,#0efh
			mov		P6,a
			nop
			nop
				
			mov		a,P6			;p6.4=1	
			orl		a,#10h
			mov		P6,a			    
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
			jb		bitizm,rebyte
			 ;����� 2 ������ �� ���������
;3.11.06
;			mov		r0,#vichR
;						mov		a,@r0
;						cjne	@r0,#21h,poivich
;						mov		a,bufind+7
;						orl		a,#40h
;						mov		bufind+7,a	
;poivich:
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
;			mov		a,chmas
;			mov		@r1,a	;->chmasN
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
			;���/10
			MOV	   DPTR,#ch20;ch10 
			jmp		allsum
			;;;;;;;
			

noparT2:	cjne	@r0,#3,noparT3
			jmp		aapar

noparT3:	cjne	@r0,#4,noparT4
aapar:		mov		r0,#reacp
			call	resar2		;reacp->r2..r5
			mov		r0,#rez_A
			call	saver2
			 mov		r1,#chmasN
			mov		@r1,#10
		;	mov		@r1,#10		;n=10
			jmp		klmas
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

mas20:		mov			dptr,#MASS18
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

nochn10:
						MOV	   DPTR,#ch20 
				CALL   ldc_ltemp		 ; ltemp <-- 20
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
			call		findkoef				;r2,r3-hex
				call		rebyte2				;r2..r5- hex
				
				call	altof			;r2..r5->float
				mov	dptr,#CHtho;100000
				call	ldc_ltemp			;r8..r11
				call	fldiv
				call	move28
			
			mov		r0,#rez_Ame;->r2..r5   ???????????/
			call	resar2
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
			;;call	altof	;r2..r5->float
 			call	flsub
			mov		r0,#koefKp;->r8..r11
			mov		a,r2
			jnb		acc.7,nminus
			;jnb		bitznak,nminus
		
 			mov		r0,#koefKm;->r8..r11
nminus:		call	resar8
			call	flmul  ;��������� � ��������� ������� �.�. ��� ���������?
		
		;;;;;;;;	call	ftol			;float->int
			mov		r0,#rez_Ame
			call	saver2
 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 				mov		r0,#rez_A1
				call	saver2				;��� ����� ��� ���������� ,goA2 �������� � ���� ����
 ;;;;;;;;;;;;;;;;;;;;;;;;;;
afterK:			
;;;;;;;;;;;;;;
				jb		bitklb,goA2
				mov		a,r2
				anl		a,#7fh
				mov		r2,a
				mov	dptr,#ch_250;220;220000
				call	ldc_ltemp			;r8..r11=8
				call	flcmp
				jnc		rmo220		;A>220000
				call		findkoef				;r2,r3-hex
				call		rebyte2				;r2..r5- hex
				
				call	altof			;r2..r5->float
				mov	dptr,#CHtho;100000
				call	ldc_ltemp			;r8..r11=8
				call	fldiv
				call	move28
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
				jnc		rmo220		;A>200000
				jnb		knizm,goA2;		bitizm,goA2	
				jb		bitavp,yesavp	
noavp:			jb		bitvi11,yesvich  ;��� ����� ����� A B (���� ���������)
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
goonin:		   ;jmp		goonind;indA3;8.11.06
				mov		r0,#chind
				cjne	@r0,#0,rnochi0
				jmp		goonind;indA3
;				clr		P3.4
;				nop
;				nop
;				setb	P3.4	  ;??????????????????????/
;				jmp		nop3_0

;				jb		P3.0,nop3_0	;;;;;;;;;;;;;;;;;;;;;;;;;;
;				mov		r0,#rez_A0		;r2..r5->rez_A0
;				call	saver2			;��������� �������� ����
;				jmp		rebyte		;age2
 rmo220:		jmp		mo220
 rnochi0:		jmp		nochi0

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

yesvich:  	;A2=E/A1-+F
				 	mov		r0,#konstB
				call	resar2
				call	move28
				mov		r0,#rez_A1
				call	resar2				;HEX
				
				call		altof			;r2..r5->float
				mov		a,r2			;������
				anl		a,#7fh
				mov		r2,a
				call		fladd				;A1+B
				
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
			  call		lotext		 ;��������
				call		ind
				jmp			nobitizm
mo500I:	mov		dptr,#teOLI
			  call		lotext		 ;��������
				call		ind
				jmp			nobitizm
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
					jmp		nobitizm;	goonin;call	ind
					
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
 	
;;;;;;;;;;;;;;
					 mov		r0,#rez_A3
					call	resar2
				 	call	ftol			;float->int r2..r5
;;;;;;;;
					mov		r0,#rez_A3;->r2..r5	  �������� A3 � ���������
					call	resar2
				
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
					mov		@r0,#0d0h		;bufind+11.4 ����� ����� ������ �����
					
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
 nnnul:				mov		r1,#parT
					cjne	@r1,#3,nsec01
					orl		a,#10h
					jmp		nsec10	 ;0,1s
 nsec01:			cjne	@r1,#2,nsec1
					orl		a,#20h	  ;1s
					jmp		nsec10
nsec1:				cjne	@r1,#1,nsec10
					orl		a,#40h

;;;;;;;;;;;;;;;;
nsec10:				mov		@r0,a
					jnb		bitavp,nobavp
					orl		a,#04		;bufind+10.2
					mov		@r0,a
					mov		@r0,a	
nobavp:			   jnb		knizm,nobitizm
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
					cjne	@r1,#21h,test9i
					mov		@r0,#31h;11A
					dec		r0
					mov		@r0,#63h
					jmp		yesind
test9i:		cjne	@r1,#22h,test7i
					mov		@r0,#39h;09A
					jmp		yesind
test7i:		mov		@r0,#37h;07A
				
;;;;;;;;;
yesind:		
					jnb		bitklb,noklb
					orl		bufind+10,#80h; on kmp
noklb:		call	ind	   ;�� ������ �� ���������
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
					mov		r0,#chbuf	  ;T=1
					cjne	@r0,#0,nobuf0
					jb		bitprd,yesprd	;��������   A3 � �����
					jb		bitbon,yesbuf	;��������   A3 � �����
					jmp		gocikle
rnot1in:		jmp		not1in
yesprd:	;��������   A3 � �����
					jmp		goonT
yesbuf:	;��������   A3 � �����
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
gocikle:	jnb		bitzus,nofz;bitbuf,nofz					
			call	z_05s	 ;0,5c
			call	z_05s	 ;0,5c
			clr	bitzus;bitbuf ��� �������� ������� us
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


;;;;;;;;;;;3.11.06

;;��������� 0
KORnul:		mov		r0,#chdel
			cjne	@r0,#0,nonuldel
				
		;	mov		a,P5	   ;p5.3=1
		;	orl		a,#08
		;	mov		P5,a
		;	nop
		;	nop
				
		;	mov		a,P5		  ;p5.0=0
		;	anl		a,#0feh
		;	mov		P5,a
	
			mov		dptr,#kor0us
			call	lospus		;��� ����� ��������� 0
			jmp		chdelmo

nonuldel:  	;cjne	@r0,#7,no4del
						cjne	@r0,#3,no4del
			;��� ->AN
			mov		r0,#rez_A;->r2..r5
			call	resar2
		;	mov		a,reacp		;r2..r5	&&&&&&&&&&&
		;		mov		r2,a
		;		mov		a,reacp+1
		;		mov		r3,a
		;		mov		a,reacp+2
		;		mov		r4,a
		;		mov		a,reacp+3
		;		mov		r5,a
				;;;;;;;;;;
			call	altof		;r2..r5->float
			mov		r0,#kor0_AN;->kor0_AN
			call	saver2
				
		;	mov		a,P5	   	;p5.0=1
		;	orl		a,#01
		;	mov		P5,a
		;	nop
		;	nop
				
		;	mov		a,P5			;p5.3=0	
		;	anl		a,#0f7h
		;	mov		P5,a			
			call	loadUS 		;������� �������� ��� �����
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
		   
			call	loadus
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



;�� ������ �� ��������� 12 ����   bufind..bufind+11
 ind:	mov		EIE2,#00H;mov	IE,#00h
 		call	mign
 		 mov		r0,#bufind;+11
		 mov		r7,#12
 nexin:	clr		p0.6
		mov		a,@r0
		mov		SPI0DAT,a
		jb		TXBSY,$
		setb	p0.6
		call	z_9	 	;25mks
		inc		r0;dec		r0
		djnz	r7,nexin
		mov		EIE2,#30H;mov	IE,#80h
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

;������ �� acc
write_x1: clr	c
writeD_x1:
		  mov P3.1,c        ;������
          mov P2,A
		  setb P3.3
		  call z_5
		  clr P3.3
		  mov P2,#0FFh
		  ret

;������ � acc
read_x2:  clr	c  
          mov P3.1,c        ;������
          setb P3.2
		  setb P3.3
		call z_5
		  mov A,P2
		  clr P3.3
		  clr P3.2
		  ret


loop:     call read_x2;x2    ;�������� ����� ����������
		  jb ACC.7,loop     ;������� �� ������, ���� ��� �(7)=1
		   ret           ;�������, ���� ��� �(7)<>1
				 
				   



;dptr+4-��������
;dptr-��������
;r7-��� ����  
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
clmassix:	mov			r7,#50h;28h
			mov     dptr,#MASS0        ;������ ������ A ������
clmax:  	mov	     a,#00h
             movx    @dptr,a
             inc     dptr
            djnz		r7,clmax                
             mov     chmas,a
             clr     bitmas
            ret

;r1-��������
;r0-��������
;r7-��� ����  
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
  
;r2..r5 ��������� � ��� ���
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
;r0- ����� _����� ������������ ��������� �����  
;r2,a �������� ����� 2 ����� 
;�_�- @r0 ����������� ���_������ ����� BCD 3 ����� 
;r2 a    ����� 180
;00 b4
;�_�- mabin..mabin+2
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
z_9:      mov R3,#4Bh      ;�������� �����
	       djnz R3,$
          ret

;������   ������������ ���� � acc
;�������� ����� ������ ����� �������� ���������  ������
write:	   mov R2,#8
			clr  c	
wr1:    	clr		p1.7;P1.2
		    nop 
			rlc A
			mov P1.6,C;P1.1,C
		   call tim2
		   setb P1.7;P1.2
           call tim2
		  djnz R2,wr1
		  clr P1.6;P1.1
		 ret

;����������� ���� � acc
;����� ����� ���������������� ����� �������� ��������� ������
read:    mov R2,#8
re1:     clr P1.7;P1.2
         call tim2	  ;5mks
		mov C,P1.4;P1.0
		rlc A		
		setb P1.7;P1.2
		call tim2
		djnz R2,re1
		ret

 ;in r0-count	
;r10,r11-�������� � ������ ������������ �������
;r2..r5 -�������� ��������
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
				jmp		izmpaT
bufon:			clr		bitbon	;��� ��� ����� ����
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
			  ; call		ind
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
labelf:	   		
			jnb		bitt2,nofizm
		   mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,outF
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
nofizm:	 	jnb		bitvich,noviR1
			mov		r0,#vichR
			cjne	@r0,#11h,no11v6
			mov		@r0,#12h		;11= ���������
vvrr6:		mov		dptr,#teIZMK	;	��� �����;teVICH
			call	lotext
			jmp		outF
	
rnor11:		jmp		nor11	
	
nor13:		cjne	@r0,#11h,rnor11
			mov		@r0,#12h
			mov		dptr,#teIZMK	;	��� �����
		    call	lotext		   
			jmp		outF

no11v6:		cjne	@r0,#12h,no12v6
			mov		@r0,#13h
			mov		dptr,#teOUT
			call	lotext
			jmp		outF
		
no12v6:		cjne	@r0,#13h,no13v6
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
labelL1:	call	vvchif	;��������� ����� 

outFl:			jmp		outF
		
nor11:		;	�����
		mov		@r0,#13h  ;12->13
		mov		dptr,#teOUT
;		jmp		vi1113

;;;;;;;;;������ -> � ������ ������ ����

yesviR:		clr		bitvi11;????????/
			jb		bmem11,rlabelL
			jmp		out6;???????//

rlabelL:	jmp			labelL

noviR:	;	jb			bitmenu,;15.01.07
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
nbimenu:	jnb		bitmem,rnnmemb
			mov		r1,#level
		   cjne		@r1,#11h,nomem11
		   
		   mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#12h
		   mov		dptr,#teWR
		   call		lotext
		   jmp		outF

nomem11:   cjne		@r1,#12h,nomem12
			mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#13h
		   mov		dptr,#teLIST
		   call		lotext
		   jmp		outF
nomem12:	 cjne		@r1,#13h,labelL
			mov		p3,#0fbh
		   mov		a,p3
		   jb		acc.6,moutF
		   mov		@r1,#11h
		   mov		dptr,#teCLE
		   call		lotext
		     jmp		outF

labelL:		mov		r0,#level
			cjne	@r0,#21h,labl21
			mov		p3,#0fbh
			mov		a,p3
			jb		acc.6,loutF
			cjne	@r0,#21h,lal22
			mov		@r0,#22h
			;����
			call	lotext
			jmp		outF
lal22:		mov		@r0,#21h
			;������
			call	lotext
loutf:		jmp		outF

labl21:	   cjne	@r0,#21h,nolev1
			mov		p3,#0fbh
			mov		a,p3
			jb		acc.6,loutF
			cjne	@r0,#21h,labl22
			mov		@r0,#22h
			;����
			call	lotext
			jmp		outF
labl22:		mov		@r0,#21h
			;������
			call	lotext
			jmp		outF
		 
nolev1:		cjne	@r0,#23h,go31l
rigblo:		mov		p3,#0fbh
			jb		p3.6,llev2
labL2:	  ;  ��� ������ � ������ ������� 
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
			jz	   equ1l
			mov		a,movrig;��� � ������ �������
			mov		@r0,a
			jmp		outF;goto7						 
equ1l:		mov		a,movleft;��� � ����� �������
			mov		@r0,a	
			jmp		outF;goto7
		

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
				jmp		out7


knmenu:	jb		biteizm,menuoff
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
toutF:			jmp	toutF

noh37:		mov		p3,#0f7h
			jb		p3.7,toutF
			cjne	@r0,#11h,rvvizko
			setb	bitvi11	   ;����� ���� ���������
    	 setb	bitizm
routF:		jmp		goto7;outF



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
			mov		@r0,#21h		;��� �����->a=+0000	(vvod)
			mov		r0,#marker
			mov		@r0,#4;9
			mov		movleft,#4
			mov		movrig,#7
			mov		dptr,#teAequ0
			call	lotext
			
			call	outA
			orl		bufind+11,#08h;��� ����� ����� 7 ����������(a=000.0 v)
			
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
				mov		r0,#level
				mov		@r0,#11h
onmem11:		mov		r0,#chkl
				mov		@r0,#03
				inc		r0
				mov		@r0,#0e8h		;1000
				jmp		out7;goto7;out7

rnomemk:		jmp		nomemk		;
labelK:

;;;;;;;;;;;;
			  jnb		bitmem,rnomemk
			  mov		r0,#level
			  cjne		@r0,#11h,klev1;nome11
lefmem11:	  mov		p3,#0fbh
			  mov		a,p3
			  jb		acc.7,rkvvod0
			  cjne		@r0,#11h,locle		;<-memory
			  mov		@r0,#13h
lolist:		  mov		dptr,#teLIST
			  call		lotext		 ;��������
			  jmp	goto7;	outF

rkvvod0:	jmp		kvvod0


locle:		cjne		@r0,#12h,lowr		;<-memory
			  mov		@r0,#11h		   ;�������
loadcle:	  mov		dptr,#teCLE
			  call		lotext
			  jmp		goto7;outF
 lowr:		mov		@r0,#12h
 lowr1:		mov		dptr,#teWR		  ;������
			call	lotext
			jmp		goto7;outF
 klev1:		 cjne	@r0,#12h,klev2
 			jmp		lefmem11
klev2:		 cjne	@r0,#13h,klev22	  ;11-13 ���
 			jmp		lefmem11

;<- vvod �� ����� ������ �������
klev22:		cjne	@r0,#21h,klev21
lev220:		mov		p3,#0fbh
			jb		p3.7,kgo23
			cjne	@r0,#21h,kfull
			mov		@r0,#22h
			mov		dptr,#teBL
			call	lotext
			jmp		goto7;outF
				
klev21:		cjne	@r0,#22h,klev23
			jmp		lev220

rlabL2:		jmp		labL2
rlabM:		jmp		labM

klev23:		 cjne	@r0,#23h,rlabM
			 mov	p3,#0fbh
			 jb		p3.7,rlabL2
			 mov	p3,#0f7h
			 jb		p3.7,ddoutf
			 ;�������� ���� ������ � ��������� �������
			 clr	bitmem	;��� ������� ������ 
			 setb	bitizm
			 jmp	goto7;outF
			
kgo23:		 mov	p3,#0f7h
			jb		p3.7,ddoutf
			cjne	@r0,#21h,go23no
			;�������� ������
			clr		bitmem
			setb	bitizm
			jmp		goto7;outF

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

kvvod0:		  mov		p3,#0f7h
			  jb		p3.7,ddoutf
			  mov		r0,#level
			  cjne		@r0,#11h,mvv11
			  mov		@r0,#21h		;������
gofull:		  mov		dptr,#teFULL
			  call		lotext
ddoutf:		jmp		mlabL2	;<-

jmp		goto7

mvv11:		  cjne		@r0,#12h,mvv12
				mov		@r0,#31h
loblok:		  	mov		dptr,#teBLOK;���� 00
				call	lotext
				mov		r0,#marker
				mov		@r0,#7
				mov		movrig,#8
				mov		movleft,#7
				jmp		goto7;outF
mvv12:			mov		@r0,#41h		; ���� 00
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
		

labM:			cjne	@r0,#31h,nom31
				mov		p3,#0fbh
				jnb		p3.7,mlabL2
			   mov		p3,#0f7h
			   jb		p3.7,ddoutf
			   
			   mov		@r0,#32h
			   	;	������� � ����������  
				mov		r7,#10
				mov		r0,#adec
				call	clearN
				call	upak2			
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				;call	loadr2			;r2..r5
				;call	altof			;r2..r5->int
			   mov		r0,#nblok	;   ���������
			   mov		a,abin		;;��
			   mov		@r0,a
			   mov		dptr,#tebBL;��� ���� 000
			   call		lotext
			   mov		r0,#marker
			   mov		@r0,#7
			   mov		movrig,#9
			   mov		movleft,#7
rgoto7:		   jmp	   goto7;outF

nom31:		   cjne		@r0,#32h,nom32
				mov		p3,#0fbh
				jb		p3.7,no31n
				
lefcur:		mov		r0,#marker	;������ �����?
			mov		a,movleft
			clr		c
			subb	a,@r0
			jnz	   noequ2
			mov		a,movrig
			mov		@r0,a;��� � ������� ������ �������
			jmp		goto7
noequ2:		call	marle;�������� ������ �  ���� �� 1�������	
			jmp	   goto7
				
no31n:		   mov		p3,#0f7h
				jb		p3.7,rgoto7
				mov		@r0,#33h
				;��������� ����� ������ �����
					mov		r7,#10
				mov		r0,#adec
				call	clearN
				call	upak3			
				mov		r0,#abin
				mov		r1,#adec			;��         ��
				call	decbin			;abin..abin+3 (hex)
				call	loadr2			;r2..r5
				call	altof			;r2..r5->int

				 mov		dptr,#teeBL;��� ���� 000
			   call		lotext
			   mov		r0,#marker
			   mov		@r0,#7
			   mov		movrig,#9
			   mov		movleft,#7
			   jmp	   goto7;


nom32:		 cjne		@r0,#33h,nom33
			 mov		p3,#0fbh
			 jnb		p3.7,lefcur
			 mov		p3,#0f7h
			 jb		p3.7,rgoto7
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

nom33:		cjne		@r0,#34h,labelP
			  mov		p3,#0fbh
			 jnb		p3.7,lefcur
			 mov		p3,#0f7h
			 jb		p3.7,dgoto7
			 mov		@r0,#0ffh
			 ;T1<-����� �� ����������
			 clr		bitmem		  ;vvod ��� �� 000
			 setb		bitizm
			 	
			jmp	   goto7

;��������� ������ ���� ����
labelS:		jnb			bitmenu,labelP
					mov			r0,#vichR
					mov			a,#15h
					clr			c
					subb		a,@r0
					jc			rme21_23
			
					mov			p3,#0fbh
					jb 			p3.7,vvodm11_15
					mov			r0,#vichR
					cjne			@r0,#11h,me11_15dec;<-
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

labelP:
label7:	mov		r0,#chkl
				mov		@r0,#04;3
				inc		r0
				mov		@r0,#0e8h		;1000
				jmp		out7;

vvodm11_15:	mov			r0,#vichR;vvod
						mov			p3,#0f7h
					jb			p3.7,LABELP;????
				

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

tome15:		mov			@r0,#51h;������ 000
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

				mov			a,r8			;�������� ������ � �����������
				cjne		a,adec+7,parerr
				mov			a,r9	
				cjne		a,adec+8,parerr
				mov			a,r10
				cjne		a,adec+9,parerr
				;�����
					mov		r0,#vichR		;����� ���� 52
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
					inc		r1
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
				mov		r0,#rez_Ak
				call	saver2
					clr			bitmenu
					setb		bitklb
					;������ KM�
					setb		bitizm;��� ���������� ��� ����������
					mov			r0,#marker
					mov			@r0,#0ffh
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
				mov		@r0,#31h
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
				mov		@r0,#3
				mov		movrig,#8
				mov		movleft,#3
				mov		dptr,#teBequ0
				call	lotext
				call		outB
				anl		bufind+11,#0f7h		;������� ����� bufind+7
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

;
;goprogr:	jmp	izm
;���� ����������
testrs:	;jb	p0.3,goprogr
				clr	IE.4
test1:	mov	SBUF0,#55h
				jnb	SCON0.1,$
				mov	r0,#work;chtest
				mov	@r0,#190d;60

test01:	jnb	SCON0.0,test2
				mov	a,SBUF0
				cjne	a,#55h,test3
test4:	clr	SCON0.1
				clr	SCON0.0
				mov	r5,#10
				mov	r0,#bufind		;- - - -
test04:	mov	@r0,#2dh
				inc	r0
				djnz	r5,test04
;				;call	wwind
				jmp	test1
test3:	
				mov	nuerr,#33h
				call	error		;�� ����� ������� ERR 3
			
				call	ind;
				call	z_01s 		;100ms
				jmp	test4
test2:	mov	r0,#work;chtest
				cjne	@r0,#0,test02
				jmp	test5
test02:	dec	@r0
				jmp	test01
test5:	call	z_1ms		;1ms
				clr	SCON0.1
	
				mov	nuerr,#33h
				call	error		;�� ����� ������� ERR 3
				
				call	ind
				call	z_01s		;100ms
				jmp	test1	



endkalib:;KD=Ak/A3
					mov			r0,#rez_A3
					call		resar8
					mov			r0,#rez_Ak
					call		resar2
					call		fldiv
						
				mov	dptr,#CHtho;100000
				call	ldc_ltemp			;r8..r11=8
				call	flmul
				call	ftol		;r2..r5->float

					mov			r0,#koefKD
					call		saver2
					;������ � ���� � ����� ������
					clr		bitklb
					mov		dptr,#teEND
					call	lotext
					call	ind
					call	z_1s
					call	z_1s
					jmp		outF

$include (d:\amp\subr3.asm) 	
$include (d:\amp\sarifm3.asm) 					
$include (d:\amp\floatm.asm)
$include (d:\amp\wriread.asm)
					      
END
						