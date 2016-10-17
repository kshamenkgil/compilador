/******************************************************************************/
/******************************************************************************/
%{                
/******************************************************************************/
#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <iostream.h>
#include "files\lista.cpp"
#include "files\pila.cpp"
/******************************************************************************/
#define MAX_TABLA_SIMB 100
#define MAX_ID 32
#define MAX_CTE_DECIMAL 5
#define MAX_CTE_BINARIA 16
#define MAX_CTE_OCTAL 6
#define MAX_CTE_HEXA 4
#define MAX_CTE_DECIMAL_32 10
#define MAX_CTE_BINARIA_32 32
#define MAX_CTE_OCTAL_32 11
#define MAX_CTE_HEXA_32 8
#define MAX 32
/******************************************************************************/
typedef struct {
	char parametro_1[MAX];
  	char parametro_2[MAX];
  	char parametro_3[MAX];
}estructura_tercetos;
int cantidad_tercetos = 0;
estructura_tercetos tercetos;
Lista <estructura_tercetos> lista_tercetos;
/******************************************************************************/
typedef struct {
	char parametro[MAX];
}estructura_pila;
int cantidad_pila = 0;
estructura_pila pila;
Pila <estructura_pila> pila_tercetos;
/******************************************************************************/
typedef struct {
	char nombre[MAX_ID];
	int token;
}identificador;
identificador tablaDeIdentificadores[MAX_TABLA_SIMB];
int cantidadDeIdentificadores;
/******************************************************************************/
char id[MAX_ID];
int tamanio;
/******************************************************************************/
void Mostrar_lista_de_tercetos();
void poner_ctes_en_pila(unsigned long );
void crear_terceto_expresion(char[]);
void ifsimple_THEN_bloque();
/******************************************************************************/
int yylex();
int getEvento(char);
int initid(char);
int addId(char);
int finId(char);
int initCteD(char);
int addcteD(char);
int fincteD(char);
int initCteB(char);
int addcteB(char);
int fincteB(char);
int initCteO(char);
int addcteO(char);
int fincteO(char);
int initCteH(char);
int addcteH(char);
int fincteH(char);
int initCteD32(char);
int addcteD32(char);
int fincteD32(char);
int initCteB32(char);
int addcteB32(char);
int fincteB32(char);
int initCteO32(char);
int addcteO32(char);
int fincteO32(char);
int initCteH32(char);
int addcteH32(char);
int fincteH32(char);
int error(char);
int error_asig(char);
int error_cte(char);
int nada(char);
int menor_igual(char);
int menor(char);
int multiplicacion(char);
int suma(char);
int division(char);
int resta(char);
int distinto(char);
int igual(char);
int comienzo_bloque(char);
int fin_bloque(char);
int comienzo_parentesis(char);
int fin_parentesis(char);
int mayor_igual(char);
int asignacion(char);
int mayor(char);
int abrir_archivo();
int terminar(char);
int agregarEnTablaIdentificadores(int);
/******************************************************************************/
FILE *archivo; //global
/******************************************************************************/
int yyparse(void);
int yylex(void);
int yyerror(char *s);
/******************************************************************************/
%}
/******************************************************************************/
/******************************************************************************/
%token IF
%token THEN
%token ELSE
%token REPEAT
%token UNTIL
%token INT
%token LONGINT
%token IDENTIFICADOR
%token CONSTANTED
%token CONSTANTEB
%token CONSTANTEO
%token CONSTANTEH
%token CONSTANTED32
%token CONSTANTEB32
%token CONSTANTEO32
%token CONSTANTEH32
%token MULTIPLICACION
%token DIVISION
%token SUMA
%token RESTA
%token MENOR
%token MENOR_IGUAL
%token MAYOR
%token MAYOR_IGUAL
%token DISTINTO
%token IGUAL
%token ASIGNACION
%token COMIENZO_PARENTESIS
%token FIN_PARENTESIS
%token COMIENZO_BLOQUE
%token FIN_BLOQUE
%start programa_start_symbol
%%
/******************************************************************************/
/******************************************************************************/
programa_start_symbol:
programa
{
	printf("\nRegla 1 - Programa (start symbol).");
	Mostrar_lista_de_tercetos();
};

programa: programa sentencia { printf("\nRegla 2 - programa => programa sentencia"); }
| sentencia { printf("\nRegla 2 - programa => sentencia"); }
;

sentencia: asignacion { printf("\nRegla 3 - sentencia => asignacion"); }
| seleccion { printf("\nRegla 3 - sentencia => seleccion"); }
| iteracion { printf("\nRegla 3 - sentencia => iteracion"); }
| declaracion { printf("\nRegla 3 - sentencia => declaracion"); }
;

asignacion: IDENTIFICADOR ASIGNACION expresion
{
	printf("\nRegla 4 - asignacion => IDENTIFICADOR ASIGNACION expresion");
	strcpy(tercetos.parametro_1, ":=");
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_3, pila.parametro);
	strcpy(tercetos.parametro_2, tablaDeIdentificadores[$1].nombre);
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;
};

