 : COPY ( c a -- ) 
        >R
        BEGIN
                KEY OVER OVER - 
        WHILE
                DUP R> DUP 1 + >R C!
        REPEAT
        DROP R> ;

 : SNAP ( )
        HERE DUP 32 2 + COPY
        OVER OVER - 
        SWAP C!
        SWAP DROP
        SWAP !
        ;

 : SEEN HERE DUP 0 , 32 2 + 
        BEGIN KEY OVER OVER - WHILE , REPEAT HERE OVER - ! ;

 : xxxC" STATE @ IF 
        ELSE
        THEN ; 

 : xxxS" STATE @ IF 
        ELSE
        THEN ; 

 : xxxCOPY BEGIN KEY OVER - 0# NOT UNTIL DROP ; 
 
 : xxxTYPEZ BEGIN DUP 1 + SWAP C@ DUP IF EMIT THEN NOT UNTIL DROP ; 

 : xxxCOUNT 0 BEGIN OVER DUP C@ UNTIL DROP ;  

