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

        extra words and routines for milliforth-riscv

*/

#---------------------------------------------------------------------
#
# djb2 hash cleared of bit 31
#
.equ hash_sfr, 0x00596858
.equ hash_exec, 0x7C6BC01E
.equ hash_docode, 0x0059695B 
.equ hash_donext, 0x0059697A
.equ hash_bye, 0x0B874AFB
.equ hash_abort, 0x0A1DFF4F
.equ hash_splist, 0x005966B8
.equ hash_rplist, 0x005966B9
.equ hash_dump, 0x7C6B2FE9
.equ hash_words, 0x0B6953F8
.equ hash_see, 0x0B878F36
.equ hash_dot, 0x0002B58B

.equ hash_cell,     0x7C70B163
.equ hash_cellplus, 0x0A86DDE8
.equ hash_cellless, 0x0A86DDEE

.macro mhex rg
        add a3, zero, \rg
        call puthex
        putchar ' '
.endm

.macro mhit it
        putchar '\n'
        putchar \it
        putchar ' '
.endm

#---------------------------------------------------------------------
# extras links to last primitive

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", into_extras, hash_sfr

        call pull2
        
        srli fst, snd, 1
        
        j keep1

#---------------------------------------------------------------------
# ( a -- ) execute a word address at top of data stack
# not change the data stack
def_word "exec", "exec", h_sfr, hash_exec
        
        call pull2
        
        add wrd, zero, fst

        j pick

#---------------------------------------------------------------------
# ( -- ) execute a jump to a reference at IP
def_word ":$", "docode", h_exec, hash_docode
        
        jalr zero, 0 (ipt)

#---------------------------------------------------------------------
# ( -- ) execute a jump to next
def_word ";$", "donext", h_docode, hash_donext
        
        j next

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "bye", "byes", h_donext, hash_bye
        
        j _exit

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "abort", "aborts", h_byes, hash_abort
        
        j abort

#---------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word ".S", "splist", h_aborts, hash_splist

        call stackS

        j next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word ".R", "rplist", h_splist, hash_rplist

        call stackR
        
        j next

#----------------------------------------------------------------------
# ( a b -- a b ) dumps memory between a and b
def_word "dump", "dump", h_rplist, hash_dump

        call pull2
        
        call dumps

        j drop1

#----------------------------------------------------------------------
# ( -- ) list all words in compiled dictionary, 
def_word "words", "words", h_dump, hash_words

        call wordf

        j next

#----------------------------------------------------------------------
# ( -- ) list last word in dictionary, 
def_word "see", "sees", h_words, hash_see

        call wordu

        j next

#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal
def_word ".", "dot", h_sees, hash_dot

        call pull2

        call puthex

        putchar ' '

        j next


#---------------------------------------------------------------------
# ( -- w ) size of a cell 
def_word "cell", "cell", h_dot, hash_cell

        addi fst, zero, 4

        j push1

#---------------------------------------------------------------------

.set from_extras, h_cell

#---------------------------------------------------------------------
#
# Note: 
#       nested user calls must save ra, relies in pushra and pullra
#       these routines uses Sn registers
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal 
#
puthex:

        pushra

        call saves

        add  s2, zero, a3
        
        addi s5, zero, 58

        srli s3, s2, 24
        call 100f
        srli s3, s2, 16
        call 100f
        srli s3, s2, 8
        call 100f
        srli s3, s2, 0
        call 100f

        add  a3, zero, s2

        j loads

100:

        pushra 

        andi s3, s3, 0xFF
        
        srli s4, s3, 4
        call 200f
        
        srli s4, s3, 0
        call 200f

        pullra

        ret

200:
        pushra

        andi s4, s4, 0x0F
        ori  s4, s4, 48
        blt  s4, s5, 300f
        addi s4, s4, 7
300:
        add a3, zero, s4

        call _putc
        
        pullra

        ret

#----------------------------------------------------------------------
saves:
        addi sp, sp, -32

        sw a0,  0 (sp) 
        sw a1,  4 (sp) 
        sw a2,  8 (sp) 
        sw a3, 12 (sp) 
        sw a4, 16 (sp) 
        sw a5, 20 (sp) 
        sw a6, 24 (sp) 
        sw a7, 28 (sp) 
       
        ret

#----------------------------------------------------------------------
loads:
        lw a0,  0 (sp) 
        lw a1,  4 (sp) 
        lw a2,  8 (sp) 
        lw a3, 12 (sp) 
        lw a4, 16 (sp) 
        lw a5, 20 (sp) 
        lw a6, 24 (sp) 
        lw a7, 28 (sp) 
        
        addi sp, sp, +32
       
        ret

