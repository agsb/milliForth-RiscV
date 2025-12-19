 : CELL 4 ;
 
 : SP U@ ;
 : RP SP CELL + ;
 : LATEST RP CELL + ;
 : HEAP LATEST CELL + ;
 : >IN HEAP CELL + ;
 : STATE >IN CELL + ;
 
 : \ 0 >IN @ ! ; \ end-of-line comments

 : HEAD STATE CELL + ;
 : TAIL HEAD CELL + ;

 : SCHS TAIL CELL + ; \ start scratch area with 8 cells

 \ pointer relative offsets

 : RP@ RP @ CELL + ;
 
 : SP@ SP @ CELL + ;
 
 : RP! RP ! ; \ carefull
 : SP! SP ! ; \ carefull

 : DUP SP@ @ ;
 : OVER SP@ CELL + @ ;
 : SWAP OVER OVER SP@ CELL + CELL + CELL + ! SP@ CELL + ! ;

 : NOT DUP NAND ;
 : AND NAND NOT ;
 : OR NOT SWAP NOT AND NOT ;
 : NOR OR NOT ;

 : - NOT 1 + + ;
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

 : BRANCH RP@ @ DUP @ + RP@ ! ;
 : ?BRANCH 0# NOT RP@ @ @ CELL - AND RP@ @ + CELL + RP@ ! ;
 
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
 
 : ISNEGATIVE LIT [ ISNEGATIVE , ] ;
 
 : IF ['] ?BRANCH , HERE 0 , ; IMMEDIATE
 : THEN DUP HERE SWAP - SWAP ! ; IMMEDIATE
 : ELSE ['] BRANCH , HERE 0 , SWAP DUP 
   HERE SWAP - SWAP ! ; IMMEDIATE

 : BEGIN HERE ; IMMEDIATE
 : AGAIN ['] BRANCH , HERE - , ; IMMEDIATE
 : UNTIL ['] ?BRANCH , HERE - , ; IMMEDIATE
 : WHILE ['] ?BRANCH , HERE 0 , ; IMMEDIATE
 : REPEAT SWAP ['] BRANCH , HERE - , 
   DUP HERE SWAP - SWAP ! ; IMMEDIATE
 
 \ limit first DO ---
 : DO HERE ['] >R , ['] >R , ; IMMEDIATE

 : LOOP ['] R> , ['] R> , 
        ['] LIT , 1 , ['] + , 
        ['] 2DUP , ['] = , ['] ?BRANCH , 
        HERE - , 
        ['] 2DROP , ; IMMEDIATE

 : I ['] R> , ['] R> , 
        ['] DUP , ['] >R , 
        ['] SWAP , ['] >R , ; IMMEDIATE

 : J ['] R> , ['] R> , 
     ['] R> , ['] R> , 
     ['] DUP , ['] >R ,
     ['] SWAP , ['] >R ,
     ['] SWAP , ['] >R ,
     ['] SWAP , ['] >R ,
     ; IMMEDIATE

 : LEAVE ['] R> , ['] DROP ,
         ['] R> , ['] DROP ,
         ['] EXIT , ; IMMEDIATE

 : ?DUP DUP IF DUP THEN ;

 : CELL LIT [ 4 , ] ;
 : CELLS DUP IF 0 SWAP 0 DO CELL + LOOP THEN ;

 : 8 LIT [ 4 4 + , ] ;
 : 16 LIT [ 8 8 + , ] ;
 : 32 LIT [ 16 16 + , ] ;
 
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

 : ALIGN 3 + TRUE 3 - AND ; \ 32-bit align for strings
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ;
 : IN> >IN @ C@ >IN @ 1 + >IN ! ;

 : PARSE IN> DROP 
   >IN @ SWAP 0 
   BEGIN OVER IN> <> WHILE 1 + REPEAT 
   SWAP BL = IF >IN @ 1 - >IN ! THEN ;

 : WORD IN> DROP 
   BEGIN DUP IN> <> UNTIL 
   >IN @ 2 - >IN ! PARSE ;
 : [CHAR] ['] LIT , BL WORD DROP C@ , ; IMMEDIATE
 
 : ( [CHAR] ) PARSE DROP DROP ; IMMEDIATE
 : ." [CHAR] " PARSE TYPE ; IMMEDIATE

 ." HELLO WORLD " CR
 
 ." THAT'S ALL FOLKS !" CR

 : ," 0 DO DUP C@ , 1 + LOOP DROP ;

 : COMPILES 
        ['] LIT ,
        HERE >R
        0 ,
        ['] LIT ,
        DUP ,
        ['] TYPE ,
        ['] EXIT ,
        HERE R> !
        ,S 0 ,
        ;

 : S" [CHAR] " PARSE COMPILES ; IMMEDIATE

