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

        ONLY ASCII TOKENS IN MIXED CASE AND BETWEEN SPACES

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

.word 0xDEADBEEF

# There is no spoon.

#----------------------------------------------------------------------
# but always in RAM :)
.section .bss
.p2align 2, 0x0

# void at top of bss, used in _getc _putc 
# address MUST have lower 12 bits zeros
void: 
        .word 0x0

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
# last link list of primitives, aka dictionary

        la fst, h_last
        sw fst, LAST (usr)

# next heap free cell
        
        la fst, h_here
        sw fst, HEAP (usr)

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
knot:

# xxx
.ifdef debug

        lw fst, STAT (usr)
        bne fst, zero, find

        putchar '\n'
        putchar 'O'
        putchar 'K'
        putchar '\n'

.endif

#---------------------------------------------------------------------         
# search for a hash in dictionary linked list 
#
find:

        # get a hash of the next token in idx
        
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
        
        call docomma

        j knot

execute:
immediate:

        la ipt, knotptr

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
100:
        call _getc

        blt fst, trd, 100b
        beq fst, trd, 100b

        # hash character
200:
# xxx
.ifdef asciis
        call pass
.endif

        # djb2 hash function
        
        mv snd, idx

        slli idx, idx, SFHT
        
        add idx, idx, snd
        
        xor idx, idx, fst
        
        # scan spaces
300:
        call _getc

        blt fst, trd, 300b
        bne fst, trd, 200b

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
docomma:

        lw idx, HEAP (usr)
      
        sw fst, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HEAP (usr)

        ret

#---------------------------------------------------------------------
# the outer loop, need for indirect

knotptr:
        
        .word knot

#----------------------------------------------------------------------
# system dependences, linux ecall
#---------------------------------------------------------------------

#include "minimal.S"

#---------------------------------------------------------------------
# forth primitives 
#---------------------------------------------------------------------

.set last_next, 0x0

#---------------------------------------------------------------------
# primitives djb2 hash cleared of bit 31
#
#---------------------------------------------------------------------
# symbols ! @ + 0# : ;

.equ hash_store, 0x0002B584 
.equ hash_fetch, 0x0002B5E5 
.equ hash_plus,  0x0002B58E 
.equ hash_zeroq, 0x00596816 
.equ hash_colon, 0x0002B59F 
.equ hash_semis, 0x8002B59E # unique with FLAG_IMM 

.equ hash_KEY,   0x0B87F112
.equ hash_EMIT,  0x7C7C87D0
.equ hash_NAND,  0x7C8254C0
.equ hash_USERAT, 0x005973B0
.equ hash_EXIT,  0x7C7CC745

#---------------------------------------------------------------------

.equ init_primitives, last_next

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

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semis
def_word "EXIT", "exit", hash_EXIT, init_primitives
        
        j unnest

#---------------------------------------------------------------------
# ( -- ), ; aka figforth colon 
def_word ":", "colon", hash_colon, it_exit
# save here, panic if semis not follow elsewhere
        
        lw fst, HEAP (usr)
        
        sw fst, HEAD (usr)

# stat is 'compile' == 1
        
        addi fst, zero, ONE
        
        sw fst, STAT (usr)

# make a header

create:

# copy last into (here)
        
        lw fst, LAST (usr)
        
        call docomma

# get a hash of the next token
        
        call token

# copy hash into (here)

        mv fst, idx

comma:

        call docomma

        j next 

#---------------------------------------------------------------------
# ( -- ) ; aka figforth semicolon
def_word ";", "semis", hash_semis, it_colon 
# update last, panic if colon not lead elsewhere 
        
        lw fst, HEAD (usr)
        
        sw fst, LAST (usr)

# stat is 'interpret' == 0
        
        sw zero, STAT (usr)

finish:
# compound words must ends with exit
        
        la fst, is_exit

        j comma

#---------------------------------------------------------------------
# ( -- c ) 
def_word "KEY", "key", hash_KEY, it_semis 

        call _getc

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "EMIT", "emit", hash_EMIT, it_key
        
        call pull2

        call _putc

        j save1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", hash_store, it_emit
        
        call pull2

        sw snd, 0 (fst)

drop1:
        addi idx, idx, CELL

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", hash_fetch, it_store
        
        call look0
        
        lw fst, 0 (fst)
        
