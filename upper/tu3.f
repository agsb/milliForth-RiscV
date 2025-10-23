 
 \ this file is still a stub 

 %S

 \ from eforth, first EXIT is reserved for DOES> 
 : CREATE :NAME 
   ['] LIT , HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , ['] EXIT , 
   LATEST ! ;

 SEE CREATE

 : DOES> . HERE . TAIL . @ . ! . ; IMMEDIATE

 SEE DOES>

 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 : ARRAY CREATE ALLOT ;

 8 4 + . 

%S
 VARIABLE ONE 

 SEE ONE 

 16 ONE ! . ONE . @ .

 TAIL . @ .

%S

 : CONSTANT CREATE , DOES> @ ;

 TAIL . @ .

 SEE CONSTANT

 8 1 + CONSTANT TWO 

%S

TAIL . @ .

%S 

 SEE TWO

 . TWO .
 
 %S

