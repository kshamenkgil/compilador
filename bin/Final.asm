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
	_b dd 0.000000
	_arbol dd 0.000000
	_casa dd 0.000000
	_d dd 0.000000
	_e dd 0.000000
	_a dd 0.000000
	_g dd 0.0000000000
	_a_ db MAXTEXTSIZE dup(?), '$'
	_v4r14bl3 dd 0.000000
	_a19 dd 0.0000000000
	_x dd 0.0000000000
	&cte6 dd 9.000000
	&cte7 dd 8.000000
	&cte8 dd 5.000000
	cte9 db "COMBINATORIO DE 9 y 8", '$', 29 dup(?)
	@aux10 dd 0.0000000000
	@aux11 dd 0.0000000000
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
	cte24 db " ", '$', 49 dup(?)
	cte25 db "FACTORIAL de 5", '$', 36 dup(?)
	@aux26 dd 0.0000000000
	@aux27 dd 0.0000000000
	cte28 db "FACTORIAL de FACTORIAL de 0", '$', 23 dup(?)
	@aux29 dd 0.0000000000
	@aux30 dd 0.0000000000
	@aux31 dd 0.0000000000
	@aux32 dd 0.0000000000
	&cte33 dd 2.000000

.CODE ;Comienzo de la zona de codigo
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
	fld &cte8
	fstp _d
ETIQUETA9:
	;CMP
	fld _b
	fld _a
	fcomp
	fstsw ax
	fwait
	sahf
	jbe ETIQUETA150
ETIQUETA14:
	;CMP
	fld &cte0
	fld _b
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA150
ETIQUETA19:
	;WRITE
	displayString cte9
	newLine 1
	;ASIGNACIÓN
	fld &cte6
	fstp @aux11
	;ASIGNACIÓN
	fld @aux11
	fstp @aux10
	;ASIGNACIÓN
	fld &cte1
	fstp @aux12
	;CMP
	fld @aux10
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA56
	;CMP
	fld @aux10
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA56
	;ASIGNACIÓN
	fld @aux10
	fstp @aux12
ETIQUETA41:
	;RESTA
	fld @aux10
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux10
	;MULTIPLICACION
	fld @aux12
	fld @aux10
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux12
	;CMP
	fld &cte1
	fld @aux10
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA41
ETIQUETA56:
	;ASIGNACIÓN
	fld @aux12
	fstp @aux13
	;ASIGNACIÓN
	fld _b
	fstp @aux14
	;RESTA
	fld @aux11
	fld @aux14
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux17
	;ASIGNACIÓN
	fld @aux17
	fstp @aux15
	;ASIGNACIÓN
	fld &cte1
	fstp @aux16
	;CMP
	fld @aux15
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA100
	;CMP
	fld @aux15
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA100
	;ASIGNACIÓN
	fld @aux15
	fstp @aux16
ETIQUETA85:
	;RESTA
	fld @aux15
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux15
	;MULTIPLICACION
	fld @aux16
	fld @aux15
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux16
	;CMP
	fld &cte1
	fld @aux15
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA85
ETIQUETA100:
	;ASIGNACIÓN
	fld @aux16
	fstp @aux19
	;ASIGNACIÓN
	fld &cte1
	fstp @aux20
	;CMP
	fld @aux14
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA133
	;CMP
	fld @aux14
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA133
	;ASIGNACIÓN
	fld @aux14
	fstp @aux20
ETIQUETA118:
	;RESTA
	fld @aux14
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux14
	;MULTIPLICACION
	fld @aux20
	fld @aux14
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux20
	;CMP
	fld &cte1
	fld @aux14
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA118
ETIQUETA133:
	;ASIGNACIÓN
	fld @aux20
	fstp @aux21
	;MULTIPLICACION
	fld @aux16
	fld @aux21
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux22
	;DIVISION
	fld @aux13
	fld @aux22
	fdiv
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp _a
	;WRITE
	DisplayFloat _a 2
	newLine 1
	;WRITE
	displayString cte24
	newLine 1
	jmp ETIQUETA262
ETIQUETA150:
	;WRITE
	displayString cte25
	newLine 1
	;ASIGNACIÓN
	fld &cte8
	fstp @aux26
	;ASIGNACIÓN
	fld &cte1
	fstp @aux27
	;CMP
	fld @aux26
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA184
	;CMP
	fld @aux26
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA184
	;ASIGNACIÓN
	fld @aux26
	fstp @aux27
ETIQUETA169:
	;RESTA
	fld @aux26
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux26
	;MULTIPLICACION
	fld @aux27
	fld @aux26
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux27
	;CMP
	fld &cte1
	fld @aux26
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA169
ETIQUETA184:
	;ASIGNACIÓN
	fld @aux27
	fstp _b
	;WRITE
	DisplayFloat _b 2
	newLine 1
	;WRITE
	displayString cte24
	newLine 1
	;WRITE
	displayString cte28
	newLine 1
	;ASIGNACIÓN
	fld &cte0
	fstp @aux29
	;ASIGNACIÓN
	fld &cte1
	fstp @aux30
	;CMP
	fld @aux29
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA223
	;CMP
	fld @aux29
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA223
	;ASIGNACIÓN
	fld @aux29
	fstp @aux30
ETIQUETA208:
	;RESTA
	fld @aux29
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux29
	;MULTIPLICACION
	fld @aux30
	fld @aux29
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux30
	;CMP
	fld &cte1
	fld @aux29
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA208
ETIQUETA223:
	;ASIGNACIÓN
	fld @aux30
	fstp @aux31
	;ASIGNACIÓN
	fld &cte1
	fstp @aux32
	;CMP
	fld @aux31
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA256
	;CMP
	fld @aux31
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf
	je ETIQUETA256
	;ASIGNACIÓN
	fld @aux31
	fstp @aux32
ETIQUETA241:
	;RESTA
	fld @aux31
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp @aux31
	;MULTIPLICACION
	fld @aux32
	fld @aux31
	fmul
	fstp @aux3
	;ASIGNACIÓN
	fld @aux3
	fstp @aux32
	;CMP
	fld &cte1
	fld @aux31
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA241
ETIQUETA256:
	;ASIGNACIÓN
	fld @aux32
	fstp _arbol
	;WRITE
	DisplayFloat _arbol 2
	newLine 1
	;WRITE
	displayString cte24
	newLine 1
ETIQUETA262:
	;RESTA
	fld _d
	fld &cte1
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp _d
	;CMP
	fld &cte33
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf
	jne ETIQUETA276
ETIQUETA272:
	;ASIGNACIÓN
	fld &cte0
	fstp _b
ETIQUETA276:
	;CMP
	fld &cte1
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf
	jae ETIQUETA9
ETIQUETA281:
ETIQUETA282:
	displayString cte5
	newLine 1
	getChar

TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END START;final del archivo.