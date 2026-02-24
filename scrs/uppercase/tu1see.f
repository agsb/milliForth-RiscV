
 \ this file is still a stub 

 \ for stack debug

 \ for compilation 

 : :NAME HERE : 0 STATE ! ; SEE \ make a header

 : :NONAME HERE 1 STATE ! ; SEE \ make a body

 : LINK>HASH CELL + ; SEE

 : LINK>BODY CELL + CELL + ; SEE

 : HASH :NAME DUP HEAP ! CELL + @ ; SEE

 : FIND LATEST @ BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
        = IF SWAP DROP TRUE EXIT THEN
        @ DUP 
        0 = IF SWAP DROP FALSE EXIT THEN
        AGAIN ; SEE
 
 : ' HASH FIND IF CELL + CELL + THEN ; SEE 

 : POSTPONE ' , ; SEE IMMEDIATE  

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE 
   :NAME 
   ['] LIT , 
   HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , 
   ['] EXIT , 
   LATEST ! ; SEE

 : >BODY CELL + @ ; SEE

 : <BUILDS CREATE 0 , ; SEE

 : VARIABLE CREATE CELL ALLOT ; SEE

 : BUFFER CREATE ALLOT ; SEE

 : DOES> R> TAIL @ ! ; SEE

 : CONSTANT CREATE , DOES> @ ; SEE
 
 : ARRAY CREATE ALLOT DOES> + @ ; SEE

