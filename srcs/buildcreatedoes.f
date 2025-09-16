
 : creates 
        here @ : last !
        here dup cell + cell + ,
        ['] exit ,
        ;

 : variables 
        creates 
        ['] lit ,
        here @ cell + cell + ,
        ['] exit ,
        ,
        ;
 
 /#--------------------------------------------------------------------
 : create here @ : last !
        ['] lit ,
        here @ cell + cell + ,
        ['] exit ,
        [ ;

 : cells lit [ 4 , ] ;

 : variable create cells allot ;

 : (;code)
        r> late ( pfa cfa ! ) 
        ;
 
 : ;code ['] (;code) [ ;

 : <builds 0 const ;

 : does> r> late pfa ! pscode (dodoes) ;

 : (dodoes)
        (--sp) = ip
        ip = w cell + @ ;
        w = w cell cell + + ;
        
