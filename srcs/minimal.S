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
.ifndef RAS

.macro pushra
addi sp, sp, -4   # Decrement stack pointer by 4 bytes (for a word)
sw   ra, 0(sp)    # Store the value in register a0 at the new stack top
.endm

.macro pullra
lw   ra, 0(sp)    # Store the value in register a0 at the new stack top
addi sp, sp, +4   # Decrement stack pointer by 4 bytes (for a word)
.endm

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
#       Note: system ecalls do not use ra for keep return address
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
#
# Note: nested user calls must save ra,
#       relies in pushra and pullra
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# code a register (32-bit) word in ASCII hexadecimal 
#
# using A3 as argument
# using S2, S3, S4, S5 as scratch
#
puthex:

        pushra

        addi s5, zero, 58
        add  s2, zero, a3

        srli s3, s2, 24
        call 100f
        srli s3, s2, 16
        call 100f
        srli s3, s2, 8
        call 100f
        srli s3, s2, 0
        call 100f

        pullra

        ret

100:
        pushra

        andi s3, s3, 0xFF
        
        srli s4, s3, 4
        call 200f
        
        srli s4, s3, 0
        call 200f

        pullra

        ret

200:
        pushra

        andi s4, s4, 0x0F
        ori  s4, s4, 48
        blt  s4, s5, 300f
        addi s4, s4, 7
300:
        add a3, zero, s4

        call _putc
        
        pullra

        ret



