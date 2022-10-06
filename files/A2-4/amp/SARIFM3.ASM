; Ф†©Ђ SARIFM.ASM 8.11.95
;файл арифметики
  
ltemp    equ       8           ;long temporary
xtemp    equ       12          ;other temporaries
DECSIZE  EQU       10
NUMSIZE  EQU       4
RR4  EQU       4
RR5  EQU       5

						

            ; rseg     ARIF          ; Switch to this code segment.
;             using    0              ; Specify register bank for the following
                                       ; program code.
;						cseg AT 400h
; Arithmetics:  CLEARING string
; Input:
; R0 - pointer to string,
; NUMSIZE - byte count if CLRNUM used,
; DECSIZE - byte count if CLRDEC used,
; R2 - byte count if CLEAR used;
; Output:  none.

CLRDEC:
    MOV R2, #DECSIZE
    SJMP    CLEAR
CLRNUM:
    MOV R2, #NUMSIZE
    ;JMP    CLEAR
CLEAR:
    CLR A
CLR11:  MOV @R0, A
    INC R0
    DJNZ    R2, CLR11
    RET

;**********************************
;mov	r1,#abin+3
;mov	r0,#adec
; _ _ _ _
;     03ff
;ст     мл   - вход
; _ _ _ _ _ _ _ _ _ _
;             1 0 2 3
;ст                мл 
;**********************************

BINDEC:
; Arithmetics:  CONVERTING from binary into decimal "4->10"
; Input:
; R0 - pointer to destination (high digit is the first),
; R1 - pointer to source,
; NUMSIZE - byte count in binary number;
; DECSIZE - byte count in decimal number;
; Output:  none.
; Source saved

    ; 1. Clear result
    MOV R2, #DECSIZE/2
    CALL   CLEAR  ; incrementing R0

    ; 2. Prepare convertion
    DEC R0
    MOV RR4, R0 ; R4 - pointer to low byte of packed decimal result
    MOV RR5, R1 ; R5 - pointer to low byte of binary number
    MOV R3, #NUMSIZE*8  ; R3 - bit counter in binary number

    ; 3. Convert cyrcle
BIN30:

    ; 3.1. Rotate binary number one bit to left and prepare <Carry>
    MOV R1, RR5
    MOV R2, #NUMSIZE
BIN31:  MOV A, @R1
    RLC A
    MOV @R1, A
    DEC R1
    DJNZ    R2, BIN31
    MOV R1, RR5
    MOV A, @R1
    MOV ACC.0, C
    MOV @R1, A

    ; 3.2. Doubling decimal result with <Carry>
    MOV R0, RR4
    MOV R2, #DECSIZE/2
BIN32:  MOV A, @R0
    ADDC    A, @R0
    DA  A
    MOV @R0, A
    DEC R0
    DJNZ    R2, BIN32

    ; 3.3. End of convert cyrcle
    DJNZ    R3, BIN30

    ; 4. Make bytes from half-bytes
    MOV A, R0
    ADD A, #DECSIZE
    MOV R0, A   ; R0 - pointer to low byte of unpacked decimal result
    MOV R1, RR4 ; R1 - pointer to low byte of packed decimal result
    MOV R2, #DECSIZE/2
BIN41:  MOV A, @R1
    ANL A, #00FH
    MOV @R0, A
    DEC R0
    MOV A, @R1
    SWAP    A
    ANL A, #00FH
    MOV @R0, A
    DEC R0
    DEC R1
    DJNZ    R2, BIN41
    RET


;*********************************
;mov	r0,#abin
;mov	r1,#adec
; _ _ _ _	-выход
; ff0000
;0004
;мл      ст

;ст                       мл
;_ _ _ _ _ _ _ _ _ _     вход
;                       2 5 5
;                   1 0 2 4

DECBIN:
; Arithmetics:  CONVERTING from decimal into binary "10->4"
; Input:
; R0 - pointer to destination,
; R1 - pointer to source (high digit is the first),
; NUMSIZE - byte count in binary number;
; DECSIZE - byte count in decimal number;
; Output:  none
; Source cleared

    ; 1. Clear result
    CALL    CLRNUM    ; + increment R0 by NUMSIZE

    ; 2. Prepare convertion
    DEC R0
    MOV RR4, R0 ; R4 - pointer to high byte of binary result
    MOV RR5, R1 ; R5 - pointer to high byte of packed decimal number
    MOV DPTR, #DECT2
    MOV R3, #NUMSIZE*8  ; R3 - bit counter in binary number

    ; 3. Convert cyrcle
