%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constantes.h"
#include "Terceto.c"
#include "pila.c"

int pgm_ind, programa_ind,tipo_var,condrepeat_ind, condicion_ind, condsimple_ind, condmult_ind,condsimple1_ind,condsimple2_ind;
int termino_ind, factor_ind, expresion_ind,expresion1_ind,expresion2_ind,avg_ind,factorial_ind, nrocomb_ind,asignacion_ind,tokenid_ind,asignado_ind,longitud_cont;
int listaexpr_ind,lista_sentencia_ind,dec_var_ind,dec_var_ind,lista_dec_var_ind,linea_dec_var_ind;
int sentencia_ind, sent_asignacion_ind, sent_read_ind, sent_repeat_ind, sent_write_ind, lista_sentencia_ind,comienzo_if_ind,seleccion_ind,lista_variables_ind;
int concatTokenInd,concatTokenInd2,concatConstInd,concatConstInd2;	
int ultimo=0;

//para condiciones multiples
int condicionesMultiples=0;
int isAnd=0;

//se termino la declaracion de variables?
int finDecVar = 0;

//indice de constantes
int iConstantes = 0;

t_pila pila;


lista_tercetos_t * lista_terceto;
int yystopparser=0;
FILE  *yyin; //Archivo de Entrada
FILE * pfTablaSimbolos; //Tabla de Simbolos
FILE * pfTablaSimbolos2; //Tabla de Simbolos
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
 pgm_ind = programa_ind;
 printf("Start symbol - ¡Compilación exitosa!. \n");
 printf("-------------------. \n");
	DumpLista(&lista_terceto);
};

programa: PR_BEGIN{crear_pila(&pila);} lista_sentencia PR_END 
{
		programa_ind= lista_sentencia_ind;
    if(DEBUG){
				  printf("Programa donde no hubo declaración de variables. \n");
		}
		CrearTerceto(TERC_END,TERC_NULL,TERC_NULL,&lista_terceto);		
};

programa: dec_var PR_BEGIN lista_sentencia PR_END 
{
	//programa_ind=CrearTerceto(dec_var_ind,lista_sentencia_ind,NULL, &lista_terceto);
	if(DEBUG)  {printf("Programa con variables declaradas previamente. \n");}
	CrearTerceto(TERC_END,TERC_NULL,TERC_NULL,&lista_terceto);
};

/*Declaración de Variables*/
dec_var: PR_VAR {agregarCtesGenerales();} lista_dec_var PR_ENDVAR 
{	 
	 finDecVar = 1;	 
	 if(DEBUG) {printf("Bloque con declaracion de las variables. \n");}
};

lista_dec_var: linea_dec_var | lista_dec_var linea_dec_var
{
	 if(DEBUG)  {printf("Múltiples líneas con declaraciones de las variables. \n");}
};

linea_dec_var:  lista_variables DOSPUNTOS tipo
{
	linea_dec_var_ind = lista_variables_ind;
  if(DEBUG)  {printf("Declaracion de variables de cierto tipo. \n");}
};


tipo: PR_INT {tipo_var=CTE_INT;}| PR_FLOAT {tipo_var=CTE_FLT;}| PR_STRING{tipo_var=CTE_STR;}
{
	 if(DEBUG)  {printf("Tipo de variable. \n");}
};																								//Ver aca

lista_variables: TOKEN_ID {
//	lista_variables_ind= CrearTerceto($1,NULL,NULL,&lista_terceto);	
	 agregarTipoIDaTS($1,tipo_var);
	 
		if(DEBUG)  { printf("Variable. \n");}

	}	
	|  lista_variables COMA TOKEN_ID {

//	lista_variables_ind= CrearTerceto(lista_variables_ind,$3,NULL,&lista_terceto);
	 
	agregarTipoIDaTS($3,tipo_var);
		 if(DEBUG)  {printf("lista de variables. \n");}

	}

/*Sentencias*/

