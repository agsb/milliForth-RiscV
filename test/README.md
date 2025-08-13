# milliForth-ARM

*"To master riding bicycles you have do ride bicycles"*

started at 04/08/2025, agsb@
vide [Changes](https://github.com/agsb/millifort-ARM/blob/main/docs/Changes.md) and [Notes](https://github.com/agsb/millifort-ARM/blob/main/docs/Notes.md)

    _STILL a STUB_

This is an implementation of milliForth (sectorforth) concept for ARM ISA.

Milliforth uses a minimal set of primitives and functions for make a Forth.

This version uses DJB2 hashes in headers, instead of size+flags+name+pads. 

No human WORDS. The IMMEDIATE flag is the MSBit (31) of hash.

Options:

    compiler suit of RISCV: gcc riscv64-unknown-elf-* -Oz

    which memory map be used and pages size: default GCC
  
    simulator of ARM: using raspberry pi
    
    the heap and stack in memory: .heap at end of .bss, .stack elsewhere ?

    systems calls of core functions: linux ecalls
    
## ISA

the ARM is a 4 bytes (32-bit) cell CPU with 32-bit [ISA](https://developer.arm.com/documentation/den0013/d/Introduction-to-Assembly-Language/The-ARM-instruction-sets)

The milliForth is a program called by 'elsewhere alien operational system', and use registers ????. 

## Coding

For assembler, use gcc style with pre-processor directives eg. #define.

For now, using linux system in a Raspberry PI and gcc suit for a single core minimal footprint Forth thread.  

I hope it uses far less than 4k bytes, without a user dictionary.

The milliForth must use memory pointers for data stack and return stack, because does fetch and store from a special 'user structure', which contains the user variables for Forth (state, toin, last, here, spt, dpt, tout, once, heap, tail).

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
        
only internals: 
    
    main, cold, warm, quit, djb2, 
    token, skip, scan, getline, 
    tick, find, compile, execute, comma, memcopy 

    unnest, next, nest, pick, jump, 

    ps. exit is unnest, next is not the NEXT of FOR loop    

with externals:

    _getc, _putc, _exit, _init, 

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

## the Language

For Forth language primer see 
[Starting Forth](https://www.forth.com/starting-forth/)

For Forth from inside howto see
[JonasForth](http://git.annexia.org/?p=jonesforth.git;a=blob_plain;f=jonesforth.S;hb=refs/heads/master)

For A Problem Oriented Language see
[POL](https://www.forth.org/POL.pdf)

## Note

the originals files are edited for lines with less than 80 bytes

the bf.FORTH and hello_world.FORTH are from original milliForth[^1]

the my_hello_world.FORTH is adapted for miiliforth-6502

## References

[^11]: The linux ecall list: https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h)
[^10]: The milliforth-6502: https://github.com/agsb/milliForth-6502/
[^1]: The original milliForth: https://github.com/fuzzballcat/milliForth 
[^2]: The inspirational sectorForth: https://github.com/cesarblum/sectorforth/
[^3]: Mind-blowing sectorLISP: https://justine.lol/sectorlisp2/, https://github.com/jart/sectorlisp
[^4]: The miniforth: https://github.com/meithecatte/miniforth
[^5]: Forth standart ANSI X3.215-1994: http://www.forth.org/svfig/Win32Forth/DPANS94.txt
[^6]: Notes and Times: https://github.com/agsb/milliForth-6502/blob/acc2f8ddc6aafb2dec6346e90f5372ee16b38c8c/docs/Notes.md
[^7]: A minimal thread code for Forth: https://github.com/agsb/immu/blob/main/The_words_in_MTC_Forth.en.pdf


:
