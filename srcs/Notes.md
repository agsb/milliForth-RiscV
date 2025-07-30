# NOTES

*STILL A BUNCH (NOT ORGANIZED) OF IDEAS*

    Sectorforth and Milliforth was made for x86 and Z80 arch 
    and uses full 16-bit registers. 
 
    The way at 6502 is to use page zero and lots of lda/sta.
 
    The way of RiscV is to use linear memory and 32-bit registers.
 
    Focus in size not performance.
 
    why ? For understand better my skills, riscv code and thread codes
 
    how ? Programming a old Forth for new 32-bit cpu ISA
 
    what ? Design the best minimal Forth engine and vocabulary
 
## Changes
 
    Uses cell with 32-bits;
 
    All user structure, data (36 cells) and return (36 cells) stacks, 
    TIB (80 bytes) and PIC (32 bytes) are in sequence; 
 
    TIB and PIC grows forward, stacks grows backwards;
 
    No overflow or underflow checks;
 
    No numbers only words;
 
    The header order is LINK, SIZE+FLAG, NAME+PAD.
 
    Only IMMEDIATE flag used as $80, no hide, no compile;
 
    As ANSI Forth 1983: FALSE is 0 and TRUE is -1 ;
 
## Remarks
 
    This code uses Minimal Indirect Thread Code, aka MITC;
 
    No TOS or ROS registers, all values keeped at stacks;
 
    PAD (scratchpad) is for temporaries, formats, buffers, etc;  

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
          colon saves "here" into "once" and 
          semis loads "lastest" from "once";
 
# For stacks
 
    The hardware stack is not used for this Forth;
 
    The hello_world.forth file states that stacks works to allow 
        : dup sp@ @ ; so spt must point to actual TOS;
    
    "when the heap moves forward, the stack moves backward"; 
 
    The stack movement to be:
        pull is 'fetch and increase'
        push is 'decrease and store'
 
    Stacks represented as (standart)
        (w1 w2 w3 -- u1 u2), (w1 w2 w3 -- u1 u2)
        data, return (before -- after), top at left.
        c unsigned 8-bit character, a 32-bit address,
        w signed 32-bit, u unsigned 32-bit,
 
## For RiscV
 
    A 32-bit processor with 32-bit address space and reduced ISA;
 
    No direct memory access, only by register as pointer.
    No register indexed offset, only immediate offsets.

    For Assembler:

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

    The indirect code defaults:

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

    But which registers ?

    The convention for R32* ISA for interrupts, keeps ra, t0-t2, a0-a5
    and the gcc __attribute__((interrupt)) keeps which are used inside.

    The convention for R32* linux ecalls uses a0, a1, a2, a7 registers.

    Then best registers to use are s2-s11 and t3-t6. 

    All code must be align to CELL size, also the dictionary headers.
    
## IDEAS

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

