# Changes

## Todo

    1. parameters for gcc

    2. def_word macro, need resolve how to update
        link for each word to point the previous,
        linked list

    3.  Code could start at align 2 or must be at align 4 ?

## Done

30/07/2025


1. hashes in dictionary

    " there is no spoon "

    Going to use DJB2 hash for represent the words at dictionary.
    
    Splited the code of sector-riscv in two kinds, one using 
    the traditional name header with /link, size+flag, name+pad/ and
    other using a hash header with /link, hash/.

    This will simplify the lookup of dictionary, as just 
    do one single comparation of 4-bytes, and reduce the problem of
    find where code starts before the name, which could be padded to 
    align with 4-bytes.

    The usual flags in Forth uses some high bits at the size byte of 
    name c-str. 

    In Riscv ISA, can't use /andi rd, rs, 0x8000000/ with the 31 bit, 
    because the imm is restrict within +/- 2047. 
    Some alternatives uses 2 or 3 instructions.

    Using hash, there is no size+flag byte + name string, no more.
    Only four bytes hash with lower bits as flags.

    When the immediate flag (FLAG_IMM) is the bit 0, could use 
    /ori|andi|xori rd, rs, 0x1/ to test, set and flip the flag
    
    Catchs: 

    To clear the bit 0 use a shift left after hash calculation.
        
    All valid hashes will be even. 
        
    Can not calculate the hash within a macro, need a program to
    calculate the hashes for primitives and make the headers by hand

2. To load memory address
    
    Using /la rf, address/ one or two instructions, 
    and /addi rd, rf, offset * CELL/ one instruction. 

3. Sizes differs when use align 2 or align 2

29/07/2025

    Almost done the code from 6502 to Riscv.

    Still testing line parameters to gcc

    Need change the defword macro 

25/07/2025

    *A hell of Makefiles* 
    
    How define options to riscv-gnu-tools 
    (cpp,gcc,as,ld,strip,objdump)
    and keep chain $@.S $@.lst $@.out $@.elf $@.dmp

    For convenience, use CPP to name alias to registers

