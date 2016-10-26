#ifndef TS_H
#define TS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "constantes.h"

typedef struct tablaS {
       char nombre [100]; //si el nombre le precede un "_" entonces es una variable, si tiene $ entonces es real y si tiene & es int,    
                          //si tiene un # es una cte string.
       int tipo; // 0 es palabra reservada, 1 es variable, 2 constante
       double valor;
       int longitud;
       char valorString [COTA_STR]; /*Guarda valor de las variables tipo string. De no ser un string guarda un "-"*/
}TS;

TS getItemTS(int);

int getTopeTS();

int agregarTokenTS(char *, char *, int, int, double);

void agregarTipoIDaTS(char *n,int type);

int existeTokenEnTS(char*, int);

void armarValorYNombreToken(char*, char*);

void imprimirTabla();

//para ver si existe la constante float
int existeCteFloat(double);

//para constantes float
int findFloatTS(int);

//para ver si existe la constante string
int existeCteString(int);

//para constantes string
int findNombreTS(int);

//para tokens id
int findAuxTS(int);

//para tokens id
int findIdTS(int);

void ObtenerItemTS(int, TS *);

#endif