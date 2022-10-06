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
		call	ind
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


zapadc:     mov R2,#8
sdv:        setb P1.7
            rlc A
		mov P1.6,C
		call tim2
				
		clr P1.7
		call tim2
		djnz R2,sdv
		setb P1.6
		ret

chtadc:     mov R2,#8
sdv1:       setb P1.7
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
write_x1:	clr	c
writeD_x1:
		mov P3.1,c        ;������
            mov P2,A
		setb P3.3
		call z_5
		clr P3.3
		mov P2,#0FFh
		ret

;������ � acc
read_x2:	clr	c  
        	mov P3.1,c        ;������
        	setb P3.2
		setb P3.3
		call z_5
		mov A,P2
		clr P3.3
		clr P3.2
		ret

loop:		call read_x2;x2    ;�������� ����� ����������
		jb ACC.7,loop     ;������� �� ������, ���� ��� �(7)=1
		ret           ;�������, ���� ��� �(7)<>1


;����������� ���� � acc
;����� ����� ���������������� ����� �������� ��������� ������
read:      mov R2,#8
re1:       clr P1.7;P1.2
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
		mov		a,@r0
		mov		r4,a
		inc		r0
		mov		a,@r0
		mov		r5,a
		mov		r3,#0
		mov		r2,#0
		mov		r8,#0;clr			r8
		mov		r9,#0;clr			r9
		call		lcmp
		ret


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
			call		ldc_ltemp
			call		lsub
			mov		a,r5
			mov		@r1,a
			dec		r1
			mov		a,r4
			mov		@r1,a
			ret	 


loadUS:	;���� ���� ���� ��������� �� ������������ ��� �����
			jb		biteizm,yestest
			mov		r1,#diap
			mov		a,@r1
			rl		a;*2
			mov		r4,a			;save a
			mov		dptr,#tabus
			movc		a,@a+dptr
			mov		r2,a			;high byte
			mov		a,p4
			anl		a,#01
			orl		a,r2
			mov		p4,a
			inc		r4
			mov		a,r4
			movc		a,@a+dptr
			mov		r3,a			;low byte
			mov		a,p5
			anl		a,#01
			orl		a,r3
			mov		p5,a
			mov		r1,#parT
			cjne		@r1,#1,bret
			mov		r1,#diap		  ;10s (parT=1)
			mov		a,#5			  ;10-8..10-11 p4.1=1
			clr		c
			subb		a,@r1
			jnc		bret
			mov		a,p4
			orl		a,#02
			mov		p4,a			 ;10-8..10-11 p4.1=1
bret:			call		louizm		;us ���� ��� �� �����
			ret
yestest:
			call		lotpus		;�� ����� ���������
			ret
			
;���� �� ��� ��� 0
;dptr-
lospus:		clr		a
			;movc	a,@a+dptr
			;mov		r2,a			;high byte
			;mov		a,p4
			;anl		a,#01
			;orl		a,r2
			;mov		p4,a
			;inc		dptr
			clr		a
			movc		a,@a+dptr
			mov		r3,a			;low byte
			mov		a,p5
			anl		a,#0bfh;01
			orl		a,r3
			mov		p5,a
			ret

kor0us:		db		80h;18h,2eh		;us ������ ��������� 0

;us ������ ��������� ����
tabus:	   	db		88h,0d6h	 ;10-2
			db		88h,0f6h	 ;10-3
			db		88h,0d6h	 ;10-4
			db		88h,0f6h	 ;10-5
			db		9ah,0d6h	 ;10-6
			db		9ah,0f6h	 ;10-7
			db		0ach,0d6h	 ;10-8
			db		0ach,0f6h	 ;10-9
			db		0c8h,0d6h	 ;10-10
			db		0c8h,0f6h	 ;10-11

tabt11:		db		66h,0e6h;10-11
tabt9:		db		32h,0e6h;10-9
tabt7:		db		18h,0eeh;10-7

 ;�������� ������ � ����� 2 bufind+0..bufind9
;� ��� �� parT (T���)
loadT:		mov		r1,#load;parT
lolevT:		mov		r0,#bufind+0
			mov		r3,#10
			mov		b,#10
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
			anl			bufind+11,#03h		;������� �����
			ret	
