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
# user_size + sp_size + rp_size must be less than 2024 bytes
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
.ifdef emote 
.macro putch value
        li a3, \value
        call _putc
.endm
.endif

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
        # beat
        li t0, 0
        # tick
        li t1, 0
        # tack
        li t2, 0
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
.ifdef emote
        # emote 
        putch '\n'
        putch '?'
        putch '?'
        putch '\n'
.endif

# xxx
.ifdef missed

        # not compiling ? 
        lw fst, STAT (usr)
        # execute is zero
        beqz fst, 100f
        
        # wipe remains, reclaims space.
        lw fst, PEEK (usr)
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
        # get a hash of the next token in trd
        
        call token

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
# trd have the hash of the word
#
find:

        # get the latest link
        
        lw lnk, LAST (usr)

100:
        # verify end of dictionary 
        
        beqz lnk, miss

        # linked list
        
        mv fst, lnk

        # copy next link 
        
        lw lnk, 0 (fst)

        # copy the hash
        
        addi fst, fst, CELL

        lw hsh, 0 (fst)

        # mask the FLAG, hold it in snd

        lui snd, %hi(FLAG_IMM)

        and snd, hsh, snd

        xor hsh, hsh, snd

        # compare trd equ hash
        
        bne trd, hsh, 100b

        # points to code or list, aka xt

        addi fst, fst, CELL

#---------------------------------------------------------------------         
# snd have the flag
# fst have the address after header
eval:
        # what to do ?

        lw wrd, STAT (usr)
        
# XXX
.ifdef postpone
        li lnk, POSTPONE
        bne wrd, lnk, 100f
        li lnk, COMPILE
        sw lnk, STAT (usr)
        j compile
100:
.endif
        
        # executing ? if state == 0

        beqz wrd, execute

        # immediate ? if flaged

        bnez snd, execute      

        # compiling  
compile:
        
        call comma

        j warp

# immediate:
execute:

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
# return the hash of token in trd
# do not change the registers !
token:
        save_ra

        # prepare for hash

        lui trd, %hi(DJB2)
        addi trd, trd, %lo(DJB2)

        # load word separator, BL is space

        li spc, BL

        # skip spaces
skip:
        call _getc

        ble fst, spc, skip
        
        # djb2 hash function
hash:        

        mv snd, trd

        slli trd, trd, SFHT
        
        add trd, trd, snd
        
        xor trd, trd, fst
        
        # scan spaces
scan:
        call _getc

        blt fst, spc, scan

        bne fst, spc, hash

        # clear hash high bit 
mask:

        slli trd, trd, ONE

        srli trd, trd, ONE

        load_ra

        ret
        
#---------------------------------------------------------------------
comma:

        lw trd, HEAP (usr)
      
        sw fst, 0 (trd)
      
        addi trd, trd, CELL
      
        sw trd, HEAP (usr)

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
        
        lw trd, RPTR (usr)
        
        lw ipt, 0 (trd)
        
        addi trd, trd, CELL
        
        sw trd, RPTR (usr)

# next heart beat
next:
# xxx
.ifdef beatme
        addi t0, t0, 1
.endif

        lw fst, 0 (ipt)
        
        addi ipt, ipt, CELL

# compare address, if is a primitive then jumps, MITC 
pick:
        
        bge fst, nib, nest

# jump to primitive
jump: 
# xxx
.ifdef beatme
        addi t1, t1, 1
.endif

        # really jump and link 
        jalr ra, 0 (fst)

# return push
nest:   
# xxx
.ifdef beatme
        addi t2, t2, 1
.endif

        lw trd, RPTR (usr)
        
        addi trd, trd, -1 * CELL
        
        sw ipt, 0 (trd)
        
        sw trd, RPTR (usr)

move: 
# resolve indirect thread
        
        mv ipt, fst
        
        j next

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

