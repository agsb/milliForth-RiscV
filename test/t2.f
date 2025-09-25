 
 : &S sp@ . drop rp@ . drop latest @ . drop heap @ . drop ;
 
 : fake here : 0 , ['] exit 0 state ! ;
 
 : hash . fake . dup heap ! cell + @ . ;

 see
 
 &S
 
 hash void .
 
 &S
 
 see
 
 bye 
 
 
 &S %S 
 
 see
 
 
 bye 
 
 see
 
 &S %S
 
 : hash fake wipe cell + @ ;
 
 see
 
 &S %S
 
 hash void . 
 
 see
 
 &S %S 
 
 : :noname here ] ;
 
 see
 
 &S %S
 
 
 
 bye
 
 %S :noname %S %R exit [
 
 see
 
 : hash header dup cell + @ . ;
 
 see
 
 &S %S
 
 hash void
 
 &S %S
 
 hash hash
 
 &S %S
 
 bye
 
