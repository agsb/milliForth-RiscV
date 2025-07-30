# Changes


29/07/2025

    Almost done the code from 6502 to Riscv.

    Still glitches with line parameters to gcc

    Need change the defword macro, 
    sintax error when join size (3f-2f) and flags
    .byte (3f-2f) | flags   NOT WORK
    .byte (3f-2f) + flags   NOT WORK

25/07/2025

    *A hell of Makefiles* 
    
    How define options to riscv-gnu-tools 
    (cpp,gcc,as,ld,strip,objdump)
    and keep chain $@.S $@.lst $@.out $@.elf $@.dmp

    For convenience, use CPP to name alias to registers

