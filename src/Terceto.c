#include "Terceto.h"

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
	if(DEBUG){ printf("-----------Insertar En Lista de Tercetos %d %d %d \n",nue->info.operacion,nue->info.opIzq,nue->info.opDer); }
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
		//printf("NARIPETA %d %d %d ",act->info.operacion,act->info.opIzq,act->info.opDer);
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
			    if(op != NO_MODIF && op != NEGAR){
                    act->info.operacion = op;
				}
				if(op == NEGAR){
					act->info.operacion = NegarOperador(act->info.operacion);
				}
				if(li != NO_MODIF){
                    act->info.opIzq = li;
				}
                if(ld != NO_MODIF){					
                    act->info.opDer = ld;
				}
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

void NegarOperadorTerceto(int pos, lista_tercetos_t* lt)
{
    terceto_t tercetoAux;

    ObtenerItemLT(lt, pos, &tercetoAux);
    ModificarTerceto(NegarOperador(tercetoAux.operacion), NO_MODIF, NO_MODIF, lt, pos);
}


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




void DumpLista(lista_tercetos_t* p)
{	
	if(DEBUG){printf("Volcamos la lista de tercetos a intermedia.txt");}		
	char* terminales[] = {":=", "+", "-", "*", "/", "<", "<=", "==", ">", ">=", "!=", "++", "WRITE", "READ", "FIN", "JMP", "JE", "JNE", "JB", "JBE", "JA", "JAE", "ETIQ", "==STR", "!=STR", "MU","AND","OR","CMP","AVG","FACT","COMB","END"};
	int i = 0;
	t_node *act = *p;
	terceto_t terc;
	FILE* pf = fopen("Outputs/intermedia.txt", "wt+");
	
	
	if(!pf)
	{
        informeError("Error creando el archivo de notacion intermedia");		
	}
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

					if(terc.operacion == TERC_WRITE || terc.operacion == TERC_READ){
						fprintf(pf, "[%d] (%s,[%s],[_])\n", i, terminales[abs(terc.operacion) - 1], terc.opIzq);
					}else if(terc.opIzq == TERC_NULL){
						fprintf(pf, "[%d] (%s,[_],[_])\n", i, terminales[abs(terc.operacion) - 1]);					
					}else{
                    	fprintf(pf, "[%d] (%s,[%d],[_])\n", i, terminales[abs(terc.operacion) - 1], terc.opIzq);
					}					
				} else{ //Es un terminal, un operador l�gico binario						
                    	fprintf(pf, "[%d] (%s,[%d],[%d])\n", i, terminales[abs(terc.operacion) - 1], terc.opIzq, terc.opDer);					
				}
			}
			else
			{
                if(terc.opIzq == TERC_NULL)//Es un un ID o constante
                    fprintf(pf, "[%d] (%s,[_],[_])\n", i, terc.operacion);
				                    
			}
			act = act->sig;
			i++;
		}
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

int informeError(char * error){
		printf("\n%s",error);
		getchar();
		exit(1);
}