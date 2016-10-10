#include "pila.h"

template <class T> Pila<T>::Pila() // Constructor
{
   Tope = NULL;
}

template <class T> Pila<T>::~Pila(void) // Destructor
{
	NodoPila<T> *NodoAuxiliar;
	while(Tope)
	{
   	NodoAuxiliar = Tope;
      Tope = Tope -> Siguiente;
      delete NodoAuxiliar;
   }
}

template <class T> bool Pila<T>::PilaVacia()
{
 	if(Tope == NULL)
   	return true;
 	return false;
}

template <class T> bool Pila<T>::Poner(T Dato)
{
	NodoPila<T> *Nodo_Auxiliar = new NodoPila<T>;
  	if(Nodo_Auxiliar == NULL)
	{
     	error_de_memoria = true;
      return false;
   }
  	Nodo_Auxiliar -> Contenido = Dato;
   if (Tope == NULL)
   {
   	Tope = Nodo_Auxiliar;
      Nodo_Auxiliar -> Siguiente = NULL;
      return true;
	}
   else
   {
		Nodo_Auxiliar -> Siguiente = Tope;
   	Tope = Nodo_Auxiliar;
		return true;
	}
}

template <class T> bool Pila<T>::ErrorDeMemoria()
{
	if (error_de_memoria == true)
   	return true;
   return false;
}

template <class T> T Pila<T>::Sacar()
{
   T auxiliar = Tope->Contenido;
   NodoPila<T> *Puntero_auxiliar = Tope->Siguiente;
   delete Tope;
   Tope = Puntero_auxiliar;
   return auxiliar;
}

template <class T> bool Pila<T>::Vaciar_pila()
{
	if (Tope == NULL)
   	return false;

   if (Tope -> Siguiente == NULL)
   {
   	delete Tope;
   	Tope = NULL;
      return true;
   }

   NodoPila<T> *Nodo_anterior;
   while (Tope)
   {
   	Nodo_anterior = Tope;
      Tope = Tope -> Siguiente;
      delete Nodo_anterior;
   }
   return true;
}