keep0:
        sw fst, 0 (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "NAND", "nand", hash_NAND, it_fetch
        
        call pull2

        and fst, fst, snd
        
        not fst, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1 + w2  
def_word "+", "plus", hash_plus, it_nand
        
        call pull2

        add fst, fst, snd
        
        j keep1

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
def_word "0#", "zeroq", hash_zeroq, it_plus

        call pull2
        
        beq fst, zero, next

        addi fst, zero, TRUE
        
        j back1

#---------------------------------------------------------------------
# beware variables order
# ( -- _user ) return an reference to _user structure
def_word "U@", "userat", hash_USERAT, it_zeroq
        
        mv fst, usr 

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
pull2:
        
        lw idx, SPTR (usr)
        
        lw fst, 0 (idx)
        
        addi idx, idx, CELL

        lw snd, 0 (idx)

        ret

look0:
        lw idx, SPTR (usr)

        lw fst, 0 (idx)

        ret

#---------------------------------------------------------------------

.set last_next, it_userat

#---------------------------------------------------------------------

.equ init_cores, last_next

#---------------------------------------------------------------------

.equ hash_SUB, 0x0002B588 

.equ hash_PER, 0x0002B580 
.equ hash_DIV, 0x0002B58A 
.equ hash_MUL, 0x0002B58F

.equ hash_EQU, 0x0002B598 
.equ hash_LESS, 0x0002B599 

.equ hash_CTO, 0x00597287 
.equ hash_CAT, 0x005972E6 

.equ hash_RAT, 0x00597497 
.equ hash_TOR, 0x005968A9 
.equ hash_RTO, 0x005974E9 

.equ hash_AND, 0x0B87B72E 
.equ hash_OR, 0x00597378 
.equ hash_XOR, 0x0B883040 
.equ hash_NOT, 0x0B87D3D0 
.equ hash_NEG, 0x0B87D489 

.equ hash_DUP, 0x0B87BC84 
.equ hash_DROP, 0x7C7F5C2C 
.equ hash_OVER, 0x7C84398B 
.equ hash_SWAP, 0x7C8A3910 
.equ hash_ROT, 0x0B8807CC 
.equ hash_NROT, 0x7C4E8CA1 

.equ hash_RPAT, 0x0B880527 
.equ hash_RPTO, 0x0B880546 

.equ hash_SPTO, 0x0B881187 
.equ hash_SPAT, 0x0B8811E6 

.equ hash_LIT, 0x0B87DB14 
.equ hash_BRANCH, 0x1E6C4191 
.equ hash_ZBRANCH, 0x7D28616B

.equ hash_DOT, 0x0002B58B

.equ hash_ALIGN, 0x0C531CC8 

.equ hash_TRUE, 0x7C879BF3
.equ hash_FALSE, 0x0C3C6778

.equ hash_NAN, 0x0B87D404
.equ hash_ONE, 0x00002B594
.equ hash_TWO, 0x00002B597
.equ hash_CELL, 0x07C81B0A3

.equ hash_DOCODE, 0x075D9A73
.equ hash_ABORT, 0x0A1DFF4F
.equ hash_BYE, 0x0B874AFB

.equ hash_sfl, 0x0059685D
.equ hash_sfr, 0x00596858

.equ hash_plusto, 0x0059676F
.equ hash_STAT, 0x0DD1F032
.equ hash_LAST, 0x2ADAAFBE
.equ hash_HEAP, 0x00597251

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; align to cell, word is 4 bytes
def_word "ALIGN", "align", hash_ALIGN, init_cores

        call look0

        addi fst, fst, 3

        andi fst, fst, ~3

        j keep0

#---------------------------------------------------------------------
# ( w -- w*2 ) #; shift left
def_word "2*", "sfl", hash_sfl, it_align

        call look0
        
        slli fst, fst, 1
        
        j keep0

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", hash_sfr, it_sfl

        call look0
        
        srli fst, fst, 1
        
        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NOT w
def_word "NOT", "nots", hash_NOT, it_sfr

        call look0

        # xori fst, fst, -1
        not fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w1 -- w2 ) #; NEG w
def_word "NEG", "negs", hash_NEG, it_nots

        call look0

        # sub fst, zero, fst
        neg fst, fst

        j keep0

#---------------------------------------------------------------------
# ( w -- w w ) #; duplicate tos
def_word "DUP", "dups", hash_DUP, it_negs

        call look0

        j back1

