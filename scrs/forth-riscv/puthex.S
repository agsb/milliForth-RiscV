
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
