;
;ARCHIVO FINAL.ASM
;

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
	$cte25 dd 5.4500000000
	&cte26 dd 20.000000
	@aux27 dd 0.0000000000
	@aux28 dd 0.0000000000
	&cte29 dd 5.000000
	@aux30 dd 0.0000000000
	&cte31 dd 4.000000
	@aux32 dd 4.0000000000

.CODE ;Comienzo de la zona de codigo
	mov AX,@DATA ;Inicializa el segmento de datos
	mov DS,AX

START: ;Código assembler resultante de compilar el programa fuente.
																																			
TERMINAR: ;Fin de ejecución.
	mov ax, 4C00h ; termina la ejecución.
	int 21h; syscall

END ;final del archivo.