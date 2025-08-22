
 : void ;

 : -1 s@ 0# ;
 
 :  0 -1 -1 nand ;
 :  1 -1 -1 + -1 nand ;
 
 :  2 1 1 + ;
 :  4 2 2 + ;
 :  8 4 4 + ;
 : 12 8 4 + ;
 : 16 8 8 + ;
 : 20 12 8 + ;

 : 10 8 2 + ;
 : 13 8 4 + 1 + ;
 : 32 16 16 + ;
 
 : cr 10 emit ;
 : nl 13 emit ;
 : spc 32 ;

 : cell 4 ;

 : cell+ 4 + ;

 : S1 cell ;
 : S2 S1 cell + ;
 : S3 S2 cell + ;
 : S4 S3 cell + ;
 : S5 S4 cell + ;

 : state s@ ;
 : >in s@ S1 + ;
 : last s@ S2 + ;
 : here s@ S3 + ;
 : sp s@ S4 + ;
 : rp s@ S5 + ;

 : rp@ rp @ ;
 
 : sp@ sp @ cell + ;
 
 : dup sp@ @ ;

 : over sp@ cell + @ ;

 : swap over over sp@ S3 + ! sp@ S1 + ! ;

 : not dup nand ;

 : and nand not ;

 : or not swap not and not ;

 : - not 1 + + ;

 : <> - 0# ;

 : = <> not ;

 : drop dup - + ;

 : allot here @ + here ! ;

 : , here @ ! cell allot ;

 : >r rp @ @ swap rp @ ! rp @ cell - rp ! rp @ ! ;
 : r> rp @ @ rp @ cell + rp ! rp @ @ swap rp @ ! ;
 
 : branch rp @ @ dup @ + rp @ ! ;
 : ?branch 0# invert rp @ @ @ cell - and rp @ @ + cell + rp @ ! ;
 
 : lit rp @ @ dup cell + rp @ ! @ ;

 : ['] rp @ @ dup cell + rp @ ! @ ;
 
 : rot >r swap r> swap ;

 : 2* dup + ;

 : 80h 1 2* 2* 2* 2* 2* 2* 2* ;
 : immediate latest @ 2 + dup @ 80h or swap ! ;
 
 : ] 1 s@ ! ;
 : [ 0 s@ ! ; immediate
 
 1 2 4 8
 
 swap

 s@ 0# drop



