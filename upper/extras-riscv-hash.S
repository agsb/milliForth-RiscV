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
.equ hash_docode, 0x0059695B 
.equ hash_donext, 0x0059697A
.equ hash_bye, 0x0B874AFB
.equ hash_abort, 0x0A1DFF4F
.equ hash_splist, 0x005965D3
.equ hash_rplist, 0x005965D2
.equ hash_dump, 0x7C6B2FE9
.equ hash_words, 0x0B6953F8
.equ hash_see, 0x0B878F36
.equ hash_dot, 0x0002B58B
.equ hash_cell, 0x7C70B163

.equ  hash_BYE, 0x0B874AFB 
.equ  hash_ABORT, 0x0A1DFF4F 
.equ  hash_DUMP, 0x7C6B2FE9 
.equ  hash_WORDS, 0x0B6953F8 
.equ  hash_SEE, 0x0B878F36 
.equ  hash_CELL, 0x7C70B163 

#---------------------------------------------------------------------
# extra primitives

#---------------------------------------------------------------------
# ( w -- w/2 ) #; shift right
def_word "2/", "sfr", hash_sfr, into_extras

        call pull2
        
        srli fst, fst, 1
        
        j keep1

#---------------------------------------------------------------------
# ( -- ) execute a jump and link to a reference at IP
def_word ":$", "docode", hash_docode, h_sfr
        
        jalr ra, 0 (ipt)

        j next

#---------------------------------------------------------------------
# ( -- ) execute a jump to next
def_word ";$", "donext", hash_donext, h_docode
        
        j next

#---------------------------------------------------------------------
# ( -- ) exit forth
def_word "BYE", "byes", hash_bye, h_donext
        
        j _exit

#---------------------------------------------------------------------
# ( -- ) ae abort
def_word "ABORT", "aborts", hash_abort, h_byes
        
        j abort

#---------------------------------------------------------------------
# ( -- ) ae list of data stack
def_word "%S", "splist", hash_splist, h_aborts

        call stackS

        j next

#----------------------------------------------------------------------
# ( -- ) ae list of return stack
def_word "%R", "rplist", hash_rplist, h_splist

        call stackR
        
        j next

#----------------------------------------------------------------------
# ( a b -- a b ) dumps memory between a and b
def_word "DUMP", "dump", hash_dump, h_rplist

        call pull2
        
        # xxx 
        
        # init
        la fst, h_here

        # ends
        lw snd, HERE (usr)

        call dumps

        j drop1

#----------------------------------------------------------------------
# ( -- ) list all words in compiled dictionary, 
def_word "WORDS", "words", hash_words, h_dump

        call wordf

        j next

#----------------------------------------------------------------------
# ( -- ) list last word in dictionary, 
def_word "SEE", "sees", hash_see, h_words

        call wordu

        j next

#----------------------------------------------------------------------
# ( u -- u ) print tos in hexadecimal
def_word ".", "dot", hash_dot, h_sees

        call pull2

        call puthexy

        putchar ' '

        j next

#---------------------------------------------------------------------
# ( -- w ) size of a cell 
def_word "CELL", "cell", hash_cell, h_dot

        addi fst, zero, 4

        j push1

#---------------------------------------------------------------------

.set from_extras, h_cell

#---------------------------------------------------------------------
#
# Note: 
#       nested user calls must save ra, 
#       relies in pushra and pullra
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
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
        
        lw a5, LAST (usr)
        
        lw a6, HERE (usr)
        
        la s7, h_here

        putchar '\n'

100:
# verify end of compiled dictionary

        blt a5, zero, returns

        ble a5, s7, returns

        add s8, zero, a5

        call wordt

        add a6, zero, s8

        lw a5, 0 (a6)

        j 100b

#----------------------------------------------------------------------
# shows one word at dictionary
wordu:
        pushra 

        call saves

        lw a5, LAST (usr)

        lw a6, HERE (usr)

        call wordt

        j returns

#----------------------------------------------------------------------
# show entry in dictionary
wordt:

        pushra

# set the end-of-word as exit address

100:
        putchar '\n'
        
        mhex a5
        
        lw a4, 0 (a5)
        
        mhex a4
       
        addi a5, a5, CELL

        bne a5, a6, 100b

        putchar '\n'

        pullra

        ret

#----------------------------------------------------------------------
stackS:

        pushra 

        call saves

        putchar '\n'
        putchar 'S'

        lw a5, SPTR (usr)
        la a6, sp0

        call stackp

        j returns

#----------------------------------------------------------------------
stackR:

        pushra 

        call saves

        putchar '\n'
        putchar 'R'

        lw a5, RPTR (usr)
        la a6, rp0
        
        call stackp

        j returns

#----------------------------------------------------------------------
stackp:
        
        pushra

        putchar '='

        mhex a5

        mhex a6

        putchar '['

        beq a5, a6, 200f

100:
        lw a4, 0 (a5)
        
        mhex a4
        
        addi a5, a5, CELL
        
        blt a5, a6, 100b

200:
        putchar ' '
        putchar ']'

        pullra 

        ret

#----------------------------------------------------------------------
# 
dumps:
    
        pushra 

        call saves
        
        add a5, zero, a3
        
        add a6, zero, a4

100:
        addi t4, zero, 8
        
        putchar '\n'
        
        mhex a5

        putchar ':'
        
        putchar ' '

200:
        lw a4, 0 (a5)
        
        mhex a4
        
        addi a5, a5, 4
        
        addi t4, t4, -1
        
        beq t4, zero, 100b
        
        blt a5, a6, 200b

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
# code a ASCII $0-F(Z) hexadecimal in a value
#  
number:

        pushra

        call saves

        add wrd, zero, zero
        add lnk, zero, 8
100:
        lw fst, 0 (idx)
        beq fst, trd, 200f
        call digit
        slli wrd, wrd, 4
        or wrd, wrd, fst
        addi lnk, lnk, -1
        bne lnk, zero, 100b
200:
        j returns

digit:
        #; any valid digit, 0-9 and A-Z, do not care 
        addi fst, fst, -48
        blt fst, zero, 200f
        addi snd, zero, 'Z'
        bgt fst, snd, 200f
        addi snd, zero, 10
        blt fst, snd, 100f
        addi fst, fst, 7 
100:
# is_okey
        ret

200:
# is_error
        add fst, zero, zero
        ret

#---------------------------------------------------------------------
# code a 32-bit word in ASCII hexadecimal
#

puthexy:

        pushra

        add  s2, zero, a3
        
        addi s5, zero, 58

        addi a3, zero, ' '
        
        call _putc

        srli s3, s2, 24
        call 100f
        
        srli s3, s2, 16
        call 100f
        
        srli s3, s2, 8
        call 100f
        
        srli s3, s2, 0
        call 100f

        add  a3, zero, s2

        pullra

        ret

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


