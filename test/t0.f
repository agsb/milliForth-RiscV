 : TvoidT ;

 : -1 u@ 0# ;
 : 0 -1 -1 nand ;
 : TRUE -1 ;
 : FALSE 0 ;
 
 : 1 -1 -1 + -1 nand ;
 : 2 1 1 + ;
 : 3 2 1 + ;
 : 4 2 2 + ;

 : cell 4 ;
 
 : sp u@ ;
 : rp sp cell + ;
 : latest rp cell + ;
 : heap latest cell + ;
 : >in heap cell + ;
 : state >in cell + ;
 
 : rp@ rp @ cell + ;
 : sp@ sp @ cell + ;
 
 : dup sp@ @ ;
 : over sp@ cell + @ ;
 : swap over over sp@ cell + cell + cell + ! sp@ cell + ! ;
 : not dup nand ;
 : and nand not ;
 : or not swap not and not ;
 
 : - not 1 + + ;
 : <> - 0# ;
 : = <> not ;
 
 : drop dup - + ;
 : nip swap drop ;
 : tuck swap over ;
 : 2dup over over ;
 : 2drop drop drop ;
 
 : here heap @ ;
 : allot here + heap ! ;
 : , here ! cell allot ;
 : >r rp@ @ swap rp@ ! rp@ cell - rp ! rp@ ! ;
 : r> rp@ @ rp@ cell + rp ! rp@ @ swap rp@ ! ;
 
 : branch rp@ @ dup @ + rp@ ! ;
 : ?branch 0# not rp@ @ @ cell - and rp@ @ + cell + rp@ ! ;
 
 : lit rp@ @ dup cell + rp@ ! @ ;
 : ['] rp@ @ dup cell + rp@ ! @ ;

 : 2* dup + ;
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ;
 : 80h 1 2* 2* 2* 2* 2* 2* 2* ;
 : IMMEDIATE 80h 2** 2** 2** ;
 : immediate latest @ cell + dup @ IMMEDIATE or swap ! ;
 
 : ] 1 state ! ;
 : [ 0 state ! ; immediate
 : postpone -1 state ! ; immediate
 
 : if ['] ?branch , here 0 , ; immediate
 : then dup here swap - swap ! ; immediate
 : else ['] branch , here 0 , swap dup 
   here swap - swap ! ; immediate
 
 : begin here ; immediate
 : again ['] branch , here - , ; immediate
 : until ['] ?branch , here - , ; immediate
 
 : while ['] ?branch , here 0 , ; immediate
 : repeat swap ['] branch , here - , 
   dup here swap - swap ! ; immediate
 
 : do here ['] >r , ['] >r , ; immediate
 : loop ['] r> , ['] r> , ['] lit , 1 , ['] + , 
   ['] 2dup , ['] = , ['] ?branch , 
   here - , ['] 2drop , ; immediate
 
 : 8 lit [ 4 4 + , ] ;
 : 16 lit [ 8 8 + , ] ;
 : bl lit [ 16 16 + , ] ;
 : cr lit [ 8 2 + , ] emit ;
 : nl lit [ 8 4 + 1 + , ] emit ;
 : CHAR lit [ 16 1 - 2* 2* 2* 2* 16 1 - or , ] ;
 : c@ @ CHAR and ;
 
 : type 0 do dup c@ emit 1 + loop drop ;
 : in> >in @ c@ >in @ 1 + >in ! ;
 : parse in> drop 
    >in @ swap 0 
    begin over in> <> while 1 + repeat 
    swap bl = if >in @ 1 - >in ! then ;
 : word in> drop 
    begin dup in> <> until 
    >in @ 2 - >in ! parse ;
 : [char] ['] lit , bl word drop c@ , ; immediate
 
 : ( [char] ) parse drop drop ; immediate
 : ." [char] " parse type ; immediate

 ." Hello world " cr
 
 ." That's all Folks !" cr