;�������� ������ � ����� 2 bufind+0..bufind9			
;dptr-��� ������ ������		
lotext:	   	
			mov		r3,#10
			mov		r0,#bufind+0
lodt:     		clr		a
			movc		a,@a+dptr
			mov		@r0,a
			inc		r0
			inc		dptr
			djnz		r3,lodt
			anl		bufind+11,#03h		;������� �����
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
					  
;�������� 1 ��
z_1ms:     mov R1,#10h     
ss1:       mov R2,#0EDh    
     	    djnz R2, $ 	 
           djnz R1, ss1   
           ret   

;�������� 1�
z_1s:		mov		r5,#01fh 
co2s:		mov 	R6,#0ffh     
z1s:		mov 	R7,#0ffh     
co1s:		djnz 	R7, co1s	
     		djnz 	R6, z1s 
		djnz	r5,co2s
            ret

;�������� 0,1�
z_01s:  	mov		r5,#03h 
co02s:	mov 	R6,#0ffh     
z01s:     	mov 	R7,#0ffh     
	  	djnz 	R7, $	
        	djnz 	R6, z01s 
		djnz	r5,co02s
         	 ret
					  
;�������� 0,5�
z_05s:  	mov		r5,#0dh 
co05s:		mov 	R6,#0ffh     
z05s:     	mov 	R7,#0ffh     
			djnz 	R7, $	
        	djnz 	R6, z05s 
			djnz	r5,co05s
         	ret 		  					 
					 		  
chzap:		db	00,00,07h,0ffh		   
ch0:		db	00,00,00,00
ch10:		db	00,00,00,0ah		        	;10
ch5:		db	00,00,00,05						;5
ch4:		db	00,00,00,04						;4
ch954:		db 00,00,03,0b9h						;954
ch10000:	db 00,00,03h,0e8h						;10000
ch100:		db 00,00,00,64h	;100
ch2:		db	00,00,00,02						
;CH_953:	db 3fh,74h,37h,72h;0,953971
;CH_953:	db 3fh,74h,1ch,71h;0,953558
;CH_953:	db 3fh,74h,02,0d2h;0.953168
ch1:		db  00,00,00,01
ch_mln:		db	49h,74h,24h,00;10*6
ch_1:		db	3fh,80h,00,00	
ch_2:		db	40h,00,00,00;2
ch_4:		db	40h,80h,00,00;4	
ch_5:		db	40h,0a0h,00,00;5
ch_7:		db	40h,0e0h,00,00;7
	
CH_953:		db 3fh,74h,1eh,0dfh		;0,953596
CHtho:		db	47h,0c3h,50h,00;48h,43h,50h,00;30d40 h	-000
KD:			db	3fh,80h,03h,47h;1,0001
CH2tho:		db	48h,43h,50h,00;200000
ch_220:		db  48h,56h,0d8h,00;220000 -035b60 h
ch_200:		db  48h,56h,0d8h,00;200000 -030d40 h
ch_10th:	db  46h,1ch,40h,00;10000-2710h
ch_10:		db	41h,20h,00,00;10d
ch_250:		db	48h,74h,24h,00;250000
chk:		db	00,01,86h,0a0h;
ch320h:		db	00,00,03h,20h;320h=800d
ch150h:		db	00,00,01h,50h;150h
ch_m3:		db	0c0h,40h,00,00;-3


;r1- �� ���� 2� �������� �����
tenmin:		;-10
		clr		c
    	mov		a,@r1
		subb	a,#5;10
		mov		@r1,a
		dec		r1
		mov		a,@r1
		subb	a,#0
		mov		@r1,a
		ret
  ;r0-��������� ����� ������  
clear4:	mov	r7,#4
  		clr		a
cl4:	mov		@r0,a
		inc		r0
		djnz	r7,cl4
		ret	

 ;r0-��������� ����� ������		;R7- 
clearN:	 
		clr		a
cl4N:	mov		@r0,a
		inc		r0
		djnz	r7,cl4N
		ret	

  ;������ ������ ����� � ����������(2�����)
;bufind+8..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
upak2:	mov		r0,#bufind+8;
		mov		r1,#adec+9
		mov		r7,#2;2bait
upa2:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upa2
		ret  


    
 ;bufind+4..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
