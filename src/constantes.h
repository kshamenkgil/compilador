#ifndef CONSTANTES_H
#define CONSTANTES_H

//Cotas de Datos
#define STR_VALUE 255
#define COTA_STR 30
#define COTA_CTE 65535
#define COTA_REAL 9999999.9999999999
#define COTA_ID 30

//Tipos de Elementos en Tabla de Simbolos
#define PR 0
#define VRBL 1
#define CTE_INT 2
#define CTE_FLT 3
#define CTE_STR 4
#define VRBL_AUX 5

//Variable para debug
#define DEBUG 0

/*Tamaño de la tabla de simbolos*/
#define MAX_TS 1000

//Cantidad Total de Palabras Reservadas
#define TOTAL_PR 18

typedef struct tablaS {
       char nombre [100]; //si el nombre le precede un "_" entonces es una variable, si tiene $ entonces es real y si tiene & es int,    
                          //si tiene un # es una cte string.
       int tipo; // 0 es palabra reservada, 1 es variable, 2 constante
       double valor;
       int longitud;
       char valorString [COTA_STR]; /*Guarda valor de las variables tipo string. De no ser un string guarda un "-"*/
}TS;

#endif
