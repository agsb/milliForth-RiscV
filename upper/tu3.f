 
 \ this file is still a stub 

 %S

 \ from eforth, first EXIT is reserved for DOES> 
 : CREATE :NAME 
   ['] LIT , HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , ['] EXIT , 
   LATEST ! ;

 SEE CREATE

 : DOES> HERE TAIL @ ! ; IMMEDIATE

 SEE DOES>

 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 SEE VARIABLE

 : ARRAY CREATE ALLOT ;

 VARIABLE ONE 

 SEE ONE 

 TAIL . @ . DROP

 : CONSTANT CREATE , DOES> @ ;

 SEE CONSTANT

 8 1 + . 

 CONSTANT TWO 

 SEE TWO

%S

TAIL . @ .

%S 

 . TWO .
 
 %S