lista_sentencia: sentencia
{
	lista_sentencia_ind=sentencia_ind;
  if(DEBUG)  {printf("Sentencia única. \n");      }                      
};

lista_sentencia: sentencia lista_sentencia
{

	//lista_sentencia_ind=CrearTerceto(lista_sentencia_ind,sentencia_ind,NULL,&lista_terceto);
  if(DEBUG)  {printf("Sentencia múltiple. \n");       }                     
};


sentencia: seleccion
{
	sentencia_ind=seleccion_ind;
 if(DEBUG)  {printf("Sentencia Condicional: IF. \n");}
};

sentencia: sent_repeat
{
	sentencia_ind=sent_repeat_ind;
  if(DEBUG)  {printf("Sentencia bucle: REPEAT. \n");   }                         
};


sentencia: sent_asignacion  
{

	sentencia_ind=sent_asignacion_ind;
  if(DEBUG)  {printf("Sentencia: ASIGNACION. \n");    }                        
};

sentencia: sent_write 
{
	sentencia_ind=sent_write_ind;
  if(DEBUG)  {printf("Sentencia: WRITE. \n");   }                         
};

sentencia: sent_read 
{
	sentencia_ind=sent_read_ind;
  if(DEBUG)  {printf("Sentencia: READ. \n");  }                          
};



/*Sentencia WRITE*/
sent_write: PR_WRITE TOKEN_ID
{
	sent_write_ind=CrearTerceto(TERC_WRITE,findIdTS($2),TERC_NULL,&lista_terceto);
  if(DEBUG)  {printf("WRITE de un ID. \n");}
}
																	//Ver como diferenciar ID y CONS a la hora de imprimir 
sent_write: PR_WRITE CONST_STR
{
	sent_write_ind=CrearTerceto(TERC_WRITE,findNombreTS($2),TERC_NULL,&lista_terceto);
  if(DEBUG)  {printf("WRITE de un STRING. \n");}
}

/*Sentencia READ*/
sent_read: PR_READ TOKEN_ID
{
	sent_read_ind=CrearTerceto(TERC_READ,findIdTS($2),TERC_NULL,&lista_terceto);
  if(DEBUG)  {printf("READ de un ID. \n");}
}

/*Sentencia IF */
seleccion: comienzo_if lista_sentencia PR_ENDIF
{	
		int toModificar = 0;
		sacar_de_pila(&pila,&toModificar,10);
		int aDonde =  NumeroUltimoTerceto();

		ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+1, &lista_terceto, toModificar);		
		
		if(condicionesMultiples){
			int toModificar2 = 0;
			sacar_de_pila(&pila,&toModificar2,10);
//		int aDonde2 =  NumeroUltimoTerceto();

			if(isAnd){				
				ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+1, &lista_terceto, toModificar2);				
			}else{
				ModificarTerceto(NO_MODIF, NO_MODIF, toModificar2+1, &lista_terceto, toModificar2);				
				ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+1, &lista_terceto, toModificar);

			}
			isAnd = 0;
			condicionesMultiples = 0;
		}
		 if(DEBUG)  {printf("IF simple. \n");}
};

seleccion: comienzo_if lista_sentencia {

		//Salto a else
		int toModificar = 0;
		sacar_de_pila(&pila,&toModificar,10);
		int aDonde =  NumeroUltimoTerceto();
		ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+2, &lista_terceto, toModificar);		
		
		if(condicionesMultiples){
			int toModificar2 = 0;
			sacar_de_pila(&pila,&toModificar2,10);
//		int aDonde2 =  NumeroUltimoTerceto();

			if(isAnd){				
				ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+2, &lista_terceto, toModificar2);				
			}else{
				ModificarTerceto(NO_MODIF, NO_MODIF, toModificar2+1, &lista_terceto, toModificar2);				
				ModificarTerceto(NO_MODIF, NO_MODIF, aDonde+2, &lista_terceto, toModificar);
			}
			isAnd = 0;
			condicionesMultiples = 0;

		}
		
		//Branch al find
		int ind_bra = CrearTerceto(TERC_BRA,TERC_NULL,TERC_NULL,&lista_terceto);
		
		poner_en_pila(&pila,&ind_bra,10);
}
PR_ELSE lista_sentencia PR_ENDIF
{		
		//salto BRA
		int toModificar = 0;
		
		sacar_de_pila(&pila,&toModificar,10);
		int aDonde =  NumeroUltimoTerceto();

		ModificarTerceto(NO_MODIF, aDonde+1, NO_MODIF, &lista_terceto, toModificar);
							
	 	if(DEBUG)  {printf("IF con bloque ELSE. \n");}
};

