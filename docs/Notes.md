# NOTES

*STILL A BUNCH (NOT ORGANIZED) OF IDEAS*

    Sectorforth and Milliforth was made for x86 and Z80 arch 
    and uses full 16-bit registers. 
 
    The way at 6502 is use page zero and lots of lda/sta.
 
    The way of RiscV and ARM is use linear memory and 32-bit registers.
 
    Focus in size not performance.
 
    why ? For understand better my skills, riscv code and thread codes
 
    how ? Programming a old Forth for new cpu ISAs
 
    what ? Design the best minimal Forth engine and vocabulary
 
## Changes
 
    Uses cell with 32-bits;
 
    All user structure, data (36 cells) and return (36 cells) stacks, 
    TIB (80 bytes), PAD (32 bytes) and locals (8 cells) are in sequence; 
 
    TIB and PAD grows forward, stacks grows backwards;
 
    No overflow or underflow checks;
 
    No numbers only words (yet);
 
    Only IMMEDIATE flag used as $80, no hide, no compile;
 
    As ANSI Forth 1983: FALSE is 0 and TRUE is -1 ;
 
## Remarks
 
    This code uses Minimal Indirect Thread Code, aka MITC;
 
    No TOS or ROS registers, all values keeped at stacks;
 
    Locals are fixed and not stack.

    PAD is for temporaries, formats, buffers, etc;  

    TIB (terminal input buffer) is like a stream;
 
    Only 7-bit ASCII characters, plus \n, no controls;
          ( later maybe \b backspace and \u cancel )
 
    Words must be between spaces, before and after;
 
    Words are case-sensitivy and less than 32 characters;
 
    No line wrap, do not break words between lines;
 
    No multiuser, no multitask, no checks, not faster;
 
## For Devs
 
    Chuck Moore uses 64 columns, be wise, obey rule 72 CPL; 
 
    Never mess with two underscore variables;
 
    Not using smudge, 
          colon saves "here" into "head" and 
          semis loads "lastest" from "head";
 
# For stacks
 
    The hardware stack is not used for this Forth;
 
    The hello_world.forth file states that stacks works to allow 
        : dup sp@ @ ; so spt must point to actual TOS;
    
    "when the heap moves forward, the stack moves backward"; 
 
    The stack movement to be:
        push is 'decrease and store'
        pull is 'fetch and increase'
 
    Stacks represented as (standart)
        (w1 w2 w3 -- u1 u2), (w1 w2 w3 -- u1 u2)
        data, return (before -- after), top at left.
        c unsigned 8-bit character, a 32-bit address,
        w signed 32-bit, u unsigned 32-bit,
 
## For RiscV
 
    A 32-bit processor with 32-bit address space and reduced ISA;
 
    The header order is LINK, HASH and code or references.
 
    No direct memory access, only by register as pointer.

    No register indexed offset, only immediate offsets.

## For Assembler:

    1. Why ".equ name, register", does not work ?
    Also r0 must ever be called as zero.

    I dunno about another way to make register name alias
    but using cpp to pre-process the alias, eg. 
    #define mytmp  t1     

    2. All memory access is by a register eg. 
    # load
        lw rd, offset (ro); 
    # save
        sw ro, offset (rd);
    
    3. Forth uses a 'user struct' with variables and pointers, then 
    for each memory reference "la rd, reference_memory" is really
    two instructions "auipc rd" and "li rd", or "addi rd, gp, offset"
    For sake of size better keep the reference in a register 
    and do offsets "lw rd, offser (rf)"

    reserve one register (usr) to keep the reference to 'user struct'
    and another (ipt) to hold the Forth instruction pointer

    4. The indirect code defaults:

