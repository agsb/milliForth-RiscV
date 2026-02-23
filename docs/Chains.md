_this file is still a stub_

# Adapt and survive

### the primitives
   
        +    ( w1 w2 -- w1+w2 ) unsigned addition
        nand ( w1 w2 -- NOT(w1 AND w2) )  not and 
        @    ( a -- w )  fetch the value at reference
        !    ( w a -- )  store the value in reference
        s@   ( -- a )    return _state_ absolute address reference
        0#   ( 0 -- 0x0000 | w -- 0xFFFF ) if tos is diferent of zero 

        :    ( -- ) init a word definition  
        ;    ( -- ) ends a word definition
        exit ( -- ) hook for inner interpret
        
### the user area pointers 

        state,  the state of Forth, compile or execute
        toin,   next free byte in terminal input buffer
        last,   latest word in dictionary
        here,   next free byte in heap dictionary (here)
        sptr,   actual top of data stack
        rptr,   actual top of return stack
        head,   last here, heap pointer, forwards
        tail    stack pointer, backwards

### the hello_world file
    
        The changes on hello-world.FORTH to my-hello-world.FORTH, 
        to incorporate the modifications and recreate some words.

```
        :  8 4 4 + ;

        : 10 6 4 + ;

        : sp u@ 0 + ;

        : rp u@ cell + ;

        : sp@ sp @ cell + ;

        : rp@ sp @ cell + ;

```

for _shift right_ look for
https://stackoverflow.com/questions/78708194/logical-shift-right-without-dedicated-shift-instruction

### the extensions (updated)
        
        2/      ( w -- w>>1 )   shift right one bit
        2*      ( w -- w<<1 )   shift left one bit
        nan     ( w -- $80 )    places -1 at top of stack
        beat    ( -- beats )    counts beats of inner loop
        exec    ( a -- )        execute the address at top of stack
        bye     ( -- )          ends the Forth

### the extras

        abort   ( -- )      abort and reset
        .       ( w -- w )  shows cell as hexadecimal
        .S      ( -- )      dumps the data stack
        .R      ( -- )      dumps the return stack

        dump    ( -- )  dumps the dictionary as binary
        see     ( -- )  dumps last word in dictionary 
        words   ( -- )  dumps the dictionary

### internals

        main, cold, warm, abort, quit
        resolve, token, gets
        tick, create, comma
        eval, execute, compile
        djb2


