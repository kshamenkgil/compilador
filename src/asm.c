#include "asm.h"

void generarASM(){
    //Abrir archivo
    if(!(pfASM = fopen("bin/Final.asm","wt+"))){
        informeError("Error al crear el archivo Final.asm, verifique los permisos de escritura.");
    }

    fprintf(pfASM, ";\n;ARCHIVO FINAL.ASM\n;\n");

    generarEncabezado();
    generarDatos();
    generarCodigo();
    generarFin();

}

void generarEncabezado(){
    //Encabezado del archivo    
    fprintf(pfASM, "\n.MODEL LARGE ; tipo del modelo de memoria usado.\n");
    fprintf(pfASM, ".386\n");
    fprintf(pfASM, ".STACK 200h ; bytes en el stack\n");                        
}

void generarDatos(){
    //Encabezado del sector de datos
    fprintf(pfASM, "\n.DATA ; comienzo de la zona de datos.\n");
    fprintf(pfASM, "\n;\n;Declaración de todas las variables.\n;\n");

    //Recorrer tabla de simbolos y armar el sector .data
    
}

void generarCodigo(){
    //Encabezado del sector de codigo
    fprintf(pfASM, "\n.CODE; comienzo de la zona de codigo\n");
    fprintf(pfASM, "\nmov AX,@DATA ; inicializa el segmento de datos\n");
    fprintf(pfASM, "mov DS,AX\n");    
    fprintf(pfASM, "\n;\n;Código assembler resultante de compilar el programa fuente.\n;\n");

    //GENERAR CODIGO ASSEMBLER        


}

void generarFin(){
    //Fin de ejecución
    fprintf(pfASM, "\n;\n;Fin de ejecución.\n;\n");
    fprintf(pfASM, "\nmov ax, 4C00h ; termina la ejecución.\n");
    fprintf(pfASM, "int 21h; syscall\n");
    fprintf(pfASM, "END ;final del archivo.");    
}