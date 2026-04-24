# NOTES

    *STILL A BUNCH (NOT ORGANIZED) OF IDEAS*

## Why this ?

    Focus in size not performance.
 
    why ? For understand better my skills, riscv code and thread codes
 
    how ? Programming a old Forth for new cpu ISAs
 
    what ? Design the best minimal Forth engine and vocabulary
 
## 6502 and RISCV

    Sectorforth and Milliforth was made for x86 and Z80 arch 
    and uses full 16-bit registers. 
 
    The way at 6502 is use page zero and lots of lda/sta.
 
    The way of RiscV and ARM is use linear memory and 32-bit registers.
 
## Changes
 
    Uses cell with 32-bits;
 
    All user structure, data (36 cells) and return (36 cells) stacks, 

    Only IMMEDIATE flag used as $80000000, also used as NAN.
 
    As ANSI Forth 1983: FALSE is 0 and TRUE is -1 ;
 
    Uses DJB2 Hash instead of size-name-pad in header of words in
        dictionary.

    The header order is LINK, HASH and code or references.
 
    No Terminal Input Buffer (TIB), just a parser word-to-hash.

 ## NO MORE

    Those are no more used.

    ~~ Overflow or underflow stack checks.~~
 
    ~~Added a pack of 8 cells for scratch workspace, generic use.~~

    ~~TIB (80 bytes) and locals (8 cells) are in sequence;~~ 

    ~~PAD (84 bytes) and PIC (68 bytes) must be allocated if need;~~
 
    ~~TIB, PAD, PIC grows forward, stacks grows backwards;~~
 
    Those could be made by user if when need.

    Using compiled words, could define :

        PAD is for temporaries, formats, buffers, etc;  

        PIC is for number formating;

        TIB (terminal input buffer) is like a stream;

## Remarks
 
    This code uses Minimal Indirect Thread Code, aka MITC;
 
    No TOS or ROS registers, all values keeped at stacks;
 
    Only 7-bit ASCII characters, no controls;
 
    Words must be between spaces, before and after;
 
    Words are case-sensitivy and no length limit;
 
    No multiuser, no multitask, no checks, not faster;

    IMMEDIATE always toggle latest word flag immediate.
 
    No SMUDGE ou HIDDEN flags, colon saves HERE into FAUX and 
    semis loads FAUX into LATEST;
 
## For Devs
 
    Chuck Moore uses 16 lines. 

    Chuck Moore uses 64 columns. 

    Chuck Moore uses 22 deep stacks. 

    Why you need more ?
    
    Never mess with two underscore variables.
 
    When the heap moves forward, the stack moves backward. 
 
# For stacks
 
    The hardware stack is not used for this Forth;
 
    The hello_world.forth file states that stacks works to allow 
        : dup sp@ @ ; so spt must point to actual TOS;
    
    The stack movement to be:
        push is 'decrease and store'
        pull is 'fetch and increase'
 
    Stacks represented as (standart)
        (w1 w2 w3 -- u1 u2 ; w1 w2 w3 -- u1 u2)
        Read as (before -- after), top at left.
        c unsigned 8-bit character, a 32-bit address,
        w signed 32-bit, u unsigned 32-bit,
        (Data stack ; Return Stack)
 
## For RiscV
 
the RISCV is a 4 bytes (32-bit) cell CPU with 32-bit 
    [ISA](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf) 
or 
    [ISA](https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf)

A 32-bit processor with 32-bit registers, address space and reduced ISA;
 
There is no automatic pull and push of SP.

There is no immediate values in comparations.

Only 12-bits immediate adds (+/- 1024 bytes).

No direct memory access, only accessed using a register as pointer.

No register indexed offset, only immediate offsets (+/- 1024 bytes).

Use "link and jump" concept like old PDPs.

Have a ZERO dedicated register.

The milliForth uses registers r0, ra, sp, s0, s1, a0-a7, t0-t1. 

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
( sptr, rptr, state, last, heap ).

### For compiler options

    compiler suit of RISCV: gcc riscv64-unknown-elf-* -Oz

    which memory map be used and pages size: default GCC
  
    simulator of RISCV: qemu 
    
    the heap and stack: .heap at start of .bss, .stack at end of .bss.

    systems calls of core functions: linux ecalls

    system stack pointer: not used as Forth stack.


## Hell of Makefiles

In Linux, I use the GCC gnu toolchain, for Intel x*86*, ARMs and RiscVs.
there are a defined namespace for each chain, so:

