# milliForth-RiscV

*"To master riding bicycles you have do ride bicycles"*

started at 23/07/2025, agsb@
first version at 12/10/2025, @agsb
minimal dictionary compiled words at 04/12/2025, @agsb

vide [Changes](https://github.com/agsb/milliForth-RiscV/blob/main/docs/Changes.md) 
and [Notes](https://github.com/agsb/milliForth-RiscV/blob/main/docs/Notes.md)

This is an implementation of MilliForth (sector-forth) concept for RISCV ISA.

Milliforth uses a minimal set of primitives and functions for make a Forth.

This version with minimal code (.text) uses only 528 bytes, 
    468 bytes of Forth engine and 60 bytes of linux system I/O, 
    not counting ELF headers. Used 48 bytes to load fixed address. 


Could add some bytes for extras words as 2/ 2* NAN ;CODE ABORT BYE

No human WORDS. It uses DJB2 hashes in headers, 
    instead of size+flags+name+pads. 

Only use a IMMEDIATE flag, at MSBit (31) of hash, also is NaN. 

## For Size

How shink to a minimal compiled size in a Risc-V ?

    1. do not need align, the size of opcodes is always 2 or 4 bytes;

    2. choose registers to maximize use of compressed riscv opcodes;

    3. warn the user about possible errors but abandon error checking;

    4. do not speculate;

## For use

    The sector-riscv.S is working, also the extra-milliforth.S,
    could test by:

    **cat t0.f t1.f t2.f | sh doit.sh | tee output**

    t0.f is a minimal set of words, same as test0-riscv.f;

    t1.f is a complemente with hash and more words; 

    t4.f is a complement with BrainFu*ck interpreter; 

    Could test by:

    cat t0.f | sh doit.sh | tee z1

    cat t0.f t1.f | sh doit.sh | tee z2

    t1.f includes <builds create variable constant does> (_STUB_)
    
    PS. 

    Some esoteric bug makes the first word to have hash error.

    All words in lowercase, maybe later could change to uppercase.
        
    ** Now a uppercase version is done, use it **

    The memory management is done by extend the dictionary 
        into .bss, by reserve .skip bytes, defaults to 64k * 4
        no linux calls for memory allocation. (Anyone ?)

    The source could be compiled with dismiss hack and
        more complementary native code word.

## Compiler Options

    compiler suit of RISCV: gcc riscv64-unknown-elf-* -Oz

    which memory map be used and pages size: default GCC
  
    simulator of RISCV: qemu 
    
    the heap and stack: .heap at end of .bss, .stack elsewhere.

    systems calls of core functions: linux ecalls

    system stack pointer: not used by Forth.
    
## ISA

the RISCV is a 4 bytes (32-bit) cell CPU with 32-bit 
    [ISA](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf) 
or 
    [ISA](https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf)

The milliForth is a ELF program called by 'elsewhere alien operational system', 
and use registers r0, ra, sp, s0, s1, a0-a7, t0-t1. 

## Coding

*"qemu -kernel loads the kernel at 0x80000000 and causes each hart (i.e. core of CPU) to jump there."*

For assembler, use [standart Risc-V](https://github.com/riscv-non-isa/riscv-asm-manual) style 
with pre-processor directives eg. #define.

For now, using riscv-unknown-elf-gcc suit with qemu emulator
for a single core minimal footprint Forth thread.  

It uses less than 1k byte, without extras and user dictionary.

The milliForth must use memory pointers for data stack and return stack, 
because does fetch and store from a special 'user structure', which 
contains the user variables for Forth 
(state, toin, last, here, sptr, dptr, head, tail).

## Postpone Hack

__while 'tick was not in the compiled dictionary__

Forth standart have postone, instead of compile, and [compile].

Charles Moore, in 1974 [^8] make use of precedence of word and STATE, 
to control between "always execute" STATE (0), 
"compile or execute" STATE (1), "always compile" STATE(2), 
using a extra STATE and a flag for precedence.

| situation | STATE | precedence 0 | precedence 1 | precedence 2 |
| --- | --- | --- | --- | --- |
| during execution | 0  | execute | execute | execute |
| during compilation | 1 | compile | execute | execute |
| after IMMEDIATE | 2 | compile | compile | execute |

Always compile is what POSTPONE does.

In Milliforth, precedence is the IMMEDIATE flag and could be 0 or 1, 

By the way, tick and comma are in compiled dictionary.

The postpone is : POSTPONE ' , ; ( classics )

## Colon and Semis

The colon **:** makes a header by:
        1. copy HERE to HEAD
        2. copy LATEST to first cell;
        3. calculate the djb2 hash of the next word on TIB;
        4. copy hash to second cell;
        5. change STATE to compile (1);

In compile state, all non immediate words are compiled, 
        and the immediate words are executed. 
    
The semis **;** ends the word by:
        1. place a 'EXIT into last cell
        2. copy HEAD to LATEST
        3. change STATE to execute (0);

if the compilation is interrupted, STATE and LATEST keeps 
        untouched, but some junk was placed and stays into dictionary.
        Could clean that with more some code.

## Dismiss hack

When the compilation of a word breaks, the LATEST are keepd in order 
but HERE was advanced with references of words compiled, that junk 
stays lost in heap. 

To clean just copy HEAD to HERE at error or missing.

With this dismiss hack, the HERE returns to previous value before 
start the last compilation.

## CREATE and DOES>

    (from eforth ideas)

CREATE place the data address in stack and compiles two EXIT, 
        the address of the first is saved at Forth variable TAIL, 
        the data address is the cell after second EXIT;

DOES> uses the address in TAIL to save the complile address of 
        what follows DOES>;

VARIABLE uses the data address to access a cell;
    
CONSTANT uses the data address to access a value;
    
ARRAY uses the data address to access the nth byte;
    
Note, DOES> is just one word and is no immediate.

## internals

This version uses DJB2 hash for dictionary entries, and includes: 

```
primitives:

    u@    return the address of user structure
    0#    if top of data stack is not zero returns -1 (0xFFFFFFFF)

    +     adds two values at top of data stack
    nand  logic not-and the two values at top of data stack
    
    @     fetch a value of cell wich address at top of data stack
    !     store a value into a cell wich address at top of data stack

    :     starts compiling a new word
    ;     stops compiling a new word
    
    exit  ends a word

    key   get a char from default terminal (stdin)
    emit  put a char into default terminal (stdout)
        
only internals: 
    
    main, cold, warm, quit, hash, djb2, 
    token, skip, scan, gets, 
    tick, find, compile, execute, comma,  
    unnest, next, nest, pick, jump, 

    ps. exit is unnest, nest is enter/docol,
        next is not the NEXT of FOR loop !    

with externals:

    _getc, _putc, _exit, _init, 

extras: (selectable)

    2/      shift right one bit
    NAN     places 0x80000000 at top of stack
    ;CODE   execute native code at instruction pointer (IP)

    abort   restart the Forth
    bye     ends the Forth, return to system
    beat   counts words executed by next

    .       show a copy of the cell at top of data stack, 
    .S      list cells in data stack
    .R      list cells in return stack
    words   list all compiled words in dictionary order
    dump    list contents of dictionary in memory order
    see     list compiled hash contents of last word 
    cell    sizeof a cell, 4 bytes, 32-bits

A my_hello_world.FORTH alternate version with dictionary for use;

The sp@ and rp@ are now derived from u@ in the my_hello_world.FORTH

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

the my_hello_world.FORTH is adapted for miiliforth-riscv

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
[^8]: Forth: A new way to program: https://adsabs.harvard.edu/full/1974A%26AS...15..497M (Astro. Astrophys. Suppl. 14, 497-511, 1974)
[^9]: Another sector Forth: https://github.com/meithecatte/miniforth

