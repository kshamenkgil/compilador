c:\GnuWin32\bin\flex src\Lexico.l
c:\GnuWin32\bin\bison -dyv src\Sintactico.y
c:\MinGW\bin\gcc.exe src\lex.yy.c src\y.tab.c -o bin\TPEntregable.exe

del src\lex.yy.c
del src\y.tab.c
del src\y.output
del src\y.tab.h
pause