seleccion: ifsimple THEN bloque
{
	printf("\nRegla 5 - seleccion => IF condicion THEN bloque");
	ifsimple_THEN_bloque();
}
| ifsimple THEN bloque
{
   char aux[MAX];

	ultoa(cantidad_tercetos+2,aux,10);
	strcpy(tercetos.parametro_3,"");
   strcat(tercetos.parametro_3,"[");
	strcat(tercetos.parametro_3,aux);
	strcat(tercetos.parametro_3,"]");
	strcpy(tercetos.parametro_1, "BF" );
   strcpy(tercetos.parametro_2, "-" );

   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   int aux2 = atoi(pila.parametro);
	lista_tercetos.Modificar(tercetos, aux2);
}
ELSE
{
	char aux[MAX];
	strcpy(tercetos.parametro_1, "BI" );
   strcpy(tercetos.parametro_2, "-" );
   strcpy(tercetos.parametro_3, "SALTO2" );
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;

  	ultoa(cantidad_tercetos-1,aux,10);
	strcpy(pila.parametro,"");
   strcat(pila.parametro,aux);
	pila_tercetos.Poner(pila);
   cantidad_pila++;
}
bloque
{
   char aux[MAX];

	ultoa(cantidad_tercetos+1,aux,10);
	strcpy(tercetos.parametro_3,"");
   strcat(tercetos.parametro_3,"[");
	strcat(tercetos.parametro_3,aux);
	strcat(tercetos.parametro_3,"]");
	strcpy(tercetos.parametro_1, "BI" );
   strcpy(tercetos.parametro_2, "-" );

   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   int aux2 = atoi(pila.parametro);
	lista_tercetos.Modificar(tercetos, aux2);

	printf("\nRegla 5 - seleccion => IF condicion THEN bloque ELSE bloque");
}
;

ifsimple: IF condicion
{
	char aux[MAX];
	strcpy(tercetos.parametro_1, "BF" );
   strcpy(tercetos.parametro_2, "-" );
   strcpy(tercetos.parametro_3, "SALTO1" );
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;

  	ultoa(cantidad_tercetos-1,aux,10);
	strcpy(pila.parametro,"");
   strcat(pila.parametro,aux);
	pila_tercetos.Poner(pila);
   cantidad_pila++;
};

iteracion: REPEAT
{
	char aux[MAX];
  	ultoa(cantidad_tercetos+1,aux,10);
	strcpy(pila.parametro,"");
   strcat(pila.parametro,"[");
   strcat(pila.parametro,aux);
   strcat(pila.parametro,"]");
	pila_tercetos.Poner(pila);
   cantidad_pila++;
}
bloque UNTIL condicion
{
	pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_1, "BV" );
   strcpy(tercetos.parametro_2, "-" );
	strcpy(tercetos.parametro_3,"");
	strcat(tercetos.parametro_3,pila.parametro);
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;
	printf("\nRegla 6 - iteracion => REPEAT bloque UNTIL condicion");
}
;

condicion: expresion comparador expresion
{
	printf("\nRegla 7 - condicion => expresion comparador expresion");
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_3, pila.parametro);
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
  	strcpy(tercetos.parametro_1, pila.parametro);
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
  	strcpy(tercetos.parametro_2, pila.parametro);
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;
}
| COMIENZO_PARENTESIS expresion comparador expresion FIN_PARENTESIS
{
	printf("\nRegla 7 - condicion => expresion comparador expresion");
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_3, pila.parametro);
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
  	strcpy(tercetos.parametro_1, pila.parametro);
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
  	strcpy(tercetos.parametro_2, pila.parametro);
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;
	printf("\nRegla 7 - condicion => COMIENZO_PARENTESIS expresion comparador expresion");
	printf("FIN_PARENTESIS");
}
;

