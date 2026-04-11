 
 \ common standart 2012 
 \ http://www.forth200x.org/deferred.fs 
 \ based on reference standart 
 \ defer set 
 
 \ : >BODY CELL + @ ; 
 
 : >BODY @ ; 
 
 : DEFER CREATE ['] ABORT , DOES> @ EXECUTE ; 
 
 : DEFER! >BODY ! ; 

 : DEFER@ >BODY @ ; 
 
 : IS STATE @ 
        IF ['] ['] , ['] DEFER! ,
        ELSE ' DEFER! 
        THEN ; IMMEDIATE 
 
 : ACTION-OF STATE @ 
        IF ['] ['] , ['] DEFER@ ,
        ELSE ' DEFER@ 
        THEN ; IMMEDIATE 
 
 \ case set adapted from reference forth 2012 standart

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
 
