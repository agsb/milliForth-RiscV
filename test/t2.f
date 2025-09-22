
0 1 2 3 4

%S cr

: hash here : 
        dup heap !
        cell + @ . ;

see

: hash  here . : 
        here . drop
        dup . heap . !
        cell + . @ . %S ;

see

?=

hash void

?=

hash nand 

?=

hash exit

?=

bye

: defer here : latest ! ['] exit ['] exit ;

words

