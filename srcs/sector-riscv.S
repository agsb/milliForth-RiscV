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
    A MilliForth for RISCV 
 
    original for the RISCV, by Alvaro G. S. Barcellos, 2025
 
    https://github.com/agsb 

    see the disclaimer file in this repository.
 
    read notes in this repository.
 
    THIS VERSION USES ONLY HASH HEADERS.

    Stacks moves backwards, decrease and push, pull and increase.

    Made for a little endian RiscV, cell size of 4 bytes, 32-bit

    This version relies on the .data, .text, .rodata, .bss sections 
    being in this order, the dictionary will continue at end of .bss.

    Not working yet :)

*/

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 
# beware about changes
# a3, a0, a1, a2, a7 are used by ecalls in _putc and _getc
# a4, a5, a6 are generics

#include "defines.S"

#---------------------------------------------------------------------
# generics alias 

# as FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# usefull

.equ ONE, 1

.equ TWO, 2

.equ CELL, 4

.equ NL, 10    # \n

.equ CR, 13    # \r

.equ BL, 32    # space

# data stack, 36 cells 

.equ spz, 36 * CELL

# return stack, 36 cells

.equ rpz, 36 * CELL

# Terminal input buffer 80 bytes, (but 72 is enough), moves forwards

.equ tibz, 80

# highlander, immediate flag, unique 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31
.equ hash_key,   0x0B876D32 
.equ hash_emit,  0x7C6B87D0 
.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_nand,  0x7C727500 
.equ hash_plus,  0x0002B58E 
.equ hash_notzero, 0x00596816 
.equ hash_userat, 0x00596F90
.equ hash_colon, 0x0002B59F 
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 
.equ hash_exit,  0x7C6BBE85 

#---------------------------------------------------------------------
# macro to define the header of words in dictionary
#
# In rellocable programs, 
# names can`t be composed, 
# last  can't be calculated, 
# inside macros, then must be done by hand.
#
.macro def_word name, label, last, hash
.p2align 2, 0x00
h_\label:
        .word \last
        .word \hash
\label:
.endm

#----------------------------------------------------------------------
.section .data

# no data

#----------------------------------------------------------------------
.section .bss
.p2align 2, 0x0

# user structure of internal Forth variables
# accessed as off-sets

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

#----------------------------------------------------------------------
# this is it

_user:
# user offsets, STAT to TAIL
.skip 8 * CELL

# tib grows forward
_tib:       
.skip tibz

# data stack grows backward
_spb:       # bottom 
.skip spz
sp0: .word 0x0

# return stack grows backward
_rpb:       # bottom
.skip rpz
rp0: .word 0x0

#-----------------------------------------------------------------------
# start of user dictionary 
# anything above is not a primitive
# usually at end of .bss (.heap)
#----------------------------------------------------------------------

h_here: .word 0x0

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#----------------------------------------------------------------------
.ifndef _start

.globl _start

_start:

.endif

#---------------------------------------------------------------------
# for deep, more than one, nested calls
#

.equ x_pushra, YES

.macro pushra
addi sp, sp, -4   # Decrement stack pointer by 4 bytes (for a word)
sw   ra, 0(sp)    # Store the value in register a0 at the new stack top
.endm

.equ x_pullra, YES

.macro pullra
lw   ra, 0(sp)    # Store the value in register a0 at the new stack top
addi sp, sp, +4   # Decrement stack pointer by 4 bytes (for a word)
.endm

#----------------------------------------------------------------------

.equ x_putchar, YES

.macro putchar value
       li a3, \value
       call _putc
.endm

#----------------------------------------------------------------------
# do any system inits here
main:
        
# just for sake

        fence

        # call _init

        # call _exit 

        j cold

#----------------------------------------------------------------------
# do what need once
cold:
# load user pointer address

        la usr, _user
        
#----------------------------------------------------------------------
# wipe the dictionary
warm:
# link list of headers, aka dictionary

        la fst, h_last
        
        sw fst, LAST (usr)
        
# next heap free cell  (end of .bss)
        
        la fst, h_here
        
        sw fst, HERE (usr)

#---------------------------------------------------------------------
# reset TIB
reset:

        la fst, _tib
#       sw zero, 0 (fst)
        sw fst, TOIN (usr)