For linux systems, x86-64-linux-gnu, riscv64-linux-gnu, arm-linux-gnueabi 
and for embeded systems riscv64-unknown-elf, arm-linux-gnueabi, arm-none-eabi.

The QEMU uses qemu-system and qemu-user packs.

My common parameters are: xxxx is the ISA


        $(GCCFLAGS) = -nodefaultlibs -nostartfiles -static -Oz \
                      -march=xxxx -mabi=xxxx 

        $(ASFLAGS) = -Wa,-alms=$@.lst 

        $(LDFLAGS) = -Wl,--stats

        $(PASS)gcc $(GCCFLAGS) $(LDFLAGS) $(ASFLAGS) -o $@.elf $@.S 2> err | tee out

        $(PASS)objdump -hdta $@.elf > $@.dmp

        $(PASS)readelf -a $(MY).elf > $(MY).map

        $(PASS)objcopy --dump-section .text=$(MY).sec $(MY).elf
        
        $(PASS)objcopy $(MY).elf -O binary $(MY).bin

        od --endian=little -A x -t x1 -v $(MY).sec > $(MY).hex

## Postpone Hack

__while 'tick was not in the compiled dictionary__

Forth standart (now) have postone instead of compile and [compile].

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

By the way, tick and comma are in compiled dictionary, 

: POSTPONE ' , ; IMMEDIATE ( classics )

## Colon and Semis

How do not use flags as SMUDGE or HIDDEM or else ?

The colon *:* makes a header by:
        1. copy HERE to FAUX
        2. copy LATEST to first cell;
        3. calculate the djb2 hash of the next token;
        4. copy hash to second cell;
        5. change STATE to compile (1);

In compile mode, all non immediate words are compiled, 
        and the immediate words are executed. 
    
The semis *;* ends the word by:
        1. copy FAUX to LATEST
        2. place a 'EXIT into last cell
        3. change STATE to execute (0);

## Missed Hack

When the compilation breaks, by error or missing word,
the STATE and LATEST are keepd in order but HERE was advanced with 
references of words compiled, that junk stays lost in heap. 

To clean heap, HERE must returns to value before start the last compilation. 

That is why FAUX exists, to keep last mark, then just need copy FAUX to HERE. 

Also need toggle STATE to interpret mode.

## CREATE and DOES>

   _ (from eforth ideas)_

CREATE place the data address in stack and compiles two EXIT, 
        the address of the first is saved at Forth variable BODY, 
        the data address is the cell after second EXIT;

DOES> uses the address in BODY to save the complile address of 
        what follows DOES>;

VARIABLE uses the data address to access a cell;
    
CONSTANT uses the data address to access a value;
    
BUFFER uses thr data address to access a array of bytes;

ARRAY uses the data address to access the nth byte;
    
Note by that way, DOES> is just one word and is not immediate.

## ;CODE CODE END-CODE

Those are classic methods to execute compiled native code in 
 dictionary. 

But ;CODE depends on CREATE and CODE END-CODE on DOCOL, to know
where jump to execute the native code.

In a RISCV with MITC, a better way is do a jump and link to IPT 
and end the native code with a return.

gonative:

    jarl ra, 0 (IPT)

    j next
    
## The whys:

    1. Why ".equ name, register", does not work ?
        Also r0 must ever be called as zero.

        I dunno about another way to make register name alias
        but using cpp to pre-process the alias, eg. 
        #define mytmp  t1     

    2. All memory access by a register
    
        # load a address
            la rd, label or literal

        # load a word
            lw rv, offset (rd); 
        
        # save a word
            sw rv, offset (rd);
    
    3. All comparations between registers

        # load a value +/- 1024

            addi, r1, zero, value

        # compare beq, bne, blt, bge etc

            beq r1, zero, offset
            or
            beq r1, r2, offset

    4. Forth uses a 'user struct' with variables and pointers, then 
    for each memory reference "la rd, reference_memory" is really
    two instructions 
        
            lui rd, %hi(address)
            addi rd, %lo(address)

            or

            addi rd, rp, offset
    
    For sake of size better keep the reference in a register 
    and do offsets "lw rd, offser (rf)" then reserve one register (usr)
    to keep the reference to 'user struct' and another (ipt) to hold 
    the Forth instruction pointer. Those must be keeped untouched.

    4. The pull and push code defaults:

