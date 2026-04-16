

\ from forth200x.org

\ exception word set, 

 VARIABLE HANDLER
 
 0 HANDLER !

 : CATCH
        SP@ >R 
        HANDLER @ >R
        RP@ HANDLER !
        EXECUTE
        R> HANDLER !
        R> DROP
        0 ;

 : THROW
        ?DUP IF
                HANDLER @ RP!
                R> HANDLER !
                R> SWAP >R
                SP! DROP R>
        THEN ;
 
 : ABORT -1 THROW ;
                
 \ facility word set

 : +FIELD CREATE OVER , + DOES> @ + ;

 : BEGIN-STRUCTURE CREATE HERE 0 0 , DOES> @ ;

 : END-STRUCTURE SWAP ! ;