upak:	mov		r0,#bufind+9;
		mov		r1,#adec+9
		mov		r7,#6
upa:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upa
		ret

 ;������ ������ ����� � ����������(3�����)
;bufind+3..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
upak3:	mov		r0,#bufind+9;
		mov		r1,#adec+9
		mov		r7,#3;3bait
upa1:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upa1
		ret

;���-r2,r3-����� ���� ������ �����
findkoef:
		mov		r1,#diap
		mov		a,@r1
		rl		a			;diap*2(2bait )
		mov		r4,a			;save
		mov		dptr,#diKDw		;����� ������� ������ �������������
		movc	a,@a+dptr			;�� ����
		mov		r2,a
		inc		dptr
		mov		a,r4
		movc	a,@a+dptr
		mov		r3,a			;�� ����
		ret
;r2..r5 � ��� �� ����� ���
findext:
		mov		r1,#diap
		mov		a,@r1
		rl		a			;diap*2(2bait )
		rl		a			;diap*2(2bait )
		mov		r1,a			;r1-����� ������ �������� ���
				ret

;����� ����� ����  ������������� ��������� KD
;(5000h..5027h)
diKDw:	dw		5000h			;10-2
		dw		5004h			;10-3
		dw		5008h			;10-4
		dw		500ch			;10-5
		dw		5010h			;10-6
		dw		5014h			;10-7
		dw		5018h			;10-8
		dw		501ch			;10-9
		dw		5020h			;10-10
		dw		5024h			;10-11
dipar:	dw		5028h			;parol
diKm:	dw		502ch			;Km ��� ����� ���������
chthou:	db	00,01,86h,0a0h	;100.000

move82:	mov	r2,ltemp			;ltemp->r2..r5
		mov	r3,ltemp+1
		mov	r4,ltemp+2
		mov	r5,ltemp+3
		ret
;bufind+4..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
upakA:	mov		r0,#bufind+7;
		mov		r1,#adec+9
		mov		r7,#4
upaa4:	clr		c
		mov		a,@r0
		subb		a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz		r7,upaa4
		ret

;bufind+4..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;��            ��
upakB:	mov		r0,#bufind+8;
		mov		r1,#adec+9
		mov		r7,#5
upab:	clr		c
		mov		a,@r0
		subb		a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz		r7,upab
		clr		bitznB
		mov		a,bufind+3
		cjne		a,#2dh,abret
		setb		bitznB
abret:
		ret
CH_B:	db	;	4bh,18h,96h,80h;989680h=10 **7
		db	4eh,6eh,6ah,0a8h;10**9
CH_500:	db		43h,0fah,00,00;1fah=500
CH_22T:	db 		48h,56h,0d8h,00;46h,0abh,0e0h,00;55f0h=22000
CH_fl:	db	49h,74h,24h,00;47h,0c3h,50h,00;100000



;���������� AD7731		r4=b1 r5=b2
iniacp:	mov		a,#03
		call	write
		mov		a,r4;#80h
		call	write
		mov		a,r5;#04
		call	write
		mov		a,#02
		call	write
		mov		a,#0a1h
		call	write
		mov		a,#74h
		call	write
		jb		p1.5,$;p1.3,$
		mov		a,#02
		call	write
		mov		a,#81h
		call	write
		mov		a,#74h
		call	write
		jb		p1.5,$;p1.3,$
		mov		a,#02
		call	write
		mov		a,#21h
		call	write
		mov		a,#74h
		call	write
		ret


tabB1_2:	db		00,00		 ;B1,B2 � ����� � T���  
			db		60h,00h;40h,04h		;10s
			db		60h,00;40h,04h		;1s
			db		60h,01h;40h,04h		;0,1s
			db		60h,01;00h;20h,04h		;50ms
			db		60h,01;00h;20h,04h		 ;10ms
			db		13h,33h;32h		;2ms

;���� �1,�2 � ����� �� �				
loab12:		mov		r1,#parT
			mov		dptr,#tabB1_2
			mov		a,@r1
			rl		a;*2
			mov		r7,a			;save a
			movc	a,@a+dptr
			mov		r4,a   ;b1
			inc		r7
			mov		a,r7
			movc	a,@a+dptr
			mov		r5,a
		;����� ���� �1,2 ���� ��� ����� ��� ������ �
			ret


