 
# Words List

## use

 ( w1 w2 -- w3 ; u1 u2 -- u1 ) 
 
 top at right , before -- after , data stack ; return stack 

   | symbol | type | word 32 bits| 
   | -- | -- | -- |
   | w | signed | 32 |
   | a | address | 32 |
   | u | unsigned | 32 |
   | d | double  | 64 |
   | n | counter | 32 |
   | c | character | 8 |
   | [] | content of memory | 32 |

 ## Minimals

 EXIT ( -- ; a -- )   
 COLON ( : )
 SEMIS ( ; )
 KEY    ( -- c )    ditto
 EMIT   ( c -- )    ditto
 STORE ( ! ) ( w1 w2 -- ) [w2] = w1
 FETCH ( @ ) ( w1 -- w2 ) w2 = [w1]
 NAND ( w1 w2 -- w3 ) w3 = w2 NAND w1
 PLUS ( + ) ( w1 w2 - w3 ) w3 = w2 + w1

 ZEROQ ( 0# ) ( w1 -- w2 ) TRUE | FALSE = w1 != 0
 USERAT ( U@ ) ( -- a ) address of _user structure

 ## Extras

 DOCODE ( ;CODE )
 ABORT ( -- ) restart interpreter
 BYE ( -- ) ends Forth
 DOT ( . ) ( w -- ) prints w in hexadecimal

 ## Primitives

 ALIGN  ( w1 -- w2 ) w2 == w1 aligned 4 bytes 
 NOT    ( w1 -- w2 ) two complement, w2 = 0 - w1 + 1
 NEG    ( w1 -- w1 ) one complement, w2 = invert bits of w1
 DUP    ( w -- w w )
 DROP   ( w -- )
 OVER   ( w1 w2 -- w1 w2 w1 )
 SWAP   ( w1 w2 -- w2 w1 )
 ROT    ( w1 w2 w3 -- w2 w3 w1 )
 NROT ( -ROT ) ( w1 w2 w3 -- w3 w1 w2 )
 CFETCH ( C@ ) ( w -- b )
 CSTORE ( C! ) ( w1 w2 -- )
 MINUS ( - ) ( w1 w2 -- w3 ) w3 == w2 - w1
 AND ( w1 w2 -- w3 ) w3 = w2 AND w1
 OR ( w1 w2 -- w3 ) w3 = w2 OR w1
 XOR ( w1 w2 -- w3 ) w3 = w2 XOR w1 
 EQU ( = ) ( w1 w2 - w3 )  FALSE | TRUE = w2 == w1
 LESS ( < ) ( w1 w2 -- w3 ) FALSE | TRUE =  w2 > w1 
 RAT ( R@ )
 RTO ( R> )
 TOR ( >R )
 RPAT ( RP@ )
 RPTO ( RP! )
 SPAT ( SP@ )
 SPTO ( SP! )
 BRANCH 
 BRANCHZ
 LIT    
 TRUE   ( -- -1 )
 FALSE  ( -- 0 )
 ONE ( 1 )  ditto
 TWO ( 2 )  ditto
 CELL ( -- 4 ) size in bytes of Forth cell
 NAN ( -- 0x80000000 ) Not a Number
 RPZO ( RP0 ) address to bottom of return stack
 SPZO ( SP0 ) address to botton of data stack
 STATE  0 execute 1 compile
 LAST   latest word address
 HEAP   next unused word in free memory
 HEAD   initial address of free memory
 TAIL   final address of free memory
 BYMUL ( M* ) ( w1 w2 -- w3 w4 ) w1/w2 == w3 reminder w4 quotient
 BYMOD ( \*/MOD ) ( w1 w2 -- w3 w4 ) w1 * w2 == w3 lower w4 upper
 TWOMUL ( 2* ) ( w -- w * 2 )
 TWODIV ( 2/ ) ( w -- w / 2 )
 LSHIFT 
 RSHIFT
 PLUSTO ( +! )

 ## Debug

 SPLIST ( %S )
 RPLIST ( %R )
 DUMP
 WORDS
 SEES
 SHOW
 TDOT ( .. )