DEC30:

    ; 3.1. Divide decimal number by 2 and prepare <Carry>
    CLR C
    MOV R1, RR5
    MOV R2, #DECSIZE
DEC31:  MOV A, @R1
    ANL A, #00FH
    MOV ACC.4, C
    MOVC    A,@A+DPTR
    MOV @R1, A
    MOV C, ACC.7
    INC R1
    DJNZ    R2, DEC31

    ; 3.2. Rotate binary result one bit to right with <Carry>
    MOV R0, RR4
    MOV R2, #NUMSIZE
DEC32:  MOV A, @R0
    RRC A
    MOV @R0, A
    DEC R0
    DJNZ    R2, DEC32

    ; 3.3. End of convert cyrcle
    DJNZ    R3, DEC30
    RET

DECT2:  DB  00,80H,001,81H,02,82H,03,83H,04,84H
    DB  00,00,00,00,00,00
    DB  05,85H,06,86H,07,87H,08H,88H,09H,89H

;   Long comparison
;   Lcmp - called with arg1 in r2-r5 and arg2 in ltemp - returns with
;   flags and acc set as though a long subtraction was done.
;*******************************
;сравнить r2..r5 с (ltemp..ltemp+3)
;c=1     r2..r5< ltemp..ltemp+3     a<b
;c=0       r2..r5> ltemp..ltemp+3   a>b
;*******************************
lcmp:
    clr c
    mov a,r2
    subb    a,8
    jnz done
    mov a,r3
    subb    a,9
    jnz done1
    mov a,r4
    subb    a,10
    jnz done1
    mov a,r5
    subb    a,11
done1:
    clr ov      ;overflow is significant only for top byte
done:
    ret

;   Load long into r2-5 from [dptr]

ldc_long:
    mov a,dph       ;is it in on board memory
    jz  onboard     ;yes
    clr a
    movc    a,@a+dptr
    mov r2,a
    mov a,#1
    movc    a,@a+dptr
    mov r3,a
    mov a,#2
    movc    a,@a+dptr
    mov r4,a
    mov a,#3
    movc    a,@a+dptr
    mov r5,a
    ret
onboard:
    mov r0,dpl
    mov a,@r0
    mov r2,a
    inc r0
    mov a,@r0
    mov r3,a
    inc r0
    mov a,@r0
    mov r4,a
    inc r0
    mov a,@r0
    mov r5,a
    ret

;**************************************
;загрузить ltemp...+3 из пам€ти программ
;mov	dptr,#CH5
;call	ldc_ltemp 	 ltemp <--5
;**************************************
ldc_ltemp:
    mov a,dph       ;is it in on board memory
    jz  oboard      ;yes
    clr a
    movc    a,@a+dptr
    mov 8,a
    mov a,#1
    movc    a,@a+dptr
    mov 9,a
    mov a,#2
    movc    a,@a+dptr
    mov 10,a
    mov a,#3
    movc    a,@a+dptr
    mov 11,a
    ret
oboard:
    mov r0,dpl
    mov 8,@r0
    inc r0
    mov 9,@r0
    inc r0
    mov 10,@r0
    inc r0
    mov 11,@r0
    ret

;*****************************
;mov	dptr,#k1
;call	ldx_long
;k1->r2..r5
;*****************************
;   Load long into r2-5 from [dptr]
;
; 01/30/90 JLZ      Updated from new library; added save/restore DPH, DPL
ldx_long:
    mov a,dph       ;is it in on board memory
    jz  onboar1        ;yes
    push    dpl
    push    dph
    movx    a,@dptr
    mov r2,a
    inc dptr
    movx    a,@dptr
    mov r3,a
    inc dptr
    movx    a,@dptr
    mov r4,a
    inc dptr
    movx    a,@dptr
    mov r5,a
    pop dph
    pop dpl
    ret
onboar1:
    mov r0,dpl
    mov a,@r0
    mov r2,a
    inc r0
    mov a,@r0
    mov r3,a
    inc r0
    mov a,@r0
    mov r4,a
    inc r0
    mov a,@r0
    mov r5,a
    ret

;*********************************
;mov	dptr,#k2
;call	ldx_ltemp	;k2->ltemp..ltemp+3
;**********************************
ldx_ltemp:
    mov a,dph       ;is it in on board memory
    jz  oboard1     ;yes
    movx    a,@dptr
    mov 8,a
    inc dptr
    movx    a,@dptr
    mov 9,a
    inc dptr
    movx    a,@dptr
    mov 10,a
    inc dptr
    movx    a,@dptr
    mov 11,a
    ret