returns:

        call loads

        pullra 

        ret

#----------------------------------------------------------------------
# shows all words at dictionary
wordf:
        pushra 

        call saves

# get the latest link
        
        lw a6, LAST (usr)
        
        putchar '\n'

100:
# verify end of dictionary
        
        beq a6, zero, returns

        add a5, zero, a6

        lw a6, 0 (a5)

        call wordt

        la t0, h_here

        blt a6, t0, returns

        j 100b

#----------------------------------------------------------------------
# shows one word at dictionary
wordu:
        pushra 

        call saves

        lw a5, LAST (usr)

        call wordt

        j returns

#----------------------------------------------------------------------
# show entry in dictionary
wordt:

        pushra

# set the end-of-word as exit address

        la t0, exit

        putchar '\n'
        putchar '#'

#        addi a5, a5, 8

100:
        putchar '\n'
        
        mhex a5
        
        lw a4, 0 (a5)
        
        mhex a4
       
        addi a5, a5, 4

        bne a4, t0, 100b

        pullra

        ret

#----------------------------------------------------------------------
stackS:

        pushra 

        call saves

        putchar '\n'
        putchar 'S'

        lw a6, SPTR (usr)
        la a5, sp0

        call stackp

        j returns

#----------------------------------------------------------------------
stackR:

        pushra 

        call saves

        putchar '\n'
        putchar 'R'

        lw a6, RPTR (usr)
        la a5, rp0

        call stackp

        j returns

#----------------------------------------------------------------------
stackp:
        
        pushra

        putchar '='

        mhex a5

        putchar '['
        putchar ' '

        beq a5, a6, 200f

100:
        addi a5, a5, -4
        lw a4, 0 (a5)
        mhex a4
        bne a5, a6, 100b

200:
        putchar ']'

        pullra 

        ret

#----------------------------------------------------------------------
# 
dumps:
    
        pushra 

        call saves

        # last
        add a5, zero, a3

        mhex a5

        # init
        add a6, zero, a4

        mhex a6

        # many
        sub a5, a5, a6

        mhex a5

        putchar '\n'

100:
        addi t0, zero, 8
        putchar '\n'
        mhex a6
        putchar ':'
        putchar ' '
200:
        lw a4, 0 (a6)
        mhex a4
        addi a6, a6, 4
        addi a5, a5, -4
        
        addi t0, t0, -1
        beq t0, zero, 100b
        bne a5, zero, 200b

        j returns

#----------------------------------------------------------------------
# 
shows:
        pushra 

        call saves

# registers

       putchar '\n'
        putchar 'R'
        putchar ' '
        
       putchar '0'
        putchar ' '
        mhex t0
       putchar '1'
        putchar ' '
        mhex t1
       putchar '2'
        putchar ' '
        mhex t2
       putchar '3'
        putchar ' '
        mhex t3
       putchar '4'
        putchar ' '
        mhex t4
       putchar '5'
        putchar ' '
        mhex t5
       putchar '6'
        putchar ' '
        mhex t6
        
# user parameters

        putchar '\n'
        putchar 'U'
        putchar ' '
        
       putchar 'S'
        putchar ' '
        lw fst, STAT (usr)
        mhex fst
       
       putchar 'L'
        putchar ' '
        lw fst, LAST (usr)
        mhex fst
       
       putchar 'H'
        putchar ' '
        lw fst, HERE (usr)
        mhex fst
       
       putchar 'D'
        putchar ' '
        lw fst, HEAD (usr)
        mhex fst
       
       putchar 'S'
        putchar 'P'
        putchar ' '
        lw fst, SPTR (usr)
        mhex fst

       putchar 'R'
        putchar 'P'
        putchar ' '
        lw fst, RPTR (usr)
        mhex fst
       
        j returns

#----------------------------------------------------------------------
.ifdef NOTYET

#----------------------------------------------------------------------
# code a ASCII $FFFF hexadecimal in a byte
#  
number:

        ldy #0

        jsr @very
        asl
        asl
        asl
        asl
        sta fst + 1

        iny 
        jsr @very
        ora fst + 1
        sta fst + 1
        
        iny 
        jsr @very
        asl
        asl
        asl
        asl
        sta fst + 0

        iny 
        jsr @very
        ora fst + 0
        sta fst + 0

        clc #; clean
        rts

@very:
        lda (tout), y
        sec
        sbc #$30
        bmi @erro
        cmp #10
        bcc @ends
        sbc #0x07
        #; any valid digit, A-Z, do not care 
@ends:
        rts

@erro:
        pla
        pla
        rts

.endif