```
wpull:
# load the index of data stack
        lw idx, SPT (usr)
# pull the value
        lw fst, 0 (idx)
# update the index
        addi idx, idx, +4
# save the index
        sw idx, SPT (usr)

wpush:
# load the index of data stack
        lw idx, SPT (usr)
# update the index
        addi idx, idx, -4
# push the value
        sw fst, 0 (idx)
# save the index
        sw idx, SPT (usr)
```

    Those are 4 instructions cycles (load/save) over minimal code (pull-push/update) .

    5. But which registers ?

    The convention for R32* ISA for interrupts, keeps ra, t0-t2, a0-a5
    and the gcc __attribute__((interrupt)) keeps which are used inside.

    The convention for R32* linux ecalls read and writes, 
        uses a0, a1, a2, a7 registers.

    Then best registers to use are s2-s11 and t3-t6 ? 

    All code must be align to CELL size, also the dictionary headers.
    
    The jal and jalr, save PC+4 in register ra,
        does only ONE level of call, more levels must 
        save the register ra elsewhere and load it at ret.

    The ELF format leaves for linux system define the real 
        SP address stack, better use it for save RA inside deep 
        nested routines.

    The RiscV compressed instructions allow X8 to X15, 
        as S0, S1, A0-A5, and system ecalls could use A0 to A7. 
        The _putc and _getc uses A0, A1, A2, A3, A7 and A3 as argument.
    
    The milliForth use S0 as pointer for user structure, 
        S1 to hold the instruction pointer IPT, and two groups of 
        registers. A upper group A0, A1, A2 for routines without 
        ecalls and a lower group A3, A4, A5, for generic routines, 
        with ecalls. A6 and A7 are scratch.

    In some debug and extras routines more registers could be used.
        
    Sumary:  

          sp not used
         
          jalr/jal uses ra
         
          s0,s1,a0,a1,a2,a3,a4,a5 (x8-x15) used for compact instruction
         
          a0,a1,a2,a3,a7 used by ecalls in _putc, _getc, _exit, etc
         
          a0,a1,a2 used as ecalls unsafe
         
          a4,a5,a6 used as ecall safe
         
          t0,t1,t2 used as counters
         
          t3,t4,t5,t6 used as holders for a0,a1,a2,a3 for ecalls
         
          s2 used to keep ra, two level threads
         
          a3 used as joker :)
         
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

The gcc linker ld, have memory map for .text, .rodata, .data, .bss
sections and a default segment memory. 
    
Where are the .heap and .stack ? Forth needs those @!@

The Minimal Inderect Thread Code, for a linear memory model relies 
in known where are the primitives.
    
Maybe without .rodata, at start of .bss could be a good place to start...
    
 _For sake, 0x2000000 is a good place._

## For Hash

_"AI uses hash code as word, Humans uses semantics as word"_
     [Liang Ng](https://www.youtube.com/watch?v=sSlM3Mr_9sI)
    
Why not use hashes for words ?

Moore once used size and first three characters of name as words
    in dictionary. Now with 32-bit CPUs the find of a word could be 
    easy, done just one comparation, and the header as: link, hash, code.

If need to keep safe from colisions, check the hash of token,  
    and when exists, block that name. 

Also export name:hash, to make a list for human reference.
    
The hash is over 0x00000000 to 0x7FFFFFFF, to reserve
the high bit is IMMEDIATE flag

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
Splited the code of sector-riscv in two kinds, one using the 
traditional name header with /link, size+flag, name+pad/ and other 
using a hash header with /link, hash/.

In 32-bit systems, the use of hash does far lesser size than using 
names in dictionary.

Pros:

This will simplify the lookup of dictionary, as just do one single 
comparation of 4-bytes, and reduce the problem of find where code 
starts before the name, which could be padded to align with 4-bytes.

The usual flags in Forth uses some high bits at the size byte 
of name c-str. 

Using hash, there is no size+flag byte + name string, no more. 
Only four bytes hash with lower bit or higher bit as flags.

When the immediate flag (FLAG_IMM)
define 0x8000000 and 0x7FFFFFF as constants to mask it in hashes.

## Not a Number

To represent short signed integer numbers is used the high bit 
of the MSB as signal indicator, eg for one byte, 00000001
to 01111111 ( 1 to 127 ) is positive, 00000000 is zero and 11111111 to
10000001 ( -1 to -127 ) is negative, and 10000000 is -128. 

In MilliForth, -128 is not a number ( NaN ) and is used to indicate 
numeric errors in conversion, overflow, undeflow, zero division.

Sure it is extended to 4 bytes cells. 

## Linux ecalls

https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/



