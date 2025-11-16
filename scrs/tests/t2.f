 
 
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
 : literal ['] lit , , ;
 : execute >r ;

 

