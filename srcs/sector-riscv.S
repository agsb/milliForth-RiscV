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

    This version relies on the .data, .text, .rodata, .bss sections 
    being in this order, the dictionary will continue at end of .bss.

    Not working yet :)

    hash djb2

*/

#----------------------------------------------------------------------
#
# Stuff for compiler
#

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 
# do not change
# a0, a1, a2, a7 are used by ecalls in _putc and _getc
# a3, a4, a5, a6 are generics
#---------------------------------------------------------------------

#include "defines.S"

#---------------------------------------------------------------------
# generics alias 

# FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# usefull

.equ ONE, 1

.equ TWO, 2

.equ NLC, 10    # \n

.equ SPC, 32    # space

# cell size, 4 bytes, 32-bit

.equ CELL, 4

# data stack, 36 cells, moves backwards, push decreases before copy

.equ spz, 36 * CELL

# return stack, 36 cells, moves backwards, push decreases before copy

.equ rpz, 36 * CELL

# Terminal input buffer 80 bytes, (but 72 is enough), moves forwards

.equ tibz, 80

# reserves 32 bytes for pad scratch, moves forwards

.equ padz, 32

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31
.equ hash_key,   0x0B876D32 
.equ hash_emit,  0x7C6B87D0 
.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_colon, 0x0002B59F 
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 
.equ hash_nand,  0x7C727500 
.equ hash_exit,  0x7C6BBE85 
.equ hash_bye,   0x0B874AFB 
.equ hash_notzero, 0x00596816 
.equ hash_userat,  0x005970D6 

#---------------------------------------------------------------------
# macro to define the header of words in dictionary
#
# makes:
#   h_name:
#   .word  link_to_previous_entry
#   .byte  strlen(name) + flags
#   .byte  name + pad
#   name:
#

# highlander, immediate flag. using lui 
# must load the high 20 bits, as 0x80000 then
# the low 12 bits, as 0x000
#
.equ FLAG_IMM, 0x80000

.macro def_word name, label, last, hash
#.p2align 2, 0x00
h_\label:
        .word \last
        .word \hash
\label:
.endm

# hashes can't be calculated inside macros,
# all hashs must be done by hand.

#---------------------------------------------------------------------
# for deep, more than one, nested calls
#

.macro pushra
addi sp, sp, -4   # Decrement stack pointer by 4 bytes (for a word)
sw   ra, 0(sp)    # Store the value in register a0 at the new stack top
.endm

.macro pullra
lw   ra, 0(sp)    # Store the value in register a0 at the new stack top
addi sp, sp, +4   # Decrement stack pointer by 4 bytes (for a word)
.endm

#---------------------------------------------------------------------
# for easy

.macro putchar value
        li a3, \value 
        call _putc
.endm

.macro mhex rg
        putchar ' '
        add a3, zero, \rg
        call puthex
.endm

.macro mhit it
        putchar '\n'
        putchar \it
        putchar ' '
.endm

#----------------------------------------------------------------------
.section .data

# no data

#----------------------------------------------------------------------
.section .bss
.p2align 2, 0x0

# user structure of internal Forth variables
# catch:
#       the order matters for forth !
#       stacks have fixed size

# name some offsets

# state flag
.equ STAT, 0 * CELL

# toin next free byte in TIB
.equ TOIN, 1 * CELL 

# last link cell in heap dictionary linked list
.equ LAST, 2 * CELL

# next free cell in heap dictionary, aka dpt
.equ HERE, 3 * CELL

# data stack index
.equ SPT, 4 * CELL

# return stack index
.equ RPT, 5 * CELL

# next token in TIB
.equ TOUT, 6 * CELL

# hold 'here while compile
.equ ONCE, 7 * CELL

# heap forward
.equ HEAD, 8 * CELL

# heap backward
.equ TAIL, 9 * CELL

# this is it
_user:
.skip TAIL + 1 * CELL

# tib grows forward
_tib:       
.skip tibz

# pad grows forward
_pad:       
.skip padz

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
here: .word 0x0

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#----------------------------------------------------------------------
.ifndef _start
.globl _start
_start:
.endif

