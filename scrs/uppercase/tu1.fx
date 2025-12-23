
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

 : POSTPONE ' , ; IMMEDIATE SEE 

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

 \ based on reference standart, without ?DO

 0 CONSTANT CASE IMMEDIATE SEE

 : ENDOF POSTPONE ELSE ; IMMEDIATE SEE

 : ENDCASE POSTPONE DROP
    DUP 0 = IF DROP EXIT THEN
    0 DO POSTPONE THEN LOOP
    ; IMMEDIATE SEE

 : OF 1 + >R
    POSTPONE OVER POSTPONE =
    POSTPONE IF POSTPONE DROP
    R> ; IMMEDIATE SEE

 \ use as: TO 

 : VALUE CREATE , DOES> @ ; SEE

 : TO 
     ' >BODY
     STATE @ 
     IF ' LIT , , ' ! ,  ELSE !
     THEN ; SEE 

 \ common standart 2012
 \ http://www.forth200x.org/deferred.fs

 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ; SEE

 : DEFER@ >BODY @ ; SEE

 : DEFER! >BODY ! ; SEE

 : IS STATE @ 
        IF POSTPONE ['] POSTPONE DEFER!
        ELSE ' DEFER!
        THEN ; IMMEDIATE SEE

 : ACTION-OF STATE @
        IF POSTPONE ['] POSTPONE DEFER@
        ELSE ' DEFER@
        THEN ; IMMEDIATE SEE


