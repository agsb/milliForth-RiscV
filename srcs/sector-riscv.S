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
 
    More info at end of this file.
 
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

# cell size, 4 bytes, 32-bit
.equ CELL, 4

# highlander, immediate flag.
.equ FLAG_IMM, 1 << 7

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
#   f_name:
#   .word  link_to_previous_entry
#   .byte  strlen(name) + flags
#   .byte  name + pad
#   name:
#
# catch:
# the label 1: is used for get last link address for list dictionary 
##
.macro def_word name, label, flags=0x0
.p2align 2, 0x00
h_\label:
       .word 1b
1:
       .byte \flags
       .byte (3f - 2f) 
2:
       .ascii "\name"
3:
       .p2align 2, 0x20        
\label:
.endm

#---------------------------------------------------------------------
/*
 NOTES:

 Not finished yet :)

 Why ".equ name, register", does not work ?
 Mmaybe reserved words can not be aliased ?
 Also r0 must ever be called as zero.

 I dunno about another way to make register name alias
 So, using cpp to pre-process the alias, like:

 #define mytmp  t1     

 Almost all memory access must be indirectd by a register
 eg. lw rd, offset (ro); sw ro, offset (rd);
 and millifort uses a struct for pointers, then need:
 reserve one register (usr) for the pointer to this structure
 and another (idx) to use as temporary index value

 The indirect code defaults:

wpull:
# load the index of data stack
        lw idx, SPT (usr)
# pull the value
        lw fst, 0 (idx)
# update the index
        addi idx, idx, +1 * CELL
# save the index
        sw idx, SPT (usr)
wpush:
# load the index of data stack
        lw idx, SPT (usr)
# update the index
        addi idx, idx, -1 * CELL
# pull the value
        sw fst, 0 (idx)
# save the index
        sw idx, SPT (usr)

But which registers ?

The convention for R32* ISA for interrupts, keeps ra, t0-t2, a0-a5
and the gcc __attribute__((interrupt)) keeps which are used inside,

Remember, all code must be align to CELL size !

*/

# for pre-processor CPP (GNU GCC)

# forth struct pointer, constant 
#define usr a0

# instruction pointer, preserved
#define ipt a1

# memory index 
#define idx a2

# link pointer
#define lnk a3

# word pointer
#define wrd a4

# compare value
#define fth a5

# some auxiliars
#define fst t0
#define snd t1
#define trd t2

#----------------------------------------------------------------------
# dont use data, it blows the file
#.section .data

#----------------------------------------------------------------------
# better
# assure all zeroes

.section .bss
.p2align 2, 0x0

# user structure of internal Forth variables
# ATT: the order matters for forth !

# name some offsets

# state flag
.equ STAT, 0 * CELL
# toin next free byte in TIB
.equ TOIN, 1 * CELL
# last link cell in heap dictionary linked list
.equ LAST, 2  * CELL
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
.skip 10 * CELL

# tib grows forward
_tib:       
.skip tibz

# pad grows forward
_pad:       
.skip padz

# stacks grows backward

_spb:       # bottom 
.skip spz
sp0:       .word

_rpb:       # bottom
.skip rpz
rp0:       .word

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

       j main

#----------------------------------------------------------------------
# catch for header macro
1: .word 0x0

#----------------------------------------------------------------------
# system dependences, linux ecall
#
.include "minimal.S"

#----------------------------------------------------------------------
main:

# disable interrupts, sei

# do something about a0 and a1

# do save what needs

# do etc

# enable interrupts, cli

#----------------------------------------------------------------------
# do what need once
cold:

# load user pointer address
    
        fence

        la usr, _user

#----------------------------------------------------------------------
warm:
# link list of headers, aka dictionary
        la idx, h_exit
        sw idx, LAST (usr)

# next heap free cell  
        la idx, ends
        sw idx, HERE (usr)

