
 \ words like ."

 : COPY" ( c a1 -- c a2 ) \ copy from input to memory till quote
    BEGIN 
        >R KEY 
        DUP R@ C! 
        OVER = 
        R> 1 + SWAP 
    UNTIL 
    ; 

 : TYPE" ( c a1 -- c a2 ) \ dump from memory till quote
    BEGIN
        OVER OVER C@ = DUP 
        IF 
            >R DUP C@ EMIT 1 + R> 
        THEN
    UNTIL
    ; 

 zzz

 : ."
     QU
     STATE @ 
     IF \ compiling
         HERE COPY" 
         ROUND-UP HEAP !
     ELSE \ executing
         R> TYPE" >R DROP
     THEN
     ; IMMEDIATE 
 
