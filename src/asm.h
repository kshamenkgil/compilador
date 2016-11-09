#ifndef ASM_H
#define ASM_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "constantes.h"
#include "pila.h"
#include "Terceto.h"
#include "tablaSimbolos.h"

void generarEncabezado();
void generarFin();
void generarDatos();
void generarCodigo(lista_tercetos_t *);
void generarASM(lista_tercetos_t *, int);
void imprimirInstrucciones(terceto_t, int);
void imprimirFuncString();

#endif