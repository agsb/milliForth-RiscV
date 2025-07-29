/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.
 
 see the disclaimer file in this repository.

 minimal elf with exit code
*/

#---------------------------------------------------------------------
.section .bss

_pad:
.skip 8

#---------------------------------------------------------------------
.section .text
_start:

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
	ret

# load system call for exit
_exit:
        li a7, 93
        li a0, 0
        ecall

