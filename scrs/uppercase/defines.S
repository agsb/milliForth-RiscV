#---------------------------------------------------------------------
# for alias register names 
# do not change
# a0, a1, a2, a7 are used by ecalls

# forth struct pointer, constant 
#define usr s0

# instruction pointer, preserved
#define ipt s1

# hash value
#define hsh a0

# link pointer
#define lnk a1

# word pointer
#define wrd a2

# generic
#define fst a3

# generic
#define snd a4

# generic
#define trd a6

# index 
#define idx a5

#---------------------------------------------------------------------
# max size of dictionary 64k * 4 
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

.equ NL, 10    # \n

.equ CR, 13    # \r

.equ BL, 32    # space

# data stack, 36 cells 

.equ spz, 36 * CELL

# return stack, 36 cells

.equ rpz, 36 * CELL

# Terminal input buffer 80 bytes, (but 72 is enough), moves forwards

.equ tibz, 80

# PAD for temporary formating etc

.equ padz, 84

# PIC for numeric formating etc, (2*32)+4

.equ picz, 64+4 

# highlander, immediate flag, unique 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

#---------------------------------------------------------------------
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

# state flag
.equ STAT, 5 * CELL

# heap forward
.equ HEAD, 6 * CELL

# heap backward
.equ TAIL, 7 * CELL

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31

.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_zeroq, 0x00596816 
.equ hash_colon, 0x0002B59F 
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
