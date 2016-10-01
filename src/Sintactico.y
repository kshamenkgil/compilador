%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constantes.h"

int yystopparser=0;
FILE  *yyin; //Archivo de Entrada
FILE * pfTablaSimbolos; //Tabla de Simbolos

%}

/* PARA OBTENER LOS VALORES Y PASAR A TS*/
%union {
int intval;
double val;
char *str_val;
}

%token <str_val>TOKEN_ID
%token <int>CONST_INT
%token <str_val>CONST_STR
%token <double>CONST_FLOAT

%token PR_BEGIN
%token PR_END

%token PR_WRITE
%token PR_READ

%token PR_AVERAGE
%token PR_COMBINATORIO
%token PR_FACTORIAL

%token PR_VAR
%token PR_ENDVAR

%token PR_FLOAT
%token PR_INT
%token PR_STRING

%token PR_IF
%token PR_THEN
%token PR_ELSE
%token PR_ENDIF

%token PR_REPEAT
%token PR_UNTIL

%token OP_ASIGNACION
%token OP_SUMA
%token OP_RESTA
%token OP_MULTIPLICACION
%token OP_DIVISION
%token CONCAT

%token PAR_ABRE
%token PAR_CIERRA
%token COR_ABRE
%token COR_CIERRA

%token OP_MAYOR
%token OP_MAYOR_IGUAL
%token OP_MENOR
%token OP_MENOR_IGUAL
%token OP_DISTINTO
%token OP_IGUAL_IGUAL

%token OP_LOG_AND
%token OP_LOG_OR
%token OP_LOG_NOT

%token COMA
%token DOSPUNTOS


%%

/*OK!*/
pgm: programa 
{
 printf("Start symbol - ¡Compilación exitosa!. \n");
 printf("-------------------. \n");
};

programa: PR_BEGIN lista_sentencia PR_END 
{
	printf("Programa donde no hubo declaración de variables. \n");
};

programa: dec_var PR_BEGIN lista_sentencia PR_END 
{
	printf ("Programa con variables declaradas previamente. \n");
};

/*Declaración de Variables*/
dec_var: PR_VAR lista_dec_var PR_ENDVAR
{
 printf ("Bloque con declaracion de las variables. \n");
};

lista_dec_var: linea_dec_var | lista_dec_var linea_dec_var
{
	printf("Múltiples líneas con declaraciones de las variables. \n");
}

linea_dec_var:  lista_variables DOSPUNTOS tipo
{
 printf ("Declaracion de variables de cierto tipo. \n");
};


tipo: PR_INT | PR_FLOAT | PR_STRING
{
	printf("Tipo de variable. \n");
}

lista_variables: TOKEN_ID |   lista_variables COMA TOKEN_ID
{
	printf("Variable o lista de variables. \n");
}

/*Sentencias*/

lista_sentencia: sentencia
{
 printf ("Sentencia única. \n");                            
};

lista_sentencia: sentencia lista_sentencia
{
 printf ("Sentencia múltiple. \n");                            
};


sentencia: seleccion
{
printf ("Sentencia Condicional: IF. \n");
};

sentencia: sent_repeat
{
 printf ("Sentencia bucle: REPEAT. \n");                            
};


sentencia: sent_asignacion  
{
 printf ("Sentencia: ASIGNACION. \n");                            
};

sentencia: sent_write 
{
 printf ("Sentencia: WRITE. \n");                            
};

sentencia: sent_read 
{
 printf ("Sentencia: READ. \n");                            
};



/*Sentencia WRITE*/
sent_write: PR_WRITE TOKEN_ID
{
 printf ("WRITE de un ID. \n");
}

sent_write: PR_WRITE CONST_STR
{
 printf ("WRITE de un STRING. \n");
}

/*Sentencia READ*/
sent_read: PR_READ TOKEN_ID
{
 printf ("READ de un ID. \n");
}

/*Sentencia IF */
seleccion: comienzo_if lista_sentencia fin_if
{
	printf("IF simple. \n");
};

seleccion: comienzo_if lista_sentencia comienzo_else lista_sentencia fin_if
{
	printf("IF con bloque ELSE. \n");
};

comienzo_if: PR_IF PAR_ABRE Condicion PAR_CIERRA PR_THEN
{
	printf("COMIENZO del bloque IF. \n");
};

comienzo_else: PR_ELSE
{
	printf("COMIENZO dele bloque ELSE. \n");
};

fin_if: PR_ENDIF
{
	printf("FINALIZA el IF. \n");
};


sent_repeat: comienzoRepeat lista_sentencia finRepeat condRepeat
{
	printf("Sentencia REPEAT completa. \n");
};
comienzoRepeat: PR_REPEAT
{
	printf("inicio del bucle REPEAT. \n");
};
condRepeat: PAR_ABRE Condicion PAR_CIERRA 
{
	printf("Condicion del REPEAT. \n");
};
finRepeat: PR_UNTIL 
{
	printf("Fin del repeat. \n");
};

