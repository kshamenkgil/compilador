#include "asm.h"

FILE * pfASM; //Final.asm
t_pila pila;  //Pila saltos

void generarASM(lista_tercetos_t * lTercetos){
    //Abrir archivo
    
    if(!(pfASM = fopen("bin/Final.asm","wt+"))){
        informeError("Error al crear el archivo Final.asm, verifique los permisos de escritura.");
    }        

    //Crear pila para sacar los tercetos.
    crear_pila(&pila);

    //Copiar tercetos
    //lista_terceto = &lTercetos;

    //Generar archivo ASM
    fprintf(pfASM, ";\n;ARCHIVO FINAL.ASM\n;\n");

    generarEncabezado();
    generarDatos();    
    generarCodigo(lTercetos);    
    generarFin();

    //Cerrar archivo
    fclose(pfASM);
}

void generarEncabezado(){
    //Encabezado del archivo
    fprintf(pfASM, "\nINCLUDE macros2.asm\t\t ;incluye macros\n");
    fprintf(pfASM, "INCLUDE number.asm\t\t ;incluye el asm para impresion de numeros\n");
    fprintf(pfASM, "\n.MODEL LARGE ; tipo del modelo de memoria usado.\n");
    fprintf(pfASM, ".386\n");
    fprintf(pfASM, ".STACK 200h ; bytes en el stack\n");              
}

/*
typedef struct tablaS {
       char nombre [100]; //si el nombre le precede un "_" entonces es una variable, si tiene $ entonces es real y si tiene & es int,    
                          //si tiene un # es una cte string.
       int tipo; // 0 es palabra reservada, 1 es variable, 2 constante
       double valor;
       int longitud;
       char valorString [COTA_STR];
}TS;
*/
void generarDatos(){
    int i = 0;
    TS elemento;
    char aux[STR_VALUE];
    //Encabezado del sector de datos
    fprintf(pfASM, "\t\n.DATA ; comienzo de la zona de datos.\n");    
    fprintf(pfASM, "\tTRUE equ 1\n");
    fprintf(pfASM, "\tFALSE equ 0\n");
    fprintf(pfASM, "\tMAXTEXTSIZE equ %d\n",COTA_STR);
    

    //Recorrer tabla de simbolos y armar el sector .data
    for(i = 0; i < getTopeTS(); i++){
        elemento = getItemTS(i);        
        switch(elemento.tipo){                        
            case CTE_INT:
                fprintf(pfASM, "\t");            
                fprintf(pfASM, "%s dd %.6f\n",elemento.nombre,elemento.valor);        
                break;
            case CTE_STR:
                fprintf(pfASM, "\t");
                if(strcmp(elemento.valorString,"-") == 0)
                    fprintf(pfASM, "%s db MAXTEXTSIZE dup(?), '$'\n", elemento.nombre, elemento.valorString, (COTA_STR - elemento.longitud));
                else
                    fprintf(pfASM, "%s db \"%s\", '$', %d dup(?)\n", elemento.nombre, elemento.valorString, (COTA_STR - elemento.longitud));
                break;
            case CTE_FLT:
                fprintf(pfASM, "\t");
                fprintf(pfASM, "%s dd %.10f\n",elemento.nombre,elemento.valor);
                break;
            case VRBL_AUX:
                fprintf(pfASM, "\t");
                fprintf(pfASM, "%s dd %.10f\n",elemento.nombre,elemento.valor);
                break;
        }
    }    
}

void generarCodigo(lista_tercetos_t * lTercetos){    
    t_node *act = *lTercetos;
	terceto_t terc;
    int i = 0;

    //Encabezado del sector de codigo
    fprintf(pfASM, "\n.CODE ;Comienzo de la zona de codigo\n");
    fprintf(pfASM, "\tmov AX,@DATA ;Inicializa el segmento de datos\n");
    fprintf(pfASM, "\tmov DS,AX\n");    
    fprintf(pfASM, "\nSTART: ;Código assembler resultante de compilar el programa fuente.\n");    

    //Recorrer e imprimir assembler
    if(act)
	{        
        //Rebobinar lista
		while(act->ant)
			act = act->ant;

        //Recorrer lista            
		while(act)
		{
			terc = act->info;                
            //Imprimir assembler            
            imprimirInstrucciones(terc,i);

            //Pasar al siguiente terceto
            act = act->sig;
            i++;
        }                
    }

}

/*
typedef struct
{	
	int operacion;
	int	opIzq;
	int	opDer;
} terceto_t;
*/
void imprimirInstrucciones(terceto_t terc, int nTerc){
    
    //Verificar operación e imprimir instrucciones. 
    switch(terc.operacion){
        case TERC_ASIG:        
            fprintf(pfASM, "\t");
            break;
    }
}

void generarFin(){
    //Fin de ejecución
    //fprintf(pfASM, "\n;\n");
    fprintf(pfASM, "\nTERMINAR: ;Fin de ejecución.\n");

    fprintf(pfASM, "\tmov ax, 4C00h ; termina la ejecución.\n");
    fprintf(pfASM, "\tint 21h; syscall\n");
    fprintf(pfASM, "\nEND ;final del archivo.");    
}