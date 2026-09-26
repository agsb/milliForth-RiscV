
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
 : FIND ( caddr -- caddr 0 \ not found | caddr1 1 \ if immediate | caddr1 -1 \ if not immediate )
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
 
