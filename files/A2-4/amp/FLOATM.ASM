;	Copyright (C) 1988 HI-TECH Software

;	Single Precision Floating point arithmetic routines for 8051

;	The format of floating point numbers is as follows:

;	-----------------
;	*     sign	*  1 bit
;	-----------------
;	*   exponent	*  8 bits
;	-----------------
;	*   mantissa	*  23 bits + 1 implied bit = 24 bits
;	-----------------


;	As usual for the 8051 the memory layout has the most significant
;	byte (i.e. that containing the sign) coming first, i.e. at the
;	lowest address.

;	Calling conventions:

;	Left operand in r2-r5, right operand in ltemp (r0'-r3')
;
;	Return value is in r2-r5

;	Naming conventions: A routine name is constructed by

;	      ASOP

;	Where A is the arithmetic type (f for float), and op is the operation,
;	one of mul, div, mod, add, sub and cmp. S is the size, always l.
;	Conversion routines are named

;		AStof

;	where A is the arithmetic type (a for integer, l for unsigned)
;	S is the integer size, one of b (byte), w (word) or l (long).
;	Conversion from float to integer is ftol.

;		.ORG  5000h
;		.CODE
;	seg	c_text

;;	$MOD812
	CSEG
	;ORG 1000h

		;;;PUBLIC	flmul,fldiv,fladd,flsub,flcmp
	;;;PUBLIC	ftol,altof,lltof,awtof,lwtof,abtof,lbtof

;	EXTERNAL DELAY,KKOFU0,AKNCH,XNULLU
;	macros

saveregs	macro
	push	7
	push	6
	push	1
	push	0
	endm

restregs	macro
	pop	0
	pop	1
	pop	6
	pop	7
	endm

;addr	
dan	macro	pad
	mov	a,r5
	add	a,pad+3
	mov	pad+3,a
	mov	a,pad+2
	addc	a,r4
	mov	pad+2,a
	mov	a,pad+1
	addc	a,r3
	mov	pad+1,a
	mov	a,pad+0
	addc	a,r2
	mov	pad,a
	endm

addl	macro  addr
	mov	a,r5
	add	a,addr+3
	mov	r5,a
	mov	a,addr+2
	addc	a,r4
	mov	r4,a
	mov	a,addr+1
	addc	a,r3
	mov	r3,a
	mov	a,addr+0
	addc	a,r2
	mov	r2,a
	endm


add1	macro
	mov	a,r5
	add	a,#1
	mov	r5,a
	clr	a
	addc	a,r4
	mov	r4,a
	clr	a
	addc	a,r3
	mov	r3,a
	clr	a
	addc	a,r2
	mov	r2,a
	endm

shfdn	macro  addr
	clr	c
	mov	a,addr
	rrc	a
	mov	addr,a
	mov	a,addr+1
	rrc	a
	mov	addr+1,a
	mov	a,addr+2
	rrc	a
	mov	addr+2,a
	mov	a,addr+3
	rrc	a
	mov	addr+3,a
	endm

shfup	macro  addr
	clr	c
	mov	a,addr+3
	rlc	a
	mov	addr+3,a
	mov	a,addr+2
	rlc	a
	mov	addr+2,a
	mov	a,addr+1
	rlc	a
	mov	addr+1,a
	mov	a,addr
	rlc	a
	mov	addr,a
	endm

rshift	macro
	clr	c
	mov	a,r2
	rrc	a
	mov	r2,a
	mov	a,r3
	rrc	a
	mov	r3,a
	mov	a,r4
	rrc	a
	mov	r4,a
	mov	a,r5
	rrc	a
	mov	r5,a
	endm
rshift1 macro
	setb	c
	mov	a,r2
	rrc	a
	mov	r2,a
	mov	a,r3
	rrc	a
	mov	r3,a
	mov	a,r4
	rrc	a
	mov	r4,a
	mov	a,r5
	rrc	a
	mov	r5,a
	endm


lshift	macro
	mov	a,r5
	rlc	a
	mov	r5,a
	mov	a,r4
	rlc	a
	mov	r4,a
	mov	a,r3
	rlc	a
	mov	r3,a
	mov	a,r2
	rlc	a
	mov	r2,a
	endm

neg1	macro
	clr	c
	clr	a
	subb	a,r5
	mov	r5,a
	clr	a
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r3
	mov	r3,a
	clr	a
	subb	a,r2
	mov	r2,a
	endm

