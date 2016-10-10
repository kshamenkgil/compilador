/******************************************************************************/
typedef struct {
	char parametro_1[MAX];
  	char parametro_2[MAX];
  	char parametro_3[MAX];
}estructura_tercetos;
estructura_tercetos tercetos;
/******************************************************************************/
// Lista de ID
typedef struct {
	char parametro[MAX];
	int indice;
}estructura_id;
estructura_id estruc_id;
/******************************************************************************/
// Lista de Tipo
typedef struct {
	char parametro[MAX];
}estructura_tipo;
/******************************************************************************/
typedef struct {
	char parametro[MAX];
	int indice;
	char tipo[10];
}estructura_pila;
/******************************************************************************/

typedef struct {
        int contador;
        char sentencia[MAX];
}pila_cont_etiquetas;
