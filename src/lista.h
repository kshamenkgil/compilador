#ifndef LISTA_H
#define LISTA_H

#include <stdio.h>
#include <iostream>
#include <iomanip>
#include <stdlib.h>

template <class R> class Nodo
{ 	public:
   R Contenido;
   Nodo<R> *Siguiente;
};

template <class T> class Lista
{
      Nodo<T> *Puntero_a_nodo;
		Nodo<T> *Puntero_a_lista;
		bool error_de_memoria;
	public:
   	Lista();
      ~Lista();
		bool Insertar_al_comienzo(T);
		bool Insertar_al_final(T);
      bool Pasar_a_nodo_sig();
      T MostrarNodo();
      T MostrarPrimerNodo();
      bool ListaVacia();
      bool ErrorDeMemoria();
      T Eliminar_primero();
      T Eliminar_ultimo();
      bool Vaciar_lista();
		void Modificar(T, int);
};

#endif
