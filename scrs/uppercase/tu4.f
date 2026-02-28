
: FILL  ( into many char -- )
        SWAP >R
        BEGIN
        OVER OVER !
        R> 1 - DUP >R
        IF R> DROP DROP DROP EXIT THEN
        SWAP 1 + 
        SWAP
        AGAIN
        ;

: CCOPY ( from into many -- )
        >R 
        BEGIN
        OVER @
        OVER !
        R> 1 - DUP >R
        IF R> DROP DROP DROP EXIT THEN
        SWAP 1 +
        SWAP 1 +
        AGAIN
        ;

: CYPOC ( from into many -- )
        >R 
        BEGIN
        OVER @
        OVER !
        R> 1 - DUP >R
        IF R> DROP DROP DROP EXIT THEN
        SWAP 1 1
        SWAP 1 1
        AGAIN
        ;
