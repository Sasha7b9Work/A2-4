loadUS:	;если идет тест измерения ус восстановить для теста
				jb		biteizm,yestest
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
bret:	   call		 louizm		;us если вкл кн ИЗМЕР
			ret
yestest:
			call		lotpus		;ус теста измерения
			ret
			
;загр ус для кор 0
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

kor0us:		db		80h;18h,2eh		;us режима коррекции 0

;us кнопка измерения выкл
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

 ;загрузка текста в буфер 2 bufind+0..bufind9
;в зав от parT (Tизм)
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
;загрузка текста в буфер 2 bufind+0..bufind9			
;dptr-адр строки текста		
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




 ;задержка 100 мкс
z_100:    mov R1,#78h     ;загрузка первого числа
z100:     mov R2,#2h     ;загрузка второго числа
count:    djnz R2, count;декремент R2 и внутренний цикл, если R2<>0 	
          djnz R1, z100 ;декремент R1 и внутренний цикл, если R1<>0
          ret           

;задержка 34 мкс
z_5:      mov R3,#8Bh      ;загрузка числа
ct:       djnz R3,ct
          ret

;задержка 15 мс
z_15:     mov R1,#0FAh    ;загрузка первого числа
z15:      mov R2,#0EDh   ;загрузка второго числа
zz:       djnz R2, zz 	;декремент R2 и внутренний цикл, если R2<>0
          djnz R1, z15  ;декремент R1 и внутренний цикл, если R1<>0
          ret   
					  
 ;задержка 1 мс
z_1ms:     mov R1,#10h     
ss1:       mov R2,#0EDh    
      	   djnz R2, $ 	 
           djnz R1, ss1   
           ret   

 ;????????
;задержка 1с
z_1s:   mov		r5,#01fh 
co2s:	mov 	R6,#0ffh     
z1s:     mov 	R7,#0ffh     
co1s:   djnz 	R7, co1s	
        djnz 	R6, z1s 
		djnz	r5,co2s
          ret
;задержка 0,1с
z_01s:  	 mov		r5,#03h 
co02s:		mov 	R6,#0ffh     
z01s:     	mov 	R7,#0ffh     
		  	djnz 	R7, $	
        	djnz 	R6, z01s 
			djnz	r5,co02s
         	 ret
					  
;задержка 0,5с
z_05s:  	 mov		r5,#0dh 
co05s:			mov 	R6,#0ffh     
z05s:     	mov 	R7,#0ffh     
		  		djnz 	R7, $	
        	djnz 	R6, z05s 
					djnz	r5,co05s
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
chk:		db	00,01,86h,0a0h;
;r1- мл байт 2х байтного числа
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
  ;r0-обнуление ячеек памяти  
  clear4:	 mov	r7,#4
  			clr		a
  cl4:		mov		@r0,a
			inc		r0
			djnz	r7,cl4
			ret	

 ;r0-обнуление ячеек памяти 
 ;R7- 
  clearN:	 
  			clr		a
  cl4N:		mov		@r0,a
			inc		r0
			djnz	r7,cl4N
			ret	

  ;чтение номера байта с индикатора(2байта)
;bufind+8..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;ст            мл
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
;ст            мл
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

 ;чтение номера байта с индикатора(3байта)
;bufind+3..bufind+9
;-  - - -
;- - - - - - - - - -
;adec..adec+9
;ст            мл
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

;вых-r2,r3-адрес ячее памяти прогр
findkoef:
				mov		r1,#diap
				mov		a,@r1
				rl		a							;diap*2(2bait )
				mov		r4,a					;save
				mov		dptr,#diKDw		;адрес таблицы поиска коэффициентов
				
				movc	a,@a+dptr			;ст байт
				mov		r2,a
				inc		dptr
				mov		a,r4
				movc	a,@a+dptr
				mov		r3,a			;мл байт
				ret
;r2..r5 в опр яч внешн озу
findext:
				mov		r1,#diap
				mov		a,@r1
				rl		a							;diap*2(2bait )
				rl		a							;diap*2(2bait )
				mov		r1,a					;r1-номер ячейки внешнего озу
				
				ret

