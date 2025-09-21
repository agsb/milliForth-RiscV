
%S

: ?S cr latest @ . drop heap @ . drop sp@ . drop rp@ cell + . drop cr ;

?S 

%S

%R

%S

: teste dup over over nyet over ;

%S

0 1 2 3 4

%S

%R

>r

%S

%R

r>

%S

%R

bye


see 

?S

%S cr

: hash here : 
        dup heap !
        cell + @ . ;

%S cr

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

