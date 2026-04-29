 
 \ : REPEATS SWAP AGAIN THEN ; IMMEDIATE 

 %S %R SEE

 \ : AFT DROP ['] COMPILE BRANCH , HERE 0 , HERE SWAP ; IMMEDIATE 

 \ %S %R SEE

 \ : AFT DROP AHEAD HERE SWAP ; IMMEDIATE 
 
 \ %S %R SEE 


 : TESTE
        %S
        IF CR ELSE CR THEN 
        %S 
        BEGIN CR AGAIN
        %S
        BEGIN CR UNTIL
        %S
        BEGIN CR WHILE CR REPEAT
        %S
        ;
 SEE

 BYE

( 
 : DJB2 
        LIT [ 1024 DUP DUP + DUP + + 256 + 4 + 1 + , ] 
        ; 

 : HASH 
        BL BEGIN KEY OVER OVER = NOT UNTIL DJB2 
        BEGIN 
                DUP DUP + DUP + DUP + DUP + DUP + + XOR >R
                KEY OVER OVER =  
                IF TRUE ELSE R> FALSE THEN
        UNTIL
        DROP DROP R>   
        ;

 HASH EMIT %S . 
 HASH EXIT %S .
 HASH NAND %S .
 HASH : %S .
 HASH ; %S . 
 HASH ! %S . 
 HASH @ %S . 
 
 %S 

 ) 

 HASH HASH %S 
 FIND %S 
 0 
 ' HASH %S 
 0

 ' IF ' ELSE ' THEN %S 

 : TEST ' IF , ' ELSE , ' THEN , ; 

 SEE 

 %S TEST %S

 : TEST POSTPONE IF POSTPONE ELSE POSTPONE THEN ; 

 SEE 

 %S TEST %S

 BYE 

%S 

HASH POSTPONE .

%S

HASHED POSTPONE .

%S

BYE

 : HSH HASH DUP . ;

 HSH POSTPONE 

 %S
 
 BYE 

 ' IF  
 
 ' ELSE 
 
 ' THEN 
 
 %S 

 SHOW

 HERE 

 ' IF , 
 
 ' ELSE ,
 
 ' THEN ,
 
 %S 

 DUP @ . CELL + DUP @ . CELL + @ .

 %S


 : TESTE  
        POSTPONE IF 
        POSTPONE ELSE 
        POSTPONE THEN 
        ; IMMEDIATE
 

 SHOW
 
 SEE 

 BYE 

 %S %R  
 
 1 2 3 4 %R 
 DUP %S 
 DROP %S 
 OVER %S 
 DROP %S
 SWAP %S 
 SWAP %S
 ROT %S 
 -ROT %S 
 
 %R  
 >R %S %R 
 >R %S %R 
 >R %S %R 
 R@ . %S %R  
 R> 
 R@ . %S %R 
 R> 
 R@ . %S %R 
 R> 
 R@ . %S %R 

 : DO0 0 DO I 32 + EMIT SPACE LOOP ;

 %S 16 DO0 %S 

 %R 
 
 : DOI 0 DO I . SPACE LOOP ;
 
 %S 16 DOI %S 

 %R 

 : BE0 BEGIN DUP . SPACE 1 - DUP 0 = UNTIL DROP ;   
 
 %S 16 BE0 %S

 %R 
 
 HASH POSTPONE FIND %S . . 

 HASH POSTPONES FIND %S . . 

 %S %R 


