 \ crude pointer for CREATE DOES>

 : >BODY ['] LIT , HERE CELL + , 0 ,  ; SEE 

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        HERE >BODY ! 
        ['] EXIT , 
        ['] EXIT , 
        LATEST !  ; SEE  
 
 : DOES> R> >BODY @ !  ; SEE  

 : <BUILDS CREATE 0 ,  ; SEE  

 : VARIABLE CREATE CELL ALLOT  ; SEE  

 : CONSTANT CREATE , DOES> @  ; SEE  
 
 : BUFFER CREATE ALLOT  ; SEE  

 : ARRAY CREATE ALLOT DOES> + @  ; SEE  

 : VALUE CREATE , DOES> @  ; SEE  
 
 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , 
        ELSE ! THEN  ; SEE  

