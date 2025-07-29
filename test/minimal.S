/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.
 
 see the disclaimer file in this repository.

 minimal elf with exit code
*/


#---------------------------------------------------------------------
# linux ecall stuff

.equ STDIN,     0
.equ STDOUT,    1
.equ GETC,     63
.equ PUTC,     64
.equ EXIT,     93

#---------------------------------------------------------------------
.section .bss

.ifndef _pad
_pad:
.skip 32
.endif

#---------------------------------------------------------------------
.section .text

.ifndef _start
.globl _start
_start:
.endif

# load system call for exit
_exit:
        addi a0, a0, 0
        addi a7, a7, EXIT
        ecall

# load system call for init
_init:
	la a1, _pad
	addi a2, a2, 1
	ret

# linux ecall for getc
_getc:
	addi a0, a0, STDIN
	addi a7, a7, GETC
    	ecall
    	lw t0, 0 (a1)
	ret

# linux ecall for putc
_putc:
	addi a0, a0, STDOUT
	addi a7, a7, PUTC
	ecall
        lw t0, a0
	ret

