#ifndef CODIGO_INTERMEDIO
#define CODIGO_INTERMEDIO
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TAM_TT 2000
#define MAX 200
#define SIN_TIPO 0

typedef struct{
    int pila[MAX];
    int tope;
}t_pila;

int num_actual = 0, numaux;

typedef struct tercetos {
	int posicion;
	char operador[257];
	char arg1[257];
	char arg2[257];
	int tipo;
}tercetos;

int expr_ind, factor_ind, term_ind, asg_ind, comp_ind;

int mat_sin_sum[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, 3}};


int mat_sin_res[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_mul[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_div[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_asg[3][3] = {{1, 1, -1},
{2, 2, -1},
{-1, -1, 3}};

int mat_sin_je[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_jne[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_jge[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_jle[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_jg[3][3] = {{1, 2, -1},
{2, 2, -1},
{-1, -1, -1}};

int mat_sin_jl[3][3] = {{1, 1, -1},
{2, 2, -1},
{-1, -1, -1}};

tercetos lista_tercetos[TAM_TT];

t_pila P;
t_pila P_FACT;

int crear_terceto(char *op, char *arg1, char *arg2, char * ambito){ //POS en TS
	char tipo_1[257], tipo_2[257], aux_op[257], aux_arg1[257],aux_arg2[257];
	char * variableReal;
	int pos_1, pos_2, pos, tipo_res = 0, pos_cmp;
	int tipo_entero_1, tipo_entero_2;
	if(num_actual == TAM_TT)
		return -1;

	strcpy(aux_op, op);
	strcpy(aux_arg1, arg1);
	strcpy(aux_arg2, arg2);
  
	if(strcmp(op, "+") == 0 || strcmp(op, "-") == 0 || strcmp(op, "*") == 0 || strcmp(op, "/") == 0){
		sscanf(arg1, "%d", &pos_1);
		sscanf(arg2, "%d", &pos_2);
		if((tipo_entero_1 = lista_tercetos[pos_1-1].tipo) == 1){
			strcpy(tipo_1, "INTEGER");
		}else if((tipo_entero_1 =lista_tercetos[pos_1-1].tipo) == 2){
			strcpy(tipo_1, "REAL");
		}else if((tipo_entero_1 = lista_tercetos[pos_1-1].tipo) == 3){
			strcpy(tipo_1, "STRING");
		}

		if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 1){
			strcpy(tipo_2, "INTEGER");
		}else if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 2){
			strcpy(tipo_2, "REAL");
		}else if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 3){
			strcpy(tipo_2, "STRING");
		}
		
		//tipo_res = 2;
		tipo_res = compatibilidad(tipo_entero_1, tipo_entero_2, op);
		//printf("OPERACION: %s, TIPO_1: %s, TIPO_2: %s\n", op, tipo_1, tipo_2);		
	}else if((strcmp(arg1, "_1") == 0 || strcmp(arg1, "_2") == 0) && strcmp(arg2, "_") == 0 && strcmp(op, "EOP") != 0 && strcmp(op, "EOF") != 0 && strcmp(op, "JMP") != 0){
		variableReal = strtok(op, "_");
		variableReal = strtok(NULL, "_");
		
		if(variableReal != NULL){
			pos = buscarEnTS(variableReal, ambito); //TENER EN CUENTA AMBITO. ES VARIABLE
			//printf("VR: %s (%s)\n", variableReal, ambito);
		}else{
			//printf("OP: %s\n", op);
			pos = buscarEnTS(op, ambito); //ES CTE
			//aux_op[0]='_';
			//printf("VR: %s (%s)-\n", op, ambito);		
		}
		strcpy(tipo_1, ts[pos].tipo);
		//printf("%s - %s\n", op, ambito);
		if(strcmp(tipo_1, "INTEGER") == 0 || strcmp(tipo_1, "CTE_INTEGER") == 0 || strcmp(tipo_1, "FUNCTION:INTEGER") == 0){
			tipo_res = 1;		
		}else if(strcmp(tipo_1, "REAL") == 0 || strcmp(tipo_1, "CTE_REAL") == 0 || strcmp(tipo_1, "FUNCTION:REAL") == 0){
			tipo_res = 2;		
		}else if(strcmp(tipo_1, "STRING") == 0 || strcmp(tipo_1, "CTE_STRING") == 0 || strcmp(tipo_1, "FUNCTION:STRING") == 0){
			tipo_res = 3;		
		}
		//printf("%d (%s, %s, %s) %d\n", num_actual+1, aux_op, "_", "_", tipo_res);
	}else if(strcmp(op, "JE") == 0 || strcmp(op, "JNE") == 0 || strcmp(op, "JG") == 0 || strcmp(op, "JL") == 0 || strcmp(op, "JLE") == 0 || strcmp(op, "JGE") == 0){
		pos_cmp = num_actual-1;
		//printf("%d (%s, %s, %s) %d\n", lista_tercetos[pos_cmp].posicion, lista_tercetos[pos_cmp].operador, lista_tercetos[pos_cmp].arg1, lista_tercetos[pos_cmp].arg2, lista_tercetos[pos_cmp].tipo);
		sscanf(lista_tercetos[pos_cmp].arg1, "%d", &pos_1);
		sscanf(lista_tercetos[pos_cmp].arg2, "%d", &pos_2);
		tipo_entero_1 = lista_tercetos[pos_1-1].tipo;
		tipo_entero_2 = lista_tercetos[pos_2-1].tipo;
		//printf("TIPO1: %d - TIPO2: %d\n", lista_tercetos[pos_1].tipo, lista_tercetos[pos_2].tipo);
		tipo_res = compatibilidad(tipo_entero_1, tipo_entero_2, op);
		lista_tercetos[pos_cmp].tipo = tipo_res;
		//printf("POS1: %d - TIPO1: %d - POS2: %d - TIPO2: %d\n. TIPO RES: \n", pos_1, pos_2, tipo_entero_1, tipo_entero_2, tipo_res);
	}else if(strcmp(op, ":=") == 0){
		variableReal = strtok(arg1, "_");
		variableReal = strtok(NULL, "_");
		//printf("VR: %s (%s)(\n", arg1, ambito); 
		pos = buscarEnTS(variableReal, ambito); //TENER EN CUENTA AMBITO
		strcpy(tipo_1, ts[pos].tipo);
		//printf("%s - %s\n", arg1, ambito);
		if(strcmp(tipo_1, "INTEGER") == 0 || strcmp(tipo_1, "CTE_INTEGER") == 0 || strcmp(tipo_1, "FUNCTION:INTEGER") == 0){	
			tipo_entero_1 = 1;	
		}else if(strcmp(tipo_1, "REAL") == 0 || strcmp(tipo_1, "CTE_REAL") == 0 || strcmp(tipo_1, "FUNCTION:REAL") == 0){
			tipo_entero_1 = 2;	
		}else if(strcmp(tipo_1, "STRING") == 0 || strcmp(tipo_1, "CTE_STRING") == 0 || strcmp(tipo_1, "FUNCTION:STRING") == 0){
			tipo_entero_1 = 3;		
		}
		
		sscanf(arg2, "%d", &pos_2);
		if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 1){
			strcpy(tipo_2, "INTEGER");
		}else if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 2){
			strcpy(tipo_2, "REAL");
		}else if((tipo_entero_2 = lista_tercetos[pos_2-1].tipo) == 3){
			strcpy(tipo_2, "STRING");
		}
		
		tipo_res = compatibilidad(tipo_entero_1, tipo_entero_2, op);
		//printf("ASIGNACION. %s := %s\n", tipo_1, tipo_2);
	}else{
		tipo_res = SIN_TIPO;
	}
		
	if(tipo_res != -1){
		lista_tercetos[num_actual].posicion=num_actual+1;
		strcpy(lista_tercetos[num_actual].operador,aux_op);
		strcpy(lista_tercetos[num_actual].arg1,aux_arg1);
		strcpy(lista_tercetos[num_actual].arg2,aux_arg2);
		lista_tercetos[num_actual].tipo = tipo_res;
		num_actual++;
	}else{
		printf("ERROR DE TIPOS. ABORTANDO...\n");
		exit(1);	
	}
	return num_actual;
};

int compatibilidad(int a, int b, char * op){
	if(strcmp(op, "+") == 0){
		return mat_sin_sum[a-1][b-1];
	}else if(strcmp(op, "-") == 0){
		return mat_sin_res[a-1][b-1];
	}else if(strcmp(op, "/") == 0){
		return mat_sin_div[a-1][b-1];
	}else if(strcmp(op, "*") == 0){
		return mat_sin_mul[a-1][b-1];
	}else if(strcmp(op, ":=") == 0){
		if(a == 1 && b == 2){
			printf("WARNING: perdida precision\n");		
		}
		return mat_sin_asg[a-1][b-1];
	}else if(strcmp(op, "JE") == 0){
		return mat_sin_je[a-1][b-1];
	}else if(strcmp(op, "JNE") == 0){
		//printf("HOLA: %d\n", mat_sin_jne[a-1][b-1]); 
		return mat_sin_jne[a-1][b-1];
	}else if(strcmp(op, "JGE") == 0){
		return mat_sin_jge[a-1][b-1];
	}else if(strcmp(op, "JLE") == 0){
		return mat_sin_jle[a-1][b-1];
	}else if(strcmp(op, "JG") == 0){
		return mat_sin_jg[a-1][b-1];
	}else if(strcmp(op, "JL") == 0){
		return mat_sin_jl[a-1][b-1];
	}
}


void modificar_terceto(int t,int narg,char *arg){
	switch(narg){
		case 0:strcpy(lista_tercetos[t-1].operador,arg); break;
		case 1:strcpy(lista_tercetos[t-1].arg1,arg); break;
		case 2:strcpy(lista_tercetos[t-1].arg2,arg); break;
	};
}; 

void grabar_tercetos(char * nombre){
	FILE * intermedio;
	char aux[257] = "intermedio/";
	strcat(aux, nombre);
	strcat(aux, "_intermedio.txt"); 
	//printf("%s\n", aux);
  	if( !(intermedio=fopen(aux,"w"))){
		printf("Error de creacion del archivo %s_intermedio.txt ...", aux);
		exit(0);
	}    
	int pos=0;
	int num = 0;
	char * paux;
	while(pos!=num_actual){
		fprintf(intermedio,"%d (%s",lista_tercetos[pos].posicion,lista_tercetos[pos].operador);
		paux = lista_tercetos[pos].arg1;
		while(* paux != '\0'){
			if(isdigit(*paux))
				num = 1;
			else{
				num = 0;
				break;			
			}	
			paux++;	
		}
		
		if(buscarEnTS(lista_tercetos[pos].arg1, NULL)==-1 && strcmp(lista_tercetos[pos].arg1,"_")!=0 && num == 1 )
			fprintf(intermedio,",[%s],",lista_tercetos[pos].arg1);
		else
			fprintf(intermedio,",%s,",lista_tercetos[pos].arg1);
		   
		num = 0;
		paux = lista_tercetos[pos].arg2;
		while(* paux != '\0'){
			if(isdigit(*paux))
				num = 1;
			else{
				num = 0;
				break;			
			}		
			paux++;
		}
		if(buscarEnTS(lista_tercetos[pos].arg2, NULL)==-1 && strcmp(lista_tercetos[pos].arg2,"_")!=0 && num == 1)
			fprintf(intermedio,"[%s])",lista_tercetos[pos].arg2);
		else
			fprintf(intermedio,"%s)",lista_tercetos[pos].arg2);
		
		if(lista_tercetos[pos].tipo == 1){
			fprintf(intermedio," INTEGER\n");
		}else if(lista_tercetos[pos].tipo == 2){
			fprintf(intermedio," REAL\n");
		}else if(lista_tercetos[pos].tipo == 3){
			fprintf(intermedio," STRING\n");
		}else{
			fprintf(intermedio,"\n");
		}
		
		pos++;
	    
	}
	num_actual = 0;
	fclose(intermedio); 
};  


void crearPila(t_pila * ppila){
    ppila->tope = 0;
};

int apilar(t_pila * ppila, int *d){
    if(ppila->tope == MAX)
        return 0;
    ppila->pila[ppila->tope]=*d;
    ppila->tope++;
    return 1;
};

int desapilar(t_pila * ppila, int *d){
    if(ppila->tope == 0)
        return 0;
    ppila->tope--;
    *d=ppila->pila[ppila->tope];
    return 1;
};

int vertope(t_pila * ppila, int *d){
    if(ppila->tope == 0)
        return 0;
    *d=ppila->pila[ppila->tope-1];
    return 1;
};

void vaciarPila(t_pila * ppila){
    ppila->tope = 0;
};

int pilaVacia(t_pila * ppila){
    return ppila->tope == 0;
};

int pilaLlena(t_pila * ppila){
    return ppila->tope == MAX;
};

#endif
