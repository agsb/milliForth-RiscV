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

        not finished yet :)

*/

#----------------------------------------------------------------------
# I dunno about another way to make register name alias
# why ".equ name, register", does not work ?
# maybe reserved words can not be aliased ?
# also r0 must be called as zero.
##

# almost all memory access must be indirectd by a register
# and millifort uses a struct for pointers, then:
# reserve one register (usr) for the pointer to this structure
# and another (idx) to use as temporary index value
# 
# lw rd, offset (ro)
# sw ro, offset (rd)
#
# the indirect code defaults:
#
/*
# load the index of data stack
        lw idx, spt (usr)
# pull the value
        lw fst, 0 (idx)
# update the index
        addi idx, idx, +1 * CELL
# save the index
        sw idx, spt (usr)
*/

# forth struct pointer 
#define usr a0

# for stack index
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
# dont use data, it blows the file
# better
.section .bss
.p2align 2, 0x0

# user structure of internal Forth variables
# ATT: the order matters for forth !

# name some offsets

# state flag
.equ stat, 0 * CELL
# toin next free byte in TIB
.equ toin, 1 * CELL
# last link cell in heap dictionary linked list
.equ last, 2  * CELL
# next free cell in heap dictionary, aka dpt
.equ here, 3 * CELL
# data stack index
.equ spt, 4 * CELL
# return stack index
.equ rpt, 5 * CELL
# next token in TIB
.equ tout, 6 * CELL
# hold 'here while compile
.equ once, 7 * CELL
# heap forward
.equ head, 8 * CELL
# heap backward
.equ tail, 9 * CELL

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
        sw wrd, last (usr)

# next heap free cell  
        la wrd, ends
        sw wrd, here (usr)

#---------------------------------------------------------------------
# supose never change
reset:
        la wrd, tib
        sw wrd, toin (usr)
        sw wrd, tout (usr)

#---------------------------------------------------------------------
abort:
# reset data stack
        la wrd, sp0 
        sw wrd, spt (usr)

#---------------------------------------------------------------------
quit:
# reset return stack
        la wrd, rp0 
        sw wrd, rpt (usr)

# stat is 'interpret' == \0
        sw zero, stat (usr)

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
        lw snd, last (usr)
        
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
        sb trd, stat+1 (usr)

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
        lda tib, y
        beq getline    #; if \0 
        iny
        eor #' '
        rts

#---------------------------------------------------------------------
getline:
# drop rts of try
        pla
        pla

# leave the first
        ldy #0
@loop:  
# is valid
        sta tib, y  #; dummy store on first pass, overwritten
        iny
# would be better with 
# end of buffer ?
#       cpy #tib_end
#       beq @ends
# then 
        jsr getchar
# would be better with 
# 7-bit ascii only
#       and #$7F        
# unix \n
        cmp #10         
        bne @loop
# would be better with 
# no controls
#       cmp #' '
#       bmi @loop

# clear all if y eq \0
@ends:
# grace \b
        lda #32
        sta tib + 0 #; start with space
        sta tib, y  #; ends with space
# mark eol with \0
        lda #0
        sta tib + 1, y
# start it
        sta toin + 0

#---------------------------------------------------------------------
# in place every token,
# the counter is placed at last space before word
# no rewinds
token:
# last position on tib
        ldy toin + 0

@skip:
# skip spaces
        jsr try
        beq @skip

# keep y == start + 1
        dey
        sty tout + 0

@scan:
# scan spaces
        jsr try
        bne @scan

# keep y == stop + 1  
        dey
        sty toin + 0 

@done:
# sizeof
        tya
        sec
        sbc tout + 0

# keep it
        ldy tout + 0
        dey
        sta tib, y  #; store size for counted string 
        sty tout + 0

# setup token
        clc     #; clean 
        rts

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

#
#   lib6502 emulator
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# decrement a word in page zero. offset by X
decwx:
        lda 0, x
        bne @ends
        dec 1, x
@ends:
        dec 0, x
        rts

#---------------------------------------------------------------------
# increment a word in page zero. offset by X
#incwx:
#       inc 0, x
#       bne @ends
#       inc 1, x
#@ends:
#       rts

#---------------------------------------------------------------------
# classic heap moves always forward
#
stawrd:
        sta wrd + 1

wcomma:
        ldy #(wrd)

comma: 
        ldx #(here)
        #; fall throught

#---------------------------------------------------------------------
# from a page zero address indexed by Y
# into a page zero indirect address indexed by X
copyinto:
        lda 0, y
        sta (0, x)
        jsr incwx
        lda 1, y
        sta (0, x)
        jmp incwx

#---------------------------------------------------------------------
#
# generics 
#
#---------------------------------------------------------------------
spush1:
        ldy #(fst)

#---------------------------------------------------------------------
# push a cell 
# from a page zero address indexed by Y
# into a page zero indirect address indexed by X
spush:
        ldx #(spt)
        #; jmp push
        .byte $2c   #; mask next two bytes, nice trick !

rpush:
        ldx #(rpt)

#---------------------------------------------------------------------
# classic stack oncewards
push:
        jsr decwx
        lda 1, y
        sta (0, x)
        jsr decwx
        lda 0, y
        sta (0, x)
        rts  

#---------------------------------------------------------------------
spull2:
        ldy #(snd)
        jsr spull
        #; fall through

