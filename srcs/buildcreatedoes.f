
;#--------------------------------------------------------------------
; classic
; THE ROAD TOWARDS A MINIMAL FORTH ARCHITECTURE, Mikael Patel, 1990

 : : ( -- ) create ] does >r ;

 : variable ( -- ) create 0 , does> ;
 
 : constant ( x -- ) create , does> @ ;

;#--------------------------------------------------------------------
; alternative
; https://www.reddit.com/r/Forth/comments/yuytb2/whats_the_usecase_for_create_does/

 : lit, ( x -- ) postpone literal ;
 
 : constant ( x "name" -- )  >r :  r> lit,  postpone ;  ;
 
 : variable ( "name" -- ) align here 0 , constant ;


;#--------------------------------------------------------------------
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
 
 ;#--------------------------------------------------------------------
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
        