#---------------------------------------------------------------------
# clean TIB
reset:
        la idx, _tib
        sw zero, 0 (idx)

        #sw idx, TOIN (usr)
        #sw idx, TOUT (usr)

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
# the outer loop, need for indirects

resolvept:
        .word okey

#---------------------------------------------------------------------
okey:

        # call prompt_okey ('OK\n')

#---------------------------------------------------------------------
resolve:
# get a token, return 
        call token

# get the size of token 

        #; lda #'P'
        #; jsr putchar

#---------------------------------------------------------------------
find:
# get the latest link
        lw lnk, LAST (usr)

# set token
        lw idx, TOIN (usr)
        lb fst, (idx)

# set space
        add trd, zero, 32

100:
# verify null, end of dictionary, then abort
# or maybe to verify numbers? 
        beq lnk, zero, abort

# linked list
        add wrd, lnk, zero

# update next link 
        lw lnk, 0 (wrd)

        add wrd, wrd, CELL

# first byte is (size and flag) 
# test length of word

        lb snd, (wrd)

# save it

        sb snd, STAT+1 (usr)

# mask it

        andi snd, snd, 0x7F

# compare it

        bne fst, snd, 100b

# size ok, compare chars

200:
        addi idx, idx, 1

        addi wrd, wrd, 1

        lb fst, 0 (idx)
        
        lb snd, 0 (wrd)

        beq fst, trd, 200f
        
        bne fst, snd, 100b
        
        j 200b

200:

        addi idx, idx, 1

eval:
# executing ? if == \0
        lb idx, STAT+0 (usr)
        beq idx, zero, execute

# immediate ? if != \0
        lb idx, STAT+1 (usr)
        bne idx, zero, immediate      

compile:

        #; lda #'C'
        #; jsr putchar

        call wcomma

        j resolve

immediate:
execute:

        #; lda #'E'
        #; jsr putchar

        la ipt, resolvept

        j pick

#---------------------------------------------------------------------
# 
try:
        lb fst, 0 (idx)

        beq fst, zero, getline
        
        addi idx, idx, 1
        
        ret

#---------------------------------------------------------------------
# absolute crude getline, continues until \n
getline:
# get the TIB 
  
        la idx, _tib
        
        sw idx, TOIN (usr)

# end-of-line is newline
        addi fth, zero, 10

# ever start with a space
        addi fst, zero, 32

# fill the TIB
100:
        sb fst, 0 (idx)
        
        addi idx, idx, 1

        call getchar

# 7-bit ascii only 
#        andi fst, 0x7F

# \n ends 
        bne fst, fth, 100b

# replace new-line with space 
100:        
        addi fst, zero, 32
        
        sw fst, 0 (idx)

# mark eol with \0

        addi idx, idx, 1
        
        sw zero, 0 (idx)

        # falltrought

#---------------------------------------------------------------------
# in place every token, no rewinds
# the counter is placed at space before word
# returns a c-str

# \0 as eol goto getline

token:

# last position on tib
        lw idx, TOIN (usr)

# set test to space
        addi fth, zero, 32

# skip spaces
100:
        call try
        bne fst, fth, 100f
        j 100b
100:

# update toin
        sw idx, TOIN (usr)

# scan spaces
200:
        call try
        beq fst, fth, 200f
        j 200b
200:

# update tout
        sw idx, TOUT (usr)

# lenght 

        lw fth, TOIN (usr)

        sub idx, idx, fth

# place the length before word, c-str

        addi fth, fth, -1

        sw idx, 0 (fth)

        sw fth, TOIN (usr)

        ret

#---------------------------------------------------------------------
#
# generics 
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  this code depends on systems or emulators
#
getchar:
        ret

putchar:
        ret

# exit for emulator  
byes:
        ret

#---------------------------------------------------------------------
#
# note : using load2 to short code size at cost of 1 cycle
#
load2:
        lw idx, SPT (usr)
        
        lw snd, 0 * CELL (idx)
        
        lw fst, 1 * CELL (idx)

        ret

