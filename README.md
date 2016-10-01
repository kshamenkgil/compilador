# Compilador


MIRAR CHANGELOG.md
--------------------

Así como esta compila y funciona BASTANTE BIEN. Genera TS y todo :|
Revisar los TODOs.

TODOs:
--------------------
* Ver lo de la tabla de símbolos
	Verificar bien que hace y pulir (hay for con breaks, nombre malos ,etc)
* Testear a con diferentes entradas
* Ver como escribe la TS en un txt


* Revisar de nuevo los printf de las acciones semánticas del sintáctico. 
	-> --LISTO-- 
* Revisar el comentario que dejé en el sintáctico respecto a sacar algo. 
	-> que tiene de malo "lista_variables" ? Si era un tema de recursividad, se la cmbie a derecha, asi cuando lee el primer token ya lo convierte a lista y luego se maneja solo con "lista, id". Si no era eso, no se que tenía de malo
* Cambiar algunos nombres .. 
	-> --LISTO--
* Average, Factorial y Combinatorio 
	-> --LISTO--
* VER que onda con el tema de que puedo poner un id en cualquier lado sin antes haberlo declarado. Se verifica con sintáctico eso? O es para más adelante?
	-> Se verifica con acciones semanticas, pero a la hora de generar Intermedio (donde defino la suma, resta, funciones, etc)


Generar compilador:
----------------------
```sh
./build.sh
```
