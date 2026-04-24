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

 : HEAD  STATE CELL + ; 
 : BEATS HEAD CELL + ; 
 : TICKS BEATS CELL + ;  
 
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

 : R> RP@ @ RP@ CELL + RP ! RP@ @ SWAP RP@ ! ; 
 : >R RP@ @ SWAP RP@ ! RP@ CELL - RP ! RP@ ! ; 
 : R@ R> R> DUP >R SWAP >R ; 

 : EXECUTE >R ; 
 : COMPILE R> DUP @ , CELL + >R ;

 : LIT RP@ @ DUP CELL + RP@ ! @ ; 
 : ['] RP@ @ DUP CELL + RP@ ! @ ; 
 
 : ROT >R SWAP R> SWAP ; 
 : -ROT SWAP >R SWAP R> ; 
 
 : XOR OVER OVER AND -ROT NOR NOR ; 
 : XNOR XOR NOT ; 
 
 : 0= 0# NOT ; 
 : 0< ISNEGATIVE AND 0# ; 

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
 
 : DO ['] SWAP , HERE ['] >R , ['] >R , ; IMMEDIATE 

 : LOOP 
        ['] R> , ['] LIT , 1 , ['] + , ['] R> , 
        ['] 2DUP , ['] = , ['] ?BRANCH , HERE - , 
        ['] 2DROP , ; IMMEDIATE 

 : I ['] R@ , ; IMMEDIATE 

 : LEAVE 
        ['] R> , ['] DROP ,
        ['] R> , ['] DROP ,
        ['] EXIT , ; IMMEDIATE 

 : FOR HERE ['] >R , ; IMMEDIATE

 : NEXT 
        ['] R> , ['] LIT , 1 , ['] - ,  ['] DUP , 
        ['] 0< , ['] NOT ,
        ['] ?BRANCH , HERE - , 
        ['] DROP , ; IMMEDIATE

 : BREAK 
        ['] DUP , ['] R> , ['] LEAVE , ; IMMEDIATE

 : ?DUP DUP IF DUP THEN ; 

 : CELL LIT [ 4 , ] ; 

 : CHARS ;

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


\ from forth200x.org

\ exception word set, 

 VARIABLE HANDLER
 
 0 HANDLER !

 : CATCH
        SP@ >R 
        HANDLER @ >R
        RP@ HANDLER !
        EXECUTE
        R> HANDLER !
        R> DROP
        0 ;

 : THROW
        ?DUP IF
                HANDLER @ RP!
                R> HANDLER !
                R> SWAP >R
                SP! DROP R>
        THEN ;
 
 : ABORT -1 THROW ;
                
 \ facility word set

 : +FIELD CREATE OVER , + DOES> @ + ;

 : BEGIN-STRUCTURE CREATE HERE 0 0 , DOES> @ ;

 : END-STRUCTURE SWAP ! ;

 \ clean stack

 : DROPS DROP DROP DROP ; 

 \ FILL and COPY does forward, pointers at init
 
 : CFILL ( char into many -- )
        FOR OVER OVER ! 1 + NEXT DROPS ;

 : CCOPY ( from into many -- )
        FOR OVER @ OVER ! 1 + SWAP 1 + SWAP NEXT DROPS ;

 \ FILL< and COPY< does backward, pointers at end 

 : TOEND ( f t n -- f+n t+n n )
        DUP DUP >R >R + SWAP R> + SWAP R> ; 
        
 : CFILL< ( char into many -- )
        FOR OVER OVER ! 1 - NEXT DROPS ;

 : CCOPY< ( from into many -- ) 
        FOR OVER @ OVER ! 1 - SWAP 1 - SWAP NEXT DROPS ;

\ forth 2012 reference

 : ABS ( n -- +n ) DUP 0< IF NEGATE THEN ;

 : MIN ( w1 w2 -- w3 ) OVER OVER - 0 < IF SWAP THEN DROP ;

 : MAX ( w1 w2 -- w3 ) SWAP MIN ;

 CREATE TIB 80 CHARS ALLOT

 : ACCEPT ( a n -- ) 
        IF FOR KEY DUP CR <> 
                IF OVER ! 1 + ELSE R> DROP 0 R> THEN
                NEXT THEN DROP ; 

 \ this file is still a stub 

 : HOOK BEGIN >R ;
 : BACK R> AGAIN ;
 : ?BACK R> UNTIL ;

 : SWIP >R SWAP R> ; 
 : ROT SWIP SWAP ;
 : -ROT SWAP SWIP ;
 : FLIP SWAP SWIP SWAP ;

 : DOVAR R> DUP CELL + >R ;
 : DOCON R> DUP CELL + >R @ ;
 : DOLIT R> DUP CELL + >R ;
 : LITERAL ['] DOLIT , , ;

 \ https://stackoverflow.com/questions/78708194/
 \ logical-shift-right-without-dedicated-shift-instruction

 : 2/   0 32 2 DO
        OVER ISNEGATIVE AND IF 1 + THEN  
        DUP + SWAP
        DUP + SWAP
        LOOP
        OVER ISNEGATIVE AND IF 1 + THEN  
        SWAP DROP
        ;

 \ crude math

 : <  - 0< ;

 : > SWAP < ;

 : ** DUP IF >R DUP R> 1 DO OVER + LOOP SWAP DROP THEN ;

 \ SHOW HEXADECIMAL

 : 7 LIT [ 4 2 + 1 + , ] ; \ to escape : thru @

 : 48 LIT [ 32 16 + , ] ;  \ to compare '0'

 : 57 LIT [ 48 10 + 1 - , ] ;  \ to compare '9' 

 : HEX_NIBB
        0fh AND 48 OR DUP 
        57 > IF 7 + THEN  
        EMIT
        ;

 : HEX_BYTE
        ffh AND 
        DUP
        2/ 2/ 2/ 2/
        HEX_NIBB
        HEX_NIBB
        ;
        
 : HEX_WORD
        DUP 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        HEX_BYTE
        HEX_BYTE
        ;

 \ : . HEX_WORD ;

 \ : ? @ . ;

 \ this file is still a stub 

 \ modified from sector-forth examples, @Cesar Blum

 : ?DUP DUP ?BRANCH [ 4 , ] DUP ;
 : XOR 2DUP AND INVERT -ROT OR and ;
 : 80000000h LIT [ 0 c, 0 c, 0 c, 80h c, ] ; \ little endian
 : >= - 80000000h AND 0= ;
 : < >= INVERT ;
 : <= 2DUP < -ROT = OR ;
 : 0< 0 < ;

 : 2SWAP ROT >R ROT R> ;
 : 2OVER >R >R 2DUP R> R> 2SWAP ;
 : 2ROT 2>R 2SWAP 2R> 2SWAP ;
 : -2ROT 2ROT 2ROT ;
 
 : 2NIP 2SWAP 2DROP ;
 : 2TUCK 2SWAP 2OVER ;
 
 : U< 2DUP XOR 0< IF SWAP DROP 0< EXIT THEN - 0< ;
 : U> SWAP U< ;
 : = XOR IF FALSE EXIT THEN TRUE ;
 : < 2DUP XOR 0< IF DROP 0< EXIT THEN - 0< ;
 : > SWAP < ;

 : ABS DUP 0< IF NEGATE THEN ;

 : MIN 2DUP SWAP < IF SWAP THEN DROP ;
 : MAX 2DUP < IF SWAP THEN DROP ;

 : UMIN 2DUP SWAP U< IF SWAP THEN DROP ;
 : UMAX 2DUP U< IF SWAP THEN DROP ;

 : WITHIN OVER - >R - R> U< ;


 \ math from eforth

 : * ( x y -- z )
        DUP ( Check not zero)
        IF OVER 0< OVER 0< XOR >R ( Calculate sign of result)
        0 ROT ABS ROT ABS ( Use absolute values)
        BEGIN
                DUP ( While not zero do)
        WHILE
                SWAP ROT OVER + ( Add to accumulator)
                SWAP ROT 1- ( And decrement counter)
        REPEAT
        DROP DROP ( Drop temporary parameters)
        R> IF 
                NEGATE THEN ( Check sign for negate)
        ELSE
                SWAP DROP ( Return zero)
        THEN ;

 : /MOD ( x y -- r q )
        DUP ( Check not zero division )
        IF 
                OVER 0< >R ( Save sign of divident )
                OVER 0< OVER 0< XOR >R ( Calculate sign of result )
                0 ROT ABS ROT ABS ( Use the absolute values )
                BEGIN
                        SWAP OVER - DUP 0< NOT ( Calculate next remainder )
                WHILE ( Check not negative )
                        SWAP ROT 1+ ( Increment quotient )
                        ROT ROT ( And go again )
                REPEAT
        + SWAP ( Restore after last loop )
        R> IF NEGATE THEN ( Check sign of quotient )
        R> IF SWAP NEGATE SWAP THEN ( Check sign of remainder )
        THEN ;

 : / ( x y -- q ) /MOD SWAP DROP ;

 : MOD ( x y -- r ) /MOD DROP ;

 : 2/ ( x -- y ) 2 / ;

 : 2* ( x -- y ) 2 * ;


