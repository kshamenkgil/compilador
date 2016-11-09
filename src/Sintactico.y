%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"
#include "tablaSimbolos.h"
#include "constantes.h"
#include "Terceto.h"
#include "pila.h"
#include "asm.h"

int pgm_ind, programa_ind,tipo_var,condrepeat_ind, condicion_ind, condsimple_ind, condmult_ind,condsimple1_ind,condsimple2_ind;
int termino_ind, factor_ind, expresion_ind,expresion1_ind,expresion2_ind,avg_ind,factorial_ind, nrocomb_ind,asignacion_ind,tokenid_ind,asignado_ind;
int listaexpr_ind,lista_sentencia_ind,dec_var_ind,dec_var_ind,lista_dec_var_ind,linea_dec_var_ind;
int sentencia_ind, sent_asignacion_ind, sent_read_ind, sent_repeat_ind, sent_write_ind, lista_sentencia_ind,comienzo_if_ind,seleccion_ind,lista_variables_ind;
int concatTokenInd,concatTokenInd2,concatConstInd,concatConstInd2;	
int expresion_primer_comb;
int primer_resultado;
int resultadoTotal;
int ultimo=0;
int auxK,auxN, auxCombTotal,auxNValor;
int auxiliarAvg;
int t2=0, t1=0;
int concatFlag = 0;

double longitud_cont;
t_pila lastTokenIdPos;

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
	
	imprimirTabla();
	DumpLista(&lista_terceto);	
	generarASM(&lista_terceto,concatFlag);

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


tipo: PR_INT {
	int i = 0;
	TS elemento;
	tipo_var=CTE_INT;
	for(i = 0; i < getTopeTS(); i++){
        elemento = getItemTS(i);
		if(elemento.tipo == VRBL){
			agregarTipoIDaTS(elemento.nombre,tipo_var);
		}
	}
}
| PR_FLOAT {
	int i = 0;
	TS elemento;
	tipo_var=CTE_FLT;
	for(i = 0; i < getTopeTS(); i++){
        elemento = getItemTS(i);
		if(elemento.tipo == VRBL){
			agregarTipoIDaTS(elemento.nombre,tipo_var);
		}
	}
}
| PR_STRING{
	int i = 0;
	TS elemento;
	tipo_var=CTE_STR;
	for(i = 0; i < getTopeTS(); i++){
        elemento = getItemTS(i);
		if(elemento.tipo == VRBL){
			agregarTipoIDaTS(elemento.nombre,tipo_var);
		}
	}
}
{
	 if(DEBUG)  {printf("Tipo de variable. \n");}
};

lista_variables: TOKEN_ID {
	if(DEBUG)  { printf("Variable. \n");}

}	
|  lista_variables COMA TOKEN_ID {

	if(DEBUG)  {printf("lista de variables. \n");}

};

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
		CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);
		int aDonde =  NumeroUltimoTerceto()-1;

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
		int ind_bra = CrearTerceto(TERC_JMP,TERC_NULL,TERC_NULL,&lista_terceto);
		int nroLastTerc = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);
		poner_en_pila(&pila,&ind_bra,10);
		//poner_en_pila(&pila,&nroLastTerc,10);
}
PR_ELSE lista_sentencia PR_ENDIF
{		
		//salto BRA
		int toModificar = 0;
		
		sacar_de_pila(&pila,&toModificar,10);
		CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);
		int aDonde =  NumeroUltimoTerceto()-1;

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
	/*printf("ultimo: %d\n",ultimo);
	getchar();*/
	poner_en_pila(&pila,&ultimo,10);
	CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);


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
				ModificarTerceto(NEGAR, NO_MODIF, enPila2+1, &lista_terceto, enPila2);
				//ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila);	
				ModificarTerceto(NEGAR, NO_MODIF, enPila, &lista_terceto, toModificar);
			}else{
				//ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila2);				
				ModificarTerceto(NEGAR, NO_MODIF, enPila2, &lista_terceto,toModificar);
				//ModificarTerceto(NEGAR, NO_MODIF, toModificar, &lista_terceto, enPila);
				ModificarTerceto(NEGAR, NO_MODIF, enPila, &lista_terceto, toModificar);
		}
	}else{		
		enPila  = 0;
		/*printf("---------------------");
		while(tope_pila(&pila,&enPila,10) != PILA_VACIA){
			sacar_de_pila(&pila,&enPila,10);
			printf("?: %d",enPila);
			getchar();
		}
		printf("---------------------");*/
		sacar_de_pila(&pila,&enPila,10);
		//sacar_de_pila(&pila,&enPila,10);
		
		//printf("enPila: %d\n",enPila);
		t1 = enPila;
		
		toModificar = 0;
		sacar_de_pila(&pila,&toModificar,10);
		//sacar_de_pila(&pila,&toModificar,10);
		//printf("to modif:%d\n",toModificar);
		t2 = toModificar;
		ModificarTerceto(NEGAR, NO_MODIF, t2, &lista_terceto, t1);
		//ModificarTerceto(NEGAR, NO_MODIF, enPila, &lista_terceto, toModificar);
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
	  CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);
	  //printf("pongo en pila : %d",numero);
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

