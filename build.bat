cd src
flex Lexico.l
bison -dyv Sintactico.y
cd ..
gcc.exe src/lex.yy.c src/y.tab.c -o bin/Primera.exe

del src\lex.yy.c
del src\y.tab.c
del src\y.output
del src\y.tab.h
pause
