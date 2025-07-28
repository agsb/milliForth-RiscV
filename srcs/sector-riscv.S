/*
;---------------------------------------------------------------------
;
; Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#----------------------------------------------------------------------
#
#   A MilliForth for RISCV 
#
#   original for the RISCV, by Alvaro G. S. Barcellos, 2025
#
#   https://github.com/agsb 

#   see the disclaimer file in this repository.
#
#   More info at end of this file.
#
#----------------------------------------------------------------------
#
# Stuff for compiler
#

# .attribute arch, rv64imafdc

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
.equ FLAG_IMM, 1 << (CELL * 8)

# Terminal input buffer 80 bytes, (but 72 is enough), moves forwards
.equ tibz, 80

# reserves 32 bytes for pad scratch, moves forwards
.equ padz, 32

# data stack, 36 cells, moves backwards, push decreases before copy
.equ spz, 36 

# return stack, 36 cells, moves backwards, push decreases before copy
.equ rpz, 36 

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

 I dunno about another way to make register name alias
 why ".equ name, register", does not work ?
 maybe reserved words can not be aliased ?
 also r0 must be called as zero.


 almost all memory access must be indirectd by a register
 and millifort uses a struct for pointers, then:
 reserve one register (usr) for the pointer to this structure
 and another (idx) to use as temporary index value
 
 lw rd, offset (ro)
 sw ro, offset (rd)

 the indirect code defaults:

# load the index of data stack
        lw idx, spt (usr)
# pull the value
        lw fst, 0 (idx)
# update the index
        addi idx, idx, +1 * CELL
# save the index
        sw idx, spt (usr)
*/

# for pre-processor CPP (GNU GCC)

# forth struct pointer, indirect constant
#define usr a0

# for stack index, indirect variable
#define idx a1

# instruction pointer
#define ipt a2

# word pointer
#define wrd a3

# some auxiliars
#define fst a4
#define snd a5
#define trd a6
#define fth a7

#----------------------------------------------------------------------
# dont use data, it blows the file
#.section .data

#----------------------------------------------------------------------
# better
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
tib:       
.skip tibz

# pad grows forward
pad:       
.skip padz

# stacks grows backward

spb:       # bottom 
.skip spz
sp0:       .word

rpb:       # bottom
.skip rpz
rp0:       .word

#----------------------------------------------------------------------
.text 
.p2align 2, 0x0

       j main

# catch for macros
1: .word 0x0

#----------------------------------------------------------------------
main:

# disable interrupts, sei

# do something about a0 and a1

# save

# enable interrupts, cli

#----------------------------------------------------------------------
# do what need once
cold:

# load user pointer address
    
        la usr, _user

#----------------------------------------------------------------------
warm:
# link list of headers
        la wrd, h_exit
        sw wrd, LAST (usr)

# next heap free cell  
        la wrd, ends
        sw wrd, HERE (usr)

#---------------------------------------------------------------------
# supose never change
reset:
        la wrd, tib
        sw wrd, TOIN (usr)
        sw wrd, TOUT (usr)

#---------------------------------------------------------------------
abort:
# reset data stack
        la wrd, sp0 
        sw wrd, SPT (usr)

#---------------------------------------------------------------------
quit:
# reset return stack
        la wrd, rp0 
        sw wrd, RPT (usr)

# stat is 'interpret' == \0
        sw zero, STAT (usr)

        j okey

#---------------------------------------------------------------------
# the outer loop

resolvept:
        .word okey

#---------------------------------------------------------------------
okey:

#;   uncomment for feedonce
#       lda stat + 0
#       bne resolve
#       lda #'O'
#       jsr putchar
#       lda #'K'
#       jsr putchar
#       lda #10
#       jsr putchar

#---------------------------------------------------------------------
resolve:
# get a token
        jal token

        #; lda #'P'
        #; jsr putchar

#---------------------------------------------------------------------
find:
        lw snd, LAST (usr)
        
loop%=:
# verify null, end of dictionary, abort
        beq snd, zero, abort

# linked list
        add wrd, snd, zero

#   maybe to place a code for number? 

# uncomment for feedback, comment out "beq abort" above
# end of dictionary, no more words to search, abort
#       lda #'?'
#       jsr putchar
#       lda #'?'
#       jsr putchar
#       lda #10
#       jsr putchar
#       jmp abort  

each%=:       

# update next link 
        add snd, wrd, zero

# compare words
        ldy #0

# save the flag, first byte is (size and flag) 
        lb trd, (wrd)
        # zzzz
        sb trd, STAT+1 (usr)


# zzzz

# compare chars
equal%=:
        lda (tout), y
# space ends
        beq t1, ' ', done%=  

# verify 
        sbc (wrd), y     

# clean 7-bit ascii
        asl        
        bne @loop

# next char
        iny
        bne @equal

@done:
# update wrd
        tya
        ;; ldx #(wrd) #; set already
        ;; addwx also clear carry
        jsr addwx
        
eval:
# executing ? if == \0
        lda stat + 0   
        beq execute

# immediate ? if < \0
        lda stat + 1   
        bmi immediate      

compile:

        #; lda #'C'
        #; jsr putchar

        jsr wcomma

        bcc resolve

immediate:
execute:

        #; lda #'E'
        #; jsr putchar

        lda #>resolvept
        sta ipt + 1
        lda #<resolvept
        sta ipt + 0

