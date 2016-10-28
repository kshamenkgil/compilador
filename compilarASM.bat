bin\Compilador.exe Test\prueba.txt
tasm /la /zi bin\Final.asm
REM tasm /la /zi bin\numbers.asm
tlink /3 bin\Final.obj bin\numbers.obj /v /s /m
del FINAL.OBJ
del FINAL.MAP
del FINAL.LST