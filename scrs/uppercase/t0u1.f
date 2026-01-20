
 : TYPE, 0 DO DUP C@ , 1 + LOOP DROP  ; SEE 

 : ," STATE 
        IF [CHAR] " PARSE TYPE, 
        ELSE  
        R> BEGIN DUP C@ DUP [CHAR] " = UNTIL >R 
        THEN ; SEE 

