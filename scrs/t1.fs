\ the dictionary is a set of  
\ link, hash, code, exit
\ link is a pointer to previous word
\ hash is the djb2 32 bits hash with high bit clear
\    high bit is immediate flag, set only in immediate words 
\ code is a set of pointers or native code

\ where is the hash

 : LINK>HASH CELL + ; 

 SEE 

\ where is the code

 : LINK>BODY CELL + CELL + ; 

 SEE

 \ make a header

 : :NAME HERE : 0 STATE ! ; 

 SEE

 \ make a body

 : :NONAME HERE 1 STATE ! ; 

 SEE

 : HASH HERE :NAME SWAP HEAP ! CELL + @ ; 

 SEE

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
 
 \ zzzz review it
 : FIND ( caddr -- caddr 0 | caddr1 1 immediate | caddr1 -1 not immediate )
	LATEST @ 
	BEGIN
    	OVER OVER CELL + @
    	ISNEGATIVE 1 - AND
    = IF SWAP DROP TRUE EXIT THEN
    @ DUP 0 
    = IF SWAP DROP FALSE EXIT THEN
    AGAIN ; 


 HASH HASH . CR

 \ HASH2 HASH . CR

 ISNEGATIVE 1 - . CR

 ISNEGATIVE 1 + . CR

 FIND HASH . CR
 
 SEE HASH

 BYE

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


