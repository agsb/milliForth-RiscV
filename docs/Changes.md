_this file is still a stub_

# Adapt and survive

### the primitives
   
        +    ( w1 w2 -- w1+w2 ) unsigned addition
        nand ( w1 w2 -- NOT(w1 AND w2) )  not and 
        @    ( a -- w )  fetch the value at reference
        !    ( w a -- )  store the value in reference
        s@   ( -- a )    return veriable _state_ absolute reference
        0#   ( 0 -- 0x0000 | w -- 0xFFFF ) if tos is diferent of zero 

        :    ( -- ) init a word definition  
        ;    ( -- ) ends a word definition
        exit ( -- ) hook for inner interpret
        
### the user area pointers 

        state,  the state of Forth, compile or execute
        toin,   next free byte in terminal input buffer
        last,   latest word in dictionary
        here,   next free byte in heap dictionary (here)
        spt,    actual top of data stack
        rpt,    actual top of return stack
        tout,   
        once,   hold last here while compiling
        head,   heap pointer, forwards
        tail    stack pointer, backwards

### the hello_world file
    
        The changes on hello-world.FORTH to my-hello-world.FORTH, 
        to incorporate the modifications and recreate some words.

```
        :  8 4 4 + ;

        : 10 6 4 + ;

        : sp s@ 8 + ;

        : rp s@ 10 + ;

        All _sp@_ and _rp@_ changed to sp @ and rp @
```

### the extensions
        
        2/      ( w -- w>>1 )   shift right one bit
        exec    ( a -- )        jump to top of stack address
        >r      ( w -- )( -- w ) move from data into return stack
        r>      ( -- w )( w -- ) move from return into data stack

### the extras

        bye     ( -- )  ends the Forth
        abort   ( -- )  abort and reset
        .S      ( -- )  dumps the data stack
        .R      ( -- )  dumps the return stack
        dump    ( -- )  dumps the dictionary as binary
        words   ( -- )  dumps the dictionary as extended
        .       ( w -- w ) shows cell as hexadecimal


