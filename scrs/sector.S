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
#----------------------------------------------------------------------

    A MilliForth for RISCV 
 
    original for the RISCV, by Alvaro G. S. Barcellos, 2025
 
    https://github.com/agsb 

    see the disclaimer file in this repository.
 
    read notes in this repository.
 
    Stacks moves backwards, decrease then push, pull then increase.

    Made for a little endian RiscV, cell size of 4 bytes, 32-bit

    This version relies on the .text, .rodata, .data, .bss sections 
    being in this order, the dictionary continues at .bss.

        THIS VERSION USES ONLY HASH HEADERS. NO NAMES, NO SIZES

        THIS VERSION USES STREAMS. NO TIB, NO LINES, NO CONTROLS

        USE ONLY ASCII TOKENS IN MIXED CASE AND BETWEEN SPACES

#----------------------------------------------------------------------
*/

#---------------------------------------------------------------------
# using pre-processor CPP (GNU GCC) for alias names 
#---------------------------------------------------------------------

#include "defines.S"

#include "registers.S" 

#---------------------------------------------------------------------
# macro to define the header of words in dictionary
#
.global def_word

.macro def_word name, label, hash, last
it_\label:
        .word \last
        .word \hash
is_\label:
.endm

#---------------------------------------------------------------------
# Riscv does not have automatic, and hidden, SP push/pull
# for nested calls, use pushra and pullra
#

.global pushra
.macro pushra
        addi sp, sp, -4   
        sw ra, 0(sp)    
.endm

.global pullra
.macro pullra
        lw ra, 0(sp)    
        addi sp, sp, +4   
.endm

#----------------------------------------------------------------------
# Nothing here, void.
.section .data
.p2align 2, 0x0

.word 0xFEEDCAFE

# There is no spoon.

#----------------------------------------------------------------------
# but always in RAM :)
.section .bss
.p2align 2, 0x0

# void at top of bss 
void: 
        .word 0x0

# all forth variables and stacks by offset of _user
# beware change offsets

# user stack of parameter, for offsets vide defines.S
_user:
.skip user_size

# data stack grows backward, bottom 
.skip sp_size
sp0: 

# return stack grows backward, bottom
.skip rp_size
rp0: 

# end of stacks
mark:
        .word 0x0

# start of user dictionary 
h_here: 
.skip RAM_LIMIT - ( h_here - _user )
h_ends:

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#---------------------------------------------------------------------
# xxx
.ifdef debug

#include "puthex.S"

.endif

#----------------------------------------------------------------------
.globl _start

#.p2align 4, 0x00

_start:

#----------------------------------------------------------------------
# go ! go ! go !
main:

# #include "testv.S"

# do any system inits
# call _init

#----------------------------------------------------------------------
# do what need be only once
cold:
# load user pointer address

        la usr, _user

# xxx 
.ifdef beatme

        sw zero, BEAT (usr)
.endif

# xxx 
.ifdef tickme

        sw zero, TICK (usr)
.endif

#----------------------------------------------------------------------
# wipe the dictionary
warm:
# next heap free cell
        
        # la fst, h_here
        addi fst, usr, user_size + sp_size + rp_size + CELL
        sw fst, HEAP (usr)

# last link list of primitives, aka dictionary

        la fst, h_last
        sw fst, LAST (usr)

#---------------------------------------------------------------------
# unexpected end of dictionary
miss:

# xxx 
.ifdef debug

        putchar '\n'

        putchar '?'
        putchar '?'

        putchar '\n'

.endif

# xxx
.ifdef missed

        # not compiling ? 
        lw fst, STATE (usr)
        beq fst, zero, 100f
        # wipe remains
        lw fst, HEAD (usr)
        sw fst, HEAP (usr)
        sw zero, STATE (usr)
100:
.endif

#---------------------------------------------------------------------
abort:
# reset data stack
        
        # la fst, sp0 
        addi fst, usr, user_size + sp_size
        sw fst, SPTR (usr)

#---------------------------------------------------------------------
quit:
# reset return stack
        
        #la fst, rp0 
        addi fst, usr, user_size + sp_size + rp_size
        sw fst, RPTR (usr)

#---------------------------------------------------------------------
# stat is 'interpret' == \0
        
        sw zero, STAT (usr)

#---------------------------------------------------------------------
# 
warp:

# xxx
.ifdef debug

        lw fst, STAT (usr)
        bne fst, zero, find

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

.endif

        # get a hash of the next token in idx
        
        call token

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
#
find:

        # get the latest link
        
        lw lnk, LAST (usr)

100:
        # verify end of dictionary 
        
        beq lnk, zero, miss

        # linked list
        
        mv fst, lnk

        # copy next link 
        
        lw lnk, 0 (fst)

        # copy the hash
        
        addi fst, fst, CELL

        lw wrd, 0 (fst)

        # mask the FLAG, hold it in snd

        lui snd, %hi(FLAG_IMM)

        and snd, wrd, snd

        xor wrd, wrd, snd

        # compare trd eq  hash
        
        bne idx, wrd, 100b

        # points to code or list, aka xt

        addi fst, fst, CELL

