  
 \ : U< 2DUP XOR 0< IF SWAP DROP 0< EXIT THEN - 0< ;  
 \ : U> SWAP U< ;  
 \ : = XOR IF FALSE EXIT THEN TRUE ;  
 \ : < 2DUP XOR 0< IF DROP 0< EXIT THEN - 0< ;  
 \ : > SWAP < ;  
  
 \ : ABS DUP 0< IF NEGATE THEN ;  
   
 \ : MIN 2DUP SWAP < IF SWAP THEN DROP ;  
 \ : MAX 2DUP < IF SWAP THEN DROP ;  
  
 \ : UMIN 2DUP SWAP U< IF SWAP THEN DROP ;  
 \ : UMAX 2DUP U< IF SWAP THEN DROP ;  
  
 \ : WITHIN OVER - >R - R> U< ;  
  