comienzo_if: PR_IF PAR_ABRE Condicion PAR_CIERRA PR_THEN
{
	comienzo_if_ind=condicion_ind;
	 if(DEBUG)  {printf("COMIENZO del bloque IF. \n");}
};

sent_repeat: PR_REPEAT{
	int ultimo = NumeroUltimoTerceto()+1;
	 printf("pongo en pila : %d",ultimo);
	poner_en_pila(&pila,&ultimo,10);


} lista_sentencia PR_UNTIL condRepeat
{

	int enPila = 0;
	int enPila2 = 0;
	int toModificar = 0;


	if(condicionesMultiples==1){
		enPila = 0;
		sacar_de_pila(&pila,&enPila,10);
		enPila2  = 0;
		sacar_de_pila(&pila,&enPila2,10);
		toModificar = 0;
		sacar_de_pila(&pila,&toModificar,10);
		if(isAnd){				
				ModificarTerceto(NEGAR, NO_MODIF, enPila+1, &lista_terceto, enPila);
				ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila2);	
			}else{
				ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila);				
				ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila2);

		}
	}else{
		enPila  = 0;
		sacar_de_pila(&pila,&enPila,10);
		toModificar = 0;
		sacar_de_pila(&pila,&toModificar,10);
		printf("to modif: %d", toModificar);
		printf("en pila: %d", enPila);
		ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila);
	}

	condicionesMultiples = 0;
	isAnd = 0;
	 if(DEBUG)  {printf("Sentencia REPEAT completa. \n");}
};

condRepeat: PAR_ABRE Condicion PAR_CIERRA 
{
    condrepeat_ind = condicion_ind;
	 if(DEBUG)  {printf("Condicion del REPEAT. \n");}
};


/*Condiciones*/

/*Agrupo los dos tipos de Condiciones*/
Condicion: Condicion_simple
{
	  int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);
	  printf("pongo en pila : %d",numero);
    condicion_ind = condsimple_ind;
	 if(DEBUG)  {printf("Condicion SIMPLE. \n");}
};

Condicion: Condicion_multiple
{	
		condicionesMultiples=1;
    condicion_ind = condmult_ind;
	 if(DEBUG)  {printf("Condicion MULTIPLE. \n");}
};

Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_MENOR expresion{expresion2_ind=expresion_ind;}
{	
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MENOR), condsimple_ind, TERC_NULL, &lista_terceto);
    
  if(DEBUG)  {printf("Condicion simple con operador Menor. \n");}
};

Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_MENOR_IGUAL expresion{expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MENOR_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  if(DEBUG)  {printf("Condicion simple con operador Menor e Igual. \n");}
};


Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_MAYOR expresion{expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MAYOR),  condsimple_ind, TERC_NULL, &lista_terceto);
  if(DEBUG)  {printf("Condicion simple con operador Mayor. \n");}
};
 	
Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_MAYOR_IGUAL expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MAYOR_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion simple con operador Mayor e Igual. \n");}
};

Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_DISTINTO expresion {expresion2_ind=expresion_ind;}
{
	  condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_DISTINTO), condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion simple con operador Distinto. \n");}
};

