loadUS:	;���� ���� ���� ��������� �� ������������ ��� �����
				;jb		biteizm,yestest
					mov		r1,#diap
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
			anl		a,#01
			orl		a,r3
			mov		p5,a
			mov		r1,#parT
			cjne	@r1,#1,bret
			mov		r1,#diap		  ;10s (parT=1)
			mov		a,#5			  ;10-8..10-11 p4.1=1
			clr		c
			subb	a,@r1
			jnc		bret
			mov		a,p4
			orl		a,#02
			mov		p4,a			 ;10-8..10-11 p4.1=1
bret:	   call		 louizm		;us ���� ��� �� �����
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
			movc	a,@a+dptr
			mov		r3,a			;low byte
			mov		a,p5
			anl		a,#0bfh;01
			orl		a,r3
			mov		p5,a
			ret

kor0us:		db		80h;18h,2eh		;us ������ ��������� 0

;us ������ ��������� ����
tabus:	   db		88h,0d6h	 ;10-2
			db      88h,0f6h	 ;10-3
			db		88h,0d6h	 ;10-4
			db		88h,0f6h	 ;10-5
			db      9ah,0d6h	 ;10-6
			db		9ah,0f6h	 ;10-7
			db		0ach,0d6h	 ;10-8
			db      0ach,0f6h	 ;10-9
			db		0c8h,0d6h	 ;10-10
			db		0c8h,0f6h	 ;10-11

tabt11:	
			db		66h,0e6h;10-11
tabt9:	
			db		32h,0e6h;10-9
tabt7:	
			db		18h,0eeh;10-7

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
			ret	
;�������� ������ � ����� 2 bufind+0..bufind9			
;dptr-��� ������ ������		
lotext:	   	
			mov		r3,#10
			mov		r0,#bufind+0
lodt:     	clr		a
			movc	a,@a+dptr
			mov		@r0,a
			inc		r0
			inc		dptr
			djnz	r3,lodt
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

 ;????????
;�������� 1�
z_1s:   mov		r5,#01fh 
co2s:	mov 	R6,#0ffh     
z1s:     mov 	R7,#0ffh     
co1s:   djnz 	R7, co1s	
        djnz 	R6, z1s 
		djnz	r5,co2s
          ret
;�������� 0,1�
z_01s:  	 mov		r5,#03h 
co02s:		mov 	R6,#0ffh     
z01s:     	mov 	R7,#0ffh     
		  	djnz 	R7, $	
        	djnz 	R6, z01s 
			djnz	r5,co02s
         	 ret 		  
chzap:	db	00,00,07h,0ffh		   
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
KD:		db	3fh,80h,03h,47h;1,0001
CH2tho:	db	48h,43h,50h,00;200000
ch_220:	db  48h,56h,0d8h,00;220000 -035b60 h
ch_200:	db  48h,56h,0d8h,00;200000 -030d40 h
ch_10th:db  46h,1ch,40h,00;10000-2710h
ch_10:	db	41h,20h,00,00;10d
ch_250:	db	48h,74h,24h,00;250000
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
  clear4:	 mov	r7,#4
  			clr		a
  cl4:		mov		@r0,a
			inc		r0
			djnz	r7,cl4
			ret	

 ;r0-��������� ����� ������ 
 ;R7- 
  clearN:	 
  			clr		a
  cl4N:		mov		@r0,a
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
				rl		a							;diap*2(2bait )
				mov		r4,a					;save
				mov		dptr,#diKDw		;����� ������� ������ �������������
				
				movc	a,@a+dptr			;�� ����
				mov		r2,a
				inc		dptr
				mov		a,r4
				movc	a,@a+dptr
				mov		r3,a			;�� ����
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

chthou:	db	00,01,86h,0a0h	;100.000

move82:		mov	r2,ltemp			;ltemp->r2..r5
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
upaa:	clr		c
		mov		a,@r0
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upaa
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
		subb	a,#30h
		mov		@r1,a
		dec		r0
		dec		r1
		djnz	r7,upab
		clr			bitznB
		mov		a,bufind+3
		cjne		a,#2dh,abret
		setb		bitznB
abret:
		ret
CH_B:			db	;	4bh,18h,96h,80h;989680h=10 **7
					db	4eh,6eh,6ah,0a8h;10**9
CH_500:		db		43h,0fah,00,00;1fah=500
CH_22T:		db 		48h,56h,0d8h,00;46h,0abh,0e0h,00;55f0h=22000
CH_fl:	db	49h,74h,24h,00;47h,0c3h,50h,00;100000



;���������� AD7731
;r4=b1 r5=b2
iniacp:	;���������� AD7731
			mov		a,#03

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
			;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
tabB1_2:		db		00,00		 ;B1,B2 � ����� � T���  
				db		60h,00h;40h,04h		;10s
				db		60h,00;40h,04h		;1s
				db		40h,04h		;0,1s
				db		20h,04h		;50ms
				db		20h,04h		 ;10ms
				db		13h,32h		;2ms

;���� �1,�2 � ����� �� �				
loab12:			mov		r1,#parT
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
					
 ;;;;;;;;;;;;;;;;;;;      
 ;�������� KD � ����������� �� ���� ���  
 ;koef->r8..r11
loadKD:			mov		r0,#diap
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

 diKDn:			db		3fh,50h,6bh,7bh;3fh,80h,00,00		;10-2
 				db		3fh,50h,7fh,0cch;3fh,80h,00,00		;10-3
				db		3fh,4fh,9dh,0bh;3fh,80h,00,00		;10-4
 				db		3fh,4fh,0e8h,69h;3fh,80h,00,00		;10-5
 				db		3fh,50h,29h,4ah;3fh,80h,00,00;4fh,0e9h,11h	;0,81215   10-6
 				 db		3fh,50h,63h,9eh;3fh,80h,00,00		;10-7
 				db		3fh,4bh,0c9h,0f0h;3fh,80h,00,00		;10-8
				db		3fh,4ch,06h,3bh;3fh,80h,00,00		;10-9
 				db		3fh,50h,0efh,0ddh;3fh,80h,00,00		;10-10
				db		3fh,51h,2ah,0d9h;3fh,80h,00,00		;10-11

ch57:	db	00,00,00,39h;57
ch20:	db	00,00,00,14h;20

;���� �� ��� ������ ��� 
;dptr-
lotpus:	mov		r0,#vichR
				cjne	@r0,#21h,te22
				mov			dptr,#tabt11;������� �� 11�
lotp:		clr		a
			movc	a,@a+dptr				;high byte
			mov		p4,a
			inc		dptr
			clr		a
			movc	a,@a+dptr				;low byte
			mov		p5,a
			ret
te22:			cjne	@r0,#22h,te23
			mov			dptr,#tabt9;������� �� 9�	
			jmp			lotp

te23:	mov			dptr,#tabt7;������� �� 7�	
			jmp			lotp





Tabn:		db		2,3,4,5,6,7,8,9,10,11				;������� ���������� �������

findR:			mov			r0,#diap
						mov			a,@r0
						mov			dptr,#Tabn
						movc		a,@a+dptr
						ret