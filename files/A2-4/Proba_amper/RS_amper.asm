	������ ������� ( �� �� � ������� )
��  ��  cmd  lng bytes  ...  ks
	answer 
��  ��  code  lng bytes<=255  ...  ks

1-� ���.�������: ����� ����� 4 �������� ��������� ����=����������� ��������� ? ���� �.���� ��� ������ ����������

1	�0	����.���					bitavp	BIT	cellbit.5
	�1	���.���

2	Q0	��������� 0					bitnul	BIT	cellbit1.7

3	B0	����.������ ���-���
	B1	���.������ ���-���
	B2	������ �����

4	T0	����� ������������ ���������	10 �		parT	 data  9ah		����. 0-6
	T1					1 �
	T2	0.1
	T3	50 ��
	T4	10 ��
	T5	2 ��

5	H0	����������	4 �������			parN	data  0afh		����.1,2,3
	H1			5
	H2			6

6	R0	����.����� ���������� R				bitvi11	BIT	cellbit.6
	R1	���.����� ���������� R
	R2	������ ��������� ���������� R			konstA	data  0bch	����.1-1000

7	M0	�������� ������ N				
	M1	������ �������� �������, ������� � ������� ????
	M2	���.���������� �������
	M3	����.
	M4	������ � RS array N
	M5	������ ������ ������ ������, �����

8	I0	��������� ����.
	I1	��������� ���.






	SUBR7.asm
testrs:	;jb	p0.3,goprogr
		clr	IE.4


;������ ������ �������� � r8..r11
;��-r2,r3-��� �� ������ �����
re4byte:	mov			dph,r2
		mov			dpl,r3
		clr			a
		movc		a,@a+dptr


bitv19	=1 ~ 19600

yst1:	...				??????
		mov	IE,#80h




        mov     SBUF,#7
        jnb     TI,$
        clr     TI


	clr	RI
	clr	C
	mov	A,SBUF


SUB_RS232:
	push	ACC
	push	PSW
        setb    PSW.3
	clr	TI
	jnb	RI,S_R2
	clr	RI
	clr	C
	mov	A,SBUF
	subb	A,#20h
	jc	S_RS_COM	
	mov	A,COUNT_RS
	orl	A,COUNT_RS
	jz	S_R3
	add	A,#BUF_RS	
	mov	R1,A
	mov	A,SBUF
	mov	@R1,A
	dec	COUNT_RS
	ljmp	S_R2
S_RS_COM:
	mov	COUNT_RS,#0
	mov	A,SBUF
	mov	R1,#BUF_RS
	mov	@R1,A
	cjne	A,#27,S_R0
	mov	COUNT_RS,#4
	ljmp	S_R2	
S_R0:	cjne	A,#28,S_R1
	mov	COUNT_RS,#4
	ljmp	S_R2	
S_R1:	cjne	A,#29,S_R3
	clr	RUN_SYS.2	
	clr	RUN_SYS.3	
	mov	COUNT_RS,#0
S_R3:	mov	@R1,#0	
S_R2:	pop	PSW
	pop	ACC
        reti

       mov     SCON,#50h

        mov     TMOD,#00010101B	;timer 1, count 0
        mov     TCON,#00000101B	;mode INT0, INT1
        mov     IE,  #10001110B	;enable int1, t0 , t1
        mov     IP,  #00000000B 


