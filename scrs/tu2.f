 
 \ common standart 2012 
 \ http://www.forth200x.org/deferred.fs 
 \ based on reference standart 
 
 \ case set from punyforth 
 
: CASE ( -- branch-counter ) 0 ; IMMEDIATE

: OF 
    	['] OVER , 
	['] = ,
    	['] ?BRANCH , HERE 0 , 
    	['] DROP , ; IMMEDIATE

: ENDOF 
    	SWAP 1 + SWAP             
    	['] BRANCH , HERE 0 , SWAP
    	HERE OVER - SWAP ! 
    	SWAP ; IMMEDIATE

: ENDCASE ( #branches #branchesi*a -- )
	0 DO HERE OVER - SWAP ! LOOP ; IMMEDIATE


 \ case set reference forth 2012 std, changed

 : CASE 0 ; IMMEDIATE  
 
 : OF 1 + >R 
        ['] OVER ,
        ['] = , 
	['] ?BRANCH , HERE 0 ,
        ['] DROP 
        R> ; IMMEDIATE 
 
 : ENDOF 
	['] BRANCH , HERE 0 , 
	SWAP DUP HERE 
	SWAP - SWAP ! ; IMMEDIATE

 : ENDCASE 
        ['] DROP , DUP 0 = 
	IF DROP EXIT 
	THEN 0 DO DUP HERE SWAP - SWAP ! LOOP 
        ; IMMEDIATE 
 
 \ case set reference forth 2012 std

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
 
