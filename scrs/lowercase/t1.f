 
 
 : for ['] >r , begin ; immediate
 : next ['] r> , ['] lit , [ 1 ] , ['] - , 
   ['] dup , ['] 0# , ['] ?branch ,
   here - , ['] drop , ; immediate

 : hook begin >r ;
 : back r> again ;
 : ?back r> until ;

 : swip >r swap r> ; 
 : rot swip swap ;
 : -rot swap swip ;
 : flip swap swip swap ;

 : dovar r> dup cell + >r ;
 : docon r> dup cell + >r @ ;
 : literal lit lit , , ;
 : execute >r ;

 : sp0 lit [ sp@ , ] ;

 : rp0 lit [ rp@ , ] ;

 : && sp@ . drop rp@ . drop latest @ . drop heap @ . drop ;
 
 : :name here : 0 state ! ;
 
 : :noname here 1 state ! ;

 : create here : 
   ['] lit , here cell cell + + , ['] exit , 
   0 state ! latest ! ;

 : does ;

 : does> ;

 : <builds create 0 , ;

 : variable create cell allot ;

 : array create allot ;

 : hash :name dup heap ! cell + @ ;
 
 : seek latest @ . begin
        over over cell + @ 
        IMMEDIATE 1 - and
        = if swap drop TRUE
          else @ dup 
               if FALSE 
               else swap drop TRUE 
               then
          then 
        until 
        dup if cell + cell + then
        ;

 : ' hash seek ;

 ( locators, Bill Ragsdale, FIG_FORTH meet 26/09/2025 )
 ( link_list, selector_hash, payload_wherever )

 ( variable mylist 0 mylist ! )
 ( mylist link, 101 , ," message 101 " )
 ( mylist link, 404 , ," message 404 " )
 ( mylist link, 501 , ," message 501 " )
 ( mylist link, 999 , ," message 999 " )

 ( variable dolist 0 dolist ! )
 ( : exec-999 ," execute in 999 " )
 ( : exec-501 ," execute in 501 " )
 ( : exec-404 ," execute in 404 " )
 ( : exec-101 ," execute in 101 " )
 ( dolist link, 999 , ['] exec-999 )
 ( dolist link, 501 , ['] exec-501 )
 ( dolist link, 404 , ['] exec-404 )
 ( dolist link, 101 , ['] exec-101 )

 : postpone ' , ;

 : link, here over @ @ , swap ! ;

 : .search begin @ 2dup cell + @ =
        if nip cell + cell + TRUE exit then
        dup @ 0 = if 2drop FALSE exit then
        agin ;
 
 : .message
        .search
        if count type
        else ," no message found "
        then ;
 
 : .execute
        .search
        if @ execute
        else ," no compiled code found "
        then ;

         
