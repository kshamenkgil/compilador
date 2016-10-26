#!/bin/bash
so="$(uname -o)"
if [ "$so" == "GNU/Linux" ]; then
	rm bin/TPEntregable
	cd src
	flex Lexico.l
	bison -dyv Sintactico.y
	cd ..
	mkdir -p bin
	gcc src/lex.yy.c src/y.tab.c src/asm.c src/pila.c src/Terceto.c src/tablaSimbolos.c -o bin/TPEntregable
	rm src/lex.yy.c
	rm src/y.tab.c
	rm src/y.output
	rm src/y.tab.h
else
	cd src
	c:\GnuWin32\bin\flex src\Lexico.l
	c:\GnuWin32\bin\bison -dyv src\Sintactico.y
	cd ..
	mkdir -p bin
	c:\MinGW\bin\gcc.exe src\lex.yy.c src\y.tab.c src\asm.c src\pila.c src\Terceto.c src\tablaSimbolos.c -o bin\TPEntregable.exe
	rm src\lex.yy.c
	rm src\y.tab.c
	rm src\y.output
	rm src\y.tab.h	
fi
