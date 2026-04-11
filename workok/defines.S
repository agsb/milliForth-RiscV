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

# ascii

.equ XON, 17   #  ^Q
.equ XOFF, 19  #  ^S

.equ ACK, 6    #  ^F
.equ NAK, 21   #  ^U

.equ BS, 8     # \b ^H

.equ HT, 9     # \t ^I

.equ LF, 10    # \n ^J

.equ CR, 13    # \r ^M

.equ CAN, 24   #    ^X

.equ ESC, 27   #    ^[

.equ BL, 32    # blank space

# Moore uses 22 deep stacks

.equ stacks, 36

# data stack,  

.equ spz, stacks * CELL

# return stack,  

.equ rpz, stacks * CELL

# Terminal input buffer 80 bytes, (but 72 is enough), moves forwards

.equ tibz, 80

# PAD for temporary formating etc

.equ padz, 84

# PIC for numeric formating etc, (2*32)+4

.equ picz, 64+4 

# highlander, immediate flag, unique NaN 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

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
.equ HERE, 3 * CELL

# toin next free byte in TIB
.equ TOIN, 4 * CELL

# terminal (source) input buffer
.equ TIBS, 5 * CELL

# state flag
.equ STAT, 6 * CELL

# counter of words executed by next
.equ BEAT, 7 * CELL

# counter of words executed by next
.equ TICK, 8 * CELL

# heap forward
.equ HEAD, 9 * CELL

# heap backward
.equ TAIL, 10 * CELL

# void 
.equ VOID, 11 * CELL

#---------------------------------------------------------------------
# reserve for above 

.equ PARAMS, 12 

.equ LOCALS, 8

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31
#
#---------------------------------------------------------------------
# symbols ! @ + 0# : ;
.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_zeroq, 0x00596816 
.equ hash_colon, 0x0002B59F 

#---------------------------------------------------------------------
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 

#---------------------------------------------------------------------
# lowercase
.equ hash_key,   0x0B876D32 
.equ hash_emit,  0x7C6B87D0 
.equ hash_exit,  0x7C6BBE85 
.equ hash_nand,  0x7C727500 
.equ hash_userat, 0x00596F90

#---------------------------------------------------------------------
# uppercase
.equ hash_KEY,   0x0B87F112
.equ hash_EMIT,  0x7C7C87D0
.equ hash_EXIT,  0x7C7CC745
.equ hash_NAND,  0x7C8254C0
.equ hash_USERAT, 0x005973B0

#---------------------------------------------------------------------
# flags for compiler options


/*
 .equ debug, YES
 
 .equ extras, YES
 
 .equ maths, YES
 
 .equ dismiss, YES

 .equ beatme, YES

 .equ tickme, YES

 .equ linedit, YES

 .equ onlyascii, YES

 # default is mixed case

 # .equ uppercase, YES
 
 # .equ lowercase, YES

*/

#---------------------------------------------------------------------
# 

#include "registers.S"

#
#---------------------------------------------------------------------
