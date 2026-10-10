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
 : HEAP RP CELL + ; 
 : LATEST HEAP CELL + ; 
 : PIKE LATEST CELL + ; 
 : STATE PIKE CELL + ; 
 : BASE STATE CELL + ; 

 : SP@ SP @ CELL + ; 
 : RP@ RP @ CELL + ; 
 
 : DUP SP@ @ ; 

 : INVERSE DUP NAND ; 
 : NOT INVERSE ;
 : AND NAND INVERSE ; 

 : NEGATE INVERSE 1 + ;
 : - NEGATE + ; 

 : BRANCH RP@ @ DUP @ + RP@ ! ; 
 : 0BRANCH 0# INVERSE RP@ @ @ CELL - AND RP@ @ + CELL + RP@ ! ; 
 
 : OVER SP@ CELL + @ ; 
 : SWAP OVER OVER SP@ CELL + CELL + CELL + ! SP@ CELL + ! ; 

 : OR INVERSE SWAP INVERSE AND INVERSE ; 
 : NOR OR INVERSE ; 

 : <> - 0# ; 
 : = <> INVERSE ; 
 
 : DROP DUP - + ; 
 : NIP SWAP DROP ; 
 : TUCK SWAP OVER ; 

 : HERE HEAP @ ; 
 : ALLOT HERE + HEAP ! ; 
 : , HERE ! CELL ALLOT ; 
 
 : RECURSE PIKE @ , ;

 : +! SWAP OVER @ + SWAP ! ; 

 : R> RP@ @ RP@ CELL + RP ! RP@ @ SWAP RP@ ! ; 
 : >R RP@ @ SWAP RP@ ! RP@ CELL - RP ! RP@ ! ; 
 : R@ R> R> DUP >R SWAP >R ; 

 : EXECUTE >R ; 
 : COMPILE R> DUP CELL + >R @ , ;
 : STATE? STATE @ ;

 : LIT RP@ @ DUP CELL + RP@ ! @ ; 
 : ['] RP@ @ DUP CELL + RP@ ! @ ; 
 
 : ROT >R SWAP R> SWAP ; 
 : -ROT SWAP >R SWAP R> ; 
 
 : XOR OVER OVER AND -ROT NOR NOR ; 
 : XNOR XOR INVERSE ; 
 
 : 2DUP OVER OVER ; 
 : 2DROP DROP DROP ; 
 : 2SWAP ROT >R ROT R> ;

 : 2@ DUP CELL + @ SWAP @ ;
 : 2! SWAP OVER ! CELL + ! ;
 : 2>R SWAP >R >R ;
 : 2R> R> R> SWAP ;
 : 2R@ R> R> 2DUP >R >R SWAP ;

 : 2* DUP + ; 
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ; 
 : 80H 1 2* 2* 2* 2* 2* 2* 2* ; 
 : ISNEGATIVE 80H 2** 2** 2** ; 
 : IMMEDIATE LATEST @ CELL + DUP @ ISNEGATIVE + SWAP ! ; 
 
 : ] 1 STATE ! ; 
 : [ 0 STATE ! ; IMMEDIATE  

 : LITERAL ['] LIT , , ; IMMEDIATE 
 
 : SP0 LIT [ SP@ , ] ; 
 : RP0 LIT [ RP@ , ] ; 

 : 0= 0# INVERSE ; 
 : 0< ISNEGATIVE AND 0# ; 

 : ISNEGATIVE LIT [ ISNEGATIVE , ] ; 
 
 : BEGIN HERE ; IMMEDIATE  

 : BACK HERE - , ; 

 : AGAIN ['] BRANCH , BACK ; IMMEDIATE  

 : UNTIL ['] 0BRANCH , BACK ; IMMEDIATE  

 : ENDIF HERE OVER - SWAP ! ; 

 : MARK HERE 0 , ;

 : AFT HERE ; IMMEDIATE

 : IF ['] 0BRANCH , MARK ; IMMEDIATE  

 : ELSE ['] BRANCH , MARK SWAP ENDIF ; IMMEDIATE  

 : THEN ENDIF ; IMMEDIATE  

 : WHILE ['] 0BRANCH , MARK ; IMMEDIATE  

 : REPEAT SWAP ['] BRANCH , BACK ENDIF ; IMMEDIATE  

 : DO ['] SWAP , HERE ['] >R , ['] >R , ; IMMEDIATE  

 : LOOP 
    ['] R> , ['] LIT , 1 , ['] + , ['] R> , 
    ['] 2DUP , ['] = , ['] 0BRANCH , HERE - , 
    ['] 2DROP , ; IMMEDIATE  

 : I ['] R@ , ; IMMEDIATE  

 : J 
   ['] R> , ['] R> , ['] R@ , 
   ['] SWAP , ['] >R , ['] SWAP , ['] >R , ; IMMEDIATE  

 : LEAVE 
   ['] R> , ['] DROP ,
   ['] R> , ['] DROP ,
   ['] EXIT , ; IMMEDIATE  

 : FOR 0 >R HERE ['] >R , ; IMMEDIATE 

 : NEXT 
   ['] R> , ['] LIT , 1 , ['] - , ['] DUP , 
   ['] 0< , ['] INVERSE , ['] 0BRANCH , HERE - , 
   ['] 2DROP , ; IMMEDIATE 

 : ?DUP DUP IF DUP THEN ; 

 : CHAR LIT [ 1 , ] ;
 : CHARS ;
 
 : CELL LIT [ 4 , ] ; 
 : CELLS DUP + DUP + ; 

 : 0 LIT [ 0 , ] ;
 : 1 LIT [ 1 , ] ;
 : 2 LIT [ 1 1 + , ] ;
 : 4 LIT [ 2 2 + , ] ;
 : 8 LIT [ 4 4 + , ] ; 
 : 16 LIT [ 8 8 + , ] ; 
 : 32 LIT [ 16 16 + , ] ; 
 : 64 LIT [ 32 32 + , ] ; 
 : 128 LIT [ 64 64 + , ] ; 
 : 256 LIT [ 128 128 + , ] ; 
 : 512 LIT [ 256 256 + , ] ; 
 : 1024 LIT [ 512 512 + , ] ; 
 : 2048 LIT [ 1024 1024 + , ] ; 
 : 4096 LIT [ 2048 2048 + , ] ; 
 
 : BL LIT [ 16 16 + , ] ; 
 : QU LIT [ 16 16 + 2 + , ] ; 
 : BB LIT [ 64 32 + 4 - ] ;

 : CR 8 2 + EMIT ; 
 : NL 8 4 + 1 + EMIT ; 

 : SPACE BL EMIT ; 

 : SPACES 0 DO SPACE LOOP ; 

 : 0> 
    DUP 
    0< IF DROP FALSE EXIT THEN
    0= IF FALSE EXIT THEN 
    TRUE ; 

 : 0fh LIT [ 16 1 - , ] ; 
 : ffh LIT [ 256 1 - , ] ; 

 : C@ @ ffh AND ; 
 : C! DUP @ ffh INVERSE AND ROT ffh AND OR SWAP ! ; 
 : C, HERE C! 1 ALLOT ; 

 : ALIGN 2 + 1 + 4 0 - AND ; 
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ; 

 : SKIP BEGIN KEY OVER - 0# UNTIL DROP ; 

 : SCAN BEGIN KEY OVER - 0# INVERSE UNTIL DROP ; 

 : \ 8 2 + SCAN ; IMMEDIATE  

 : ( 32 8 + 1 + SCAN ; IMMEDIATE 

 : ." QU BEGIN KEY OVER OVER - WHILE EMIT REPEAT DROP DROP ; 

 \ test end-of-line comments

 ( test multi-lines comments )

 ." That's all folks ! " 

 ." At least one more ! " 

 \ CANONICAL DJB2 HASH

 : DJB2-CTE ( -- 1505 ) LIT [ 1024 DUP DUP + DUP + + 256 + 4 + 1 + , ] ; 

 : DJB2-HSH ( KEY HSH -- HSH2 ) DUP DUP + DUP + DUP + DUP + DUP + + XOR ; 

 : DJB2-VAL 
    BL BEGIN KEY OVER OVER = NOT UNTIL 
    DJB2-CTE >R
    BEGIN 
    R> DJB2-HSH >R
        KEY OVER OVER = 
        IF TRUE ELSE FALSE THEN
    UNTIL
    DROP DROP 
    ( MASK HIGH BIT ) 
    ISNEGATIVE INVERSE R> AND 
    ; 

 : HASH DJB2-VAL ; 

 \ find a word by hash
 : FIND ( caddr -- caddr 0 \ not found | caddr1 1 \ if immediate | caddr1 -1 \ if not immediate )
    LATEST @ 
    BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
        = IF SWAP DROP 
            DUP CELL + @
            ISNEGATIVE AND
            0 = IF -1 ELSE 1 THEN EXIT 
        THEN
        @ DUP 0 
        = IF SWAP DROP FALSE EXIT THEN
    AGAIN ; 

 \ retrieve CFA 
 : ' HASH FIND IF CELL + CELL + ELSE ABORT THEN ; 
 
 \ compile CFA 
 : POSTPONE ' ,  ; IMMEDIATE 

 \ a entry is  LINK HASH CODE ... CODE EXIT

 \ where is the hash

 : L>H CELL + ; 

 \ where is the code

 : L>C CELL + CELL + ; 

 \ make a header

 : :NAME HERE LATEST @ , LATEST ! HASH , ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ; 

 \ easy create
 \ leaves a pointer to next cell after second EXIT
 \ first EXIT is reserved for DOES> use 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        ['] EXIT , 
        ['] EXIT , 
      ; 
 
 \ easy does, changes the first EXIT to next current compiled dictionary cell

 : DOES> R> LATEST @ CELL + CELL + CELL + CELL + ! ;  

 \ classics

 : <BUILDS CREATE ; 

 : VARIABLE CREATE 0 , ; 

 : CONSTANT CREATE , DOES> @ ; 
 
 : BUFFER CREATE ALLOT ; 

 : ARRAY CREATE ALLOT DOES> + @ ; 

 \ extras 

 : VALUE CONSTANT ; 

 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , \ compiling 
        ELSE ! THEN ; 

 \ easy defer, first EXIT is replaced by IS

 : DEFER :NAME ['] EXIT , ['] EXIT , ; 
 
 \ easy is, changes the first EXIT to a address in TOS

 : IS ' ! ; 