comparador:                             
MAYOR
{
	printf("\nRegla 7 - comparador => MAYOR");
	strcpy(pila.parametro,">");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
| MENOR
{
	printf("\nRegla 7 - comparador => MENOR");
	strcpy(pila.parametro,"<");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
| MAYOR_IGUAL
{
	printf("\nRegla 7 - comparador => MAYOR_IGUAL");
	strcpy(pila.parametro,">=");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
| MENOR_IGUAL
{
	printf("\nRegla 7 - comparador => MENOR_IGUAL");
	strcpy(pila.parametro,"<=");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
| IGUAL
{
	printf("\nRegla 7 - comparador => IGUAL");
	strcpy(pila.parametro,"=");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
| DISTINTO
{
	printf("\nRegla 7 - comparador => DISTINTO");
	strcpy(pila.parametro,"#");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
;

expresion: expresion SUMA termino
{
	printf("\nRegla 8 - expresion => expresion SUMA termino");
	crear_terceto_expresion("+");
}
| expresion RESTA termino
{
	printf("\nRegla 8 - expresion =>expresion RESTA termino");
	crear_terceto_expresion("-");
}
| termino
{
	printf("\nRegla 8 - expresion => termino");
}
;

termino: termino MULTIPLICACION factor
{
	printf("\nRegla 9 - termino => termino MULTIPLICACION factor");
	crear_terceto_expresion("*");
}
| termino DIVISION factor
{
	printf("\nRegla 9 - termino => termino DIVISION factor");
	crear_terceto_expresion("/");
}
| factor
{
	printf("\nRegla 9 - termino => factor");
}
;

factor: IDENTIFICADOR
{
	printf("\nRegla 10 - factor => IDENTIFICADOR: %s, yylval: %d", tablaDeIdentificadores[$1].nombre, $1);
	strcpy(pila.parametro, tablaDeIdentificadores[$1].nombre);
	pila_tercetos.Poner(pila);
   cantidad_pila++;
}

| CONSTANTED
{
	printf("\nRegla 10 - factor => CONSTANTED: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEO
{
	printf("\nRegla 10 - factor => CONSTANTEO: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEB
{
	printf("\nRegla 10 - factor => CONSTANTEB: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEH
{
	printf("\nRegla 10 - factor => CONSTANTEH: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTED32
{
	printf("\nRegla 10 - factor => CONSTANTED32: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEO32
{
	printf("\nRegla 10 - factor => CONSTANTEO32: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEB32
{
	printf("\nRegla 10 - factor => CONSTANTEB32: %d", $1);
	poner_ctes_en_pila($1);
}
| CONSTANTEH32
{
	printf("\nRegla 10 - factor => CONSTANTEH32: %d", $1);
	poner_ctes_en_pila($1);
}
| COMIENZO_PARENTESIS expresion FIN_PARENTESIS
{
	printf("\nRegla 10 - factor => COMIENZO_PARENTESIS expresion FIN_PARENTESIS");
}
;

bloque: COMIENZO_BLOQUE programa FIN_BLOQUE
{
	printf("\nRegla 11 - bloque => COMIENZO_BLOQUE programa FIN_BLOQUE");
}
;

declaracion: tipo IDENTIFICADOR
{
	printf("\nRegla 12 - declaracion => tipo IDENTIFICADOR: %s, yylval: %d", tablaDeIdentificadores[$2].nombre, $2);
}
;

tipo: INT { printf("\nRegla 13 - tipo => INT"); }
| LONGINT { printf("\nRegla 13 - tipo => LONGINT"); }
;
%%
/******************************************************************************/
/******************************************************************************/
void main(int argc, char * argv[])
{
	int i;
   int error;

   if (argc == 1)
	{
      do{
   	error = abrir_archivo();
		}while(error!=0);
   }
   if (argc == 2)
   {
  	 		if ((archivo=fopen(argv[1],"r"))==NULL)
			{
				printf("\nError: no se pudo abrir el archivo ingresado como parametro.");
			   printf("\nPresione cualquier tecla para continuar.");
   	      getche();
		      error = 1;
			}
      	else
	      	error = 0;
         if (error)
         {
               do{
						error = abrir_archivo();
					}while(error!=0);
         }
   }
   if (argc >= 3)
	{
     	printf("\nError: se recibe un solo parametro, que es el nombre del archivo fuente");
      printf("\nEjemplo: compila fuente.txt");
      printf("\nPresione cualquier tecla para continuar.");
   	getche();
		do{
			error = abrir_archivo();
      }while(error!=0);
   }
   
   /* Agregar palabras reservadas a tabla de simbolos */
   strcpy(tablaDeIdentificadores[0].nombre,"IF");
   tablaDeIdentificadores[0].token = IF;
   strcpy(tablaDeIdentificadores[1].nombre,"THEN");
   tablaDeIdentificadores[1].token = THEN;
   strcpy(tablaDeIdentificadores[2].nombre,"ELSE");
   tablaDeIdentificadores[2].token = ELSE;
   strcpy(tablaDeIdentificadores[3].nombre,"REPEAT");
   tablaDeIdentificadores[3].token = REPEAT;
   strcpy(tablaDeIdentificadores[4].nombre,"UNTIL");
   tablaDeIdentificadores[4].token = UNTIL;
   strcpy(tablaDeIdentificadores[5].nombre,"INT");
   tablaDeIdentificadores[5].token = INT;
   strcpy(tablaDeIdentificadores[6].nombre,"LONGINT");
   tablaDeIdentificadores[6].token = LONGINT;
   cantidadDeIdentificadores+=7;
   /***************************************************/

  	yyparse();

   fclose(archivo); //cerrar archivo

//   printf("\nPresione cualquier tecla para continuar.");
//	getche();

   printf("\n\nTabla de Simbolos"); //se muestra la tabla de simbolos

   if(cantidadDeIdentificadores == 7)
   {
   	printf("\nNo se definieron identificadores.");
	   printf("\nSe muestran solo las palabras reservadas.");
		for(i = 0; i < 7; i++)
		{
      	printf("\n%s - %d",tablaDeIdentificadores[i].nombre,\
         tablaDeIdentificadores[i].token);
      }
   }
   else
   {
		for(i = 0; i < cantidadDeIdentificadores; i++)
		{
      	printf("\n%s - %d",tablaDeIdentificadores[i].nombre,\
         tablaDeIdentificadores[i].token);
      }
   }
//   printf("\nPresione cualquier tecla para finalizar.");
//	getche();
}
//fin de main
/******************************************************************************/
/******************************************************************************/
//Comienzo de funciones

int abrir_archivo()
{
   char nombre[32];

	clrscr();
	printf("LENGUAJES Y COMPILADORES - TP COMPILADOR");
	printf("\nIngrese nombre del archivo fuente.");
	printf("\n(tiene que ser un archivo de texto plano).");
	printf("\nEjemplo: c:\\programa.txt");
   printf("\n-> ");
   fflush(stdin);
	scanf("%s",&nombre);
   fflush(stdin);

   if ((archivo=fopen(nombre,"r"))==NULL)
	{
		printf("\nError: no se pudo abrir el archivo.");
		printf("\nPresione cualquier tecla para continuar.");
   	getche();
		return 1;
   }
   else
		return 0;
}

int yylex()
{

int nuevoEstado[15][25] = {

/*  0 */{1,  1,  1,  1,  1,  1,  2,  7,  15, 15, 12, 13, 14, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 0, 15},

/*  1 */{1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  2 */{15, 15, 4,  3,	 5,  6,	15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  3 */{15, 15, 15, 15, 15, 15, 3,  3,  3,  3,  15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  4 */{15, 15, 15, 15, 15, 15, 4,  4,  15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  5 */{15, 15, 15, 15, 15, 15, 5,  5,  5,  15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  6 */{15, 6,  6,  6,  15, 15, 6,  6,  6,  6,  15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  7 */{15, 15, 9,  8,	 10, 11, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  8 */{15, 15, 15, 15, 15, 15, 8,  8,  8,  8,  15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/*  9 */{15, 15, 15, 15, 15, 15, 9,  9,  15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/* 10 */{15, 15, 15, 15, 15, 15, 10, 10, 10, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/* 11 */{15, 11, 11, 11, 15, 15, 11, 11, 11, 11, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/* 12 */{15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/* 13 */{15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

/* 14 */{15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, \
15, 15, 15, 15, 15, 15, 15, 15},

};

int (*funcion[15][25])(char) = {

/*  0 */
{initid, initid, initid, initid, initid, initid, nada, nada, error, error,\
 nada, nada, nada, multiplicacion, suma, division, resta, distinto, igual, \
 comienzo_bloque, fin_bloque, comienzo_parentesis, fin_parentesis, nada, \
 terminar},

/*  1 */
{addId, addId, addId, addId, addId, addId, addId, addId, addId, addId, finId, \
 finId, finId, finId, finId, finId, finId, finId, finId, finId, finId, finId, \
 finId, finId, finId},

/*  2 */
{error_cte, error_cte, initCteB, initCteD, initCteO, initCteH, error_cte, \
 error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, \
 error_cte, error_cte, error_cte, error_cte,	error_cte, error_cte, error_cte, \
 error_cte, error_cte, error_cte, error_cte},

/*  3 */
{fincteD,   fincteD,   fincteD,    fincteD,    fincteD,   fincteD,   addcteD, \
 addcteD,   addcteD,   addcteD,    fincteD,    fincteD,   fincteD,   fincteD, \
 fincteD,   fincteD,   fincteD,    fincteD,    fincteD,   fincteD,   fincteD, \
 fincteD,   fincteD,   fincteD,    fincteD},

/*  4 */
{fincteB,   fincteB,   fincteB,    fincteB,    fincteB,   fincteB,   addcteB, \
 addcteB,   fincteB,   fincteB,    fincteB,    fincteB,   fincteB,   fincteB, \
 fincteB,   fincteB,   fincteB,    fincteB,    fincteB,   fincteB,   fincteB, \
 fincteB,   fincteB,   fincteB,    fincteB},

/*  5 */
{fincteO,   fincteO,   fincteO,    fincteO,    fincteO,   fincteO,   addcteO, \
 addcteO,   addcteO,   fincteO,    fincteO,    fincteO,   fincteO,   fincteO, \
 fincteO,   fincteO,   fincteO,    fincteO,    fincteO,   fincteO,   fincteO, \
 fincteO,   fincteO,   fincteO,    fincteO},

/*  6 */
{fincteH, addcteH, addcteH, addcteH, fincteH, fincteH, addcteH, addcteH, \
 addcteH, addcteH, fincteH, fincteH, fincteH, fincteH, fincteH, fincteH, \
 fincteH, fincteH, fincteH, fincteH, fincteH, fincteH, fincteH, fincteH, \
 fincteH},

/*  7 */
{error_cte, error_cte, initCteB32, initCteD32, initCteO32, initCteH32, \
 error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, \
 error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, error_cte, \
 error_cte, error_cte, error_cte, error_cte, error_cte},

/*  8 */
{fincteD32, fincteD32, fincteD32, fincteD32, fincteD32, fincteD32, addcteD32, \
 addcteD32, addcteD32, addcteD32, fincteD32, fincteD32, fincteD32, fincteD32, \
 fincteD32, fincteD32, fincteD32, fincteD32, fincteD32, fincteD32, fincteD32, \
 fincteD32, fincteD32, fincteD32, fincteD32},

/*  9 */
{fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, addcteB32, \
 addcteB32, fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, \
 fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, fincteB32, \
 fincteB32, fincteB32, fincteB32, fincteB32},

/* 10 */
{fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, addcteO32, \
 addcteO32, addcteO32, fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, \
 fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, fincteO32, \
 fincteO32, fincteO32, fincteO32, fincteO32},

/* 11 */
{fincteH32, addcteH32, addcteH32, addcteH32, fincteH32, fincteH32, addcteH32, \
 addcteH32, addcteH32, addcteH32, fincteH32, fincteH32, fincteH32, fincteH32, \
 fincteH32, fincteH32, fincteH32, fincteH32, fincteH32, fincteH32, fincteH32, \
 fincteH32, fincteH32, fincteH32, fincteH32},

/* 12 */
{error_asig, error_asig, error_asig, error_asig, error_asig, error_asig, \
 error_asig, error_asig, error_asig, error_asig, error_asig, error_asig, \
 error_asig, error_asig, error_asig, error_asig, error_asig, error_asig, \
 asignacion, error_asig, error_asig, error_asig, error_asig, error_asig, \
 error_asig},

/* 13 */
{mayor, mayor, mayor, mayor, mayor,	mayor, mayor, mayor, mayor, mayor, mayor, \
 mayor, mayor, mayor, mayor, mayor,	mayor, mayor, mayor_igual, mayor, mayor, \
 mayor, mayor, mayor, mayor },

/* 14 */
{menor, menor, menor, menor, menor, menor, menor, menor, menor, menor, menor, \
 menor, menor, menor, menor, menor,	menor, menor, menor_igual, menor, menor, \
 menor, menor, menor, menor },

};
	int i;
	char caracter;
   int codigoDevuelto = 0;
   int estado = 0;
   int evento;

   tamanio = 0; //cantidad de caracteres del identificador o palabra reservada
   for (i = 0; i < MAX_ID; i++)//limpio el string
		id[i]=' ';

	while (estado != 15)
	{
		caracter = (char) fgetc(archivo);

		evento = getEvento(caracter);

      if(evento != -1) //si se reconoce el caracter
	   	codigoDevuelto=(*funcion[estado][evento])(caracter);
      else //si no se reconoce el caracter
      {
			printf("\nERROR: CARACTER NO RECONOCIDO => %c",caracter);
         printf("\nPRESIONE CUALUIER TECLA PARA SALIR");
      	getche();
         return -1;
      }

      if(codigoDevuelto == -2) //si se produjo un error
      	return -1;

    	estado = nuevoEstado[estado][evento];
	}
	return codigoDevuelto;
}
/******************************************************************************/
int initid(char a)
{
   tamanio=1;
   id[0]= a;
   return 0;
}
/******************************************************************************/
int addId(char a)
{
	if (tamanio< (MAX_ID-1))
	{
		tamanio++;
	id[tamanio-1]= a;
	}
	else
	{
		printf("\nError: Nombre de variable excede %d caracteres.",MAX_ID);
		error(1);
	}
	return 0;
}
/******************************************************************************/
int finId(char a)
{
   int i, aux;
   char palabrasReservadas[7][10] = {"IF", "THEN", "ELSE", "REPEAT", "UNTIL", \
   "INT", "LONGINT"};
   id[tamanio]='\0'; //coloca el fin de cadena

  	ungetc(a, archivo);

   for(i=0; i<7;i++)  //compara por cada fila de palabrasReservadas
      if (strcmp(id,palabrasReservadas[i])==0)//si es igual el id a pal res
         switch (i) //devuelve el token correspondiente
         {
            case 0: return IF;
            case 1: return THEN;
            case 2: return ELSE;
		   	case 3: return REPEAT;
			   case 4: return UNTIL;
				case 5: return INT;
				case 6: return LONGINT;
	 }

	aux = agregarEnTablaIdentificadores(IDENTIFICADOR);
   if (aux == -1)
	{
      printf("\nSe lleno la tabla de simbolos.");
      printf("\nPresione cualquier tecla para finalizar.");
      return -1;
   }
	return IDENTIFICADOR; //sino devuelve el token de id
}
/******************************************************************************/
int initCteD(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int initCteD32(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int addcteD(char a)
{

  if (tamanio < MAX_CTE_DECIMAL)
  {
     tamanio++;
     id[tamanio-1] = a;
  }
  else
  {
	printf("\nError: Constante entera decimal 16 bits: Excedio rango 0-65535");
	error(1);
  }
  return 0;
}
/******************************************************************************/
int addcteD32(char a)
{

  if (tamanio < MAX_CTE_DECIMAL_32)
  {
     tamanio++;
     id[tamanio-1] = a;
  }
  else
  {
printf("\nError: Constante entera decimal 32 bits: Excedio rango 0-4294967295");
  	error(1);
  }
  return 0;
}
/******************************************************************************/
int fincteD(char a)
{
   int i;
   long int valor;
   long int aux = 0;
   long int aux2 = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1; i>=0; i--)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	if(id[i] == '2') valor = 2;
	if(id[i] == '3') valor = 3;
	if(id[i] == '4') valor = 4;
	if(id[i] == '5') valor = 5;
	if(id[i] == '6') valor = 6;
	if(id[i] == '7') valor = 7;
	if(id[i] == '8') valor = 8;
	if(id[i] == '9') valor = 9;

	aux += (valor * aux2);
	aux2 *= 10;
   }

   if (aux > 65535)
   {
printf("\nError: Constante entera decimal 16 bits: Excedio rango 0-65535");
	error(1);
   }
	yylval = aux;
	return CONSTANTED;
}
/******************************************************************************/
int fincteD32(char a)
{
   int i;
   double valor;
   double aux = 0;
   double aux2 = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1; i>=0; i--)
   {
		if(id[i] == '0') valor = 0;
		if(id[i] == '1') valor = 1;
		if(id[i] == '2') valor = 2;
		if(id[i] == '3') valor = 3;
		if(id[i] == '4') valor = 4;
		if(id[i] == '5') valor = 5;
		if(id[i] == '6') valor = 6;
		if(id[i] == '7') valor = 7;
		if(id[i] == '8') valor = 8;
		if(id[i] == '9') valor = 9;
		aux += valor * aux2;
		aux2 *= 10;
	}

   if (aux > 4294967295)
   {
printf("\nError: Constante entera decimal 32 bits: Excedio rango 0-4294967295");
	error(1);
   }
	yylval = aux;
	return CONSTANTED32;
}
/******************************************************************************/
int initCteB(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int initCteB32(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int addcteB(char a)
{
  if (tamanio < MAX_CTE_BINARIA)
  {
     tamanio++;
     id[tamanio-1]=a;
  }
  else
  {
	printf("\nError: Constante entera binaria 16 bits:");
   printf("Excedio rango 0-1111111111111111");
	error(1);
  }
  return 0;
}
/******************************************************************************/
int addcteB32(char a)
{
  if (tamanio < MAX_CTE_BINARIA_32)
  {
     tamanio++;
     id[tamanio-1] = a;
  }
  else
  {
	printf("\nError: Constante entera binaria 32 bits.");
	printf("Excedio rango 0-11111111111111111111111111111111");
	error(1);
  }
  return 0;
}
/******************************************************************************/
int fincteB(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal
   double multiplo = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	aux += valor * pow(2,j);
	multiplo *= 10;
   }
	yylval = aux;
	return CONSTANTEB;
}
/******************************************************************************/
int fincteB32(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal
   double multiplo = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	aux += valor * pow(2,j);
	multiplo *= 10;
   }
   yylval = aux;
   return CONSTANTEB32;
}
/******************************************************************************/
int initCteO(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int initCteO32(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int addcteO(char a)
{
  if (tamanio < MAX_CTE_OCTAL)
  {
     tamanio++;
     id[tamanio-1] = a;
  }
    else
  {
	printf("\nError: Constante entera octal 16 bits. \nExcedio rango 0-177777");
	error(1);
  }

  return 0;
}
/******************************************************************************/
int addcteO32(char a)
{
  if (tamanio< MAX_CTE_OCTAL_32)
  {
     tamanio++;
     id[tamanio-1] = a;
  }
  else
  {
printf\
("\nError: Constante entera octal 32 bits. \nExcedio rango 0-37777777777");
	error(1);
  }
  return 0;
}
/******************************************************************************/
int fincteO(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal
   double multiplo = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	if(id[i] == '2') valor = 2;
	if(id[i] == '3') valor = 3;
	if(id[i] == '4') valor = 4;
	if(id[i] == '5') valor = 5;
	if(id[i] == '6') valor = 6;
	if(id[i] == '7') valor = 7;

	aux += valor * pow(8,j);
	multiplo *= 10;
   }

   if (aux > 65535)
   {
	printf("\nError: Constante entera octal 16 bits. \nExcedio rango 0-177777");
	error(1);
   }

   yylval = aux;	
   return CONSTANTEO;
}
/******************************************************************************/
int fincteO32(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal
   double multiplo = 1;

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	if(id[i] == '2') valor = 2;
	if(id[i] == '3') valor = 3;
	if(id[i] == '4') valor = 4;
	if(id[i] == '5') valor = 5;
	if(id[i] == '6') valor = 6;
	if(id[i] == '7') valor = 7;

	aux += valor * pow(8,j);
	multiplo *= 10;
   }

   if (aux > 4294967295)
   {
printf("\nError: Constante entera octal 32 bits.\nExcedio rango 0-37777777777");
	error(1);
   }
	yylval = aux;
	return CONSTANTEO32;
}
/******************************************************************************/
int initCteH(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int initCteH32(char a)
{
   tamanio=0;
   return 0;
}
/******************************************************************************/
int addcteH(char a)
{
	char c;
  if (tamanio<MAX_CTE_HEXA)
  {
     tamanio++;
     c = a;
	  if(!isdigit(c))
     		c = toupper(c);
     id[tamanio-1]= c;
  }
  else
  {
printf("\nError: Constante entera hexadecimal 16 bits. \nExcedio rango 0-FFFF");
	error(1);
  }
  return 0;
}
/******************************************************************************/
int addcteH32(char a)
{
	char c;
  if (tamanio<MAX_CTE_HEXA_32)
  {
     tamanio++;
     c = a;
	  if(!isdigit(c))
     		c = toupper(c);
     id[tamanio-1] = c;
  }
  else
  {
printf\
("\nError: Constante entera hexadecimal 32 bits. \nExcedio rango 0-FFFFFFFF");
	error(1);
  }

  return 0;
}
/******************************************************************************/
int fincteH(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	if(id[i] == '2') valor = 2;
	if(id[i] == '3') valor = 3;
	if(id[i] == '4') valor = 4;
	if(id[i] == '5') valor = 5;
	if(id[i] == '6') valor = 6;
	if(id[i] == '7') valor = 7;
	if(id[i] == '8') valor = 8;
	if(id[i] == '9') valor = 9;
	if(id[i] == 'a' || id[i] == 'A') valor = 10;
	if(id[i] == 'b' || id[i] == 'B') valor = 11;
	if(id[i] == 'c' || id[i] == 'C') valor = 12;
	if(id[i] == 'd' || id[i] == 'D') valor = 13;
	if(id[i] == 'e' || id[i] == 'E') valor = 14;
	if(id[i] == 'f' || id[i] == 'F') valor = 15;
	aux += valor * pow(16,j);
   }

   if (aux > 65535)
   {
printf("\nError: Constante entera hexadecimal 16 bits. \nExcedio rango 0-FFFF");
	error(1);
   }
	yylval = aux;
	return CONSTANTEH;
}
/******************************************************************************/
int fincteH32(char a)
{
   int i;
   int j;
   double valor;
   double aux = 0; //valor en decimal

   id[tamanio]='\0'; //coloca el fin de cadena
  	ungetc(a, archivo);
   for(i=tamanio-1, j=0; i>=0; i--, j++)
   {
	if(id[i] == '0') valor = 0;
	if(id[i] == '1') valor = 1;
	if(id[i] == '2') valor = 2;
	if(id[i] == '3') valor = 3;
	if(id[i] == '4') valor = 4;
	if(id[i] == '5') valor = 5;
	if(id[i] == '6') valor = 6;
	if(id[i] == '7') valor = 7;
	if(id[i] == '8') valor = 8;
	if(id[i] == '9') valor = 9;
	if(id[i] == 'a' || id[i] == 'A') valor = 10;
	if(id[i] == 'b' || id[i] == 'B') valor = 11;
	if(id[i] == 'c' || id[i] == 'C') valor = 12;
	if(id[i] == 'd' || id[i] == 'D') valor = 13;
	if(id[i] == 'e' || id[i] == 'E') valor = 14;
	if(id[i] == 'f' || id[i] == 'F') valor = 15;

	aux += valor * pow(16,j);
   }

   if (aux > 4294967295)
   {
	printf("\nError: Constante entera hexadecimal 32 bits.");
	printf("\nExcedio rango 0-FFFFFFFF");
	error(1);
   }
	yylval = aux;
   return CONSTANTEH32;
}
/******************************************************************************/
int mayor_igual(char a)
{
	return MAYOR_IGUAL;
}
/******************************************************************************/
int mayor(char a)
{
  	ungetc(a, archivo);
	return MAYOR;
}
/******************************************************************************/
int asignacion(char a)
{
	return ASIGNACION;
}
/******************************************************************************/
int menor_igual(char a)
{
	return MENOR_IGUAL;
}
/******************************************************************************/
int menor(char a)
{
  	ungetc(a, archivo);
	return MENOR;
}
/******************************************************************************/
int multiplicacion(char a)
{
	return MULTIPLICACION;
}
/******************************************************************************/
int suma(char a)
{
	return SUMA;
}
/******************************************************************************/
int division(char a)
{
	return DIVISION;
}
/******************************************************************************/
int resta(char a)
{
	return RESTA;
}
/******************************************************************************/
int distinto(char a)
{
	return DISTINTO;
}
/******************************************************************************/
int igual(char a)
{
	return IGUAL;
}
/******************************************************************************/
int comienzo_bloque(char a)
{
	return COMIENZO_BLOQUE;
}
/******************************************************************************/
int fin_bloque(char a)
{
	return FIN_BLOQUE;
}
/******************************************************************************/
int comienzo_parentesis(char a)
{
	return COMIENZO_PARENTESIS;
}
/******************************************************************************/
int fin_parentesis(char a)
{
	return FIN_PARENTESIS;
}
/******************************************************************************/
int error(char a)
{
   printf("\nError: Se esperaba cualquier letra");
   printf(" (comienzo de identificador o palabra reservada).");
   printf("\nEjemplos: variable, IF");
   printf("\nSe esperaba 0 (comienzo de constante de 16 bits).");
   printf("\nEjemplo: 0d50");
	printf("\nSe esperaba 1 (comienzo de constante de 32 bits).");
   printf("\nEjemplo: 1d50");
   return (-2);
}
/******************************************************************************/
int error_asig(char a)
{
   printf("\nError de asignacion: se esperaba = despues de :");
	printf("\nEjemplo -> a:=b");
   return (-2);
}
/******************************************************************************/
int error_cte(char a)
{
   printf("\nError de constantes: se esperaba alguna de las letras");
   printf("\n 'b' o 'B' (binario)");
   printf("\n 'o' o 'O' (octal)");
   printf("\n 'd' o 'D' (decimal)");
   printf("\n 'h' o 'H' (hexadecimal)");
   printf("\ndespues de 0 (16 bits) o 1 (32 bits)");
   printf("\n\nEjemplos:");
	printf("\n\nConstantes 16 bits");
	printf("\nDecimales: 0D65535 o 0d65535");
	printf("\nBinarias: 0B1111111111111111 o 0b1111111111111111");
	printf("\nOctales: 0O177777 o 0o177777");
	printf("\nHexadecimales: 0HFFFF o 0hFFFF o 0Hffff o 0hffff");
	printf("\n\nConstantes 32 bits");
	printf("\nDecimales: 1D4294967295 o 1d4294967295");
	printf("\nBinarias: 1B11111111111111111111111111111111 o");
	printf("\n1b11111111111111111111111111111111");
	printf("\nOctales: 1O37777777777 o 1o37777777777");
	printf("\nHexadecimales: 1HFFFFFFFF o 1hFFFFFFFF o 1Hffffffff o 1hffffffff");
   return (-2);
}
/******************************************************************************/
int nada(char a)
{
	return 0;
}
/******************************************************************************/
int getEvento(char c)
{
	if (c == 'a' || c == 'c' || c == 'e' || c == 'f'|| c == 'A' || c == 'C' || \
   c == 'E' || c == 'F')
   	return 1;
   if (c == 'b' || c=='B')
   	return 2;
	if (c == 'd' || c=='D')
   	return 3;
   if (c == 'o' || c=='O')
	return 4;
   if (c == 'h' || c=='H')
   	return 5;
   if (isdigit(c))
   {
   	if (c == '0')
      	return 6;
      if (c == '1')
      	return 7;
      if (c >= '2' || c <= '7')
      	return 8;
      if (c == '8' || c == '9')
      	return 9;
   }
   if(isalpha(c))
		return 0;
	if(c == ':')
   	return 10;
	if(c == '>')
   	return 11;
	if(c == '<')
   	return 12;
	if(c == '*')
   	return 13;
	if(c == '+')
   	return 14;
	if(c == '/')
   	return 15;
	if(c == '-')
   	return 16;
	if(c == '#')
		return 17;
	if(c == '=')
   	return 18;
	if(c == '{')
	return 19;
	if(c == '}')
   	return 20;
	if(c == '(')
   	return 21;
	if(c == ')')
		return 22;
	if(c == ' ' || c == '\t' || c == '\n')
   	return 23;
   if(c == EOF)
	   return 24;
   return -1; //caracter no reconocido
}
/******************************************************************************/
int terminar(char a)
{
	return -1;
}
/******************************************************************************/
int agregarEnTablaIdentificadores(int type)//type es el token correspondiente
{
   int i;

   if (cantidadDeIdentificadores >= MAX_TABLA_SIMB)
		return -1; //excedio la capacidad del vector

   for(i=0; i < cantidadDeIdentificadores; i++)
   {
      	if(!strcmp(tablaDeIdentificadores[i].nombre,id))
         {
         		yylval = i;
   	    	 	return -2; //ya existe, no hay que agregar
         }
   }

   //si no existe hay que agregar al final
  	strcpy(tablaDeIdentificadores[cantidadDeIdentificadores].nombre,id);
	tablaDeIdentificadores[cantidadDeIdentificadores].token = type;
   yylval = cantidadDeIdentificadores;
   cantidadDeIdentificadores++;
   return 0;
}
/******************************************************************************/
int yyerror(char *s)
//char *s;
{
    fprintf(stderr, "\nError: %s\n", s);
	return 0;
}
/******************************************************************************/
void poner_ctes_en_pila(unsigned long constante)
{
   char aux[MAX];
	ultoa(constante,aux,10);
	strcpy(pila.parametro,"");
	strcat(pila.parametro,aux);
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
/******************************************************************************/
void crear_terceto_expresion(char simbolo[MAX])
{
	char aux[MAX];
   strcpy(tercetos.parametro_1, simbolo);
   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_3, pila.parametro);
	pila = pila_tercetos.Sacar();
   cantidad_pila--;
   strcpy(tercetos.parametro_2, pila.parametro);
	lista_tercetos.Insertar_al_final(tercetos);
   cantidad_tercetos++;
  	ultoa(cantidad_tercetos,aux,10);
	strcpy(pila.parametro,"");
   strcat(pila.parametro,"[");
	strcat(pila.parametro,aux);
	strcat(pila.parametro,"]");
   pila_tercetos.Poner(pila);
   cantidad_pila++;
}
/******************************************************************************/
void Mostrar_lista_de_tercetos()
{
	int i = 0;
   while (lista_tercetos.Pasar_a_nodo_sig() != true )
	{
	  	tercetos = lista_tercetos.MostrarNodo();
		cout << endl << "Terceto Nro.: [" << ++i << "]";
     	cout << " -> ( " << tercetos.parametro_1;
      cout << ", " << tercetos.parametro_2;
      cout << ", " << tercetos.parametro_3 << " )";
   }
}
/******************************************************************************/
void ifsimple_THEN_bloque()
{
   char aux[MAX];

	ultoa(cantidad_tercetos+1,aux,10);
	strcpy(tercetos.parametro_3,"");
   strcat(tercetos.parametro_3,"[");
	strcat(tercetos.parametro_3,aux);
	strcat(tercetos.parametro_3,"]");
	strcpy(tercetos.parametro_1, "BF" );
   strcpy(tercetos.parametro_2, "-" );

   pila = pila_tercetos.Sacar();
   cantidad_pila--;
   int aux2 = atoi(pila.parametro);
	lista_tercetos.Modificar(tercetos, aux2);
}
/******************************************************************************/
