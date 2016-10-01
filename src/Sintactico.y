%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
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
%token OP_CONCAT

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

pgm : programa 
{
 printf("Start\n");
 printf("\n");
 printf("COMPILACION EXITOSA\n");
 printf("-------------------\n");
};

programa : PR_BEGIN lista_sentencia PR_END 
{
	printf("Programa sin variables declaradas\n");
};

programa : dec_var PR_BEGIN lista_sentencia PR_END 
{
	printf ("Programa con variables declaradas\n");
};

/*Declaración de Variables*/
dec_var: PR_VAR lista_dec_var PR_ENDVAR
{
 printf ("Modulo declaracion de variables\n");
};

lista_dec_var : linea_dec_var | lista_dec_var linea_dec_var
{
	printf("Múltiples declaraciones de variables\n");
}


linea_dec_var :  lista_variables DOS_PUNTOS tipo
{
 printf ("Declaracion de tipos\n");
};


tipo : PR_INT | PR_FLOAT | PR_STRING
{
	printf("Tipo de variable\n");
}

lista_variables : TOKEN_ID | TOKEN_ID COMA lista_variables
{
	printf("Lista de variables\n");
}

/*Sentencias*/

lista_sentencia : sentencia
{
 printf ("Sentencia Simple\n");                            
};

lista_sentencia : sentencia lista_sentencia
{
 printf ("Sentencia Multiple\n");                            
};

sentencia : sentencia_take 
{
	printf ("Sentencia TAKE\n");
};
sentencia : seleccion
{
	printf ("Sentencia IF\n");
};

sentencia : sent_repeat
{
 printf ("Sentencia REPEAT\n");                            
};

sentencia : sent_repeat_especial
{
 printf ("Sentencia WHILE ESPECIAL\n");                            
};

sentencia : sent_asignacion PUNTO_Y_COMA 
{
 printf ("Sentencia ASIGNACION\n");                            
};

sentencia : sent_put PUNTO_Y_COMA
{
 printf ("Sentencia WRITE\n");                            
};

sentencia : sent_get PUNTO_Y_COMA
{
 printf ("Sentencia READ\n");                            
};

/*Sentencia WRITE*/
sent_put : PR_PUT TOKEN_ID
{
 printf ("WRITE ID\n");
}

sent_put : PR_PUT CONST_STR
{
 printf ("WRITE STRING\n");
}

/*Sentencia READ*/
sent_get : PR_GET TOKEN_ID
{
 printf ("READ ID\n");
}

/*Sentencia IF OK_lea*/
seleccion : comienzo_if lista_sentencia fin_if
{
	printf("IF SIN ELSE\n");
};

seleccion : comienzo_if lista_sentencia comienzo_else lista_sentencia fin_if
{
	printf("IF CON ELSE\n");
};

comienzo_if : PR_IF PAR_ABRE condicion PAR_CIERRA PR_THEN
{
	printf("COMIENZO IF\n");
};

comienzo_else : PR_ELSE
{
	printf("COMIENZO ELSE\n");
};

fin_if : PR_ENDIF
{
	printf("FINALIZA IF\n");
};

/*Sentencia REPEAT cambiar_lea*/

sent_repeat: comienzoWhile finCondicion lista_sentencia finWhile 
{
	printf("Sentencia While completa\n");
};
comienzoWhile: PR_WHILE
{
	printf("inicio While\n");
};
finCondicion: PAR_ABRE condicion PAR_CIERRA 
{
	printf("Cond While\n");
};
finWhile: PR_ENDWHILE 
{
	printf("End repeat\n");
};

/*Condiciones*/

/*Agrupo los dos tipos de condiciones*/
condicion: condicion_simple
{
	printf("CONDICION SIMPLE\n");
};

condicion: condicion_multiple
{
	printf("CONDICION MULTIPLE\n");
};

condicion_simple : expresion OP_MENOR expresion 	
{
 printf ("Condicion Simple Menor\n");
};

condicion_simple : expresion OP_MENOR_IGUAL expresion
{
 printf ("Condicion Simple Menor Igual\n");
};

