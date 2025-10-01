 \ modified from sector-forth examples, @Cesar Blum

 : ?DUP DUP ?BRANCH [ 4 , ] DUP ;
 : XOR 2DUP AND INVERT -ROT OR and ;
 : 80000000h LIT [ 0 c, 0 c, 0 c, 80h c, ] ; \ little endian
 : >= - 80000000h AND 0= ;
 : < >= INVERT ;
 : <= 2DUP < -ROT = OR ;
 : 0< 0 < ;

 : 2SWAP ROT >R ROT R> ;
 : 2OVER >R >R 2DUP R> R> 2SWAP ;
 : 2ROT 2>R 2SWAP 2R> 2SWAP ;
 : -2ROT 2ROT 2ROT ;
 
 : 2NIP 2SWAP 2DROP ;
 : 2TUCK 2SWAP 2OVER ;
 
 : U< 2DUP XOR 0< IF SWAP DROP 0< EXIT THEN - 0< ;
 : U> SWAP U< ;
 : = XOR IF FALSE EXIT THEN TRUE ;
 : < 2DUP XOR 0< IF DROP 0< EXIT THEN - 0< ;
 : > SWAP < ;

 : ABS DUP 0< IF NEGATE THEN ;

 : MIN 2DUP SWAP < IF SWAP THEN DROP ;
 : MAX 2DUP < IF SWAP THEN DROP ;

 : UMIN 2DUP SWAP U< IF SWAP THEN DROP ;
 : UMAX 2DUP U< IF SWAP THEN DROP ;

 : WITHIN OVER - >R - R> U< ;

