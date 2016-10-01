#!/bin/bash
so="$(uname -o)"
echo $so
if [ "$so" == "GNU/Linux" ]; then
	flex Lexico.l
	bison -dyv Sintactico.y
	gcc lex.yy.c y.tab.c -o TPEntregable
else
	c:\GnuWin32\bin\flex Lexico.l
	c:\GnuWin32\bin\bison -dyv Sintactico.y
	c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o TPEntregable.exe
fi

rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h