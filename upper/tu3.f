 
 
 : FOR ['] >R , BEGIN ; IMMEDIATE
 : NEXT ['] R> , ['] LIT , [ 1 ] , ['] - , 
   ['] DUP , ['] 0# , ['] ?BRANCH ,
   HERE - , ['] DROP , ; IMMEDIATE

 : HOOK BEGIN >R ;
 : BACK R> AGAIN ;
 : ?BACK R> UNTIL ;

 : SWIP >R SWAP R> ; 
 : ROT SWIP SWAP ;
 : -ROT SWAP SWIP ;
 : FLIP SWAP SWIP SWAP ;

 : DOVAR R> DUP CELL + >R ;
 : DOCON R> DUP CELL + >R @ ;
 : LITERAL ['] LIT , , ;
 : EXECUTE >R ;

 