negm	macro  addr
	clr	c
	clr	a
	subb	a,addr+3
	mov	addr+3,a
	clr	a
	subb	a,addr+2
	mov	addr+2,a
	clr	a
	subb	a,addr+1
	mov	addr+1,a
	clr	a
	subb	a,addr
	mov	addr,a
	endm

copytor macro  addr
	mov	r2,addr
	mov	r3,addr+1
	mov	r4,addr+2
	mov	r5,addr+3
	endm


copyrto macro  addr
	mov	addr,r2
	mov	addr+1,r3
	mov	addr+2,r4
	mov	addr+3,r5
	endm


;	Internal representation: in this set of routines a floating number
;	is unpacked into seperate mantissa, exponent and sign parts.

;	Stack offset values
;ltemp	 equ	 28h

cntr	equ	6		;r6 is the counter
sign	equ	7		;signs in r7 - left sign in bit 7, right in 6
exp1	equ	0		;exponent 1 in r0
mant1	equ	2		;mantissa 1 in r2-5
exp2	equ	1		;exponent 1 in r1
mant2	equ	ltemp		;mantissa 2 in ltemp
prod	equ	ltemp+4 	;product/quotient in ltemp+4 (r4'-r7')





;DECSIZE EQU	 10
;NUMSIZE EQU	 4
;RR4	 EQU	 4
;RR5	 EQU	 5

;	unpack1 - unpacks the left operand

unpack1:
	mov	a,r2		;get sign
	anl	a,#80h
	anl	sign,#40h	;clear other bits
	orl	sign,a		;store sign
	mov	a,r3		;get lsb of exponent
	rlc	a		;rotate into carry
	mov	a,r2		;get rest of exponent
	rlc	a		;and make it 8 bits
	mov	r0,a		;store it
	jz	zer1		;if zero, the whole thing is zero
	orl	mant1+1,#80h	;set hidden bit
	mov	r2,#0		;clear upper byte of mantissa
	ret
zer1:
	clr	a
	mov	r2,a
	mov	r3,a
	mov	r4,a
	mov	r5,a		;zero mantissa
	mov	r0,a		;zero exponent
	ret

;	unpack2 - unpacks right operand

unpack2:
	mov	a,ltemp 	;get sign
	rrc	a		;shift down
	anl	a,#40h		;mask out sign
	anl	sign,#80h	;clear old bit
	orl	sign,a
	mov	a,ltemp+1	;get lsb of exponent
	rlc	a		;rotate into carry
	mov	a,ltemp 	;get rest of exponent
	rlc	a		;and make it 8 bits
	mov	r1,a		;store it
	jz	zer2		;if zero, the whole thing is zero
	orl	mant2+1,#80h	;set hidden bit
	mov	mant2,#0	;clear upper byte
	ret
zer2:
	clr	a
	mov	ltemp,a
	mov	ltemp+1,a
	mov	ltemp+2,a
	mov	ltemp+3,a		;zero mantissa
	ret

;	pack1 - put operand 1 back into float format

pack1:
	mov	a,r0		;get exponent
	clr	c
	rrc	a		;shift down 1 bit
	anl	sign,#80h	;mask sign bit
	orl	a,r7		;or in sign bit
	mov	r2,a		;store
	mov	a,r0		;get other bit
	rr	a		;rotate into hi bit
	anl	a,#80h		;mask
	anl	mant1+1,#7Fh	;clear hidden bit
	orl	mant1+1,a	;put in
	ret


;	norm1 - normalize the unpacked value in 1

norm1:
	mov	a,r0		;get exponent
	jz	zer1		;zero the mantissa if so
	mov	a,r2		;get hi byte
	jz	norup		;zero, so shift up if anything
nordn:
	mov	a,r2		;get hi byte
	cjne	a,#1,nordn1	;if not about to do last shift, skip
	add1			;add in a rounding bit
nordn1:
	rshift			;shift down 1 bit
	inc	r0		;adjust exponent
	mov	a,r2		;test high byte
	jnz	nordn		;loop
	ret			;done

norup:
	orl	a,r3
	orl	a,r4
	orl	a,r5		;test for zero mantissa
	jz	zer1		;it is - make it true zero
norup1:
	mov	a,r3		;get mantissa byte
	jb	acc.7,norup2	;jump if set
	clr	c
	lshift			;shift mantissa up
	dec	r0		;adjust exponent
	jmp	norup1
norup2:
	ret			;finito


