 
 \ find a word by hash
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
    AGAIN  ; SEE  

 \ retrieve CFA 
 : ' HASH FIND IF CELL + CELL + THEN  ; SEE   
 
 \ compile CFA 
 : POSTPONE ' ,  ; SEE  IMMEDIATE 
 
