 \
 \ revision for correct ."
 \

 : TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ;

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

 ." HELLO WORLD " CR
 
 ." THAT'S ALL FOLKS !" CR

 \ : TYPE, 0 DO DUP C@ , 1 + LOOP DROP ;

 : ,"   
        STATE @ IF ( compile, copy from tibs into heap until " )
          \ count n bytes until "
          \ copy n bytes to heap
          \ align >IN and HERE with 0
          \ update >IN and HERE
        ELSE ( executing, copy from word into output )
          \ R> BEGIN DUP C@ DUP IF EMIT ?????? THEN 1 + (byte at byte)
          \ align R
        THEN
        \ TIBS !
        ;

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