oboard1:
    mov r0,dpl
    mov 8,@r0
    inc r0
    mov 9,@r0
    inc r0
    mov 10,@r0
    inc r0
    mov 11,@r0
    ret
;   Long division routines for 8051
;   Divide is called with the divisor in ltemp, the dividend in r5-r2
;   It returns with the quotient in r5-r2 and the remainder in ltemp
;   The top of bank 1 (locations 12-15) are used as a long temporary
;   and registers r0 and r1 in bank 0 are used as temporaries. R0 and
;   r1 must be saved by the caller.
;   This is long unsigned division.


;   Register usage:
;       r0 loop counter
;       xtemp (12-15) accumulates quotient
;       r5-r2 holds dividend
;       ltemp holds divisor

;************************************
;r2..r5-делимое
;ltemp..-делитель
;частное -r2..r5
;*************************************
divide:
    clr a
    mov r0,a        ;initialize count
    mov xtemp,a     ;zero quotient
    mov xtemp+1,a
    mov xtemp+2,a
    mov xtemp+3,a
    mov a,r5        ;check for zero dividend
    orl a,r4
    orl a,r3
    orl a,r2
    jz  jfinis
    mov a,ltemp     ;check for zero divisor
    orl a,ltemp+1
    orl a,ltemp+2
    orl a,ltemp+3
    jnz midl
    ret

jfinis: jmp finis

loops:
    mov a,r2
    clr c
    subb    a,ltemp+0   ;is divisor greater than dividend yet
    jc  yes     ;yes, go no further
    jnz no
    mov a,r3
    subb    a,ltemp+1
    jc  yes
    jnz no
    mov a,r4
    subb    a,ltemp+2
    jc  yes
    jnz no
    mov a,r5
    subb    a,ltemp+3
    jc  yes
no:
    mov a,ltemp+3   ;shift divisor up one bit
    add a,ltemp+3
    mov ltemp+3,a
    mov a,ltemp+2
    addc    a,ltemp+2
    mov ltemp+2,a
    mov a,ltemp+1
    addc    a,ltemp+1
    mov ltemp+1,a
    mov a,ltemp+0
    addc    a,ltemp+0
    mov ltemp+0,a
midl:
    inc r0      ;increment count
    mov a,ltemp+0   ;check for safe to shift some more
    jnb acc.7,loops  ;loop if top bit clear
yes:
    mov a,ltemp+0
    clr c
    subb    a,r2        ;can we subtract now?
    jc  dosub       ;yes, go and do it
    jnz nosub
    mov a,ltemp+1
    subb    a,r3
    jc  dosub
    jnz nosub
    mov a,ltemp+2
    subb    a,r4
    jc  dosub
    jnz nosub
    mov a,ltemp+3
    subb    a,r5
    jc  dosub
    jz  dosub
nosub:
    clr c
    sjmp    dosh
dosub:
    clr c       ;subtract divisor from dividend
    mov a,r5
    subb    a,ltemp+3
    mov r5,a
    mov a,r4
    subb    a,ltemp+2
    mov r4,a
    mov a,r3
    subb    a,ltemp+1
    mov r3,a
    mov a,r2
    subb    a,ltemp+0
    mov r2,a
    setb    c       ;now set bit for quotient
dosh:
    mov a,xtemp+3
    rlc a
    mov xtemp+3,a
    mov a,xtemp+2
    rlc a
    mov xtemp+2,a
    mov a,xtemp+1
    rlc a
    mov xtemp+1,a
    mov a,xtemp+0
    rlc a
    mov xtemp+0,a
    mov a,ltemp+0       ;shift divisor down
    clr c
    rrc a
    mov ltemp+0,a
    mov a,ltemp+1
    rrc a
    mov ltemp+1,a
    mov a,ltemp+2
    rrc a
    mov ltemp+2,a
    mov a,ltemp+3
    rrc a
    mov ltemp+3,a

    djnz    r0,yes      ;and continue with the rest

finis:
    mov ltemp+3,r5
    mov ltemp+2,r4
    mov ltemp+1,r3
    mov ltemp+0,r2
    mov r5,xtemp+3
    mov r4,xtemp+2
    mov r3,xtemp+1
    mov r2,xtemp+0
    ret         ;and return with the satisfaction of a job well done


;   Long multiplication
;   The main multiply thingo. Called with one operand in r5-r2 and the
;   other in ltemp. It really doesn't matter which one is where.

