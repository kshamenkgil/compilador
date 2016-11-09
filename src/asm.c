#include "asm.h"

FILE * pfASM; //Final.asm
t_pila pila;  //Pila saltos
t_pila pVariables;  //Pila variables
int cFlag = 0;

void generarASM(lista_tercetos_t * lTercetos, int concatFlag){ //concatFlag se utiliza para ver si escribo las funciones de manejo de string
    //Abrir archivo
    
    if(!(pfASM = fopen("bin/Final.asm","wt+"))){
        if(!(pfASM = fopen("Final.asm","wt+"))){
            informeError("Error al crear el archivo Final.asm, verifique los permisos de escritura.");
    }        

    //Crear pilas para sacar los tercetos.
    crear_pila(&pila);
    crear_pila(&pVariables);

    //Copiar tercetos
    //lista_terceto = &lTercetos;

    //Imprimo func de strings?
    cFlag = concatFlag; 

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
    //fprintf(pfASM, "INCLUDE string.asm\t\t ;incluye el asm para manejo de strings\n");    		 
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
                if(strcmp(elemento.nombre,"@aux4STR") == 0){ //variable aux para strings.
                    fprintf(pfASM, "\t%s db MAXTEXTSIZE dup(?), '$'\n", elemento.nombre, elemento.valorString, (COTA_STR - elemento.longitud));
                    break;                
                }
                fprintf(pfASM, "\t");
                fprintf(pfASM, "%s dd %.10f\n",elemento.nombre,elemento.valor);
                break;
        }
    }    
}

void imprimirFuncString(){
    if(!cFlag)
        return;
    
    int c;
    FILE *file;
    file = fopen("bin/string.asm", "r");
    if (file) {
        fprintf(pfASM,"\n");
        while ((c = getc(file)) != EOF)
            fprintf(pfASM,"%c",c);
        fprintf(pfASM,"\n\n");
        fclose(file);
    }else{        
        file = fopen("string.asm", "r");
        if (file) {
            fprintf(pfASM,"\n");
            while ((c = getc(file)) != EOF)
                fprintf(pfASM,"%c",c);
            fprintf(pfASM,"\n\n");
            fclose(file);
        }else{
            informeError("Error no se puede abrir string.asm");
        }
    }

}

