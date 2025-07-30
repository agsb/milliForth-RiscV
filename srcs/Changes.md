# Changes

## Todo

    1. parameters for gcc

    2. def_word macro, need resolve how to update
        link for each word to point the previous,
        linked list

    3. force use of 'addi rd, gp, offset' instead 
        auipc rd, offset (31-12); addi rd, rd, (11-0)

    4.

## Done

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

