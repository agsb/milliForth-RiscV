 
 \ this file is still a stub 

 %S

 \ from eforth, first EXIT is reserved for DOES> 
 : CREATE :NAME 
   ['] LIT , HERE CELL + CELL + CELL + , 
   HERE TAIL ! 
   ['] EXIT , ['] EXIT , 
   LATEST ! ;

 SEE CREATE

 : <BUILDS CREATE 0 , ;

 : VARIABLE CREATE CELL ALLOT ;

 SEE VARIABLE

 : ARRAY CREATE ALLOT ;

 VARIABLE ONE 

 SEE ONE 

 16 1 + ONE ! . ONE . @ .

 : R@ R> DUP >R ;

 : DOES> . R@ . TAIL . @ . ! . ;

 SEE DOES>

 : CONSTANT CREATE , DOES> @ ;
 
 SEE CONSTANT

 CONSTANT TWO 

 SEE TWO

 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ;

 8 1 + . 

%S 

. TWO .

%S 

TAIL . @ .

 %S

