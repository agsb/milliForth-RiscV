

\ from forth200x.org

\ exception word set, 

\ SP@ returns the address of top of data stack
\ SP! restors the address of top of data stack
\ RP@ returns the address of top of return stack
\ RP! restors the address of top of return stack

0 VARIABLE HANDLER

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
 
 : ABORTS -1 THROW ;
                
\ facility word set

: +FIELD CREATE OVER , + DOES> @ + ;

: BEGIN-STRUCTURE CREATE HERE 0 0 , DOES @ ;

: END-STRUCTURE SWAP ! ;