Condicion_multiple: Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple1_ind=condsimple_ind;CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);} OP_LOG_AND Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);condsimple2_ind=condsimple_ind;}
{	
	isAnd = 1;
    //condmult_ind = CrearTerceto(TERC_AND,condsimple1_ind,condsimple2_ind, &lista_terceto);
  	if(DEBUG)  {printf("Condicion Multiple con operador lógico AND. \n");}
};

Condicion_multiple: Condicion_simple {int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);condsimple1_ind=condsimple_ind;CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);} OP_LOG_OR Condicion_simple {;int numero = NumeroUltimoTerceto(); poner_en_pila(&pila,&numero,10);CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);condsimple2_ind=condsimple_ind;}
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
	int pos = existeTokenEnTS(findIdTS($1),NULL);
	verificarTipos(pos,CTE_STR,0);
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

sent_asignacion: TOKEN_ID {

	int posicionToken = existeTokenEnTS(findIdTS($1),NULL);
	poner_en_pila(&lastTokenIdPos,&posicionToken,10);

} OP_ASIGNACION asignado
{
	 tokenid_ind = CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
     asignacion_ind = CrearTerceto(TERC_ASIG, tokenid_ind, asignado_ind, &lista_terceto);
			 
 	 if(DEBUG)  {printf("Asignacion Simple. \n");}
};

asignado: expresion 
{
	int posToken;
	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,0);
     asignado_ind = expresion_ind;
 	 if(DEBUG)  {printf("Asignacion a partir de una expresion. \n");  }                      
};

asignado: CONST_STR
{	
	int posToken;
	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,1);
     asignado_ind = CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
     if(DEBUG)  {printf("Asignacion a partir de una Constante String. \n");  }                      
};

/*"pepe1"++"pepe2"*/
asignado: CONST_STR CONCAT CONST_STR	
{
	int posToken;
	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,1);
	concatFlag = 1;
	//int concatTokenInd,concatTokenInd2,concatConstInd,concatConstInd2;
	concatConstInd=CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatConstInd2=CrearTerceto(findNombreTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT, concatConstInd, concatConstInd2, &lista_terceto);
	if(DEBUG)  {printf("Asignacion a partir de una concatenación entre constantes String. \n"); }
};

/*ID++"pepe2"*/
asignado: TOKEN_ID CONCAT CONST_STR	
{
	concatFlag = 1;
	//Lo pongo en pila por convencion. Asi queda todo igual #NoMePuteen
	int posicionToken = existeTokenEnTS(findIdTS($1),NULL);
	int posToken = posicionToken;
	verificarTipos(posToken,CTE_STR,1);

	posToken;
	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,1);

	concatTokenInd=CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatConstInd=CrearTerceto(findNombreTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT, concatTokenInd, concatConstInd, &lista_terceto);
	if(DEBUG)  {printf("Asignacion a partir de una concatenación entre un ID string y una constante String. \n");    }
};