#---------------------------------------------------------------------
wcomma:
        lw idx, HERE (usr)
      
        sw wrd, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HERE (usr)

        ret

#---------------------------------------------------------------------
tokencopy:
100:
        lb   idx, 0(fst)       # Load a byte from source into t0
        sb   idx, 0(snd)       # Store the byte from t0 to destination

        beq  idx, zero, 100f   # If byte is null (0), exit loop

        addi idx, zero, 32     # ascii space
        beq  idx, zero, 100f   # If byte is space (32), exit loop

        addi fst, fst, 1       # Increment destination address
        addi snd, snd, 1       # Increment source address
        jal  zero, 100b        # Jump back to the start of the loop

100:
        ret                     # Return from function

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
        
        call getchar

        j push1

#---------------------------------------------------------------------
# ( c -- ) 
def_word "emit", "emit", 0
        
        call load2

        call putchar

        j drop1

#---------------------------------------------------------------------
# ( a w -- ),  [a] = w
def_word "!", "store", 0
        
        call load2

        sw fst, 0 (snd)

drop2:
        add idx, idx, +1 * CELL
        
drop1:
        add idx, idx, +1 * CELL

        sw idx, SPT (usr)

        j next

#---------------------------------------------------------------------
# ( w1 w2 -- w), NOT(w1 AND w2)
def_word "nand", "nand", 0

        call load2
        
        and fst, fst, snd
        
        not fst, fst

save1:

        add idx, idx, +1 * CELL

        sw idx, SPT (usr)

        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w), w = w1+w2  
def_word "+", "plus", 0

        call load2

        add fst, fst, snd

        j save1

#---------------------------------------------------------------------
# ( a -- w ), w = [a]
def_word "@", "fetch", 0
fetchw:
        call load2
        
        lw fst, 0 (snd)
        
        j save0

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
        
        add fst, usr, zero 

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

        lw idx, HERE (usr)

        sw idx, ONCE (usr)

# stat is 'compile' == 1
        addi fst, zero, 1
        
        sw fst, STAT (usr)

# make header:
# copy last into (here)
        lw wrd, LAST (usr)
        
        call wcomma

# get following token
        call token
        
        lw fst, TOIN (usr)
        
        lw snd, HERE (usr)
        
        call tokencopy

# update here 
        sw snd, HERE (usr)

# done
        # jmp next
        j next 

#---------------------------------------------------------------------
def_word ";", "semis",  FLAG_IMM
# update last, panic if colon not lead elsewhere 
        lw idx, ONCE (usr)
        
        sw idx, LAST (usr)

# stat is 'interpret' == 0
        sw zero, STAT (usr)

# compound words must ends with exit
finish:
        la wrd, exit
        
        call wcomma

# done
        # jmp next
        j next 

#---------------------------------------------------------------------
# Thread Code Engine
#
#   ipt is IP, wrd is W
#
# for reference: 
#
#   nest aka enter or docol, 
#   unnest aka exit or semis;
#
# for milli-forth both stack index must be in memory
# but there is only indirect memory save, sw !
#
# then for sake must have:
#       usr, one register for point the user struct
#       idx, one register for stack index
#
#---------------------------------------------------------------------
# ( -- ) 
def_word "exit", "exit", 0
unnest: #; exit
# pull, ipt = (rpt), rpt += cell 
        lw idx, RPT (usr)
        lw ipt, 0 (idx)
        addi idx, idx, +1 * CELL
        sw idx, RPT (usr)

next:
# wrd = (ipt) #; ipt += cell
        lw wrd, 0 (ipt)
        addi ipt, ipt,  +1 * CELL

pick:
# compare address, if less than ends is a primitive 
        la idx, ends
        blt wrd, idx, jump

