 : VOID ;

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
 : >IN HEAP CELL + ;
 : STATE >IN CELL + ;
 
 : \ 0 >IN @ ! ;

 \ SP . RP . LATEST . HEAP . >IN . STATE .

 \ pointer relative offsets

 : RP@ RP @ CELL + ;
 : SP@ SP @ CELL + ;
 
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
 : ISIMMEDIATE 80H 2** 2** 2** ;
 : IMMEDIATE LATEST @ CELL + DUP @ ISIMMEDIATE OR SWAP ! ;
 
 : ] 1 STATE ! ;
 : [ 0 STATE ! ; IMMEDIATE
 : POSTPONE -1 STATE ! ; IMMEDIATE
 
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
 
 : DO HERE ['] >R , ['] >R , ; IMMEDIATE
 : LOOP ['] R> , ['] R> , ['] LIT , 1 , ['] + , 
   ['] 2DUP , ['] = , ['] ?BRANCH , 
   HERE - , ['] 2DROP , ; IMMEDIATE
 
 : CELL LIT [ 4 , ] ;
 : 8 LIT [ 4 4 + , ] ;
 : 16 LIT [ 8 8 + , ] ;
 
 : BL LIT [ 16 16 + , ] ;
 : CR LIT [ 8 2 + , ] EMIT ;
 : NL LIT [ 8 4 + 1 + , ] EMIT ;
 : SPACE BL EMIT ;

 : 0= 0# NOT ;
 : 0< ISIMMEDIATE AND 0# ;
 : 0> DUP 
   0= IF DROP FALSE EXIT THEN 
   0< IF FALSE EXIT THEN
   TRUE ;

 : ffh LIT [ 16 1 - 2* 2* 2* 2* 16 1 - OR , ] ;
 : C@ @ ffh AND ;
 : C! DUP @ ffh NOT AND ROT ffh AND OR SWAP ! ;
 : C, HERE C! 1 ALLOT ;

 : ALIGN 4 + TRUE 3 - AND ; / 32-bit align for strings
 
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

