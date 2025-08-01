# Changes

## Todo

    1. parameters for gcc

    2. def_word macro, need resolve how to update
        link for each word to point the previous,
        linked list

    3.  Code could start at align 2 or must be at align 4 ?

    4.  How use of compressed ISA ?

## Done

01/07/2025

    Using GCCFLAGS = -nostartfiles -nodefaultlibs \
                     -march=rv32ic -mabi=ilp32 -static -Oz

    size of 0x26C, using s2-s7 and t3-t6, mix 32-bit and 16-bit 
    opcodes, No errors. 

    Now try optimize for:

        Use zero (x0), ra (x1), sp (x2), s0 (x8), s1 (x9), a1-a5 (x10-x15)

        Keep just one level of call, no need backup for ra

        Use sp as reference pointer of user struct with offset

        Use s0 as forth instruction pointer

        ecall uses a0, a1, a2, a7, always 32-bit size

        keep a0, a1, a2, in memory while ecalls


31/07/2025

_"From a 6502 64k memory to a Risc-V 4GB memory, Mind the Gap."_

    Moved .ends: to end of .bss, so dictionary starts at .heap 

    (relies in .dat, .text, .rodata, .bss linker order) 

    
30/07/2025

1. hashes in dictionary

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
With the immediate flag (FLAG_IMM) is the bit 0, could use _ori|andi|xori rd, rs, 0x1_ to test, set and flip the flag
    
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