#---------------------------------------------------------------------
# ( w -- ) #; drop tos
def_word "DROP", "drop", hash_DROP, it_dups

        j drop1

#---------------------------------------------------------------------
# ( w1 w2 -- w1 w2 w1 ) #; over tos
def_word "OVER", "over", hash_OVER, it_drop

        call look0

        lw fst, CELL (idx)

        j push1

#---------------------------------------------------------------------
# ( w1 w2 -- w2 w1 ) #; over tos
def_word "SWAP", "swap", hash_SWAP, it_over

        call look0

        lw snd, CELL (idx)

        sw snd, 0 (idx)

        sw fst, CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w2 w3 w1 ) #; rot tos
def_word "ROT", "rot", hash_ROT, it_swap

        call look0

        lw snd, CELL (idx)
        
        lw trd, 2 * CELL (idx)

        sw trd, 0 (idx)

        sw fst, CELL (idx)

        sw snd, 2 * CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 w3 -- w3 w1 w2 ) #; rot tos
def_word "-ROT", "nrot", hash_NROT, it_rot

        call look0

        lw snd, CELL (idx)
        
        lw trd, 2 * CELL (idx)

        sw snd, 0 (idx)

        sw trd, CELL (idx)

        sw fst, 2 * CELL (idx)

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 - w2
def_word "-", "sub", hash_SUB, it_nrot

        call pull2

        sub fst, snd, fst

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 AND w2
def_word "AND", "and", hash_AND, it_sub

        call pull2

        and fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "OR", "or", hash_OR, it_and

        call pull2

        or fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 OR w2 
def_word "XOR", "xor", hash_XOR, it_or

        call pull2

        xor fst, fst, snd

        j keep1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 = w2 
def_word "=", "equ", hash_EQU, it_false

        call pull2

        bne fst, snd, isfalse

istrue:
        addi fst, zero, TRUE

        j keep0

isfalse:
        addi fst, zero, FALSE

        j keep0

#---------------------------------------------------------------------
# ( w1 w2 -- w3 ) #; w1 < w2 
def_word "<", "less", hash_LESS, it_equ

        call pull2

        blt snd, fst, istrue

        j isfalse

#---------------------------------------------------------------------
# ( -- w ) #; @
def_word "R@", "rat", hash_RAT, it_less

rlook0:
        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; the value is at second cell
def_word "R>", "rto", hash_RTO, it_rat

rpull1:
        lw idx, RPTR (usr)

        # load value

        lw fst, CELL (idx)

        # load return

        lw snd, 0 (idx)

        addi idx, idx, +1 * CELL

        # save return 

        sw snd, 0 (idx) 

        sw idx, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( w --  ; -- w ) #; @
def_word ">R", "tor", hash_TOR, it_rto

        call pull2 

        lw idx, RPTR (usr)

        # load return

        lw snd, 0 (idx) 

        # save value

        sw fst, 0 (idx) 

        addi idx, idx, -1 * CELL

        # save return

        sw snd, 0 (idx)

        sw idx, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP@", "rpat", hash_RPAT, it_tor

        lw fst, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "RP!", "rpto", hash_RPTO, it_rpat

        call pull2

        sw fst, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP@", "spat", hash_SPAT, it_rpto

        lw fst, SPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- w ; w -- ) #; @
def_word "SP!", "spto", hash_SPTO, it_spat

        call pull2

        sw fst, SPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; @
def_word "BRANCH", "branch", hash_BRANCH, it_spto

branch:
        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        lw snd, 0 (fst)

        add fst, fst, snd

        sw fst, 0 (idx)

        j next

#---------------------------------------------------------------------
# ( -- ; -- ) #; @
def_word "0BRANCH", "branchz", hash_ZBRANCH, it_branch
        
        call pull2

        beq fst, zero, branch

rdrop1:
        lw idx, RPTR (usr)

        addi idx, idx, +1 * CELL

        sw idx, RPTR (usr)

        j next

#---------------------------------------------------------------------
# ( -- w ) #; @
def_word "LIT", "lit", hash_LIT, it_branchz

        lw idx, RPTR (usr)

        lw fst, 0 (idx)

        addi idx, idx, +1 * CELL

        sw idx, RPTR (usr)

        j push1

#---------------------------------------------------------------------
# ( -- TRUE ) #; push 0xFFFFFFFF 
def_word "TRUE", "true", hash_TRUE, it_lit
        
        addi fst, zero, TRUE 

        j push1

