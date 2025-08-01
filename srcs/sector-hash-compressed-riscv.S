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
 
    A MilliForth for RISCV 
 
    original for the RISCV, by Alvaro G. S. Barcellos, 2025
 
    https://github.com/agsb 

    see the disclaimer file in this repository.
 
    read notes in this repository.
 
    THIS VERSION USES ONLY HASH HEADERS.

    This version relies on the .data, .text, .rodata, .bss sections 
    being in this order, the dictionary will continue at end of .bss.

    Not working yet :)

*/

#----------------------------------------------------------------------
#
# Stuff for compiler
#

# .attribute arch, rv32i

#---------------------------------------------------------------------

# uncomment to include the extras (sic)
# use_extras = 1 

# uncomment to include the extensions (sic)
# use_extensions = 1 

#---------------------------------------------------------------------
# alias 

# FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# usefull

.equ ONE, 1

.equ TWO, 2

.equ SPC, 32

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
# macro to define the header of words in dictionary
#
# makes:
#   h_name:
#   .word  link_to_previous_entry
#   .byte  strlen(name) + flags
#   .byte  name + pad
#   name:
#

# highlander, immediate flag.
.equ FLAG_IMM, 0x1

.set last_link, 0x0

.macro def_word name, label, flag
#.p2align 2, 0x00
h_\label:
.word last_link

.word 0x0
#.set last_link, h_\label + 0
\label:
.endm

# hashes can't be calculated inside macros,
# all hsh must be by hand.
# but only for few primitives :)

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC)
# for alias register names 

# forth struct pointer, constant 
#define usr sp

# instruction pointer, preserved
#define ipt s0

# memory index 
#define idx s1

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

# keep ascii space,
#define trd a5

# keep ra, return addres
#define fth a6 

#----------------------------------------------------------------------
#.section .data

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
.equ STAT, 0 

# toin next free byte in TIB
.equ TOIN, 1 

# last link cell in heap dictionary linked list
.equ LAST, 2  

# next free cell in heap dictionary, aka dpt
.equ HERE, 3 

# data stack index
.equ SPT, 4 

# return stack index
.equ RPT, 5 

# next token in TIB
.equ TOUT, 6 

# hold 'here while compile
.equ ONCE, 7 

# heap forward
.equ HEAD, 8 

# heap backward
.equ TAIL, 9 


# this is it
_user:
.skip (TAIL + 1) * CELL

# tib grows forward
_tib:       
.skip tibz

# pad grows forward
_pad:       
.skip padz

# data stack grows backward
_spb:       # bottom 
.skip spz
sp0:       .word

# return stack grows backward
_rpb:       # bottom
.skip rpz
rp0:       .word

#-----------------------------------------------------------------------
# start of user dictionary 
# anything above is not a primitive
# usually .heap
# MUST BE AT END OF .BSS
#----------------------------------------------------------------------
ends: .word 0x0

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#----------------------------------------------------------------------
.ifndef _start
.globl _start
_start:
.endif

main:
        #
        # call _init
        #

#----------------------------------------------------------------------
# do what need once
cold:
# just for sake

        fence

# load user pointer address

        la usr, _user

# load word separator, space

        addi trd, zero, SPC

#----------------------------------------------------------------------
# wipe the dictionary
warm:
# link list of headers, aka dictionary

        la hsh, h_exit
        
        sw hsh, LAST (usr)

# next heap free cell  
        
        la hsh, ends
        
        sw hsh, HERE (usr)

#---------------------------------------------------------------------
# reset TIB
reset:
        
        la idx, _tib
        
        sw zero, 0 (idx)

#---------------------------------------------------------------------
abort:
# reset data stack
        
        la idx, sp0 
        
        sw idx, SPT (usr)

        # call prompt_erro ('??\n')

#---------------------------------------------------------------------
quit:
# reset return stack
        
        la idx, rp0 
        
        sw idx, RPT (usr)

# stat is 'interpret' == \0
        
        sw zero, STAT (usr)

        j okey

#---------------------------------------------------------------------
# the outer loop, need for indirect

resolvept:
        
        .word okey

#---------------------------------------------------------------------
okey:

        # call prompt_okey ('OK\n')

#---------------------------------------------------------------------
# get a hash of the token
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
        
        beq lnk, zero, abort

# linked list
        
        mv wrd, lnk

# get next link 
        
        lw lnk, 0 (wrd)

