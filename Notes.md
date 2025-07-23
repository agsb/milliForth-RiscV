# Notes

started at 23/07/2025, agsb@

This will be an implementation of MilliForth (sectorforth) concept for RISCV ISA.

Milliforth uses a minimal set of primitives and functions for Forth.

Must define:

    a compiler suit of RISCV
    a simulator of RISCV
    a library of core functions of RISCV

    how do getc and putc for key and emit
    which memory map be used and pages size
    where is the heap and stack in memory
    
## ISA

the RISCV is a 4 bytes (32-bit) cell CPU with 32-bit [ISA](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf) or [ISA](https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf)

The milliForth will be a program called by elsewhere alien operational system, then use of temporary registers T0-T6, because they are expendable bettween function calls.

The milliForth uses memory pointers for data stack, return stack. They must be memory pointers because are acessed using fetch and store words from a special structure called s.

## Coding

This version includes: 

```
primitives:
    s@    return the address of user structure
    +     adds two values at top of data stack
    nand  logic not and the two values at top of data stack
    @     fetch a value of cell wich address at top of data stack
    !     store a value into a cell wich address at top of data stack
    0#    test if top of data stack is not zero

    :     starts compilng a new word
    ;     stops compiling a new word
    exit  ends a word

    key   get a char from default terminal (system dependent)
    emit  put a char into default terminal (system dependent)
        
internals: 
    spush, spull, rpull, rpush, (stack code)
    copyfrom, copyinto, (heap code)
    cold, warm, quit, token, skip, scan, getline, (boot and terminal)
    parse, find, compile, execute, (outer interpreter)

    unnest, next, nest, pick, jump, (mtc inner)

    ps. next is not the FOR NEXT loop    

externals:

    getch, putch, byes (depends on system, used minimal for emulator )

extensions: (selectable)

    2/      shift right one bit
    exec    jump to address at top of spt
    :$      jump to (ipt)   
    ;$      jump to next 

extras:    (selectable)

    bye     ends the Forth, return to system
    abort   restart the Forth
    .S      list cells in data stack
    .R      list cells in return stack
    .       show cell at top of data stack
    words   extended list the words in dictionary
    dump    list contents of dictionary in binary

A my_hello_world.FORTH alternate version with dictionary for use;

The sp@ and rp@ are now derived from s@ in the my_hello_world.FORTH

```

    
