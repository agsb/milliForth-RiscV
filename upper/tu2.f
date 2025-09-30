

 : && SP@ . DROP RP@ . DROP LATEST @ . DROP HEAP @ . DROP ;

 : SP0 LIT [ SP@ , ] ;

 : RP0 LIT [ RP@ , ] ;

 : DUMPS BEGIN OVER OVER 
        = IF DROP DROP EXIT THEN
        CELL +
        DUP CR . SPACE @ . DROP 
        AGAIN ;

 : $S SP0 SP@ DUMPS ;
 
 : $R RP0 RP@ DUMPS ;


