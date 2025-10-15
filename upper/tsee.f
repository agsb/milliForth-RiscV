
: SEE  
        ['] EXIT . HASH FIND . CR IF 
        BEGIN
        OVER . OVER . NAND . CR
        WHILE
                DUP . @ . CR DROP
                CELL +
        REPEAT
        THEN
        DROP
        %S
        ;

 SEE SEE


