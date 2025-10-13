 \ adapted from eForth65, EFO16I01.ASM

 : [,] , ;

 : _VAR R> ;

 : _CON R> @ ;

 : _LIT R> DUP CELL + R> @ ;

 : _DOES R> ['] EDOES @ ! ;

 : DOES> ['] _DOES [,] :NONAME DROP ['] R> [,] ; IMMEDIATE

 : CREATE :NAME LATEST ! HERE ['] EDOES ! ['] _VAR [,] ; 
 
 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 : ARRAY CREATE ALLOT ;
 