#---------------------------------------------------------------------
try:
        lb wrd, 0 (idx)

        beq wrd, zero, getline
        
        addi idx, idx, 1
        
        ret

#---------------------------------------------------------------------
# none edit 
#
getline:
# get the terminal input buffer
        la idx, tib
        
        sw idx, TOIN (usr)

# end-of-line is newline
        addi fth, zero, 10

# ever start with a space
        addi wrd, zero, 32

100:
        sw wrd, 0 (idx)
        
        addi idx, idx, 1

110:
        call getchar

# \n ends 
        beq wrd, fth, 100f

# 7-bit ascii only ?
#        andi wrd, 0x7F

# no controls ?
#        addi fth, zero, 32
#        blt wrd, fth, 110b

        j 100b

# grace a space
        
        addi wrd, wrd, 32
        
        sw wrd, 0 (idx)

# mark eol with \0
        addi idx, idx, 1
        
        sw zero, 0 (idx)

#---------------------------------------------------------------------
# in place every token, no rewinds
# the counter is placed at space before word
# returns a c-str

# \0 as eol then goto getline

token:

# set space
        addi, fth, zero, 32

# last position on tib
        lw idx, TOIN (usr)

# skip spaces
100:
        call try
        bne wrd, fth, 100f
        j 100b

#update toin
100:
        sw idx, TOIN (usr)

# scan spaces
200:
        call try
        beq wrd, fth, 200f
        j 200b

# update tout
200:
        sw idx, TOUT (usr)

# sizeof

        lw wrd, TOIN (usr)

        sub idx, idx, wrd

        subi wrd, wrd, 1

        sw idx, 0 (wrd)

        sw wrd, TOIN (src)

        ret

#---------------------------------------------------------------------
#  this code depends on systems or emulators
#
#  lib6502  emulator
# 
getchar:
        lda $E000

eofs:
# EOF ?
        cmp #$FF #; also clean carry :)
        beq byes

putchar:
        sta $E000
        rts

# exit for emulator  
byes:
        jmp 0x0000

#---------------------------------------------------------------------
#
# generics 
#
#---------------------------------------------------------------------

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
# the primitives, 
# 
#---------------------------------------------------------------------

#
# note : using load2 to short code size at cost of 1 cycle
#
load2:
        lw idx, SPT (usr)
        
        lw snd, 0 * CELL (idx)
        
        lw fst, 1 * CELL (idx)

        ret

wcomma:
        lw idx, HERE (usr)
      
        sw wrd, 0 (idx)
      
        addi idx, idx, CELL
      
        sw idx, HERE (usr)

        ret

tokencopy:
    # fst = source address
    # snd = destination address

        
100:
        lb   idx, 0(fst)       # Load a byte from source into t0
        sb   idx, 0(snd)       # Store the byte from t0 to destination

        beq  idx, zero, 100f   # If byte is null (0), exit loop
# zzzz
        addi idx, zero, 32     # ascii space
        beq  idx, zero, 100f   # If byte is space (32), exit loop

        addi fst, fst, 1       # Increment destination address
        addi snd, snd, 1       # Increment source address
        jal  zero, 100b        # Jump back to the start of the loop

100:
        ret                     # Return from function

#----------------------------------------------------------------------

#---------------------------------------------------------------------
# ( -- u ) #; tos + 1 unchanged
def_word "key", "key", 0
        
        jalr getchar

        j push1

#---------------------------------------------------------------------
# ( u -- ) #; tos + 1 unchanged
def_word "emit", "emit", 0
        
        call load2

        jalr putchar

        j drop1

#---------------------------------------------------------------------
# ( a w -- ) #; [a] = w
def_word "!", "store", 0
        
        call load2

        sw fst, 0 (snd)

drop2:
        add idx, idx, +1 * CELL
        
drop1:
        add idx, idx, +1 * CELL

        sw idx, SPT (usr)

        beq zero, zero, next

#---------------------------------------------------------------------
# ( w1 w2 -- NOT(w1 AND w2) )
def_word "nand", "nand", 0

        call load2
        
        and fst, fst, snd
        
        not fst, fst

save1:

        add idx, idx, +1 * CELL

        sw idx, SPT (usr)

        j save0

#---------------------------------------------------------------------
# ( w1 w2 -- w1+w2 ) 
def_word "+", "plus", 0

        call load2

        add fst, fst, snd

        j save1

#---------------------------------------------------------------------
# ( a -- w ) #; w = [a]
def_word "@", "fetch", 0
fetchw:
        call load2
        
        lw fst, 0 (snd)
        
        j save0

#---------------------------------------------------------------------
# ( 0 -- FALSE) | ( n -- TRUE) not zero at top ?
def_word "0#", "zeroq", 0

        call load2

isfalse:

        beq snd, zero, next
        
istrue:

        lwi fst, TRUE

        j save0

#---------------------------------------------------------------------
# ( -- state ) a variable return an reference
def_word "s@", "state", 0 
        
        add fst, usr, zero 

push1:
        lw idx, SPT (usr)
        
        addi idx, idx, -1 * CELL
        
        sw idx, SPT (usr)
        
save0:
        sw fst, 0 (idx)

        beq zero, zero, next

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
        beq zero, zero, next 

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
        beq zero, zero, next 

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
        beq zero, zero, next

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
