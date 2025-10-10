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
 
 : FOR ['] >R , BEGIN ; IMMEDIATE

 : NEXT ['] R> , ['] LIT , [ 1 ] , ['] - , 
   ['] DUP , ['] 0# , ['] ?BRANCH ,
   HERE - , ['] DROP , ; IMMEDIATE

 : HOOK BEGIN >R ;
 : BACK R> AGAIN ;
 : ?BACK R> UNTIL ;

 : SWIP >R SWAP R> ; 
 : ROT SWIP SWAP ;
 : -ROT SWAP SWIP ;
 : FLIP SWAP SWIP SWAP ;

\ : DOVAR R> DUP CELL + >R ;
\ : DOCON R> DUP CELL + >R @ ;
\ : LITERAL ['] LIT , , ;
\ : EXECUTE >R ;

 