```
wpull:
# load the index of data stack
        lw idx, SPT (usr)
# pull the value
        lw fst, 0 (idx)
# update the index
        addi idx, idx, +1 * CELL
# save the index
        sw idx, SPT (usr)
wpush:
# load the index of data stack
        lw idx, SPT (usr)
# update the index
        addi idx, idx, -1 * CELL
# pull the value
        sw fst, 0 (idx)
# save the index
        sw idx, SPT (usr)
```

    5. But which registers ?

    The convention for R32* ISA for interrupts, keeps ra, t0-t2, a0-a5
    and the gcc __attribute__((interrupt)) keeps which are used inside.

    The convention for R32* linux ecalls uses a0, a1, a2, a7 registers.

    Then best registers to use are s2-s11 and t3-t6. 

    All code must be align to CELL size, also the dictionary headers.
    
    6. The jal and jalr, save PC+4 in register ra,
    does only ONE level of call, more levels must 
    save the register ra elsewhere and load it at ret.

    7. the ELF format leaves for linux system define the real SP address stack, 
    better use it for save RA inside deep nested routines.

    8. The RiscV compressed instructions allow X8 to X15, as S0, S1, A0-A5, and 
    system ecalls uses A0, A1, A2 and A7. The _putc and _getc uses A3 as argument.
    
    9. The milliForth use S0 as pointer for user structure, S1 to hold the instruction 
    pointer IPT, and two groups of registers. A upper group A0, A1, A2, A7 for 
    routines without ecalls and a lower group A3, A4, A5, A6 for generic routines with ecalls.
        

## For Heaps

_"From a 6502 64k memory to a Risc-V 4GB memory, Mind the Gap."_

The milliforth-riscv is a memory program that runs in SRAM and Forth
thinks that is continous but limited, and grows silently. 

Really ?

Forth starts the compiled dictionary at end of code, 
because all memory is linear and equal, except some reserved for I/O.

RiscV CPUs are memory mapped, eg. the RP2350 includes 520KiB of SRAM 
in ten banks, first eigth banks (0-7) have bits 3:2 striped address 
access, the last two banks (8-9) are not striped.

The gcc linker ld, have memory map for .data, .text, .bss, .rodata 
sections and a default segment memory. 
    
Where are the .heap and .stack ? Forth needs those @!@

The Minimal Inderect Thread Code, for a linear memory model relies 
in known where are the primitives.
    
Maybe without .rodata, at end of .bss could be a good place to start...
    
 _For sake, 0x2000000 is a good place._

## For Hash

    _"AI uses hash code as word, Humans uses semantics as word"_
     [Liang Ng](https://www.youtube.com/watch?v=sSlM3Mr_9sI)
    
    Why not use hashes for words ?

    Moore once used size and first three characters of name as words
    in dictionary. Now with 32-bit CPUs the find of a word could be 
    easy, done just one comparation, and the header as: link, hash, code.

    To keep safe from colisions, check the hash of token inside colon (:)
    and when exists, block that token.

    Also could export a name:hash, to make a list for human reference.
    
    The hash over 0x00000000 to 0x7FFFFFFF, reserve -1 to IMMEDIATE flag

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
Splited the code of sector-riscv in two kinds, one using the traditional 
name header with /link, size+flag, name+pad/ and other using a 
hash header with /link, hash/.

This will simplify the lookup of dictionary, as just do one single 
comparation of 4-bytes, and reduce the problem of find where code 
starts before the name, which could be padded to align with 4-bytes.

The usual flags in Forth uses some high bits at the size byte 
of name c-str. 

In Riscv ISA, can't use /andi rd, rs, 0x8000000/ with the 31 bit, 
because the imm is restrict within +/- 2047. 
Some alternatives uses 2 or 3 instructions.

Using hash, there is no size+flag byte + name string, no more. 
Only four bytes hash with lower bit or higher bit as flags.

When the immediate flag (FLAG_IMM)
define 0x8000000 and 0x7FFFFFF as constants to mask it in hashes.
    
Can not calculate the hash within a assembler macro, 
need a program to calculate the hashes for primitives 
and make the headers by hand.

