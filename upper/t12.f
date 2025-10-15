
 \ crude math

 : <  - 0< ;

 : > SWAP < ;

 : * DUP IF >R DUP R> 1 DO OVER + LOOP SWAP DROP THEN ;

 \ https://stackoverflow.com/questions/78708194/logical-shift-right-without-dedicated-shift-instruction

 : 2/   0 32 2 DO
        OVER ISNEGATIVE AND IF 1 + THEN  
        DUP + SWAP
        DUP + SWAP
        LOOP
        CR
        SWAP DROP
        ;

 : 2/   . 0 32 1 - BEGIN
        >R
        OVER ISNEGATIVE AND IF 1 + THEN  
        R> 1 - DUP 0# WHILE
        %S
        >R
        DUP + SWAP
        DUP + SWAP
        R>
        REPEAT
        %S
        DROP SWAP DROP
        ;

: FULL 32 32 + 32 + 32 + 32 + 0 DO
        I . 2/ .
        CR
        LOOP ;

 FULL

 bye

 : 7 LIT [ 4 2 + 1 + , ] ;

 : 10 LIT [ 8 2 + , ] ;

 : 48 LIT [ 32 16 + , ] ;  \ '0'

 : 57 LIT [ 48 10 + 1 - , ] ;  \ '9' 

 : PUTC
        0fh AND 48 OR DUP 
        57 > IF 7 + THEN  
        EMIT
        ;

 : PUTB
        ffh AND 
        DUP
        . SPACE
        2/ 2/ 2/ 2/
        . SPACE
        PUTC
        . SPACE 
        PUTC
        ;
        
  57 1 +  48 + %S

  DUP 2/ . 2/ . 2/ . 2/ .

  PUTB .
 
 bye 

 : PUTH
        %S
        DUP 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        PUTB
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        PUTB
        DUP
        2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ 
        PUTB
        PUTB
        %S
        ;

  57 1 +  48 + %S DUP DUP

 PUTC PUTB PUTH CR

