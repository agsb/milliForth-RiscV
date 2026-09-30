\ where is the hash

 : L>H CELL + ; 

\ where is the code

 : L>B CELL + CELL + ; 

 \ make a header and preserve old PIKE. 
 : :NAME HERE PIKE @ : PIKE ! 0 STATE ! ; 

 \ make a body
 : :NONAME HERE 1 STATE ! ; 

 \ :NAME have a problem 
 \ when executing the second : changes state to 1 (compile)
