
 \ this file is still a stub 

 \ for stack debug

 : && SP@ . DROP RP@ . DROP LATEST @ . DROP HEAP @ . DROP ;

 : SP0 LIT [ SP@ , ] ;

 : RP0 LIT [ RP@ , ] ;

 : RP! RP ! ; \ carefull

 : SP! SP ! ; \ carefull

 \ for compilation 

 : :NAME HERE : 0 STATE ! ;

 : :NONAME HERE 1 STATE ! ;

 : LINK>HASH CELL + ;

 : LINK>BODY CELL + CELL + ;

 : HASH :NAME DUP HEAP ! CELL + @ ;

 : FIND LATEST @ BEGIN
        OVER OVER CELL + @
        ISNEGATIVE 1 - AND
        = IF SWAP DROP TRUE EXIT THEN
        @ DUP 
        0 = IF SWAP DROP FALSE EXIT THEN
        AGAIN ;
 
 : ' HASH FIND IF CELL + CELL + THEN ; 

 : POSTPONE ' , ; IMMEDIATE 

 : SEE  
        HASH FIND IF DUP
        BEGIN
        OVER OVER @ = IF DROP DROP EXIT THEN
        DUP . @ . DROP CR CELL +
        AGAIN
        THEN
        ;

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

 : * DUP IF >R DUP R> 1 DO OVER + LOOP SWAP DROP THEN ;

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

 : .x HEX_WORD ;

 : ?x @ . ;


