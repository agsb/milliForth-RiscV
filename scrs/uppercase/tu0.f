 : VOID  ; SEE 

 : ABORT VOID  ; SEE  

 : -1 U@ 0#  ; SEE 
 : 0 -1 -1 NAND  ; SEE 

 : TRUE -1  ; SEE 
 : FALSE 0  ; SEE 
 
 : 1 -1 -1 + -1 NAND  ; SEE 
 : 2 1 1 +  ; SEE 
 : 3 2 1 +  ; SEE 
 : 4 2 2 +  ; SEE 
 : CELL 4  ; SEE 
 
 : SP U@  ; SEE 
 : RP SP CELL +  ; SEE 
 : LATEST RP CELL +  ; SEE 
 : HEAP LATEST CELL +  ; SEE 
 : >IN HEAP CELL +  ; SEE 
 : STATE >IN CELL +  ; SEE 
 
 : \ 0 >IN @ !  ; SEE  \ end-of-line comments

 : HEAD STATE CELL +  ; SEE  \ used in compilation process preserve HERE
 : TAIL HEAD CELL +  ; SEE   \ used in CREATE/DOES preserve common words 

 : SCHS TAIL CELL +  ; SEE  \ start scratch area with 8 cells

 \ pointer relative offsets

 : RP@ RP @ CELL +  ; SEE 
 
 : SP@ SP @ CELL +  ; SEE 
 
 : RP! RP !  ; SEE  \ carefull
 : SP! SP !  ; SEE  \ carefull

 : DUP SP@ @  ; SEE 
 : OVER SP@ CELL + @  ; SEE 
 : SWAP OVER OVER SP@ CELL + CELL + CELL + ! SP@ CELL + !  ; SEE 

 : NOT DUP NAND  ; SEE 
 : AND NAND NOT  ; SEE 
 : OR NOT SWAP NOT AND NOT  ; SEE 
 : NOR OR NOT  ; SEE 

 : - NOT 1 + +  ; SEE 
 : <> - 0#  ; SEE 
 : = <> NOT  ; SEE 
 
 : DROP DUP - +  ; SEE 
 : NIP SWAP DROP  ; SEE 
 : TUCK SWAP OVER  ; SEE 

 : HERE HEAP @  ; SEE 
 : ALLOT HERE + HEAP !  ; SEE 
 : , HERE ! CELL ALLOT  ; SEE 
 
 : +! SWAP OVER @ + SWAP !  ; SEE 

 : >R RP@ @ SWAP RP@ ! RP@ CELL - RP ! RP@ !  ; SEE 
 : R> RP@ @ RP@ CELL + RP ! RP@ @ SWAP RP@ !  ; SEE 
 : R@ R> DUP >R  ; SEE 

 : EXECUTE >R  ; SEE 

 : BRANCH RP@ @ DUP @ + RP@ !  ; SEE 
 : ?BRANCH 0# NOT RP@ @ @ CELL - AND RP@ @ + CELL + RP@ !  ; SEE 
 
 : LIT RP@ @ DUP CELL + RP@ ! @  ; SEE 
 : ['] RP@ @ DUP CELL + RP@ ! @  ; SEE 
 
 : ROT >R SWAP R> SWAP  ; SEE 
 : -ROT SWAP >R SWAP R>  ; SEE 
 
 : 2DUP OVER OVER  ; SEE 
 : 2DROP DROP DROP  ; SEE 
 : XOR 2DUP AND -ROT NOR NOR  ; SEE 
 : XNOR XOR NOT  ; SEE 
 
 : 2* DUP +  ; SEE 
 : 2** 2* 2* 2* 2* 2* 2* 2* 2*  ; SEE 
 : 80H 1 2* 2* 2* 2* 2* 2* 2*  ; SEE 
 : ISNEGATIVE 80H 2** 2** 2**  ; SEE 
 : IMMEDIATE LATEST @ CELL + DUP @ ISNEGATIVE OR SWAP !  ; SEE 
 
 : ] 1 STATE !  ; SEE 
 : [ 0 STATE !  ; IMMEDIATE SEE
 
\ : SP0 LIT [ SP@ ]  ; SEE  
 
\ SP0 .

\ : RP0 LIT [ RP@ ]  ; SEE  

\ RP0 .

 : ISNEGATIVE LIT [ ISNEGATIVE , ]  ; SEE 
 
 : IF ['] ?BRANCH , HERE 0 ,  ; IMMEDIATE SEE
 : THEN DUP HERE SWAP - SWAP !  ; IMMEDIATE SEE
 : ELSE ['] BRANCH , HERE 0 , SWAP DUP 
   HERE SWAP - SWAP !  ; IMMEDIATE SEE

 : BEGIN HERE  ; IMMEDIATE SEE
 : AGAIN ['] BRANCH , HERE - ,  ; IMMEDIATE SEE
 : UNTIL ['] ?BRANCH , HERE - ,  ; IMMEDIATE SEE
 : WHILE ['] ?BRANCH , HERE 0 ,  ; IMMEDIATE SEE
 : REPEAT SWAP ['] BRANCH , HERE - , 
   DUP HERE SWAP - SWAP !  ; IMMEDIATE SEE
 
 \ limit first DO --- LOOP

 : DO HERE ['] >R , ['] >R ,  ; IMMEDIATE SEE

 : LOOP ['] R> , ['] R> , 
        ['] LIT , 1 , ['] + , 
        ['] 2DUP , ['] = , ['] ?BRANCH , 
        HERE - , 
        ['] 2DROP ,  ; IMMEDIATE SEE

 : I ['] R> , ['] R> , 
        ['] DUP , ['] >R , 
        ['] SWAP , ['] >R ,  ; IMMEDIATE SEE

 : J ['] R> , ['] R> , 
     ['] R> , ['] R> , 
     ['] DUP , ['] >R ,
     ['] SWAP , ['] >R ,
     ['] SWAP , ['] >R ,
     ['] SWAP , ['] >R ,
      ; IMMEDIATE SEE

 : LEAVE ['] R> , ['] DROP ,
         ['] R> , ['] DROP ,
         ['] EXIT ,  ; IMMEDIATE SEE

 : ?DUP DUP IF DUP THEN  ; SEE 

 : CELL LIT [ 4 , ]  ; SEE 
 : CELLS DUP IF 0 SWAP 0 DO CELL + LOOP THEN  ; SEE 

 : 8 LIT [ 4 4 + , ]  ; SEE 
 : 16 LIT [ 8 8 + , ]  ; SEE 
 : 32 LIT [ 16 16 + , ]  ; SEE 
 
 : BL LIT [ 16 16 + , ]  ; SEE 
 : CR LIT [ 8 2 + , ] EMIT  ; SEE 
 : NL LIT [ 8 4 + 1 + , ] EMIT  ; SEE 
 : SPACE BL EMIT  ; SEE 
 : SPACES 0 DO SPACE LOOP  ; SEE 

 : 0= 0# NOT  ; SEE 
 : 0< ISNEGATIVE AND 0#  ; SEE 
 : 0> DUP 
   0= IF DROP FALSE EXIT THEN 
   0< IF FALSE EXIT THEN
   TRUE  ; SEE 

 : 0fh LIT [ 16 1 - , ]  ; SEE 
 : ffh LIT [ 0fh 2* 2* 2* 2* 0fh OR , ]  ; SEE 

 : C@ @ ffh AND  ; SEE 
 : C! DUP @ ffh NOT AND ROT ffh AND OR SWAP !  ; SEE 
 : C, HERE C! 1 ALLOT  ; SEE 

 : ALIGN 3 + TRUE 3 - AND  ; SEE  \ 32-bit align for strings
 
 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP  ; SEE 
 : IN> >IN @ C@ >IN @ 1 + >IN !  ; SEE 

 : PARSE IN> DROP 
   >IN @ SWAP 0 
   BEGIN OVER IN> <> WHILE 1 + REPEAT 
   SWAP BL = IF >IN @ 1 - >IN ! THEN  ; SEE 

 : WORD IN> DROP 
   BEGIN DUP IN> <> UNTIL 
   >IN @ 2 - >IN ! PARSE  ; SEE 
 : [CHAR] ['] LIT , BL WORD DROP C@ ,  ; IMMEDIATE SEE
 
 : ( [CHAR] ) PARSE DROP DROP  ; IMMEDIATE SEE
 : ." [CHAR] " PARSE TYPE  ; IMMEDIATE SEE

 \ TEST MINIMAL

 ." HELLO WORLD " CR
 
 ." THAT'S ALL FOLKS !" CR

