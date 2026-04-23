 
# Words List

## use

 ( w1 w2 -- w3 ; u1 u2 -- u1 ) 
 
    __botton at left top at right__ 
    __before -- after__
    __data stack ; return stack__ 

   | symbol | type | word 32 bits| 
   | -- | -- | -- |
   | w | signed | 32 |
   | a | address | 32 |
   | u | unsigned | 32 |
   | d | double  | 64 |
   | n | counter | 32 |
   | c | character | 8 |
   | [ ] | content of memory | 32 |

 ## Minimals

  | name | word | stacks | use | defined | 
  | -- | -- | -- | -- | -- | 
  | exit | EXIT | ( -- ; a -- ) | execute next word | core |
  | colon | : | ( -- ) | init a compiled word | core |
  | semis | ; | ( -- ) | ends a compiled word | core |
  | key | KEY | ( -- c ) | get a character from stdin | core |
  | emit | EMIT | ( c -- ) | put a character into stdout | core |
  | store | ! |  ( w1 w2 -- ) | [w2] = w1 | core |
  | fetch | @ |  ( w1 -- w2 ) | w2 = [w1] | core |
  | plus |  +  |  ( w1 w2 -- w3 ) | w3 = w2 + w1 | core |
  | nand | NAND | ( w1 w2 -- w3 ) | w3 = w2 NAND w1 | milli |
  | zeroq | 0# |  ( w1 -- w2 ) | w1 != 0 ? TRUE \| FALSE | milli |
  | userat | U@ | ( -- a ) | address of _user structure | milli |

 ## Extras

  | name | word | stacks | use | defined | 
  | -- | -- | -- | -- | -- | 
  | docode | ( ;$ ) | ( -- ) | execute native code at next dictionary cell | milli |
  | abort | ABORT | ( -- ) | restart interpreter | core |
  | bye | BYE | ( -- ) | ends Forth | core | 
  | dot | ( . ) | ( w -- ) | prints w in hexadecimal | core |
  | per | ( $ ) | ( -- w ) | accept a signed integer hexadecimal to stack | milli |

 ## Primitives

  | name | word | stacks | use | defined | 
  | -- | -- | -- | -- | -- | 
  | align | ALIGN | ( w1 -- w2 ) | w2 == w1 aligned 4 bytes | core |
  | not | NOT   | ( w1 -- w2 ) | two complement, w2 = 0 - w1 + 1 | core |
  | neg | NEG   | ( w1 -- w1 ) | one complement, w2 = invert bits of w1 | core |
  | dup | DUP   | ( w -- w w ) | ditto | core |
  | drop | DROP |  ( w -- ) | ditto | core |
  | over | OVER |  ( w1 w2 -- w1 w2 w1 ) | ditto | core |
  | swap | SWAP | ( w1 w2 -- w2 w1 ) | ditto | core |
  | rot | ROT   | ( w1 w2 w3 -- w2 w3 w1 ) | ditto | core |
  | nrot | -ROT | ( w1 w2 w3 -- w3 w1 w2 ) | ditto | core |
  | cfetch | C@ | ( w -- b ) | ditto | core |
  | cstore | C! | ( w1 w2 -- ) | ditto | core |
  | minus | - | ( w1 w2 -- w3 ) | w3 == w2 - w1 | core |
  | and | AND | ( w1 w2 -- w3 ) | w3 = w2 AND w1 | core |
  | or | OR | ( w1 w2 -- w3 ) | w3 = w2 OR w1 | core |
  | xor | XOR | ( w1 w2 -- w3 ) | w3 = w2 XOR w1 | core |
  | equ | = | ( w1 w2 - w3 )  | FALSE \| TRUE ? w2 == w1 | core |
  | less | \< | ( w1 w2 -- w3 ) | FALSE \| TRUE ? w2 > w1 | core |
  | rat | R@ | ( -- w ; w -- w ) | ditto | core |
  | rto | R\> | ( -- w ; w -- ) | ditto | core |
  | tor | \>R | ( w -- ; -- w ) | ditto | core |
  | rpat | RP@ | ( -- rp ) | ditto | exception |
  | rpto | RP! | ( rp -- ) | ditto | exception |
  | spat | SP@ | ( -- sp ) | ditto | exception |
  | spto | SP! | ( sp -- ) | ditto | exception |
  | branch | BRANCH | ( -- ) | todo | internal |
  | branchz | 0BRANCH | ( -- ) | todo | internal |
  | lit | LIT | ( -- w ) | todo | internal |
  | true | TRUE | ( -- -1 ) | ditto | core |
  | false | FALSE |  ( -- 0 ) | ditto | core |
  | one | 1 | ( -- 1 ) |  ditto | internal |
  | two | 2 | ( -- 2 ) |  ditto | internal |
  | cell | CELL | ( -- 4 ) | size in bytes of Forth cell | core |
  | nan | NAN | ( -- 0x80000000 ) | Not a Number, flag IMMEDIATE | internal |
  | rpzo | RP0 | ( -- rp0 ) | address to bottom of return stack | internal |
  | spzo | SP0 | ( -- sp0 ) | address to botton of data stack | internal |
  | state | STATE | ( -- c ) |  0 execute 1 compile | core |
  | latest | LAST | ( -- a ) | address of latest word link in dictionary | internal |
  | heap | HEAP | ( -- a ) | address of next cell in free memory aka DP | internal |
  | head | HEAD | ( -- a ) | initial address of free memory | internal |
  | tail | TAIL | ( -- a ) | final address of free memory | internal |
  | bymul | M* | ( w1 w2 -- w3 w4 ) | w1/w2 == w3 reminder w4 quotient | core |
  | bymod | \*/MOD | ( w1 w2 -- w3 w4 ) | w1 * w2 == w3 lower w4 upper | core |
  | twomul | 2* | ( w -- w * 2 ) | ditto | core |
  | twodiv | 2/ | ( w -- w / 2 ) | ditto | core |
  | lshift | LSHIFT | ( w1 w2 -- w1\<\< w2 ) | ditto | core |
  | rshift | RSHIFT | ( w1 w2 -- w1\>\> w2 ) | ditto | core |
  | plusto | +! | ( w1 w2 -- ) | [w1] = [w1] + w2 | core |

 ## Debug

  | name | word | stacks | use | defined | 
  | -- | -- | -- | -- | -- | 
  | splist | .S | ( -- ) | pretty print data stack | tools |
  | rplist | .R | ( -- ) | pretty print return stack | tools* |
  | dump | DUMP | ( a1 a2 -- ) | pretty print memory from a1 to a2 | tools* |
  | words | WORDS | ( -- ) | pretty print all compiled words backwards | tools |
  | sees | SEE | ( -- ) | pretty print latest word | tools |
  | show | SHOW | ( -- ) | shows variables and lists data and return stacks | tools* |
  | twodot | .. | ( w -- w ) | print TOS in hexadecimal, leave TOS | tools* |