#---------------------------------------------------------------------
spull1:
        ldy #(fst)
        #; fall through

#---------------------------------------------------------------------
# pull a cell 
# from a page zero indirect address indexed by X
# into a page zero address indexed by y
spull:
        ldx #(spt)
        #; jmp pull
        .byte $2c   #; mask next two bytes, nice trick !

rpull:
        ldx #(rpt)

#---------------------------------------------------------------------
# classic stack oncewards
pull:   #; fall through, same as copyfrom

#---------------------------------------------------------------------
# from a page zero indirect address indexed by X
# into a page zero address indexed by y
copyfrom:
        lda (0, x)
        sta 0, y
        jsr incwx
        lda (0, x)
        sta 1, y
        #; jmp incwx ; fall through

#---------------------------------------------------------------------
# increment a word in page zero. offset by X
incwx:
        lda #01
#---------------------------------------------------------------------
# add a byte to a word in page zero. offset by X
addwx:
        clc
        adc 0, x
        sta 0, x
        bcc @ends
        inc 1, x
        clc #; keep carry clean
@ends:
        rts

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
#----------------------------------------------------------------------

#---------------------------------------------------------------------
# ( -- u ) #; tos + 1 unchanged
def_word "key", "key", 0
        jalr getchar

        lw idx, spt (usr)

        bne this    #; always taken
        
#---------------------------------------------------------------------
# ( u -- ) #; tos + 1 unchanged
def_word "emit", "emit", 0
        jalr spull1
        lda fst + 0
        jsr putchar
        #; jmp next  ; uncomment if carry could be set
        bcc jmpnext #; always taken


#---------------------------------------------------------------------
# 
drop2:
        add idx, idx, +1 * CELL

drop1:
        add idx, idx, +1 * CELL
        
        sw idx, spt (usr)

        beq zero, zero, next

load2:
        lw idx, spt (usr)
        
        lw fst, 0 * CELL (idx)
        
        lw snd, 1 * CELL (idx)

        ret

save1:
        sw fst, 1 * CELL (idx)

        addi idx, idx, -1 * CELL

        beq zero, zero, drop1

save0:

        sw fst, 0 * CELL (idx)

        beq zero, zero, next

#---------------------------------------------------------------------
# ( a w -- ) #; [a] = w
def_word "!", "store", 0
        
        call load2

        sw snd, 0 (fst)

        j drop2


#---------------------------------------------------------------------
# ( w1 w2 -- NOT(w1 AND w2) )
def_word "nand", "nand", 0

        call load2

        and snd, snd, fst
        
        not snd, snd

        j drop1

#---------------------------------------------------------------------
# ( w1 w2 -- w1+w2 ) 
def_word "+", "plus", 0

        call load2

        add snd, snd, fst

        beq zero, zero, save1

#---------------------------------------------------------------------
# ( a -- w ) #; w = [a]
def_word "@", "fetch", 0
fetchw:
        call load2

        add snd, fst, zero

        lw fst, 0 (snd)
        
        beq zero, zero, save0

#---------------------------------------------------------------------
# ( 0 -- 0x0000) | ( n -- $FFFF) not zero at top ?
def_word "0#", "zeroq", 0

        call load2

        beq fst, zero, istrue
        
istrue:

        not fst, fst

isfalse:

        beq zero, zero, save0

#---------------------------------------------------------------------
# ( -- state ) a variable return an reference
def_word "s@", "state", 0 
        lw idx, spt (usr)
        
        addi idx, idx, -1 * CELL
        
        addi fst, stat, zero 
        
        sw fst, 0 (idx)

        sw idx, spt (usr)

        beq zero, zero, save0

#---------------------------------------------------------------------
def_word ";", "semis",  FLAG_IMM
# update last, panic if colon not lead elsewhere 
        lw fst, once (usr)
        sw fst, last (usr)

# stat is 'interpret' == 0
        sw zero, stat (usr)

# compound words must ends with exit
finish:
        la fst, exit
        call wcomma

# done
        # jmp next
        beq zero, zero, next 

#---------------------------------------------------------------------
def_word ":", "colon", 0
# save here, panic if semis not follow elsewhere
        lw fst, here (usr)
        sw fst, once (usr)

# stat is 'compile' == 1
        addi fst, zero, 1
        sw fst, stat (usr)

@header:
# copy last into (here)
        ldy #(last)
        jsr comma

# get following token
        jsr token

# copy it
        ldy #0
@loop:       
        lda (tout), y
        cmp #32    #; stops at space
        beq @ends
        sta (here), y
        iny
        bne @loop

@ends:
# update here 
        tya
        ldx #(here)
        jsr addwx

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
        lw idx, rpt (usr)
        lw ipt, 0 (idx)
        addi idx, idx, +1 * CELL
        sw idx, rpt (usr)

next:
# wrd = (ipt) #; ipt += cell
        lw wrd, 0 (ipt)
        addi ipt, ipt + 1 * CELL

pick:
# compare address, if less than ends is a primitive 
        blt wrd, ends, jump

nest:   #; enter
# push, (rpt) = ipt, rp -= cell
        lw idx, rpt (usr)
        sw ipt, 0 (idx)
        addi idx, idx, -1 * CELL
        sw idx, rpt (usr)

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
