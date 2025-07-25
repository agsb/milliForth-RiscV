# Notes

*"To master riding bicycles you have do ride bicycles"*

started at 23/07/2025, agsb@

This will be an implementation of MilliForth (sectorforth) concept for RISCV ISA.

Milliforth uses a minimal set of primitives and functions for make a Forth.

Must define:

    a compiler suit of RISCV:   gcc riscv64-unknown-elf-*
    a simulator of RISCV:    spike
    
    which memory map be used and pages size:    start 0x80000000, page 4096
    
    where is the heap and stack in memory:    for a 4GB real memory in qemu VM, about 18GB 
    
    a library of core functions of RISCV:

    how do getc and putc for key and emit
    
## ISA

the RISCV is a 4 bytes (32-bit) cell CPU with 32-bit [ISA](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf) or [ISA](https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf)

The milliForth is a program called by 'elsewhere alien operational system', and use of registers A2-A7, 
because they are caller saved between function calls, and T3-T5, as scratch. 

## Coding

*"qemu -kernel loads the kernel at 0x80000000 and causes each hart (i.e. core of CPU) to jump there."*

For assembler, use [standart Risc-V](https://github.com/riscv-non-isa/riscv-asm-manual) style without pre-processor directives like #define.

For now, using riscv-unknown-elf-gcc 15.0 suit with spike and qemu emulators for a single core minimal footprint Forth thread.  I hope it uses far less than 4k bytes, without a dictionary.

The milliForth must use memory pointers for data stack and return stack, because does fetch and store from a special 'user structure', which contains the user variables for Forth (state, toin, last, here, sp, dp, tout, back, heap, tail).

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

    
