
 : IN> >IN @ C@ >IN @ 1 + >IN ! ; 

 : PARSE IN> DROP 
        >IN @ SWAP 0 
        BEGIN OVER IN> <> WHILE 1 + REPEAT 
        SWAP BL = IF >IN @ 1 - >IN ! THEN ; 

 : WORD IN> DROP 
        BEGIN DUP IN> <> UNTIL 
        >IN @ 2 - >IN ! PARSE ; 

 : [CHAR] ['] LIT , BL WORD DROP C@ , ; IMMEDIATE 
 
 : ( [CHAR] ) PARSE DROP DROP ; IMMEDIATE 

 : ." [CHAR] " PARSE TYPE ; IMMEDIATE 

 \ TEST MINIMAL

 ." HELLO WORLD " CR
 
 ." THAT'S ALL FOLKS !" CR

