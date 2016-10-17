#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define TERC_ASIG -1
#define TERC_SUMA -2
#define TERC_RESTA -3
#define TERC_MULT -4
#define TERC_DIV -5
#define TERC_MENOR -6
#define TERC_MENOR_IGUAL -7
#define TERC_IGUAL -8
#define TERC_MAYOR -9
#define TERC_MAYOR_IGUAL -10
#define TERC_DISTINTO -11
#define TERC_CONCAT -12
#define TERC_WRITE -13
#define TERC_PRINTLN -14
#define TERC_FIN -15

#define TERC_BRA -16
#define TERC_JE -17
#define TERC_JNE -18
#define TERC_JB -19
#define TERC_JBE -20
#define TERC_JA -21
#define TERC_JAE -22
#define TERC_ETIQ -23

#define TERC_IGUAL_STRING -24
#define TERC_DISTINTO_STRING -25

#define TERC_MU -26

#define TERC_AND -27
#define TERC_OR -28
#define TERC_CMP -29



#define TERC_AVG -30
#define TERC_FACT -31
#define TERC_NROCOMB -32

#define TERC_READ -207


#define TERC_NULL -1
#define NO_MODIF -1

typedef struct
{
	int operacion;
	int	opIzq;
	int	opDer;
} terceto_t;

typedef struct s_node
{
	terceto_t info;
	struct s_node *sig,*ant;
}t_node;

typedef t_node* lista_tercetos_t;



void CrearLT(lista_tercetos_t*);
int InsertarEnLT(lista_tercetos_t*,terceto_t*);
int CrearTerceto(int,int,int,lista_tercetos_t*);
void VaciarLT(lista_tercetos_t*);
void ObtenerItemLT(lista_tercetos_t*,int,terceto_t*);
int BuscarPosLT(lista_tercetos_t*, terceto_t*);
//void ModificarTerceto(int,int,int,lista_tercetos_t*,int);
//void NegarOperadorTerceto(int,lista_tercetos_t*);
//nt NegarOperador(int);
void DumpLista(lista_tercetos_t*);
int NumeroUltimoTerceto();
void EliminarUltimoTerceto(lista_tercetos_t*);

int x;
int tamLista = 0;

int CrearTerceto(int p1, int p2, int p3, lista_tercetos_t *p)
{
    terceto_t terc;
    terc.operacion = p1; 
    terc.opIzq = p2; 
    terc.opDer = p3;
        return InsertarEnLT(p, &terc)-1;
}

int InsertarEnLT(lista_tercetos_t *p, terceto_t *d)
{
	//Esto inserta al terceto en la lista y devuelve su posici�n.
	//La posici�n puede ser tomada como el n�mero del mismo.
	t_node *nue;
	nue = (t_node*)malloc(sizeof(t_node));
	if(!nue)
		return 0;
	nue->info = *d;
	printf("-----------Insertar En Lista de Tercetos %d %d %d \n",nue->info.operacion,nue->info.opIzq,nue->info.opDer);
	nue->sig = NULL;
	nue->ant = *p;
	if(*p)
		(*p)->sig = nue;
	*p = nue;

	tamLista++;
	return tamLista;
}

void EliminarUltimoTerceto(lista_tercetos_t *p)
{
    if(*p != NULL)
    {
        t_node *aux = *p;
        *p = aux->ant;
        if(*p != NULL)
        {
            (*p)->sig = NULL;
        }
        free(aux);
        tamLista--;
    }
}

void VaciarLT(lista_tercetos_t *p)
{
	t_node *pri = *p,*act = *p,*aux;
	if(*p)
		pri = (*p)->ant;
	while(act)
	{
		if(act->sig)
			act->sig->ant = act->ant;
		if(act->ant)
		{
			act->ant->sig = act->sig;
			*p = act->ant;
		}
		else
			*p = act->sig;
		printf("NARIPETA %d %d %d ",act->info.operacion,act->info.opIzq,act->info.opDer);
		aux = act;
		act = act->sig;

		free(aux);
	}
	act = pri;
	while(act)
	{
		if(act->sig)
			act->sig->ant = act->ant;
		if(act->ant)
		{
			act->ant->sig = act->sig;
			*p = act->ant;
		}
		else
			*p = act->sig;
		aux = act;
		act = act->ant;
		free(aux);
	}

    tamLista = 0;
}


void ObtenerItemLT(lista_tercetos_t* p, int pos, terceto_t* nodo)
{
	t_node *act = *p;
	int cont = 0;

	if(pos < 0)
		nodo = NULL;

	if(act)
	{
		while(act->ant)
			act = act->ant;
		while(act)
		{
			if(cont == pos)
			{
				*nodo = act->info;
				return;
			}
			else
			{
				cont++;
				act = act->sig;
			}
		}
	}

	nodo = NULL;
}

