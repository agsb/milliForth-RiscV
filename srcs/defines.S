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
# flags for compiler options

# enable echo
#.equ echoo, YES

# enable OK or ??
#.equ emote, YES

# enable heap clean
#.equ missme, YES

# enable extras
#.equ extras, YES

# enable extendeds
#.equ extendeds, YES

# enable counters 
#.equ beats, YES

# enable debug 
#.equ debugs, YES


#---------------------------------------------------------------------
# max size of dictionary 64k CELLS  
# depends on host machine

.equ RAM_LIMIT, 0x40000

#---------------------------------------------------------------------
# generics alias 

# as FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# states

.equ EXECUTE, 0

.equ COMPILE, 1

# usefull

.equ CELL, 4	# sizeof a CELL

.equ BL,  32   	# word delimiter is blank space 

# highlander, immediate flag, unique NaN 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

# Moore uses 22 deep stacks

.equ stacks, 36 

# data stack

.equ sp_size, stacks * CELL

# return stack  

.equ rp_size, stacks * CELL

#---------------------------------------------------------------------
# Note the order must be preserved, same in source. 

#---------------------------------------------------------------------
# user structure of internal Forth variables, per task

# data stack index
.equ SPTR, 0 * CELL

# return stack index
.equ RPTR, 1 * CELL 

# next free cell in heap dictionary, aka dp
.equ HEAP, 2 * CELL

# last link cell in heap dictionary linked list
.equ LAST, 3 * CELL

# last heap 
.equ PIKE, 4 * CELL

# state flag
.equ STAT, 5 * CELL

# base radix for numbers, for future use
.equ BASE, 6 * CELL

#---------------------------------------------------------------------
# reserved internals  

# last ip, reserved
.equ HIPO, 7 * CELL

# first absolute cell, reserved DICTIONARY__INIT 
.equ HEAD, 8 * CELL

# last absolute free cell, reserved RAM_LIMIT
.equ TAIL, 9 * CELL

# temporary scratch as array of 6 CELLS
.equ TEMP, 10 * CELL

# user parameter stack: sp rp heap last state base
# user internal: hipo pike hipo head tail temp[6]

.equ params, 16

# user stack

.equ user_size, params * CELL

#---------------------------------------------------------------------