#---------------------------------------------------------------------
# reset data stack
error:

        putchar '\n'
        putchar '?'
        putchar '?'
        putchar '\n'

#---------------------------------------------------------------------
abort:
# reset data stack
        
        la fst, sp0 
        sw fst, SPTR (usr)

#---------------------------------------------------------------------
quit:
# reset return stack
        
        la fst, rp0 
        sw fst, RPTR (usr)

# stat is 'interpret' == \0
        
        sw zero, STAT (usr)

        j okey

#---------------------------------------------------------------------
# the outer loop, need for indirect

resolvept:
        
        .word okey

#---------------------------------------------------------------------
okey:

# call prompt_okey

        #call stackS
        #call stackR
        
        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

#---------------------------------------------------------------------
# get a hash of the next token
resolve:
        
        call token

#---------------------------------------------------------------------         
# find de code
tick:

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 

# get the latest link
        
        lw lnk, LAST (usr)

100:
# verify end of dictionary, abort (could be number?)
        
        beq lnk, zero, error

# linked list
        
        mv wrd, lnk

# get next link 
        
        lw lnk, 0 (wrd)

# move to hash
        
        add wrd, wrd, CELL

        lw fst, 0 (wrd)

# mask the FLAG

        lui snd, %hi(FLAG_IMM)

        and snd, fst, snd

        xor fst, fst, snd

# compare
        
        bne hsh, fst, 100b

100:
# wrd points to or start of code or list of references

        add wrd, wrd, CELL

#---------------------------------------------------------------------         
eval:
# immediate ? if i != 0

        bne snd, zero, immediate      

# executing ? if == 0
        
        lw fst, STAT (usr)
        
        beq fst, zero, execute

#---------------------------------------------------------------------         
# compiling ? if != 0
compile:

        call comma

        j resolve

#---------------------------------------------------------------------         
execute:
immediate:

        la ipt, resolvept

        j pick

#---------------------------------------------------------------------
# in place every token, no rewinds
# the counter is placed at space before word
# returns a c-str
# \0 as eol goto getline
token:

        pushra

# load word separator, space

        addi trd, zero, BL

# last position on tib
        
100:

        lw idx, TOIN (usr)

# skip spaces // trd
200:

        lb snd, 0 (idx)

        beq snd, zero, gets

        bne snd, trd, hash

        addi idx, idx, ONE

        j 200b
        
#---------------------------------------------------------------------
# absolute crude getline, just getc until \n
gets:
  
        la idx, _tib
        
        sw idx, TOIN (usr)

# end-of-line is \n, ^J 
        
        addi snd, zero, NL

# ever start with a space
        
        add fst, zero, trd

# loop and fill the TIB until \n
# no test end of buffer 
300:
        sb fst, 0 (idx)
        
        addi idx, idx, ONE

# get next char
        call _getc

# echo it
        call _putc

# 7-bit ascii only 
        andi fst, fst, 127

# \n ^J ends the line, no overflow check

        bne fst, snd, 300b

# at end-of-line
400:

# replace \n with space 
        sb trd, 0 (idx)

# mark eol with \0
        sb zero, 1 (idx)

        j 100b

#---------------------------------------------------------------------
hash:

# make hash

        call djb2
        
# mask forth flag 
mask:

# set the FLAG as complement

        lui fst, %hi(MASK_IMM)
        
        addi fst, fst, %lo(MASK_IMM)

        and hsh, hsh, fst

# save toin

        sw idx, TOIN (usr)

        pullra

        ret 

#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
# idx pointer to str
# trd hold the end of word character ( \0 or spc)
# uses fst, snd
# hsh returns the hash 
# idx returns next space

.equ DJB2, 5381

djb2:
        # easy 5381
   
        lui hsh, %hi(DJB2)

        addi hsh, hsh, %lo(DJB2)

        # addi trd, zero, BL

100:
        lb fst, 0 (idx)
        
        # beq fst, zero, 100f
        
        beq fst, trd, 100f

        add snd, zero, hsh

        slli hsh, hsh, 5
        
        add hsh, hsh, snd
        
        xor hsh, hsh, fst
        
        addi idx, idx, ONE
        
        j 100b

100:    

        ret
        
