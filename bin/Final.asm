;
;ARCHIVO FINAL.ASM
;

.MODEL LARGE ; tipo del modelo de memoria usado.
.386
.STACK 200h ; bytes en el stack

.DATA ; comienzo de la zona de datos.

;
;Declaración de todas las variables.
;

.CODE; comienzo de la zona de codigo

mov AX,@DATA ; inicializa el segmento de datos
mov DS,AX

;
;Código assembler resultante de compilar el programa fuente.
;

;
;Fin de ejecución.
;

mov ax, 4C00h ; termina la ejecución.
int 21h; syscall
END ;final del archivo.