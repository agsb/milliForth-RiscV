# milliForth-RiscV

*"To master riding bicycles you have do ride bicycles"*

    started at 23/07/2025, agsb@
    first version at 12/10/2025, @agsb
    minimal dictionary compiled words at 04/12/2025, @agsb

Please, vide [Changes](https://github.com/agsb/milliForth-RiscV/blob/main/docs/Changes.md) 
and [Notes](https://github.com/agsb/milliForth-RiscV/blob/main/docs/Notes.md)

Any Forth system depends on the I/O functions and
the executable linkable format (ELF) of the host system. 

The problem is reach a functional minimal code forth engine for RISCV ISA. 

This is an implementation of MilliForth (sector-forth) concept for RISCV ISA, 
using [Minimal Indirect Thread Code](https://github.com/agsb/agsb.github.io/blob/main/The_words_in_MTC_Forth.v4.pdf).

Milliforth uses a minimal set of functions and primitives for make a Forth.

This version with minimal code (.text), uses only 454 bytes, 
    388 bytes for Forth engine and 66 bytes for linux system I/O. 
    Not counting ELF headers. 
    Used 56 bytes to load ELF PIC address and 44 bytes for word headers.

No human WORDS. It uses DJB2 hash in headers. 

No Terminal Input Buffer, just an token-to-hash stream ascii parser.

Only use a IMMEDIATE flag, at MSBit (31) of hash, it also is NaN, 
used to indicate errors.

There are a file with more core words in native code to use.

## For Size

How shink to a minimal compiled size in a Risc-V ?

    1. do not need align, the size of opcodes is always 2 or 4 bytes;

    2. choose registers to maximize use of compressed riscv opcodes;

    3. warn the user about possible errors but abandon error checking;

    4. use streams, no buffers;

    5. do not speculate;

## For use

    The sector-riscv.S is working, also the extra-milliforth.S,
    could test by:

    **cat t0.f t1.f t2.f - | sh doit.sh | tee output**

    t0.f is a minimal set of words, same as test0-riscv.f;

    t1.f is a complement with hash and more words; 

    the hiphen refers to terminal (/dev/tty)

    Could test by:

    cat t0.f | sh doit.sh | tee z1

    cat t0.f t1.f | sh doit.sh | tee z2

    t1.f includes <builds create variable constant does> (_STUB_)
    
    PS. 

    Add a hyphen at end of cat files list to allow terminal I/O
            cat t0.f t1.f t2.f - > sh doit.sh 
            
    Some esoteric bug makes the first word to have hash error.

    The memory management is done by extend the dictionary 
        into .bss, by reserve .skip bytes, defaults to 64k * 4
        no linux calls for memory allocation. (Anyone ?)

    The source could be compiled with 'missed' hack and
        more extensive native code word set.

## No name, just a hash

*I AM AFR--- THA- THE LET--- IN THE LAS- ISS-- ABO--
FOR-- INC- USI-- ONL- THR-- LET--- NAM- FIE--- HAS
HAD THE OPP ..... EFF--- FRO- WHA- THE WRI--- WAN---*

[Full text](https://github.com/agsb/agsb.github.io/blob/main/notes/Essay.md)

The letter to the Editor of Forth Dimensions [Moore 1983] concerning 
the practice of storing names of Forth words as a count and first three characters,

A count and first three characters, four bytes was enough.

_"AI uses hash code as word, Humans uses semantics as word"_
     [Liang Ng](https://www.youtube.com/watch?v=sSlM3Mr_9sI)

In this century, computers uses hashes to compare contents, so why not 
use a 4 bytes hash to identify tokens ? 

This version of milliforth uses 32-bit DJB2 hash. It provide a fast 
comparation in compilations and have small footprint.

For a 32-bit DJB2 hash, collisions become highly probable after 
approximately 65,536 items which requires a damn huge dictionary.

## No Terminal Input Buffer

_"The melange must flow"_

_Chuck executes or compiles each word indiviually rather than line by line.
In fact Chuck doesn't really have lines. I will also go word by word rather
than line by line in aha._

[Jeff Fox](https://www.ultratechnology.com/enthflux.htm) ?

Why no Terminal Input Buffer ?

Forth is not a editor. Does not need of undo, redo, copy or paste.

The input is a stream, just flows tokens. 

A token is being defined, has been defined, or has not been defined and
Forth reacts.

## Internals

This version uses DJB2 hash for dictionary entries, uses relatives branches
and includes: 

```
minimal primitives:

    u@    return the address of user structure
    0#    if top of data stack is not zero returns -1 (0xFFFFFFFF)

    +     adds two values at top of data stack
    NAND  logic not-and the two values at top of data stack
    
    @     fetch a value of cell wich address at top of data stack
    !     store a value into a cell wich address at top of data stack

    :     starts compiling a new word
    ;     stops compiling a new word
    
    EXIT  ends a word

    KEY  get a char from default terminal (stdin)
    EMIT  put a char into default terminal (stdout)
        
only internals: 
    
    main, cold, warm, miss, warp, abort, quit,   
    token, skip, hash, scan, mask, 
    find, eval, compile, execute, immediate, comma,  
    unnest, next, pick, jump, nest, move

    ps. next is not the NEXT of FOR NEXT loop !    

with externals, ecall to linux:

    _getc, _putc, _exit, ( _fcntl, _init ) 

```

## Vocabulary

More words in native code are selectable in defines.S

Eg. extras:

    ;$      execute native code at instruction pointer (IP), vide Notes
    ABORT   restart the Forth interpreter
    BYE     ends the Forth, return to system
    .       show the cell at top of data stack in hexadecimal 
    $       next token is a signed integer hexadecimal number to TOS 
    
A full list of primitives in [Word Lists](https://github.com/agsb/milliForth-RiscV/blob/main/docs/WordsList.md)

## the Language

For Forth language primer see 
[Starting Forth](https://www.forth.com/starting-forth/)

For Forth from inside howto see
[JonasForth](http://git.annexia.org/?p=jonesforth.git;a=blob_plain;f=jonesforth.S;hb=refs/heads/master)

For A Problem Oriented Language see
[POL](https://www.forth.org/POL.pdf)

## References

[^11]: The linux ecall list: https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h)
[^10]: The milliforth-6502: https://github.com/agsb/milliForth-6502/
[^1]: The original milliForth: https://github.com/fuzzballcat/milliForth 
[^2]: The inspirational sectorForth: https://github.com/cesarblum/sectorforth/
[^3]: Mind-blowing sectorLISP: https://justine.lol/sectorlisp2/, https://github.com/jart/sectorlisp
[^4]: The miniforth: https://github.com/meithecatte/miniforth
[^5]: Forth standart ANSI X3.215-1994: http://www.forth.org/svfig/Win32Forth/DPANS94.txt
[^6]: Notes and Times: https://github.com/agsb/milliForth-6502/blob/acc2f8ddc6aafb2dec6346e90f5372ee16b38c8c/docs/Notes.md
[^9]: Evolution of Forth: https://dl.acm.org/doi/epdf/10.1145/234286.1057832 
        https://raw.githubusercontent.com/larsbrinkhoff/forth-documents/master/Evolution.pdf
[^7]: A minimal thread code for Forth: https://github.com/agsb/immu/blob/main/The_words_in_MTC_Forth.en.pdf
[^8]: Forth: A new way to program: https://adsabs.harvard.edu/full/1974A%26AS...15..497M (Astro. Astrophys. Suppl. 14, 497-511, 1974)
[^9]: Another sector Forth: https://github.com/meithecatte/miniforth