/*"pepe1"++ID*/
asignado: CONST_STR CONCAT TOKEN_ID	
{	
	concatFlag = 1;
	int posicionToken = existeTokenEnTS(findIdTS($3),NULL);
	int posToken = posicionToken;
	verificarTipos(posToken, CTE_STR,1);

	posToken;
	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,1);

	concatConstInd=CrearTerceto(findNombreTS($1), TERC_NULL, TERC_NULL, &lista_terceto);
	concatTokenInd=CrearTerceto(findIdTS($3), TERC_NULL, TERC_NULL, &lista_terceto);
	asignado_ind = CrearTerceto(TERC_CONCAT,concatConstInd ,concatTokenInd , &lista_terceto);	
	if(DEBUG)  {printf("Asignacion a partir de una concatenacion entre una constante String y de un ID string. \n");   }                     
};

/*ID++ID*/
asignado: TOKEN_ID CONCAT TOKEN_ID	
{     

	concatFlag = 1;
	//Lo pongo en pila por convencion. Asi queda todo igual #NoMePuteen
	int posicionToken = existeTokenEnTS(findIdTS($1),NULL);
	poner_en_pila(&lastTokenIdPos,&posicionToken,10);

	//Lo pongo en pila por convencion. Asi queda todo igual #NoMePuteen
	posicionToken = existeTokenEnTS(findIdTS($3),NULL);
	poner_en_pila(&lastTokenIdPos,&posicionToken,10);



	  int posToken;
	  sacar_de_pila(&lastTokenIdPos,&posToken,10);
	  verificarTipos(posToken, CTE_STR,1);
	  sacar_de_pila(&lastTokenIdPos,&posToken,10);
	  verificarTipos(posToken, CTE_STR,1);        

	sacar_de_pila(&lastTokenIdPos,&posToken,10);
	verificarTipos(posToken,CTE_STR,1);


	  concatTokenInd=CrearTerceto(findIdTS($1), TERC_NULL, TERC_NULL, &lista_terceto);  
	  concatTokenInd2=CrearTerceto(findIdTS($3), TERC_NULL, TERC_NULL, &lista_terceto);            
      asignado_ind = CrearTerceto(TERC_CONCAT, concatTokenInd, concatTokenInd2, &lista_terceto);
	  if(DEBUG)  {printf("Asignacion a partir de una concatenacion entre dos ID. \n");  }       
};


/***Declaracion Funciónes especiales***/

average: PR_AVERAGE {longitud_cont=0;} PAR_ABRE COR_ABRE lista_expresiones COR_CIERRA PAR_CIERRA
{

	char tBuffer[STR_VALUE],tBuffer2[STR_VALUE];
	
	//Auxiliar para la expresion
	strcpy(tBuffer,"@aux"); //valor
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);

	int valor = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,longitud_cont);
	


	int aux  = CrearTerceto(findAuxTS(auxiliarAvg),TERC_NULL,TERC_NULL,&lista_terceto);
	int dividir  = CrearTerceto(findAuxTS(valor),TERC_NULL,TERC_NULL,&lista_terceto);
	avg_ind = CrearTerceto(TERC_DIV, aux, dividir, &lista_terceto);
	if(DEBUG)  {printf("Función AVERAGE. \n");}
};


lista_expresiones: expresion {
			char tBuffer[STR_VALUE],tBuffer2[STR_VALUE];
				//Auxiliar total
				strcpy(tBuffer,"@aux"); //total
				sprintf(tBuffer2,"%d",getiConstantes());
				strcat(tBuffer,tBuffer2);
				auxiliarAvg = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);
		  		longitud_cont++;
				int aux = CrearTerceto(findAuxTS(auxiliarAvg),TERC_NULL,TERC_NULL,&lista_terceto);
         		listaexpr_ind =CrearTerceto(TERC_ASIG,aux,expresion_ind, &lista_terceto);
	    }
|  lista_expresiones COMA expresion
        {
       		 int aux = 	CrearTerceto(findAuxTS(auxiliarAvg),TERC_NULL,TERC_NULL,&lista_terceto);
        	 int listaexpr_ind = CrearTerceto(TERC_SUMA, expresion_ind ,aux, &lista_terceto);
			  aux = CrearTerceto(findAuxTS(auxiliarAvg),TERC_NULL,TERC_NULL,&lista_terceto);
		 	listaexpr_ind = CrearTerceto(TERC_ASIG,aux,listaexpr_ind, &lista_terceto); 
			longitud_cont++;
	}
{
  if(DEBUG)  {printf("Expresión o lista de expresiones. \n");    }                        
};