Condicion_simple: expresion{expresion1_ind=expresion_ind;} OP_IGUAL_IGUAL expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion simple  con operador Igual Igual. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_MENOR expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MAYOR_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple  con operador Menor Negado. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_MENOR_IGUAL expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MAYOR),  condsimple_ind, TERC_NULL, &lista_terceto);
 		if(DEBUG)  { printf("Condicion Simple  con operador Menor Igual Negado. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_MAYOR expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MENOR_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple  con operador Mayor pero Negado. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_MAYOR_IGUAL expresion {expresion2_ind=expresion_ind;}
{
		condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_MENOR),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple Mayor Igual pero Negado. \n");}
};


Condicion_simple: OP_LOG_NOT expresion
{		
		int cte_ind = CrearTerceto("&cte0", TERC_NULL, TERC_NULL, &lista_terceto);
		condsimple_ind = CrearTerceto(TERC_CMP, expresion_ind, cte_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_DISTINTO),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple expresión negada. \n");}
};

Condicion_simple: expresion
{
		int cte_ind1 = CrearTerceto("&cte1", TERC_NULL, TERC_NULL, &lista_terceto);
		condsimple_ind = CrearTerceto(TERC_CMP, expresion_ind, cte_ind1, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple expresión. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_DISTINTO expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_IGUAL),  condsimple_ind, TERC_NULL, &lista_terceto);
 	  if(DEBUG)  {printf("Condicion Simple Distinto pero Negado. \n");}
};

Condicion_simple: OP_LOG_NOT expresion{expresion1_ind=expresion_ind;} OP_IGUAL_IGUAL expresion {expresion2_ind=expresion_ind;}
{
    condsimple_ind = CrearTerceto(TERC_CMP, expresion1_ind, expresion2_ind, &lista_terceto);
    condsimple_ind = CrearTerceto(NegarOperador(TERC_DISTINTO),  condsimple_ind, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Simple  con operador Igual Igual pero Negado. \n");}
};

Condicion_multiple: Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple1_ind=condsimple_ind;} OP_LOG_AND Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple2_ind=condsimple_ind;}
{	
	isAnd = 1;
    //condmult_ind = CrearTerceto(TERC_AND,condsimple1_ind,condsimple2_ind, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Multiple con operador lógico AND. \n");}
};

Condicion_multiple: Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple1_ind=condsimple_ind;} OP_LOG_OR Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple2_ind=condsimple_ind;}
{
	isAnd = 0;
    //condmult_ind = CrearTerceto(TERC_OR,condsimple1_ind,condsimple2_ind, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Multiple con operador lógico OR. \n");}
};


/*Expresiones Matematicas*/

expresion: expresion OP_SUMA termino	
{
    expresion_ind= CrearTerceto(TERC_SUMA, expresion_ind, termino_ind, &lista_terceto);
  	if(DEBUG)  {printf("Expresión como suma de otra expresión y un término. \n");  }     
};

expresion: expresion OP_RESTA termino
{
    expresion_ind= CrearTerceto(TERC_RESTA, expresion_ind, termino_ind, &lista_terceto);
  	if(DEBUG)  {printf("Expresión como resta de otra expresión y un término. \n");  }   
};
	
expresion: termino	
{
    expresion_ind=termino_ind;
  	if(DEBUG)  {printf("Expresión como un término. \n");   }                     
};

termino: termino OP_MULTIPLICACION factor								
{
    termino_ind= CrearTerceto(TERC_MULT, termino_ind, factor_ind, &lista_terceto);
  	if(DEBUG)  {printf("Término como producto de un término y un factor. \n");         }           
};

termino: termino OP_DIVISION factor	
{
    termino_ind= CrearTerceto(TERC_DIV, termino_ind, factor_ind, &lista_terceto);
  	if(DEBUG)  {printf("Término como cociente de un término y un factor. \n");   }
};

termino: factor 
{
    termino_ind = factor_ind;
 	if(DEBUG)  {printf("Termino como un factor. \n");}
};

