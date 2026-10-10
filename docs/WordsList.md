 
# Words List

## Use

 ( w1 w2 w3 -- w4 w5 ; u1 u2 -- u1 ) 
 
 __botton at left top at right__ 
 __before -- after__
 __data stack ; return stack__ 

 | symbol | type | bits | 
 | -- | -- | -- |
 | w | signed | 32 |
 | a | address | 32 |
 | u | unsigned | 32 |
 | d | double | 64 |
 | n | counter | 32 |
 | c | character | 8 |
 | [ ] | content of memory | 32 |
 |   |   |   |   |   |

 values are 32-bit signed integers

 ## Minimals

 | name | word | stacks | use for | set | 
 | -- | -- | -- | -- | -- | 
 | exit | EXIT | ( -- ; -- ) | ends execution | core |
 | colon | : | ( -- ) | init compilation | core |
 | semis | ; | ( -- ) | exit compilation | core |
 | key | KEY | ( -- c ) | get a character from stdin | core |
 | emit | EMIT | ( c -- ) | put a character into stdout | core |
 | store | ! | ( w1 w2 -- ) | [w2] = w1 | core |
 | fetch | @ | ( w1 -- w2 ) | w2 = [w1] | core |
 | plus | + | ( w1 w2 -- w3 ) | w3 = w1 + w2 | core |
 | nand | NAND | ( w1 w2 -- w3 ) | w3 = w1 NAND w2 | milli |
 | zeroq | 0# | ( w1 -- w2 ) | w1 != 0 ? TRUE \| FALSE | milli |
 | userat | U@ | ( -- a ) | address of _user structure | milli |
 |   |   |   |   |   |

 ## Extras

 | name | word | stacks | use | defined | 
 | -- | -- | -- | -- | -- | 
 | nan | NaN | ( -- w ) | place NaN 0x80000000 at TOS | milli |
 | lshift | LSHIFT | ( w1 w2 -- w1\<\< w2 ) | ditto | core |
 | rshift | RSHIFT | ( w1 w2 -- w1\>\> w2 ) | ditto | core |
 | docode | ( ;$ ) | ( -- ) | execute native code at next dictionary cell | milli |
 | abort | ABORT | ( -- ) | restart interpreter | core |
 | bye | BYE | ( -- ) | ends Forth | core | 
 | lit | LIT | ( -- w ) | place next dictionary cell at TOS, advance IP | core |
 | dolar | ( $ ) | ( -- w ) | inputs a value, in hexadecimal, into stack | milli |
 | dot | ( . ) | ( w -- ) | outputs a value, in hexadecimal, from stack | core |
 |   |   |   |   |   |

 ## Extendeds

 | name | word | stacks | use | defined | 
 | -- | -- | -- | -- | -- | 
 | align | ALIGN | ( w1 -- w2 ) | w2 == w1 aligned 4 bytes | core |
 | not | NOT | ( w1 -- w2 ) | two complement, w2 = 0 - w1 + 1 | core |
 | neg | NEG | ( w1 -- w1 ) | one complement, w2 = invert bits of w1 | core |
 | dup | DUP | ( w -- w w ) | ditto | core |
 | drop | DROP | ( w -- ) | ditto | core |
 | over | OVER | ( w1 w2 -- w1 w2 w1 ) | ditto | core |
 | swap | SWAP | ( w1 w2 -- w2 w1 ) | ditto | core |
 | rot | ROT | ( w1 w2 w3 -- w2 w3 w1 ) | ditto | core |
 | nrot | -ROT | ( w1 w2 w3 -- w3 w1 w2 ) | ditto | core |
 | cfetch | C@ | ( w -- b ) | ditto | core |
 | cstore | C! | ( w1 w2 -- ) | ditto | core |
 | minus | - | ( w1 w2 -- w3 ) | w3 == w2 - w1 | core |
 | and | AND | ( w1 w2 -- w3 ) | w3 = w2 AND w1 | core |
 | or | OR | ( w1 w2 -- w3 ) | w3 = w2 OR w1 | core |
 | xor | XOR | ( w1 w2 -- w3 ) | w3 = w2 XOR w1 | core |
 | equ | = | ( w1 w2 - w3 ) | w2 == w1 ? TRUE \| FALSE | core |
 | less | \< | ( w1 w2 -- w3 ) | w1 < w2 ? TRUE \| FALSE | core |
 | rat | R@ | ( -- w ; w -- w ) | ditto | core |
 | rto | R\> | ( -- w ; w -- ) | ditto | core |
 | tor | \>R | ( w -- ; -- w ) | ditto | core |
 | rpat | RP@ | ( -- rp ) | ditto | exception |
 | rpto | RP! | ( rp -- ) | ditto | exception |
 | spat | SP@ | ( -- sp ) | ditto | exception |
 | spto | SP! | ( sp -- ) | ditto | exception |
 | branch | BRANCH | ( -- ) | jump to relative by next dictionary cell value | internal |
 | branchz | 0BRANCH | ( -- ) | branch if TOS is 0 | internal |
 | true | TRUE | ( -- -1 ) | push TRUE to stack | core |
 | false | FALSE | ( -- 0 ) | push FALSE to stack | core |
 | cell | CELL | ( -- 4 ) | size in bytes of Forth cell | core |
 | state | STATE | ( -- c ) | 0 execute 1 compile 2 postpone ? | core |
 | last | LAST | ( -- a ) | address of last node of linked list dictionary, aka LATEST | internal |
 | heap | HEAP | ( -- a ) | address of next unnused cell in free memory, aka DP | internal |
 | pike | PIKE | ( -- a ) | address of last HEAP before compiling | internal |
 | rpzo | RP0 | ( -- rp0 ) | constant address to bottom of return stack | internal |
 | spzo | SP0 | ( -- sp0 ) | constant address to botton of data stack | internal |
 | bymul | M* | ( w1 w2 -- w3 w4 ) | w1/w2 == w3 reminder w4 quotient | core |
 | bymod | \*/MOD | ( w1 w2 -- w3 w4 ) | w1 * w2 == w3 lower w4 upper | core |
 | perform | PERFORM | ( a -- ) | execute native code at address on top of stack | proposed* |
 |   |   |   |   |   |

 ## Debug

 | name | word | stacks | use | defined | 
 | -- | -- | -- | -- | -- | 
 | splist | .S | ( -- ) | pretty print data stack | tools |
 | rplist | .R | ( -- ) | pretty print return stack | tools* |
 | words | WORDS | ( -- ) | pretty print all compiled words backwards | tools |
 | see | SEE | ( -- ) | pretty print latest word | tools |
 | show | SHOW | ( -- ) | shows variables and lists data and return stacks | tools* |
 | twodot | .. | ( w -- w ) | print TOS in hexadecimal, DUP DOT | tools* |
 | dump | DUMP | ( a1 a2 -- ) | pretty print memory from a1 to a2 | tools* |
 |   |   |   |   |   |