#---------------------------------------------------------------------
# ( -- FALSE ) #; push 0x00000000
def_word "FALSE", "false", hash_FALSE, it_true

        addi fst, zero, FALSE 

        j push1

#---------------------------------------------------------------------
# ( -- 1 ) #; push 0x00000001
def_word "1", "one", hash_ONE, it_false

        addi fst, zero, ONE

        j push1

#---------------------------------------------------------------------
# ( -- 2 ) #; push 0x00000002
def_word "2", "two", hash_TWO, it_one

        addi fst, zero, TWO

        j push1

#---------------------------------------------------------------------
# ( -- 4 ) #; push 0x00000004
def_word "CELL", "cell", hash_CELL, it_two

        addi fst, zero, CELL

        j push1

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "NAN", "nan", hash_NAN, it_cell
by_zero:
by_erro:
        
        lui fst, 0x80000
        
        j push1

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "STATE", "stat", hash_STAT, it_nan
        
        lw fst, STAT (usr)
        
        j push1

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "LATEST", "last", hash_LAST, it_stat
        
        lw fst, LAST (usr)
        
        j push1

#---------------------------------------------------------------------
# ( -- ) push 0x80000000
def_word "DP", "heap", hash_HEAP, it_last
        
        lw fst, HEAP (usr)
        
        j push1

#---------------------------------------------------------------------
# ( -- ) execute a jump and link to a reference at IP
def_word ";CODE", "docode", hash_DOCODE, it_heap

        jalr ra, 0 (ipt)

        j next

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "ABORT", "aborts", hash_ABORT, it_docode

        j abort

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "BYE", "byes", hash_BYE, it_aborts

        j _exit

#---------------------------------------------------------------------
# ( w -- ) #; @
def_word ".", "dot", hash_DOT, it_byes

        call pull2

        call tohex

        j next
        
#---------------------------------------------------------------------
# ( w -- ) #; @
def_word "+!", "plusto", hash_plusto, it_dot

        call pull2

        lw idx, 0 (fst)

        add snd, snd, idx

        sw snd, 0 (fst)

        j drop1
        
#---------------------------------------------------------------------

.set last_next, it_plusto

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#
.global tohex
tohex:

        pushra

        add  snd, zero, fst
        
        addi trd, zero, 58

        addi t0, zero, 32

        # rolls 
100:
        beq t0, zero, 300f

        addi t0, t0, -4

        srl  fst, snd, t0

        andi fst, fst, 15
        ori  fst, fst, 48
        blt  fst, trd, 200f
        addi fst, fst, 7
200:
        call _putc
        
        j 100b

300:

        pullra

        ret

#---------------------------------------------------------------------

.equ init_math, last_next

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#

.equ hash_BYMOD, 0x7C4D1C6C  
.equ hash_BYMUL, 0x7C4FB089

.equ hash_MUL, 0x0002B58F  
.equ hash_DIV, 0x0002B58A  
.equ hash_MSTAR, 0x005972C2  
.equ hash_UMSTAR, 0x0B87EB77  
.equ hash_FMBYMOD, 0x14CB69A7  
.equ hash_SMBYMOD, 0x49BE2C12  

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) double multiply,  
def_word "*MOD", "bymul", hash_BYMUL, init_math
        
        call pull2
        mulh trd, fst, snd
        mul snd, fst, snd

push2:
        sw snd, 0 (idx)
        add fst, trd, zero
	j back1

#---------------------------------------------------------------------
# ( w1 w2 -- w3 w4 ) divide
def_word "/MOD", "bymod", hash_BYMOD, it_bymul
        
        call pull2
	beqz snd, by_zero
        div trd, fst, snd
        rem snd, fst, snd
	j push2

#---------------------------------------------------------------------

.set last_next, it_bymod

#---------------------------------------------------------------------
# to review 

# ( n1 n2 n3 -- n4 ) #; n1 n2 * n3 / 
# n1 n2 * gives a double cell then divide by n3 give a single cell
#def_word "*/", "starslash", hash_starslash, it_dot

# ( n1 n2 n3 -- n4 n5 ) #; n1 n2 * n3 / 
# n1 n2 * gives a double cell then divide by n3 give a 
# reminder n4 and quontient n5
#def_word "*/MOD", "starslashmod", hash_starslashmod, it_dot

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

