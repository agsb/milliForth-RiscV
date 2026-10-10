
: (.") ( -- )
  R>             ( Get the address of the string data from the return stack )
  COUNT          ( Read the length byte and advance the pointer to the text )
  2DUP TYPE      ( Type out the string to the console )
  +              ( Add length to address to point past the end of the string )
  >R ;           ( Push the updated pointer back to the return stack )

: ." ( -- )
  [CHAR] " PARSE       ( Parse the input stream until the next " character )
  STATE @ IF           ( Are we compiling? )
    POSTPONE (.")      ( Compile the runtime printer primitive )
    DUP ,              ( Compile the length of the string into the dictionary )
    HERE SWAP DUP ALLOT( Allocate space in the dictionary for the string bytes )
    CHARS MOVE         ( Move the parsed string data into that allocated space )
  ELSE
    TYPE               ( If interpreting, just print it directly )
  FI ; IMMEDIATE       ( Mark the word as IMMEDIATE so it runs during compilation )

