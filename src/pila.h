#ifndef PILA_H
#define PILA_H

#include <stdio.h>

#include <iostream>
#include <iomanip>
#include <stdlib.h>

template <class R> class NodoPila
{ 	public:
   R Contenido;
   NodoPila<R> *Siguiente;
};

template <class T> class Pila
{
		NodoPila<T> *Tope;
		bool error_de_memoria;
	public:
   	Pila();
      ~Pila();
      bool ErrorDeMemoria();
		bool Poner(T);
      T Sacar();
      bool PilaVacia();
      bool Vaciar_pila();

};

#endif
