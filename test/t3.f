

 : && sp@ . drop rp@ . drop latest @ . drop heap @ . drop ;

 : sp0 lit [ sp@ , ] ;

 : rp0 lit [ rp@ , ] ;

 : dumps begin over over 
        = if drop drop exit then
        cell +
        dup cr . bl emit @ . drop 
        again ;

 : $S sp0 sp@ dumps ; 

 : $R rp0 rp@ dumps ;


