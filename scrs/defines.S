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

.equ ONE, 1

.equ TWO, 2

.equ CELL, 4

.equ BL, 32    # blank space

.equ QU, 34    # double quote

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

# user parameter stack: sp rp last heap state 
# internal: head beat tick 

.equ params, 8

# user stack

.equ user_size, params * CELL

#---------------------------------------------------------------------
# the order must be preserved, same in source. 

# user structure of internal Forth variables

# data stack index
.equ SPTR, 0 * CELL

# return stack index
.equ RPTR, 1 * CELL 

# last link cell in heap dictionary linked list
.equ LAST, 2 * CELL

# next free cell in heap dictionary, aka dpt
.equ HEAP, 3 * CELL

# state flag
.equ STAT, 4 * CELL

#---------------------------------------------------------------------
# reserved 

# last heap while compiling
.equ HEAD, 5 * CELL

# counter of words executed by next
.equ BEAT, 6 * CELL

# counter of primitives executed 
.equ TICK, 7 * CELL

#---------------------------------------------------------------------
# flags for compiler options

 /*

 .equ extras, YES

 .equ primitives, YES

 .equ debug, YES
 
 .equ maths, YES

 .equ missed, YES

 .equ beatme, YES

 .equ tickme, YES
 
 .equ asciis, YES

 .equ asciionly, YES

 # .equ upperonly, YES
 
 # .equ loweronly, YES

*/