factorial: PR_FACTORIAL PAR_ABRE expresion PAR_CIERRA
{	
	/*****
	Ejemplo en C:

	int valor = 5;
	int total;

	total = valor;
	while(valor>0){
		valor = (valor-1);
		total = total * valor; 
	}

	En ASM sería (pseudocodigo):

	FACTORIAL:
	mov r1, expresion	
	mov @auxValor,r1
	mov r1,@auxValor
	mov @auxTotal,r1
	mov @auxTotal,r1
	mov @auxValor,r1
	sub r1,1
	mov @auxValor,r1
	mul @auxTotal, @auxValor //supongo que guarda en r1
	mov @auxTotal,r1
	cmp @auxValor,0
	jne FACTORIAL
	mov _variable, @auxTotal

	*****/

	char tBuffer[STR_VALUE],tBuffer2[STR_VALUE];
	int salto;//,etiq1,etiq2;

	//Auxiliar para la expresion
	strcpy(tBuffer,"@aux"); //valor
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);

	int pos = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar total
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int posTotal = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//valor = expresion
	int aux1 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxExpresion = CrearTerceto(TERC_ASIG,aux1,expresion_ind,&lista_terceto);
	
	//if 1 o 0
	//inicializo en 1
	int auxInicializador = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1

	int aux2Init = CrearTerceto(findAuxTS(posTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotalInit = CrearTerceto(TERC_ASIG,aux2Init,auxInicializador,&lista_terceto);	

	int auxConst1 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro1 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp1 = CrearTerceto(TERC_CMP,auxOtro1,auxConst1,&lista_terceto); //cmp auxExpresion, 0	
	int auxJNE1 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE
	//etiq1 = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	int auxConst0 = CrearTerceto("&cte0",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro2 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp2 = CrearTerceto(TERC_CMP,auxOtro2,auxConst0,&lista_terceto); //cmp auxExpresion, 0
	//etiq2 = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto);
	int auxJNE2 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE
	//CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	//total = valor
	int auxOtro = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux2 = CrearTerceto(findAuxTS(posTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotal = CrearTerceto(TERC_ASIG,aux2,auxOtro,&lista_terceto);

	//Numero de salto
	//int salto = NumeroUltimoTerceto()+1;
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	//valor = (valor - 1)
	int aux3 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux4 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxResta = CrearTerceto(TERC_RESTA,aux3,aux4,&lista_terceto); 

	int aux5 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	auxExpresion = CrearTerceto(TERC_ASIG,aux5,auxResta,&lista_terceto);	
	
	//Multiplicacion por el anterior
	aux5 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux6 = CrearTerceto(findAuxTS(posTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxMultiplicacion = CrearTerceto(TERC_MULT,aux6,aux5,&lista_terceto);//auxExpresion

	int aux7 = CrearTerceto(findAuxTS(posTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotal = CrearTerceto(TERC_ASIG,aux7,auxMultiplicacion,&lista_terceto);

	//Salto
	int aux8 = CrearTerceto(findAuxTS(pos),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux9 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);
	
	int auxCmp = CrearTerceto(TERC_CMP,aux8,aux9,&lista_terceto); //cmp auxExpresion, 0
	int auxJNE = CrearTerceto(TERC_JNE,NumeroUltimoTerceto(),salto,&lista_terceto); //jne INICIO_WHILE
	
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE1);
	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE2);

	int resultadoTotal = CrearTerceto(findAuxTS(posTotal),TERC_NULL,TERC_NULL,&lista_terceto);

	factorial_ind = resultadoTotal;

    
  if(DEBUG)  {printf("Función FACTORIAL. \n");    }                        
};



nrocombinatorio: PR_COMBINATORIO PAR_ABRE expresion{
	expresion_primer_comb = expresion_ind;


	char tBuffer[STR_VALUE],tBuffer2[STR_VALUE];
	int salto;


	//Auxiliar para la expresion
	strcpy(tBuffer,"@aux"); //valor
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);

	auxN = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar VALOR DE N
	strcpy(tBuffer,"@aux"); //valor
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);

	auxNValor = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar total
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int auxCombTotal = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//valor = expresion
	int aux1 = CrearTerceto(findAuxTS(auxNValor),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxExpresion = CrearTerceto(TERC_ASIG,aux1,expresion_ind,&lista_terceto);

	//valor = expresion
	int tAuxExp = CrearTerceto(findAuxTS(auxNValor),TERC_NULL,TERC_NULL,&lista_terceto);
	aux1 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);	
	auxExpresion = CrearTerceto(TERC_ASIG,aux1,tAuxExp,&lista_terceto);
	
	//if 1 o 0
	//inicializo en 1
	int auxInicializador = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1

	int aux2Init = CrearTerceto(findAuxTS(auxCombTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotalInit = CrearTerceto(TERC_ASIG,aux2Init,auxInicializador,&lista_terceto);	

	int auxConst1 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro1 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp1 = CrearTerceto(TERC_CMP,auxOtro1,auxConst1,&lista_terceto); //cmp auxExpresion, 0	
	int auxJNE1 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE

	int auxConst0 = CrearTerceto("&cte0",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro2 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp2 = CrearTerceto(TERC_CMP,auxOtro2,auxConst0,&lista_terceto); //cmp auxExpresion, 0
	int auxJNE2 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE

	//total = valor
	int auxOtro = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux2 = CrearTerceto(findAuxTS(auxCombTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotal = CrearTerceto(TERC_ASIG,aux2,auxOtro,&lista_terceto);

	//Numero de salto
	//int salto = NumeroUltimoTerceto()+1;
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	//valor = (valor - 1)
	int aux3 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux4 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxResta = CrearTerceto(TERC_RESTA,aux3,aux4,&lista_terceto); 

	int aux5 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	auxExpresion = CrearTerceto(TERC_ASIG,aux5,auxResta,&lista_terceto);	
	
	//Multiplicacion por el anterior
	aux5 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux6 = CrearTerceto(findAuxTS(auxCombTotal),TERC_NULL,TERC_NULL,&lista_terceto);	
	int auxMultiplicacion = CrearTerceto(TERC_MULT,aux6,aux5,&lista_terceto); //auxExpresion

	int aux7 = CrearTerceto(findAuxTS(auxCombTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotal = CrearTerceto(TERC_ASIG,aux7,auxMultiplicacion,&lista_terceto);

	//Salto	
	int aux8 = CrearTerceto(findAuxTS(auxN),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux9 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);
	
	int auxCmp = CrearTerceto(TERC_CMP,aux8,aux9,&lista_terceto); //cmp auxExpresion, 0
	int auxJNE = CrearTerceto(TERC_JNE,NumeroUltimoTerceto(),salto,&lista_terceto); //jne INICIO_WHILE
		
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA
	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE1);//NumeroUltimoTerceto()+1
	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE2);//NumeroUltimoTerceto()+1

	//Variable de numerador
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	primer_resultado = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	int resultadoTotal = CrearTerceto(findAuxTS(auxCombTotal),TERC_NULL,TERC_NULL,&lista_terceto);
	int numerador = CrearTerceto(findAuxTS(primer_resultado),TERC_NULL,TERC_NULL,&lista_terceto);
	int finalize = CrearTerceto(TERC_ASIG,numerador,resultadoTotal,&lista_terceto);


} COMA expresion PAR_CIERRA
{

	char tBuffer[STR_VALUE],tBuffer2[STR_VALUE];
	int salto;
	//Auxiliar para la expresion
	strcpy(tBuffer,"@aux"); //valor
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);

	int auxK = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar total
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int constDeResta = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int factorialDeResta = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar resta
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int auxDeResta = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//Auxiliar 1 o 0
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int auxUnoCero = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	//valorK = EXPRESION
	int aux12 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxExpresion22 = CrearTerceto(TERC_ASIG,aux12,expresion_ind,&lista_terceto);
	

	// asignacionFinal =(n-k)

	int tercetoAuxN = CrearTerceto(findAuxTS(auxNValor),TERC_NULL,TERC_NULL,&lista_terceto);
	int tercetoAuxK = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	int primeraExpresionComb = CrearTerceto(TERC_RESTA,tercetoAuxN,tercetoAuxK,&lista_terceto);
	int idGuardar = CrearTerceto(findAuxTS(auxDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int asignacionFinal = CrearTerceto(TERC_ASIG,idGuardar,primeraExpresionComb,&lista_terceto);


	//asignacionFinal!

	//valor = expresion
	int aux2000 = CrearTerceto(findAuxTS(auxDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux1 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxExpresion = CrearTerceto(TERC_ASIG,aux1,aux2000,&lista_terceto);
	
	//if 1 o 0
	//inicializo en 1
	int auxInicializador = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1

	int aux2Init = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotalInit = CrearTerceto(TERC_ASIG,aux2Init,auxInicializador,&lista_terceto);	

	int auxConst1 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro1 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp1 = CrearTerceto(TERC_CMP,auxOtro1,auxConst1,&lista_terceto); //cmp auxExpresion, 0	
	int auxJNE1 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE

	int auxConst0 = CrearTerceto("&cte0",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxOtro2 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxCmp2 = CrearTerceto(TERC_CMP,auxOtro2,auxConst0,&lista_terceto); //cmp auxExpresion, 0
	int auxJNE2 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE	

	//total = valor
	int auxOtro = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux2 = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int auxTotal = CrearTerceto(TERC_ASIG,aux2,auxOtro,&lista_terceto);

	//Numero de salto
	//salto = NumeroUltimoTerceto()+1;
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	//valor = (valor - 1)
	int aux3 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux4 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	int auxResta = CrearTerceto(TERC_RESTA,aux3,aux4,&lista_terceto); 

	int aux5 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	auxExpresion = CrearTerceto(TERC_ASIG,aux5,auxResta,&lista_terceto);	
	
	//Multiplicacion por el anterior
	aux5 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux6 = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);	
	int auxMultiplicacion = CrearTerceto(TERC_MULT,aux6,aux5,&lista_terceto);//auxExpresion

	int aux7 = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotal = CrearTerceto(TERC_ASIG,aux7,auxMultiplicacion,&lista_terceto);

	//Salto	
	int aux8 = CrearTerceto(findAuxTS(constDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int aux9 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);
	
	int auxCmp = CrearTerceto(TERC_CMP,aux8,aux9,&lista_terceto); //cmp auxExpresion, 0
	int auxJNE = CrearTerceto(TERC_JNE,NumeroUltimoTerceto(),salto,&lista_terceto); //jne INICIO_WHILE
	
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE1);
	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE2);

	int resultadoTotalX = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);

	//(n-k)!
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int nMenosKFactorial = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	int idGuardar2 = CrearTerceto(findAuxTS(nMenosKFactorial),TERC_NULL,TERC_NULL,&lista_terceto);
	int asignacionFinal2 = CrearTerceto(TERC_ASIG,idGuardar2,resultadoTotalX,&lista_terceto);

	//ahora vamos con el k!

	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int factorialK = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	auxInicializador = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1

	aux2Init = CrearTerceto(findAuxTS(factorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotalInit = CrearTerceto(TERC_ASIG,aux2Init,auxInicializador,&lista_terceto);	

	auxConst1 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	auxOtro1 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxCmp1 = CrearTerceto(TERC_CMP,auxOtro1,auxConst1,&lista_terceto); //cmp auxExpresion, 0	
	auxJNE1 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE

	auxConst0 = CrearTerceto("&cte0",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	auxOtro2 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxCmp2 = CrearTerceto(TERC_CMP,auxOtro2,auxConst0,&lista_terceto); //cmp auxExpresion, 0
	auxJNE2 = CrearTerceto(TERC_JE,NumeroUltimoTerceto(),TERC_NULL,&lista_terceto); //jne INICIO_WHILE

	//total = valor
	auxOtro = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	aux2 = CrearTerceto(findAuxTS(factorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotal = CrearTerceto(TERC_ASIG,aux2,auxOtro,&lista_terceto);

	//Numero de salto
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA
	//salto = NumeroUltimoTerceto()+1;

	//valor = (valor - 1)
	aux3 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	aux4 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);//constante que representa el 1
	auxResta = CrearTerceto(TERC_RESTA,aux3,aux4,&lista_terceto); 

	aux5 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxExpresion = CrearTerceto(TERC_ASIG,aux5,auxResta,&lista_terceto);	
	
	//Multiplicacion por el anterior
	aux5 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);	
	aux6 = CrearTerceto(findAuxTS(factorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxMultiplicacion = CrearTerceto(TERC_MULT,aux6,aux5,&lista_terceto);//auxExpresion

	aux7 = CrearTerceto(findAuxTS(factorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	auxTotal = CrearTerceto(TERC_ASIG,aux7,auxMultiplicacion,&lista_terceto);

	//Salto	
	aux8 = CrearTerceto(findAuxTS(auxK),TERC_NULL,TERC_NULL,&lista_terceto);
	aux9 = CrearTerceto("&cte1",TERC_NULL,TERC_NULL,&lista_terceto);
	
	auxCmp = CrearTerceto(TERC_CMP,aux8,aux9,&lista_terceto); //cmp auxExpresion, 0
	auxJNE = CrearTerceto(TERC_JNE,NumeroUltimoTerceto(),salto,&lista_terceto); //jne INICIO_WHILE
	
	salto = CrearTerceto(TERC_ETIQ,TERC_NULL,TERC_NULL,&lista_terceto); //ETIQUETA

	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE1);
	ModificarTerceto(NO_MODIF,NO_MODIF,salto,&lista_terceto,auxJNE2);

	int resultadoTotalFactorialK_ind = CrearTerceto(findAuxTS(factorialK),TERC_NULL,TERC_NULL,&lista_terceto);

	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int resultadoTotalFactorialK = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	int idGuardar3 = CrearTerceto(findAuxTS(resultadoTotalFactorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	int asignacionFinal3 = CrearTerceto(TERC_ASIG,idGuardar3,resultadoTotalFactorialK_ind,&lista_terceto);


	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int denominador = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);


	//Ahora k! x (n-k)!
	int firstStep_ind = CrearTerceto(findAuxTS(resultadoTotalFactorialK),TERC_NULL,TERC_NULL,&lista_terceto);
	int SecondStep_ind = CrearTerceto(findAuxTS(factorialDeResta),TERC_NULL,TERC_NULL,&lista_terceto);
	int multiplica = CrearTerceto(TERC_MULT,firstStep_ind,SecondStep_ind,&lista_terceto);
	int denominador_ind = CrearTerceto(findAuxTS(denominador),TERC_NULL,TERC_NULL,&lista_terceto);
	int asigna_denominador_ind = CrearTerceto(TERC_ASIG,denominador_ind,multiplica,&lista_terceto);

	///la puta division
	strcpy(tBuffer,"@aux"); //total
	sprintf(tBuffer2,"%d",getiConstantes());
	strcat(tBuffer,tBuffer2);
	int division = agregarTokenTS(tBuffer,"-",VRBL_AUX,0,0.0);

	firstStep_ind = CrearTerceto(findAuxTS(primer_resultado),TERC_NULL,TERC_NULL,&lista_terceto);
	SecondStep_ind = CrearTerceto(findAuxTS(denominador),TERC_NULL,TERC_NULL,&lista_terceto);
	int divide_ind = CrearTerceto(TERC_DIV,firstStep_ind,SecondStep_ind,&lista_terceto);

	nrocomb_ind = divide_ind;

  if(DEBUG)  {printf("Función NÚMERO COMBINATORIO. \n");        }                    
};

%%

////////////////////////////////////////
//Estructuras de analizador lexico	  //
////////////////////////////////////////
int main(int argc,char *argv[])
{
	
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
  		printf(". \nNo se puede abrir el archivo: %s. \n", argv[1]);	 	
		exit(1);
  }
  else
  {
		yyparse();
  }

  fclose(yyin);
  return 0;
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
	//incrementarIConstantes();

	strcpy(aux,"&cte1");	 
	float t = 1;
	agregarTokenTS(aux,"-",CTE_INT,0,t);
	//incrementarIConstantes();

	strcpy(aux,"@aux2");	
	agregarTokenTS(aux,"-",VRBL_AUX,0,0);
	
	strcpy(aux,"@aux3");
	agregarTokenTS(aux,"-",VRBL_AUX,0,0);
	
	strcpy(aux,"@aux4STR");
	agregarTokenTS(aux,"-",VRBL_AUX,0,0);

	strcpy(aux,"cte5");
	agregarTokenTS(aux,"Presione una tecla para finalizar...",CTE_STR,0,0);
	//incrementarIConstantes();

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