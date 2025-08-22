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
#
# Note: system ecalls do not use ra 
#

#---------------------------------------------------------------------
# linux ecall stuff, 29/07/2025, vide:
# https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h

.equ _ZERO,      0
.equ _ONE,       1
.equ _STDIN,     0
.equ _STDOUT,    1
.equ _GETC,     63
.equ _PUTC,     64
.equ _EXIT,     93

#---------------------------------------------------------------------
.section .bss
_char:
.word   0x0

#---------------------------------------------------------------------
.section .text

# load system call for exit
_exit:
        addi a0, zero, _ZERO
        addi a7, zero, _EXIT
        ecall

# load system call for init
# pass system parameters to program 
_init:
        ret

# linux ecall for getc
_getc:
        addi a0, zero, _STDIN
        la   a1, _char
        addi a2, zero, _ONE
        addi a7, zero, _GETC
        ecall
        lw a3, 0 (a1)
        
        #EOF?
        beq a0, zero, _exit

        ret

# linux ecall for putc
_putc:
        addi a0, zero, _STDOUT
        la   a1, _char
        addi a2, zero, _ONE
        addi a7, zero, _PUTC
        sw a3, 0 (a1)
        ecall
        ret

#---------------------------------------------------------------------
