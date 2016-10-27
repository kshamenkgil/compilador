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
	_asd dd 0.000000
	_a dd 0.000000
	_b dd 0.000000
	_jorge db MAXTEXTSIZE dup(?), '$'
	_p1 dd 0.0000000000
	_p2 dd 0.0000000000
	&cte10 dd 3.000000
	%cte11 db "Hola", '$', 46 dup(?)
	&cte12 dd 2.000000

.CODE ;Comienzo de la zona de codigo
	mov AX,@DATA ;Inicializa el segmento de datos
	mov DS,AX

START: ;Código assembler resultante de compilar el programa fuente.
		
TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END ;final del archivo.