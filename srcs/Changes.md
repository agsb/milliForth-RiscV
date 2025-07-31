# Changes

## Todo

    1. parameters for gcc

    2. def_word macro, need resolve how to update
        link for each word to point the previous,
        linked list

    3.  Code could start at align 2 or must be at align 4 ?

    4.  How use of compressed ISA ?

## Done

31/07/2025

_"From a 6502 64k memory to a Risc-V 4GB memory, Mind the Gap."_

The milliforth-riscv is a memory program that runs in SRAM and Forth thinks that is continous but limited, and grows silently. 

Really ?

Forth starts the compiled dictionary at end of code, because all memory is linear and equal, except some reserved for I/O.

RiscV CPUs are memory mapped, eg. the RP2350 includes 520KiB of SRAM in ten banks, first eigth banks (0-7) have bits 3:2 striped address access, the last two banks (8-9) are not striped.

The gcc linker ld, have memory map for .data, .text, .bss, .rodata sections and a default segment memory. 
    
Where are the .heap and .stack ? Forth needs those @!@

The Minimal Inderect Thread Code, for a linear memory model relies in known where are the primitives.
    
Maybe without .rodata, at end of .bss could be a good place to start...
    
 _For sake, 0x2000000 is a good place._

30/07/2025

1. hashes in dictionary

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
Splited the code of sector-riscv in two kinds, one using the traditional name header with /link, size+flag, name+pad/ and other using a hash header with /link, hash/.

This will simplify the lookup of dictionary, as just do one single comparation of 4-bytes, and reduce the problem of find where code starts before the name, which could be padded to align with 4-bytes.

The usual flags in Forth uses some high bits at the size byte of name c-str. 

In Riscv ISA, can't use /andi rd, rs, 0x8000000/ with the 31 bit, because the imm is restrict within +/- 2047. Some alternatives uses 2 or 3 instructions.

Using hash, there is no size+flag byte + name string, no more. Only four bytes hash with lower bits as flags.

When the immediate flag (FLAG_IMM) is the bit 0, could use _ori|andi|xori rd, rs, 0x1_ to test, set and flip the flag
    
Catchs: 

To clear the bit 0 use a _andi rd, hsh, 0x1_ then _or hsh, hash, rd_ after hash calculation.
        
All valid hashes will be even. 
        
Can not calculate the hash within a macro, need a program to calculate the hashes for primitives and make the headers by hand.

2. To load memory address
    
Using _la rf, address_ one or two instructions, and _addi rd, rf, offset * CELL_, one instruction. 


29/07/2025

Almost done the code from 6502 to Riscv.

Still testing line parameters to gcc.

Need change the defword macro. 

25/07/2025

_A hell of Makefiles_

How define options to riscv-gnu-tools (cpp,gcc,as,ld,strip,objdump) and keep name as .S .lst .out .elf .dmp

For convenience, use CPP to name alias to registers.



