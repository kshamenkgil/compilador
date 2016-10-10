#include "lista.h"

template <class T> Lista<T>::Lista() // Constructor
{
   Puntero_a_lista = NULL;
   Puntero_a_nodo = Puntero_a_lista;
}

template <class T> Lista<T>::~Lista(void) // Destructor
{
	Nodo<T> *NodoAuxiliar;
	while(Puntero_a_lista)
	{
   	NodoAuxiliar = Puntero_a_lista;
      Puntero_a_lista = Puntero_a_lista -> Siguiente;
      delete NodoAuxiliar;
   }
	Puntero_a_nodo = Puntero_a_lista;
}

template <class T> T Lista<T>::MostrarNodo()
{
 	T aux = Puntero_a_nodo->Contenido;
 	Puntero_a_nodo = Puntero_a_nodo->Siguiente;
	return aux;
}

template <class T> T Lista<T>::MostrarPrimerNodo()
{
 	T aux = Puntero_a_lista->Contenido;
	return aux;
}

template <class T> void Lista<T>::Modificar(T Dato, int x)
{
	Nodo<T> *Puntero_Auxiliar = Puntero_a_lista ;
	for(int i = 1; i < x; i++)
   	Puntero_Auxiliar = Puntero_Auxiliar->Siguiente;
   Puntero_Auxiliar->Contenido = Dato;
}

template <class T> bool Lista<T>::Pasar_a_nodo_sig()
{
 	if(Puntero_a_nodo == NULL)
   {
      Puntero_a_nodo = Puntero_a_lista;
   	return true;
   }
 	return false;
}

template <class T> bool Lista<T>::ListaVacia()
{
 	if(Puntero_a_lista == NULL)
   	return true;
 	return false;
}

template <class T> bool Lista<T>::Insertar_al_comienzo(T Dato)
{
	Nodo<T> *Nodo_Auxiliar = new Nodo<T>;
  	if(Nodo_Auxiliar == NULL)
	{
     	error_de_memoria = true;
      return false;
   }
  	Nodo_Auxiliar -> Contenido = Dato;
   if (Puntero_a_lista == NULL)
   {
	  	Puntero_a_lista = Nodo_Auxiliar;
	   Puntero_a_nodo = Puntero_a_lista;
      Nodo_Auxiliar -> Siguiente = NULL;
      return true;
	}
   else
   {
		Nodo_Auxiliar -> Siguiente = Puntero_a_lista;
   	Puntero_a_lista = Nodo_Auxiliar;
		Puntero_a_nodo = Puntero_a_lista;
		return true;
	}
}

template <class T> bool Lista<T>::Insertar_al_final(T Dato)
{
	Nodo<T> *Nodo_Auxiliar = new Nodo<T>;
  	if(Nodo_Auxiliar == NULL)
	{
     	error_de_memoria = true;
      return false;
   }
  	Nodo_Auxiliar -> Contenido = Dato;
	Nodo_Auxiliar -> Siguiente = NULL;

   Nodo<T> *Puntero_Auxiliar = Puntero_a_lista ;

	if (ListaVacia() == true )
	{
   	Puntero_a_lista = Nodo_Auxiliar;
		Puntero_a_nodo = Puntero_a_lista;
   }
   else
   {
   	while ( Puntero_Auxiliar -> Siguiente )
			Puntero_Auxiliar = Puntero_Auxiliar -> Siguiente ;
	   Puntero_Auxiliar -> Siguiente = Nodo_Auxiliar;
   }
	return true;
}

template <class T> bool Lista<T>::ErrorDeMemoria()
{
	if (error_de_memoria == true)
   	return true;
   return false;
}

template <class T> bool Lista<T>::Vaciar_lista()
{
	if (Puntero_a_lista == NULL)
   	return false;

   if (Puntero_a_lista -> Siguiente == NULL)
   {
   	delete Puntero_a_lista;
   	Puntero_a_lista = NULL;
		Puntero_a_nodo = Puntero_a_lista;
      return true;
   }

   Nodo<T> *Nodo_anterior;
   while (Puntero_a_lista)
   {
   	Nodo_anterior = Puntero_a_lista;
      Puntero_a_lista = Puntero_a_lista -> Siguiente;
		Puntero_a_nodo = Puntero_a_lista;
      delete Nodo_anterior;
   }
   return true;
}

template <class T> T Lista<T>::Eliminar_primero()
{
   T auxiliar = Puntero_a_lista->Contenido;
   Nodo<T> *Puntero_auxiliar = Puntero_a_lista;
   Puntero_a_lista = Puntero_a_lista->Siguiente;
	Puntero_a_nodo = Puntero_a_lista;
   delete Puntero_auxiliar;
   return auxiliar;
}

template <class T> T Lista<T>::Eliminar_ultimo()
{
   Nodo<T> *Puntero_auxiliar = Puntero_a_lista;
   Nodo<T> *Puntero_anterior = Puntero_a_lista;
   while(Puntero_auxiliar->Siguiente)
   {
   	Puntero_anterior = Puntero_auxiliar;
   	Puntero_auxiliar = Puntero_auxiliar -> Siguiente;
   }

	if (Puntero_auxiliar == Puntero_anterior) //hay un solo nodo
   {
	   T auxiliar = Puntero_a_lista->Contenido;
	   delete Puntero_a_lista;
      Puntero_a_lista = NULL;
      Puntero_a_nodo = Puntero_a_lista;
	   return auxiliar;
	}

	T auxiliar = Puntero_auxiliar->Contenido;
   Puntero_anterior->Siguiente = NULL;
   delete Puntero_auxiliar;
   return auxiliar;
}




