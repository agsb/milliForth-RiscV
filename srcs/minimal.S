/*

 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 All rights reserved.
 
 see the disclaimer file in this repository.

 minimal elf with exit code
*/


#---------------------------------------------------------------------
# linux ecall stuff, 29/07/2025, vide:
# https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h

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

main:

.endif

#---------------------------------------------------------------------
#
# Note: system ecalls do not use ra 
#

# load system call for exit
_exit:
        add a0, zero, zero
        addi a7, zero, EXIT
        ecall

# load system call for init
_init:
        ret

# linux ecall for getc
_getc:
        addi a0, zero, STDIN
        la   a1, _pad
        addi a2, zero, 1
        addi a7, zero, GETC
        ecall
        lw a3, 0 (a1)
        ret

# linux ecall for putc
_putc:
        addi a0, zero, STDOUT
        la   a1, _pad
        addi a2, zero, 1
        addi a7, zero, PUTC
        sw a3, 0 (a1)
        ecall
        ret

#---------------------------------------------------------------------
