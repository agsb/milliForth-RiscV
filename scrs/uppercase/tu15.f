
 \ this file is still a stub 

\ adapted from
\ https://github.com/gerryjackson/forth2012-test-suite/blob/master/src/tester.fr
\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.2

 VARIABLE VERBOSE FALSE VERBOSE !

 VARIABLE ACTUAL-DEPTH

 CREATE ACTUAL-RESULTS 20 CELLS ALLOT

 : EMPTY-STACK SP0 SP@ ! ;

 : DEPTH SP0 SP@ @ - !

 : ERROR
        CR TYPE SOURCE TYPE
        EMPTY-STACK
        #ERRORS @ 1 + #ERRORS !
        ;
        
 :T{ ;

 : -> DEPTH SUP ACTUAL-DEPTH !
        ?DUP IF 0 DO ACTUAL-RESULTS I CELLS + ! LOOP THEN ;

 : }T
        DEPTH ACTUAL-DEPTH @ = 
        IF DEPTH ?DUP 
                IF 0 DO ACTUAL-RESULTS I CELLS + @ = 0= 
                        IF S" INCORRECT RESULT: " ERROR 
                        LEAVE THEN
                     LOOP
                THEN
        ELSE
                S" WRONG NUMBER OF RESULTS: " ERROR
        THEN ;        
                        
 : TESTING SOURCE VERBOSE @
        IF DUP >R TYPR CR R> >IN !
        ELSE >IN ! DROP [CHAR] * EMIT
        THEN ;

 
