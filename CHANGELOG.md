# CAMBIOS
* Fix del sintactico en la regla linea_dec_var decía DOS_PUNTOS en vez de DOSPUNTOS.
* Cambio de nombre del archivo Declares.h a constantes.h
* Fix tokens PR_READ y PR_WRITE, en el síntactico dcían get y put. También estan asi como regla en el léxico, pero no pasa nada.
* Fin token CONCAT
* Fix conio.h para linux
* Fix ; faltantes
* Arreglar condiciones y saltos. DONE
* Verificar repeticiones. DONE
* VER que onda con el tema de que puedo poner un id en cualquier lado sin antes haberlo declarado. DONE
* Funciones especiales. DONE
* Agregar NOT expresion. DONE
* Agregar constante 0 y 1 al prinicipio del programa. DONE
* Fix generar tercetos asignaciones. DONE
* Fix no agregar mil veces las constantes a la TS. DONE
* Fix en CONST_INT y CONST_FLOAT devuelvo posicion de la constante en la TS. DONE
* Fix en constantes string guardaba con "". DONE
* Ahora a las constantes string las precede un # en lugar de un @, el @ es para las variables auxiliares. DONE
* Generar tercetos de funcion especial FACTORIAL. DONE
* Arreglar TS, imprime vacíos. DONE
* VERIFICAR QUE EN LAS CTES STRING EN LOS ESPACIOS LE CLAVA DONE
* Verificación de tipos. DONE
* Hacer bat que compile asm. DONE
* Generación de asm. DONE    
    * Generación de concatenaciones. DONE
    * Poner los macros de concatenación junto con el resto. DONE
    * Generación de READS. DONE
    * Generación de saltos. DONE
    * Generación de WRITES. DONE
    * Generación de CMP. DONE
    * Generación de operaciones aritméticas. DONE    
    * Ver como se incluyen los macros en asm. DONE
    * Ver si los @, #, etc, se usan para direccionamiento o no joden. DONE