factor: CONST_INT	
{	
	//Descomentar esta linea junto con la del léxico si se quieren ver directamente los numeros.
    //factor_ind = CrearTerceto($<intval>1, TERC_NULL, TERC_NULL, &lista_terceto);	
	factor_ind = CrearTerceto(findFloatTS($<intval>1), TERC_NULL, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Factor es una constante entera. \n");   }                     
};

factor: CONST_FLOAT	
{
    factor_ind = CrearTerceto(findFloatTS($<intval>1), TERC_NULL, TERC_NULL, &lista_terceto);
  	if(DEBUG)  {printf("Factor es una Constante real. \n");            }            
};
							
factor: TOKEN_ID			
{
	factor_ind = CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);  
	if(DEBUG)  {printf("Factor es un ID. \n");}   
};
	
factor: PAR_ABRE expresion PAR_CIERRA 
{
    factor_ind = expresion_ind;
  	if(DEBUG)  {printf("Factor es una  ( EXPRESION ). \n");}
};

factor: average			
{
    factor_ind = avg_ind;
	if(DEBUG)  {printf("Factor es un resultado de AVERAGE. \n"); }                       
};

factor: factorial			
{
    factor_ind = factorial_ind;
  	if(DEBUG)  {printf("Factor es un resultado de FACTORIAL. \n"); }                       
};

factor: nrocombinatorio
{
    factor_ind = nrocomb_ind;
  	if(DEBUG)  {printf("Factor es un resultado de NUMERO COMBINATORIO. \n");  }                      
};

/*Asignaciones*/ //Faltan

sent_asignacion: TOKEN_ID OP_ASIGNACION asignado
{
	 tokenid_ind = CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
     asignacion_ind = CrearTerceto(TERC_ASIG, tokenid_ind, asignado_ind, &lista_terceto);
			 
 	 if(DEBUG)  {printf("Asignacion Simple. \n");}
};

asignado: expresion 
{
     asignado_ind = expresion_ind;
 	 if(DEBUG)  {printf("Asignacion a partir de una expresion. \n");  }                      
};

asignado: CONST_STR
{	
     asignado_ind = CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
     if(DEBUG)  {printf("Asignacion a partir de una Constante String. \n");  }                      
};

/*"pepe1"++"pepe2"*/
asignado: CONST_STR CONCAT CONST_STR	
{
	//int concatTokenInd,concatTokenInd2,concatConstInd,concatConstInd2;
	concatConstInd=CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatConstInd2=CrearTerceto(findNombreTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT, concatConstInd, concatConstInd2, &lista_terceto);
	if(DEBUG)  {printf("Asignacion a partir de una concatenación entre constantes String. \n"); }
};

/*ID++"pepe2"*/
asignado: TOKEN_ID CONCAT CONST_STR	
{
	concatTokenInd=CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatConstInd=CrearTerceto(findNombreTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT, concatTokenInd, concatConstInd, &lista_terceto);
	if(DEBUG)  {printf("Asignacion a partir de una concatenación entre un ID string y una constante String. \n");    }
};

/*"pepe1"++ID*/
asignado: CONST_STR CONCAT TOKEN_ID	
{	
	concatConstInd=CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatTokenInd=CrearTerceto(findIdTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT,concatConstInd ,concatTokenInd , &lista_terceto);	
	if(DEBUG)  {printf("Asignacion a partir de una concatenacion entre una constante String y de un ID string. \n");   }                     
};

/*ID++ID*/
asignado: TOKEN_ID CONCAT TOKEN_ID	
{                             
	  concatTokenInd=CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);  
	  concatTokenInd2=CrearTerceto(findIdTS($3), TERC_NULL, TERC_NULL, &lista_terceto);            
      asignado_ind = CrearTerceto(TERC_CONCAT, concatTokenInd, concatTokenInd2, &lista_terceto);
	  if(DEBUG)  {printf("Asignacion a partir de una concatenacion entre dos ID. \n");  }       
};


