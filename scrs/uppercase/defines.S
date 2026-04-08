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

# Moore uses 22 deep stacks

.equ stacks, 24 

# data stack

.equ spz, stacks * CELL

# return stack  

.equ rpz, stacks * CELL

# highlander, immediate flag, unique NaN 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

#---------------------------------------------------------------------
# the order must be preserved, same in source. 

# internal variables offset
.equ HEAD, -2 * CELL

# token input buffer
.equ TIBS, -1 * CELL

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

# void value
.equ VOID, 5 * CELL

#---------------------------------------------------------------------
# reserved 

# counter of words executed by next
.equ BEAT, 6 * CELL

# counter of primitives executed 
.equ TICK, 7 * CELL

#---------------------------------------------------------------------
# reserve sizes for above 

.equ PARAMS, 8 

#---------------------------------------------------------------------
# flags for compiler options

/*
 .equ debug, YES
 
 .equ extras, YES
 
 .equ maths, YES
 
 .equ missed, YES

 .equ beatme, YES

 .equ tickme, YES

 .equ asciis, YES

 .equ asciionly, YES

/*
 # .equ upperonly, YES
 
 # .equ loweronly, YES

*/

