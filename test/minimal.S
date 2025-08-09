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

main:
        li a3, 0x01020304

        call puthex

        li a3, 0x10203040

        call puthex

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

# code a register (32-bit) word in ASCII hexadecimal 

puthex:

        #addi s6, zero, ra

        addi s5, zero, 64
        add  s2, zero, a3

        srli s3, s2, 24
        call 100f
        srli s3, s2, 16
        call 100f
        srli s3, s2, 8
        call 100f
        srli s3, s2, 0
        call 100f

        #addi ra, zero, s6
        
        ret

100:
        andi s3, s3, 255
        srli s4, s3, 4
        call 200f
        srli s4, s3, 0
200:
        andi s4, s4, 15
        ori  s4, s4, 48
        blt  s4, s5, 300f
        addi s4, s4, 6
300:
        add a3, zero, s4

        call _putc
        
        ret



