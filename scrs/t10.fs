\ where is the hash

 : L>H CELL + ; 

\ where is the code

 : L>B CELL + CELL + ; 

 \ make a header

 : :NAME PIKE @ : PIKE ! 0 STATE ! ; 

 \ make a body

 : :NONAME HERE 1 STATE ! ; 


