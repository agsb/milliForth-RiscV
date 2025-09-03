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

    Riscv does not have automatic hidden SP push/pull

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

# PAD for temporary formating etc

.equ padz, 48

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
.equ hash_zeroq, 0x00596816 
.equ hash_userat, 0x00596F90
.equ hash_colon, 0x0002B59F 
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 
.equ hash_exit,  0x7C6BBE85 

#---------------------------------------------------------------------
# macro to define the header of words in dictionary
#
.global def_word

.macro def_word name, label, hash, last
.p2align 2, 0x00
h_\label:
        .word \last
        .word \hash
\label:
.endm

#---------------------------------------------------------------------
# for deep, more than one, nested calls, use callee
#
.global pushra

.macro pushra
        addi sp, sp, -4   
        sw   ra, 0(sp)    
.endm

.global pullra

.macro pullra
        lw   ra, 0(sp)    
        addi sp, sp, +4   
.endm

#----------------------------------------------------------------------
# easy pretty print one char
#
.global putchar

.macro putchar value
       li a3, \value
       call _putc
.endm

.macro mhit it
        putchar '\n'
        putchar \it
        putchar ' '
.endm

#----------------------------------------------------------------------
.section .data

# There is no spoon.

#----------------------------------------------------------------------
.section .bss
.p2align 2, 0x0

# user structure of internal Forth variables
# accessed as offsets

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
# and this is it

_user:
# user parameter offsets
.skip 8 * CELL

# reserved for locals 
_locals:
.skip 8 * CELL

# data stack grows backward
_spb:       # bottom 
.skip spz
sp0: .word 0x0

# return stack grows backward
_rpb:       # bottom
.skip rpz
rp0: .word 0x0

# tib grows forward
_tib:       
.skip tibz

#xxx
# pad grows forward
_pad:       
.skip padz

# start of user dictionary 
h_here: 
        .word 0x0

#-----------------------------------------------------------------------
# at end of .bss (.heap) 
#----------------------------------------------------------------------

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#---------------------------------------------------------------------
# xxx

#include "hexy.S"

#----------------------------------------------------------------------
.globl _start

_start:

#----------------------------------------------------------------------
# do any system inits
main:
# just for sake

        fence

/*
        call _init

        la snd, h_here
        
        sw fst, 0 (snd)

*/

#----------------------------------------------------------------------
# do what need be only once
cold:
# load user pointer address

        la usr, _user
        
#----------------------------------------------------------------------
# wipe the dictionary
warm:
# next heap free cell
        
        la fst, h_here
        sw fst, HERE (usr)

# link list of headers, aka dictionary

        la fst, h_last
        sw fst, LAST (usr)

#---------------------------------------------------------------------
# reset TIB
reset:

        la fst, _tib
        sw fst, TOIN (usr)

#---------------------------------------------------------------------
# reset stacks
error:

# xxx 
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

# xxx
#        lw fst, STAT (usr)
#        bne fst, zero, resolve

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

#---------------------------------------------------------------------
# get a hash of the next token
resolve:
        
        call token

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
#
tick:

# get the latest link
        
        lw lnk, LAST (usr)

100:
# verify end of dictionary, take care to abort
        
        beq lnk, zero, miss    

# linked list
        
        add wrd, zero, lnk

# move next link 
        
        lw lnk, 0 (wrd)

# move to hash
        
        add wrd, wrd, CELL

        lw fst, 0 (wrd)

# mask the FLAG and hold it in snd

        lui snd, %hi(FLAG_IMM)

        and snd, fst, snd

        xor fst, fst, snd

# compare
        
        bne hsh, fst, 100b

#---------------------------------------------------------------------         
eval:
# wrd points to or start of code or list of references

        add wrd, wrd, CELL

# immediate ? 

        bne snd, zero, immediate      

# executing ? if state == 0
        
        lw fst, STAT (usr)
        
        beq fst, zero, execute

#---------------------------------------------------------------------         
# compiling ? if state != 0
compile:

        call docomma

        j resolve

#---------------------------------------------------------------------         
execute:
immediate:

        la ipt, resolvept

        j pick

#---------------------------------------------------------------------
# unexpected end of dictionary
# wipe remains compiled
# xxx (---------------------------------------------------------------
miss:
        # compiling ?
        lw fst, STAT (usr)
        bne fst, zero, 100f
        # wipe remains
        lw fst, HEAD (usr)
        sw fst, HERE (usr)
100:
        j error
# xxx )---------------------------------------------------------------

