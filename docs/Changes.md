# Changes

## Todo

    ?   def_word macro, need resolve how to update
        link for each word to point the previous,
        linked list

## Done

14/08/2025

    Done djb2 hashes for extras.

    Compiling without extras, no errors, but still does no work.
    With extras, comes strange linker errors. 

    routine djb2 tested and okey

12/08/2025

    included extras-milliforth for support and debug
    
    still in debugs

09/08/2025

    Risc-V does not handle stack push and pull. The ISA allow any 
    register acts as stack, but by convention x2 is SP and the linux 
    loader sets SP to a default memory space.

    MilliFort does not use the SP as language stack, only for internal
    calls to hold the return address.

    The dictionary grows from the end of .bss and don't know where the 
    idefault elf SP points. 

    Usually push, decrements SP and store, and pull, fetch
    and increments SP. Better keep it around.

    Defined _pushra_ and _pullra_ using the default elf stack pointer
    
04/08/2025

    Using a QEMU Virtual Machine 

    1. At https://bellard.org/jslinux/, with linux Fedora 33 Console, 
    got a "Hello!" from sector-riscv.elf, 
    cross compiled in a x86-64 notebook with riscv64-linux-gnu suite; 

    Also followed by a "Segmentation Fault" of course.

    But this solves the VM for tests.

    the ecalls code for _putc and _getc is ok.

    2. local, 

    From https://gist.github.com/Frank-Buss/aa6aa7d4907335e4a529e8cf3e82f47e

    Installing QEMU: 
    sudo apt-get install qemu qemu-system-misc qemu-user 
    
    Installing GCC:
    sudo gcc-riscv64-unknown-elf

    the helloworldriscv.S compiles to a.out and "qemu-riscv a.out"
    does "HeloWorld!".

    Now go to debug.

03/08/2025

    Doing tests with djb2 hash and bit-0 for flag immediate, 
    the use of bit-0 grows the collisions too much.
    Return the flag to bit-31.

.equ hash_key, 0B876D32 
.equ hash_emit, 7C6B87D0 
.equ hash_store, 0002B584 
.equ hash_fetch, 0002B5E5 
.equ hash_add, 0002B58E 
.equ hash_colon, 0002B59F 
.equ hash_semis, 8002B59E   # with FLAG_IMMEDIATE 
.equ hash_nand, 7C727500 
.equ hash_exit, 7C6BBE85 
.equ hash_bye, 0B874AFB 
.equ hash_notequal, 00596816 
.equ hash_userat, 005970D6 

01/08/2025

Using GCCFLAGS = -nostartfiles -nodefaultlibs \
                 -march=rv32ic -mabi=ilp32 -static -Os
No errors. 

Size of .text is 0x26C bytes, including 0x34 of ecalls, using s2-s7 and t3-t6, mix 32-bit (101) and 16-bit (63) opcodes.
    
Now try optimize for use more 16-bit opcodes:

        Use zero (x0), ra (x1), sp (x2), s0 (x8), s1 (x9), a1-a5 (x10-x15)

        Keep just one level of call, no need backup for ra

        ecall is always a 32-bit size opcode

        no (s0) frame pointer used
        Use sp as reference pointer of user struct with offset

        Use s0 as forth instruction pointer

        keep a0, a1, a2, in memory while ecalls

consider:

        r0 is zero, ever
        ra is the return address for jal, do not touch :)
        ecall uses a0, a1, a2, (a7), must be saved 
        sp is free for use
        s0 s1 a3 a4 a5 is free for use
        
       
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