#----------------------------------------------------------------------
# do any system inits here
main:
        
# just for sake

        fence

        # call _init

        # call _exit 

        mhit '0'
        mhex sp

        j cold

#----------------------------------------------------------------------
# do what need once
cold:
# load user pointer address

        la usr, _user
        
        mhit '1'
        mhex usr

#----------------------------------------------------------------------
# wipe the dictionary
warm:
# link list of headers, aka dictionary

        la fst, h_exit
        
        sw fst, LAST (usr)
        
        mhit '2'
        mhex fst

# next heap free cell  (end of .bss)
        
        la fst, here
        
        sw fst, HERE (usr)

        mhit '3'
        mhex fst

#---------------------------------------------------------------------
# reset TIB
reset:
        

        la fst, _tib
        sw zero, 0 (fst)
        sw fst, TOIN (usr)

        mhit '4'
        mhex fst

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
        sw fst, SPT (usr)

        mhit '5'
        mhex fst

#---------------------------------------------------------------------
quit:
# reset return stack
        
        la fst, rp0 
        sw fst, RPT (usr)

        mhit '6'
        mhex fst

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

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

#---------------------------------------------------------------------
# get a hash of the next token
resolve:
        
        call token

        mhit '7'
        mhex hsh
        call _getc
        

#---------------------------------------------------------------------         
# find de code
tick:

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 

# get the latest link
        
        lw lnk, LAST (usr)

100:
# verify end of dictionary, abort (could be number?)
        
        beq lnk, zero, abort

        mhit '8'
        mhex lnk
        
# linked list
        
        mv wrd, lnk

# get next link 
        
        lw lnk, 0 (wrd)

        mhit '9'
        mhex lnk

# move to hash
        
        add wrd, wrd, CELL

        lw fst, 0 (wrd)

# set the FLAG

        lui snd, FLAG_IMM

        li snd, 0x0

        mhit 'A'
        mhex snd

# mask hash flag // snd

        and snd, fst, snd

        xor fst, fst, snd

# compare
        
        beq hsh, fst, 100f

# next link

       mhit 'B'
       
       j 100b


100:
# move to code
# wrd points to or start of code or list of references

       mhit 'Z'

       add wrd, wrd, CELL

#---------------------------------------------------------------------         
eval:
# immediate ? if i!= 0

        bne snd, zero, immediate      

# executing ? if == \0
        
        lb fst, STAT+0 (usr)
        
        beq fst, zero, execute

#---------------------------------------------------------------------         
compile:

        putchar 'C'

        call wcomma

        j resolve

#---------------------------------------------------------------------         
execute:
immediate:

        putchar 'E'

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

        addi trd, zero, SPC

# last position on tib
        
100:

        lw idx, TOIN (usr)

        mhit 'T'
        mhex idx
        
# skip spaces // trd
200:

        lb snd, 0 (idx)

        bne snd, zero, no_gets

#---------------------------------------------------------------------
# absolute crude getline, just getc until \n
gets:
  
        mhit 'G'

        la idx, _tib
        
        sw idx, TOIN (usr)

# end-of-line is newline
        
        addi snd, zero, NLC

# ever start with a space
        
        add fst, zero, trd

# loop and fill the TIB until \n
# no test end of buffer 
300:
        sb fst, 0 (idx)
        
        addi idx, idx, ONE

# get next char
        call _getc

# 7-bit ascii only 
        andi fst, fst, 127

# \n ends 
        bne fst, snd, 300b

# at end-of-line
400:

# replace \n with space 
        sb trd, 0 (idx)

# mark eol with \0
        sb zero, 1 (idx)

        mhit 'L' 

        j 100b

#---------------------------------------------------------------------
no_gets:
        
        putchar 'X'

        addi idx, idx, ONE
        
# not a space ?
        bne snd, trd, 500f

        #mv fst, snd 
        #call _putc
        
        j 200b
500:

# make hash

        call djb2
        
# mask forth flag 
mask:

        mhit 'H'
        mhex hsh