;адрес ячеек прзу  коэффициентов диапазона KD
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
;ст            мл
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
;ст            мл
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



;управление AD7731
;r4=b1 r5=b2
iniacp:	;управление AD7731
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
tabB1_2:		db		00,00		 ;B1,B2 в соотв с Tизм  
				db		60h,00h;40h,04h		;10s
				db		60h,00;40h,04h		;1s
				db		40h,04h		;0,1s
				db		20h,04h		;50ms
				db		20h,04h		 ;10ms
				db		13h,32h		;2ms

;загр В1,В2 в завис от Т				
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
				;после загр В1,2 загр упр слово для нового Т
			
				ret


loadr2:	mov		r0,#abin+3		;r2..r5
		mov		a,@r0			; ст мл   
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
 ;загрузка KD в зависимости от диап изм  
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

;загр ус для тестов ацп 
;dptr-
lotpus:	mov		r0,#vichR
				cjne	@r0,#21h,te22
				mov			dptr,#tabt11;заслать ус 11А
lotp:		clr		a
			movc	a,@a+dptr				;high byte
			mov		p4,a
			inc		dptr
			clr		a
			movc	a,@a+dptr				;low byte
			mov		p5,a
			ret
te22:			cjne	@r0,#22h,te23
			mov			dptr,#tabt9;заслать ус 9А	
			jmp			lotp

te23:	mov			dptr,#tabt7;заслать ус 7А	
			jmp			lotp





Tabn:		db		2,3,4,5,6,7,8,9,10,11				;порядок диапазонов степени

findR:			mov			r0,#diap
						mov			a,@r0
						mov			dptr,#Tabn
						movc		a,@a+dptr
						ret

;bufind=30h..39h											 ;
vvchif:			clr		bitmig
				mov		r1,#marker
				mov		a,@r1			;изм цифры
				mov		r0,#bufind			;0000
				add		a,r0
				mov		r0,a
				inc		@r0
				cjne	@r0,#3ah,chif
				mov		@r0,#30h
chif:	
       			ret

  ;перевод маркера влево
marle:	
		clr		bitmig
		;mov		savba,#0   нельзя обнулять
    	mov		r0,#marker
		dec		@r0
   		mov		a,@r0
		clr		c
		subb	a,movleft	  ;крайне левое положение
		jnc		rler
		inc		@r0
rler:  	ret
    
;перевод маркера вправо
marri:	clr		bitmig
		mov		r0,#marker
   		inc	    @r0
		mov		a,movrig	   ;крайне правое положение
		clr		c
		subb	a,@r0
		jnc		rrir
		dec		@r0
rrir:  	ret
    
;konstA->bufind+4..bufind+7
outA:		mov			r0,#konstA
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
outB:		mov			r0,#konstB
				call		resar2
				mov			a,r2
				anl			a,#80h
				jz			outb3
mov			a,r2
				anl			a,#7fh
				mov			r2,a
				mov			bufind+3,#2dh
outb3:	call		ftol			;->hex
				mov		r0,#abin
				call		saver2
				mov			r0,#adec
				mov		r1,#abin+3
				call		bindec
				mov			r0,#adec+9
				mov			r1,#bufind+8
				mov			r7,#5
outb2:	mov		a,@r0
			  add		a,#30h
				mov		@r1,a
				dec		r1
				dec		r0
				djnz	r7,outb2
				ret


;пп мигания индикации
mign:		mov		r0,#marker
				
				cjne	@r0,#0ffh,mignn
				;реж изм мигает *
				clr		bitmig
				ret

mignn:			;clr		c
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

onmig:			mov		@r1,savba
				;mov		a,savba
				; mov		@r1,a
				clr		bitmig
				call	z_01s
				ret
;номер ошибки bufind+6
error:		mov		dptr,#teERR
					call	lotext
					mov		bufind+6,nuerr
				ret


