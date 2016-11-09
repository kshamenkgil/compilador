;
;ARCHIVO FINAL.ASM
;

INCLUDE macros2.asm		 ;incluye macros
INCLUDE number.asm		 ;incluye el asm para impresion de numeros

.MODEL LARGE ; tipo del modelo de memoria usado.
.386
.STACK 200h ; bytes en el stack
	
.DATA ; comienzo de la zona de datos.
	TRUE equ 1
	FALSE equ 0
	MAXTEXTSIZE equ 50
	&cte0 dd 0.000000
	&cte1 dd 1.000000
	@aux2 dd 0.0000000000
	@aux3 dd 0.0000000000
	@aux4STR db MAXTEXTSIZE dup(?), '$'
	cte5 db "Presione una tecla para finalizar...", '$', 50 dup(?)
	_a dd 0.000000
	_b dd 0.000000
	_c dd 0.000000
	_d dd 0.0000000000
	_e dd 0.0000000000
	_f dd 0.0000000000
	_j dd 0.0000000000
	_n1 dd 0.0000000000
	_n2 dd 0.0000000000
	_n3 dd 0.0000000000
	_g db MAXTEXTSIZE dup(?), '$'
	_h db MAXTEXTSIZE dup(?), '$'
	_i db MAXTEXTSIZE dup(?), '$'
	_v4r14bl3 dd 0.000000
	_a19 dd 0.0000000000
	_x dd 0.0000000000
	&cte6 dd 9.000000
	&cte7 dd 5.000000
	cte8 db "INGRESE a", '$', 41 dup(?)
	cte9 db "", '$', 50 dup(?)
	cte10 db "INGRESE b", '$', 41 dup(?)
	cte11 db "COMBINATORIO DE a Y b", '$', 29 dup(?)
	@aux12 dd 0.0000000000
	@aux13 dd 0.0000000000
	@aux14 dd 0.0000000000
	@aux15 dd 0.0000000000
	@aux16 dd 0.0000000000
	@aux17 dd 0.0000000000
	@aux18 dd 0.0000000000
	@aux19 dd 0.0000000000
	@aux20 dd 0.0000000000
	@aux21 dd 0.0000000000
	@aux22 dd 0.0000000000
	@aux23 dd 0.0000000000
	@aux24 dd 0.0000000000
	@aux25 dd 0.0000000000
	cte26 db " ", '$', 49 dup(?)
	cte27 db "FACTORIAL de 5", '$', 36 dup(?)
	@aux28 dd 0.0000000000
	@aux29 dd 0.0000000000
	cte30 db "FACTORIAL de FACTORIAL", '$', 28 dup(?)
	&cte31 dd 2.000000
	@aux32 dd 0.0000000000
	@aux33 dd 0.0000000000
	&cte34 dd 4.000000
	@aux35 dd 0.0000000000
	@aux36 dd 0.0000000000
	cte37 db "IMPRIMIR", '$', 42 dup(?)
	cte38 db "INGRESE 3 NUMEROS", '$', 33 dup(?)
	@aux39 dd 0.0000000000
	@aux40 dd 3.0000000000
	cte41 db "EL PROMEDIO ES", '$', 36 dup(?)
	cte42 db "CUENTA COMPLEJA", '$', 35 dup(?)
	&cte43 dd 8.000000
	cte44 db "Hola ", '$', 45 dup(?)
	cte45 db "Mundo", '$', 45 dup(?)
	cte46 db "CONCATENO ", '$', 40 dup(?)

.CODE ;Comienzo de la zona de codigo

;************************************************************
; devuelve en BX la cantidad de caracteres que tiene un string
; DS:SI apunta al string.
;************************************************************
STRLEN PROC
    mov bx,0

STRL01:
    cmp BYTE PTR [SI+BX],'$'
    je STREND
    inc BX
    jmp STRL01
STREND:
    ret

STRLEN ENDP

;************************************************************
; copia DS:SI a ES:DI; busca la cantidad de caracteres
;************************************************************
COPIAR PROC
    call STRLEN    ; busco la cantidad de caracteres
    cmp bx,MAXTEXTSIZE
    jle COPIARSIZEOK

    mov bx,MAXTEXTSIZE

COPIARSIZEOK:
    mov cx,bx
    cld

    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al

    ret
COPIAR ENDP

;************************************************************
; concatena DS:SI al final de ES:DI.
;
; busco el size del primer string
; sumo el size del segundo string
; si la suma excede MAXTEXTSIZE, copio solamente MAXTEXTSIZE caracteres
; si la suma NO excede MAXTEXTSIZE, copio el total de caracteres que tiene el segundo string
;************************************************************
CONCAT PROC
    push ds
    push si
    
    call STRLEN ; busco la cantidad de caracteres del 2do string

    mov dx,bx  ; guardo en DX la cantidad de caracteres en el origen.
    mov si,di
    push es
    pop ds

    call STRLEN ; tamaño del 1er string
        
    add di,bx ; DI ya queda apuntando al final del primer string    
    add bx,dx ; tamaño total

    cmp bx,MAXTEXTSIZE
    jg CONCATSIZEMAL