loadr2:	mov		r0,#abin+3		;r2..r5
		mov		a,@r0			; �� ��   
		mov		r2,a
		dec		r0
		mov		a,@r0
		mov		r3,a
		dec		r0
		mov		a,@r0
		mov		r4,a
		dec		r0
		mov		a,@r0
		mov		r5,a
		ret
					

 ;�������� KD � ����������� �� ���� ���  
 ;koef->r8..r11
loadKD:	mov		r0,#diap
		mov		a,@r0
		mov		dptr,#diKDn
		mov		b,#4
		mul		ab
		mov		r7,a;save
		movc	a,@a+dptr
		mov		r8,a
		inc		dptr
		mov		a,r7
		movc	a,@a+dptr
		mov		r9,a
		inc		dptr
		mov		a,r7
		movc	a,@a+dptr
		mov		r10,a
		inc		dptr
		mov		a,r7
		movc	a,@a+dptr
		mov		r11,a
		ret

 diKDn:	db		3fh,50h,6bh,7bh;3fh,80h,00,00		;10-2
 		db		3fh,50h,7fh,0cch;3fh,80h,00,00		;10-3
		db		3fh,4fh,9dh,0bh;3fh,80h,00,00		;10-4
 		db		3fh,4fh,0e8h,69h;3fh,80h,00,00		;10-5
 		db		3fh,50h,29h,4ah;3fh,80h,00,00	;4fh,0e9h,11h	;0,81215   10-6
 		db		3fh,50h,63h,9eh;3fh,80h,00,00		;10-7
 		db		3fh,4bh,0c9h,0f0h;3fh,80h,00,00		;10-8
		db		3fh,4ch,06h,3bh;3fh,80h,00,00		;10-9
 		db		3fh,50h,0efh,0ddh;3fh,80h,00,00		;10-10
		db		3fh,51h,2ah,0d9h;3fh,80h,00,00		;10-11

ch57:		db	00,00,00,39h;57
ch20:		db	00,00,00,14h;20

;���� �� ��� ������ ��� 	;dptr-
lotpus:	mov		r0,#vichR
		cjne	@r0,#21h,te22
		mov			dptr,#tabt11;������� �� 11�
lotp:	clr		a
		movc	a,@a+dptr				;high byte
		mov		p4,a
		inc		dptr
		clr		a
		movc	a,@a+dptr				;low byte
		mov		p5,a
		ret
te22:	cjne	@r0,#22h,te23
		mov			dptr,#tabt9;������� �� 9�	
		jmp			lotp
te23:	mov			dptr,#tabt7;������� �� 7�	
		jmp			lotp





Tabn:		db		2,3,4,5,6,7,8,9,10,11		;������� ���������� �������

findR:	mov			r0,#diap
		mov			a,@r0
		mov			dptr,#Tabn
		movc		a,@a+dptr
		ret
;bufind=30h..39h											 ;
vvchif:	clr		bitmig
		mov		r1,#marker
		mov		a,@r1			;��� �����
		mov		r0,#bufind			;0000
		add		a,r0
		mov		r0,a
		inc		@r0
		cjne	@r0,#3ah,chif
		mov		@r0,#30h
		ret
chif:	clr			c
		mov			a,#30h
		subb		a,@r0
		jc			chif5
		mov		@r0,#30h
chif5:	ret

vvnol41:	jmp			vvchif	;��� ������ ���� � ��������� � ����������

vvnol31:	cjne		@r0,#41h,vvnol41
			jmp			chifour
vvnol23:	cjne		@r0,#31h,vvnol31
			jmp			chifour	

vvchibl:	mov			r0,#level
			cjne		@r0,#23h,vvnol23;��� ������ ���� � �����
chifour:	clr		bitmig
			mov		r1,#marker
			mov		a,@r1			;��� �����
			mov		r0,#bufind			;1..4
			add		a,r0
			mov		r0,a
			inc		@r0
			cjne	@r0,#35h,chifb
			mov		@r0,#31h
			jmp		chifb1
chifb:		cjne	@r0,#30h,chifb1
			mov		@r0,#31h
			ret

chifb1:	clr			c
		mov			a,#30h
		subb		a,@r0
		jc			chifl5
		mov		@r0,#30h