void generarCodigo(lista_tercetos_t * lTercetos){
    
    t_node *act = *lTercetos;
	terceto_t terc;
    int i = 0;

    //Encabezado del sector de codigo
    fprintf(pfASM, "\n.CODE ;Comienzo de la zona de codigo\n");

    //Imprimo funciones de manejo de strings
    imprimirFuncString();

    //Inicio codigo usuario
    fprintf(pfASM, "START: ;Código assembler resultante de compilar el programa fuente.\n");
    fprintf(pfASM, "\tmov AX,@DATA ;Inicializa el segmento de datos\n");
    fprintf(pfASM, "\tmov DS,AX\n");
    fprintf(pfASM, "\tfinit\n\n");

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
    char tConst,tConst2;
    char aux[STR_VALUE];
    char aux2[STR_VALUE] = "";
    char last[STR_VALUE] = "";
    char concat[STR_VALUE];
    TS simbolo,simbolo2;
    int pos;
    //Verificar operación e imprimir instrucciones. 
    switch(terc.operacion){
        case TERC_ASIG:
            fprintf(pfASM,"\t;ASIGNACIÓN\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                pos = existeTokenEnTS(aux,VRBL);
                ObtenerItemTS(pos,&simbolo);
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    if(strcmp(aux2,"@aux4STR") == 0){                               	                    
                        fprintf(pfASM, "\tmov ax,@DATA\n");
                        fprintf(pfASM, "\tmov es,ax\n");
                        fprintf(pfASM, "\tmov si,OFFSET %s ;apunta el origen al auxiliar\n",aux2);
                        fprintf(pfASM, "\tmov di,OFFSET %s ;apunta el destino a la cadena\n",aux);
                        fprintf(pfASM, "\tcall COPIAR ;copia los string\n\n");
                    }else if(simbolo.tipo == CTE_STR){
                        fprintf(pfASM, "\tmov ax,@DATA\n");
                        fprintf(pfASM, "\tmov es,ax\n");
                        fprintf(pfASM, "\tmov si,OFFSET %s ;apunta el origen al auxiliar\n",aux2);
                        fprintf(pfASM, "\tmov di,OFFSET %s ;apunta el destino a la cadena\n",aux);
                        fprintf(pfASM, "\tcall COPIAR ;copia los string\n\n");
                    }else{
                        fprintf(pfASM, "\tfld %s\n",aux2);
                        fprintf(pfASM, "\tfstp %s\n\n",aux);
                    }
                }
            }            
            break;
        case TERC_CMP:
            fprintf(pfASM,"\t;CMP\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM, "\tfld %s\n",aux);
                    fprintf(pfASM, "\tfld %s\n",aux2);                    
                    fprintf(pfASM, "\tfcomp\n");
                    fprintf(pfASM, "\tfstsw ax\n");
                    fprintf(pfASM, "\tfwait\n");
                    fprintf(pfASM, "\tsahf\n\n");                            
                }
            }            
            break;
        case TERC_ETIQ:
            sprintf(aux,"ETIQUETA%d:",nTerc);                            
            fprintf(pfASM,"ETIQUETA%d:\n",nTerc);                
            strcpy(last,aux);            
            break;
        case TERC_JMP:
            sprintf(aux,"ETIQUETA%d", terc.opIzq);
            fprintf(pfASM, "\tjmp %s\n",aux);
            break;
        case TERC_JE:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tje %s\n",aux);
            break;
        case TERC_JNE:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tjne %s\n",aux);
            break;
        case TERC_JB:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tjb %s\n",aux);
            break;
        case TERC_JBE:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tjbe %s\n",aux);
            break;   
        case TERC_JA:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tja %s\n",aux);
            break;                             
        case TERC_JAE:
            sprintf(aux,"ETIQUETA%d", terc.opDer);
            fprintf(pfASM, "\tjae %s\n",aux);      
            break;
        case TERC_RESTA:
            fprintf(pfASM,"\t;RESTA\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM, "\tfld %s\n",aux2);
                    fprintf(pfASM, "\tfld %s\n",aux);                   
                    fprintf(pfASM, "\tfsub\n");
                    //fprintf(pfASM, "\tlocal %s\n",aux); // Variable local en vez de los aux de arriba

                    //guardar valor en aux
                    if(strcmp(aux,"@aux2") == 0){
                        fprintf(pfASM, "\tfstp @aux3\n\n");                    
                        poner_en_pila(&pVariables,"@aux3",255);
                    }else{
                        fprintf(pfASM, "\tfstp @aux2\n\n");                    
                        poner_en_pila(&pVariables,"@aux2",255);
                    }
                }                
            }                        
            break;        
        case TERC_SUMA:
            fprintf(pfASM,"\t;SUMA\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM, "\tfld %s\n",aux);
                    fprintf(pfASM, "\tfld %s\n",aux2);
                    fprintf(pfASM, "\tfadd\n");
                    //fprintf(pfASM, "\tlocal %s\n",aux); // Variable local en vez de los aux de arriba

                    //guardar valor en aux
                    if(strcmp(aux,"@aux2") == 0){
                        fprintf(pfASM, "\tfstp @aux3\n\n");                    
                        poner_en_pila(&pVariables,"@aux3",255);
                    }else{
                        fprintf(pfASM, "\tfstp @aux2\n\n");                    
                        poner_en_pila(&pVariables,"@aux2",255);
                    }
                }                
            }     
                                 
            break;
        case TERC_MULT:
            fprintf(pfASM,"\t;MULTIPLICACION\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM, "\tfld %s\n",aux);
                    fprintf(pfASM, "\tfld %s\n",aux2);
                    fprintf(pfASM, "\tfmul\n");
                    //fprintf(pfASM, "\tlocal %s\n",aux); // Variable local en vez de los aux de arriba

                    //guardar valor en aux
                    if(strcmp(aux,"@aux2") == 0){
                        fprintf(pfASM, "\tfstp @aux3\n\n");                    
                        poner_en_pila(&pVariables,"@aux3",255);
                    }else{
                        fprintf(pfASM, "\tfstp @aux2\n\n");                    
                        poner_en_pila(&pVariables,"@aux2",255);
                    }
                }                
            }  
            break;
        case TERC_DIV:
            fprintf(pfASM,"\t;DIVISION\n");
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM, "\tfld %s\n",aux2);
                    fprintf(pfASM, "\tfld %s\n",aux);
                    fprintf(pfASM, "\tfdiv\n");
                    //fprintf(pfASM, "\tlocal %s\n",aux); // Variable local en vez de los aux de arriba

                    //guardar valor en aux
                    if(strcmp(aux,"@aux2") == 0){
                        fprintf(pfASM, "\tfstp @aux3\n\n");                    
                        poner_en_pila(&pVariables,"@aux3",255);
                    }else{
                        fprintf(pfASM, "\tfstp @aux2\n\n");                    
                        poner_en_pila(&pVariables,"@aux2",255);
                    }
                }                
            }  
            break;
        case TERC_CONCAT:            
            if(sacar_de_pila(&pVariables,aux,255) != PILA_VACIA)
            {
                if(sacar_de_pila(&pVariables,aux2,255) != PILA_VACIA)
                {
                    fprintf(pfASM,"\t;CONCATENACIÓN\n");
                    fprintf(pfASM, "\tmov ax,@DATA\n");
                    fprintf(pfASM, "\tmov es,ax\n");
                    fprintf(pfASM, "\tmov si,OFFSET %s ;apunta el origen a la primer cadena\n",aux2);
                    fprintf(pfASM, "\tmov di,OFFSET @aux4STR ;apunta el destino al auxiliar\n");
                    fprintf(pfASM, "\tcall COPIAR ;copia los string\n\n");

                    fprintf(pfASM, "\tmov ax,@DATA\n");
                    fprintf(pfASM, "\tmov es,ax\n");
                    fprintf(pfASM, "\tmov si,OFFSET %s ;apunta el origen a la segunda cadena\n",aux);
                    fprintf(pfASM, "\tmov di,OFFSET @aux4STR ;concatena los string\n");
                    fprintf(pfASM, "\tcall CONCAT\n\n");

                    poner_en_pila(&pVariables,"@aux4STR",255);
                }
            }
            break;
        case TERC_WRITE:            
            sprintf(aux,"%s",terc.opIzq);            
            fprintf(pfASM,"\t;WRITE\n");
            tConst = aux[0];
            switch(tConst){                
                case '_':
                    pos = existeTokenEnTS(terc.opIzq,VRBL);
                    ObtenerItemTS(pos,&simbolo);
                    switch(simbolo.tipo){
                        case CTE_STR:
                            fprintf(pfASM,"\tdisplayString %s\n",aux);
                            fprintf(pfASM, "\tnewLine 1\n\n");
                            break;
                        default:
                            fprintf(pfASM,"\tDisplayFloat %s 2\n",aux);
                            fprintf(pfASM, "\tnewLine 1\n\n");
                            break;
                    }
                    break;
                case '&':
                    fprintf(pfASM,"\tDisplayInteger %s 2\n",aux);
                    fprintf(pfASM, "\tnewLine 1\n\n");                    
                    break;
                case '$':
                    fprintf(pfASM,"\tDisplayFloat %s 2\n",aux);
                    fprintf(pfASM, "\tnewLine 1\n\n");                    
                    break;
                case '@':
                    fprintf(pfASM,"\tDisplayFloat %s 2\n",aux);
                    fprintf(pfASM, "\tnewLine 1\n\n");                
                    break;                
                default:
                    fprintf(pfASM,"\tdisplayString %s\n",aux);
                    fprintf(pfASM, "\tnewLine 1\n\n");
                    break;
            }                        
            break;
        case TERC_READ:
            sprintf(aux,"%s",terc.opIzq);
            fprintf(pfASM,"\t;READ\n");
            pos = existeTokenEnTS(terc.opIzq,VRBL);
            ObtenerItemTS(pos,&simbolo);
            switch(simbolo.tipo){
                case CTE_STR:
                    fprintf(pfASM,"\tgetString %s\n\n",aux);
                    break;
                default:
                    fprintf(pfASM,"\tGetFloat %s\n\n",aux);
                    break;
            }             
            break;
        case TERC_END:
            sprintf(aux,"ETIQUETA%d:",nTerc);                            
            fprintf(pfASM,"ETIQUETA%d:\n",nTerc);                
            strcpy(last,aux);            
            fprintf(pfASM,"\tdisplayString cte5\n");
            fprintf(pfASM,"\tnewLine 1\n");
            fprintf(pfASM,"\tgetChar\n");
            break;        
        default:
            sprintf(aux,"%s",terc.operacion);            
            poner_en_pila(&pVariables,&aux,255);
            break;
    }
}

void generarFin(){
    //Fin de ejecución
    //fprintf(pfASM, "\n;\n");
    fprintf(pfASM, "\nTERMINAR: ;Fin de ejecución.\n");

    fprintf(pfASM, "\tmov ax, 4C00h ; termina la ejecución.\n");
    fprintf(pfASM, "\tint 21h; syscall\n");
    fprintf(pfASM, "\nEND START;final del archivo.");    
}