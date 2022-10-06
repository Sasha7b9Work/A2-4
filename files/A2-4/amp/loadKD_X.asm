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
  
bufind	DATA	40h;������ ��������� 12byte	(���� koi � ���� ���� )
;DATA 4ch
abin		DATA	4fh;4byte
adec		DATA	53h;10byte
chmas		DATA	6eh;
mabin		DATA	6fh
reacp		DATA	77h;��������� ������ ��� 4byte int (hex)

  
chkl		DATA	3dh		;������� �������� ���������� 2bait                         
chmasN		DATA	3fh		;n=2,n=10 ������������ n ��������	
	
cellbit		DATA	20h
bitznak		BIT 	cellbit.0	;20.0		
bitmas		BIT 	cellbit.1	;20.1 ��� ���������� �������		
znmat		BIT		cellbit.2	;20.2
bitrs		BIT		cellbit.3	;20.3
bitizm		BIT		cellbit.4	;20.4 ��� ��� ���������
bitavp		BIT		cellbit.5	;20.5  ��� ������ avp
bitvi11		BIT		cellbit.6	;20.6	��� ������ ��� R
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
bitt2		BIT 	cellbit2.0	;22.0 ��� ������� T���2		
bitmenu		BIT 	cellbit2.1	;22.1  ��� ������ ����(������ �� ����)	
bitvi12		BIT		cellbit2.2	;22.2  
bitvi13		BIT		cellbit2.3	;22.3
bitvich		BIT		cellbit2.4	;22.4  	 1-� ������� �� ��� R (����� ��� R)
bitvi21		BIT		cellbit2.5	;22.5    
bitvi31		BIT		cellbit2.6	;22.6	��� ���13	 
;bitnul		BIT		cellbit2.7	;22.7 ��� ������ ����	

	

rez_Ame   data 5eh;	 (���1-AN)*K
rez_A	 data 62h	;��� ����� 100 (10)�������� ���������	 
rez_A1  data 66h	;���1  ������� �� ������� �� 2,10 �� ��������� int (hex)
rez_A0  data 6ah;
rez_A2	 data 7bh; A2

chinkor  data  98h;98..99;80h		;������� ��������� ���������  2byte
chavt	 data  81h		;������� ��������������	 2byte
chdel	 data  83h		; ������� ��������
;float
kor0_AN	 data  84h		;4byte	AN
rezAp	 data  88h		;4byte	A+
rezAm	 data  8ch		;4byte	A-
koefKp	 data  90h		;4byte	K+
koefKm	 data  94h		;4byte 	K-
;hex 
parT	 data  9ah		;�������� ������� ���������
chbefore data  9bh		;������� ���������������� ������������
rez_A3   data  9ch		;A3
;FLOAT
koefKD	data  0a0h	   ;KD
constE	data  0a4h	   ;E
constF	data  0a8h	   ;F
chind	data  0ach	   ;������� ���������
chbuf	data  0adh	   ;������� ������� �������� � ����� � ���������
diap	data  0aeh	   ;����� ���������
parN	data  0afh	   ;N
level	data  0b0h		;������� � ����, ���	,T���
vichR	data  0b1h		;�������� =11,12,13,21
marker  data  0b2h	   ;����� ��������� ����������
;data  0b3h
;������� ��� 64K 
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

	;mov	IE,#80h;//10000000	;//������ ���������� ���� ����������
     mov	XBR2,#40h
	 mov	XBR0,#06h;16h
	mov		SPI0CN,#03
	mov		spi0ckr,#31H;;;;;;;;#04
;ozu
			clr	a
			mov	r0,#00h	
mecle:		mov	@r0,a 			;�������� ��� 256 ����
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
			 ;�������� ���������
			mov		r0,#bufind
age1:
			mov		@r0,#0fdh;" ";0ffh   ;-----
			inc		r0
			cjne	r0,#bufind+11,age1		
			call	ind
		;������ ��� �����(5000h) 1 ��������(ffh)
;� ������ �� ������� ���(0000h)
copyP:		  mov		ie,#00h
				mov		r1,#0			;
				mov		r2,#50h
				mov		r3,#00
				call	copyPP
				;������ ��������� �� ����� ���
				;KD=00 01 86 A0	(KD=1)
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
				jmp		$


;����� ����� �������� ��� ���������������� ��������� KD
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







		
		
		
		

				
		
		



		
 			  
		


;�������� ���� KD � ����������� �� ���������
loadKD:
;;;;;;;;;;;;
 ;;;;;;;;;;;;;;
;r7-���������� ����
;dptr-��� 1-� ������ �������
;
cle256:
			 ; push	rr7						;�������� r7 ����(������ � ������ ff)
							
mm3:		MOV		PSCTL,#02
				
				MOV		PSCTL,#03
				mov		FLSCL,#0a5h
				mov		FLSCL,#0f1h
					
				mov		a,#0ffh
				movx	@dptr,a				;wr
				ret
				
;;;;;;;;;;;;;;
;r7-���������� ����
;dptr-��� ������ ��� ������
;r1-��� ������
wr4bait:
mm5:
			MOV		PSCTL,#03;00				;����������� ��� ������� ������ �����
				
				MOV		PSCTL,#01			;����������� ��� ������� ������ �����
;				mov		FLKEY,#0a5h		;����������� ��� ������� ������ �����
;				mov		FLKEY,#0f1h		;����������� ��� ������� ������ �����
					
			  mov	a,@r1
				movx	@dptr,a				;wr
				inc		dptr
				inc		r1
				djnz	r7,mm5
				ret

;������ ������ �������� � r8..r11
;��-r2,r3-��� �� ������ �����
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
;r7-���������� ����
;dptr-��� ������ ��� ������
;r1-��� ������

wrpage:
WW5:
			mov		IE,#0
			MOV		FLSCL,#01;FLWE(FLSCL.0)����������� ��� ������� ������ �����
				
			MOV		PSCTL,#03;FLWE(PSCTL.1,.0)����������� ��� ������� ������ �����
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
;������ ������ �������� �� ������� ���
;��-r2,r3-��� �� ������ �����
;r1- �� ������� ���
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
						