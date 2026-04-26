 
 \ based on reference standart 
 \ dpans94, X3-215 1994. 
 \
 \
 \ 0 CONSTANT CASE IMMEDIATE  
 \
 \ : OF 1 + >R 
 \       POSTPONE OVER 
 \       POSTPONE = 
 \       POSTPONE IF 
 \       POSTPONE DROP 
 \       R> ; IMMEDIATE 
 \
 \ : ENDOF >R POSTPONE ELSE R> ; IMMEDIATE 
 \
 \ : ENDCASE 
 \       POSTPONE DROP 
 \       0 ?DO POSTPONE THEN LOOP 
 \       ; IMMEDIATE 
 \

 : CASE 0 >R ; IMMEDIATE  
 
 : OF R> 1 + >R 
        ['] OVER ,
        ['] = , 
	['] ?BRANCH , HERE 0 ,
        ['] DROP 
        ; IMMEDIATE 
 
 : ENDOF 
	['] BRANCH , HERE 0 , 
	SWAP DUP HERE 
	SWAP - SWAP ! 
        ; IMMEDIATE

 : ENDCASE 
        ['] DROP  
        0 ?DO DUP HERE SWAP - SWAP ! LOOP 
        ; IMMEDIATE 
 

 \ defer set 
 
 \ : >BODY CELL + @ ; 
 
 : DEFER CREATE HERE >BODY ! ['] ABORT , DOES> @ EXECUTE ; 
 
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
 
