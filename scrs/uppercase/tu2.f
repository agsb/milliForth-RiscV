 
 \ common standart 2012 
 \ http://www.forth200x.org/deferred.fs 
 \ based on reference standart 
 
 \ case set 
 

HASH DUP FIND .

HASH IF FIND .

%S 

 0 CONSTANT CASE IMMEDIATE  
 
 : ENDOF POSTPONE ELSE ; IMMEDIATE 

 : OF 1 + >R 
        POSTPONE OVER 
        POSTPONE = 
        POSTPONE IF 
        POSTPONE DROP 
        R> ; IMMEDIATE 
 
 : ENDCASE 
        POSTPONE DROP 
        DUP 0 = IF DROP EXIT THEN 
        0 DO POSTPONE THEN LOOP 
        ; IMMEDIATE 
 
 \ defer set 
 
 \ : >BODY CELL + @ ; 
 
 : >BODY @ ; 
 
 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ; 
 
 : DEFER! >BODY ! ; 
 
 : IS STATE @ 
        IF POSTPONE ['] POSTPONE DEFER! 
        ELSE ' DEFER! 
        THEN ; IMMEDIATE 
 
 : DEFER@ >BODY @ ; 
 
 : ACTION-OF STATE @ 
        IF POSTPONE ['] POSTPONE DEFER@ 
        ELSE ' DEFER@ 
        THEN ; IMMEDIATE 
 
