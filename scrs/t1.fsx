
\ where is the hash

 : LINK>HASH CELL + ; 

 SEE 

\ where is the body

 : LINK>BODY CELL + CELL + ; 

 SEE 

 \ make a header

 : :NAME HERE : 0 STATE ! ; 

 SEE

 \ make a body

 : :NONAME HERE 1 STATE ! ; 

 SEE

 \ : HASH HERE :NAME SWAP HEAP ! CELL + @ ; 

 : DJB2 LIT [ 1024 DUP DUP + DUP + + 256 + 4 + 1 + , ] ; 

 SEE

 DJB2 . SPACE CR 

 BL . SPACE CR 

 \ BYE

 : HASH 
        BL BEGIN KEY OVER OVER = NOT UNTIL 
        DJB2 BEGIN 
                DUP DUP + DUP + DUP + DUP + DUP + + XOR >R
                KEY OVER OVER = 
                IF TRUE ELSE R> FALSE THEN
        UNTIL
        DROP DROP R>  
        ;
 
 SEE 

 : FIND LATEST @ BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
        = IF SWAP DROP TRUE EXIT THEN
        @ DUP 0 
        = IF SWAP DROP FALSE EXIT THEN
        AGAIN ; 
 
 SEE 

 \ BYE

 HASH HASH . ." "

 HASH U@ . ." "

 HASH 0# . ." "

 : ' HASH FIND IF CELL + CELL + THEN ;  
 
 : '= ' ; IMMEDIATE  

 : POSTPONE ' , ; IMMEDIATE 

 \ crude pointer for CREATE DOES>

 : >BODY ['] LIT , HERE CELL + , 0 , ;

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        HERE >BODY ! 
        ['] EXIT , 
        ['] EXIT , 
        LATEST ! ; 
 
 : DOES> R> >BODY @ ! ; 

 : <BUILDS CREATE 0 , ; 

 : VARIABLE CREATE CELL ALLOT ; 

 : CONSTANT CREATE , DOES> @ ; 
 
 : BUFFER CREATE ALLOT ; 

 : ARRAY CREATE ALLOT DOES> + @ ; 

 : VALUE CREATE , DOES> @ ; 
 
 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , 
        ELSE ! THEN ; 


