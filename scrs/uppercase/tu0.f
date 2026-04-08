 : VOID ; 
  
 : ABORT VOID ;  

 : -1 U@ 0# ; 
 : 0 -1 -1 NAND ; 

 : TRUE -1 ; 
 : FALSE 0 ; 
 
 : 1 -1 -1 + -1 NAND ; 
 : 2 1 1 + ; 
 : 3 2 1 + ; 
 : 4 2 2 + ; 
 : CELL 4 ; 
 
 : SP U@ ; 
 : RP SP CELL + ; 
 
 : LATEST RP CELL + ; 
 : HEAP LATEST CELL + ; 
 : STATE HEAP CELL + ; 
 : BASE STATE CELL + ; 

 : >IN BASE CELL + ; 
 : TIB >IN CELL + ; 

 : BEATS TIB CELL + ; 
 : TICKS BEATS CELL + ;  
 
 : HEAD TICKS CELL + ;   
 : TAIL HEAD CELL + ;  

 : VARS TAIL CELL + ; 

 : CLOCKS BEATS @ TICKS @ ;

 : SP@ SP @ CELL + ; 
 : RP@ RP @ CELL + ; 
 
 : SP! SP ! ;  
 : RP! RP ! ; 

 : DUP SP@ @ ; 
 : NOT DUP NAND ; 
 : AND NAND NOT ; 
 : - NOT 1 + + ; 

 : BRANCH RP@ @ DUP @ + RP@ ! ; 
 : ?BRANCH 0# NOT RP@ @ @ CELL - AND RP@ @ + CELL + RP@ ! ; 
 
 : OVER SP@ CELL + @ ; 
 : SWAP OVER OVER SP@ CELL + CELL + CELL + ! SP@ CELL + ! ; 

 : OR NOT SWAP NOT AND NOT ; 
 : NOR OR NOT ; 

 : <> - 0# ; 
 : = <> NOT ; 
 
 : DROP DUP - + ; 
 : NIP SWAP DROP ; 
 : TUCK SWAP OVER ; 

 : HERE HEAP @ ; 
 : ALLOT HERE + HEAP ! ; 
 : , HERE ! CELL ALLOT ; 
 
 : +! SWAP OVER @ + SWAP ! ; 

 : >R RP@ @ SWAP RP@ ! RP@ CELL - RP ! RP@ ! ; 
 : R> RP@ @ RP@ CELL + RP ! RP@ @ SWAP RP@ ! ; 
 : R@ R> DUP >R ; 

 : EXECUTE >R ; 
 : COMPILE R> DUP @ , CELL + >R ;

 : LIT RP@ @ DUP CELL + RP@ ! @ ; 
 : ['] RP@ @ DUP CELL + RP@ ! @ ; 
 
 : ROT >R SWAP R> SWAP ; 
 : -ROT SWAP >R SWAP R> ; 
 
 : 2DUP OVER OVER ; 
 : 2DROP DROP DROP ; 
 : XOR 2DUP AND -ROT NOR NOR ; 
 : XNOR XOR NOT ; 
 
 : 2* DUP + ; 
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ; 
 : 80H 1 2* 2* 2* 2* 2* 2* 2* ; 
 : ISNEGATIVE 80H 2** 2** 2** ; 
 : IMMEDIATE LATEST @ CELL + DUP @ ISNEGATIVE OR SWAP ! ; 
 
 : ] 1 STATE ! ; 
 : [ 0 STATE ! ; IMMEDIATE 
 
 : SP0 LIT [ SP@ , ] ;  
 
 : RP0 LIT [ RP@ , ] ; 

 : ISNEGATIVE LIT [ ISNEGATIVE , ] ; 
 
 : IF ['] ?BRANCH , HERE 0 , ; IMMEDIATE 
 : THEN DUP HERE SWAP - SWAP ! ; IMMEDIATE 
 : ELSE ['] BRANCH , HERE 0 , SWAP 
        DUP HERE SWAP - SWAP ! ; IMMEDIATE 

 : BEGIN HERE ; IMMEDIATE 
 : AGAIN ['] BRANCH , HERE - , ; IMMEDIATE 
 : UNTIL ['] ?BRANCH , HERE - , ; IMMEDIATE 

 : WHILE ['] ?BRANCH , HERE 0 , ; IMMEDIATE 
 : REPEAT SWAP ['] BRANCH , HERE - , 
        DUP HERE SWAP - SWAP ! ; IMMEDIATE 
 
 : DO HERE ['] >R , ['] >R , ; IMMEDIATE 

 : LOOP ['] R> , ['] R> , 
    ['] LIT , 1 , ['] + , 
    ['] 2DUP , ['] = , ['] ?BRANCH , 
    HERE - , 
    ['] 2DROP , ; IMMEDIATE 

 : I ['] R> , ['] R> , 
    ['] DUP , ['] >R , 
    ['] SWAP , ['] >R , ; IMMEDIATE 

 : LEAVE ['] R> , ['] DROP ,
     ['] R> , ['] DROP ,
     ['] EXIT , ; IMMEDIATE 

 : ?DUP DUP IF DUP THEN ; 

 : CELL LIT [ 4 , ] ; 
 : CELLS DUP IF 0 SWAP 0 DO CELL + LOOP THEN ; 

 : 1 LIT [ 1 + , ] ;
 : 2 LIT [ 2 + , ] ;
 : 4 LIT [ 4 + , ] ;
 : 8 LIT [ 4 4 + , ] ; 
 : 16 LIT [ 8 8 + , ] ; 
 : 32 LIT [ 16 16 + , ] ; 
 : 64 LIT [ 32 32 + , ] ; 
 
 : BL LIT [ 16 16 + , ] ; 
 : CR LIT [ 8 2 + , ] EMIT ; 
 : NL LIT [ 8 4 + 1 + , ] EMIT ; 
 : SPACE BL EMIT ; 
 : SPACES 0 DO SPACE LOOP ; 

 : 0= 0# NOT ; 
 : 0< ISNEGATIVE AND 0# ; 
 : 0> DUP 
        0= IF DROP FALSE EXIT THEN 
        0< IF FALSE EXIT THEN
        TRUE ; 

 : 0fh LIT [ 16 1 - , ] ; 
 : ffh LIT [ 0fh 2* 2* 2* 2* 0fh OR , ] ; 

 : C@ @ ffh AND ; 
 : C! DUP @ ffh NOT AND ROT ffh AND OR SWAP ! ; 
 : C, HERE C! 1 ALLOT ; 

 : ALIGN 3 + TRUE 3 - AND ; 
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ; 

 : SKIP BEGIN KEY OVER - 0# UNTIL DROP ; 

 : SCAN BEGIN KEY OVER - 0# NOT UNTIL DROP ; 

 : \ 8 2 + SCAN ; IMMEDIATE 

 : ( 32 8 + 1 + SCAN ; IMMEDIATE

 : ." 32 2 + BEGIN KEY OVER OVER - WHILE EMIT REPEAT DROP ;

 : COPY ( c a -- a+n+1 ) \ better less than 255 characters
        >R
        BEGIN
                KEY OVER OVER - 
        WHILE
                R> DUP 1 + >R C!
        REPEAT
        DROP R> ;

 : SNAP
        HERE DUP 32 2 + COPY
        OVER OVER - 
        SWAP C!
        SWAP DROP
        SWAP !
        ;

 : SEEN HERE DUP 0 , 32 2 + 
        BEGIN KEY OVER OVER - WHILE , REPEAT HERE OVER - ! ;

 : xxxC" STATE @ IF 
        ELSE
        THEN ; 

 : xxxS" STATE @ IF 
        ELSE
        THEN ; 

 : xxxCOPY BEGIN KEY OVER - 0# NOT UNTIL DROP ; 
 
 : xxxTYPEZ BEGIN DUP 1 + SWAP C@ DUP IF EMIT THEN NOT UNTIL DROP ; 

 : xxxCOUNT 0 BEGIN OVER DUP C@ UNTIL DROP ;  

 \ comments
 ( more comments )
 ." That's all folks ! "


