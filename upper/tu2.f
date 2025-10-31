

 \ for stack debug

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
 
 %S

 : %%S SP@ . @ . SP0 . CR LINES ; 

 %%S

 %S

 BYE


\ : $S SP@ . SP0 . CR DUMPS ;
 
\ : %R RP@ RP0 LINES ;

\ : $R RP@ RP0 DUMPS ;

\ %S  $S



