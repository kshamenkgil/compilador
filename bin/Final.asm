;
;ARCHIVO FINAL.ASM
;

INCLUDE macros2.asm		 ;incluye macros
INCLUDE number.asm		 ;incluye el asm para impresion de numeros
INCLUDE string.asm		 ;incluye el asm para manejo de strings

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
	_asd dd 0.000000
	_a dd 0.000000
	_b dd 0.000000
	_jorge db MAXTEXTSIZE dup(?), '$'
	_p1 dd 0.0000000000
	_p2 dd 0.0000000000
	&cte6 dd 2.000000
	&cte7 dd 22.000000
	&cte8 dd 33.000000
	&cte9 dd 28.000000
	&cte10 dd 9.000000

.CODE ;Comienzo de la zona de codigo
START: ;Código assembler resultante de compilar el programa fuente.
	mov AX,@DATA ;Inicializa el segmento de datos
	mov DS,AX
	finit
	;ASIGNACIÓN
	fld &cte6
	fstp _p1
	;READ
	GetFloat _a
	;READ
	getString _jorge
	;WRITE
	displayString _jorge
	newLine 1
	;SUMA
	fld &cte8
	fld &cte7
	fadd
	fstp @aux2
	;SUMA
	fld &cte9
	fld @aux2
	fadd
	fstp @aux2
	;SUMA
	fld _a
	fld @aux2
	fadd
	fstp @aux2
	;MULTIPLICACION
	fld &cte7
	fld _p1
	fmul
	fstp @aux3
	;DIVISION
	fld @aux3
	fld &cte10
	fdiv
	fstp @aux3
	;SUMA
	fld @aux3
	fld @aux2
	fadd
	fstp @aux2
	;ASIGNACIÓN
	fld @aux2
	fstp _asd
	;WRITE
	DisplayFloat _asd 2
	newLine 1
ETIQUETA22:
	displayString cte5
	newLine 1
	getChar

TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END START;final del archivo.