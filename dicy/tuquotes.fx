
\ https://github.com/kt97679/forth-dev/blob/master/sod32/kernel.4

: ."  ( "ccc<quote>" --- )
\G Parse a string delimited by " and compile the following runtime semantics.
\G Runtime: type that string.
   POSTPONE (.") 34 WORD C@ 1+ ALLOT ALIGN ; IMMEDIATE 


: S"  ( "ccc<quote>" --- )
\G Parse a string delimited by " and compile the following runtime semantics.
\G Runtime: ( --- c-addr u) Return start address and length of that string. 
  STATE @ IF POSTPONE (S") 34 WORD C@ 1+ ALLOT ALIGN 
             ELSE 34 WORD COUNT POCKET PLACE POCKET COUNT THEN ; IMMEDIATE 

