 
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
  | docode | ( ;CODE ) | execute native code at next cell | FigForth |
  | abort | ABORT | ( -- ) | restart interpreter | core |
  | bye | BYE | ( -- ) | ends Forth | core | 
  | dot | ( . ) | ( w -- ) | prints w in hexadecimal | core |

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
  | xor | XOR | ( w1 w2 -- w3 ) | w3 = w2 XOR w1 |   core |
  | equ | = | ( w1 w2 - w3 )  | FALSE | TRUE = w2 == w1 | core |
  | less | < | ( w1 w2 -- w3 ) | FALSE | TRUE =  w2 > w1 | core |
  | rat | R@ | ( -- w ; w -- w ) | ditto | core |
  | rto | R> | ( -- w ; w -- ) | ditto | core |
  | tor | >R | ( w -- ; -- w ) | ditto | core |
  | rpat | RP@ | ( -- rp ) | ditto | core |
  | rpto | RP! | ( rp -- ) | ditto | core |
  | spat | SP@ | ( -- sp ) | ditto | core |
  | spto | SP! | ( sp -- ) | ditto | core |
  | branch | BRANCH | ( -- ) | todo | core |
  | branchz | 0BRANCH | ( -- ) | todo | core |
  | lit | LIT | ( -- w ) | todo | core |
  | true | TRUE | ( -- -1 ) | ditto | core |
  | false | FALSE |  ( -- 0 ) | ditto | core |
  | one | 1 | ( -- 1 ) |  ditto | core |
  | two | 2 | ( -- 2 ) |  ditto | core |
  | cell | CELL | ( -- 4 ) | size in bytes of Forth cell | core |
  | nan | NAN | ( -- 0x80000000 ) | Not a Number | core |
  | rpzo | RP0 | ( -- rp0 ) | address to bottom of return stack | core |
  | spzo | SP0 | ( -- sp0 ) | address to botton of data stack | core |
  | state | STATE | ( -- c ) |  0 execute 1 compile | core |
  | latest | LAST | ( -- a ) | address of latest word address | core |
  | heap | HEAP | ( -- a ) | address of next cell in free memory aka DP | core |
  | head | HEAD | ( -- a ) |  initial address of free memory | core |
  | tail | TAIL | ( -- a ) |  final address of free memory | core |
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
  | splist | %S | ( -- ) | pretty print data stack | debug |
  | rplist | %R | ( -- ) | pretty print return stack | debug |
  | dump | DUMP | ( a1 a2 -- ) | pretty print memory from a1 to a2 | debug |
  | words | WORDS | ( -- ) | pretty print all compiled words backwards | debug |
  | sees | SEE | ( -- ) | pretty print latest word | debug |
  | show | SHOW | ( -- ) | shows variables and lists data and return stacks | debug |
  | twodot | .. | ( w -- w ) | print TOS in hexadecimal, leave TOS | debug |


