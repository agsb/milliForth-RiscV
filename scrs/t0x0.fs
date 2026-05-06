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
 : STATE LATEST CELL + ; 

 : FAUX STATE CELL + ;
 : CEIL FAUX CELL + ;

 : SP@ SP @ CELL + ; 
 : RP@ RP @ CELL + ; 
 
 : DUP SP@ @ ; 

 : NOT DUP NAND ; 
 : AND NAND NOT ; 

 : NEGATE NOT 1 + ;
 : - NEGATE + ; 

 : BRANCH RP@ @ DUP @ + RP@ ! ; 
 : 0BRANCH 0# NOT RP@ @ @ CELL - AND RP@ @ + CELL + RP@ ! ; 
 
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
 
 : RECURSE FAUX @ , ;

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
 : XNOR XOR NOT ; 
 
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
 
 : SP0 LIT [ SP@ , ] ; SEE SP0  
 : RP0 LIT [ RP@ , ] ; SEE RP0 

 : 0= 0# NOT ; 
 : 0< ISNEGATIVE AND 0# ; 

 : ISNEGATIVE LIT [ ISNEGATIVE , ] ; 
 
 : BEGIN HERE ; IMMEDIATE  

 : BACK HERE - , ; 

 : AGAIN ['] BRANCH , BACK ; IMMEDIATE  

 : UNTIL ['] 0BRANCH , BACK ; IMMEDIATE  

 : ENDIF HERE OVER - SWAP ! ; 

 : MARK HERE 0 , ;

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

 : J ['] R> , ['] R> , ['] R@ , 
 ['] SWAP , ['] >R , ['] SWAP , ['] >R , ; IMMEDIATE  

 : LEAVE 
 ['] R> , ['] DROP ,
 ['] R> , ['] DROP ,
 ['] EXIT , ; IMMEDIATE  

 : FOR 0 >R HERE ['] >R , ; IMMEDIATE 

 : NEXT ['] R> , ['] LIT , 1 , ['] - , ['] DUP , 
 ['] 0< , ['] NOT , ['] 0BRANCH , HERE - , 
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
 
 : CR 8 2 + EMIT ; 
 : NL 8 4 + 1 + EMIT ; 
 : SPACE BL EMIT ; 
 : SPACES 0 DO SPACE LOOP ; 

 : 0> DUP 
 0= IF DROP FALSE EXIT THEN 
 0< IF FALSE EXIT THEN
 TRUE ; 

 : 0fh LIT [ 16 1 - , ] ; 
 : ffh LIT [ 0fh 2* 2* 2* 2* 0fh OR , ] ; 
 : FFh LIT [ 128 128 + 1 - , ] ;

 : C@ @ ffh AND ; 
 : C! DUP @ ffh NOT AND ROT ffh AND OR SWAP ! ; 
 : C, HERE C! 1 ALLOT ; 

 : ALIGN 3 + TRUE 3 - AND ; 
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ; 

 : SKIP BEGIN KEY OVER - 0# UNTIL DROP ; 

 : SCAN BEGIN KEY OVER - 0# NOT UNTIL DROP ; 

 : \ 8 2 + SCAN ; IMMEDIATE  

 : ( 32 8 + 1 + SCAN ; IMMEDIATE 

 : ." 32 2 + BEGIN KEY OVER OVER - WHILE EMIT REPEAT DROP DROP ; 

 \ comments

 ( more comments )

 ." That's all folks ! "

 ." At least one more ! "