/***Declaracion Funciónes especiales***/

average: PR_AVERAGE {longitud_cont=0;} PAR_ABRE COR_ABRE lista_expresiones COR_CIERRA PAR_CIERRA
{
	avg_ind = CrearTerceto(TERC_AVG, listaexpr_ind, longitud_cont, &lista_terceto);
	if(DEBUG)  {printf("Función AVERAGE. \n");                            }
};


lista_expresiones: expresion {
		    longitud_cont++;
         //listaexpr_ind = CrearTerceto(expresion_ind, TERC_NULL, TERC_NULL, &lista_terceto);
	    }
        |  lista_expresiones COMA expresion
        {
        
         listaexpr_ind = CrearTerceto(TERC_SUMA,listaexpr_ind ,expresion_ind, &lista_terceto);    
		longitud_cont++;
	}
{
  if(DEBUG)  {printf("Expresión o lista de expresiones. \n");    }                        
};


factorial: PR_FACTORIAL PAR_ABRE expresion PAR_CIERRA
{
    factorial_ind = CrearTerceto(TERC_FACT, expresion_ind, TERC_NULL, &lista_terceto);
    
  if(DEBUG)  {printf("Función FACTORIAL. \n");    }                        
};



nrocombinatorio: PR_COMBINATORIO PAR_ABRE expresion COMA expresion PAR_CIERRA
{
    //VER
    nrocomb_ind = CrearTerceto(TERC_NROCOMB, expresion_ind, expresion_ind, &lista_terceto);
  if(DEBUG)  {printf("Función NÚMERO COMBINATORIO. \n");        }                    
};

%%
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Estructuras de analizador lexico

//Instancia de Tabla de Símbolos
TS tabla[MAX_TS];
//Tope Tabla de Simbolos
int topeTS = 0;
/* FunciónES */
/* De no existir el Token en la tabla de simbolos lo agrega */
void agregarTokenTS(char *n,char *valueString,int type, int l, double value)
{	int pos_token_ts;
	
	if(DEBUG)  { printf("Verifico si %s existe en la Tabla de Simbolos. \n",n);}

	if(type == VRBL)
		pos_token_ts = existeTokenEnTS(n);
	else if(type == CTE_STR)
		pos_token_ts = existeCteString(valueString);
	else
		pos_token_ts = existeCteFloat(value);

	if(pos_token_ts==topeTS)
	{

		if(getfinDecVar() && type == VRBL){
			char msg[STR_VALUE] = "Variable ";
			strcat(msg,n);
			strcat(msg," no declarada previamente");		 
			informeError(msg);
		}		

		if(DEBUG)  {	 printf("\n No existe! Lo agrego en la Posicion: %d. \n",topeTS);}
			strcpy(tabla[topeTS].nombre,n);
			strcpy(tabla[topeTS].valorString,valueString);
			tabla[topeTS].tipo=type;
			tabla[topeTS].longitud=l;
			tabla[topeTS].valor=value;
			topeTS++;
	}
	else
	{
		if(DEBUG)  { printf("El token ya se encuentra en la Tabla de Simbolos. Posicion: (%d). \n",pos_token_ts);}
	
	}
}

void agregarTipoIDaTS(char *n,int type)
{	int pos_token_ts;
	if(DEBUG)  {	 printf("Verifico si %s existe en la Tabla de Simbolos. \n",n);}
	pos_token_ts = existeTokenEnTS(n, type);
	if(pos_token_ts==topeTS)
	{
		if(DEBUG)  {	 printf("\n No existe! Lo agrego en la Posicion: %d. \n",topeTS);}
			tabla[topeTS].tipo=type;
			topeTS++;
	}
	else
	{
		informeError("El id ya estaba declarado. ERROR");	
	}
}


