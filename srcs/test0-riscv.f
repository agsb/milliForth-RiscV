 : -1 s@ s@ nand s@ nand ;
 :  0 -1 -1 nand ;
 :  1 -1 -1 + -1 nand ;
 :  2 1 1 + ;


 :  4 2 2 + ;
 :  8 4 4 + ;
 : 12 8 4 + ;
 : 16 8 8 + ;
 : 20 12 8 + ;

 : cell 4 ;
 : sp s@ 16 + ;
 : rp s@ 20 + ;


 : 10 8 2 + ;
 : 13 8 4 + 1 + ;
 : cr 10 emit ;
 : nl 13 emit ;

 : dup sp @ @ ;
 : drop dup - + ;
 : over sp @ cell + @ ;

