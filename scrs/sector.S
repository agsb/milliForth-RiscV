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
# for two level nested calls, use save_ra and load_ra
# ever use as macro

# one deep

.macro  save_ra
        mv rak, ra
.endm

.macro  load_ra
        mv ra, rak
.endm

#----------------------------------------------------------------------
# Nothing here, void.
.section .data
.p2align 4, 0x0

.word 0xFEEDCAFE

# There is no spoon.

#----------------------------------------------------------------------
# but always in RAM :)
.section .bss
.p2align 4, 0x0

# void at top of bss 

# all forth variables and stacks by offset of _user
# beware change offsets

# user stack of parameter, for offsets vide defines.S
_user:
.skip user_size

# data stack grows backward, bottom 
_spz:
.skip sp_size
_sp0: 
        # top of data stack, keep
        .word 0x0

# return stack grows backward, bottom
_rpz:
.skip rp_size
_rp0: 
        # top of return stack, keep
        .word 0x0

#----------------------------------------------------------------------
# NOTE:
# user_size + sp_size + rp_size must be less than 1024 bytes
# because code uses addi (+12bits) to setup offset address
#----------------------------------------------------------------------

# user dictionary 
.word 0x0

# at start of memory
h_where: 
.skip RAM_LIMIT - ( h_where - _user )
# to end of  memory
h_there:

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

#---------------------------------------------------------------------
# xxx
.ifdef tools

#include "puthex.S"

.endif

#----------------------------------------------------------------------
.globl _start

#.p2align 4, 0x00

_start:

#----------------------------------------------------------------------
# go ! go ! go !
main:

# do any system initializations
# call _init

#----------------------------------------------------------------------
# do what need be only once
cold:
# load constant pointer address

        la usr, _user

        la nib, _nibs
        
        la bow, is_warp

# xxx 
.ifdef beatme

        sw zero, BEAT (usr)

        sw zero, TICK (usr)

        sw zero, TACK (usr)

.endif

#----------------------------------------------------------------------
# wipe the dictionary
warm:
# last link list of primitives, aka dictionary

        la fst, h_last
        sw fst, LAST (usr)

# next heap free cell
        
        # la fst, h_where
        addi fst, usr, user_size + sp_size + CELL + rp_size + CELL 
        sw fst, HEAP (usr)

#---------------------------------------------------------------------
# unexpected end of dictionary
miss:

# xxx 
.ifdef tools

        # emote 
        putchar '\n'
        putchar '?'
        putchar '?'
        putchar '\n'

.endif

# xxx
.ifdef missed

        # not compiling ? 
        lw fst, STAT (usr)
        # execute is zero
        beq fst, zero, 100f
        
        # wipe remains, reclaims space.
        lw fst, FAUX (usr)
        sw fst, HEAP (usr)
        li fst, EXECUTE
        sw fst, STAT (usr)
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
        addi fst, usr, user_size + sp_size + CELL + rp_size
        sw fst, RPTR (usr)

#---------------------------------------------------------------------
# stat is 'interpret' == \0
        
        li fst, EXECUTE
        sw fst, STAT (usr)

#---------------------------------------------------------------------
# 
warp:

# xxx
.ifdef tools

        # not compiling ?
        lw fst, STAT (usr)
        # execute is zero
        bne fst, zero, 100f

        # emote 
        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

100:
.endif

        # get a hash of the next token in idx
        
        call token

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
# idx have the hash of the word
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

        # compare trd equ hash
        
        bne idx, wrd, 100b

        # points to code or list, aka xt

        addi fst, fst, CELL

#---------------------------------------------------------------------         
# snd have the flag
# fst have the address after header
eval:
        # what to do ?

        lw wrd, STAT (usr)
        
        # executing ? if state == 0

        beq wrd, zero, execute

        # immediate ? if flaged

        bne snd, zero, immediate      

        # compiling  
compile:
        
        call comma

        j warp

execute:
immediate:

        mv ipt, bow

        j pick

#---------------------------------------------------------------------
# crude token
# load a valid sequence of ascii from stream, wipes all controls, 
# any token must be between spaces
#----------------------------------------------------------------------
# djb2 hash function
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
#---------------------------------------------------------------------
# magic numbers
.equ DJB2, 5381
.equ SFHT, 5
#---------------------------------------------------------------------
# return the hash of token in idx 
# do not change the registers !
token:
        save_ra

        # prepare for hash

        lui idx, %hi(DJB2)
        addi idx, idx, %lo(DJB2)

        # load word separator, BL is space

        li trd, BL

        # skip spaces
skip:
        call _getc

        bleu fst, trd, skip
        
        # djb2 hash function
hash:        

        mv snd, idx

        slli idx, idx, SFHT
        
        add idx, idx, snd
        
        xor idx, idx, fst
        
        # scan spaces
scan:
        call _getc

        # andi fst, fst, 127

        bltu fst, trd, scan

        bne fst, trd, hash

        # clear hash high bit 
mask:

        slli idx, idx, ONE

        srli idx, idx, ONE

        load_ra

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
#---------------------------------------------------------------------
# return pull 
unnest: 
        
        lw idx, RPTR (usr)
        
        lw ipt, 0 (idx)
        
        addi idx, idx, CELL
        
        sw idx, RPTR (usr)

# next heart beat
next:
# xxx
.ifdef beatme
        call beats
.endif

        lw fst, 0 (ipt)
        
        addi ipt, ipt, CELL

# compare address, if is a primitive then jumps, MITC 
pick:
        
        # la idx, _ends
        # bge fst, idx, nest
        
        bge fst, nib, nest

# jump to primitive
jump: 
# xxx
.ifdef beatme
        call ticks
.endif

        # really jump and link 
        jalr ra, 0 (fst)

# return push
nest:   
# xxx
.ifdef beatme
        call tacks
.endif

        lw idx, RPTR (usr)
        
        addi idx, idx, -1 * CELL
        
        sw ipt, 0 (idx)
        
        sw idx, RPTR (usr)

move: 
# resolve indirect thread
        
        mv ipt, fst
        
        j next

#----------------------------------------------------------------------
# xxx
.ifdef beatme

# count heart beats 
beats:
        lw idx, BEAT (usr)

        addi idx, idx, 1
        
        sw idx, BEAT (usr)

        ret

# count ticks as primitive executions
ticks:
        lw idx, TICK (usr)

        addi idx, idx, 1
        
        sw idx, TICK (usr)

        ret

# count tacks as composed executions
tacks:
        lw idx, TACK (usr)

        addi idx, idx, 1
        
        sw idx, TACK (usr)

        ret

.endif
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# system dependences, linux ecall
#---------------------------------------------------------------------

#include "syscalls.S"

#---------------------------------------------------------------------
# forth words
#---------------------------------------------------------------------

#----------------------------------------------------------------------
.set last_next, 0x0

#include "minimals.S"

#----------------------------------------------------------------------
.ifdef primitives

#include "primitives.S"

.endif

#----------------------------------------------------------------------
.ifdef tools

#include "tools.S"

.endif

#----------------------------------------------------------------------
.set h_last, last_next

#---------------------------------------------------------------------
# Beware, ends must be at last word behind native ditionary !
# it is used to know if a 'address' is primitive or not
#---------------------------------------------------------------------

_nibs:

#---------------------------------------------------------------------
.end

