
 \ this file is still a stub 

 \ for stack debug

 : && SP@ . DROP RP@ . DROP LATEST @ . DROP HEAP @ . DROP ;

 : SP0 LIT [ SP@ , ] ;

 : RP0 LIT [ RP@ , ] ;

 : RP! RP ! ; \ carefull

 : SP! SP ! ; \ carefull

 : DUMPS BEGIN OVER OVER 
        = IF DROP DROP EXIT THEN
        CELL +
        DUP CR . SPACE @ . DROP 
        AGAIN ;
 
 : $S SP0 SP@ DUMPS ;
 
 : $R RP0 RP@ DUMPS ;

 : ? ( a -- a ) @ . ;

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

