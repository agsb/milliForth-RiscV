
 VARIABLE TAPE_HEAD

 VARIABLE LOOP_DEPTH
 
 VARIABLE PARSE_INDEX
 
 : RUNBF 0 PARSE_INDEX ! 
   BEGIN PARSE_INDEX @ C@ 
   DUP DUP DUP DUP DUP DUP DUP 
   [CHAR] , = IF KEY TAPE_HEAD @ ! THEN 
   [CHAR] - = IF TAPE_HEAD @ @ 1 - TAPE_HEAD @ ! THEN 
   [CHAR] + = IF TAPE_HEAD @ @ 1 + TAPE_HEAD @ ! THEN 
   [CHAR] < = IF TAPE_HEAD @ 2 - TAPE_HEAD ! THEN 
   [CHAR] > = IF TAPE_HEAD @ 2 + TAPE_HEAD ! THEN 
   [CHAR] . = IF TAPE_HEAD @ @ EMIT THEN 
   
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
 
 HERE 64 + TAPE_HEAD !
 
 BF( >++++++++[<+++++++++>-] <.>++++[<+++++++>-] <+.+++++++..+++.>>++++++[<+++++++>-] <++.------------.>++++++[<+++++++++>-] <+.<.+++.------.--------.>>>++++[<++++++++>-] <+. )

