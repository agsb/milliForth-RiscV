 : VOID ; SEE 
 
 : ABORT VOID ; SEE 

 : -1 U@ 0# ; SEE 
 : 0 -1 -1 NAND ; SEE 

 : TRUE -1 ; SEE 
 : FALSE 0 ; SEE 
 
 : 1 -1 -1 + -1 NAND ; SEE 
 : 2 1 1 + ; SEE 
 : 3 2 1 + ; SEE 
 : 4 2 2 + ; SEE 
 : CELL 4 ; SEE 
 
 : SP U@ ; SEE 
 : RP SP CELL + ; SEE 
 
 : HEAP RP CELL + ; SEE 
 : LATEST HEAP CELL + ; SEE 
 : STATE LATEST CELL + ; SEE 

 : PIKE STATE CELL + ;
 : CEIL PIKE CELL + ;

 : SP@ SP @ CELL + ; SEE 
 : RP@ RP @ CELL + ; SEE 
 
 : DUP SP@ @ ; SEE 

 : INVERSE DUP NAND ; SEE 
 : NOT INVERSE ;
 : AND NAND INVERSE ; SEE 

 : NEGATE INVERSE 1 + ;
 : - NEGATE + ; SEE 

 : BRANCH RP@ @ DUP @ + RP@ ! ; SEE 
 : 0BRANCH 0# INVERSE RP@ @ @ CELL - AND RP@ @ + CELL + RP@ ! ; SEE 
 
 : OVER SP@ CELL + @ ; SEE 
 : SWAP OVER OVER SP@ CELL + CELL + CELL + ! SP@ CELL + ! ; SEE 

 : OR INVERSE SWAP INVERSE AND INVERSE ; SEE 
 : NOR OR INVERSE ; SEE 

 : <> - 0# ; SEE 
 : = <> INVERSE ; SEE 
 
 : DROP DUP - + ; SEE 
 : NIP SWAP DROP ; SEE 
 : TUCK SWAP OVER ; SEE 

 : HERE HEAP @ ; SEE 
 : ALLOT HERE + HEAP ! ; SEE 
 : , HERE ! CELL ALLOT ; SEE 
 
 : RECURSE PIKE @ , ;

 : +! SWAP OVER @ + SWAP ! ; SEE 

 : R> RP@ @ RP@ CELL + RP ! RP@ @ SWAP RP@ ! ; SEE 
 : >R RP@ @ SWAP RP@ ! RP@ CELL - RP ! RP@ ! ; SEE 
 : R@ R> R> DUP >R SWAP >R ; SEE 

 : EXECUTE >R ; SEE 
 : COMPILE R> DUP CELL + >R @ , ;
 : STATE? STATE @ ;

 : LIT RP@ @ DUP CELL + RP@ ! @ ; SEE 
 : ['] RP@ @ DUP CELL + RP@ ! @ ; SEE 
 
 : ROT >R SWAP R> SWAP ; SEE 
 : -ROT SWAP >R SWAP R> ; SEE 
 
 : XOR OVER OVER AND -ROT NOR NOR ; SEE 
 : XNOR XOR INVERSE ; SEE 
 
 : 2DUP OVER OVER ; SEE 
 : 2DROP DROP DROP ; SEE 
 : 2SWAP ROT >R ROT R> ;

 : 2@ DUP CELL + @ SWAP @ ;
 : 2! SWAP OVER ! CELL + ! ;
 : 2>R SWAP >R >R ;
 : 2R> R> R> SWAP ;
 : 2R@ R> R> 2DUP >R >R SWAP ;

 : 2* DUP + ; SEE 
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ; SEE 
 : 80H 1 2* 2* 2* 2* 2* 2* 2* ; SEE 
 : ISNEGATIVE 80H 2** 2** 2** ; SEE 
 : IMMEDIATE LATEST @ CELL + DUP @ ISNEGATIVE + SWAP ! ; SEE 
 
 : ] 1 STATE ! ; SEE 
 : [ 0 STATE ! ; IMMEDIATE SEE  

 : LITERAL ['] LIT , , ; IMMEDIATE SEE 
 
 : SP0 LIT [ SP@ , ] ; SEE 
 : RP0 LIT [ RP@ , ] ; SEE 

 : 0= 0# INVERSE ; SEE 
 : 0< ISNEGATIVE AND 0# ; SEE 

 : ISNEGATIVE LIT [ ISNEGATIVE , ] ; SEE 
 
 : BEGIN HERE ; IMMEDIATE SEE  

 : BACK HERE - , ; SEE 

 : AGAIN ['] BRANCH , BACK ; IMMEDIATE SEE  

 : UNTIL ['] 0BRANCH , BACK ; IMMEDIATE SEE  

 : ENDIF HERE OVER - SWAP ! ; SEE 

 : MARK HERE 0 , ;

 : IF ['] 0BRANCH , MARK ; IMMEDIATE SEE  

 : ELSE ['] BRANCH , MARK SWAP ENDIF ; IMMEDIATE SEE  

 : THEN ENDIF ; IMMEDIATE SEE  

 : WHILE ['] 0BRANCH , MARK ; IMMEDIATE SEE  

 : REPEAT SWAP ['] BRANCH , BACK ENDIF ; IMMEDIATE SEE  

 : DO ['] SWAP , HERE ['] >R , ['] >R , ; IMMEDIATE SEE  

 : LOOP 
 ['] R> , ['] LIT , 1 , ['] + , ['] R> , 
 ['] 2DUP , ['] = , ['] 0BRANCH , HERE - , 
 ['] 2DROP , ; IMMEDIATE SEE  

 : I ['] R@ , ; IMMEDIATE SEE  

 : J ['] R> , ['] R> , ['] R@ , 
 ['] SWAP , ['] >R , ['] SWAP , ['] >R , ; IMMEDIATE SEE  

 : LEAVE 
 ['] R> , ['] DROP ,
 ['] R> , ['] DROP ,
 ['] EXIT , ; IMMEDIATE SEE  

 : FOR 0 >R HERE ['] >R , ; IMMEDIATE SEE 

 : NEXT ['] R> , ['] LIT , 1 , ['] - , ['] DUP , 
 ['] 0< , ['] INVERSE , ['] 0BRANCH , HERE - , 
 ['] 2DROP , ; IMMEDIATE SEE 

 : ?DUP DUP IF DUP THEN ; SEE 

 : CHAR LIT [ 1 , ] ;
 : CHARS ;
 
 : CELL LIT [ 4 , ] ; SEE 
 : CELLS DUP + DUP + ; SEE 

 : 0 LIT [ 0 , ] ;
 : 1 LIT [ 1 , ] ;
 : 2 LIT [ 1 1 + , ] ;
 : 4 LIT [ 2 2 + , ] ;
 : 8 LIT [ 4 4 + , ] ; SEE 
 : 16 LIT [ 8 8 + , ] ; SEE 
 : 32 LIT [ 16 16 + , ] ; SEE 
 : 64 LIT [ 32 32 + , ] ; SEE 
 : 128 LIT [ 64 64 + , ] ; SEE 
 : 256 LIT [ 128 128 + , ] ; SEE 
 : 512 LIT [ 256 256 + , ] ; SEE 
 : 1024 LIT [ 512 512 + , ] ; SEE 
 : 2048 LIT [ 1024 1024 + , ] ; SEE 
 : 4096 LIT [ 2048 2048 + , ] ; SEE 
 
 : BL LIT [ 16 16 + , ] ; SEE 
 : QU LIT [ 16 16 + 2 + , ] ; SEE 
 
 : CR 8 2 + EMIT ; SEE 
 : NL 8 4 + 1 + EMIT ; SEE 
 
 : SPACE BL EMIT ; SEE 
 : SPACES 0 DO SPACE LOOP ; SEE 

 : CELL-UP 2 + 1 + 4 0 - AND ;

 : 0> DUP 
 0= IF DROP FALSE EXIT THEN 
 0< IF FALSE EXIT THEN
 TRUE ; SEE 

 : 0fh LIT [ 16 1 - , ] ; SEE 
 : ffh LIT [ 256 1 - , ] ; SEE 

 : C@ @ ffh AND ; SEE 
 : C! DUP @ ffh INVERSE AND ROT ffh AND OR SWAP ! ; SEE 
 : C, HERE C! 1 ALLOT ; SEE 

 : ALIGN 3 + TRUE 3 - AND ; SEE 
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ; SEE 

 : SKIP BEGIN KEY OVER - 0# UNTIL DROP ; SEE 

 : SCAN BEGIN KEY OVER - 0# INVERSE UNTIL DROP ; SEE 

 : \ 8 2 + SCAN ; IMMEDIATE SEE  

 : ( 32 8 + 1 + SCAN ; IMMEDIATE SEE 

 : ." 32 2 + BEGIN KEY OVER OVER - WHILE EMIT REPEAT DROP DROP ; SEE 

 \ comments

 ( more comments )

 ." That's all folks ! "

 ." At least one more ! "


 \ CANONICAL DJB2 HASH

 : DJB2-CTE ( -- 1505 ) LIT [ 1024 DUP DUP + DUP + + 256 + 4 + 1 + , ] ; SEE 

 : DJB2-HSH ( KEY HSH -- HSH2 ) DUP DUP + DUP + DUP + DUP + DUP + + XOR ; SEE 

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
    ; SEE 

 : HASH DJB2-VAL ; SEE 

 
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
    AGAIN ; SEE 

 \ retrieve CFA 
 : ' HASH FIND IF CELL + CELL + ELSE ABORT THEN ; SEE 
 
 \ compile CFA 
 : POSTPONE ' ,  ; IMMEDIATE SEE 
 

\ a entry is  LINK HASH CODE ... CODE EXIT
\ LATEST points to LINK
\ TICK points to CODE

\ where is the hash

 : L>H CELL + ; SEE 

\ where is the code

 : L>C CELL + CELL + ; SEE 

\ where the does changes
 
 : L>D CELL + CELL + CELL + ; SEE 

 \ make a header as :name

 : :NAME HERE LATEST @ , LATEST ! HASH , ; SEE 

 \ make a body

 : :NONAME HERE 1 STATE ! ; SEE 

 \ from eforth, 
 \ leaves a pointer to next cell after second EXIT
 \ first EXIT is reserved for DOES> use 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        ['] EXIT , 
        ['] EXIT , 
  ; SEE 
 
 \ changes the first EXIT to next current compiled dictionary cell

 : DOES> HERE LATEST CELL + CELL + CELL + ! ; IMMEDIATE SEE  

 : VALUE CREATE , DOES> @ ; SEE 
 

 : TO ' CELL + @ 
        STATE @ 
        IF ['] LIT , , ['] ! , \ compiling 
        ELSE ! THEN ; SEE 


 : DEFER :NAME ['] EXIT , ['] EXIT , ; SEE 
 
 : IS ' ! ; SEE 

 \ classics

 : <BUILDS CREATE 0 , ; SEE 

 : VARIABLE CREATE 0 , ; SEE 

 : CONSTANT CREATE , DOES> @ ; SEE 
 
 : BUFFER CREATE ALLOT ; SEE 

 : ARRAY CREATE ALLOT DOES> + @ ; SEE 


 VARIABLE TEST 

 SEE 

 %S 

 TEST @ . 

 SEE 
 
 %S

 16 TEST !

 SEE 

 %S

 TEST @ .

 SEE 