;**********************************
;(r2..r5)*(ltemp..ltemp+3)=r2..r5
;ст  мл
;**********************************
llmul:
almul:
lmul:
    mov a,r5        ;low order byte
    mov b,ltemp+3       ;times low order byte
    mul ab
    mov xtemp+3,a       ;store low
    mov xtemp+2,b   ;and high
    mov a,r5        ;low order
    mov b,ltemp+2   ;times next
    mul ab
    add a,xtemp+2   ;add in
    mov xtemp+2,a
    mov a,b
    addc    a,#0
    mov xtemp+1,a
    mov a,r5
    mov b,ltemp+1
    mul ab
    add a,xtemp+1
    mov xtemp+1,a
    mov a,b
    addc    a,#0
    mov xtemp+0,a
    mov a,r5
    mov b,ltemp+0
    mul ab
    add a,xtemp+0
    mov xtemp+0,a
    mov a,r4
    mov b,ltemp+3
    mul ab
    add a,xtemp+2
    mov xtemp+2,a
    mov a,b
    addc    a,xtemp+1
    mov xtemp+1,a
    mov a,xtemp+0
    addc    a,#0
    mov xtemp+0,a
    mov a,r4
    mov b,ltemp+2
    mul ab
    add a,xtemp+1
    mov xtemp+1,a
    mov a,b
    addc    a,xtemp+0
    mov xtemp+0,a
    mov a,r4
    mov b,ltemp+1
    mul ab
    add a,xtemp+0
    mov xtemp+0,a

    mov a,r3
    mov b,ltemp+3
    mul ab
    add a,xtemp+1
    mov xtemp+1,a
    mov a,b
    addc    a,xtemp+0
    mov xtemp+0,a
    mov a,r3
    mov b,ltemp+2
    mul ab
    add a,xtemp+0
    mov xtemp+0,a

    mov a,r2
    mov b,ltemp+3
    mul ab
    add a,xtemp+0
    mov r2,a
    mov r3,xtemp+1
    mov r4,xtemp+2
    mov r5,xtemp+3

    ret         ;all done
;******************************
;из содержимого  r2-r5  вычесть
;содержимое          ltemp..ltemp+3
;******************************
llsub:
 lsub:
    mov a,r5
    clr c
    subb    a,11
    mov r5,a
    mov a,r4
    subb    a,10
    mov r4,a
    mov a,r3
    subb    a,9
    mov r3,a
    mov a,r2
    subb    a,8
    mov r2,a
    ret

;***********************************************
;                                                      ст мл
; cложение содержимого  r2..r5 с числом по адресу
;  r0- адрес младшего байта !!!
;результат- r2..r5
;***********************************************

ladd:    clr       c
     mov       a,r5
     add       a,@r0
     mov       r5,a
     dec       r0
     mov       a,r4
     addc      a,@r0
     mov       r4,a
     dec       r0
     mov       a,r3
     addc      a,@r0
     mov       r3,a
     dec       r0
     mov       a,r2
     addc      a,@r0
     mov       r2,a
     ret
;***********************************************
;                                                      ст мл
; cложение содержимого  r2..r5 с числом по адресу
;  r0- адрес младшего байта !!!
;результат- r2..r5
;***********************************************

laddx:    clr       c
					movx		a,@r0
					add			a,r5
          mov     r5,a
     			dec     r0
     			movx    a,@r0
     			addc    a,r4
     			mov     r4,a
     			dec     r0
     			movx    a,@r0
     			addc    a,r3
     			mov     r3,a
     			dec     r0
     			movx    a,@r0
     			addc    a,r2
     			mov       r2,a
     			ret

;***********************************************
;                                                      ст мл
; cложение содержимого  r2..r5 с числом по адресу
;  dptr- адрес младшего байта !!!
;результат- r2..r5
;***********************************************

addx:    clr       c
					movx		a,@dptr
					add			a,r5
          mov     r5,a
     			call		dedptr;dec     dptr
     			movx    a,@dptr
     			addc    a,r4
     			mov     r4,a
     			call		dedptr;dec     dptr
     			movx    a,@dptr
     			addc    a,r3
     			mov     r3,a
     			call		dedptr;dec     dptr
     			movx    a,@dptr
     			addc    a,r2
     			mov       r2,a
     			ret

dedptr:		push	psw
					clr		c
					mov		a,dpl
					subb	a,#1
					mov		dpl,a
					mov		a,dph
					subb	a,#0
					mov		dph,a
					pop		psw
					ret