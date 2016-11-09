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
	_g db MAXTEXTSIZE dup(?), '$'
	_h db MAXTEXTSIZE dup(?), '$'
	_i db MAXTEXTSIZE dup(?), '$'
	_v4r14bl3 dd 0.000000
	_a19 dd 0.0000000000
	_x dd 0.0000000000
	&cte6 dd 9.000000
	&cte7 dd 8.000000
	&cte8 dd 5.000000
	cte9 db "ERROR", '$', 45 dup(?)
	cte10 db "COMBINATORIO DE 9 y 8", '$', 29 dup(?)
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
	@aux24 dd 0.0000000000
	cte25 db " ", '$', 49 dup(?)
	cte26 db "FACTORIAL de 5", '$', 36 dup(?)
	@aux27 dd 0.0000000000
	@aux28 dd 0.0000000000
	cte29 db "FACTORIAL de FACTORIAL de 0", '$', 23 dup(?)
	@aux30 dd 0.0000000000
	@aux31 dd 0.0000000000
	@aux32 dd 0.0000000000
	@aux33 dd 0.0000000000
	&cte34 dd 2.000000

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
	mov ax,@DATA
	mov es,ax
	mov si,OFFSET &cte8 ;apunta el origen al auxiliar
	mov di,OFFSET _g ;apunta el destino a la cadena
	call COPIAR ;copia los string

	;ASIGNACIÓN
	fld cte9
	fstp _d

ETIQUETA12:
	;CMP
	fld _b
	fld _a
	fcomp
	fstsw ax
	fwait
	sahf

	jbe ETIQUETA153
ETIQUETA17:
	;CMP
	fld &cte0
	fld _b
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA153
ETIQUETA22:
	;WRITE
	displayString cte10
	newLine 1

	;ASIGNACIÓN
	fld &cte6
	fstp @aux12

	;ASIGNACIÓN
	fld @aux12
	fstp @aux11

	;ASIGNACIÓN
	fld &cte1
	fstp @aux13

	;CMP
	fld @aux11
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA59
	;CMP
	fld @aux11
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA59
	;ASIGNACIÓN
	fld @aux11
	fstp @aux13

ETIQUETA44:
	;RESTA
	fld @aux11
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux11

	;MULTIPLICACION
	fld @aux13
	fld @aux11
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux13

	;CMP
	fld &cte1
	fld @aux11
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA44
ETIQUETA59:
	;ASIGNACIÓN
	fld @aux13
	fstp @aux14

	;ASIGNACIÓN
	fld _b
	fstp @aux15

	;RESTA
	fld @aux12
	fld @aux15
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux18

	;ASIGNACIÓN
	fld @aux18
	fstp @aux16

	;ASIGNACIÓN
	fld &cte1
	fstp @aux17

	;CMP
	fld @aux16
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA103
	;CMP
	fld @aux16
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA103
	;ASIGNACIÓN
	fld @aux16
	fstp @aux17

ETIQUETA88:
	;RESTA
	fld @aux16
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux16

	;MULTIPLICACION
	fld @aux17
	fld @aux16
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux17

	;CMP
	fld &cte1
	fld @aux16
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA88
ETIQUETA103:
	;ASIGNACIÓN
	fld @aux17
	fstp @aux20

	;ASIGNACIÓN
	fld &cte1
	fstp @aux21

	;CMP
	fld @aux15
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA136
	;CMP
	fld @aux15
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA136
	;ASIGNACIÓN
	fld @aux15
	fstp @aux21

ETIQUETA121:
	;RESTA
	fld @aux15
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux15

	;MULTIPLICACION
	fld @aux21
	fld @aux15
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux21

	;CMP
	fld &cte1
	fld @aux15
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA121
ETIQUETA136:
	;ASIGNACIÓN
	fld @aux21
	fstp @aux22

	;MULTIPLICACION
	fld @aux17
	fld @aux22
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux23

	;DIVISION
	fld @aux14
	fld @aux23
	fdiv
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp _a

	;WRITE
	DisplayFloat _a 2
	newLine 1

	;WRITE
	displayString cte25
	newLine 1

	jmp ETIQUETA265
ETIQUETA153:
	;WRITE
	displayString cte26
	newLine 1

	;ASIGNACIÓN
	fld &cte8
	fstp @aux27

	;ASIGNACIÓN
	fld &cte1
	fstp @aux28

	;CMP
	fld @aux27
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA187
	;CMP
	fld @aux27
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA187
	;ASIGNACIÓN
	fld @aux27
	fstp @aux28

ETIQUETA172:
	;RESTA
	fld @aux27
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux27

	;MULTIPLICACION
	fld @aux28
	fld @aux27
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux28

	;CMP
	fld &cte1
	fld @aux27
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA172
ETIQUETA187:
	;ASIGNACIÓN
	fld @aux28
	fstp _b

	;WRITE
	DisplayFloat _b 2
	newLine 1

	;WRITE
	displayString cte25
	newLine 1

	;WRITE
	displayString cte29
	newLine 1

	;ASIGNACIÓN
	fld &cte0
	fstp @aux30

	;ASIGNACIÓN
	fld &cte1
	fstp @aux31

	;CMP
	fld @aux30
	fld &cte1
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA226
	;CMP
	fld @aux30
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA226
	;ASIGNACIÓN
	fld @aux30
	fstp @aux31

ETIQUETA211:
	;RESTA
	fld @aux30
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp @aux30

	;MULTIPLICACION
	fld @aux31
	fld @aux30
	fmul
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux31

	;CMP
	fld &cte1
	fld @aux30
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA211
ETIQUETA226:
	;ASIGNACIÓN
	fld @aux31
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

	je ETIQUETA259
	;CMP
	fld @aux32
	fld &cte0
	fcomp
	fstsw ax
	fwait
	sahf

	je ETIQUETA259
	;ASIGNACIÓN
	fld @aux32
	fstp @aux33

ETIQUETA244:
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
	fstp @aux3

	;ASIGNACIÓN
	fld @aux3
	fstp @aux33

	;CMP
	fld &cte1
	fld @aux32
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA244
ETIQUETA259:
	;ASIGNACIÓN
	fld @aux33
	fstp _f

	;WRITE
	DisplayFloat _f 2
	newLine 1

	;WRITE
	displayString cte25
	newLine 1

ETIQUETA265:
	;RESTA
	fld _d
	fld &cte1
	fsub
	fstp @aux2

	;ASIGNACIÓN
	fld @aux2
	fstp _d

	;CMP
	fld &cte34
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf

	jne ETIQUETA279
ETIQUETA275:
	;ASIGNACIÓN
	fld &cte0
	fstp _b

ETIQUETA279:
	;CMP
	fld &cte1
	fld _d
	fcomp
	fstsw ax
	fwait
	sahf

	jae ETIQUETA12
ETIQUETA284:
ETIQUETA285:
	displayString cte5
	newLine 1
	getChar

TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END START;final del archivo.