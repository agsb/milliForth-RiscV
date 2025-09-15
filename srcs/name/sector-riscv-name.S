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

    Stacks moves backwards, decrease and push, pull and increase.

    Made for a little endian RiscV, cell size of 4 bytes, 32-bit

    Riscv does not have automatic hidden SP push/pull

    This version relies on the .data, .text, .rodata, .bss sections 
    being in this order, the dictionary will continue at end of .bss.

    THIS VERSION USES ONLY NAME HEADERS.

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

# MSF bit, is the flag
.equ FLAG_IMM, 128

# LSB bits, are size (32 maximum)
.equ MASK_IMM, 127

#---------------------------------------------------------------------


#---------------------------------------------------------------------
# macro to define the header of words in dictionary
#
.global def_word

.macro def_word name, label, last, flag
.p2align 2, 0x00
h_\label:
        .word \last
        size = 2f - 1f
        .byte \flag + size
1:
        .ascii "\name"
2:
        .balign 4, 0x00
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
/*
# xxx 
        putchar '\n'
        putchar '?'
        putchar '?'
        putchar '\n'
*/
#---------------------------------------------------------------------
miss:

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

/*
# xxx
        lw fst, STAT (usr)
        bne fst, zero, resolve

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'
*/

#---------------------------------------------------------------------
# get a c-str in fst and size in snd, pointer in idx
resolve:
        
        call token

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
#
tick:

# get the latest link
        
        lw lnk, LAST (usr)

100:
# verify end of dictionary
        
        beq lnk, zero, miss

# linked list
        
        add fst, zero, lnk

# copy next link 
        
        lw lnk, 0 (fst)

        add fst, fst, CELL

# get size and flags, first byte

        # from dictionary

        lb snd, 0 (fst)

        # from word token

        lb trd, 0 (idx)
        
        # save the flag
        andi hsh, snd, 0x80
        # wipe the flag 
        andi snd, snd, 0x7F
        # test size equal
        bne trd, snd, 100b

# crude strcmp

        add t0, zero, idx
        add t1, zero, fst

200:
        addi t0, t0, 1
        addi t1, t1, 1
        lb t2, 0 (t0)
        lb t3, 0 (t1)
        bne t2, t3, 100b

        addi snd, snd, -1
        bne snd, zero, 200b

        # need adjust balign 
        # ((n + 3) & ~3) 

        addi t1, t1, 3
        andi fst, t1, ~3

#---------------------------------------------------------------------         
eval:
# wrd points to or start of code or list of references

# immediate ? 

        bne hsh, zero, immediate      

# executing ? if state == 0
        
        lw snd, STAT (usr)
        
        beq snd, zero, execute

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
/*
miss:

        putchar '?'

100:
        lb fst, 0 (s10)
        call _putc 
        beq fst, trd, 100f
        add s10, s10, 1
        j 100b
100:
        putchar '?'

        j error

        # compiling ?
        lw fst, STAT (usr)
        bne fst, zero, 100f
        # wipe remains
        lw fst, HEAD (usr)
        sw fst, HERE (usr)
100:
        j error
*/
# xxx )---------------------------------------------------------------

#---------------------------------------------------------------------
# in place every token, no rewinds, returns idx, a pointer to c-str
# \s is space, \0 as eol
token:

        pushra

# load word separator, space

        addi trd, zero, BL

100:

# last position on tib
        lw idx, TOIN (usr)

# skip spaces, 
# \s \0 ends line
200:
        lb fst, 0 (idx)

        beq fst, zero, gets

        bne fst, trd, 200f

        addi idx, idx, ONE

        j 200b

# scan spaces // trd
        add snd, zero, idx

200:
        lb fst, 0 (snd)

        # every word ends with \s
        # beq snd, zero, gets 

        beq fst, trd, 200f

        addi snd, snd, ONE

        j 200b
# 
200:
        sw snd, TOIN (usr)

        sub snd, snd, idx
        
        addi idx, idx, (0 - ONE)

        sw snd, 0 (idx)

        pullra

        ret

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

#---------------------------------------------------------------------
docomma:

        lw idx, HERE (usr)
      
        sw fst, 0 (idx)
      
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
def_word "key", "key", 0x0, 0x0

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", h_key, 0x0
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", h_emit, 0x0
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi idx, idx, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", h_store, 0x0
        
        call pull2
        
        lw fst, 0 (fst)
        
        j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", h_fetch, 0x0
        
        call pull2

        and fst, fst, snd
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", h_nand, 0x0
        
        call pull2

        add fst, fst, snd
        
        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", h_plus, 0x0

        call pull2
        
isfalse:

        beq fst, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j back1

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "u@", "userat", h_zeroq, 0x0
        
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
def_word ":", "colon", h_userat, 0x0
# save here, panic if semis not follow elsewhere
        
        lw fst, HERE (usr)
        
        sw fst, HEAD (usr)

# stat is 'compile' == 1
        
        add fst, zero, ONE
        
        sw fst, STAT (usr)

# make a header

create:

# copy last into (here)
        
        lw fst, LAST (usr)
        
        call docomma

# get following token
        
        call token
        
# idx points to a c-str, snd is sizeof

# write cells
100:
        lw fst, 0 (idx)
        call docomma
        add idx, idx, CELL
        add snd, snd, (0 - CELL)
        bgt snd, zero, 100b

        j next 

#---------------------------------------------------------------------
# ( -- )
def_word ";", "semis", h_colon, FLAG_IMM
# update last, panic if colon not lead elsewhere 
        
        lw fst, HEAD (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        sw zero, STAT (usr)

finish:
# compound words must ends with exit
        
        la fst, exit

comma:
        call docomma
        j next

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
def_word "exit", "exit", h_semis, 0x0
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

#.equ EXTRAS, YES

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

