
 \ this file is still a stub 

 \ for stack debug

 \ for compilation 

 : :NAME HERE : 0 STATE ! ; \ make a header

 : :NONAME HERE 1 STATE ! ; \ make a body

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

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE 
   :NAME 
   ['] LIT , 
   HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , 
   ['] EXIT , 
   LATEST ! ;

 : >BODY CELL + @ ;

 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 : BUFFER CREATE ALLOT ;

 : DOES> R> TAIL @ ! ;

 : CONSTANT CREATE , DOES> @ ;
 
 : ARRAY CREATE ALLOT DOES> + @ ;

