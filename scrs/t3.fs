
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
  ;  
 
 \ changes the first EXIT to next current compiled dictionary cell

 : DOES> HERE LATEST CELL + CELL + CELL + ! ; IMMEDIATE  

 : VALUE CREATE , DOES> @ ;  
 

 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , \ compiling 
        ELSE ! THEN ;  	


 : DEFER :NAME ['] EXIT , ['] EXIT , ;
 
 : IS ' ! ; 

 \ classics

 : <BUILDS CREATE 0 , ;  

 : VARIABLE CREATE 0 , ;  

 : CONSTANT CREATE , DOES> @ ;  
 
 : BUFFER CREATE ALLOT ;  

 : ARRAY CREATE ALLOT DOES> + @ ;  

