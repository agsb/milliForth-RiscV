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
.endif

# load system call for exit
_exit:
        addi a0, zero, STDIN
        addi a7, zero, EXIT
        ecall

# load system call for init
_init:
        ret

# linux ecall for getc
_getc:
        addi a0, zero, STDIN
        la a1, _pad
        addi a2, zero, 1
        addi a7, zero, GETC
        ecall
        lw a3, 0 (a1)
        ret

# linux ecall for putc
_putc:
        sw a3, 0 (a1)
        addi a0, zero, STDOUT
        la a1, _pad
        addi a2, zero, 1
        addi a7, zero, PUTC
        ecall
        ret

# just not necessary

.if 0
# linux ecall for puts
_puts:
        # pointer to msg
        add a1, t3, zero
        # lenght of msg
        add a2, t4, zero

        addi a0, zero, STDOUT
        addi a7, zero, PUTC
        ecall
        j _init
        ret
.endif