;	fpdenorm - denormalize one of the two operands so that their
;	exponents are equal. This requires the smaller number to have
;	its exponent incremented and its mantissa shifted right.

denorm:
	mov	a,r0
	clr	c
	subb	a,r1		;compare exponents
	jnc	up2a		;shift operand 2
up1:
	inc	r0		;increment exponent
	rshift			;shift mantissa down
	mov	a,r0
	cjne	a,exp2,up1	;loop if still not equal
	ret

up2:
	inc	r1		;increment exponent 2
	shfdn	mant2		;shift mantissa down
up2a:
	mov	a,r0		;compare exponents
	cjne	a,exp2,up2
	ret			;all done
;------------------------------------------------------------------
;	Add the number in op1 to the number in op2 and return the result in r2-r5

fladd:
	saveregs
	call	unpack1
	call	unpack2
	call	denorm
	mov	a,sign
	jnb	acc.7,ok1	;test left sign
	neg1			;negate op1
ok1:
	mov	a,sign
	jnb	acc.6,ok2	;test right sign
	negm	mant2		;negate op2
ok2:
	addl	mant2		;add mantissas
	clr	a
	mov	r7,a		;clear sign
	mov	a,r2		;get sign of result
	jnb	acc.7,ok3	;all ok
	mov	r7,a		;store sign
	neg1			;negate mantissa
ok3:
	call	norm1
	call	pack1		;pack normalized result
	restregs		;and return
	ret
;-------------------------------------------------------------
;	Subtract the number ltemp from the number in r2-r5

flsub:
	xrl	ltemp,#80h	;toggle sign bit
	jmp	fladd		;and add!

;================================================================
;	Compare r2-r5 with the right operand and set flags accordingly

flcmp:
       mov     a,r2	       ;get sign of left
       xrl     a,ltemp	       ;calculate new sign
       jnb     acc.7,cexp      ;same, go check exponent
;ifdef SMALL_MODEL
	mov	a,r2		;get sign of left again
	rlc	a
	jnc	flout
;endif
	setb	c
flout:       	ret		       ;return with acc < 0

cexp:
       clr     c
       mov     a,r2	       ;compare exponent and mantissa
       subb    a,ltemp
       jnz     fnd
       mov     a,r3
       subb    a,ltemp+1
       jnz     fnd
       mov     a,r4
       subb    a,ltemp+2
       jnz     fnd
       mov     a,r5
       subb    a,ltemp+3
       jnz     fnd
cdone:
       ret		       ;return with acc == 0
fnd:
      mov     b,r2	       ;get sign of left value
     jnb     b.7,cdone       ;if positive, finished
       cpl   acc.7	       ;toggle sign???????/
                    orl     	a,#1            	      ;make non-zero
	cpl	c		;c=0->1,c=1->0
       	ret
;==============================================================

;	Multiply the float in r2-r5 by the float in ltemp and return
;	the result in r2-r5

flmul:
	saveregs
	call	unpack1
	call	unpack2
	clr	a
	mov	prod,a
	mov	prod+1,a	;clear product
	mov	prod+2,a
	mov	prod+3,a
	mov	r6,#7		;initialize counter
mup1:
	shfdn	mant2		;shift multiplier right
	jnc	nobit		;skip if lsb was zero
	dan	prod		;add multiplicand to product
nobit:
	lshift			;shift multiplicand up
	djnz	r6,mup1 	;loop if more

	mov	r6,#17		;re-initalize counter
	sjmp	mup3
mup11:
	shfdn	prod		;shift product right
mup3:
	shfdn	mant2		;shift multiplier down
	jnc	mup2		;skip if bit not set
	dan	prod		;add to prod
mup2:
	djnz	r6,mup11	;loop if more
	mov	a,r0		;get exp1
	add	a,r1		;add exp2
	add	a,#7ah;;;;;;;;;;;;;;;;;;;(-127-7) & 0FFh    ;adjust
	mov	r0,a		;store
	mov	a,r7		;get sign
	rl	a		;rotate bit into msb
	xrl	sign,a		;xor with other bit
	copytor prod		;copy prod to mant1
	call	norm1		;normalize
	call	pack1
	restregs
	ret
;-----------------------------------------------------------
;	Floating divide: divide the number in r2-r5 by ltemp