/*Verifica la existencia de un token en la TS. Compara por nombre y de encontrarlo devuelve la pos */
int existeTokenEnTS(char *name, int type)
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
	
	//system("echo hola");
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf(". \nNo se puede abrir el archivo: %s. \n", argv[1]);	 	
		exit(1);
  }
  else
  {
			//Creación del archivo tablaSimbolos.txt
			if((pfTablaSimbolos = fopen("Outputs/tablaSimbolos.txt","w")) == NULL)
			{
				informeError(". \nError al crear el archivo tablaSimbolos.txt. \n");			
			}
			//Creación del archivo tablaSimbolos2.txt
			if((pfTablaSimbolos2 = fopen("Outputs/tablaSimbolos2.txt","w")) == NULL)
			{
				informeError(". \nError al crear el archivo tablaSimbolos2.txt. \n");		 
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
	{
		fprintf(pfTablaSimbolos,"%d", i);
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
			fprintf(pfTablaSimbolos,"\t\t %lf",tabla[i].valor);
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
			fprintf(pfTablaSimbolos2,"%lf",tabla[i].valor);
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

//para ver si existe la constante float
int existeCteFloat(double valor){
	
	int i=0;
	int ret;
	while(i < topeTS){
		if(tabla[i].valor==valor){
			ret = i;
			return ret;
		}
		i++;

	}

	return i;

}

//para constantes float
int findFloatTS(double valor){
	
	int i=0;
	char * ret;
	while(i < topeTS){
		if(tabla[i].valor==valor){
			ret = tabla[i].nombre;
			return ret;
		}
		i++;

	}

	informeError("No existe constante en TS");

}

//para ver si existe la constante string
int existeCteString(int valorString){
	char t_aux[STR_VALUE], sinComillas[STR_VALUE];
	int ret;

	strcpy(t_aux, valorString);
	armarValorYNombreToken(t_aux,sinComillas);
	
	int i=0;
	while(i < topeTS){
		if(strcmp(tabla[i].valorString,t_aux)==0 ){
			ret = i;
			return ret;
		}
		i++;

	}
	
	return i;

}

//para constantes string
int findNombreTS(int valorString){
	char t_aux[STR_VALUE], sinComillas[STR_VALUE];
	char * ret;

	strcpy(t_aux, valorString);
	armarValorYNombreToken(t_aux,sinComillas);
	
	int i=0;
	while(i < topeTS){
		if(strcmp(tabla[i].valorString,t_aux)==0 ){
			ret = tabla[i].nombre;
			return ret;
		}
		i++;

	}
	
	informeError("No existe constante en TS");

}


//para tokens id
int findIdTS(int nombre){
	char t_aux[STR_VALUE], sinComillas[STR_VALUE];
	char * ret;

  strcpy(t_aux,"_");
	strcat(t_aux, nombre);										
	
	int i=0;
	while(i < topeTS){
		if(strcmp(tabla[i].nombre,t_aux)==0 ){
			ret = tabla[i].nombre;
			return ret;
		}
		i++;

	}

	informeError("No existe el id en TS");

}

void ObtenerItemTS(int ind, TS *reg){
	int pos=0;
	while(pos <= ultimo){
		if(pos == ind){
			*reg = tabla[ind];
			break;
		}	
		pos++;
	}	
}


int getfinDecVar(){
	return finDecVar;
}


int yyerror(void)
{
	printf("Syntax Error. \n");
	getchar();
	exit(1);
}

void agregarCtesGenerales(){
	char aux[STR_VALUE];
	if(DEBUG){ 
		printf( "Agregando constantes generales");			
	}	
	
	strcpy(aux,"&cte0");	
	agregarTokenTS(aux,"-",CTE_INT,0,0);	
	incrementarIConstantes();

	strcpy(aux,"&cte1");	 
	float t = 1;
	agregarTokenTS(aux,"-",CTE_INT,0,t);
	incrementarIConstantes();

}

void setiConstantes(int value){
	iConstantes = value;
}

int incrementarIConstantes(){
	iConstantes++;
	return iConstantes;
}

int getiConstantes(){
	return iConstantes;
}