chifl5:	ret

  ;������� ������� �����
marle:	
		clr		bitmig
		;mov		savba,#0   ������ ��������
    	mov		r0,#marker
		dec		@r0
   		mov		a,@r0
		clr		c
		subb	a,movleft	  ;������ ����� ���������
		jnc		rler
		inc		@r0
rler:  	ret
    
;������� ������� ������
marri:	clr		bitmig
		mov		r0,#marker
   		inc	    @r0
		mov		a,movrig	   ;������ ������ ���������
		clr		c
		subb		a,@r0
		jnc		rrir
		dec		@r0
rrir:  	ret
    
;konstA->bufind+4..bufind+7
outA:	mov		r0,#konstA
		call		resar2
		call		ftol			;->hex
		mov		r0,#abin
		call		saver2
		mov			r0,#adec
		mov		r1,#abin+3
		call		bindec
		mov			r0,#adec+9
		mov			r1,#bufind+7
		mov			r7,#4
outa2:	mov		a,@r0
		add		a,#30h
		mov		@r1,a
		dec		r1
		dec		r0
		djnz	r7,outa2
		ret
					
;konstB->bufind+4..bufind+8
;outB:	mov			r0,#konstB
;		call		resar2
;		mov			a,r2
;		anl			a,#80h
;		jz			outb3
;		mov		a,r2
;		anl			a,#7fh
;		mov			r2,a
;		mov			bufind+3,#2dh
;outb3:	call		ftol			;->hex
;		mov		r0,#abin
;		call		saver2
;		mov			r0,#adec
;		mov		r1,#abin+3
;		call		bindec
;		mov			r0,#adec+9
;		mov			r1,#bufind+8
;		mov			r7,#5
;outb2:	mov		a,@r0
;		add		a,#30h
;		mov		@r1,a
;		dec		r1
;		dec		r0
;		djnz	r7,outb2
;		ret


;�� ������� ���������
mign:	mov		r0,#marker
		cjne	@r0,#0ffh,mignn
	;��� ��� ������ *
		clr		bitmig
		ret

mignn:	;clr		c
		mov		a,#bufind
		add		a,@r0			;a=bufind+marker
		mov		r1,a
		jb		bitmig,onmig
		mov		savba,@r1
	;	mov		a,@r1
	;	mov		savba,a
		mov		@r1,#" "
		setb	bitmig
		ret

onmig:	mov		@r1,savba
		;mov		a,savba
		; mov		@r1,a
		clr		bitmig
		call	z_01s
		ret
;����� ������ bufind+6
error:	mov		dptr,#teERR
		call	lotext
		mov		bufind+6,nuerr
		ret


textT:		
te2ms:		db		0fdh,"T","=",32h,"m",67h,0fdh,0fdh,0fdh,0fdh ;load=0..5
te10ms:		db		0fdh,"T","=",31h,30h,"m",67h,0fdh,0fdh,0fdh
			db		0fdh,"T","=",35h,30h,"m",67h,0fdh,0fdh,0fdh
			db		0fdh,"T","=",64h,31h,67h,0fdh,0fdh,0fdh,0fdh
			db		" "," "," ","T","=",31h,67h," "," "," "
			db		" "," ","T","=",31h,30h,67h," "," "," "	 
;teNO:		db		0fdh,0fdh,0fdh,"H","E","T",0fdh,0fdh,0fdh,0fdh

teVICH:		db		"B",75h,34h,74h,79h,76h,74h,"T",77h," ";���������
teAequ0:  	db		" ",'U','='," "," "," "," "," "," ",65h
teBequ0:	db		" ",'B','=','+'," "," "," "," "," "," "
teMENU:		db		" "," ",71h,"E","H",72h," "," "," "," "

