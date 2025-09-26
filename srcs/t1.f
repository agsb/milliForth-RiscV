 
 
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

 : *& sp@ . drop rp@ . drop latest @ . drop heap @ . drop ;
 
 : :name here : 0 state ! ;
 
 : :noname here 1 state ! ;

 : hash :name dup heap ! cell + @ ;
 
 : create here :  
        ['] lit , here cell cell + + , ['] exit , 
        0 state !  latest !  ;

 : does ;

 : does> ;

 : <builds create 0 , ;

 : variable create cell allot ;

 : array create allot ;


