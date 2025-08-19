/*
#---------------------------------------------------------------------
 
  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

#----------------------------------------------------------------------
*/

/*
 Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
 
 All rights reserved.
 
 see the disclaimer file in this repository.

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
_char:
.word   0x0

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
# pass system parameters to program 
_init:
        ret

# linux ecall for getc
_getc:
        addi a0, zero, STDIN
        la   a1, _char
        addi a2, zero, 1
        addi a7, zero, GETC
        ecall
        lw a3, 0 (a1)
        
        #EOF?
        beq a3, zero, _exit

        ret

# linux ecall for putc
_putc:
        addi a0, zero, STDOUT
        la   a1, _char
        addi a2, zero, 1
        addi a7, zero, PUTC
        sw a3, 0 (a1)
        ecall
        ret

#---------------------------------------------------------------------

#---------------------------------------------------------------------
# code a register (32-bit) word in ASCII hexadecimal 
#
puthex:

        pushra

        add  s2, zero, a3
        
        addi s5, zero, 58

        srli s3, s2, 24
        call 100f
        srli s3, s2, 16
        call 100f
        srli s3, s2, 8
        call 100f
        srli s3, s2, 0
        call 100f

        add  a3, zero, s2

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