#---------------------------------------------------------------------
# in place every token, no rewinds
# the counter is placed at space before word
# returns a c-str
# \0 as eol, goto getline
token:

        pushra

# load word separator, space

        addi trd, zero, BL

100:

# last position on tib
        lw idx, TOIN (usr)

# skip spaces // trd
200:

        lb snd, 0 (idx)

        beq snd, zero, gets

        bne snd, trd, hash

        addi idx, idx, ONE

        j 200b
        
#---------------------------------------------------------------------
# absolute crude getline, 
# no overflow, no line edit, no clues
# the _getc handle EOF
gets:
  
        la idx, _tib
        
        sw idx, TOIN (usr)

# end-of-line is \n, ^J
        
        addi snd, zero, NL

# ever start with a space
        
        add fst, zero, trd

# loop and fill the TIB until \n
300:
        sb fst, 0 (idx)
        
        addi idx, idx, ONE

# get next char

        call _getc

# echo it

        call _putc

# 7-bit ascii only 
# xxx
       andi fst, fst, 127

# \n ^J ends the line

        bne fst, snd, 300b

# at end-of-line
400:

# replace \n with space 
        sb trd, 0 (idx)

# mark eol with \0
        sb zero, 1 (idx)

# back to token
        j 100b

#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
# idx pointer to str
# trd holds the end of word  
# uses fst, snd, trd
# hsh returns the hash 
# idx returns next space after
#---------------------------------------------------------------------
.equ DJB2, 5381
.equ SFHT, 5
#---------------------------------------------------------------------
hash:
djb2:
        # easy 5381
   
        lui hsh, %hi(DJB2)
        addi hsh, hsh, %lo(DJB2)

100:
        lb fst, 0 (idx)
        
        beq fst, trd, 200f

        add snd, zero, hsh

        slli hsh, hsh, SFHT
        
        add hsh, hsh, snd
        
        xor hsh, hsh, fst
        
        addi idx, idx, ONE
        
        j 100b

#---------------------------------------------------------------------
200:    

# mask forth flag 
mask:

        lui fst, %hi(MASK_IMM)
        
        and hsh, hsh, fst

# save toin

        sw idx, TOIN (usr)

        pullra

        ret
        
#---------------------------------------------------------------------
docomma:

        mhex wrd        

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
def_word "key", "key", hash_key, 0x0

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", hash_emit, h_key
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", hash_store, h_emit
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi idx, idx, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", hash_fetch, h_store
        
        call pull2
        
        lw fst, 0 (fst)
        
        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", hash_nand, h_fetch
        
        call pull2

        and fst, fst, snd
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", hash_plus, h_nand
        
        call pull2

        add fst, fst, snd
        
        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", hash_zeroq, h_plus

        call pull2
        
isfalse:

        beq fst, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j back1

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "u@", "userat", hash_userat, h_zeroq
        
        add fst, zero, usr 

push1:
        lw idx, SPTR (usr)
        
back1:
        addi idx, idx, -1 * CELL

keep1:
        sw fst, 0 (idx)

save1:
        sw idx, SPTR (usr)
        
        j next

#---------------------------------------------------------------------
# ( -- ), 
def_word ":", "colon", hash_colon, h_userat
# save here, panic if semis not follow elsewhere
        
        lw fst, HERE (usr)
        
        sw fst, HEAD (usr)

# stat is 'compile' == 1
        
        add fst, zero, ONE
        
        sw fst, STAT (usr)

create:

# copy last into (here)
        
        lw wrd, LAST (usr)
        
        call docomma

# get following token
        
        call token
        
# copy hash into (here)

        add wrd, zero, hsh

comma:

        call docomma

        j next 

#---------------------------------------------------------------------
# ( -- )
def_word ";", "semis", hash_semis, h_colon 
# update last, panic if colon not lead elsewhere 
        
        lw fst, HEAD (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        sw zero, STAT (usr)

finish:
# compound words must ends with exit
        
        la wrd, exit

        j comma

#---------------------------------------------------------------------
# Minimal Indirect Thread Code Engine
#
# this is the Forth heart beat.
#
# nest aka enter or docol, unnest aka exit or semis;
#
# "why there is no 'docol at start of words ?"
#
# ( -- ) 
def_word "exit", "exit", hash_exit, h_semis
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
# compare address, if is a primitive then jumps 
        
        la idx, ends
        
        blt wrd, idx, jump

nest:   #; enter
# return push, rp -= cell, (rpt) = ipt
        
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

#---------------------------------------------------------------------
.end

