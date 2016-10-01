%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
#include "constantes.h"

FILE  *yyin;
char aux[COTA_STR],aux2[COTA_STR];
double f;
%}

%option noyywrap  
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]
OTRO			.

C_SIMPLE		"-/"{OTRO}*"/-"
COMENTARIO		"-/"{OTRO}*{C_SIMPLE}+{OTRO}*"/-"

CONST_STR 		"\""({LETRA}|{DIGITO}|{OTRO})*"\""
CONST_FLOAT     {DIGITO}+"."{DIGITO}*|"."{DIGITO}+
CONST_INT       {DIGITO}+
ID				{LETRA}({LETRA}|{DIGITO}|_)*

OP_MUL				["*"]
OP_DIV				["/"]
OP_SUMA				["+"]
OP_RESTA			["-"]
OPCONCAT			["++"]
OP_MAYOR			[">"]
OP_MENOR			["<"]
OP_MAYOR_IGUAL		[">="]
OP_MENOR_IGUAL		["<="]
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
"BEGIN"		{ return PR_BEGIN;}
"END"		{ return PR_END;}

"READ"		{return PR_READ;}
"WRITE"		{return PR_WRITE;}

"AVERAGE"		{return PR_AVERAGE;}
"COMBINATORIO"	{return PR_COMBINATORIO;}
"FACTORIAL"		{return PR_FACTORIAL;}



"DECVAR"		{ return PR_VAR;}
"ENDDEC"		{ return PR_ENDVAR;}


"FLOAT"			{ return PR_FLOAT;}
"INT"			{ return PR_INT;}
"STRING"		{ return PR_STRING;}


"IF"			{ return PR_IF;}
"THEN"   		{ return PR_THEN;}
"ELSE"   		{ return PR_ELSE;}
"ENDIF"	      	{ return PR_ENDIF;}

"REPEAT"		{ return PR_REPEAT;}
"UNTIL"	        { return PR_UNTIL;}

":="			{ return OP_ASIGNACION;}
"+"				{ return OP_SUMA;}
"-"				{ return OP_RESTA;}
"*"				{ return OP_MULTIPLICACION;}
"/"				{ return OP_DIVISION;}
"++"			{ return CONCAT;}

"("				{ return PAR_ABRE;}
")"				{ return PAR_CIERRA;}
"["				{ return COR_ABRE;}
"]"				{ return COR_CIERRA;}


">"             { return OP_MAYOR;}
">="            { return OP_MAYOR_IGUAL;}
"<"             { return OP_MENOR;}
"<="            { return OP_MENOR_IGUAL;}
"!="            { return OP_DISTINTO;}
"=="            { return OP_IGUAL_IGUAL;}

"AND"           { return OP_LOG_AND;}
"OR"            { return OP_LOG_OR;}
"NOT"           { return OP_LOG_NOT;}


","				{ return COMA;}
":"				{ return DOSPUNTOS;}

{ID}			{


						yylval.str_val = yytext;
						if(strlen(yytext)>COTA_ID)
							{
								printf("Variable %s supera el maximo de caracteres en linea %d\n")
								printf("VARIABLE SUPERA MAXIMO CARACTERES\n\t***ERROR - FINALIZANDO LEXICO***\n");
								exit(1);
							}
						else	
							{	strcpy(aux,"_");
								strcat(aux,yytext);
								printf( "Ingreso en la Tabla de símbolos: %s\n",aux);
								printf( "Identificador en lexico: %s (%s)\n", yytext,yylval.str_val);
								agregarATS(aux,"-",VRBL,0,0);//hay que mandar el id y los datos necesarios para agregar
								return TOKEN_ID;
							}
				}
				

{CONST_INT}		{ 		
						yylval.str_val = yytext;
						if(atoi(yytext)>COTA_ID)
							{
								printf("CONST ENTERA SUPERA COTA\n\t***ERROR - FINALIZANDO LEXICO***\n");
								exit(1);
							}
						else
							{
								strcpy(aux,"&");
								strcat(aux,yytext);
								printf( "Genero aux para TS: (%s)\n",aux);
								printf( "Identificador en lexico: %s (%s)\n", yytext,yylval.str_val);
								agregarATS(aux,"-",CTE_INT,0,atoi(yytext));
								return CONST_INT;
							}
				}
				
{CONST_STR}		{ 		yylval.str_val = yytext;
						strcpy(aux2,yytext);
						if(strlen(aux2)>COTA_STR)
							{	
								printf("STRING SUPERA COTA\n\t***ERROR - FINALIZANDO LEXICO***\n");
								exit(1);
						
							}
						else
							{
								setearString(aux2,yytext);
								strcpy(aux,"@");
								strcat(aux,aux2);
								printf( "Genero aux para TS: (%s)\n",aux);
								printf( "Identificador en lexico: %s (%s)\n", yytext,yylval.str_val);
								agregarATS(aux,yytext,CTE_STR,strlen(aux2),0);
								return CONST_STR;
							}
				}
				
{CONST_FLOAT}	{ 		
						yylval.str_val = yytext;
						f=atof(yytext);
						if(f>COTA_REAL)
							{
								printf("CONST REAL SUPERA COTA\n\t***ERROR - FINALIZANDO LEXICO***\n");
								exit(1);
							}
						else
							{
								strcpy(aux,"$");
								strcat(aux,yytext);
								printf( "Genero aux para TS: (%s)\n",aux);
								printf( "Identificador en lexico: %s (%s)\n", yytext,yylval.str_val);
								agregarATS(aux,"-",CTE_FLT,0,f);
								return CONST_FLOAT;
							}
				}
				
{COMENTARIO}	{ printf("COMENTARIO \n");}





"\n"      		
"\t"

%%
