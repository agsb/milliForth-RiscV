 ." HELLO WORLD " CR
 
 ." THAT'S ALL FOLKS !" CR

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

