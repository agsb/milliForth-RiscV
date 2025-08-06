/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.
 
 see the disclaimer file in this repository.

 minimal elf with exit code
*/


#---------------------------------------------------------------------
# linux ecall stuff, 29/07/2025, vide:
# https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h

.equ ZERO,      0
.equ ONE,       1
.equ TWO,       2
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
        li a0, ZERO
        li a7, EXIT
        ecall

# load system call for init
_init:
        ret

# linux ecall for getc
_getc:
        li a0,  STDIN
        la a1,  _pad
        li a2,  ONE
        li a7,  GETC
        ecall
        lw a3,  0 (a1)
        ret

# linux ecall for putc
_putc:
        li a0,  STDOUT
        la a1,  _pad
        li a2,  ONE
        li a7,  PUTC
        sw a3,  0 (a1)
        ecall
        ret


