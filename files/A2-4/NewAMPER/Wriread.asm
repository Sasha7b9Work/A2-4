;dptr-����� ������ �������� ������
cle256:		mov		IE,#00H
			mov		FLSCL,#01			;�������� �������� ����(������ � ������ ff)
			MOV		PSCTL,#03
					
			mov		a,#00h	;������ ������ �������� ������� ��������
			movx	@dptr,a				;wr
			mov		PSCTL,#00
			mov		FLSCL,#00
			mov		IE,#80H
			ret

;������ ������ �������� � r8..r11
;��-r2,r3-��� �� ������ �����
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
 ;������ ������ �������� � r2..r5
;��-r2,r3-��� �� ������ �����
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
 
;r7-���������� ����
;dptr-��� ������ ��� ������
;r1-��� ������	�������� ���

wrpage:	mov		IE,#00H
WW5:	mov		FLSCL,#01		;����������� ��� ������� ������ �����
		mov		PSCTL,#01		;����������� ��� ������� ������ �����
		movx		a,@r1
		movx		@dptr,a				;wr
		mov		PSCTL,#0
		mov		FLSCL,#00
		inc			dptr
		inc			r1
		djnz		r7,WW5
		mov		IE,#80H
		ret
			


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

;r8..r11->@r0..@r0+3
;r0-��� ������
;��������� � ������ ���
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


 