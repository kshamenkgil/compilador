%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constantes.h"
#include "lista_dinamica.c"
#include "pilaDinamica.c"
#include "tipos.h"

int debug=1;
int yystopparser=0;
FILE  *yyin; //Archivo de Entrada
FILE * pfTablaSimbolos; //Tabla de Simbolos
FILE * pfTablaSimbolos2; //Tabla de Simbolos

************************** Estructura de Tercetos en tipos.h *****************************

int cant_tercetos = 0;
Lista <estructura_tercetos> lista_tercetos;
Lista <estructura_tercetos> lista_tercetos_aux;

************************* Estructura de ID ********************************************

int cant_id = 0;
int cant_var = 1;
Lista <estructura_id> lista_id, lista_var;


************************* Estructura de Tipo de dato ********************************************

int cant_tipo = 0;
estructura_tipo estruc_tipo;
Lista <estructura_tipo> lista_tipo;

************************* Pila de Tercetos ********************************************

int cantidad_pila = 0;
estructura_pila pila;
Pila <estructura_pila> pila_tercetos;

********************************************

//Contadores de Etiquetas
int cant_etiq_if = 0;
int cant_etiq_while = 0;
int cant_etiq_repeat = 0;
int cant_etiq_filter = 0;

Pila <pila_cont_etiquetas> pila_etiquetas;
int cont_expresion = 0;


************************************* Tabla de Simbolos *********************************************

//Estructuras de analizador lexico
typedef struct tablaS {
       char nombre [100]; //si el nombre le precede un "_" entonces es una variable, si tiene $ entonces es real y si tiene & es int,    
                          //si tiene un @ es una cte string.
       int tipo; // 0 es palabra reservada, 1 es variable, 2 constante
       double valor;
       int longitud;
       char valorString [COTA_STR]; /*Guarda valor de las variables tipo string. De no ser un string guarda un "-"*/
}TS;

//Instancia de Tabla de Símbolos
TS tabla[MAX_TS];

//Tope Tabla de Simbolos
int topeTS = 0;

******************************************

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
	if(debug){
 			printf("Start symbol - ¡Compilación exitosa!. \n");
 			printf("-------------------. \n");
	}

	 strcpy(tercetos.parametro_1, "END" );
     strcpy(tercetos.parametro_2, "-" );
     strcpy(tercetos.parametro_3, "-" );
     lista_tercetos.Insertar_al_final(tercetos);
     cantidad_tercetos++;
};

programa: PR_BEGIN lista_sentencia PR_END 
{
	if(debug){
		printf("Programa donde no hubo declaración de variables. \n");
	}
};

programa: dec_var PR_BEGIN lista_sentencia PR_END 
{
	if(debug){
		printf ("Programa con variables declaradas previamente. \n");
	}
};

/*Declaración de Variables*/
dec_var: PR_VAR lista_dec_var PR_ENDVAR
{
	if(debug){
	 printf ("Bloque con declaracion de las variables. \n");
	}
};

lista_dec_var: linea_dec_var | lista_dec_var linea_dec_var
{
	if(debug){
		printf("Múltiples líneas con declaraciones de las variables. \n");
	}
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
	if(debug){
 		printf ("WRITE de un ID. \n");
	}

	 strcpy(tercetos.parametro_1, "WRITE");
 	 pila = pila_tercetos.Sacar();
     cantidad_pila--;
                  
    strcpy(tercetos.parametro_2, "-");
    strcpy(tercetos.parametro_3, pila.parametro);
    lista_tercetos.Insertar_al_final(tercetos);
    cantidad_tercetos++; 


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
	if(debug){
		printf("IF simple. \n");
	}

	if(strcmp (pila.parametro, "DOBLE_CONDICION") == 0){
		corregir_salto_doble_if(cantidad_tercetos+1);
	}    
	else // es condición simple
		corregir_salto_if(cantidad_tercetos+1, "BF");

	generar_terceto_etiqueta(TERMINA_IF);




};