condicion_simple : expresion OP_MAYOR expresion
{
 printf ("Condicion Simple Mayor\n");
};
 	
condicion_simple : expresion OP_MAYOR_IGUAL expresion 
{
 printf ("Condicion Simple Mayor Igual\n");
};

condicion_simple : expresion OP_DISTINTO expresion 
{
 printf ("Condicion Simple Distinto\n");
};

condicion_simple : expresion OP_IGUAL_IGUAL expresion 
{
 printf ("Condicion Simple Igual Igual\n");
};

condicion_simple : OP_LOG_NOT expresion OP_MENOR expresion 
{
 printf ("Condicion Simple Menor Negado\n");
};

condicion_simple : OP_LOG_NOT expresion OP_MENOR_IGUAL expresion 
{
 printf ("Condicion Simple Menor Igual Negado\n");
};

condicion_simple : OP_LOG_NOT expresion OP_MAYOR expresion 
{
 printf ("Condicion Simple Mayor Negado\n");
};

condicion_simple : OP_LOG_NOT expresion OP_MAYOR_IGUAL expresion 
{
 printf ("Condicion Simple Mayor Igual Negado\n");
};

condicion_simple : OP_LOG_NOT expresion OP_DISTINTO expresion 
{
 printf ("Condicion Simple Distinto Negado\n");
};

condicion_simple : OP_LOG_NOT expresion OP_IGUAL_IGUAL expresion 
{
 printf ("Condicion Simple Igual Igual Negado\n");
};

condicion_multiple : condicion_simple OP_LOG_AND condicion_simple
{
 printf ("Condicion Multiple AND\n");
};

condicion_multiple : condicion_simple OP_LOG_OR condicion_simple
{
 printf ("Condicion Multiple OR\n");
};


/*Expresiones Matematicas*/

expresion : expresion OP_SUMA termino	
{
 printf ("Expresion = Expresion + termino\n");       
};

expresion : expresion OP_RESTA termino
{
 printf ("Expresion = Expresion - termino\n");     
};
	
expresion : termino	
{
 printf ("Expresion = Termino\n");                        
};

termino : termino OP_MULTIPLICACION factor								
{
 printf ("Termino = Termino * Factor\n");                    
};

termino : termino OP_DIVISION factor	
{
 printf ("Termino = Termino / Factor\n");   
};

termino : factor 
{
 printf ("Termino = Factor\n");
};

factor : CONST_INT	
{
 printf ("Factor = Constante INT\n");                        
};

factor : CONST_FLOAT	
{
 printf ("Factor = Constante REAL\n");                        
};
							
factor: TOKEN_ID			
{
 printf ("Factor = ID\n");                        
};
	
factor: PAR_ABRE expresion PAR_CIERRA 
{
 printf ("Factor = ( EXPRESION )\n");
};


/*Asignaciones*/

sent_asignacion : TOKEN_ID OP_ASIGNACION asignado
{
printf ("Asignacion Simple\n");
};

asignado: expresion 
{
 printf ("Asignacion es una Expresion\n");                        
};

asignado : CONST_STR
{
 printf ("Asignacion es una Constante String\n");                        
};

/*"HOLA"++"MUNDO"*/
asignado : CONST_STR CONCAT CONST_STR	
{
 printf ("Asignacion es Constante String CONCAT Constante String\n"); 
};

/*ID++"HOLA"*/
asignado : TOKEN_ID CONCAT CONST_STR	
{
 printf ("Asignacion es ID CONCAT Constante String\n");    
};

/*"HOLA"++ID*/
asignado : CONST_STR CONCAT TOKEN_ID	
{
 printf ("Asignacion es Constante String CONCAT ID\n");                        
};

/*ID++ID*/
asignado : TOKEN_ID CONCAT TOKEN_ID	
{
 printf ("Asignacion es ID CONCAT ID\n");         
};


/*Sentencia WHILE ESPECIAl*/				
sent_repeat_especial : PR_WHILE estructura_in PR_DO lista_sentencia PR_ENDWHILE
{
	printf("Sentencia WHILE ESPECIAL Estructura\n");
};

