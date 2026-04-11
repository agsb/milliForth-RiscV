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
 
    Stacks moves backwards, decrease and push, pull and increase.

    Made for a little endian RiscV, cell size of 4 bytes, 32-bit

    This version relies on the .data, .text, .rodata, .bss sections 
    being in this order, the dictionary continues at .bss.

        THIS VERSION USES ONLY HASH HEADERS.

        THIS VERSION USES ONLY TOKENS. <NO TIB, NO LINES>

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

# There is no spoon.

#----------------------------------------------------------------------
# but always in RAM :)
.section .bss
.p2align 2, 0x0

# all forth variables by offset of _user

# user stack of parameter, for offsets vide defines.S
_user:
.skip user_size

# data stack grows backward
# bottom 
_spb:       
.skip sp_size
sp0: .word 0x0

# return stack grows backward
# bottom
_rpb:       
.skip rp_size
rp0: .word 0x0

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
        
        la fst, h_here
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

wipe:
        # compiling ? 
        lw fst, HEAD (usr)
        beq fst, zero, 100f
        # wipe remains
        sw fst, HEAP (usr)
        sw zero, HEAD (usr)
100:
.endif

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

#---------------------------------------------------------------------
# stat is 'interpret' == \0
        
        sw zero, STAT (usr)

#---------------------------------------------------------------------
# 
loop:

# xxx
.ifdef debug

        lw fst, STAT (usr)
        bne fst, zero, loop

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

.endif

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
#
find:

        # get a hash of the next token 
        
        call token

        # get the latest link
        
        lw lnk, LAST (usr)

100:
        # verify end of dictionary, do miss 
        
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
        
        bne trd, wrd, 100b

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
        
        call docomma

        j loop

immediate:
execute:

        la ipt, loopptr

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
token:
        pushra

        # prepare for hash

        lui trd, %hi(DJB2)
        addi trd, trd, %lo(DJB2)

        # load word separator, BL is space

        addi idx, zero, BL

        # skip spaces
100:
        call _getc

        blt fst, idx, 100b
        beq fst, idx, 100b

        # hash character
200:
# xxx
.ifdef asciis
        call pass
.endif

        # djb2 hash function
        
        mv snd, trd

        slli trd, trd, SFHT
        
        add trd, trd, snd
        
        xor trd, trd, fst
        
        # scan spaces
300:
        call _getc

        blt fst, idx, 300b
        bne fst, idx, 200b

        # clear hash high bit 
mask:

        slli trd, trd, ONE

        srli trd, trd, ONE

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
docomma:

        lw idx, HEAP (usr)
      
        sw fst, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HEAP (usr)

        ret

#---------------------------------------------------------------------
# the outer loop, need for indirect

loopptr:
        
        .word loop

#----------------------------------------------------------------------
# system dependences, linux ecall
#---------------------------------------------------------------------

#include "minimal.S"

#---------------------------------------------------------------------
# forth primitives 
#---------------------------------------------------------------------

.set last_next, 0x0

#include "primitives.S"

#----------------------------------------------------------------------
.ifdef cores

#include "cores.S"

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