#---------------------------------------------------------------------         
# idx have the hash of the word
# snd have the flags
# fst have the address after header

eval:
        # what to do ?

        lw wrd, STAT (usr)
        
        # executing ? if state == 0

        beq wrd, zero, execute

        # immediate ? if flaged

        bne snd, zero, immediate      

        # compiling ? else
compile:
        
        call comma

        j warp

execute:
immediate:

        la ipt, is_warp

        j pick

#---------------------------------------------------------------------
# crude token
# load a valid sequence of ascii from stream, 
# wipes all controls (\t, \n, \r, ... ), 
# any token must be between spaces
#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
#---------------------------------------------------------------------
# magic numbers
.equ DJB2, 5381
.equ SFHT, 5
#---------------------------------------------------------------------
# return the hash of token 
# do not change the registers !
token:
        pushra

        # prepare for hash

        lui idx, %hi(DJB2)
        addi idx, idx, %lo(DJB2)

        # load word separator, BL is space

        addi trd, zero, BL

        # skip spaces
skip:
        call _getc

        bleu fst, trd, skip
        
        # djb2 hash function
hash:        

# xxx
.ifdef asciis
        call pass
.endif

        mv snd, idx

        slli idx, idx, SFHT
        
        add idx, idx, snd
        
        xor idx, idx, fst
        
        # scan spaces
scan:
        call _getc
        bltu fst, trd, scan

        bne fst, trd, hash

        # clear hash high bit 
mask:

        slli idx, idx, ONE

        srli idx, idx, ONE

        pullra

        ret
        
#---------------------------------------------------------------------
pass:

# xxx
100:
.ifdef asciionly

        andi fst, fst, 127

.endif

# xxx
200:
.ifdef loweronly

        addi a7, zero, 'A'       
        blt fst, a7, 300f

        addi a7, zero, 'Z'      
        blt a7, fst, 300f
        
        # set the 6th bit, 
        ori fst, fst, 32     
        
.endif

# xxx
300:
.ifdef upperonly

        addi a7, zero, 'a'       
        blt fst, a7, 400f

        addi a7, zero, 'z'      
        blt a7, fst, 400f
        
        # clear the 6th bit, 
        andi fst, fst, 95     
        
.endif

        ret

#---------------------------------------------------------------------
comma:

        lw idx, HEAP (usr)
      
        sw fst, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HEAP (usr)

        ret

#---------------------------------------------------------------------
# the outer loop, need for indirect

is_warp:
        
       .word warp

#---------------------------------------------------------------------
# Minimal Indirect Thread Code Engine
#
# this is the Forth heart beat.
#
# nest aka enter or docol, 
# 
# unnest aka exit or semis
#
# ipt must stay preserved outside, ever.
#
# "why there is no 'docol at start of words ?"
#
unnest: 
# return pull 
        
        lw idx, RPTR (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, CELL
        
        sw idx, RPTR (usr)

next:

# xxx
# count beats as next executions
.ifdef beatme
        lw idx, BEAT (usr)

        addi idx, idx, 1
        
        sw idx, BEAT (usr)
.endif

        lw fst, 0 (ipt)
        
        addi ipt, ipt, CELL

pick:
# compare address, if is a primitive then jumps, MITC 
        
        la idx, ends
        
        bge fst, idx, nest

jump: 
# jump to primitive
        
# xxx
# count ticks as primitive executions
.ifdef tickme
        lw idx, TICK (usr)

        addi idx, idx, 1
        
        sw idx, TICK (usr)
.endif

        # really jump and link 
        jalr ra, 0 (fst)

nest:   
# return push
        
        lw idx, RPTR (usr)
        
        addi idx, idx, -1 * CELL
        
        sw ipt, 0 (idx)
        
        sw idx, RPTR (usr)

move: 
# indirect access 
        
        mv ipt, fst
        
        j next

#----------------------------------------------------------------------
# system dependences, linux ecall
#---------------------------------------------------------------------

#include "linuxecall.S"

#---------------------------------------------------------------------
# forth minimal 
#---------------------------------------------------------------------

.set last_next, 0x0

#include "minimals.S"

#----------------------------------------------------------------------
.ifdef primitives

#include "primitives.S"

.endif

#----------------------------------------------------------------------
.ifdef maths

#include "maths.S"

.endif

#----------------------------------------------------------------------
.ifdef debug

#include "debug.S"

.endif

#----------------------------------------------------------------------
.set h_last, last_next

#---------------------------------------------------------------------
# Beware, ends must be at last word behind native ditionary !
# it is used to know if a 'address' is primitive or not
#---------------------------------------------------------------------

ends:

#---------------------------------------------------------------------
.end

