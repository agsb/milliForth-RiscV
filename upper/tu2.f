

 : PIPE LIT [ 32 32 + 32 + 32 + 4 - , ] EMIT ;

 : LINES SWAP 
        . 
        PIPE 
        BEGIN  
        DUP . @ . DROP PIPE 
        CELL + OVER OVER
        = IF DROP DROP EXIT THEN
        AGAIN ;
 
 : DUMPS SWAP
        BEGIN
        DUP . @ . CR DROP 
        CELL + OVER OVER
        = IF DROP DROP EXIT THEN
        AGAIN ;
 
 : %S SP@ . SP0 . CR LINES ; 

 : $S SP@ . SP0 . CR DUMPS ;
 
 : %R RP@ RP0 LINES ;

 : $R RP@ RP0 DUMPS ;

 8 4 2 1 0 

 %S  $S



