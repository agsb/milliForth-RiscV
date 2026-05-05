\ forth 2012 reference

: CHARS ; \ char ascii is 1 byte

: CELLS DUP + DUP + ; \ word is 4 bytes

: ABS ( n -- +n ) DUP 0< IF NEGATE THEN ;

: MIN ( w1 w2 -- w3 ) OVER OVER - 0 < IF SWAP THEN DROP ;

: MAX ( w1 w2 -- w3 ) SWAP MIN ;

: NIP SWAP DROP ;

: TUCK SWAP OVER ;

CREATE TIB 80 CHARS ALLOT

: ACCEPT ( a n -- ) 
        IF FOR KEY DUP CR <> 
                IF OVER ! 1 + ELSE R> DROP 0 R> THEN
                NEXT THEN DROP ; 


