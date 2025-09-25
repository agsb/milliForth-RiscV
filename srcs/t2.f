
/ test 


0 1 2 3 4

%S

: ?S latest @ . drop heap @ . drop sp@ . drop rp@ . drop cr ;

see 

?S

bye



: hash here :  
        dup heap !
        cell + @ . ;

see

?S

hash void

?S

hash nand 

?S

hash exit

?S

hash :

?S

hash ;

?S

words

