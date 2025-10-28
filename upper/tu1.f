
 \ this file is still a stub 

 \ for stack debug

 \ for compilation 

 : :NAME HERE : 0 STATE ! ;

 : :NONAME HERE 1 STATE ! ;

 : LINK>HASH CELL + ;

 : LINK>BODY CELL + CELL + ;

 : HASH :NAME DUP HEAP ! CELL + @ ;

 : FIND LATEST @ BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
        = IF SWAP DROP TRUE EXIT THEN
        @ DUP 
        0 = IF SWAP DROP FALSE EXIT THEN
        AGAIN ;
 
 : ' HASH FIND IF CELL + CELL + THEN ; 

 : POSTPONE ' , ; IMMEDIATE 

 : SEE  
        HASH FIND IF DUP
        BEGIN
        OVER OVER @ = IF DROP DROP EXIT THEN
        DUP . @ . DROP CR CELL +
        AGAIN
        THEN
        ;

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE 
   :NAME 
   ['] LIT , 
   HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , 
   ['] EXIT , 
   LATEST ! ;

 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 : ARRAY CREATE ALLOT ;

 : DOES> R> TAIL @ ! ;

 : CONSTANT CREATE , DOES> @ ;
 
 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ;

