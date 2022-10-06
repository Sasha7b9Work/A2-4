	формат команды ( от РС к прибору )
АА  АА  cmd  lng bytes  ...  ks
	answer 
АА  АА  code  lng bytes<=255  ...  ks

1-я доп.команда: гнать поток 4 байтовых плавающих слов=результатов измерений ? если м.быть так быстро результаты

1	А0	выкл.АВП					bitavp	BIT	cellbit.5
	А1	вкл.АВП

2	Q0	установка 0					bitnul	BIT	cellbit1.7

3	B0	выкл.выдачу рез-тов
	B1	вкл.выдачу рез-тов
	B2	выдать режим

4	T0	время установления показаний	10 с		parT	 data  9ah		знач. 0-6
	T1					1 с
	T2	0.1
	T3	50 мс
	T4	10 мс
	T5	2 мс

5	H0	разрешение	4 разряда			parN	data  0afh		знач.1,2,3
	H1			5
	H2			6

6	R0	выкл.режим вычисления R				bitvi11	BIT	cellbit.6
	R1	вкл.режим вычисления R
	R2	ввести константы вычисления R			konstA	data  0bch	знач.1-1000

7	M0	очистить массив N				
	M1	задать интервал времени, сколько и единицы ????
	M2	вкл.накопление массива
	M3	выкл.
	M4	выдать в RS array N
	M5	задать массив адреса начала, конца

8	I0	измерение выкл.
	I1	измерение вкл.






	SUBR7.asm
testrs:	;jb	p0.3,goprogr
		clr	IE.4


;чтение памяти программ в r8..r11
;вх-r2,r3-адр яч памяти прогр
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


