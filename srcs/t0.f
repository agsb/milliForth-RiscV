
 : void u@ 0# ;
see

 : | .S .R ;
see

 : -1 u@ 0# ;
see

 :  0 -1 -1 nand ;
see

 : TRUE -1 ;
see

 : FALSE 0 ;
see

 :  1 -1 -1 + -1 nand ;
 see

 :  2 1 1 + ;
 see
 :  4 2 2 + ;
 see

 : sp u@ ;
 see
 : rp sp cell + ;
 see
 : last rp cell + ;
 see
 : here last cell + ;
 see
 : >in here cell + ;
 see
 : state >in cell + ;
 see

 : rp@ rp @ cell + ;
 see
 
 : sp@ sp @ cell + ;
 see
 
 : dup sp@ @ ;
 see

 : over sp@ cell + @ ;
 see
 
 : swap over over sp@ cell + cell + cell + ! sp@ cell + ! ;
 see

 : not dup nand ;
 see

 : and nand not ;
 see

 : or not swap not and not ;
 see

 : - not 1 + + ;
 see

 : <> - 0# ;
 see

 : = <> not ;
 see

 : drop dup - + ;
 see

 : 2dup over over ;
 see

 : 2drop drop drop ;
 see

 : allot here @ + here ! ;
 see
 
 : , here @ ! cell allot ;
 see

 : >r rp@ @ swap rp@ ! rp@ cell - rp ! rp@ ! ;
 see

 : r> rp@ @ rp@ cell + rp ! rp@ @ swap rp@ ! ;
 see

 : branch rp@ @ dup @ + rp@ ! ;
 see
 : ?branch 0# not rp@ @ @ cell - and rp@ @ + cell + rp@ ! ;
 see
 
 : lit rp@ @ dup cell + rp@ ! @ ;
 see
 : ['] rp@ @ dup cell + rp@ ! @ ;
 see

 : rot >r swap r> swap ;
 see

 : 2* dup + ;
 : 2** 2* 2* 2* 2* 2* 2* 2* 2* ;
 : 80h 1 2* 2* 2* 2* 2* 2* 2* ;
 : IMMEDIATE 80h 2** 2** 2** ;
 see
 
 : immediate last @ cell + dup @ IMMEDIATE or swap ! ;
 see
 
 : ] 1 state ! ;
 see
 : [ 0 state ! ; immediate
 see
 
 : if ['] ?branch , here @ 0 , ; immediate
 see
 : then dup here @ swap - swap ! ; immediate
 see
 : else ['] branch , here @ 0 , swap dup 
     here @ swap - swap ! ; immediate
 see
 
 : begin here @ ; immediate
 see
 : again ['] branch , here @ - , ; immediate
 see
 : until ['] ?branch , here @ - , ; immediate
 see
 : while ['] ?branch , here @ 0 , ; immediate
 see
 : repeat swap ['] branch , here @ - , 
     dup here @ swap - swap ! ; immediate
 see
 
 : do here @ ['] >r , ['] >r , ; immediate
 see
 : loop ['] r> , ['] r> , ['] lit , 1 , ['] + , 
     ['] 2dup , ['] = , ['] ?branch , 
     here @ - , ['] 2drop , ; immediate
 see
 
 :  8 lit [ 4 4 + , ] ;
 see
 
 : 16 lit [ 8 8 + , ] ;
 see
 
 : bl lit [ 16 16 + , ] ;
 see

 : cr lit [ 8 2 + , ] emit ;
 see
 
 : nl lit [ 8 4 + 1 + , ] emit ;
 see

 : CHAR lit [ 16 1 - 2* 2* 2* 2* 16 1 - or , ] ;
 see

 : c@ @ CHAR and ;
 see

 : type 0 do dup c@ emit 1 + loop drop ;
 see
 
 : in> >in @ c@ >in dup @ 1 + swap ! ;
 see

 : parse in> drop >in @ swap 0 
        begin over in> <> while 1 + repeat 
        swap bl = if >in dup @ 1 - swap ! then ;
 see

 : word in> drop begin dup in> <> until >in @ cell - >in ! parse ;
 see
 
 : [char] ['] lit , bl word drop c@ , ; immediate
 see

 : ( [char] ) parse drop drop ; immediate
 see
 
 : ." [char] " parse type ; immediate
 see
 
 ." Hello world " cr
 
 ." That's all Folks !" cr
 
 words 