CONCATSIZEOK:
        mov cx,dx
        jmp CONCATSIGO

CONCATSIZEMAL:
        sub bx,MAXTEXTSIZE
        sub dx,bx
        mov cx,dx

CONCATSIGO:
        push ds
        pop es
        pop si
        pop ds
        cld ; cld es para que la copia se realice hacia adelante
        
        rep movsb ; copia la cadena
        mov al,'$' ; carácter terminador
        mov BYTE PTR [DI],al ; el registro DI quedo apuntando al final

        ret ;return
CONCAT ENDP

START: ;Código assembler resultante de compilar el programa fuente.
	mov AX,@DATA ;Inicializa el segmento de datos
	mov DS,AX
	finit

	;ASIGNACIÓN
	fld &cte6
	fstp _a

	;ASIGNACIÓN
	fld &cte7
	fstp _b

	;ASIGNACIÓN
	fld &cte0
	fstp _e

	;WRITE
	displayString cte8
	newLine 1

	;READ
	GetFloat _a

	;WRITE
	displayString cte9
	newLine 1

	;WRITE
	displayString cte10
	newLine 1

	;READ
	GetFloat _b

	;WRITE
	displayString cte9
	newLine 1

	;ASIGNACIÓN
	fld &cte7
	fstp _d

ETIQUETA18:
	;CMP
	fld _b
	fld _a
	fcomp
	fstsw ax
	fwait
	sahf

	jbe ETIQUETA170
ETIQUETA23:
	;CMP
	fld &cte0
	fld _b
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA170
ETIQUETA28:
	;WRITE
	displayString cte11
	newLine 1

	;ASIGNACIÓN
	fld _a
	fstp @aux13

	;ASIGNACIÓN
	fld @aux13
	fstp @aux12

	;ASIGNACIÓN
	fld &cte1
	fstp @aux14

	;CMP
	fld @aux12
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA65
	;CMP
	fld @aux12
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA65
	;ASIGNACIÓN
	fld @aux12
	fstp @aux14

ETIQUETA50:
	;RESTA
	fld @aux12
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux12

	;MULTIPLICACION
	fld @aux14
	fld @aux12
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux14

	;CMP
	fld &cte1
	fld @aux12
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA50
ETIQUETA65:
	;ASIGNACIÓN
	fld @aux14
	fstp @aux15

	;ASIGNACIÓN
	fld _b
	fstp @aux16

	;RESTA
	fld @aux13
	fld @aux16
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux19

	;ASIGNACIÓN
	fld @aux19
	fstp @aux17

	;ASIGNACIÓN
	fld &cte1
	fstp @aux18

	;CMP
	fld @aux17
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA109
	;CMP
	fld @aux17
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA109
	;ASIGNACIÓN
	fld @aux17
	fstp @aux18

ETIQUETA94:
	;RESTA
	fld @aux17
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux17

	;MULTIPLICACION
	fld @aux18
	fld @aux17
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux18

	;CMP
	fld &cte1
	fld @aux17
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA94
ETIQUETA109:
	;ASIGNACIÓN
	fld @aux18
	fstp @aux21

	;ASIGNACIÓN
	fld &cte1
	fstp @aux22

	;CMP
	fld @aux16
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA142
	;CMP
	fld @aux16
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA142
	;ASIGNACIÓN
	fld @aux16
	fstp @aux22

ETIQUETA127:
	;RESTA
	fld @aux16
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux16

	;MULTIPLICACION
	fld @aux22
	fld @aux16
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux22

	;CMP
	fld &cte1
	fld @aux16
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA127
ETIQUETA142:
	;ASIGNACIÓN
	fld @aux22
	fstp @aux23

	;MULTIPLICACION
	fld @aux18
	fld @aux23
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux24

	;DIVISION
	fld @aux15
	fld @aux24
	fdiv
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _j

	;WRITE
	DisplayFloat _j 2
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

	;RESTA
	fld _a
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _a

	;RESTA
	fld _b
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _b

	jmp ETIQUETA286
ETIQUETA170:
	;WRITE
	displayString cte27
	newLine 1

	;ASIGNACIÓN
	fld &cte7
	fstp @aux28

	;ASIGNACIÓN
	fld &cte1
	fstp @aux29

	;CMP
	fld @aux28
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA204
	;CMP
	fld @aux28
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA204
	;ASIGNACIÓN
	fld @aux28
	fstp @aux29