estructura_in : TOKEN_ID PR_IN COR_ABRE lista_expresiones COR_CIERRA
{
	printf ("Estructura IN\n");
};

lista_expresiones : expresion | expresion COMA lista_expresiones
{
	printf ("Expresiones en WHILE ESPECIAL\n");
};

/*Sentencia TAKE*/
sentencia_take : PR_TAKE PAR_ABRE definicion_take PAR_CIERRA
{
printf ("Sentencia TAKE\n");
};

definicion_take : OP_SUMA PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE lista_constantes COR_CIERRA | OP_SUMA PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE COR_CIERRA
{
printf ("Definicion TAKE SUMA\n");
};

definicion_take : OP_RESTA PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE lista_constantes COR_CIERRA | OP_RESTA PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE COR_CIERRA
{
printf ("Definicion TAKE RESTA\n");
};

definicion_take : OP_MULTIPLICACION PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE lista_constantes COR_CIERRA | OP_MULTIPLICACION PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE COR_CIERRA
{
printf ("Definicion TAKE MULTIPLICACION\n");
};

definicion_take : OP_DIVISION PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE lista_constantes COR_CIERRA | OP_DIVISION PUNTO_Y_COMA CONST_INT PUNTO_Y_COMA COR_ABRE COR_CIERRA
{
printf ("Definicion TAKE DIVISION\n");
};

lista_constantes:  CONST_INT | lista_constantes PUNTO_Y_COMA CONST_INT
{
printf ("Definicion constantes TAKE\n");
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

/* FUNCIONES */

void agregarATS(char *n,char *vs,int t, int l, double v)
{	int val_func;
	printf("Verifico si %s existe en la TS y agrego... \n",n);
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
		printf("El elemento ya se encuentra en la TS--> Pos: (%d)\n",val_func);
	
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
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	exit(1);
  }
  else
  {
	//Creación del archivo TS.TXT
	if((pfTablaSimbolos = fopen("ts.txt","w")) == NULL)
	{
		printf("\nError al crear el archivo TS.TXT\n");
		exit(1);
	}
	
	yyparse();

  }
  int i;
 //Cargar valores TS en el txt
  fprintf(pfTablaSimbolos,"***El tipo de variable lo determina el caracter que precede a esta última: \n\t _(variable);$(cte float);&(cte int);@(cte string)***\n\n");
  for(i=0;i<topeTS;i++)
	{	
		fprintf(pfTablaSimbolos,"*********************\n");
		fprintf(pfTablaSimbolos,"%s %d", "Pos:",i);
		fprintf(pfTablaSimbolos,"\n");
		fprintf(pfTablaSimbolos,"Nombre: ");
		fprintf(pfTablaSimbolos,tabla[i].nombre);
		fprintf(pfTablaSimbolos,"\n");
		fprintf(pfTablaSimbolos,"Tipo: ");
		fprintf(pfTablaSimbolos,"%d",tabla[i].tipo);
		fprintf(pfTablaSimbolos,"\n");
		fprintf(pfTablaSimbolos,"Longitud: ");
		fprintf(pfTablaSimbolos,"%d",tabla[i].longitud);
		fprintf(pfTablaSimbolos,"\n");
		fprintf(pfTablaSimbolos,"Valor: ");
		if(tabla[i].tipo==CTE_FLT)
		{
			fprintf(pfTablaSimbolos,"%7.10lf",tabla[i].valor);
		}
		else
		{
			fprintf(pfTablaSimbolos,"%ld",tabla[i].valor);
		}
		fprintf(pfTablaSimbolos,"\n");
		fprintf(pfTablaSimbolos,"Valor String: ");
		fprintf(pfTablaSimbolos,tabla[i].valorString);
		fprintf(pfTablaSimbolos,"\n");
	
	}
  fclose(pfTablaSimbolos);
  fclose(yyin);
  return 0;
}

int yyerror(void)
{
	printf("Syntax Error\n");
	system ("Pause");
	exit (1);
}