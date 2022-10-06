;dptr-адрес €чейки страницы пам€ти
cle256:		mov		IE,#00H
			mov		FLSCL,#01			;стирание страницы байт(запись в €чейки ff)
			MOV		PSCTL,#03
					
			mov		a,#00h	;запись любого значени€ стирает страницу
			movx	@dptr,a				;wr
			mov		PSCTL,#00
			mov		FLSCL,#00
			mov		IE,#80H
			ret

;чтение пам€ти программ в r8..r11
;вх-r2,r3-адр €ч пам€ти прогр
re4byte: mov		dph,r2
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
 ;чтение пам€ти программ в r2..r5
;вх-r2,r3-адр €ч пам€ти прогр
rebyte2: mov		dph,r2
		mov			dpl,r3
		clr			a
		movc		a,@a+dptr
		mov			r2,a
		inc			dptr
		clr			a
		movc		a,@a+dptr
		mov			r3,a
		inc			dptr
		clr			a
		movc		a,@a+dptr
		mov			r4,a
		inc			dptr
		clr			a
		movc		a,@a+dptr
		mov			r5,a						;r8..r11
		ret
 
;r7-количество байт
;dptr-адр €чейки дл€ записи
;r1-адр €чейки	внешнего озу

wrpage:	mov		IE,#00H
WW5:	mov		FLSCL,#01		;об€зательно дл€ каждого записи байта
		mov		PSCTL,#01		;об€зательно дл€ каждого записи байта
		movx		a,@r1
		movx		@dptr,a				;wr
		mov		PSCTL,#0
		mov		FLSCL,#00
		inc			dptr
		inc			r1
		djnz		r7,WW5
		mov		IE,#80H
		ret
			


;чтение пам€ти программ во внешнее озу
;вх-r2,r3-адр €ч пам€ти прогр
;r1- €ч внешнее озу
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

;r8..r11->@r0..@r0+3
;r0-адр €чейки
;сохранить в €чейке озу
savelte:	mov	a,ltemp
		mov	@r0,a
		inc	r0
		mov	a,ltemp+1
		mov	@r0,a
		inc	r0
		mov	a,ltemp+2
		mov	@r0,a
		inc	r0
		mov	a,ltemp+3
		mov	@r0,a
		ret


 