#---------------------------------------------------------------------
comma:
        
        lw idx, HERE (usr)
      
        sw wrd, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HERE (usr)

        ret

#---------------------------------------------------------------------
#
# the primitives 
# 
#---------------------------------------------------------------------

/*
h_name:
        .word h_link_last_name
        .word hash_this_name
name:
        asm code
        j next
*/

### version 1.5.0
#---------------------------------------------------------------------
pull2:
        
        lw idx, SPTR (usr)
        
        lw fst, 0 (idx)
        
        add idx, idx, CELL

        lw snd, 0 (idx)

        ret

#---------------------------------------------------------------------
# ( -- c ) 
def_word "key", "key", 0x0, hash_key

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", h_key, hash_emit
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", h_emit, hash_store
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi idx, idx, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", h_store, hash_fetch
        
        call pull2
        
        lw fst, 0 (fst)
        
        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", h_fetch, hash_nand
        
        call pull2

        and fst, fst, snd
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", h_nand, hash_plus
        
        call pull2

        add fst, fst, snd
        
        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", h_plus, hash_notzero

        call pull2
        
isfalse:

        beq fst, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j back1

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "u@", "userat", h_zeroq, hash_userat
        
        add fst, zero, usr 

push1:

        lw idx, SPTR (usr)
        
back1:

        add idx, idx, -1 * CELL

keep1:

        sw fst, 0 (idx)

save1:

        sw idx, SPTR (usr)
        
        j next

#---------------------------------------------------------------------
def_word ":", "colon", h_userat, hash_colon
# save here, panic if semis not follow elsewhere
        
        lw fst, HERE (usr)
        
        sw fst, HEAD (usr)

# stat is 'compile' == 1
        
        add fst, zero, ONE
        
        sw fst, STAT (usr)

# make a header:

# copy last into (here)
        
        lw wrd, LAST (usr)
        
        call comma

# get following token
        
        call token
        
# copy hash into (here)

        add wrd, zero, hsh

#---------------------------------------------------------------------
finish:

        call comma

        j next 

#---------------------------------------------------------------------
def_word ";", "semis",  h_colon, hash_semis 
# update last, panic if colon not lead elsewhere 
        
        lw fst, HEAD (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        sw zero, STAT (usr)

# compound words must ends with exit
        
        la wrd, exit

        j finish

#---------------------------------------------------------------------
# Minimal Indirect Thread Code Engine
#
# this is the Forth heart beat.
#
# nest aka enter or docol, 
# unnest aka exit or semis;
#
# "why there is no 'docol at start of words ?"
#
# ( -- ) 
def_word "exit", "exit", h_semis, hash_exit
unnest: #; exit
# return pull, ipt = (rpt), rpt += cell 
        
        lw idx, RPTR (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, CELL
        
        sw idx, RPTR (usr)

next:
# wrd = (ipt) #; ipt += cell
        
        lw wrd, 0 (ipt)
        
        addi ipt, ipt, CELL

pick:
# compare address, if less or equal than exit then is a primitive 
        
        la idx, ends
        
        ble wrd, idx, jump

nest:   #; enter
# return push, (rpt) = ipt, rp -= cell
        
        lw idx, RPTR (usr)
        
        addi idx, idx, -1 * CELL
        
        sw ipt, 0 (idx)
        
        sw idx, RPTR (usr)

move: 
# indirect access 
        
        mv ipt, wrd
        
        j next

jump: 
# jump to primitive
        
        jalr zero, 0 (wrd)

#----------------------------------------------------------------------
# system dependences, linux ecall
#

#include "minimal.S"

#---------------------------------------------------------------------
# any other primitives after exit
#---------------------------------------------------------------------

.equ EXTRAS, YES

.ifdef EXTRAS
#----------------------------------------------------------------------
# keep last entry of primitives

.set into_extras, h_exit

#include "extras-milliforth.S"

#----------------------------------------------------------------------
# keep last entry of extras

.set h_last, from_extras

.endif

.ifndef EXTRAS

.set h_last, h_exit

.endif

#---------------------------------------------------------------------
# Beware, ends must be at last word in primitive ditionary !
#---------------------------------------------------------------------

ends:

.word 0xDEADBEEF

.end