fldiv:
	saveregs
	call	unpack1
	call	unpack2
	clr	a
	mov	prod,a
	mov	prod+1,a
	mov	prod+2,a
	mov	prod+3,a
	mov	a,r1		;check for zero divisor
	jz	div9
	mov	a,r0		;check for zero dividend
	jz	div9
	clr	c
	subb	a,r1		;compute new exponent
	add	a,#127-7	;unbias
	mov	r0,a		;store back
	mov	a,r7		;get sign
	rl	a
	xrl	sign,a		;compute new sign
	mov	r6,#24+7	;initialize counter
div1:
	shfup	prod		;shift quotient up
	clr	c
	mov	a,r2		;compare values
	subb	a,mant2
	jc	div2		;skip if bigger
	jnz	div3
	mov	a,r3		;compare values
	subb	a,mant2+1
	jc	div2		;skip if bigger
	jnz	div3
	mov	a,r4		;compare values
	subb	a,mant2+2
	jc	div2		;skip if bigger
	jnz	div3
	mov	a,r5		;compare values
	subb	a,mant2+3
	jc	div2		;skip if bigger
div3:
	mov	a,r5
	subb	a,mant2+3
	mov	r5,a
	mov	a,r4
	subb	a,mant2+2		;do subtraction
	mov	r4,a
	mov	a,r3
	subb	a,mant2+1		;do subtraction
	mov	r3,a
	mov	a,r2
	subb	a,mant2 	;do subtraction
	mov	r2,a
	orl	prod+3,#1	;set lsb in quotient
div2:
	lshift			;shift dividend up
	djnz	r6,div1 	;loop if more
	copytor prod		;copy quotient
div9:
	call	norm1		;now normalize result
	call	pack1		;pack it up
	restregs		;restore registers
	ret
;------------------------------------------------------------------

;	Float to long conversion: if the exponent is less than the
;	excess value, the result is zero. If the exponent is so large
;	that the value would be shifted out, the result is overflow.
;	Otherwise shift the mantissa up or down as required.

ftol:
	saveregs
	mov	a,r2
	cjne	a,#0bfh,ne05
	mov	a,r3
	jnz	ne05
	mov	a,r4
	jnz	ne05
	mov	a,r5
	jz	ftol1
ne05:	call	unpack1
	mov	a,r0		;get exponent
	add	a,#-(127-1)	;unbias
	jb	acc.7,ftol1	;jump if < 0
	mov	a,r7		;get sign
	jnb	acc.7,ftol4	;skip if +ve
	neg1			;negate it
ftol4:
	mov	a,r0		;get exponent
	add	a,#6ah;;;;;;;;(-(127-1+23+1)) & 0FFh
	jb	acc.7,ftol2	;shift has to be right
	mov	r0,a		;save it
	add	a,#-8		;if > 8, too big
	jnc	ftol3
ftol1:
	clr	a
	mov	r2,a
	mov	r3,a
	mov	r4,a
	mov	r5,a
ftol9:
	restregs
	ret
ftol3:
	mov	a,r0
	mov	r6,a		;store in counter
	jz	ftol9		;if zero, do nothing
ftol33:
	lshift			;shift up
	djnz	r6,ftol33	;and loop
	sjmp	ftol9
ftol2:
	cpl	a		;complement
	mov	r6,a
	jz	ftol22
ftol23:
	mov	a,r7
	jnb	acc.7,ftol24
	rshift1
	jmp	ftol25
ftol24: rshift			;shift down
ftol25: djnz	r6,ftol23
ftol22:
	add1			;round
	mov	a,r7
	jnb	acc.7,ftol26
	rshift1
	jmp	ftol9
ftol26: rshift
	jmp	ftol9

;	arithmetic integer to floating conversions

abtof:
	mov	a,r5
	rl	a
	mov	r4,a
	subb	a,r4
	mov	r4,a
	mov	r3,a
	mov	r2,a
	jmp	altof
awtof:
	mov	a,r4
	rl	a
	mov	r3,a
	subb	a,r3
	mov	r3,a
	mov	r2,a
altof:
	saveregs
	mov	a,r2		;get sign
	anl	a,#80h
	mov	r7,a		;store it
	jnb	acc.7,altof1	;skip if +ve
	neg1
altof1:
	mov	r0,#127+23	;initialize exponent
	call	norm1		;normalize it
	call	pack1		;and pack up
	restregs
	ret

lbtof:
	mov	r4,#0
lwtof:
	clr	a
	mov	r3,a
	mov	r2,a
lltof:
	saveregs
	mov	r7,#0		;zero sign
	sjmp	altof1

;-------------------------------------------------------


