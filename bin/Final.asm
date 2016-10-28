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
	_asd dd 0.000000
	_a dd 0.000000
	_b dd 0.000000
	_jorge db MAXTEXTSIZE dup(?), '$'
	_p1 dd 0.0000000000
	_p2 dd 0.0000000000
	&cte5 dd 3.000000
	$cte6 dd 5.4000000000
	cte7 db "Valor_de_A", '$', 40 dup(?)
	&cte8 dd 2.000000
	&cte9 dd 9.000000
	&cte10 dd 8.000000
	cte11 db "Valor_de_p2", '$', 39 dup(?)
	cte12 db "Valor_de_b", '$', 40 dup(?)
	cte13 db "Valor_de_p1", '$', 39 dup(?)

.CODE ;Comienzo de la zona de codigo
START: ;Código assembler resultante de compilar el programa fuente.
	mov AX,@DATA ;Inicializa el segmento de datos
	mov DS,AX
	finit
	;ASIGNACIÓN
	fld &cte5
	fstp _a
	;ASIGNACIÓN
	fld $cte6
	fstp _b
	;CMP
	fld _a
	fld &cte5
	fcomp
	fstsw ax
	fwait
	sahf
	;CMP
	fld _b
	fld &cte5
	fcomp
	fstsw ax
	fwait
	sahf
	;WRITE
	displayString cte7
	newLine 1
	;WRITE
	DisplayFloat _a 2
	newLine 1
	;SUMA
	fld _a
	fld _b
	fadd
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp _b
	;CMP
	fld _b
	fld &cte8
	fcomp
	fstsw ax
	fwait
	sahf
	;RESTA
	fld &cte9
	fld &cte10
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp _p2
	;MULTIPLICACION
	fld &cte8
	fld &cte8
	fmul
	fstp @aux3
	;DIVISION
	fld @aux3
	fld &cte8
	fdiv
	fstp @aux3
	;RESTA
	fld &cte9
	fld @aux3
	fsub
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp _p1
	;WRITE
	displayString cte11
	newLine 1
	;WRITE
	DisplayFloat _p2 2
	newLine 1
	;WRITE
	displayString cte12
	newLine 1
	;WRITE
	DisplayFloat _b 2
	newLine 1
	;WRITE
	displayString cte13
	newLine 1
	;WRITE
	DisplayFloat _p1 2
	newLine 1

TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END START;final del archivo.