/*
void ModificarTerceto(int op, int li, int ld, lista_tercetos_t *p, int pos)
{
	t_node *act = *p;
	int cont = 0;

	if(act)
	{
		while(act->ant)
			act = act->ant;
		while(act)
		{
			if(cont == pos)
			{
			    if(op != NO_MODIF)
                    act->info.operacion = op;
			    if(li != NO_MODIF)
                    act->info.opIzq = li;
                if(ld != NO_MODIF)
                    act->info.opDer = ld;
                return;
			}
			else
			{
				cont++;
				act = act->sig;
			}
		}
	}
}

/*void NegarOperadorTerceto(int pos, lista_tercetos_t* lt)
{
    terceto_t tercetoAux;

    ObtenerItemLT(lt, pos, &tercetoAux);
    ModificarTerceto(NegarOperador(tercetoAux.operacion), NO_MODIF, NO_MODIF, lt, pos);
}

/*
int NegarOperador(int op)
{
    int op_negado;

    switch(op)
    {
        case TERC_MENOR:
            op_negado = TERC_JAE;
            break;
        case TERC_MENOR_IGUAL:
            op_negado = TERC_JA;
            break;
        case TERC_IGUAL:
            op_negado = TERC_JNE;
            break;
        case TERC_DISTINTO:
            op_negado = TERC_JE;
            break;
        case TERC_MAYOR_IGUAL:
            op_negado = TERC_JB;
            break;
        case TERC_MAYOR:
            op_negado = TERC_JBE;
            break;

        case TERC_JB:
            op_negado = TERC_JAE;
            break;
        case TERC_JBE:
            op_negado = TERC_JA;
            break;
        case TERC_JE:
            op_negado = TERC_JNE;
            break;
        case TERC_JNE:
            op_negado = TERC_JE;
            break;
        case TERC_JAE:
            op_negado = TERC_JB;
            break;
        case TERC_JA:
            op_negado = TERC_JBE;
            break;
    }

    return op_negado;
}


*/

void DumpLista(lista_tercetos_t* p)
{	
	printf("LLEGO HASTA LA HORA DE VOLVAR LA TIRA DE TERCETOS AL TXT");
	char* terminales[] = {":=", "+", "-", "*", "/", "<", "<=", "==", ">", ">=", "!=", "++", "PRINT", "PRINTLN", "FIN", "BRA", "JE", "JNE", "JB", "JBE", "JA", "JAE", "ETIQ", "==STR", "!=STR", "MU","AND","OR","CMP","AVG","FACT","COMB"};
	int i = 0;
	t_node *act = *p;
	terceto_t terc;
	FILE* pf = fopen("Outputs/intermedia.txt", "wt+");
	
	printf("LLEGO HASTA LA HORA DE VOLVAR LA TIRA DE TERCETOS AL TXT");
	if(!pf)
	{
		perror("Error creando el archivo de notacion intermedia");
		return;
	}
	printf("LLEGO HASTA LA HORA DE VOLVAR LA TIRA DE TERCETOS AL TXT");
	if(act)
	{
		while(act->ant)
			act = act->ant;
		while(act)
		{
			terc = act->info;
			if(terc.operacion < 0)
			{

                if(terc.opDer == TERC_NULL){ //Es un terminal, un operador l�gico unario
					printf("\n****Antes de pintar******");
					printf("\n operacion %d : ",abs(terc.operacion));
					printf("\n opizq %d : ",terc.opIzq);
					
                    fprintf(pf, "[%d] (%s,[%d],[_])\n", i, terminales[abs(terc.operacion) - 1], terc.opIzq);
					printf("\n****Desp de pintar******");
				} else{ //Es un terminal, un operador l�gico binario
					printf("\n****Antes de pintar******");
					printf("\n operacion %d : ",abs(terc.operacion));
					printf("\n opizq %d : ",terc.opIzq);
					printf("\n opder %d : ",terc.opDer);
					
                    fprintf(pf, "[%d] (%s,[%d],[%d])\n", i, terminales[abs(terc.operacion) - 1], terc.opIzq, terc.opDer);
					printf("\n****Desp de pintar******");
				}
			}
			else
			{
                //El operador es la posici�n en la tabla de s�mbolos de alg�n ID o constante
                TS reg;
				ObtenerItemTS(terc.operacion, &reg);
				printf("\n ddsadas : %d", terc.operacion);
                if(terc.opIzq == TERC_NULL)//Es un un ID o constante
                    fprintf(pf, "[%d] (%s,[_],[_])\n", i, reg.nombre);
				                    
			}
			act = act->sig;
			i++;
		}
		printf("\n sali");
	}
	fclose(pf);
}


int BuscarPosLT(lista_tercetos_t* p, terceto_t* nodo)
{
	int i = 0;
	t_node *act = *p;

	if(act)
	{
		while(act->ant)
			act = act->ant;
		while(act)
		{
			if(act->info.operacion == nodo->operacion && act->info.opIzq == nodo->opIzq && act->info.opDer == nodo->opDer)
				return i;

			act = act->sig;
			i++;
		}
	}

	return -1;
}



int NumeroUltimoTerceto() {return tamLista - 1;}