teTESI:		db	" ","T","E",79h,"T",2dh,74h,33h,71h," ";���� -���    11
teTESR:		db	"T","E",79h,"T"," ","R",35h," "," "," ";���� RS 12
teSKOR:		db	" ",79h,'K',30h,"P"," ","R",35h," "," ";���� 232     13
teAVK:		db	" "," ",'A','B','K'," "," "," "," "," "	 ;A�K		14
teKALIB:	db	" " ,'K','A',76h,74h,73h,"P "," "," "," ";������     15
teTE11:		db		" ",'T',"E",79h,'T'," "," "," ",'T',31h;       21
teTE9:		db		" ",'T',"E",79h,'T'," "," "," ",'T',32h;		22
teTE7:		db		" ",'T',"E",79h,'T'," "," "," ",'T',33h;		23
teS57_6:	db		" "," "," ",35h,37h,36h," "," "," "," ";57.6
teS19_2:	db		" "," "," ",31h,39h,32h," "," "," "," ";19,2

tePAR:  	db		61h,'A',"P",30h,76h,77h," ",30h,30h,30h;������
teKD:		db		" ",30h,30h,30h,30h,30h," "," "," ",'A';00000
teIZMK:		db	74h,33h,71h," ","K",30h,"H",79h,"T"," "
teOUT:		db	" "," ","B",75h,"X",30h,78h," "," "," "	 ;�����
teOLL:		db	" "," ",30h,'L','L'," "," "," "," "," "	 ;OLL
teCLE:		db	" "," ",30h,34h,74h,79h,'T','K','A' ," " ;�������
teMEM:		db	" "," ",30h,'A',71h,79h,'T'," " ; ������
teWR:		db	" "," ",33h,'A',61h,74h,79h,77h," "," ";������
teLIST:		db	" "," ",61h,'P',30h,79h,71h,30h,"T","P ";;��������
teFULL:		db	" "," ",61h,30h,76h,"H",'A',62h," "," ";������
teINT:		db	" ",74h,"H",'T'," ",30h,30h,30h,30h,67h;��� 0000
teBL:		db	" "," ",73h,76h,30h,'K'," "," "," "," ";����
teBL0:		db	" "," ",73h,76h,30h,'K'," ",30h," "," ";���� 0
teCH:		db	30h,'T',79h,34h,"E",'T'," ",30h,30h,31h;������ 001
teSTAT:		db	79h,'T','A','T',74h,79h,'T',74h,'K','A';����������
teMIN:		db	71h,74h,"H"," "," "," "," "," "," "," ";���  00000
teMAX:		db	71h,'A','K',79h," "," "," "," "," "," ";���� 00000
teMID:		db	79h,"P","E",78h," "," "," "," "," "," ";���� 00000

teOLI:		db		" "," ",30h,"L","L"," ","I"," "," "," "
teOLR:		db		" "," ",30h,"L","L"," ",66h," "," "," "
teERR:		db		" "," ","E","R","R"," "," "," "," "," " ;ERR
teEND:		db		" "," ","E","N","D"," "," "," "," "," " ;END

;dptr+4-��������
;dptr-��������
;r7-��� ����  
xCIKLWR:	mov		r7,#4	
lwrx:		movx		a,@dptr
			push		dph
			push		dpl
			inc		dptr
			inc		dptr
			inc		dptr
			inc		dptr
			movx		@dptr,a
			pop		dpl
			pop		dph
			inc		dptr
			djnz		r7,lwrx
			ret
;r2..r5->@dptr..@dptr+3				
saveIr2:	mov		a,r2
			movx	@dptr,a
			inc	dptr
			mov	a,r3
			movx	@dptr,a
			inc		dptr
			mov		a,r4
			movx	@dptr,a
			inc		dptr
			mov		a,r5
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
lwr:		mov	a,@r0
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
form4:  mov a,r5
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
z_9:    mov R3,#4Bh      ;�������� �����
	    djnz R3,$
        ret

;������   ������������ ���� � acc
;�������� ����� ������ ����� �������� ���������  ������
write:	mov R2,#8
		clr  c	
wr1:    clr		p1.7;P1.2
		nop 
		rlc A
		mov P1.6,C;P1.1,C
		call tim2
		setb P1.7;P1.2
        call tim2
		djnz R2,wr1
		clr P1.6;P1.1
		ret

;������ ������ ����� � ����������(2�����)
;bufind+8..bufind+9
;adec..adec+9
;��            ��
upak1:	mov		r0,#bufind+7;
		mov		r1,#adec+9
		clr		c
		mov		a,@r0
		subb	a,#30h
		mov		r7,a
		clr		c
		subb	a,#5
		jc		upk1
		mov		a,#4
		jmp		upk2
