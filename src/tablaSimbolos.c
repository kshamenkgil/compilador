#include "tablaSimbolos.h"

//Tabla de Simbolos
TS tabla[MAX_TS];

//Tope Tabla de Simbolos
int topeTS = 0;

TS getItemTS(int pos){
	return tabla[pos];
}

int getTopeTS(){
	return topeTS;
}

/* Funciones */
/* De no existir el Token en la tabla de simbolos lo agrega */
int agregarTokenTS(char *n,char *valueString,int type, int l, double value)
{	int pos_token_ts;


	if(DEBUG)  { printf("Verifico si %s existe en la Tabla de Simbolos. \n",n);}

	if(type == VRBL || type == VRBL_AUX)
		pos_token_ts = existeTokenEnTS(n,type);
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
			if(type != VRBL)
				incrementarIConstantes();
			return topeTS-1;
	}
	else
	{
		if(DEBUG)  { printf("El token ya se encuentra en la Tabla de Simbolos. Posicion: (%d). \n",pos_token_ts);}
		return pos_token_ts;
	}
}

void agregarTipoIDaTS(char *n,int type)
{	int pos_token_ts;
	if(DEBUG)  {	 printf("Verifico si %s existe en la Tabla de Simbolos. \n",n);}
	pos_token_ts = existeTokenEnTS(n, type);
	if(pos_token_ts!=topeTS)
	{
		if(DEBUG)  {	 printf("\n Existe! Lo agrego en la Posicion: %d. \n",pos_token_ts);}
			tabla[pos_token_ts].tipo=type;
			//topeTS++;
	}
	else
	{
		informeError("El id no existe en la TS. ERROR");	
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
	strcpy(a,valor_token);
	strcpy(yt,nombre_token);
}

void imprimirTabla(){
    int i;

    FILE * pfTablaSimbolos; //Tabla de Simbolos
    FILE * pfTablaSimbolos2; //Tabla de Simbolos
    
    //Creación del archivo tablaSimbolos.txt
    if((pfTablaSimbolos = fopen("Outputs/tablaSimbolos.txt","w")) == NULL)
    {
		if((pfTablaSimbolos = fopen("tablaSimbolos.txt","w")) == NULL)
        	informeError(". \nError al crear el archivo tablaSimbolos.txt. \n");			
    }
    //Creación del archivo tablaSimbolos2.txt
    if((pfTablaSimbolos2 = fopen("Outputs/tablaSimbolos2.txt","w")) == NULL)
    {
		if((pfTablaSimbolos2 = fopen("tablaSimbolos2.txt","w")) == NULL)
        	informeError(". \nError al crear el archivo tablaSimbolos2.txt. \n");		 
    }

    //Genero la primer tabla de simbolos
    //Imprimir TS en el txt
    fprintf(pfTablaSimbolos,"\t\t\t ******Tabla de Simbolos******\n\n");
    fprintf(pfTablaSimbolos,"***El tipo de variable lo determina el caracter que precede a esta última:\n\t _(variable);$(cte float);&(cte int);(NADA)(cte string)***\n");
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
    fprintf(pfTablaSimbolos2,"***El tipo de variable lo determina el caracter que precede a esta última:\n\t _(variable);$(cte float);&(cte int);(NADA)(cte string)***\n");
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
}

//para ver si existe la constante float
int existeCteFloat(double valor){
	
	int i=0;
	int ret;
	while(i < topeTS){
		
		if(fabs(tabla[i].valor - valor) < 0.0000000001){
		//if(tabla[i].valor==valor){
			ret = i;
			return ret;
		}

		i++;
	}

	return i;

}

//para constantes float
int findFloatTS(int pos){
	return tabla[pos].nombre;
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
	printf("%s",valorString);
	getchar();
	informeError("No existe constante en TS");

}

//para tokens id
int findAuxTS(int pos){
	return tabla[pos].nombre;
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
	while(pos <= topeTS){
		if(pos == ind){
			*reg = tabla[ind];
			break;
		}	
		pos++;
	}	
}

void verificarTipos(int posEnTs, int type, int igual){
	char* tipos[] = {"Palabra Reservada", "Variable", "Int", "Float", "String", "Variable Aux"};

	if(igual){
		if(tabla[posEnTs].tipo != type){
				char msg[STR_VALUE] = "Error de tipos. Incompatibilidad de estos dos tipos:  ";
				strcat(msg,tipos[type]);
				strcat(msg,"  - ");	
				strcat(msg,tipos[tabla[posEnTs].tipo]);		 
				informeError(msg);
		}
	}
	if(!igual){
		if(tabla[posEnTs].tipo == type){
				char msg[STR_VALUE] = "Error de tipos. No es posible el siguiente tipo:  ";
				strcat(msg,tipos[type]);	 
				informeError(msg);
		}
	}

}