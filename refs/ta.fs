
 \ this file is still a stub 
 \ for compilation 
 
 \ make a header

 : :NAME HERE : 0 STATE ! ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ; 

 : LINK>HASH CELL + ; 

 : LINK>BODY CELL + CELL + ; 

 : HASH HERE :NAME SWAP HEAP ! CELL + @ ; 

 : FIND LATEST @ BEGIN
    OVER OVER CELL + @
    ISNEGATIVE 1 - AND
    = IF SWAP DROP TRUE EXIT THEN
    @ DUP 0 
    = IF SWAP DROP FALSE EXIT THEN
    AGAIN ; 
 
 : ' HASH FIND IF CELL + CELL + THEN ; 

 : POSTPONE ' , ; IMMEDIATE 

 \ crude pointer for CREATE DOES>

 : BODY ['] LIT , HERE CELL + , 0 , ;

 \ from eforth, first EXIT is reserved for DOES> 

 : CREATE :NAME 
        ['] LIT , 
        HERE CELL + CELL + CELL + , 
        HERE BODY ! 
        ['] EXIT , 
        ['] EXIT , 
        LATEST ! ; 
 
 : DOES> R> BODY @ ! ; 

 : <BUILDS CREATE 0 , ; 

 : VARIABLE CREATE CELL ALLOT ; 

 : CONSTANT CREATE , DOES> @ ; 
 
 : BUFFER CREATE ALLOT ; 

 : ARRAY CREATE ALLOT DOES> + @ ; 

 : VALUE CREATE , DOES> @ ; 
 
 : TO ' CELL + @ 
        STATE @ 
        IF ' LIT , , ' ! , 
        ELSE ! 
        THEN ; 

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
	THEN 0 DO DUP HERE SWAP - SWAP ! LOOP ; IMMEDIATE 
 

 \ this file is still a stub 

 VARIABLE TAPE_HEAD

 VARIABLE LOOP_DEPTH
 
 VARIABLE PARSE_INDEX
 
 
 : RUNBF 0 PARSE_INDEX ! 
   BEGIN PARSE_INDEX @ C@ 
   DUP DUP DUP DUP DUP DUP DUP 
   [CHAR] < = IF TAPE_HEAD @ 4 - TAPE_HEAD ! THEN 
   [CHAR] > = IF TAPE_HEAD @ 4 + TAPE_HEAD ! THEN 
   [CHAR] - = IF TAPE_HEAD @ @ 1 - TAPE_HEAD @ ! THEN 
   [CHAR] + = IF TAPE_HEAD @ @ 1 + TAPE_HEAD @ ! THEN 
   [CHAR] . = IF TAPE_HEAD @ @ EMIT THEN 
   [CHAR] , = IF KEY TAPE_HEAD @ ! THEN 
   
   [CHAR] [ = TAPE_HEAD @ @ 0 = AND IF 1 LOOP_DEPTH ! 
   BEGIN PARSE_INDEX @ 1 + PARSE_INDEX ! PARSE_INDEX @ C@ DUP 
   [CHAR] [ = IF LOOP_DEPTH @ 1 + LOOP_DEPTH ! THEN 
   [CHAR] ] = IF LOOP_DEPTH @ 1 - LOOP_DEPTH ! THEN 
   LOOP_DEPTH @ 0 = UNTIL THEN 
 
   [CHAR] ] = TAPE_HEAD @ @ 0 <> AND IF 1 LOOP_DEPTH ! 
   BEGIN PARSE_INDEX @ 1 - PARSE_INDEX ! PARSE_INDEX @ C@ DUP 
   [CHAR] [ = IF LOOP_DEPTH @ 1 - LOOP_DEPTH ! THEN 
   [CHAR] ] = IF LOOP_DEPTH @ 1 + LOOP_DEPTH ! THEN 
   LOOP_DEPTH @ 0 = UNTIL THEN 
   
   PARSE_INDEX @ 1 + PARSE_INDEX ! 
   
   DUP PARSE_INDEX @ = UNTIL DROP ;

 : 64 LIT [ 16 16 + 16 + 16 + , ] ;
 
 : BF( [CHAR] ) PARSE RUNBF ; IMMEDIATE
 
 HERE 64 + 64 + TAPE_HEAD !
 
 BF( >++++++++[<+++++++++>-] <.>++++[<+++++++>-] <+.+++++++..+++.>>++++++[<+++++++>-] <++.------------.>++++++[<+++++++++>-] <+.<.+++.------.--------.>>>++++[<++++++++>-] <+. )


 \ this file is still a stub 

 \ ( LOCATORS, BILL RAGSDALE, FIG_FORTH MEET 26/09/2025 )
 \ ( LINK_LIST, SELECTOR_HASH, PAYLOAD_WHEREVER )

 \ ( VARIABLE MYLIST 0 MYLIST ! )
 \ ( MYLIST LINK, 101 , ," MESSAGE 101 " )
 \ ( MYLIST LINK, 404 , ," MESSAGE 404 " )
 \ ( MYLIST LINK, 501 , ," MESSAGE 501 " )
 \ ( MYLIST LINK, 999 , ," MESSAGE 999 " )

 \ ( VARIABLE DOLIST 0 DOLIST ! )
 \ ( : EXEC-999 ," EXECUTE IN 999 " )
 \ ( : EXEC-501 ," EXECUTE IN 501 " )
 \ ( : EXEC-404 ," EXECUTE IN 404 " )
 \ ( : EXEC-101 ," EXECUTE IN 101 " )
 \ ( DOLIST LINK, 999 , ['] EXEC-999 )
 \ ( DOLIST LINK, 501 , ['] EXEC-501 )
 \ ( DOLIST LINK, 404 , ['] EXEC-404 )
 \ ( DOLIST LINK, 101 , ['] EXEC-101 )


 : LINK, HERE OVER @ @ , SWAP ! ;

 : .SEARCH BEGIN @ 2DUP CELL + @ =
        IF SWAP OVER CELL + CELL + TRUE EXIT THEN
        DUP @ 0 = IF DROP DROP FALSE EXIT THEN
        AGAIN ;
 
 : .MESSAGE
        .SEARCH
        IF COUNT TYPE
        ELSE ," NO MESSAGE FOUND "
        THEN ;
 
 : .EXECUTE
        .SEARCH
        IF @ EXECUTE
        ELSE ," NO COMPILED CODE FOUND "
        THEN ;

         

 \ this file is still a stub 

\ adapted from
\ https://github.com/gerryjackson/forth2012-test-suite/blob/master/src/tester.fr
\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.2

 VARIABLE VERBOSE FALSE VERBOSE !

 VARIABLE ACTUAL-DEPTH

 CREATE ACTUAL-RESULTS 20 CELLS ALLOT

 : EMPTY-STACK SP0 SP@ ! ;

 : DEPTH SP0 SP@ @ - !

 : ERROR
        CR TYPE SOURCE TYPE
        EMPTY-STACK
        #ERRORS @ 1 + #ERRORS !
        ;
        
 :T{ ;

 : -> DEPTH SUP ACTUAL-DEPTH !
        ?DUP IF 0 DO ACTUAL-RESULTS I CELLS + ! LOOP THEN ;

 : }T
        DEPTH ACTUAL-DEPTH @ = 
        IF DEPTH ?DUP 
                IF 0 DO ACTUAL-RESULTS I CELLS + @ = 0= 
                        IF S" INCORRECT RESULT: " ERROR 
                        LEAVE THEN
                     LOOP
                THEN
        ELSE
                S" WRONG NUMBER OF RESULTS: " ERROR
        THEN ;        
                        
 : TESTING SOURCE VERBOSE @
        IF DUP >R TYPR CR R> >IN !
        ELSE >IN ! DROP [CHAR] * EMIT
        THEN ;

 

 \ (stub)

 \ for stack debug
 
 : SEES  
        HASH FIND IF DUP
        BEGIN
        OVER OVER @ = IF DROP DROP EXIT THEN
        DUP . @ . DROP CR CELL +
        AGAIN
        THEN
        ;

 : && SP@ . DROP RP@ . DROP LATEST @ . DROP HEAP @ . DROP ;

 : PIPE LIT [ 32 32 + 32 + 32 + 4 - , ] EMIT ;

 : LINES SWAP 
        %S
        PIPE 
        BEGIN  
        DUP . @ . DROP 
        CELL + OVER OVER < 
        IF PIPE DROP DROP EXIT THEN
        AGAIN ;
 
 : DUMPS SWAP
        BEGIN
        DUP . @ . CR DROP 
        CELL + 
        OVER OVER <
        = IF DROP DROP EXIT THEN
        AGAIN ;
 
 : %%S SP@ . @ . SP0 . CR LINES ; 

\ BYE

\ : $S SP@ . SP0 . CR DUMPS ;
 
\ : %R RP@ RP0 LINES ;

\ : $R RP@ RP0 DUMPS ;

\ %S  $S



: UM+ + ;

: UM/MOD 
    2DUP U< 
    IF NEGATE 
        32 FOR 
            >R DUP UM+ 
                >R >R DUP UM+ 
                R> + DUP R> R@ SWAP 
            >R UM+ 
            R> OR 
                IF >R DROP 1 + R> 
                ELSE DROP 
            THEN R> 
        NEXT DROP SWAP EXIT 
    THEN DROP 2DROP 1 - DUP ; 

: M/MOD 
    DUP 0< DUP >R 
        IF NEGATE >R 
            DNEGATE R> 
        THEN >R DUP 0< 
        IF R@ + 
        THEN R> UM/MOD 
    R> 
    IF SWAP NEGATE SWAP THEN ;

: /MOD OVER 0< SWAP M/MOD ; 

: MOD /MOD DROP ; 

: / /MOD NIP ; 

: UM* 
    0 SWAP 
    32 FOR 
        DUP UM+ >R >R 
        DUP UM+ 
        R> + 
        R> 
        IF >R OVER UM+ 
            R> + 
        THEN 
    NEXT 
    ROT DROP ; 

: * UM* DROP ; 

: M* 
    2DUP XOR 0< >R 
    ABS SWAP ABS UM* 
    R> IF DNEGATE THEN ; 

: */MOD >R M* R> M/MOD ; 

: */ */MOD SWAP DROP ; 

: 2* 2 * ; 

: 2/ 2 / ; 

: MU/MOD >R 0 R@ UM/MOD R> SWAP >R UM/MOD R> ; 

: D2* 2DUP D+ ; 

: DU2/ 2 MU/MOD ROT DROP ; 

: D2/ DUP >R 1 AND DU2/ R> 2/ OR ; 

: ALIGNED DUP 0 2 UM/MOD DROP DUP IF 2 SWAP - THEN + ; 

 
 \
 \ revision for correct ."
 \

 80 ARRAY TIBS 

 VARIABLE >IN

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

 \ : TYPE, 0 DO DUP C@ , 1 + LOOP DROP ;

 : ,"   
        STATE @ IF ( compile, copy from tibs into heap until " )
          \ count n bytes until "
          \ copy n bytes to heap
          \ align >IN and HERE with 0
          \ update >IN and HERE
        ELSE ( executing, copy from word into output )
          \ R> BEGIN DUP C@ DUP IF EMIT ?????? THEN 1 + (byte at byte)
          \ align R
        THEN
        \ TIBS !
        ;

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

 : COPY ( c a -- ) 
        >R
        BEGIN
                KEY OVER OVER - 
        WHILE
                DUP R> DUP 1 + >R C!
        REPEAT
        DROP R> ;

 : SNAP ( )
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