seleccion: comienzo_if lista_sentencia comienzo_else lista_sentencia fin_if
{
	if(debug){
		printf("IF con bloque ELSE. \n");
	}
	
	pila = pila_tercetos.Sacar();
	cantidad_pila--;
	
	if(strcmp (pila.parametro, "COND_DOBLE") == 0){
		corregir_salto_doble_if(cantidad_tercetos+2);
	}
	else{ // es condición simple
		corregir_salto_if(cantidad_tercetos+2, "BF");
	}                  
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



/* FunciónES */

/* De no existir el Token en la tabla de simbolos lo agrega */

void agregarTokenTS(char *n,char *valueString,int type, int l, double value)
{	int pos_token_ts;
	printf("Verifico si %s existe en la Tabla de Simbolos. \n",n);
	pos_token_ts = existeTokenEnTS(n);
	if(pos_token_ts==topeTS)
	{
			printf("\n No existe! Lo agrego en la Posicion: %d. \n",topeTS);

			strcpy(tabla[topeTS].nombre,n);
			strcpy(tabla[topeTS].valorString,valueString);
			tabla[topeTS].tipo=type;
			tabla[topeTS].longitud=l;
			tabla[topeTS].valor=value;
			topeTS++;
	}
	else
	{
		printf("El token ya se encuentra en la Tabla de Simbolos. Posicion: (%d). \n",pos_token_ts);
	
	}
}


/*Verifica la existencia de un token en la TS. Compara por nombre y de encontrarlo devuelve la pos */

int existeTokenEnTS(char *name)
{
	int pos;
	for(pos=0;pos<topeTS;pos++)
		if(strcmp(name, tabla[pos].nombre)==0)
			return pos;
	return pos;
}

/* Esta funcion arma el nombre del token y el valor del string. Para el nombre del token reemplaza los ' ' por '_'. */
/* Para el nombre del token y el valor del string saltea los '"'. */

void armarValorYNombreToken(char *a, char *yt)
{
	char nombre_token[COTA_STR],valor_token[COTA_STR];
	int i,j=0,z=0;
	for(i=0;i<strlen(a);i++){
			if(a[i]!='"'&&a[i]!=' ')
				{
					nombre_token[j]=a[i];
					valor_token[z]=a[i];
					j++;
					z++;
				}
			if(a[i]==' ')
				{
					nombre_token[j]='_';
					valor_token[z]=a[i];
					j++;
					z++;
				}	
		}
	nombre_token[j]='\0';
	valor_token[z]='\0';
	strcpy(a,nombre_token);
	strcpy(yt,valor_token);

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
	//Creación del archivo tablaSimbolos.txt
	if((pfTablaSimbolos = fopen("tablaSimbolos.txt","w")) == NULL)
	{
		printf(". \nError al crear el archivo tablaSimbolos.txt. \n");
		exit(1);
	}
	//Creación del archivo tablaSimbolos2.txt
	if((pfTablaSimbolos2 = fopen("tablaSimbolos2.txt","w")) == NULL)
	{
		printf(". \nError al crear el archivo tablaSimbolos2.txt. \n");
		exit(1);
	}
	
	yyparse();

  }
  int i;
  //Genero la primer tabla de simbolos
//Imprimir TS en el txt
 fprintf(pfTablaSimbolos,"\t\t\t ******Tabla de Simbolos******\n\n");
 fprintf(pfTablaSimbolos,"***El tipo de variable lo determina el caracter que precede a esta última:\n\t _(variable);$(cte float);&(cte int);@(cte string)***\n");
 fprintf(pfTablaSimbolos,"****************************************************************************\n\n");
 fprintf(pfTablaSimbolos,"Posicion");
 fprintf(pfTablaSimbolos,"\t\t Nombre ");
 fprintf(pfTablaSimbolos,"\t\t Tipo");
 fprintf(pfTablaSimbolos,"\t\t Longitud");
 fprintf(pfTablaSimbolos,"\t\t Valor");
 fprintf(pfTablaSimbolos,"\t\t Valor String");
 fprintf(pfTablaSimbolos,"\n\n");

  for(i=0;i<topeTS;i++)
	{	fprintf(pfTablaSimbolos,"%d", "Pos:",i);
		fprintf(pfTablaSimbolos,"\t\t\t ");
		fprintf(pfTablaSimbolos,tabla[i].nombre);
		fprintf(pfTablaSimbolos,"\t\t\t %d",tabla[i].tipo);
		fprintf(pfTablaSimbolos,"\t\t\t %d",tabla[i].longitud);
		if(tabla[i].tipo==CTE_FLT)
		{
			fprintf(pfTablaSimbolos,"\t\t %7.10lf",tabla[i].valor);
		}
		else
		{
			fprintf(pfTablaSimbolos,"\t\t %ld",tabla[i].valor);
		}
		fprintf(pfTablaSimbolos,"\t\t ");
		fprintf(pfTablaSimbolos,tabla[i].valorString);
		fprintf(pfTablaSimbolos,"\n\n");
	
	}

	//Genero la 2da tabla de simbolos
	//Genero la primer tabla de simbolos
//Imprimir TS en el txt
 fprintf(pfTablaSimbolos2,"\t\t\t ******Tabla de Simbolos******\n\n");
 fprintf(pfTablaSimbolos2,"***El tipo de variable lo determina el caracter que precede a esta última:\n\t _(variable);$(cte float);&(cte int);@(cte string)***\n");
 fprintf(pfTablaSimbolos2,"****************************************************************************");
 

  for(i=0;i<topeTS;i++)
	{	
		fprintf(pfTablaSimbolos2,"\n\n");
		fprintf(pfTablaSimbolos2,"Posicion: ");
		fprintf(pfTablaSimbolos2,"%d",i);
 		fprintf(pfTablaSimbolos2,"\nNombre: ");
		 fprintf(pfTablaSimbolos2,tabla[i].nombre);
 		fprintf(pfTablaSimbolos2,"\nTipo: ");
		 fprintf(pfTablaSimbolos2,"%d",tabla[i].tipo);
 		fprintf(pfTablaSimbolos2,"\nLongitud: ");
		 fprintf(pfTablaSimbolos2,"%d",tabla[i].longitud);
 		fprintf(pfTablaSimbolos2,"\nValor: ");
 		if(tabla[i].tipo==CTE_FLT)
		{
			fprintf(pfTablaSimbolos2,"%7.10lf",tabla[i].valor);
		}
		else
		{
			fprintf(pfTablaSimbolos2,"%ld",tabla[i].valor);
		}
		 fprintf(pfTablaSimbolos2,"\nValor String: ");
		fprintf(pfTablaSimbolos2,tabla[i].valorString);
		fprintf(pfTablaSimbolos2,"\n\n");
		fprintf(pfTablaSimbolos2,"****************************************************************************");
	
	}
  fclose(pfTablaSimbolos2);
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


*************************************************** FUNCIONES ESPECIALES DE TERCETOS ***************************************************************

void generar_terceto_etiqueta(int etiqueta)
{
    char aux[4];
	// Se encuentra en tipos.h
    estructura_pila pila_aux;
    switch (etiqueta)
       {
        case EMPIEZA_IF:
                           cant_etiq_if++;
                           struc_etiq.contador = cant_etiq_if;
                           strcpy(struc_etiq.sentencia, "COMIENZO_IF_");
                           pila_etiquetas.Poner (struc_etiq);
			   sprintf(aux,"%u",cant_etiq_if);
                           strcpy(tercetos.parametro_3, "");
                           strcat(tercetos.parametro_3, "COMIENZO_IF_");
                           strcat(tercetos.parametro_3, aux);
                           strcpy(tercetos.parametro_2, "-");
                           strcpy(tercetos.parametro_1, "ETIQ");
                           break;

        case ELSE:
                      struc_etiq = pila_etiquetas.Sacar ();
		      sprintf(aux,"%u",struc_etiq.contador);
                      strcpy(tercetos.parametro_3, "");
                      strcat(tercetos.parametro_3, "ELSE_IF_");
                      strcat(tercetos.parametro_3, aux);
                      strcpy(tercetos.parametro_2, "-");
                      strcpy(tercetos.parametro_1, "ETIQ");
                      pila_etiquetas.Poner (struc_etiq);
                      break;

        case TERMINA_IF:
                      struc_etiq = pila_etiquetas.Sacar();
		      sprintf(aux,"%u",struc_etiq.contador);
                      strcpy(tercetos.parametro_3, "");
                      strcat(tercetos.parametro_3, "FIN_IF_");
                      strcat(tercetos.parametro_3, aux);
                      strcpy(tercetos.parametro_2, "-");
                      strcpy(tercetos.parametro_1, "ETIQ");
                      break;
        case COND2:
                   //Guardo numero de terceto de segunda condicion
                    pila_aux = pila_tercetos.Sacar();
                   //Nexo logico (AND u OR)  
                   pila = pila_tercetos.Sacar();
                   
                   //Si es OR debo generar terceto de etiqueta
                   if (strcmp(pila.parametro,"OR") == 0)
                      {
                      struc_etiq = pila_etiquetas.Sacar ();
                      strcpy(tercetos.parametro_3, "");
                      strcat(tercetos.parametro_3, struc_etiq.sentencia);
                      strcat(tercetos.parametro_3, "_COND2");
                      strcpy(tercetos.parametro_2, "-");
                      strcpy(tercetos.parametro_1, "ETIQ");
                      
                      pila_etiquetas.Poner (struc_etiq);
                      pila_tercetos.Poner(pila);  
                      pila_tercetos.Poner(pila_aux);
                      }
                   else
                      {
                       pila_tercetos.Poner(pila);  
                       pila_tercetos.Poner(pila_aux);
                       return;
                      }
                    break;

        case COMIENZO_WHILE:
                       cant_etiq_while++;
                       struc_etiq.contador = cant_etiq_while;
                       strcpy(struc_etiq.sentencia, "COMIENZO_WHILE_");
                       pila_etiquetas.Poner (struc_etiq);
		       sprintf(aux,"%u",cant_etiq_while);
                       strcpy(tercetos.parametro_3, "");
                       strcat(tercetos.parametro_3, "COMIENZO_WHILE_");
                       strcat(tercetos.parametro_3, aux);
                       strcpy(tercetos.parametro_2, "-");
                       strcpy(tercetos.parametro_1, "ETIQ");
                       break;

        case WHILE_VERDAD:
                      struc_etiq = pila_etiquetas.Sacar ();
		      sprintf(aux,"%u",struc_etiq.contador);
                      strcpy(tercetos.parametro_3, "");
                      strcat(tercetos.parametro_3, "WHILE_VERDAD_");
                      strcat(tercetos.parametro_3, aux);
                      strcpy(tercetos.parametro_2, "-");
                      strcpy(tercetos.parametro_1, "ETIQ");
                      pila_etiquetas.Poner (struc_etiq);
                      break;

        case FIN_WHILE:
                      struc_etiq = pila_etiquetas.Sacar ();
		      sprintf(aux,"%u",struc_etiq.contador);
                      strcpy(tercetos.parametro_3, "");
                      strcat(tercetos.parametro_3, "FIN_WHILE_");
                      strcat(tercetos.parametro_3, aux);
                      strcpy(tercetos.parametro_2, "-");
                      strcpy(tercetos.parametro_1, "ETIQ");
                      break;     
        }     
        lista_tercetos.Insertar_al_final(tercetos);
        cantidad_tercetos++;
}


/******************************************************************************/
void corregir_salto_doble_if (int p_salto)
{
    char aux[MAX];
    int aux2;
    char cond2[MAX];
    
    pila = pila_tercetos.Sacar();
    cantidad_pila--;
    strcpy(cond2, pila.parametro);
    pila = pila_tercetos.Sacar();
    cantidad_pila--;
    if (strcmp (pila.parametro, "AND") == 0)
    {
        pila = pila_tercetos.Sacar();
        cantidad_pila--;
        /* Corregir salto para condicion 1 */
  	sprintf(aux,"%lu", p_salto);
    	strcpy(tercetos.parametro_3,"");
        strcat(tercetos.parametro_3,"[");
    	strcat(tercetos.parametro_3,aux);
    	strcat(tercetos.parametro_3,"]");
    	strcpy(tercetos.parametro_1, "BF" );
        strcpy(tercetos.parametro_2, "-" );
        aux2 = atoi(pila.parametro);
        lista_tercetos.Modificar(tercetos, aux2);
        
        /* Corregir salto para condicion 2 */
        aux2 = atoi(cond2);
        lista_tercetos.Modificar(tercetos, aux2);         	                
    }
    else /* es OR*/
    {
         pila = pila_tercetos.Sacar();
        cantidad_pila--;
        /* Corregir salto para condicion 1 */
        aux2 = atoi(cond2);
        aux2++;
  	sprintf(aux,"%lu", aux2);
    	strcpy(tercetos.parametro_3,"");
        strcat(tercetos.parametro_3,"[");
    	strcat(tercetos.parametro_3,aux);
    	strcat(tercetos.parametro_3,"]");
    	strcpy(tercetos.parametro_1, "BV" );
        strcpy(tercetos.parametro_2, "-" );
        aux2 = atoi(pila.parametro);
        lista_tercetos.Modificar(tercetos, aux2);
        
        /* Corregir salto para condicion 2 */
  	sprintf(aux,"%lu", p_salto);
    	strcpy(tercetos.parametro_3,"");
        strcat(tercetos.parametro_3,"[");
    	strcat(tercetos.parametro_3,aux);
    	strcat(tercetos.parametro_3,"]");
    	strcpy(tercetos.parametro_1, "BF" );
        strcpy(tercetos.parametro_2, "-" );
        aux2 = atoi(cond2);
        lista_tercetos.Modificar(tercetos, aux2); 
    }
}
;
/****************************************************************************** /
//Corrige salto para el número de terceto desapilado antes de llamada la función
void corregir_salto_if (int p_salto, char bifurcacion[MAX])
{
    char aux[MAX];
    int aux2;
    
    sprintf(aux,"%u", p_salto);
    
    strcpy(tercetos.parametro_3,"");
    strcat(tercetos.parametro_3,"[");
    strcat(tercetos.parametro_3,aux);
    strcat(tercetos.parametro_3,"]");
    
    strcpy(tercetos.parametro_1, bifurcacion );
    strcpy(tercetos.parametro_2, "-" );
    aux2 = atoi(pila.parametro);
    printf("par: %d",aux2);
    lista_tercetos.Modificar(tercetos, aux2);
}