# move to hash
        
        add wrd, wrd, CELL

        lw fst, 0 (wrd)

# mask hash flag // snd
        
        andi snd, fst, FLAG_IMM

        xor fst, fst, snd

# compare
        
        beq hsh, fst, 100f

# next link
       
       j 100b

100:
# move to code
# wrd points to or start of code or list of references

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

        call wcomma

        j resolve

#---------------------------------------------------------------------         
execute:
immediate:

        la ipt, resolvept

        j pick

#---------------------------------------------------------------------
# absolute crude getline, continues until \n
getline:
# get the TIB 
  
        la idx, _tib
        
        sw idx, TOIN (usr)

# end-of-line is newline
        
        addi snd, zero, 10

# ever start with a space
        
        mv fst, trd

# fill the TIB until \n
100:
        sb fst, 0 (idx)
        
        addi idx, idx, ONE

        call _getc

# 7-bit ascii only 
#        andi fst, 0x7F

# \n ends 
        
        bne fst, snd, 100b

# at end-of-line

# replace \n with space 
100:        
        
        sw trd, 0 (idx)

# mark eol with \0

        sw zero, 1 (idx)

        # falltrought

#---------------------------------------------------------------------
# in place every token, no rewinds
# the counter is placed at space before word
# returns a c-str

# \0 as eol goto getline

token:
# last position on tib
        
        lw idx, TOIN (usr)

# skip spaces // trd
100:
        lb fst, 0 (idx)

        beq fst, zero, getline
        
        addi idx, idx, ONE
        
        bne fst, trd, 100f

        j 100b
100:

# preserve return

        mv fth, ra

# make hash

        call djb2
        
# restore return

        mv ra, fth

# mask forth flag 
mask:

        andi fst, hsh, FLAG_IMM

        xor hsh, hsh, fst
       
# save toin

        sw idx, TOIN (usr)

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
# fth hold the end of word character ( \0 or spc)
# uses fst, snd
# hsh returns the hash 
djb2:
        # easy 3581
        addi hsh, zero, 2000

        addi hsh, hsh,  1581

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
# extras
#
#---------------------------------------------------------------------
.ifdef use_extras
.include "extras-milliforth.S"
.endif

#---------------------------------------------------------------------
#
# extensions
#
#---------------------------------------------------------------------
.ifdef use_extensions
.include "extensions-milliforth.S"
.endif

#---------------------------------------------------------------------
#
# the primitives 
# 
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# ( -- c ) 
def_word "key", "key", 0
        
        call _getc
        
        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", 0
        
        call load2
        
        call _putc
        
        j drop1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", 0
        
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
def_word "@", "fetch", 0
        
        call load2
        
        lw fst, 0 (snd)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", 0
        
        call load2
        
        and fst, snd, fst
        
        not fst, fst

save1:
        
        add idx, idx, CELL
        
        sw idx, SPT (usr)
        
        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", 0
        
        call load2
        
        add fst, fst, snd
        
        j save1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", 0

        call load2

isfalse:

        beq snd, zero, next

istrue:
        
        addi fst, zero, TRUE
        
        j save0

#---------------------------------------------------------------------
# ( -- state ), return an reference
def_word "s@", "state", 0 
        
        mv fst, usr 

push1:
        
        lw idx, SPT (usr)
        
        addi idx, idx, -1 * CELL
        
        sw idx, SPT (usr)

save0:
        
        sw fst, 0 (idx)
        
        j next

#---------------------------------------------------------------------
def_word ":", "colon", 0
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
def_word ";", "semis",  0 #FLAG_IMM
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
#---------------------------------------------------------------------
# ( -- ) 
def_word "exit", "exit", 0
unnest: #; exit
# return pull, ipt = (rpt), rpt += cell 
        
        lw idx, RPT (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, +1 * CELL
        
        sw idx, RPT (usr)

next:
# wrd = (ipt) #; ipt += cell
        
        lw wrd, 0 (ipt)
        
        addi ipt, ipt,  +1 * CELL

pick:
# compare address, if less than 'ends then is a primitive 
        
        la idx, ends
        
        blt wrd, idx, jump

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
.include "minimal.S"

#-----------------------------------------------------------------------
# BEWARE, MUST BE AT END! MINIMAL THREAD CODE DEPENDS ON IT!
#       for riscv-unknow-elf moved to end of .bss
#-----------------------------------------------------------------------

.end

