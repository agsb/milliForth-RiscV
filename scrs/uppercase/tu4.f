
 \ FOR NEXT counts down ends at zero
 \ leaves the counter with 0 at TOS 
 \ and not mess stack

 : FOR ( n -- )
        ['] HERE >R , ; IMMEDIATE 

 : NEXT ( -- 0 )
        ['] R> , ['] -1 , ['] + , ['] DUP , 
        ['] 0 , ['] = , ['] ?BRANCH , HERE - ,
        ; IMMEDIATE 

 : DROPS DROP DROP DROP ; 

 : CFFILL ( char into many -- )
        FOR OVER OVER ! 1 + NEXT DROPS ;

 : CBFILL ( char into many -- )
        FOR OVER OVER ! 1 - NEXT DROPS ;

 : CFCOPY ( from into many -- ) \ forward copy
        FOR OVER @ OVER ! 1 + SWAP 1 + SWAP NEXT DROPS ;

 : CBCOPY ( from into many -- ) \ backward copy
        FOR OVER @ OVER ! 1 - SWAP 1 - SWAP NEXT DROPS ;

 : COUNT ( c a -- a n )
        0 >R BEGIN OVER OVER @ = 
        IF R> 1 + >R 
        ELSE SWAP DROP R> EXIT 
        THEN AGAIN ;

