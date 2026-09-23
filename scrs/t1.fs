\ the dictionary is a set of  
\ link, hash, code, exit
\ link is a pointer to previous word
\ hash is the djb2 32 bits hash with high bit clear
\    high bit is immediate flag, set only in immediate words 
\ code is a set of pointers or native code

\ where is the hash

 : LINK>HASH CELL + ; 

\ where is the code

 : LINK>BODY CELL + CELL + ; 

 \ make a header

 : :NAME HERE : 0 STATE ! ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ; 

 \ make a hash HFA
 : HASH HERE :NAME SWAP HEAP ! CELL + @ ; 

 : DJB2-CTE ( -- 1505 ) LIT [ 1024 DUP DUP + DUP + + 256 + 4 + 1 + , ] ; 

 : DJB2-HSH ( KEY HSH -- HSH2 ) DUP DUP + DUP + DUP + DUP + DUP + + XOR ;

 : HASH2 
    BL BEGIN KEY OVER OVER = NOT UNTIL 
    DJB2-HSH >R
    ( BL KEY -- )
    BEGIN 
    R> DJB2-HSH >R
        KEY OVER OVER = 
        IF TRUE ELSE FALSE THEN
    UNTIL
    DROP DROP R> 
       ;

 \ find a hash of a word
 : FIND ( caddr -- caddr 0 | caddr1 1 immediate | caddr1 -1 not immediate )
    LATEST @ 
    BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
         = IF SWAP DROP 
            DUP CELL + @
            ISNEGATIVE AND
            0 = IF -1 ELSE 1 THEN EXIT 
        THEN
        @ DUP 0 
        = IF SWAP DROP FALSE EXIT THEN
    AGAIN ; 

 \ retrieve CFA 
 : ' HASH FIND IF CELL + CELL + THEN ;  
 
 \ compile CFA 
 : POSTPONE ' , ; IMMEDIATE 
 
 SEE

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

 HERE .  SPACE

 : TEST U@ 0# ; 
 \ : TEST POSTPONE POSTPONE 
 \   HERE DUP . SPACE POSTPONE IF @ . CR
 \   HERE DUP . SPACE POSTPONE ELSE @ . CR
 \   HERE DUP . SPACE POSTPONE THEN @ . CR
 \   ; 

HERE .  SPACE


SEE

