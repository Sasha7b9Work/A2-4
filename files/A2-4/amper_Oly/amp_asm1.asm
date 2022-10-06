   $include (c8051f020.inc)               ; Include register definition file.
	
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

				DSEG

bufind	DATA	2eh;������ ���������
abin		DATA	4fh;4byte
adec		DATA	53h;10byte

TMR2RLL  DATA 0cah;    // TIMER 2 RELOAD LOW                                       */
TMR2RLH  DATA 0cbh;    // TIMER 2 RELOAD HIGH                                      */
		
cellbit		DATA	20h
bitznak			BIT 			cellbit.0			;20.0 �� ��� ������ ��������� ������������� ��������
 
 
 
             rseg     Main          ; Switch to this code segment.

             using    0              ; Specify register bank for the following

org 100h
;$EJECT

begin:	   mov  sp, #0e0h
					mov		PCA0L,#00;=0x00;
					mov	PCA0MD,#00;= 0x00;
					mov	P0MDOUT,#1fh;=0x1f;
					mov	P1MDOUT,#8fh;=0x8f;
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
                       
  	mov	OSCICN,#84h;=0x84;
    mov TMR2RLL,#0;=0;
    mov	TMR2RLH,#0d1h;=0xd1;
  
		setb  TCON.6			;������� ����������
		 setb tcon.4

	mov	RSTSRC,#0;=00	;//��������� ������ 

	//IE=0x00;//10000000	;//������ ���������� ���� ����������
     mov	XBR2,#40h;=0x40;

;ozu
							clr	a
							mov	psw,a
							mov	r0,#20h	
mecle:				mov	@r0,a 			;�������� ��� 256 ����
							inc	r0
							cjne	r0,#7fh,mecle
							mov	r0,#80h
meff:					mov	@r0,a 
							inc	r0
							cjne	r0,#0dfh,meff

;START
;					rez_A0=0;
;	 SUMM=0; //��������� ����������� �������
;	 over_mas=0;
;	 count_mas=0;

//������������� ����������

	  clr P3.4
		call z_100         ;�����
		setb P3.4
   clr P3.3
	 	clr P3.2
  call z_15         ;�������� 15 ��
         ;��������� �������� ������
    mov A,#30h     ;������������� ����������� ����
		call write_x1;x1  ;������� � ������
	call z_15         ;�������� 15 ��
	call write_x1;x1  ;������� � ������
	call z_100        ;�������� 100 ���
         
		call write_x1;x1;������
		call loop            ;�������� ����� BF
    mov A,#38h     ;������������� ����� ��������� ����������� � ��� ������
  	call write_x1;x1 ;������
   	call loop                     ;�������� ����� BF

   	mov A,#06h     ;������������� ����� ��������������� ����������� ������� �����-������� ����� ������ ������� ������� 
   	call write_x1;x1   ;������
		call loop                     ;�������� ����� BF 

    mov A,#02h     ;������ ������ ���������� � ������ DDRAM
		call write_x1;x1    ;������
		call loop                     ;�������� ����� BF
    mov A,#0Ch     ;�������� ���������� �� ������ ���-������, ��� ����������� ��������
		call write_x1;x1       ;������
		call loop                     ;�������� ����� BF
		mov	acc,#01;
		call write_x1;x1;write();//

			mov		r0,#bufind
age1:
			mov		@r0,#21h
			inc		r0
			cjne	r0,#4fh,age1		

age2:		call	ind

					mov R6,#0ffh
					djnz R6,$
          
;������������� ACP
		      jnb P1.5,$
          jb  p1.5,$
          nop
					nop
					call tim
					mov A,#01100100b
					call zapadc   ;������ INSR
					nop
					nop
					call tim
					mov A,#01100000b
					call zapadc     ;������� ���� ��
          mov A,#00100000b
					call zapadc      ;������ ���� ��
					mov A,#00000011b
					call zapadc        ;������ ���� ��
          mov A,#00001100b
					call zapadc     ;������� ���� ��
					mov		DAC1L,#0;
					mov		DAC1H,#8;

;��������� ACP 
			    jnb P1.5,$
         jb P1.5, $
          nop
					nop
					call tim
					mov A,#11000000b ;������ INSR
					call zapadc
					nop
					nop
					call 	tim
					call 	chtadc
					mov 	abin+1,A		;�� ����
					call 	chtadc
        	mov 	abin+2,A
				  call 	chtadc
       	  mov 	abin+3,A		;r2r3r4r5
					nop
					nop
					mov		r0,#abin+1
					mov		a,@r0
					jb		acc.7,znplus;
					setb	bitznak				;-
					
					mov		r7,#3
invers:		mov		a,@r0
					cpl		a
					mov		@r0,a
					inc		r0
					djnz	r7,invers
					jmp		goznak
znplus:		anl		a,#7fh			;+
					mov		@r0,a
goznak:		mov		r0,#adec
					mov		r1,#abin+3
					;call	bindec

;					mov		a,r3
;					jnc		acc.7,minzn
;					anl		a,#7fh
;					clr		bitznak

;minzn:		setb	bitznak
					

					

				
				                  
         
					ajmp age2


				
		

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

tim:      mov R6,#38h
tim1:     djnz R6,tim1
          ret
          
tim2:     mov R6,#14h
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
				 
				   
ret

;�������� 100 ���
z_100:    mov R1,#78h     ;�������� ������� �����
z100:     mov R2,#2h     ;�������� ������� �����
count:    djnz R2, count;��������� R2 � ���������� ����, ���� R2<>0 	
          djnz R1, z100 ;��������� R1 � ���������� ����, ���� R1<>0
          ret           

;�������� 34 ���
z_5:      mov R3,#8Bh      ;�������� �����
ct:       djnz R3,ct
          ret

;�������� 15 ��
z_15:     mov R1,#0FAh    ;�������� ������� �����
z15:      mov R2,#0EDh   ;�������� ������� �����
zz:       djnz R2, zz 	;��������� R2 � ���������� ����, ���� R2<>0
          djnz R1, z15  ;��������� R1 � ���������� ����, ���� R1<>0
          ret   
					  
;;;;;;;;;;;;;;;
ind:    	mov	r0,#2eh
        	call	loop
          mov A,#10000000b  ;��������� ������
					call write_x1
					
M2:		  	call loop
          
					mov A,@R0      ;���������� ���������� R0 � �����������
          setb c         ;��������� �������� ������
					call writeD_x1               ;������
          inc r0
					cjne r0,#3Eh,M2  ;��������� ������������ � ���������� � �������, ���� �� =0  

f5:       call loop               ;�������� ����� BF
  			  mov A,#0C0h        ;��������� ������
        	call write_x1               ;������

  				mov r0,#3Eh      ;�������� ��������
M3:		  	call	loop       ;�������� ����� BF
        	mov A,@R0     ;���������� ���������� R0 � �����������
         	setb	c			;��������� �������� ������ 
					call writeD_x1               ;������
         	inc R0          ;��������� ��������
			
					cjne R0,#4Eh,M3  ;��������� ������������ � ���������� � �������, ���� �� =0
			    ret					



					
$include (e:\amper\sarifm3.asm) 					
					      
END
						