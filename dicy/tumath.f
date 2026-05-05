: UM+ + ;

: UM/MOD 
    2DUP U< 
    IF NEGATE 
        32 FOR 
            >R DUP UM+ 
                >R >R DUP UM+ 
                R> + DUP R> R@ SWAP 
            >R UM+ 
            R> OR 
                IF >R DROP 1 + R> 
                ELSE DROP 
            THEN R> 
        NEXT DROP SWAP EXIT 
    THEN DROP 2DROP 1 - DUP ; 

: M/MOD 
    DUP 0< DUP >R 
        IF NEGATE >R 
            DNEGATE R> 
        THEN >R DUP 0< 
        IF R@ + 
        THEN R> UM/MOD 
    R> 
    IF SWAP NEGATE SWAP THEN ;

: /MOD OVER 0< SWAP M/MOD ; 

: MOD /MOD DROP ; 

: / /MOD NIP ; 

: UM* 
    0 SWAP 
    32 FOR 
        DUP UM+ >R >R 
        DUP UM+ 
        R> + 
        R> 
        IF >R OVER UM+ 
            R> + 
        THEN 
    NEXT 
    ROT DROP ; 

: * UM* DROP ; 

: M* 
    2DUP XOR 0< >R 
    ABS SWAP ABS UM* 
    R> IF DNEGATE THEN ; 

: */MOD >R M* R> M/MOD ; 

: */ */MOD SWAP DROP ; 

: 2* 2 * ; 

: 2/ 2 / ; 

: MU/MOD >R 0 R@ UM/MOD R> SWAP >R UM/MOD R> ; 

: D2* 2DUP D+ ; 

: DU2/ 2 MU/MOD ROT DROP ; 

: D2/ DUP >R 1 AND DU2/ R> 2/ OR ; 

: ALIGNED DUP 0 2 UM/MOD DROP DUP IF 2 SWAP - THEN + ; 

