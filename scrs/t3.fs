
\ a entry is  LINK HASH CODE ... CODE EXIT
\ LATEST points to LINK
\ TICK points to CODE

\ where is the hash

 : L>H CELL + ; 

\ where is the code

 : L>C CELL + CELL + ; 

\ where the does changes
 
 : L>D CELL + CELL + CELL + ;

 \ make a header as :name

 : :NAME HERE LATEST @ , LATEST ! HASH , ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ;

 \ from eforth, 
 \ leaves a pointer to next cell after second EXIT
 \ first EXIT is reserved for DOES> use 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        ['] EXIT , 
        ['] EXIT , 
   ; SEE  
 
 \ changes the first EXIT to next current compiled dictionary cell

 : DOES> R> DUP >R LATEST CELL + CELL + CELL + !  ; SEE IMMEDIATE 

 SEE 

 \ classics

 : <BUILDS CREATE 0 ,  ; SEE  

 : VARIABLE CREATE 0 ,  ; SEE  

 : CONSTANT CREATE , DOES> @  ; SEE  
 
 : BUFFER CREATE ALLOT  ; SEE  

 : ARRAY CREATE ALLOT DOES> + @  ; SEE  

 : VALUE CREATE , DOES> @  ; SEE  
 
 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , \ compiling 
        ELSE ! THEN  ; SEE  	

