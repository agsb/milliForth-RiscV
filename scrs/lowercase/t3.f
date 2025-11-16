

 : && sp@ . drop rp@ . drop latest @ . drop heap @ . drop ;

 : sp0 lit [ sp@ , ] ;

 : rp0 lit [ rp@ , ] ;

 : $S sp0 sp@ begin 
        over over 
        = if drop drop exit then
        cell +
        dup cr . bl emit @ . drop 
        again ;

 : $R rp0 rp@ begin 
        over over 
        = if drop drop exit then
        cell +
        dup cr . bl emit @ . drop 
        again ;


