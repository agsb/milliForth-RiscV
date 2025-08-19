
 : void ;

 : -1 s@ s@ nand s@ nand ;
 :  0 -1 -1 nand ;
 :  1 -1 -1 + -1 nand ;
 :  2  1  1 + ;

 :  4 2 2 + ;
 :  8 4 4 + ;
 : 12 8 4 + ;
 : 16 8 8 + ;
 : 20 12 8 + ;

 : 10 8 2 + ;
 : 13 8 4 + 1 + ;
 : 32 16 16 + ;

 : cell 4 ;

 : S1 cell ;
 : S2 S1 cell + ;
 : S3 S2 cell + ;
 : S4 S3 cell + ;
 : S5 S4 cell + ;

 : toin s@ S1 + ;
 : last s@ S2 + ;
 : here s@ S3 + ;
 : sp s@ S4 + ;
 : rp s@ S5 + ;

 : cr 10 emit ;
 : nl 13 emit ;
 : spc 32 ;

 : dup sp @ @ ;
 : over sp @ cell + @ ;

 : invert dup nand ;
 : and nand invert ;
 : or invert swap invert and invert ;
 : - invert 1 + + ;
 : <> - 0# ;
 : = <> invert ;
 
 : drop dup - + ;
 : swap over over sp @ S3 + ! sp @ S2 + ! ;

 : 2dup over over ;
 : 2drop drop drop ;
 
 : allot here @ + here ! ;
 : , here @ ! cell allot ;

 : 2* dup + ;
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ;
 : 80h 1 2* 2* 2* 2* 2* 2* 2* 2** 2** 2** ;
 : immediate latest @ cell + dup @ 80h or swap ! ;
 
 : >r rp @ @ swap rp @ ! rp @ cell - rp ! rp @ ! ;
 : r> rp @ @ rp @ cell + rp ! rp @ @ swap rp @ ! ;
 
 : branch rp @ @ dup @ + rp @ ! ;
 : ?branch 0# invert rp @ @ @ cell - and rp @ @ + cell + rp @ ! ;
 
 : lit rp @ @ dup CEL + rp @ ! @ ;
 : ['] rp @ @ dup CEL + rp @ ! @ ;
 
 : rot >r swap r> swap ;
 
 : ] 1 s@ ! ;
 : [ 0 s@ ! ; 

