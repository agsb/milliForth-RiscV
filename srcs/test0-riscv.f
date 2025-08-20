
 : void ;

 : -1 s@ s@ nand s@ nand ;
  
 : -1 s@ 0# ;
 
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
 
 : cr 10 emit ;
 : nl 13 emit ;
 : spc 32 ;


 : cell 4 ;

 : S1 cell ;
 : S2 S1 cell + ;
 : S3 S2 cell + ;
 : S4 S3 cell + ;
 : S5 S4 cell + ;

 : >in s@ S1 + ;
 : last s@ S2 + ;
 : here s@ S3 + ;
 : sp s@ S4 + ;
 : rp s@ S5 + ;

 : dup sp @ @ ;

 1 1 + 

 1 1 nand 

 key emit 

 1 2 4 8
 
 sp @ @

 0

 16

 dup 

 0

 : over sp @ cell + @ ;

 : invert dup nand ;
 : and nand invert ;
 : - invert 1 + + ;
 : <> - 0# ;
 : = <> invert ;
 
 : drop dup - + ;
 : swap over over sp @ S3 + ! sp @ S2 + ! ;
 : or invert swap invert and invert ;

 : 2dup over over ;
 : 2drop drop drop ;
 
 : allot here @ + here ! ;
 : , here @ ! cell allot ;

 : 2* dup + ;
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ;
 : 80h 1 2* 2* 2* 2* 2* 2* 2* ;
 : flag 80h 2** 2** 2** ;

 flag

 : immediate last @ cell + dup @ flag or swap ! ;
 
 : >r rp @ @ swap rp @ ! rp @ cell - rp ! rp @ ! ;
 : r> rp @ @ rp @ cell + rp ! rp @ @ swap rp @ ! ;
 
 : branch rp @ @ dup @ + rp @ ! ;
 : ?branch 0# invert rp @ @ @ cell - and rp @ @ + cell + rp @ ! ;
 
 : lit rp @ @ dup cell + rp @ ! @ ;
 : ['] rp @ @ dup cell + rp @ ! @ ;
 
 : rot >r swap r> swap ;
 
 : ] 1 s@ ! ;
 : [ 0 s@ ! ; 

 immediate
 
 : if ['] ?branch , here @ 0 , ; immediate
 : then dup here @ swap - swap ! ; immediate
 : else ['] branch , here @ 0 , swap dup 
     here @ swap - swap ! ; immediate
 
 : begin here @ ; immediate
 : again ['] branch , here @ - , ; immediate
 : until ['] ?branch , here @ - , ; immediate
 : while ['] ?branch , here @ 0 , ; immediate
 : repeat swap ['] branch , here @ - , 
     dup here @ swap - swap ! ; immediate
 
 : do here @ ['] >r , ['] >r , ; immediate
 : loop ['] r> , ['] r> , ['] lit , 1 , ['] + , 
     ['] 2dup , ['] = , ['] ?branch , 
     here @ - , ['] 2drop , ; immediate
 
 : bl lit [ 1 2* 2* 2* 2* 2* , ] ;
 : 0fh lit [ 4 4 4 4 + + + 1 - , ] ;
 : ffh lit [ 0fh 2* 2* 2* 2* 0fh or , ] ;
 : c@ @ ffh and ;
 : type 0 do dup c@ emit 1 + loop drop ;
 
 : in> >in @ c@ >in dup @ 1 + swap ! ;
 : parse in> drop >in @ swap 0 begin over in> 
     <> while 1 + repeat swap bl 
     = if >in dup @ 1 - swap ! then ;
 : word in> drop begin dup in> <> until >in @ 2 - >in ! parse ;
 
 : [char] ['] lit , bl word drop c@ , ; immediate
 : ." [char] " parse type ; immediate
 
 : ( [char] ) parse drop drop ; immediate
 
 ." Hello world " cr
 
 ." That's all Folks !" cr
 
 dump
 
 