textT:		
			db		0fdh,"T","=",32h,"m",67h,0fdh,0fdh,0fdh,0fdh ;load=0..5
			db		0fdh,"T","=",31h,30h,"m",67h,0fdh,0fdh,0fdh
			db		0fdh,"T","=",35h,30h,"m",67h,0fdh,0fdh,0fdh
			db		0fdh,"T","=",64h,31h,67h,0fdh,0fdh,0fdh,0fdh
			db		" "," "," ","T","=",31h,67h," "," "," "
			db		" "," ","T","=",31h,30h,67h," "," "," "	 
;teNO:		db		0fdh,0fdh,0fdh,"H","E","T",0fdh,0fdh,0fdh,0fdh

teVICH:	db		"B",75h,34h,74h,79h,76h,74h,"T",77h," ";вычислить
teAequ0:  	db		" ",'A','='," "," "," "," "," "," ",65h
teBequ0:	db		" ",'B','=','+'," "," "," "," "," "," "
teMENU:	db		" "," ",71h,"E","H",72h," "," "," "," "

teTESI:	db	" ","T","E",79h,"T",2dh,74h,33h,71h," ";ТЕСТ -ИЗМ    11
teTESR:	db	"T","E",79h,"T"," ","R",35h," "," "," ";ТЕСТ RS 12
teSKOR:	db	" ",79h,'K',30h,"P"," ","R",35h," "," ";СКОР 232      13
teAVK:	db	" "," ",'A','B','K'," "," "," "," "," "	 ;AВK					14
teKALIB:	 db	" " ,'K','A',76h,74h,73h,"P "," "," "," ";КАЛИБР    15

teTE11:		db		" ",'T',"E",79h,'T'," ",2dh,31h,31h,'A';          21
teTE9:		db		" ",'T',"E",79h,'T'," ",2dh,30h,39h,'A';					22
teTE7:		db		" ",'T',"E",79h,'T'," ",2dh,30h,37h,'A';					23


teS57_6:		db		" "," ",35h,37h,36h," "," "," "," "," ";57.6
teS19_2:		db		" "," ",31h,39h,32h," "," "," "," "," ";19,2

tePAR:  	db		61h,'A',"P",30h,76h,77h," ",30h,30h,30h;пароль
teKD:			db		" ",30h,30h,30h,30h,30h," "," "," ",'A';00000
teIZMK:	db	74h,33h,71h," ","K",30h,"H",79h,"T"," "
teOUT:		db	" "," ","B",75h,"X",30h,78h," "," "," "	 ;ВЫХОД
teOLL:		db	" "," ",30h,'L','L'," "," "," "," "," "	 ;OLL
teCLE:		db	" "," ",30h,34h,74h,79h,'T','K','A' ," " ;ОЧИСТКА
teMEM:		db	" "," ",30h,'A',71h,79h,'T'," " ; ПАМЯТЬ
teWR:		db	" "," ",33h,'A',61h,74h,79h,77h," "," ";ЗАПИСЬ
teLIST:	db	" "," ",61h,'P',30h,79h,71h,30h,"T","P ";;ПРОСМОТР
teFULL:	db	" "," ",61h,30h,76h,"H",'A',62h," "," ";ПОЛНАЯ
teBLOK:	db	" "," ",73h,76h,30h,'K'," ",30h,30h," ";БЛОК 00
teBL:		db	" "," ",73h,76h,30h,'K'," "," "," "," ";БЛОК
tebBL:		db	"H",'A',34h," ",73h,76h," ",30h,30h,30h; НАЧ БЛОК 000
teeBL:		db	"K",30h,"H"," ",73h,76h," ",30h,30h,30h; КОН БЛОК 000
 ;;;;;;;;;;;;;;;;;;;         
teOLI:	db		" "," ",30h,"L","L"," ","I"," "," "," "
teOLR:	db		" "," ",30h,"L","L"," ",66h," "," "," "
teERR:	db		" "," ","E","R","R"," "," "," "," "," " ;ERR
teEND:	db		" "," ","E","N","D"," "," "," "," "," " ;END

