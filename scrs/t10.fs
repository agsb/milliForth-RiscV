\ where is the hash

 : L>H CELL + ; 

\ where is the code

 : L>B CELL + CELL + ; 

 \ make a header

 : :NAME HERE : 0 STATE ! ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ; 


