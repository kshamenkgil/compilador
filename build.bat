cd src
C:\GnuWin32\bin\flex Lexico.l
C:\GnuWin32\bin\bison -dyv Sintactico.y
cd ..
gcc.exe src\lex.yy.c src\y.tab.c src\asm.c src\pila.c src\Terceto.c -o bin\Primera.exe

del src\lex.yy.c
del src\y.tab.c
del src\y.output
del src\y.tab.h
pause
