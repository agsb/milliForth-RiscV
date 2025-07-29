/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.
 
 see the disclaimer file in this repository.

 minimal elf with exit code
*/

#---------------------------------------------------------------------
.section .bss

.ifndef _pad
_pad:
.skip 32
.endif

#---------------------------------------------------------------------
.section .text
_start:

# load system call for exit
_exit:
        li a7, 93
        li a0, 0
        ecall

# load system call for init
_init:
	ret

# linux ecall for getc
_getc:
	li a7, 63
	li a0, 0
	la a1, _pad
	li a2, 1 
    	ecall
    	lw t0, 0 (a1)
	ret

# linux ecall for putc
_putc:
	li a7, 64
	li a0, 1
	la a1, _pad
	li a2, 1
	ecall
        lw t0, a0
	ret