upk1:	mov		a,r7
upk2:	mov		@r1,a
		ret  
;r1-�� ���� �������� �����
chminus: clr			c
		mov			a,@r1
		subb		a,#01
		mov			@r1,a;low
		dec			r1
		mov			a,@r1
		subb		a,#00
		mov			@r1,a
		ret


;������ ������ ����� � ����������(4�����)
;bufind+6..bufind+9
;adec..adec+9
;��            ��
upak4:	mov		r0,#bufind+8;
		mov		r1,#adec+9
		mov		r7,#4
upaa:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upaa
		ret

;dptr-��� ������ 1� ����� ����� 
adrblok:	mov		a,nblok
		clr		c
		subb	a,#1
		mov		r5,a
		clr		a
		mov		r4,a
		mov		r3,a
		mov		r2,a
		mov		dptr,#ch320h
		CALL	ldc_ltemp		 ; ltemp <-320
		call	lmul;r2..r5
		mov		a,r5
		add		a,#50h
		mov		dpl,a
		mov		a,r4
		addc	a,#01		
		mov		dph,a			;dptr-
		ret

;
;saven_bl<-dptr  ����� ���� ������ ����� ��� 
save_hl:	mov		a,nblok
		cjne	a,#1,sa_hl1
		mov		r1,#saven_bl
sa_hl:	mov		a,dph
		mov		@r1,a
		inc		r1
		mov		a,dpl
		mov		@r1,a
	;;;;;;;;;�� ����� �� �����
		mov			r1,#volume+1;work+1
		call		chminus
		mov		r0,#volume
		mov		a,@r0
		jnb		acc.7,noendli
		clr			bitbon			;���� ����������
		anl			bufind+11,#0fdh
		call		ind
noendli: ret

sa_hl1:	cjne	a,#2,sa_hl2
		mov		r1,#saven_bl2
		jmp		sa_hl

sa_hl2:	cjne	a,#3,sa_hl3
		mov		r1,#saven_bl3
		jmp		sa_hl
sa_hl3:	mov		r1,#saven_bl4
		jmp		sa_hl

;�������� dptr ���� ����� ��������� ������ ������
resa_hl:
		mov		a,nblok
		cjne	a,#1,re_hl1
		mov		r1,#saven_bl;����1 150h..46fh
re_hl:	mov		a,@r1	
		mov		dph,a
		inc		r1
		mov		a,@r1
		mov		dpl,a
		ret

re_hl1:	cjne	a,#2,re_hl2
		mov		r1,#saven_bl2	;����2 470h..78fh
		jmp		re_hl

re_hl2:	cjne	a,#3,re_hl3
		mov		r1,#saven_bl3	;����3 790h..aafh
		jmp		re_hl

re_hl3:	mov		r1,#saven_bl4	;����4 ab0h..dcfh
		jmp		re_hl
;�������� rez_A3 � ����� �� ����� ���
loA3_X:	mov		r0,#rez_A3
		call	resar2
		mov		a,r2			;
		movx	@dptr,a
		inc		dptr
		mov		a,r3
		movx	@dptr,a
		inc		dptr
		mov		a,r4
		movx	@dptr,a
		inc		dptr
		mov		a,r5
		movx	@dptr,a
		inc		dptr;����� ���� ������ ����� ��� ������
		ret		;� ������ saven_bl
;������ � rez_A3 �� ����� �� ����� ���

reA3_X:	movx	a,@dptr
		mov		r2,a
		inc		dptr
		movx	a,@dptr
		mov		r3,a
		inc		dptr
		movx	a,@dptr
		mov		r4,a
		inc		dptr
		movx	a,@dptr
		mov		r5,a
		inc		dptr
		mov		r0,#rez_A3
		call	saver2
		ret

;�������� �������� ���
;0..ffh ����������� �������� ���� ������������� �������������
;100h..150h ��� ���� ��� ��� ����������� ������� ���������
;150h..46fh 1� ����
;470h..78fh	2� ����
;790h..aaf	3� ����
;ab0h..dcfh 4� ����
;dd0..fffh ��������� �������
;
;���������� � ����� ��� ����������
;����
;�����
;avp
;����
;0,1s
;1s
;10s
;���
;������
;����
