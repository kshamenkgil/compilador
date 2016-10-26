%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaSimbolos.h"
#include "y.tab.h"
#include "constantes.h"

FILE  *yyin;
char aux[COTA_STR],aux2[COTA_STR];
double f;

char bufferItoa[STR_VALUE];

%}

%option noyywrap 
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]
OTRO			.

COM_SIMPLE		"-/"{OTRO}*"/-"
COM_ANIDADO		"-/"{OTRO}*{COM_SIMPLE}+{OTRO}*"/-"

CONST_STR 		"\""({ESPACIO}|{LETRA}|{DIGITO})*"\""

CONST_FLOAT     {DIGITO}+"."{DIGITO}*|"."{DIGITO}+
CONST_INT       {DIGITO}+
ID				{LETRA}({LETRA}|{DIGITO}|_)*


ESPACIO				[" "]
PUNTOYCOMA			[";"]
OP_MUL				["*"]
OP_DIV				["/"]
OP_SUMA				["+"]
OP_RESTA			["-"]
OP_CONCAT			["++"]
OP_MAYOR			[">"]
OP_MENOR			["<"]
OP_MAYOR_IGUAL			[">="]
OP_MENOR_IGUAL			["<="]
ASIGNA				[":="]
IGUAL				["=="]
DISTINTO			["!="]

NEGADO				["NOT"]
OP_AND				["AND"]
OP_OR				["OR"]

P_ABRE				["("]
P_CIERRA			[")"]
COR_ABRE			["["]
COR_CIERRA			["]"]
COMA				[","]
DOSPUNTOS			[":"]

GET				["READ"]
PUT				["WRITE"]



%%
"BEGIN"			{ return PR_BEGIN;}
"END"			{ return PR_END;}

"READ"			{return PR_READ;}
"WRITE"			{return PR_WRITE;}

"AVERAGE"		{return PR_AVERAGE;}
"COMBINATORIO"		{return PR_COMBINATORIO;}
"FACTORIAL"		{return PR_FACTORIAL;}



"DECVAR"		{ return PR_VAR;}
"ENDDEC"		{ return PR_ENDVAR;}


"FLOAT"			{ return PR_FLOAT;}
"INT"			{ return PR_INT;}
"STRING"		{ return PR_STRING;}


"IF"			{ return PR_IF;}
"THEN"   		{ return PR_THEN;}
"ELSE"   		{ return PR_ELSE;}
"ENDIF"	      		{ return PR_ENDIF;}

"REPEAT"		{ return PR_REPEAT;}
"UNTIL"	        	{ return PR_UNTIL;}

":="			{ return OP_ASIGNACION;}
"+"			{ return OP_SUMA;}
"-"			{ return OP_RESTA;}
"*"			{ return OP_MULTIPLICACION;}
"/"			{ return OP_DIVISION;}
"++"			{ return CONCAT;}

"("			{ return PAR_ABRE;}
")"			{ return PAR_CIERRA;}
"["			{ return COR_ABRE;}
"]"			{ return COR_CIERRA;}


">"             	{ return OP_MAYOR;}
">="            	{ return OP_MAYOR_IGUAL;}
"<"             	{ return OP_MENOR;}
"<="            	{ return OP_MENOR_IGUAL;}
"!="            	{ return OP_DISTINTO;}
"=="            	{ return OP_IGUAL_IGUAL;}

"AND"           	{ return OP_LOG_AND;}
"OR"            	{ return OP_LOG_OR;}
"NOT"           	{ return OP_LOG_NOT;}


","			{ return COMA;}
":"			{ return DOSPUNTOS;}

{ID}			{


						yylval.str_val = strdup(yytext);
						if(strlen(yytext)>COTA_ID)
							{
								printf("¡ERROR con %s! Supera el maximo de caracteres permitidos %d\n",yytext,COTA_ID);
								printf("---ERROR proporcionado por el Analizador léxico---\n");
								exit(1);
							}
						else	
							{	strcpy(aux,"_");
								strcat(aux,yytext);
								if(DEBUG) {
									printf( "Nuevo elemento en la Tabla de símbolos: %s a partir del ",aux);
									printf( "identificador %s (%s)\n", yytext,yylval.str_val);
								}
								agregarTokenTS(aux,"-",VRBL,0,0);
								return TOKEN_ID;
							}
				}
				

{CONST_INT}		{ 		
						yylval.str_val = strdup(yytext);
						if(atoi(yytext)>COTA_CTE)
							{
								printf("¡ERROR con la constante numérica entera %s! Supera el rango de: %d",yytext,COTA_CTE);
								printf("\n---ERROR porporcionado por el Analizador léxico---\n");
								exit(1);
							}
						else
							{
								strcpy(aux,"&cte");
								//strcat(aux,yytext);
								sprintf(bufferItoa,"%d",getiConstantes());
								strcat(aux,bufferItoa);
								if(DEBUG){ 
									printf( "Nuevo elemento en la Tabla de símbolos: %s a partir de la ",aux);
									printf( "constante %s (%s)\n", yytext,yylval.str_val);
								}
								float valor = atof(yytext);								
								
								//Comentar esta linea si se quieren ver directamente los numeros
								//junto con la de factor -> CONST_INT del sintáctico. 
								//yylval.intval=getiConstantes();
								yylval.intval =agregarTokenTS(aux,"-",CTE_INT,0,valor);

								//incrementarIConstantes();
								return CONST_INT;
							}
				}
				
{CONST_STR}		{ 		yylval.str_val = strdup(yytext);
						//strcpy(aux2,yytext);
						//if(strlen(aux2)>COTA_STR)
						if(strlen(yytext)>COTA_STR)
							{	
								printf("¡ERROR con %s! Supera el maximo de caracteres permitidos %d\n",yytext,COTA_STR);
								printf("---ERROR proporcionado por el Analizador léxico---\n");
								exit(1);
						
							}
						else
							{
								strcpy(aux2,yytext); //ksh
								armarValorYNombreToken(aux2,yytext);
								strcpy(aux,"#cte");
								sprintf(bufferItoa,"%d",getiConstantes());
								strcat(aux,bufferItoa);
								//strcat(aux,aux2);
								if(DEBUG) {
									printf( "Nuevo elemento en la Tabla de símbolos: %s a partir del ",aux);
									printf( "string  %s (%s)\n", yytext,yylval.str_val);
								}						
																

								agregarTokenTS(aux,aux2,CTE_STR,strlen(aux2),0);
								//incrementarIConstantes();
								return CONST_STR;
							}
				}
				
{CONST_FLOAT}	{ 		
						yylval.str_val = strdup(yytext);						
						f=atof(yytext);
						
						if(f>COTA_REAL)
							{
								printf("¡ERROR con la constante numérica real %s! Supera el rango de: %f",yytext,COTA_REAL);
								printf("\n---ERROR porporcionado por el Analizador léxico---\n");
								exit(1);
							}
						else
							{
								strcpy(aux,"$cte");
								sprintf(bufferItoa,"%d",getiConstantes());
								strcat(aux,bufferItoa);
								//strcat(aux,yytext);
								if(DEBUG) {
									printf( "Nuevo elemento en la Tabla de símbolos: %s a partir de la",aux);
									printf( "constante %s (%s)\n", yytext,yylval.str_val);
								}

								yylval.intval = agregarTokenTS(aux,"-",CTE_FLT,0,f);
								
								//yylval.intval = getiConstantes();
								
								return CONST_FLOAT;																
							}
				}

{COM_ANIDADO}	{ if(DEBUG) {printf("Comentario anidado encontrado\n");} }	
			
{COM_SIMPLE}	{ if(DEBUG) {printf("Comentario simple encontrado\n");} }




"\n"      		
"\t"

%%