nest:   #; enter
# push, (rpt) = ipt, rp -= cell
        lw idx, RPT (usr)
        addi idx, idx, -1 * CELL
        sw ipt, 0 (idx)
        sw idx, RPT (usr)

# exchange 
        add ipt, wrd, zero
        j next

# jump to primitive
jump: 
        jalr zero, 0 (wrd)

#-----------------------------------------------------------------------
# BEWARE, MUST BE AT END! MINIMAL THREAD CODE DEPENDS ON IT!
ends:

#-----------------------------------------------------------------------
# anything above is not a primitive
#----------------------------------------------------------------------

.end

;----------------------------------------------------------------------
;
; Copyright (c) 2025, Alvaro Gomes Sobral Barcellos
; All rights reserved.
; 
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
; 
; 1. Redistributions of source code must retain the above copyright 
; notice, this list of conditions and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright
; notice, this list of conditions and the following disclaimer in 
; the documentation and/or other materials provided with the 
; distribution.
; 
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
; FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
; COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, 
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
; ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
; POSSIBILITY OF SUCH DAMAGE.
;
#----------------------------------------------------------------------
#   SectorForth and MilliForth was made for x86 arch 
#   and uses full 16-bit registers 
#
#   The way at 6502 is use page zero and lots of lda/sta.
#
#   The way of RiscV is use linear memory and 32-bit registers.
#
#   Focus in size not performance.
#
#   why ? For understand better my skills, riscv code and thread codes
#
#   how ? Programming a old Forth for new 32-bit cpu emulator
#
#   what ? Design the best minimal Forth engine and vocabulary
#
#----------------------------------------------------------------------
#   Changes:
#
#   all user structure, data (36 cells) and return (36 cells) stacks, 
#   TIB (80 bytes) and PIC (32 bytes) are in sequence; 
#
#   TIB and PIC grows forward, stacks grows backwards;
#
#   no overflow or underflow checks;
#
#   no numbers only words;
#
#   the header order is LINK, SIZE+FLAG, NAME+PAD.
#
#   only IMMEDIATE flag used as $80, no hide, no compile;
#
#   As ANSI Forth 1994: FALSE is 0x0000 #; TRUE is $FFFF ;
#
#----------------------------------------------------------------------
#   Remarks:
#
#         this code uses Minimal Thread Code, aka MTC.
#
#         uses cell with 32-bits. 
#
#         no TOS register, all values keeped at stacks;
#
#         TIB (terminal input buffer) is like a stream;
#
#         Chuck Moore uses 64 columns, be wise, obey rule 72 CPL; 
#
#         words must be between spaces, before and after;
#
#         no line wrap, do not break words between lines;
#
#         only 7-bit ASCII characters, plus \n, no controls;
#         ( later maybe \b oncespace and \u cancel )
#
#         words are case-sensitivy and less than 16 characters;
#
#         ? no need named-'pad' at end of even names;
#
#         ? no multiuser, no multitask, no checks, not faster;
#
#----------------------------------------------------------------------
#   For RiscV:
#
#         a 32-bit processor with 32-bit address space;
#
#         hardware stack not used for this Forth;
#
#----------------------------------------------------------------------
#   For stacks:
#
#   "when the heap moves forward, move the stack onceward" 
#
#----------------------------------------------------------------------
#   For Devs:
#
#   the hello_world.forth file states that stacks works
#         to allow : dup sp@ @ #; so sp must point to actual TOS.
#   
#   The movement will be:
#         pull is 'fetch and increase'
#         push is 'decrease and store'
#
#   Never mess with two underscore variables;
#
#   Not using smudge, 
#         colon saves "here" into "once" and 
#         semis loads "lastest" from "once";
#
#----------------------------------------------------------------------
#
#   Stacks represented as (standart)
#         S:(w1 w2 w3 -- u1 u2)  R:(w1 w2 w3 -- u1 u2)
#         before -- after, top at left.
#
#----------------------------------------------------------------------
