
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
.globl esave
.macro esave
        mv t3, a0
        mv t4, a1
        mv t5, a2
        mv t6, a3
.endm

.globl eload
.macro eload
        mv a0, t3
        mv a1, t4
        mv a2, t5
        mv a3, t6
.endm

.globl putchar
.macro putchar value
       esave
       li a3, \value
       call _putc
       eload
.endm

#---------------------------------------------------------------------
.globl mhit
.macro mhit it
        esave
        li a3, '\n'
        call _putc
        li a3, \it'
        call _putc
        li a3, '\n'
        call _putc
        eload
.endm

#---------------------------------------------------------------------
.globl mhex
.macro mhex rg
        pushra
        esave
        mv a3, \rg
        call puthex
        eload
        pullra 
.endm

#---------------------------------------------------------------------
