#ifndef ASM_H
#define ASM_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "constantes.h"
#include "pila.h"
#include "tablaSimbolos.h"

FILE * pfASM; //Final.asm

void generarEncabezado();
void generarFin();
void generarDatos();
void generarCodigo();
void generarASM();

#endif