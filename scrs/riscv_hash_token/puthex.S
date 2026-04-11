
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
.globl tinto
.macro tinto
        add t3, zero, a0
        add t4, zero, a1
        add t5, zero, a2
        add t6, zero, a3
.endm

.globl tfrom
.macro tfrom
        add a0, zero, t3
        add a1, zero, t4
        add a2, zero, t5
        add a3, zero, t6
.endm

.globl putchar
.macro putchar value
       tinto
       li a3, \value
       call _putc
       tfrom
.endm

#---------------------------------------------------------------------
.globl mhit
.macro mhit it
        putchar '\n'
        putchar \it
        putchar ' '
.endm

#---------------------------------------------------------------------
.globl mhex
.macro mhex rg
        pushra
        call saves
        add a3, zero, \rg
        call puthex
        call loads
        pullra 
.endm

#---------------------------------------------------------------------
# first version
#
puthexold:

        pushra

        add  s2, zero, a3
        
        addi s5, zero, 58

        addi a3, zero, ' '
        
        call _putc

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

