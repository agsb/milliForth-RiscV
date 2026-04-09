
 \ FOR NEXT counts down and ends at zero

 : FOR ( n -- )
        ['] HERE >R , ; IMMEDIATE 

 : NEXT ( -- 0 )
        ['] R> , ['] -1 , ['] + , ['] DUP , 
        ['] 0 , ['] = , ['] ?BRANCH , HERE - ,
        ; IMMEDIATE 

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

 : XXXCOUNT ( c a -- a n )
        SWAP OVER BEGIN OVER OVER @ = 
        ;