/*Condiciones*/

/*Agrupo los dos tipos de Condiciones*/
Condicion: Condicion_simple
{
	printf("Condicion SIMPLE. \n");
};

Condicion: Condicion_multiple
{
	printf("Condicion MULTIPLE. \n");
};

Condicion_simple: expresion OP_MENOR expresion 	
{
 printf ("Condicion simple con operador Menor. \n");
};

Condicion_simple: expresion OP_MENOR_IGUAL expresion
{
 printf ("Condicion simple con operador Menor e Igual. \n");
};

Condicion_simple: expresion OP_MAYOR expresion
{
 printf ("Condicion simple con operador Mayor. \n");
};
 	
Condicion_simple: expresion OP_MAYOR_IGUAL expresion 
{
 printf ("Condicion simple con operador Mayor e Igual. \n");
};

Condicion_simple: expresion OP_DISTINTO expresion 
{
 printf ("Condicion simple con operador Distinto. \n");
};

Condicion_simple: expresion OP_IGUAL_IGUAL expresion 
{
 printf ("Condicion simple  con operador Igual Igual. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_MENOR expresion 
{
 printf ("Condicion Simple  con operador Menor Negado. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_MENOR_IGUAL expresion 
{
 printf ("Condicion Simple  con operador Menor Igual Negado. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_MAYOR expresion 
{
 printf ("Condicion Simple  con operador Mayor pero Negado. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_MAYOR_IGUAL expresion 
{
 printf ("Condicion Simple Mayor Igual pero Negado. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_DISTINTO expresion 
{
 printf ("Condicion Simple Distinto pero Negado. \n");
};

Condicion_simple: OP_LOG_NOT expresion OP_IGUAL_IGUAL expresion 
{
 printf ("Condicion Simple  con operador Igual Igual pero Negado. \n");
};

Condicion_multiple: Condicion_simple OP_LOG_AND Condicion_simple
{
 printf ("Condicion Multiple con operador lógico AND. \n");
};

Condicion_multiple: Condicion_simple OP_LOG_OR Condicion_simple
{
 printf ("Condicion Multiple con operador lógico OR. \n");
};


/*Expresiones Matematicas*/

expresion: expresion OP_SUMA termino	
{
 printf ("Expresión como suma de otra expresión y un término. \n");       
};

expresion: expresion OP_RESTA termino
{
 printf ("Expresión como resta de otra expresión y un término. \n");     
};
	
expresion: termino	
{
 printf ("Expresión como un término. \n");                        
};

termino: termino OP_MULTIPLICACION factor								
{
 printf ("Término como producto de un término y un factor. \n");                    
};

termino: termino OP_DIVISION factor	
{
 printf ("Término como cociente de un término y un factor. \n");   
};

termino: factor 
{
 printf ("Termino como un factor. \n");
};

factor: CONST_INT	
{
 printf ("Factor es una constante entera. \n");                        
};

factor: CONST_FLOAT	
{
 printf ("Factor es una Constante real. \n");                        
};
							
factor: TOKEN_ID			
{
 printf ("Factor es un ID. \n");                        
};
	
factor: PAR_ABRE expresion PAR_CIERRA 
{
 printf ("Factor es una  ( EXPRESION ). \n");
};
factor: average			
{
 printf ("Factor es un resultado de AVERAGE. \n");                        
};

factor: factorial			
{
 printf ("Factor es un resultado de FACTORIAL. \n");                        
};
factor: nrocombinatorio
{
 printf ("Factor es un resultado de NUMERO COMBINATORIO. \n");                        
};

/*Asignaciones*/ //Faltan

sent_asignacion: TOKEN_ID OP_ASIGNACION asignado
{
printf ("Asignacion Simple. \n");
};

asignado: expresion 
{
 printf ("Asignacion a partir de una expresion. \n");                        
};

asignado: CONST_STR
{
 printf ("Asignacion a partir de una Constante String. \n");                        
};

/*"pepe1"++"pepe2"*/
asignado: CONST_STR CONCAT CONST_STR	
{
 printf ("Asignacion a partir de una concatenación entre constantes String. \n"); 
};

/*ID++"pepe2"*/
asignado: TOKEN_ID CONCAT CONST_STR	
{
 printf ("Asignacion a partir de una concatenación entre un ID string y una constante String. \n");    
};

/*"pepe1"++ID*/
asignado: CONST_STR CONCAT TOKEN_ID	
{
 printf ("Asignacion a partir de una concatenacion entre una constante String y de un ID string. \n");                        
};

/*ID++ID*/
asignado: TOKEN_ID CONCAT TOKEN_ID	
{
 printf ("Asignacion a partir de una concatenacion entre dos ID. \n");         
};

/*Declaracion Funciónes especiales*/


average: PR_AVERAGE PAR_ABRE COR_ABRE lista_expresiones COR_CIERRA PAR_CIERRA
{
 printf ("Función AVERAGE. \n");                            
};


lista_expresiones: expresion |  lista_expresiones COMA expresion
{
 printf ("Expresión o lista de expresiones. \n");                            
};


factorial: PR_FACTORIAL PAR_ABRE expresion PAR_CIERRA
{
 printf ("Función FACTORIAL. \n");                            
};



nrocombinatorio: PR_COMBINATORIO PAR_ABRE expresion COMA expresion PAR_CIERRA
{
 printf ("Función NÚMERO COMBINATORIO. \n");                            
};

%%

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Estructuras de analizador lexico
typedef struct tablaS {
       char nombre [100]; //si el nombre le precede un "_" entonces es una variable, si tiene $ entonces es real y si tiene & es int,    
                          //si tiene un @ es una cte string.
       int tipo; // 0 es palabra reservada, 1 es variable, 2 constante
       double valor;
       int longitud;
       char valorString [COTA_STR]; /*Guarda valor de las variables tipo string*/
}TS;

//Instancia de Tabla de Símbolos
TS tabla[MAX_TS];

//Tope Tabla de Simbolos
int topeTS = 0;

/* FunciónES */

void agregarATS(char *n,char *vs,int t, int l, double v)
{	int val_func;
	printf("Verifico si %s existe en la TS y agrego... . \n",n);
	val_func = verificarTS(n);
	if(val_func==topeTS)
	{
			strcpy(tabla[topeTS].nombre,n);
			strcpy(tabla[topeTS].valorString,vs);
			tabla[topeTS].tipo=t;
			tabla[topeTS].longitud=l;
			tabla[topeTS].valor=v;
			topeTS++;
	}
	else
	{
		printf("El elemento ya se encuentra en la TS--> Pos: (%d). \n",val_func);
	
	}
}

int verificarTS(char *n)
{
	int i;
	for(i=0;i<topeTS;i++)
		if(strcmp(n, tabla[i].nombre)==0)
			break;
	return i;
}

void setearString(char *a, char *yt)
{
	char t[COTA_STR],y[COTA_STR];
	int i,j=0,z=0;
	for(i=0;i<strlen(a);i++)
		{
			if(a[i]!='"'&&a[i]!=' ')
				{
					t[j]=a[i];
					y[z]=a[i];
					j++;
					z++;
				}
			if(a[i]==' ')
				{
					t[j]='_';
					y[z]=a[i];
					j++;
					z++;
				}	
		}
	t[j]='\0';
	y[z]='\0';
	strcpy(a,t);
	strcpy(yt,y);

}
int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf(". \nNo se puede abrir el archivo: %s. \n", argv[1]);
	exit(1);
  }
  else
  {
	//Creación del archivo TS.TXT
	if((pfTablaSimbolos = fopen("ts.txt","w")) == NULL)
	{
		printf(". \nError al crear el archivo TS.TXT. \n");
		exit(1);
	}
	
	yyparse();

  }
  int i;
 //Cargar valores TS en el txt
  fprintf(pfTablaSimbolos,"***El tipo de variable lo determina el caracter que precede a esta última: . \n\t _(variable);$(cte float);&(cte int);@(cte string)***. \n. \n");
  for(i=0;i<topeTS;i++)
	{	
		fprintf(pfTablaSimbolos,"*********************. \n");
		fprintf(pfTablaSimbolos,"%s %d", "Pos:",i);
		fprintf(pfTablaSimbolos,". \n");
		fprintf(pfTablaSimbolos,"Nombre: ");
		fprintf(pfTablaSimbolos,tabla[i].nombre);
		fprintf(pfTablaSimbolos,". \n");
		fprintf(pfTablaSimbolos,"Tipo: ");
		fprintf(pfTablaSimbolos,"%d",tabla[i].tipo);
		fprintf(pfTablaSimbolos,". \n");
		fprintf(pfTablaSimbolos,"Longitud: ");
		fprintf(pfTablaSimbolos,"%d",tabla[i].longitud);
		fprintf(pfTablaSimbolos,". \n");
		fprintf(pfTablaSimbolos,"Valor: ");
		if(tabla[i].tipo==CTE_FLT)
		{
			fprintf(pfTablaSimbolos,"%7.10lf",tabla[i].valor);
		}
		else
		{
			fprintf(pfTablaSimbolos,"%ld",tabla[i].valor);
		}
		fprintf(pfTablaSimbolos,". \n");
		fprintf(pfTablaSimbolos,"Valor String: ");
		fprintf(pfTablaSimbolos,tabla[i].valorString);
		fprintf(pfTablaSimbolos,". \n");
	
	}
  fclose(pfTablaSimbolos);
  fclose(yyin);
  return 0;
}

int yyerror(void)
{
	printf("Synax Error. \n");
	system ("Pause");
	exit (1);
}
