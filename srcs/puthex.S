
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

#---------------------------------------------------------------------
#
# macros for debug
#
#---------------------------------------------------------------------
# lazy way, why push and pull using hardware stack
.globl esave
.macro esave
        mv s8, a0
        mv s9, a1
        mv s10, a2
        mv s11, a7
.endm

.globl eload
.macro eload
        mv a0, s8
        mv a1, s9
        mv a2, s10
        mv a7, s11
.endm

#---------------------------------------------------------------------
.globl putchr
.macro putchr it
       	esave
       	li a3, \it
       	call _putc
       	eload
.endm

#---------------------------------------------------------------------
.globl puthex
.macro puthex it
        #pushra
        esave
        mv a3, \it
        call bin2hex
        eload
        #pullra 
.endm

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#
.global bin2hex
bin2hex:
        pushra

        mv t3, a3
        
        li t4, 58

        li t5, 32

        # rolls 
100:
        beqz t5, 300f

        addi t5, t5, -4

        srl  a3, t3, t5

        andi a3, a3, 15

        ori  a3, a3, 48
        
        blt  a3, t4, 200f
        
        addi a3, a3, 7

200:
        call _putc
        
        j 100b

300:

        pullra

        ret

#---------------------------------------------------------------------

