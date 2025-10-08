
 \ this file is still a stub 

 : && SP@ . DROP RP@ . DROP LATEST @ . DROP HEAP @ . DROP ;

 : SP0 LIT [ SP@ , ] ;

 : RP0 LIT [ RP@ , ] ;

 : RP! RP ! ;

 : SP! SP ! ;

 : DUMPS BEGIN OVER OVER 
        = IF DROP DROP EXIT THEN
        CELL +
        DUP CR . SPACE @ . DROP 
        AGAIN ;

 : $S SP0 SP@ DUMPS ;
 
 : $R RP0 RP@ DUMPS ;

 : ? ( a -- a ) @ . ;

 : :NAME HERE : 0 STATE ! ;

 : :NONAME HERE 1 STATE ! ;

 : HASH :NAME DUP HEAP ! CELL + @ ;

 : LINK>HASH CELL + ;

 : LINK>BODY CELL + CELL + ;

 : FIND
        LATEST @ BEGIN
        OVER OVER CELL + @
        IMMEDIATE 1 - AND
        = IF SWAP DROP TRUE EXIT THEN
        @ DUP 
        0 = IF SWAP DROP FALSE EXIT THEN
        AGAIN ;
 
 : ' HASH FIND IF CELL + CELL + THEN ; 

 : POSTPONE ' , ; IMMEDIATE 

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

 