# set the FLAG as complement

        lui fst, FLAG_IMM - 1

        li  fst, -1

        and hsh, hsh, fst

        mhit 'H'
        mhex hsh

# save toin
        sw idx, TOIN (usr)

        mhit 'N'
        mhex idx

        pullra

        ret 

#---------------------------------------------------------------------
#
# generics 
#
#---------------------------------------------------------------------

#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
# idx pointer to str
# trd hold the end of word character ( \0 or spc)
# uses fst, snd
# hsh returns the hash 
# idx returns next space
djb2:
        # easy 3581
        addi hsh, zero, 2000

        addi hsh, hsh,  1581

        addi trd, zero, SPC

100:
        lb fst, 0 (idx)
        
        # beq fst, zero, 100f
        
        beq fst, trd, 100f
        
        mv snd, hsh

        slli hsh, hsh, 5
        
        add hsh, hsh, snd
        
        xor hsh, hsh, fst
        
        addi idx, idx, ONE
        
        j 100b

100:    ret
        
#---------------------------------------------------------------------
wcomma:
        
        lw idx, HERE (usr)
      
        sw wrd, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HERE (usr)

        ret

#---------------------------------------------------------------------
load2:
        
        lw idx, SPT (usr)
        
        lw snd, 0 * CELL (idx)
        
        lw fst, 1 * CELL (idx)

        ret

#---------------------------------------------------------------------
#
# the primitives 
# 
#---------------------------------------------------------------------

/*
h_name:
        .word h_name_up
        .word hash_name
name:
        code
*/

#---------------------------------------------------------------------
# ( -- c ) 
def_word "key", "key", 0x0, hash_key

        call _getc
        
        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", h_key, hash_emit
        
        call load2
        
        add fst, zero, snd

        call _putc
        
        j drop1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", h_emit, hash_store
        
        call load2
        
        sw fst, 0 (snd)
drop2:
        
        add idx, idx, CELL
drop1:
        
        add idx, idx, CELL
        
        sw idx, SPT (usr)
        
        j next

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", h_store, hash_fetch
        
        call load2
        
        lw fst, 0 (snd)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", h_fetch, hash_nand
        
        call load2
        
        and fst, snd, fst
        
        not fst, fst

save1:
        
        add idx, idx, CELL
        
        sw idx, SPT (usr)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", h_nand, hash_plus
        
        call load2
        
        add fst, fst, snd
        
        j save1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", h_plus, hash_notzero

        call load2

isfalse:

        beq snd, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j save0

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "s@", "state", h_zeroq, hash_userat
        
        mv fst, usr 

push1:
        
        lw idx, SPT (usr)
        
        addi idx, idx, -1 * CELL
        
        sw idx, SPT (usr)

save0:
        
        sw fst, 0 (idx)
        
        j next

#---------------------------------------------------------------------
def_word ":", "colon", h_state, hash_colon
# save here, panic if semis not follow elsewhere
        
        lw fst, HERE (usr)
        
        sw fst, ONCE (usr)

# stat is 'compile' == 1
        
        addi fst, zero, ONE
        
        sw fst, STAT (usr)

# make a header:

# copy last into (here)
        
        lw wrd, LAST (usr)
        
        call wcomma

# get following token
        
        call token
        
# copy the hash

        mv wrd, hsh

#---------------------------------------------------------------------
finish:

        call wcomma

# done
        j next 

#---------------------------------------------------------------------
def_word ";", "semis",  h_colon, hash_semis 
# update last, panic if colon not lead elsewhere 
        
        lw fst, ONCE (usr)
        
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
        
        lw idx, RPT (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, CELL
        
        sw idx, RPT (usr)

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
        
        lw idx, RPT (usr)
        
        addi idx, idx, -1 * CELL
        
        sw ipt, 0 (idx)
        
        sw idx, RPT (usr)

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

# #include "extras-milliforth.S"

#---------------------------------------------------------------------
# Beware, ends must be at last word in primitive ditionary !
#---------------------------------------------------------------------

ends:
.word 0xDEADBEEF

.end