ETIQUETA189:
	;RESTA
	fld @aux28
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux28

	;MULTIPLICACION
	fld @aux29
	fld @aux28
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux29

	;CMP
	fld &cte1
	fld @aux28
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA189
ETIQUETA204:
	;ASIGNACIÓN
	fld @aux29
	fstp _j

	;WRITE
	DisplayFloat _j 2
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

	;WRITE
	displayString cte30
	newLine 1

	;ASIGNACIÓN
	fld &cte31
	fstp @aux32

	;ASIGNACIÓN
	fld &cte1
	fstp @aux33

	;CMP
	fld @aux32
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA244
	;CMP
	fld @aux32
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA244
	;ASIGNACIÓN
	fld @aux32
	fstp @aux33

ETIQUETA229:
	;RESTA
	fld @aux32
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux32

	;MULTIPLICACION
	fld @aux33
	fld @aux32
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux33

	;CMP
	fld &cte1
	fld @aux32
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA229
ETIQUETA244:
	;SUMA
	fld &cte34
	fld @aux33
	fadd
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux35

	;ASIGNACIÓN
	fld &cte1
	fstp @aux36

	;CMP
	fld @aux35
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA279
	;CMP
	fld @aux35
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA279
	;ASIGNACIÓN
	fld @aux35
	fstp @aux36

ETIQUETA264:
	;RESTA
	fld @aux35
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux35

	;MULTIPLICACION
	fld @aux36
	fld @aux35
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux36

	;CMP
	fld &cte1
	fld @aux35
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA264
ETIQUETA279:
	;ASIGNACIÓN
	fld @aux36
	fstp _j

	;WRITE
	DisplayFloat _j 2
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

ETIQUETA286:
	;RESTA
	fld _d
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _d

	;CMP
	fld &cte31
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA303
ETIQUETA296:
	;ASIGNACIÓN
	fld &cte0
	fstp _b

	;ASIGNACIÓN
	fld &cte7
	fstp _e

ETIQUETA303:
ETIQUETA304:
	;WRITE
	displayString cte37
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

	;RESTA
	fld _e
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _e

	;CMP
	fld &cte1
	fld _e
	fcomp
	fstsw ax
	fwait
	sahf

	jae ETIQUETA304
ETIQUETA317:
	;CMP
	fld &cte1
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf

	jae ETIQUETA18
ETIQUETA322:
	;WRITE
	displayString cte38
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _n1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _n2

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _n3

	;ASIGNACIÓN
	fld _n1
	fstp @aux39

	;SUMA
	fld @aux39
	fld _n2
	fadd
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux39

	;SUMA
	fld @aux39
	fld _n3
	fadd
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux39

	;DIVISION
	fld @aux39
	fld @aux40
	fdiv
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _j

	;WRITE
	displayString cte41
	newLine 1

	;WRITE
	DisplayFloat _j 2
	newLine 1

	;ASIGNACIÓN
	fld &cte0
	fstp _j

	;ASIGNACIÓN
	fld &cte1
	fstp _d

	;WRITE
	displayString cte42
	newLine 1

	;MULTIPLICACION
	fld &cte31
	fld _d
	fmul
	fstp @aux2

	;RESTA
	fld &cte43
	fld @aux2
	fsub
	fstp @aux3

	;RESTA
	fld &cte6
	fld &cte7
	fsub
	fstp @aux2

	;DIVISION
	fld @aux3
	fld @aux2
	fdiv
	fstp @aux3

	;MULTIPLICACION
	fld &cte31
	fld @aux3
	fmul
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _j

	;WRITE
	DisplayFloat _j 2
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

	;CONCATENACIÓN
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET cte44 ;apunta el origen a la primer cadena
	mov di,OFFSET @aux4STR ;apunta el destino al auxiliar
	call COPIAR ;copia los string

	mov ax,@DATA
	mov es,ax
	mov si,OFFSET cte45 ;apunta el origen a la segunda cadena
	mov di,OFFSET @aux4STR ;concatena los string
	call CONCAT

	;ASIGNACIÓN
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET @aux4STR ;apunta el origen al auxiliar
	mov di,OFFSET _g ;apunta el destino a la cadena
	call COPIAR ;copia los string

	;WRITE
	displayString _g
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

	;ASIGNACIÓN
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET cte46 ;apunta el origen al auxiliar
	mov di,OFFSET _h ;apunta el destino a la cadena
	call COPIAR ;copia los string

	;CONCATENACIÓN
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET _h ;apunta el origen a la primer cadena
	mov di,OFFSET @aux4STR ;apunta el destino al auxiliar
	call COPIAR ;copia los string

	mov ax,@DATA
	mov es,ax
	mov si,OFFSET _g ;apunta el origen a la segunda cadena
	mov di,OFFSET @aux4STR ;concatena los string
	call CONCAT

	;ASIGNACIÓN
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET @aux4STR ;apunta el origen al auxiliar
	mov di,OFFSET _h ;apunta el destino a la cadena
	call COPIAR ;copia los string

	;WRITE
	displayString _h
	newLine 1

	;WRITE
	displayString cte26
	newLine 1

	;READ
	GetFloat _f

ETIQUETA392:
	displayString cte5
	newLine 1
	getChar

TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END START;final del archivo.