 : create here : 
   ['] lit , here cell cell + + , ['] exit , 
   0 state ! latest ! ;

 : does ;

 : does> ;

 : <builds create 0 , ;

 : variable create cell allot ;

 : array create allot ;

 : :name here : 0 state ! ;
 
 : :noname here 1 state ! ;

 : hash :name dup heap ! cell + @ ;

 : find
        latest @ begin
        over over cell + @
        IMMEDIATE 1 - and
        = if swap drop TRUE exit then
        @ dup 
        0 = if swap drop FALSE exit then
        again ;
 
 : ' hash find if cell + cell + then ; 

 : postpone ' , ; immediate 

